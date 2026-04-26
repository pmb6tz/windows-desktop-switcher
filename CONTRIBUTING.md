# Contributing

Last updated: 2026-04-26

Thanks for helping improve WDS 1.0.

This project is small on purpose. Good contributions keep it easy to run, easy to inspect, and easy to recover if a Windows update changes virtual desktop behavior.

## Before Changing Code

Read these first:

1. `README.md`
2. `STATUS.md`
3. `TASKS.md`
4. `DECISIONS.md`

Check whether the work is already listed, blocked, or out of scope.

## Good First Contributions

- Verify the current script on a specific Windows build.
- Record a clear smoke test result in `STATUS.md`.
- Improve setup instructions without changing behavior.
- Clarify `VirtualDesktopAccessor.dll` source and compatibility.
- Fix small AutoHotkey v1 issues with a focused patch.

## Code Guidelines

- Keep AutoHotkey v1 syntax unless a migration has been explicitly accepted.
- Keep shortcut mappings in `user_config.ahk`.
- Keep runtime behavior in `desktop_switcher.ahk`.
- Avoid broad rewrites until the current baseline is tested.
- Do not add installer, UI, or packaging work in the same change as shortcut logic.

## Documentation Guidelines

Use `PROJECT_RECORDS.md` as the style contract.

In short:

- Start with active truth.
- Date status-changing notes.
- Mark unknowns clearly.
- Do not overclaim compatibility.
- Keep historical context separate from current state.

## Test Notes

A useful test report includes:

- Windows version and build.
- AutoHotkey version.
- Whether the script was run normally or as administrator.
- Which shortcuts were tested.
- Whether `VirtualDesktopAccessor.dll` worked for moving windows.
- Any error messages or debug output.

## Pull Request Shape

Keep pull requests focused:

- One behavior change per PR.
- Documentation-only changes should not touch `.ahk` or `.dll` files.
- Compatibility claims should include test evidence.
