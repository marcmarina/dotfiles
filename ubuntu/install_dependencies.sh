#!/bin/sh

sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:neovim-ppa/stable

sudo apt update
sudo apt install neovim git wget curl zsh tmux ripgrep fzf fd-find gcc g++
