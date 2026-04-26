# Project Status

Last updated: 2026-04-26
Repository: `I-am-Eisenhorn/WDS-1.0`
Branch: `master`
Mode: legacy project restart, documentation-first

## Active Truth

WDS 1.0 is currently a lightweight AutoHotkey v1 project for Windows virtual desktop shortcuts.

The project is not yet in a verified 2026 release state. The code may work, but this repository does not currently contain a fresh compatibility report for recent Windows 10 or Windows 11 builds.

## Confirmed From Repository Source

- `desktop_switcher.ahk` is the runtime entrypoint.
- `user_config.ahk` stores the default and alternate shortcut mappings.
- `VirtualDesktopAccessor.dll` is present in the repository and is loaded by `desktop_switcher.ahk` from the script folder.
- The script requires AutoHotkey v1.1.33+.
- AutoHotkey v2 is not supported by the current scripts.
- The script can switch desktops, create/delete desktops, and move the active window between desktops.
- The script reads virtual desktop state from the Windows registry and includes a Windows 11 registry path fallback.

## Not Yet Verified

- Fresh runtime test on Windows 10.
- Fresh runtime test on Windows 11.
- Whether the committed `VirtualDesktopAccessor.dll` is compatible with the newest Windows builds.
- Whether every default shortcut works under normal and elevated app windows.
- Whether startup instructions still work without adjustment.
- Project license status for this fork.
- Release packaging format.

## Product Boundary

Current scope:

- Direct keyboard control for Windows virtual desktops.
- Small AutoHotkey v1 script surface.
- Human-readable configuration in `user_config.ahk`.

Out of scope until deliberately reopened:

- Full desktop environment replacement.
- Wallpaper management per desktop.
- Large UI shell.
- AutoHotkey v2 migration.
- Installer or marketplace distribution.

## Acceptance Target For A 2026 Ready State

The repository can be called 2026-ready only after these are true:

- A current Windows 11 smoke test is recorded.
- A current Windows 10 smoke test is recorded or explicitly marked unsupported.
- The DLL origin and compatibility status are documented.
- Startup behavior is tested.
- License status is clarified.
- A release ZIP or installation path is documented.
