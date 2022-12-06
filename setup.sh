#!/bin/sh

# Absolute path to script folder
SCRIPTPATH=$(dirname $(readlink -f "$0"))

# File copying
mkdir -p ~/.config
cat .gitconfig >> ~/.gitconfig

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
rm ~/.zshrc

# Symlinks
ln -s $SCRIPTPATH/.zshrc /home/$USER/.zshrc
ln -s $SCRIPTPATH/.tmux.conf /home/$USER/.tmux.conf
ln -s $SCRIPTPATH/nvim /home/$USER/.config/nvim
ln -s $SCRIPTPATH/.tool-versions /home/$USER/.tool-versions
ln -s $SCRIPTPATH/lazygit /home/$USER/.config/lazygit

# Plugins/Packages
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
