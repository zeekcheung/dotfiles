# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

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

proxy() {
	export https_proxy=http://127.0.0.1:20171 http_proxy=http://127.0.0.1:20171 all_proxy=socks5://127.0.0.1:20170
	echo "proxy on"
}

unproxy() {
	unset https_proxy http_proxy all_proxy
	echo "proxy off"
}

alias zshconfig="nvim ~/.config/zsh"

alias ~="cd ~"
alias ..="cd .."
alias cat="bat"
alias cd="z"
alias grep="rg"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gg="lazygit"
alias gl="git log"
alias gp="git pull && git git push"
alias gt="git status"
alias ipconfig="ifconfig"
alias la="eza -a --git --icons --group-directories-first"
alias ls="eza --git --icons --group-directories-first"
alias ll="eza -l --git --icons --group-directories-first"
alias vi="nvim"

# starship
eval "$(starship init zsh)"
# zoxide
eval "$(zoxide init zsh)"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
