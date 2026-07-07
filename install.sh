#!/bin/sh
# Install a compiled CalKit runtime artifact.
#
# This installer expects to live beside VERSION, SHA256SUMS, and
# calkit-runtime-<version>-macos-<arch>.tar.gz. It installs the runtime under a
# versioned directory and points ~/.local/bin/calkit at that exact binary.

set -eu

prog="install.sh"

info() { printf '%s\n' "$*"; }
step() { printf '==> %s\n' "$*"; }
warn() { printf '%s: warning: %s\n' "$prog" "$*" >&2; }
err() {
	printf '%s: error: %s\n' "$prog" "$*" >&2
	exit 1
}

usage() {
	cat <<'EOF'
Usage: install.sh [--artifact <path>] [-h|--help]

Install the compiled CalKit runtime for this Mac.

Options:
  --artifact <path>  Use this tarball instead of the adjacent platform artifact.
  -h, --help         Show this help.

Environment overrides:
  CALKIT_BIN_DIR     Directory for the calkit symlink (default: ~/.local/bin).
EOF
}

artifact_opt=""
while [ "$#" -gt 0 ]; do
	case "$1" in
	--artifact)
		[ "$#" -ge 2 ] || err "--artifact requires a path"
		artifact_opt="$2"
		shift 2
		;;
	--artifact=*)
		artifact_opt="${1#--artifact=}"
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		err "unknown argument: $1 (try --help)"
		;;
	esac
done

script_dir=$(unset CDPATH; cd -- "$(dirname -- "$0")" && pwd)

os=$(uname -s)
[ "$os" = "Darwin" ] || err "unsupported OS '$os' - CalKit binary releases currently target macOS only."

machine=$(uname -m)
case "$machine" in
arm64 | aarch64) arch="arm64" ;;
x86_64 | amd64 | x64) arch="x64" ;;
*) err "unsupported architecture '$machine' - supported: arm64, x64." ;;
esac
step "Platform: macOS $arch"

command -v git >/dev/null 2>&1 || warn "missing 'git' - install git before using CalKit snapshot/history/branch commands."

version_file="$script_dir/VERSION"
[ -f "$version_file" ] || err "no VERSION file next to installer: $version_file"
IFS= read -r version <"$version_file" || [ -n "${version:-}" ] || err "could not read VERSION"
version=$(printf '%s' "$version" | tr -d '[:space:]')
[ -n "$version" ] || err "VERSION is empty"

if [ -n "$artifact_opt" ]; then
	case "$artifact_opt" in
	/*) tarball="$artifact_opt" ;;
	*) tarball="$(unset CDPATH; cd -- "$(dirname -- "$artifact_opt")" && pwd)/$(basename -- "$artifact_opt")" ;;
	esac
else
	tarball="$script_dir/calkit-runtime-$version-macos-$arch.tar.gz"
fi
[ -f "$tarball" ] || err "artifact not found: $tarball"
tarball_base=$(basename -- "$tarball")
step "Artifact: $tarball_base (v$version)"

command -v shasum >/dev/null 2>&1 || err "'shasum' not found - cannot verify artifact checksum."
sha_file="$script_dir/SHA256SUMS"
[ -f "$sha_file" ] || err "no SHA256SUMS next to installer: $sha_file"
expected=$(awk -v f="$tarball_base" '$2 == f {print $1; exit}' "$sha_file")
[ -n "$expected" ] || err "no checksum entry for '$tarball_base' in SHA256SUMS"
actual=$(shasum -a 256 "$tarball" | awk '{print $1}')
[ "$expected" = "$actual" ] || err "checksum mismatch for $tarball_base"
step "Checksum OK"

runtime_root="$HOME/.calkit-runtime"
version_dir="$runtime_root/$version"
extracted_name="calkit-runtime-$version-macos-$arch"
extracted_dir="$version_dir/$extracted_name"

mkdir -p "$version_dir"
if [ -d "$extracted_dir" ]; then
	info "runtime v$version already present at $extracted_dir - refreshing."
	rm -rf "$extracted_dir"
fi
tar -xzf "$tarball" -C "$version_dir" || err "failed to extract $tarball_base"

installed_bin="$extracted_dir/calkit-bin"
[ -f "$installed_bin" ] || err "artifact has no CalKit binary at $installed_bin"
chmod +x "$installed_bin" 2>/dev/null || true
step "Installed: $installed_bin"

bin_dir="${CALKIT_BIN_DIR:-$HOME/.local/bin}"
mkdir -p "$bin_dir"
link="$bin_dir/calkit"
tmp_link="$link.tmp.$$"
rm -f "$tmp_link"
ln -s "$installed_bin" "$tmp_link"
mv -f "$tmp_link" "$link"
step "Linked: $link -> $installed_bin"

on_path=0
case ":$PATH:" in
*":$bin_dir:"*) on_path=1 ;;
esac

info ""
info "CalKit runtime v$version installed."
info "  runtime: $extracted_dir"
info "  command: $link"
if [ "$on_path" -eq 0 ]; then
	info ""
	info "NOTE: $bin_dir is not on your PATH. Add it, e.g.:"
	info "  echo 'export PATH=\"$bin_dir:\$PATH\"' >> ~/.zshrc && exec \$SHELL"
fi
info ""
info "Verify with: calkit --version"
