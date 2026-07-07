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

## 4. Save History With Git

CalKit stores files locally. Use `snapshot` when you want CalKit to commit the
current calendar state:

```sh
calkit snapshot -m "first calendar entries"
```

Inspect history:

```sh
calkit history
```

## 5. Preview The Calendar

Build a static month view:

```sh
calkit preview -o preview
open preview/index.html
```

Or run the local interactive server:

```sh
calkit serve
```

## 6. Use JSON Output For Agents

Every command supports `--json`, and `CALKIT_JSON=1` enables JSON output by
default:

```sh
calkit agenda --from today --to +1w --json
```

## 7. Optional: Install The Agent Skill

If you use an agent environment that reads local skills, install CalKit's skill
into the current project:

```sh
calkit init-skill
```

This copies the public CalKit agent playbook into `.claude/skills/calkit/`.

## Common Issues

- `calkit: command not found`: add `~/.local/bin` to your `PATH`.
- `git` warnings: install git before using snapshot/history/branch commands.
- `not in a calkit repo`: run commands from inside a folder initialized with
  `calkit init`.
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
