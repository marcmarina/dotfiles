#---------#
# Aliases #
#---------#

alias src="exec $SHELL"
alias zshconf="nvim ~/.zshrc"


#-----------#
# Variables #
#-----------#

export PATH=$PATH:$HOME/.local/bin:/home/$USER/Scripts
export EDITOR=nvim

export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="rg --files --hidden --glob '!.git'"


#-----------#
# Oh My Zsh #
#-----------#

export ZSH="/home/$USER/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
	asdf
	fzf
	git
	sudo
	tmux
	ubuntu
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
