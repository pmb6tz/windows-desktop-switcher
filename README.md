# windows-desktop-switcher
An AutoHotKey script for Windows that lets a user change virtual desktops by pressing CapsLock + &lt;num> or other custom key combination. It also provides other features, such as creation/deletion of desktops by hotkey, etc. (see Hotkeys section below).

## Overview
This script creates more convenient hotkeys for switching virtual desktops in Windows 10. I built this to better mirror
the mapping I use on linux (with dwm), and it's always annoyed me that Windows does not have better
hotkey support for this feature (for instance, there's no way to go directly to a desktop by number).

Note, CapsLock will function normally even when using it as a modifier.

## Installation
[Install AutoHotkey](https://autohotkey.com/download/) v1.1 or later, then run the desktop_switcher.ahk script (open with AutoHotKey if prompted). I would recommend putting it in your startup folder and it'll be invoked on login. 

Note, on some windows (such as the ones you've run with Administrator privileges, also terminals) the hotkeys will only work if the script itself is `Run as Administrator`, due to the way Windows is designed. For the script to be invoked at startup with Administrator privileges, you can use Windows Task Scheduler.

## Hotkeys
        <CapsLock> + <Num>      - Switches to virtual desktop "num", e.g. <CapsLock> + 1
        <CapsLock> + Tab        - Switches back to the last desktop used
        <CapsLock> + C          - Create a new virtual desktop
        <CapsLock> + D          - Delete the current virtual desktop
        <CapsLock> + A or P     - Switch to virtual desktop on left (also, it cycles from the first to the last desktop)
        <CapsLock> + S or N     - Switch to virtual desktop on right (also, it cycles from the last to the first desktop)

Using `Ctrl + Alt` instead of `CapsLock` also works, without any additional changes necessary (e.g. use `<Ctrl> + <Alt> + 1` tu switch to the Desktop 1, just as you would use `<CapsLock> + 1`)

## Custom Hotkeys
To change the key mappings, modify the User Configuration section of the script and then reload (Right click the icon in the System Tray). Be sure to read about the [symbols AutoHotKey uses](https://autohotkey.com/docs/Hotkeys.htm) for custom key mapping.

## Other
To see debug messages, download [SysInternals DebugView](https://technet.microsoft.com/en-us/sysinternals/debugview).

To keep high-performance and robustness, this script is intended to be lightweight. For more advanced features (such as having different wallpapers on different desktops) check out https://github.com/sdias/win-10-virtual-desktop-enhancer