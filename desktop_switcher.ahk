; Globals
DesktopCount = 2        ; Windows starts with 2 desktops at boot
CurrentDesktop = 1      ; Desktop count is 1-indexed (Microsoft numbers them this way)

;
; This function examines the registry to build an accurate list of the current virtual desktops and which one we're currently on.
; Current desktop UUID appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops
; List of desktops appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops
;
mapDesktopsFromRegistry() {
    global CurrentDesktop, DesktopCount

    ; Get the current desktop UUID. Length should be 32 always, but there's no guarantee this couldn't change in a later Windows release so we check.
    RegRead, CurrentDesktopId, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops, CurrentVirtualDesktop
    IdLength := StrLen(CurrentDesktopId)

    ; Get a list of the UUIDs for all virtual desktops on the system
    RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    DesktopListLength := StrLen(DesktopList)

    ; Figure out how many virtual desktops there are
    DesktopCount := DesktopListLength/IdLength

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
    i := 0
    while (i < DesktopCount) {
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
; This function switches to the desktop number provided.
;
switchDesktopByNumber(targetDesktop)
{
    global CurrentDesktop, DesktopCount

    ; Re-generate the list of desktops and where we fit in that. We do this because
    ; the user may have switched desktops via some other means than the script.
    mapDesktopsFromRegistry()

    ; If the user is trying to swap to a desktop that isn't valid, don't let
    ; them because we'd lose track of numbering. Unfortunately, we have to assume
    ; that this script was started when there were three desktops because we have
    ; no way to check.
    if (targetDesktop > DesktopCount) {
        return
    }

    ; Go right until we reach the desktop we want
    while(CurrentDesktop < targetDesktop) {
        Send ^#{Right}
        CurrentDesktop++
        OutputDebug, [right] target: %targetDesktop% current: %CurrentDesktop%
    }

    ; Go left until we reach the desktop we want
    while(CurrentDesktop > targetDesktop) {
        Send ^#{Left}
        CurrentDesktop--
        OutputDebug, [left] target: %targetDesktop% current: %CurrentDesktop%
    }
}

;
; This function creates a new virtual desktop and switches to it
;
createVirtualDesktop()
{
    global CurrentDesktop, DesktopCount
    Send, #^d
    DesktopCount++
    CurrentDesktop = %DesktopCount%
    OutputDebug, [create] desktops: %DesktopCount% current: %CurrentDesktop%
}

;
; This function deletes the current virtual desktop
;
deleteVirtualDesktop()
{
    global CurrentDesktop, DesktopCount
    Send, #^{F4}
    DesktopCount--
    CurrentDesktop--
    OutputDebug, [delete] desktops: %DesktopCount% current: %CurrentDesktop%
}

;
; This function selects the previous virtual desktop using Windows shortcuts.
;
switchPreviousDesktop()
{
    global CurrentDesktop
    mapDesktopsFromRegistry()
    ; Only operate if not on first desktop
    if (CurrentDesktop SS> 1) {
        Send ^#{Left}
        CurrentDesktop--
        OutputDebug, [previous] current: %CurrentDesktop%
    }
}

;
; This function selects the next virtual desktop using Windows shortcuts.
;
switchNextDesktop()
{
    global CurrentDesktop, DesktopCount
    mapDesktopsFromRegistry()
    ; Only operate if not on last desktop
    if (CurrentDesktop < DesktopCount) {
        Send ^#{Right}
        CurrentDesktop++
        OutputDebug, [next] current: %CurrentDesktop%
    }
}

; Main
SetKeyDelay, 75
mapDesktopsFromRegistry()
OutputDebug, [loading] desktops: %DesktopCount% current: %CurrentDesktop%

; User config!
; This section binds the key combo to the switch/create/delete actions
CapsLock & 1::switchDesktopByNumber(1)
CapsLock & 2::switchDesktopByNumber(2)
CapsLock & 3::switchDesktopByNumber(3)
CapsLock & 4::switchDesktopByNumber(4)
CapsLock & 5::switchDesktopByNumber(5)
CapsLock & 6::switchDesktopByNumber(6)
CapsLock & 7::switchDesktopByNumber(7)
CapsLock & 8::switchDesktopByNumber(8)
CapsLock & 9::switchDesktopByNumber(9)
CapsLock & a::switchPreviousDesktop()
CapsLock & s::switchNextDesktop()
CapsLock & c::createVirtualDesktop()
CapsLock & d::deleteVirtualDesktop()

; Alternate keys for this config. Adding these because DragonFly (python) doesn't send CapsLock correctly.
^!1::switchDesktopByNumber(1)
^!2::switchDesktopByNumber(2)
^!3::switchDesktopByNumber(3)
^!4::switchDesktopByNumber(4)
^!5::switchDesktopByNumber(5)
^!6::switchDesktopByNumber(6)
^!7::switchDesktopByNumber(7)
^!8::switchDesktopByNumber(8)
^!9::switchDesktopByNumber(9)
^!c::createVirtualDesktop()
^!d::deleteVirtualDesktop()
