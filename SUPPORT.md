# Support

Last updated: 2026-04-26

WDS 1.0 is a small open-source Windows desktop workflow project. Support is best-effort until a tested 2026 release is documented.

## Before Asking For Help

Check these first:

1. `README.md` for setup and shortcuts.
2. `STATUS.md` for known unknowns and compatibility state.
3. `TASKS.md` for work that is already planned.

## Useful Support Details

When reporting an issue, include:

- Windows version and build.
- AutoHotkey version.
- Whether AutoHotkey v1 or v2 is installed.
- Whether the script was run normally or as administrator.
- Whether `desktop_switcher.ahk`, `user_config.ahk`, and `VirtualDesktopAccessor.dll` are in the same folder.
- Which shortcut failed.
- Whether switching desktops works but moving windows does not.
- Any DebugView output, if available.

## Common Checks

- AutoHotkey v2 alone is not enough; the current scripts target AutoHotkey v1.
- The DLL must be next to `desktop_switcher.ahk`.
- Restart the script after editing `user_config.ahk`.
- Run the script as administrator if shortcuts need to work in elevated windows.
- Windows updates can affect virtual desktop helper DLL behavior.

## Compatibility Claims

If a Windows build is not recorded in `STATUS.md`, treat compatibility as unverified.

A support report that includes a successful smoke test can help move a target from unverified to confirmed.
