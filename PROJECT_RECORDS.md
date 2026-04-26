# Project Records Style

Last updated: 2026-04-26

This is the writing contract for WDS 1.0 project notes.

## Human-First Standard

Write for a real person returning to the project after a break.

A good note answers four questions quickly:

1. What is true right now?
2. What changed?
3. What is still unknown?
4. What should happen next?

## 2026 Style Rules

- Start with the current state, not the backstory.
- Date every status-changing note.
- Use short sections with plain headings.
- Keep claims testable.
- Mark unknowns as unknowns.
- Prefer checklists for work, tables for shortcuts, and short paragraphs for context.
- Link to source files when a claim depends on a file.
- Keep `README.md` useful for a first-time human reader.
- Keep `STATUS.md` useful for active truth.
- Keep `HANDOFF.md` useful for the next session.
- Keep `TASKS.md` useful for execution.
- Keep `DECISIONS.md` useful for settled choices.
- Keep `CHANGELOG.md` useful for history.

## What To Avoid

- Do not turn the README into a full archive.
- Do not bury active blockers under optimistic language.
- Do not say `supported` when the repository only proves `present in source`.
- Do not repeat the same background in every file.
- Do not add marketing language before runtime behavior is verified.
- Do not mix old upstream notes with current fork status unless the difference is explicit.

## Claim Levels

Use these words deliberately:

| Word | Meaning |
| --- | --- |
| Confirmed | Verified from source or an actual test recorded in this repo. |
| Expected | Likely based on source, but not yet tested. |
| Unverified | Not tested or not proven in this repo. |
| Blocked | Cannot move forward until a specific dependency is resolved. |
| Out of scope | Not part of the current project boundary. |

## File Roles

| File | Job |
| --- | --- |
| `README.md` | Fast human entrypoint. |
| `STATUS.md` | Active truth and validation state. |
| `HANDOFF.md` | Next-session restart note. |
| `TASKS.md` | Work queue. |
| `DECISIONS.md` | Settled decisions. |
| `PROJECT_RECORDS.md` | Documentation style contract. |
| `CHANGELOG.md` | Dated change history. |

## Update Rhythm

Update docs when one of these changes:

- Compatibility status.
- Support boundary.
- Packaging format.
- License status.
- Default shortcuts.
- Runtime entrypoint.
- DLL source or compatibility.
- Any task moves from unverified to confirmed.
