export ZSH="/home/$USER/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
	git
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
	asdf
	fzf
)

source $ZSH/oh-my-zsh.sh

alias zshconf="nvim ~/.zshrc"

export PATH=$PATH:/home/$USER/Scripts
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore-vcs"
export EDITOR=nvim
