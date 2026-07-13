# CalKit Releases

Public binary release channel for **CalKit**.

This repo ships compiled runtime artifacts and install metadata only. The source
code lives in the private `yevgetman/calkit` repo.

Current version: **0.1.1** for macOS Apple Silicon (`arm64`).

Start here:

- **[`INSTALL.md`](INSTALL.md)** — installation, update, uninstall, and
  verification.
- **[`GETTING_STARTED.md`](GETTING_STARTED.md)** — first calendar repo and
  core workflows.

## What You Get

CalKit is a command-line calendar-as-code tool. It stores a personal or business
calendar as version-controlled YAML, expands recurrence, imports/exports
iCalendar, and provides a local preview/serve view.

This release installs a compiled `calkit` command. It does not include:

- CalKit source code
- private calendars
- local `.calkit/` runtime state
- reminder delivery credentials
- Telegram, mail, or notification tokens

## Prerequisites

- macOS on Apple Silicon (`arm64`)
- git, for snapshot/history/branch commands

## Install

From the [latest release](../../releases/latest), download these files into one
folder:

- `install.sh`
- `VERSION`
- `SHA256SUMS`
- `calkit-runtime-0.1.1-macos-arm64.tar.gz`

Then run:

```sh
sh install.sh
```

The installer verifies the checksum, installs the compiled runtime under
`~/.calkit-runtime/<version>/`, and points `~/.local/bin/calkit` at the compiled
binary.

Verify:

```sh
calkit --version
```

Then follow **[`GETTING_STARTED.md`](GETTING_STARTED.md)** to initialize a
calendar repo and run your first commands.

For PATH setup, updates, manual verification, uninstall notes, and offline
install details, see **[`INSTALL.md`](INSTALL.md)**.

## Sharing Calendars

The runtime and calendar data are separate. Installing this runtime does not
share any calendar content.

If you intentionally share a calendar repo, review the YAML files first. Events,
reminders, scopes, locations, notes, URLs, and exported `.ics` files may contain
personal or business-sensitive data.

## Support

This is an early macOS-only runtime release. Report install/runtime issues to
the CalKit maintainers with:

```sh
calkit --version
calkit doctor
```

Include your macOS version and whether your machine is Apple Silicon (`uname -m`
prints `arm64`).
