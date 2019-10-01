# windows-desktop-switcher
An AutoHotkey script for Windows that lets a user change virtual desktops by pressing CapsLock + &lt;num> or other custom key combination. It also provides other features, such as creation/deletion of desktops by hotkey, etc. (see Hotkeys section below).

## Overview
This script creates more convenient hotkeys for switching virtual desktops in Windows 10. I built this to better mirror the mapping I use on linux (with dwm), and it's always annoyed me that Windows does not have better hotkey support for this feature (for instance, there's no way to go directly to a desktop by number).

Note, CapsLock will function normally even when using it as a modifier.

## Notes about Windows 1809/1903≤ Updates
This project relies partly on [VirtualDesktopAccessor.dll](https://github.com/Ciantic/VirtualDesktopAccessor) (for moving windows to other desktops). This binary is included in this repository for convenience, and was recently updated to work with the 1809/1903≤ updates. 

This may cause instability for users running older versions of Windows. If this is the case, [download the older DLL](https://github.com/pmb6tz/windows-desktop-switcher/blob/5289a0968179638f6e946a4cb69723510abd0d19/virtual-desktop-accessor.dll), rename it to `VirtualDesktopAccessor.dll`, and overwrite the previous DLL.

If a future Windows Update breaks the DLL again and updating your files from this repository doesn't work, you could try [building the DLL yourself](https://github.com/Ciantic/VirtualDesktopAccessor) (given that it was since updated by its' creators).

## Running
[Install AutoHotkey](https://autohotkey.com/download/) v1.1 or later, then run the `desktop_switcher.ahk` script (open with AutoHotkey if prompted). You can disable the switching animation by opening "Adjust the appearance and performance of Windows" and then unselecting the checkmark "Animate windows when minimizing and maximizing".

## Default Hotkeys
        <CapsLock> + <Num>      - Switches to virtual desktop "num", e.g. <CapsLock> + 1 (you can also use the Numpad)
        <CapsLock> + Tab        - Switches back to the last desktop used
        <CapsLock> + C          - Create a new virtual desktop
        <CapsLock> + D          - Delete the current virtual desktop
        <CapsLock> + A or P     - Switch to virtual desktop on left (also cycles from the first to the last desktop)
        <CapsLock> + S or N     - Switch to virtual desktop on right (also cycles from the last to the first desktop)
        <CapsLock> + <Letter>   - Moves the current window to another desktop, then switches to it. 
                                  Use letters Q, W, E, R, T, Y, U, I, O.
                                  (e.g. <CapsLock> + Q moves to the first desktop
                                  	    <CapsLock> + W moves to the second desktop, etc.)

If you'd like, you can [enable the alternate configuration](https://github.com/pmb6tz/windows-desktop-switcher/issues/44), to use `<Ctrl> + <Alt>` instead of `<CapsLock>` (e.g. use `<Ctrl> + <Alt> + 1` to switch to the Desktop 1, just as you would use `<CapsLock> + 1`).

## Customizing Hotkeys
To change the key mappings, modify the `user_config.ahk` script and then run `desktop_switcher.ahk` (program will restart if it's already running). Note, `!` corresponds to `Alt`, `+` is `Shift`, `#` is `Win`, and `^` is `Ctrl`. The syntax of the config file is `HOTKEY::ACTION`. Here are some of the examples of customization options. 

```
!n::switchDesktopToRight()             <- <Alt> + <N> will switch to the desktop on the right
#!space::switchDesktopToRight()        <- <Win> + <Alt> + <Space> will switch to the desktop on the right
CapsLock & n::switchDesktopToRight()   <- <CapsLock> + <N> will switch to the next desktop (& is necessary when using non-modifier key such as CapsLock)
^space::send, #{tab}                   <- <Ctrl> + <Space> will open Desktop Manager by sending <Win> + <Tab>
```

After any changes to the configuration the program needs to be closed and opened again. You can find the explanation for the Desktop Manager hotkey [here](https://github.com/pmb6tz/windows-desktop-switcher/issues/41).
For more detailed description of hotkeys check out [AutoHotkey docs](https://autohotkey.com/docs/Hotkeys.htm).

## Running on boot

You can make the script run on every boot with either of these methods.

### Simple (Non-administrator method)

1. Press `Win + R`, enter `shell:startup`, press `OK`
2. Create a shortcut to the `desktop_switcher.ahk` file here

### Advanced (Administrator method)

Windows prevents hotkeys from working in windows that were launched with higher elevation than the AutoHotKey script (such as CMD or Powershell terminals that were launched as Administrator). As a result, Windows Desktop Switcher hotkeys will only work within these windows if the script itself is `Run as Administrator`, due to the way Windows is designed. 

You can do this by creating a scheduled task to invoke the script at logon. You may use 'Task Scheduler', or create the task in powershell as demonstrated.
```
# Run the following commands in an Administrator powershell prompt. 
# Be sure to specify the correct path to your desktop_switcher.ahk file. 

$A = New-ScheduledTaskAction -Execute "PATH\TO\desktop_switcher.ahk"
$T = New-ScheduledTaskTrigger -AtLogon
$P = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$S = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit 0
$D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
Register-ScheduledTask WindowsDesktopSwitcher -InputObject $D
```

The task is now registered and will run on the next logon, and can be viewed or modified in 'Task Scheduler'. 

## Credits

- Thanks to [Ciantic/VirtualDesktopAccessor](https://github.com/Ciantic/VirtualDesktopAccessor) (for the DLL) and [sdias/win-10-virtual-desktop-enhancer](https://github.com/sdias/win-10-virtual-desktop-enhancer) (for the DLL usage samples) our code can move windows between desktops.

## Other
To see debug messages, download [SysInternals DebugView](https://technet.microsoft.com/en-us/sysinternals/debugview).

This script is intended to be lightweight in order to prioritize performance and robustness. For more advanced features (such as configuring different wallpapers on different desktops) check out https://github.com/sdias/win-10-virtual-desktop-enhancer.
