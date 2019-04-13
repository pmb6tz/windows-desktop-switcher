; ====================
; === INSTRUCTIONS ===
; ====================
; 1. Any lines starting with ; are ignored
; 2. After changing this config file run script file "desktop_switcher.ahk"
; 3. Every line is in the format HOTKEY::ACTION

; === SYMBOLS ===
; !   <- Alt
; +   <- Shift
; ^   <- Ctrl
; #   <- Win
; For more, visit https://autohotkey.com/docs/Hotkeys.htm

; === EXAMPLES ===
; !n::switchDesktopToRight()             <- <Alt> + <N> will switch to the next desktop (to the right of the current one)
; #!space::switchDesktopToRight()        <- <Win> + <Alt> + <Space> will switch to next desktop
; CapsLock & n::switchDesktopToRight()   <- <CapsLock> + <N> will switch to the next desktop (& is necessary when using non-modifier key such as CapsLock)

; ===========================
; === END OF INSTRUCTIONS ===
; ===========================

$1::updateTrayIcon()
CapsLock & 1::switchDesktopByNumber(1)
CapsLock & 2::switchDesktopByNumber(2)
CapsLock & 3::switchDesktopByNumber(3)
CapsLock & 4::switchDesktopByNumber(4)
CapsLock & 5::switchDesktopByNumber(5)
CapsLock & 6::switchDesktopByNumber(6)
CapsLock & 7::switchDesktopByNumber(7)
CapsLock & 8::switchDesktopByNumber(8)
CapsLock & 9::switchDesktopByNumber(9)

CapsLock & n::switchDesktopToRight()
CapsLock & p::switchDesktopToLeft()
CapsLock & s::switchDesktopToRight()
CapsLock & a::switchDesktopToLeft()
CapsLock & tab::switchDesktopToLastOpened()

CapsLock & c::createVirtualDesktop()
CapsLock & d::deleteVirtualDesktop()

CapsLock & f::togglePinWindowOnTop()
CapsLock & g::togglePinWindowOnAllDesktops()
CapsLock & h::togglePinAppOnAllDesktops()

CapsLock & q::moveCurrentWindowToDesktop(1)
CapsLock & w::moveCurrentWindowToDesktop(2)
CapsLock & e::moveCurrentWindowToDesktop(3)
CapsLock & r::moveCurrentWindowToDesktop(4)
CapsLock & t::moveCurrentWindowToDesktop(5)
CapsLock & y::moveCurrentWindowToDesktop(6)
CapsLock & u::moveCurrentWindowToDesktop(7)
CapsLock & i::moveCurrentWindowToDesktop(8)
CapsLock & o::moveCurrentWindowToDesktop(9)

; === INSTRUCTIONS ===
; Below is the alternate key configuration. Delete symbol ; in the beginning of the line to enable. 
; Note, that  ^!1  means "Ctrl + Alt + 1" and  ^#1  means "Ctrl + Win + 1"
; === END OF INSTRUCTIONS ===

; ^!1::switchDesktopByNumber(1)
; ^!2::switchDesktopByNumber(2)
; ^!3::switchDesktopByNumber(3)
; ^!4::switchDesktopByNumber(4)
; ^!5::switchDesktopByNumber(5)
; ^!6::switchDesktopByNumber(6)
; ^!7::switchDesktopByNumber(7)
; ^!8::switchDesktopByNumber(8)
; ^!9::switchDesktopByNumber(9)

; ^!n::switchDesktopToRight()
; ^!p::switchDesktopToLeft()
; ^!s::switchDesktopToRight()
; ^!a::switchDesktopToLeft()
; ^!tab::switchDesktopToLastOpened()

; ^!c::createVirtualDesktop()
; ^!d::deleteVirtualDesktop()

; ^#1::moveCurrentWindowToDesktop(1)
; ^#2::moveCurrentWindowToDesktop(2)
; ^#3::moveCurrentWindowToDesktop(3)
; ^#4::moveCurrentWindowToDesktop(4)
; ^#5::moveCurrentWindowToDesktop(5)
; ^#6::moveCurrentWindowToDesktop(6)
; ^#7::moveCurrentWindowToDesktop(7)
; ^#8::moveCurrentWindowToDesktop(8)
; ^#9::moveCurrentWindowToDesktop(9)
