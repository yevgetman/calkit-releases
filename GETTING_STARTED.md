# Getting Started With CalKit

This guide is for installing the compiled CalKit runtime from the public release
channel. It does not require access to the private source repository.

CalKit manages a calendar as local YAML files in a git repo. It does not connect
to a cloud calendar by default, and it does not send reminders until you
explicitly configure reminders.

## 1. Install The CalKit Runtime

Download these files from the
[latest release](https://github.com/yevgetman/calkit-releases/releases/latest)
into one folder:

- `install.sh`
- `VERSION`
- `SHA256SUMS`
- `calkit-runtime-0.1.0-macos-arm64.tar.gz`

Run:

```sh
sh install.sh
```

The installer verifies the runtime checksum, installs CalKit under
`~/.calkit-runtime/<version>/`, and links the command to `~/.local/bin/calkit`.

If `~/.local/bin` is not on your `PATH`, the installer prints the line to add to
your shell config.

Verify:

```sh
calkit --version
```

For alternate install directories, updates, uninstall notes, and checksum
details, see [`INSTALL.md`](INSTALL.md).

## 2. Create A Calendar Repo

Create a folder for your calendar data:

```sh
mkdir -p ~/calendars/personal
cd ~/calendars/personal
calkit init --name "Personal Calendar" --owner "Me" --timezone America/Chicago
```

This creates:

- `.calkit/` - repo marker
- `calendar.yaml` - calendar metadata
- `scopes.yaml` - calendar tracks
- `events/` - one YAML file per event

Run a health check:

```sh
calkit doctor
```

## 3. Add Events

Add a one-time event:

```sh
calkit add --title "Dentist" --start 2026-07-15T09:00:00 --end 2026-07-15T10:00:00
```

Add a recurring event:

```sh
calkit add --title "Team standup" --start 2026-07-08T09:00:00 --end 2026-07-08T09:15:00 --repeat weekly --byday MO,WE
```

View the next two weeks:

```sh
calkit agenda --from today --to +2w
```

Show the next upcoming occurrence:

```sh
calkit list --expand --from today --to +1w
```

Show one event after copying its id from `list` or `agenda`:

```sh
calkit show evt_12345678
```

Edit or remove an event:

```sh
calkit edit evt_12345678 --title "Updated title"
calkit rm evt_12345678
```

## 4. Use Scopes

Scopes are calendar tracks. The default repo starts with a `personal` scope.

Create a work scope:

```sh
calkit scope add work --name "Work" --color "#2563eb"
```

Add an event to that scope:

```sh
calkit add --scope work --title "Planning" --start 2026-07-16T14:00:00 --end 2026-07-16T15:00:00
```

List only that scope:

```sh
calkit agenda --scope work --from today --to +2w
```

## 5. Save History With Git

CalKit stores files locally. Use `snapshot` when you want CalKit to commit the
current calendar state:

```sh
calkit snapshot -m "first calendar entries"
```

Inspect history:

```sh
calkit history
```

## 6. Preview The Calendar

Build a static month view:

```sh
calkit preview -o preview
open preview/index.html
```

Or run the local interactive server:

```sh
calkit serve
```

## 7. Import And Export

Import an iCalendar file into a scope:

```sh
calkit import calendar.ics --scope personal
```

Export your calendar:

```sh
calkit export --format ics -o calendar.ics
calkit export --format json -o calendar.json
```

Review exports before sharing them. They may contain private titles, notes,
locations, URLs, and timing patterns.

## 8. Optional: Reminders

CalKit can run reminders through a per-calendar local job, but it does not do so
until configured. Reminder delivery depends on the adapter you configure, such
as TeleKit or a local command.

Inspect reminder-related commands:

```sh
calkit reminders --help
calkit reminder --help
```

Do not add notification tokens or credentials to calendar YAML files.

## 9. Use JSON Output For Agents

Every command supports `--json`, and `CALKIT_JSON=1` enables JSON output by
default:

```sh
calkit agenda --from today --to +1w --json
```

## 10. Optional: Install The Agent Skill

If you use an agent environment that reads local skills, install CalKit's skill
into the current project:

```sh
calkit init-skill
```

This copies the public CalKit agent playbook into `.claude/skills/calkit/`.

## Common Issues

- `calkit: command not found`: add `~/.local/bin` to your `PATH`.
- `unsupported architecture`: the current public runtime is macOS `arm64`.
- `checksum mismatch`: re-download the release files into the same folder.
- `git` warnings: install git before using snapshot/history/branch commands.
- `not in a calkit repo`: run commands from inside a folder initialized with
  `calkit init`.
- `unknown scope`: create the scope with `calkit scope add` or use an existing
  scope from `scopes.yaml`.
- Timezone surprises: initialize with your IANA timezone, for example
  `America/Chicago`.

## What To Send When Asking For Help

Share command output, not private calendar data:

```sh
calkit --version
calkit doctor
calkit agenda --from today --to +1w
```

Do not share private event notes, locations, URLs, exported `.ics` files, or
notification credentials unless you intentionally want the recipient to see
that data.
