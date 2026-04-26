# Decisions

Last updated: 2026-04-26

This file records decisions that should remain stable until there is a clear reason to change them.

## D001 - Keep The Current Baseline On AutoHotkey v1

Decision: the current project baseline remains AutoHotkey v1.

Reason: `desktop_switcher.ahk` declares `#Requires AutoHotkey v1.1.33+`, and `user_config.ahk` uses AutoHotkey v1 syntax. A migration to AutoHotkey v2 would be a real engineering task, not a documentation edit.

Status: active.

## D002 - Use Human-First Project Records

Decision: project notes should be short, dated, and written for a person opening the repository under time pressure.

Reason: this is an old project restart. The repository needs a clear front door and a small set of source-of-truth notes rather than one large README carrying every detail.

Status: active.

## D003 - Separate Active Truth From Historical Detail

Decision: active truth belongs in `STATUS.md`; historical changes belong in `CHANGELOG.md`; next-session restart notes belong in `HANDOFF.md`.

Reason: mixing old background, planned work, and current facts makes the project hard to resume safely.

Status: active.

## D004 - Do Not Overclaim Windows Compatibility

Decision: the documentation must not claim current Windows 10 or Windows 11 release readiness until a fresh test is recorded.

Reason: the source contains Windows registry handling and a Windows 11 fallback, but source inspection is not the same as runtime validation.

Status: active.

## D005 - Keep The Core Scope Small

Decision: WDS 1.0 remains focused on virtual desktop keyboard control.

Reason: the project is valuable because it is small, fast, and easy to reason about. New UI, installer, tray features, or desktop personalization should wait until the base workflow is verified.

Status: active.

## D006 - Treat License Status As Unresolved

Decision: do not make redistribution or packaging claims until license status is clarified.

Reason: this fork currently needs explicit license verification before a 2026-ready release can be described confidently.

Status: active.
