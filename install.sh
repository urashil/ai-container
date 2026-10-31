#!/usr/bin/env bash
# ./install.sh            link `container` into ~/.local/bin and run the one-time root setup (asks for your sudo password)
# ./install.sh --no-root  only the link
set -euo pipefail
[ "$(id -u)" -ne 0 ] || { echo "run this as your normal user; setup uses sudo where it needs root" >&2; exit 1; }
here=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$HOME/.local/bin"
ln -sfn "$here/container" "$HOME/.local/bin/container"
echo "container -> $here/container"
if [ "${1:-}" != --no-root ]; then
    "$here/container" setup
fi
