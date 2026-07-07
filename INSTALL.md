# Installing CalKit

This repo is the public install channel for CalKit. It installs a compiled
runtime without giving access to the private source code.

## Supported Platform

Current release:

- CalKit `0.1.0`
- macOS Apple Silicon (`arm64`)

Check your Mac:

```sh
uname -s
uname -m
```

Expected output is `Darwin` and `arm64`.

## Files To Download

Download all of these files from the
[latest release](https://github.com/yevgetman/calkit-releases/releases/latest)
into the same folder:

- `install.sh`
- `VERSION`
- `SHA256SUMS`
- `calkit-runtime-0.1.0-macos-arm64.tar.gz`

The installer expects the files to be side by side.

## Install

Run:

```sh
sh install.sh
```

The installer:

1. Detects your platform.
2. Reads `VERSION`.
3. Verifies the tarball against `SHA256SUMS`.
4. Extracts the runtime into `~/.calkit-runtime/<version>/`.
5. Links `~/.local/bin/calkit` to the compiled executable.

Verify:

```sh
calkit --version
```

If `calkit` is not found, add `~/.local/bin` to your PATH:

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
exec "$SHELL"
```

Then run `calkit --version` again.

## Install To A Different Bin Directory

Set `CALKIT_BIN_DIR`:

```sh
CALKIT_BIN_DIR="$HOME/bin" sh install.sh
```

Make sure that directory is on your PATH.

## Manual Checksum Verification

The installer verifies checksums automatically. To verify manually:

```sh
shasum -a 256 calkit-runtime-0.1.0-macos-arm64.tar.gz
cat SHA256SUMS
```

The hash for the tarball must match the entry in `SHA256SUMS`.

## Offline Or Air-Gapped Install

Download the four release files on a connected machine, transfer them together
to the target Mac, then run:

```sh
sh install.sh
```

No source repo access is required. The runtime itself does not need network
access for normal local calendar operations.

## Updating

Download the files from the newer release into one folder and run:

```sh
sh install.sh
```

The installer installs each version under its own directory and updates the
`calkit` symlink to point at the selected version.

## Uninstalling

Remove the symlink:

```sh
rm "$HOME/.local/bin/calkit"
```

Optionally remove installed runtimes:

```sh
rm -rf "$HOME/.calkit-runtime"
```

This does not delete your calendar repos. Calendar data lives wherever you
created it, for example `~/calendars/personal`.

## What Gets Installed

The runtime includes:

- `calkit-bin` — the compiled executable.
- `assets/` — UI assets for `calkit preview` and `calkit serve`.
- `agent-skill/` — the public agent playbook copied by `calkit init-skill`.
- `VERSION`.

It does not include private source code, private calendars, reminder delivery
credentials, tokens, or local `.calkit/` runtime state.

## Troubleshooting

- `unsupported OS`: this release targets macOS only.
- `unsupported architecture`: this release targets Apple Silicon (`arm64`).
- `checksum mismatch`: re-download all four release files into the same folder.
- `calkit: command not found`: add `~/.local/bin` to your PATH.
- `git` warning: install git before using `snapshot`, `history`, or `branch`.
