### Quick note
I wrote this as a quick evening script to solve my problem. If you're looking for something more robust & need more than this script can give you, check out:
https://github.com/sdias/win-10-virtual-desktop-enhancer

# windows-desktop-switcher
An AutoHotKey script for Windows that lets a user change virtual desktops by pressing CapsLock + &lt;num>. It also allows for creation/deletion of desktops by hotkey (see below).

## Overview
This script creates 'better' hotkeys for switching virtual desktops in windows 10. I built this to better mirror
the mapping I use on linux (with dwm), and it's always annoyed me that Windows does not have better
hotkey support for this feature (for instance, there's no way to go directly to a desktop by number).

Note that this only overrides CapsLock for the key combinations below. Otherwise, CapsLock will function normally.

## Installation
Install AutoHotKey v1.1 or later, then run the desktop_switcher.ahk script (open with AutoHotKey if prompted). I would recommend putting it in your startup folder and it'll be invoked on login.

## Hotkeys
        <CapsLock> + <Num>      - Switches to virtual desktop "num".
        <CapsLock> + C          - Create a new virtual desktop
        <CapsLock> + D          - Delete the current virtual desktop
        <CapsLock> + A or P     - Switch to virtual desktop on left
        <CapsLock> + S or N     - Switch to virtual desktop on right

To change the key mappings, modify the bottom of the script and reload. Be sure to read about the [symbols AutoHotKey uses](https://autohotkey.com/docs/Hotkeys.htm) for key mapping.

## Other
To see debug messages, download [SysInternals DebugView](https://technet.microsoft.com/en-us/sysinternals/debugview).

Disclaimer: I've only tried this on my machine, and on Windows 10. Use at your own risk.
