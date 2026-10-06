# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew (macOS)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
fi

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
alias vimconf="nvim ~/.config/nvim/init.lua"


#-----------#
# Variables #
#-----------#

export PATH=$HOME/.local/bin:$HOME/Scripts:$HOME/dotfiles/scripts:$PATH
export EDITOR=nvim

export FZF_DEFAULT_COMMAND="$FD_COMMAND --type file --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FD_COMMAND --type d --hidden --follow --exclude .git"

#-----------#
# Oh My Zsh #
#-----------#

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	asdf
	docker
	docker-compose
	fzf
	kubectl
	git
	npm
	sudo
	tmux
	yarn
	zoxide
)

# apt aliases, only where apt exists (Ubuntu/Debian)
(( $+commands[apt] )) && plugins+=(ubuntu)

# Keep these last
plugins+=(zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


#-----------#
# Functions #
#-----------#

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


# VS Code CLI
VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
[[ -d "$VSCODE_BIN" ]] && export PATH="$PATH:$VSCODE_BIN"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
