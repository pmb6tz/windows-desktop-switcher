# Security Policy

Last updated: 2026-04-26

WDS 1.0 is a local Windows AutoHotkey workflow project. It uses a script plus a native DLL helper, so security reports should be handled carefully even though the project is small.

## Supported Versions

No 2026-ready release has been validated yet.

| Version | Security support |
| --- | --- |
| `master` | Best-effort review only |
| Packaged releases | Not available yet |

## Reporting A Vulnerability

If you believe there is a security issue:

1. Do not publish exploit steps in a public issue.
2. Open a minimal issue asking for maintainer contact, or use GitHub private vulnerability reporting if it is enabled for this repository.
3. Include the affected file, Windows version, and the safest possible description of impact.

## Security-Sensitive Areas

Pay extra attention to changes involving:

- `VirtualDesktopAccessor.dll` origin or replacement.
- Running the script as administrator.
- Startup or scheduled task instructions.
- External downloads.
- Code that sends keystrokes or moves windows.

## Current Limitations

- DLL provenance and compatibility still need a dedicated documentation pass.
- License status still needs verification before release packaging.
- No automated security scanning workflow is present in this repository.
