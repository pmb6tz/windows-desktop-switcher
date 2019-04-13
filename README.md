# windows-desktop-switcher
An AutoHotKey script for Windows that lets a user change virtual desktops by pressing CapsLock + &lt;num> or other custom key combination. It also provides other features, such as creation/deletion of desktops by hotkey, etc. (see Hotkeys section below).

## Overview
This script creates more convenient hotkeys for switching virtual desktops in Windows 10. I built this to better mirror
the mapping I use on linux (with dwm), and it's always annoyed me that Windows does not have better
hotkey support for this feature (for instance, there's no way to go directly to a desktop by number).

Note, CapsLock will function normally even when using it as a modifier.

## Running
[Install AutoHotkey](https://autohotkey.com/download/) v1.1 or later, then run the `desktop_switcher.ahk` script (open with AutoHotKey if prompted). 

## Default Hotkeys
        <CapsLock> + <Num>      - Switches to virtual desktop "num", e.g. <CapsLock> + 1
        <CapsLock> + Tab        - Switches back to the last desktop used
        <CapsLock> + C          - Create a new virtual desktop
        <CapsLock> + D          - Delete the current virtual desktop
        <CapsLock> + A or P     - Switch to virtual desktop on left (also, it cycles from the first to the last desktop)
        <CapsLock> + S or N     - Switch to virtual desktop on right (also, it cycles from the last to the first desktop)
        <CapsLock> + <Num>      - Switches to virtual desktop "num", e.g. <CapsLock> + 1
        <CapsLock> + <Letter>   - Moves the current window to another desktop, then switches to it. 
                                  Use letters Q, W, E, R, T, Y, U, I, O.
                                  (e.g. <CapsLock> + <Q> moves to the first desktop
                                  	    <CapsLock> + <W> moves to the second desktop, etc.)

Using `Ctrl + Alt` instead of `CapsLock` also works, without any additional changes necessary (e.g. use `<Ctrl> + <Alt> + 1` to switch to the Desktop 1, just as you would use `<CapsLock> + 1`)

## Customizing Hotkeys
To change the key mappings, modify the `user_config.ahk` script and then run `desktop_switcher.ahk` (program will restart if it's already running). Here are some of the examples of customization options. Please note, `!` is button `Alt`, `+` is `Shift`, `#` is `Win`, `^` is `Ctrl`. Then syntax of the config file is `HOTKEY::ACTION`.

```
!n::switchDesktopToRight()             <- <Alt> + <N> will switch to the next desktop (to the right of the current one)
#!space::switchDesktopToRight()        <- <Win> + <Alt> + <Space> will switch to next desktop
CapsLock & n::switchDesktopToRight()   <- <CapsLock> + <N> will switch to the next desktop (& is necessary when using non-modifier key such as CapsLock)
```

For more detailed description of hotkeys check out [AutoHotKey docs](https://autohotkey.com/docs/Hotkeys.htm).

## Running on boot

You can make the script run on every boot with either of these methods.

### Simple (Non-administrator method)

1. Press `Win + R`, enter `shell:startup`, press `OK`
2. Create a shortcut to the `desktop_switcher.ahk` file here

### Advanced (Administrator method)

In Windows OS, some windows (such as the ones you've run with Administrator privileges, also terminals) the hotkeys will only work if the script itself is `Run as Administrator`, due to the way Windows is designed.

1. In the script folder, create file `desktop_switcher_admin.vbs` with contents
```
Set WshShell = CreateObject("WScript.Shell" ) 
WshShell.Run """desktop_switcher.ahk""", 0 
Set WshShell = Nothing
```
2. Press `Win + R`, enter `shell:startup`, press `OK`
3. Create a shortcut to `desktop_switcher_admin.vbs` here

Instead of the above method, you can also use Windows Task Scheduler to run the script as Administrator on boot.

## Other
To see debug messages, download [SysInternals DebugView](https://technet.microsoft.com/en-us/sysinternals/debugview).

To keep high-performance and robustness, this script is intended to be lightweight. For more advanced features (such as having different wallpapers on different desktops) check out https://github.com/sdias/win-10-virtual-desktop-enhancer
