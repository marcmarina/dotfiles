# Absolute path to script folder
SCRIPTPATH=$(dirname $(readlink -f "$0"))

ln -s $SCRIPTPATH/.tool-versions $HOME/.tool-versions

asdf plugin add nodejs
asdf plugin add yarn
asdf plugin add lazygit
asdf plugin add kubectl
asdf plugin add k9s https://github.com/looztra/asdf-k9s
asdf plugin add lazydocker https://github.com/comdotlinux/asdf-lazydocker.git

asdf install
