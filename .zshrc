export ZSH="/home/$USER/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
	git
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

alias zshconf="nvim ~/.zshrc"

export PATH=$PATH:/home/$USER/Scripts

. $HOME/.asdf/asdf.sh

# prompt_context() {}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
