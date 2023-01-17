#!/bin/sh

# Absolute path to script folder
SCRIPTPATH=$(dirname $(readlink -f "$0"))

# File copying
mkdir -p ~/.config
cp .gitconfig-base ~/.gitconfig

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
rm ~/.zshrc

# Symlinks
ln -s $SCRIPTPATH/.zshrc $HOME/.zshrc
ln -s $SCRIPTPATH/.tmux.conf $HOME/.tmux.conf
ln -s $SCRIPTPATH/nvim $HOME/.config/nvim
ln -s $SCRIPTPATH/.tool-versions $HOME/.tool-versions
ln -s $SCRIPTPATH/lazygit $HOME/.config/lazygit

# Plugins/Packages
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
