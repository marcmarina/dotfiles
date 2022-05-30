#!/bin/sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# File copying
mkdir -p ~/.config
cat .gitconfig >> ~/.gitconfig

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
rm ~/.zshrc

# Symlinks
ln -s $PWD/.zshrc /home/$USER/.zshrc
ln -s $PWD/.vimrc /home/$USER/.vimrc
ln -s $PWD/.tmux.conf /home/$USER/.tmux.conf
ln -s $PWD/nvim /home/$USER/.config/nvim
ln -s $PWD/.tool-versions /home/$USER/.tool-versions

# Plugins/Packages
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
