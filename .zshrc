# Oh My Zsh
export ZSH="/home/$USER/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
	asdf
	fzf
	git
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias src="exec $SHELL"
alias zshconf="nvim ~/.zshrc"

# Variables
export PATH=$PATH:/home/$USER/Scripts
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore-vcs"
export EDITOR=nvim
