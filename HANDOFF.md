# Handoff

Last updated: 2026-04-26
Repository: `I-am-Eisenhorn/WDS-1.0`
Branch: `master`

## Start Here

Read these files in order:

1. `README.md`
2. `STATUS.md`
3. `TASKS.md`
4. `DECISIONS.md`
5. `CHANGELOG.md`

The current work is documentation restart for an old Windows desktop switching project. No code changes were made in this documentation pass.

## Current Shape

- Runtime is `desktop_switcher.ahk`.
- User shortcuts live in `user_config.ahk`.
- The native desktop helper is `VirtualDesktopAccessor.dll`.
- Current scripts are AutoHotkey v1, not v2.
- Documentation was rewritten to be shorter, dated, and explicit about unknowns.

## What Changed In This Pass

- Replaced the long legacy README with a human-first README.
- Added active project status tracking.
- Added task, decision, handoff, project-record, and changelog files.
- Kept compatibility claims conservative until real Windows testing is recorded.

## Do Not Repeat

Do not re-copy the old README into new project notes.

Do not claim that Windows 11 is fully supported just because the script has a Windows 11 registry fallback.

Do not claim release readiness until tests and license status are resolved.

Do not mix active truth with historical background. Historical notes belong in `CHANGELOG.md` or in a clearly labeled legacy section.

## Next Best Step

Run a real smoke test on the target Windows version:

1. Install or confirm AutoHotkey v1.1.33+.
2. Run `desktop_switcher.ahk` from the repository folder.
3. Confirm direct switching with `CapsLock` + `1` and `CapsLock` + `2`.
4. Confirm last-desktop switching with `CapsLock` + `Tab`.
5. Confirm window move with `CapsLock` + `Q` / `W` or arrow shortcuts.
6. Record results in `STATUS.md` and `CHANGELOG.md`.

## Open Questions

- Should WDS 1.0 remain AutoHotkey v1, or should an AHK v2 migration become a separate future line?
- Which Windows version is the official support target?
- Should the project ship as raw scripts, a ZIP bundle, or a small installer?
- What license should this fork carry after upstream license verification?
