#!/bin/sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Removals
rm ~/.zshrc

# File copying
mkdir -p ~/.config
cp -r nvim ~/.config/nvim
cp .gitconfig ~/.gitconfig

# Symlinks
ln -s $PWD/.vimrc /home/$USER/.vimrc
ln -s $PWD/nvim/coc-settings.json /home/$USER/.config/nvim/coc-settings.json
ln -s $PWD/.zshrc /home/$USER/.zshrc

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Plugins/Packages
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
