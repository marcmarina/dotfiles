sudo apt purge -y zsh git neovim
rm -rf ~/.oh-my-zsh ~/.zshrc ~/.vimrc ~/.zshrc.pre-oh-my-zsh ~/.config/nvim
sudo usermod --shell /usr/bin/bash $USER
