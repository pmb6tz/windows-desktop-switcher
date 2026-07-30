#Requires AutoHotkey v1.1.33+
#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#KeyHistory 0 ; Ensures user privacy when debugging is not needed
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability

; Globals
DesktopCount := 2        ; Windows starts with 2 desktops at boot
CurrentDesktop := 1      ; Desktop count is 1-indexed (Microsoft numbers them this way)
LastOpenedDesktop := 1

; DLL
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", A_ScriptDir . "\VirtualDesktopAccessor.dll", "Ptr")
global IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
global hDesktopFocusBridge := DllCall("LoadLibrary", "Str", A_ScriptDir . "\DesktopFocusBridge.dll", "Ptr")
global PrepareWindowFocusProc := DllCall("GetProcAddress", Ptr, hDesktopFocusBridge, AStr, "PrepareWindowFocus", "Ptr")
global CommitWindowFocusProc := DllCall("GetProcAddress", Ptr, hDesktopFocusBridge, AStr, "CommitWindowFocus", "Ptr")
global CancelWindowFocusProc := DllCall("GetProcAddress", Ptr, hDesktopFocusBridge, AStr, "CancelWindowFocus", "Ptr")
global FocusBridgeAvailable := hDesktopFocusBridge && PrepareWindowFocusProc && CommitWindowFocusProc && CancelWindowFocusProc
global ActiveWindowByDesktop := {}
global ActiveWindowPidByDesktop := {}

; Main
SetKeyDelay, 75
mapDesktopsFromRegistry()
OutputDebug, [loading] desktops: %DesktopCount% current: %CurrentDesktop%

#Include %A_ScriptDir%\user_config.ahk
return

;
; This function examines the registry to build an accurate list of the current virtual desktops and which one we're currently on.
; List of desktops appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops
; On Windows 11 the current desktop UUID appears to be in the same location
; On previous versions in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops
;
mapDesktopsFromRegistry()
{
    global CurrentDesktop, DesktopCount

    ; Get the current desktop UUID. Length should be 32 always, but there's no guarantee this couldn't change in a later Windows release so we check.
    IdLength := 32
    SessionId := getSessionId()
    if (SessionId) {
        RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, CurrentVirtualDesktop
        if ErrorLevel {
            RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
        }
        
        if (CurrentDesktopId) {
            IdLength := StrLen(CurrentDesktopId)
        }
    }

    ; Get a list of the UUIDs for all virtual desktops on the system
    RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    if (DesktopList) {
        DesktopListLength := StrLen(DesktopList)
        ; Figure out how many virtual desktops there are
        DesktopCount := floor(DesktopListLength / IdLength)
    }
    else {
        DesktopCount := 1
    }

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
    i := 0
    while (CurrentDesktopId and i < DesktopCount) {
        StartPos := (i * IdLength) + 1
        DesktopIter := SubStr(DesktopList, StartPos, IdLength)
        OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.

        ; Break out if we find a match in the list. If we didn't find anything, keep the
        ; old guess and pray we're still correct :-D.
        if (DesktopIter = CurrentDesktopId) {
            CurrentDesktop := i + 1
            OutputDebug, Current desktop number is %CurrentDesktop% with an ID of %DesktopIter%.
            break
        }
        i++
    }
}

;
; This functions finds out ID of current session.
;
getSessionId()
{
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
    if ErrorLevel {
        OutputDebug, Error getting current process id: %ErrorLevel%
        return
    }
    OutputDebug, Current Process Id: %ProcessId%

    DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
    if ErrorLevel {
        OutputDebug, Error getting session id: %ErrorLevel%
        return
    }
    OutputDebug, Current Session Id: %SessionId%
    return SessionId
}

