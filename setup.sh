#!/bin/sh

# Absolute path to script folder
SCRIPTPATH=$(dirname $(readlink -f "$0"))

# Create config folder
mkdir -p ~/.config

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm ~/.zshrc
ln -s $SCRIPTPATH/.zshrc $HOME/.zshrc

# Git
cp .gitconfig-base ~/.gitconfig

# Tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s $SCRIPTPATH/.tmux.conf $HOME/.tmux.conf

# Neovim
ln -s $SCRIPTPATH/nvim $HOME/.config/nvim

# Lazygit
ln -s $SCRIPTPATH/lazygit $HOME/.config/lazygit

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1

