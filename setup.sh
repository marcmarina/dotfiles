sudo apt update
sudo apt install git zsh zsh-syntax-highlighting neovim ripgrep python3

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.config
cp -r nvim ~/.config/nvim

rm ~/.bashrc

ln -s $PWD/.bashrc /home/$USER/.bashrc
ln -s $PWD/.vimrc /home/$USER/.vimrc

source ~/.bashrc

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

rm ~/.zshrc
ln -s $PWD/.zshrc /home/$USER/.zshrc

sudo usermod -s /usr/bin/zsh $USER
zsh
