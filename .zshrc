#---------#
# Aliases #
#---------#

FD_COMMAND="fd"

if ! command -v fd &> /dev/null
then
    FD_COMMAND="fdfind"
    alias fd="fdfind"
fi

alias lg="lazygit"
alias src="exec $SHELL"
alias zshconf="nvim ~/.zshrc"
alias vimconf="nvim ~/.config/nvim/init.vim"


#-----------#
# Variables #
#-----------#

export PATH=$PATH:$HOME/.local/bin:/$HOME/Scripts:/$HOME/dotfiles/scripts
export EDITOR=nvim

export FZF_DEFAULT_COMMAND="$FD_COMMAND --type file --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FD_COMMAND --type d --hidden --follow --exclude .git"

#-----------#
# Oh My Zsh #
#-----------#

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster" # set by `omz`

plugins=(
	asdf
	docker
	docker-compose
	fzf
	git
	npm
	sudo
	tmux
	ubuntu
	pyenv
	yarn
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh


#-----------#
# Functions #
#-----------#

# Get all commit authors with the given names
function gitauthors {
	names=""
	for var in "$@"
	do
		if [ "$var" = "$1" ]; then
			names="$var"
		else
			names="$names|$var"
		fi
	done
	git log --pretty="Co-authored-by: %an <%ae>" | sort | uniq | grep -iE "$names"
}

# Confirmation prompt
function confirm {
	echo "Are you sure? [y/N]"
	read 'confirm?> '
	if [[ $confirm == "y" || $confirm == "Y" || $confirm == "yes" || $confirm == "Yes" ]]
	then
		true
	else
		false
	fi
}
