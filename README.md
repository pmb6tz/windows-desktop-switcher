# WDS 1.0

Human-first virtual desktop switching for Windows.

WDS 1.0 is a restart point for a small AutoHotkey-based desktop workflow: press a simple shortcut, jump to the workspace you meant, and keep moving. The project is intentionally lightweight. It exists for people who use Windows virtual desktops every day and want direct, reliable keyboard control instead of slow workspace navigation.

This fork is based on `windows-desktop-switcher` and currently keeps the legacy AutoHotkey v1 architecture.

## What It Does

- Switch directly to virtual desktops 1-9.
- Switch left or right through desktops.
- Return to the last opened desktop.
- Create or delete virtual desktops.
- Move the current window to another desktop, then follow it there.
- Keep shortcuts configurable in `user_config.ahk`.

## Quick Start

1. Install AutoHotkey v1.1.33 or newer.
2. Keep these files in the same folder:
   - `desktop_switcher.ahk`
   - `user_config.ahk`
   - `VirtualDesktopAccessor.dll`
3. Run `desktop_switcher.ahk`.
4. Try `CapsLock` + `1`, `CapsLock` + `2`, and `CapsLock` + `Tab`.

AutoHotkey v2 is not supported by the current scripts.

## Default Shortcuts

| Action | Shortcut |
| --- | --- |
| Go to desktop 1-9 | <kbd>CapsLock</kbd> + <kbd>1</kbd> ... <kbd>9</kbd> |
| Go to desktop 1-9 with numpad | <kbd>CapsLock</kbd> + <kbd>Numpad1</kbd> ... <kbd>Numpad9</kbd> |
| Go to the last opened desktop | <kbd>CapsLock</kbd> + <kbd>Tab</kbd> |
| Go right | <kbd>CapsLock</kbd> + <kbd>S</kbd> or <kbd>N</kbd> |
| Go left | <kbd>CapsLock</kbd> + <kbd>A</kbd> or <kbd>P</kbd> |
| Create a desktop | <kbd>CapsLock</kbd> + <kbd>C</kbd> |
| Delete the current desktop | <kbd>CapsLock</kbd> + <kbd>D</kbd> |
| Move current window to desktop 1-9 | <kbd>CapsLock</kbd> + <kbd>Q</kbd> ... <kbd>O</kbd> |
| Move current window right or left | <kbd>CapsLock</kbd> + <kbd>Right</kbd> or <kbd>Left</kbd> |

`CapsLock` still works as Caps Lock when it is not used as a shortcut modifier.

## Customize Shortcuts

Edit `user_config.ahk`, then run `desktop_switcher.ahk` again. The script uses AutoHotkey v1 syntax:

| Symbol | Key |
| --- | --- |
| `!` | Alt |
| `+` | Shift |
| `^` | Ctrl |
| `#` | Win |

Example:

```ahk
!n::switchDesktopToRight()
#!space::switchDesktopToRight()
CapsLock & n::switchDesktopToRight()
```

The current config also includes commented alternate mappings for `Ctrl` + `Alt` and `Ctrl` + `Win`.

## Run On Sign-In

Simple user startup:

1. Press <kbd>Win</kbd> + <kbd>R</kbd>.
2. Enter `shell:startup`.
3. Add a shortcut to `desktop_switcher.ahk`.

Administrator startup is useful when you need shortcuts to work inside elevated windows. Use Windows Task Scheduler and run the script at logon with highest privileges. The exact path must point to your local `desktop_switcher.ahk` file.

## Current Project State

This repository is in a documentation restart phase.

Confirmed from source:

- Runtime entrypoint: `desktop_switcher.ahk`.
- User shortcut map: `user_config.ahk`.
- Native helper expected by the script: `VirtualDesktopAccessor.dll`.
- Current script target: AutoHotkey v1.1.33+.
- The script reads Windows virtual desktop data from the registry and includes a Windows 11 registry location fallback.

Not yet confirmed in this repository:

- Fresh Windows 10 compatibility test.
- Fresh Windows 11 compatibility test.
- Current `VirtualDesktopAccessor.dll` compatibility across recent Windows builds.
- Packaged release format.
- License file status for this fork.

See [STATUS.md](STATUS.md) and [TASKS.md](TASKS.md) before making product claims.

## Project Records

The Markdown files are the working memory for this project:

- [STATUS.md](STATUS.md) - active truth and validation state.
- [HANDOFF.md](HANDOFF.md) - compact restart notes for the next session.
- [TASKS.md](TASKS.md) - next work, blocked work, and done work.
- [DECISIONS.md](DECISIONS.md) - decisions that should not be re-litigated casually.
- [PROJECT_RECORDS.md](PROJECT_RECORDS.md) - writing style for project notes.
- [CHANGELOG.md](CHANGELOG.md) - dated documentation and project changes.

Repository care files:

- [CONTRIBUTING.md](CONTRIBUTING.md) - how to change the project safely.
- [SUPPORT.md](SUPPORT.md) - how to report usage issues with useful context.
- [SECURITY.md](SECURITY.md) - how to handle security-sensitive reports.

## Troubleshooting

If shortcuts do not work:

- Confirm AutoHotkey v1 is installed, not only AutoHotkey v2.
- Confirm `VirtualDesktopAccessor.dll` is in the same folder as `desktop_switcher.ahk`.
- Restart the script after editing `user_config.ahk`.
- Run as administrator if you need shortcuts inside elevated apps.
- Use Sysinternals DebugView if you need to inspect debug output from the script.

## Credits

This fork descends from the original `windows-desktop-switcher` project and relies on `VirtualDesktopAccessor.dll` from the wider Windows virtual desktop tooling ecosystem. Preserve upstream credit when modifying or redistributing the project.
