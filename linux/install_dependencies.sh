#!/bin/sh

set -e

PACKAGES="zsh tmux git curl fzf fd-find ripgrep zoxide wget gnupg btop gcc g++ unzip"

sudo apt-get update

# The git-core PPA only exists for Ubuntu. On Debian and anything else apt-based,
# add-apt-repository would point at a release that isn't published and break
# apt-get update, so use the git the distro ships instead.
ID=""
if [ -r /etc/os-release ]; then . /etc/os-release; fi

if [ "$ID" = ubuntu ]; then
  if sudo apt-get install -y software-properties-common &&
    sudo add-apt-repository -y ppa:git-core/ppa; then
    sudo apt-get update
  else
    echo "Couldn't add the git PPA; falling back to the distro's git." >&2
  fi
fi

sudo apt-get install -y $PACKAGES
