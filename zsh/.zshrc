# shellcheck disable=SC1091,SC2034,SC2086,SC2155

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

zstyle ':omz:plugins:nvm' lazy yes

# Disable colors in ls.
DISABLE_LS_COLORS="true"

# Enable command auto-correction.
ENABLE_CORRECTION="false"

# Disable marking untracked files under VCS as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Change the command execution time stamp shown in the history command output.
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in $ZSH/plugins/
plugins=(
	git
	zsh-completions
	zsh-autosuggestions
	zsh-syntax-highlighting
	nvm
)

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

case "$XDG_CURRENT_DESKTOP" in
*GNOME*) alias ex="nautilus" ;;
*KDE*) alias ex="dolphin" ;;
*XFCE*) alias ex="thunar" ;;
*) alias ex="xdg-open" ;;
esac

package_exist() {
	command -v "$1" >/dev/null 2>&1
}

if package_exist bat; then
	alias cat="bat"
fi

if package_exist eza; then
	alias la="eza -a --git --icons --group-directories-first"
	alias ls="eza --git --icons --group-directories-first"
	alias ll="eza -l --git --icons --group-directories-first"
else
	alias la="ls -a"
	alias ll="ls -l"
fi

if package_exist git; then
	alias ga="git add"
	alias gb="git branch"
	alias gc="git commit"
	alias gd="git diff"
	alias gl="git log"
	alias gp="git pull && git push"
	alias gt="git status"
fi

if package_exist lazygit; then
	alias gg="lazygit"
fi

if package_exist nvim; then
	alias vi="nvim"
fi

# starship
if package_exist "starship"; then
	eval "$(starship init zsh)"
fi

# zoxide
if package_exist "zoxide"; then
	eval "$(zoxide init zsh)"
	alias cd="z"
fi
