#!/bin/sh

set -e

ASDF_VERSION=v0.20.2
ASDF="$HOME/.local/bin/asdf"
# Some plugins call `asdf` themselves, so it must be on PATH
export PATH="$HOME/.local/bin:$PATH"

# Install the asdf binary if missing
if [ ! -x "$ASDF" ]; then
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  case "$(uname -m)" in
    x86_64) arch=amd64 ;;
    aarch64 | arm64) arch=arm64 ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
  esac
  mkdir -p "$HOME/.local/bin"
  curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/$ASDF_VERSION/asdf-$ASDF_VERSION-$os-$arch.tar.gz" | tar -xz -C "$HOME/.local/bin" asdf
fi

# Add a plugin unless it's already added
add_plugin() {
  "$ASDF" plugin list 2>/dev/null | grep -qx "$1" || "$ASDF" plugin add "$@"
}

add_plugin nodejs
add_plugin yarn
add_plugin lazygit
add_plugin kubectl
add_plugin k9s https://github.com/looztra/asdf-k9s
add_plugin lazydocker https://github.com/comdotlinux/asdf-lazydocker.git
add_plugin neovim
add_plugin github-cli
add_plugin helm
add_plugin uv

# Install every version in ~/.tool-versions
cd "$HOME"
"$ASDF" install