_switchDesktopToTarget(targetDesktop)
{
    ; Globals variables should have been updated via updateGlobalVariables() prior to entering this function
    global CurrentDesktop, DesktopCount, LastOpenedDesktop, FocusBridgeAvailable
    global GoToDesktopNumberProc, PrepareWindowFocusProc, CommitWindowFocusProc, CancelWindowFocusProc

    ; Don't attempt to switch to an invalid desktop
    if (targetDesktop > DesktopCount || targetDesktop < 1 || targetDesktop == CurrentDesktop) {
        OutputDebug, [invalid] target: %targetDesktop% current: %CurrentDesktop%
        return
    }

    LastOpenedDesktop := CurrentDesktop

    currentWindowId := DllCall("GetForegroundWindow", "Ptr")
    rememberDesktopWindow(CurrentDesktop, currentWindowId)

    targetWindowId := getDesktopFocusWindow(targetDesktop)
    if (targetWindowId && !raiseWindowWithoutActivation(targetWindowId)) {
        forgetDesktopWindow(targetDesktop)
        targetWindowId := 0
    }

    focusPrepared := false
    if (FocusBridgeAvailable && targetWindowId) {
        prepareResult := DllCall(PrepareWindowFocusProc, "Ptr", targetWindowId, "Int")
        focusPrepared := prepareResult >= 0
        if (!focusPrepared) {
            OutputDebug, [focus] prepare failed: %prepareResult%
        }
    }

    ; Preserve the previous behavior only when the native focus handoff cannot
    ; be prepared (for example, on an unsupported Windows build).
    if (!focusPrepared) {
        taskbarHwnd := DllCall("FindWindow", "Str", "Shell_TrayWnd", "Ptr", 0, "UPtr")
        if (taskbarHwnd) {
            DllCall("SetForegroundWindow", "UPtr", taskbarHwnd)
        }
    }

    switchResult := DllCall(GoToDesktopNumberProc, "Int", targetDesktop - 1, "Int")
    if (switchResult != 1) {
        if (focusPrepared) {
            DllCall(CancelWindowFocusProc)
        }
        OutputDebug, [switch] failed: %switchResult%
        return
    }

    if (focusPrepared) {
        commitResult := DllCall(CommitWindowFocusProc, "Int")
        if (commitResult < 0) {
            OutputDebug, [focus] commit failed: %commitResult%
        }
    }
    else {
        focusTheForemostWindow(targetDesktop)
    }
}

updateGlobalVariables()
{
    ; Re-generate the list of desktops and where we fit in that. We do this because
    ; the user may have switched desktops via some other means than the script.
    mapDesktopsFromRegistry()
}

switchDesktopByNumber(targetDesktop)
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    _switchDesktopToTarget(targetDesktop)
}

switchDesktopToLastOpened()
{
    global CurrentDesktop, DesktopCount, LastOpenedDesktop
    updateGlobalVariables()
    _switchDesktopToTarget(LastOpenedDesktop)
}

switchDesktopToRight()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    _switchDesktopToTarget(CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1)
}

switchDesktopToLeft()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    _switchDesktopToTarget(CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1)
}

focusTheForemostWindow(targetDesktop) {
    foremostWindowId := getForemostWindowIdOnDesktop(targetDesktop)
    if isWindowNonMinimized(foremostWindowId) {
        DllCall("SetForegroundWindow", "UPtr", foremostWindowId)
    }
}

isWindowNonMinimized(windowId) {
    WinGet MMX, MinMax, ahk_id %windowId%
    return MMX != -1
}

getForemostWindowIdOnDesktop(n)
{
    ; winIDList contains a list of windows IDs ordered from the top to the bottom for each desktop.
    WinGet winIDList, list
    Loop % winIDList {
        windowID := % winIDList%A_Index%
        if (isDesktopApplicationWindow(windowID, n)) {
            return windowID
        }
    }
}

rememberDesktopWindow(desktopNumber, windowId)
{
    global ActiveWindowByDesktop, ActiveWindowPidByDesktop

    if (!isDesktopApplicationWindow(windowId, desktopNumber)) {
        return false
    }

    WinGet, processId, PID, ahk_id %windowId%
    if (!processId) {
        return false
    }

    ActiveWindowByDesktop[desktopNumber] := windowId
    ActiveWindowPidByDesktop[desktopNumber] := processId
    return true
}

