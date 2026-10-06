#!/bin/sh

set -e

if [ -x /opt/homebrew/bin/brew ]; then
  BREW=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
  BREW=/usr/local/bin/brew
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW=/opt/homebrew/bin/brew
  [ -x "$BREW" ] || BREW=/usr/local/bin/brew
fi

# Install only what's missing, so reruns don't upgrade or touch anything
missing=""
for pkg in zsh tmux git fzf fd ripgrep zoxide wget gnupg btop; do
  "$BREW" list --formula "$pkg" >/dev/null 2>&1 || missing="$missing $pkg"
done
[ -z "$missing" ] || "$BREW" install $missing
