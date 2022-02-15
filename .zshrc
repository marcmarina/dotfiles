#---------#
# Aliases #
#---------#

alias src="exec $SHELL"
alias zshconf="nvim ~/.zshrc"


#-----------#
# Variables #
#-----------#

export PATH=$PATH:/home/$USER/Scripts
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore-vcs"
export EDITOR=nvim


#-----------#
# Oh My Zsh #
#-----------#

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
	git log --pretty="Co-authored-by: %an <%ae>" | sort | uniq | grep -E "$names"
}
