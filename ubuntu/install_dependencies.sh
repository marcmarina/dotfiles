#!/bin/sh

set -e

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa

sudo apt-get update
sudo apt-get install -y zsh tmux git curl fzf fd-find ripgrep zoxide wget gnupg btop gcc g++ unzip
