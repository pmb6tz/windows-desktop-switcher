; Globals
desktopCount = 3		; Windows starts with 3 desktops at boot
currentDesktop = 1		; Desktop count is 1-indexed (yeah, yeah)

OutputDebug, [loading] desktops: %desktopCount% current: %currentDesktop%

; This function switches to the desktop number provided.
switchDesktopByNumber(targetDesktop)
{
	global currentDesktop, desktopCount
	
	; If the user is trying to swap to a desktop that isn't valid, don't let
	; them because we'd lose track of numbering. Unfortunately, we have to assume
	; that this script was started when there were three desktops because we have
	; no way to check.
	if (targetDesktop > desktopCount) {
		return
	}
	
	; Go right until we reach the desktop we want
	while(currentDesktop < targetDesktop) {
        SendEvent ^#{Right}	
		currentDesktop++
		Sleep, 150
    	OutputDebug, [right] target: %targetDesktop% current: %currentDesktop%
	}
	
	; Go left until we reach the desktop we want
	while(currentDesktop > targetDesktop) {
	    SendEvent ^#{Left}
		currentDesktop--
		Sleep, 150
		OutputDebug, [left] target: %targetDesktop% current: %currentDesktop%
	}
}

; This function creates a new virtual desktop and switches to it
createVirtualDesktop()
{
	global currentDesktop, desktopCount
	Send, #^d
	desktopCount++
	currentDesktop = %desktopCount%
	OutputDebug, [create] desktops: %desktopCount% current: %currentDesktop%
}

; This function deletes the current virtual desktop
deleteVirtualDesktop()
{
	global currentDesktop, desktopCount
	Send, #^{F4}
	desktopCount--
	currentDesktop--
	OutputDebug, [delete] desktops: %desktopCount% current: %currentDesktop%
}


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