forgetDesktopWindow(desktopNumber)
{
    global ActiveWindowByDesktop, ActiveWindowPidByDesktop
    ActiveWindowByDesktop.Delete(desktopNumber)
    ActiveWindowPidByDesktop.Delete(desktopNumber)
}

getDesktopFocusWindow(desktopNumber)
{
    global ActiveWindowByDesktop, ActiveWindowPidByDesktop

    if (ActiveWindowByDesktop.HasKey(desktopNumber)) {
        windowId := ActiveWindowByDesktop[desktopNumber]
        WinGet, processId, PID, ahk_id %windowId%
        if (processId == ActiveWindowPidByDesktop[desktopNumber]
                && isDesktopApplicationWindow(windowId, desktopNumber)) {
            return windowId
        }
        forgetDesktopWindow(desktopNumber)
    }

    windowId := getForemostWindowIdOnDesktop(desktopNumber)
    if (windowId) {
        rememberDesktopWindow(desktopNumber, windowId)
    }
    return windowId
}

isDesktopApplicationWindow(windowId, desktopNumber)
{
    global IsWindowOnDesktopNumberProc

    if (!windowId || !DllCall("IsWindow", "Ptr", windowId)) {
        return false
    }
    if (!DllCall("IsWindowVisible", "Ptr", windowId)
            || DllCall("IsIconic", "Ptr", windowId)) {
        return false
    }
    if (DllCall(IsWindowOnDesktopNumberProc, "Ptr", windowId, "UInt", desktopNumber - 1, "Int") != 1) {
        return false
    }

    WinGetTitle, windowTitle, ahk_id %windowId%
    WinGetClass, windowClass, ahk_id %windowId%
    WinGet, exStyle, ExStyle, ahk_id %windowId%

    if (windowTitle == "" || (exStyle & 0x00000080) || (exStyle & 0x08000000)) {
        return false
    }
    if (windowClass == "Shell_TrayWnd" || windowClass == "Shell_SecondaryTrayWnd"
            || windowClass == "Progman" || windowClass == "WorkerW") {
        return false
    }
    return true
}

raiseWindowWithoutActivation(windowId)
{
    static HWND_TOP := 0
    static SWP_NOSIZE := 0x0001
    static SWP_NOMOVE := 0x0002
    static SWP_NOACTIVATE := 0x0010
    static SWP_NOOWNERZORDER := 0x0200
    flags := SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE | SWP_NOOWNERZORDER

    return DllCall("SetWindowPos", "Ptr", windowId, "Ptr", HWND_TOP, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", flags, "Int") == 1
}

MoveCurrentWindowToDesktop(desktopNumber) {
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, desktopNumber - 1)
    switchDesktopByNumber(desktopNumber)
}

MoveCurrentWindowToRightDesktop()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, (CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1) - 1)
    _switchDesktopToTarget(CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1)
}

MoveCurrentWindowToLeftDesktop()
{
    global CurrentDesktop, DesktopCount
    updateGlobalVariables()
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, (CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1) - 1)
    _switchDesktopToTarget(CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1)
}

;
; This function creates a new virtual desktop and switches to it
;
createVirtualDesktop()
{
    global CurrentDesktop, DesktopCount
    Send, #^d
    DesktopCount++
    CurrentDesktop := DesktopCount
    OutputDebug, [create] desktops: %DesktopCount% current: %CurrentDesktop%
}

;
; This function deletes the current virtual desktop
;
deleteVirtualDesktop()
{
    global CurrentDesktop, DesktopCount, LastOpenedDesktop
    Send, #^{F4}
    if (LastOpenedDesktop >= CurrentDesktop) {
        LastOpenedDesktop--
    }
    DesktopCount--
    CurrentDesktop--
    OutputDebug, [delete] desktops: %DesktopCount% current: %CurrentDesktop%
}
