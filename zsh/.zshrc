# shellcheck disable=SC1090,SC1091,SC2034,SC2086,SC2128,SC2155,SC2164,SC2206

# zsh
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
unsetopt AUTO_REMOVE_SLASH
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt EXTENDED_HISTORY

# Autoload
autoload -U compinit
compinit
zmodload zsh/complist
autoload -Uz edit-command-line
zle -N edit-command-line

# Auto completion
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"

# path
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$N_PREFIX/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.local/share/nvim/mason/bin:$PATH

# misc
alias ~="cd ~"
alias ..="cd .."
alias ls="ls --color=auto"
alias l="ls -al"
alias la="ls -a"
alias ll="ls -l"

# git
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gp="git pull && git push"
alias gt="git status"
alias gg="lazygit"

# nvim
alias vi="nvim"
# ~/.config/nvchad
alias nvchad="env NVIM_APPNAME=nvchad nvim"
# ~/.config/lazyvim
alias lazyvim="env NVIM_APPNAME=lazyvim nvim"

# tmux
alias t="tmux"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -t"
alias tl="tmux ls"
alias tn="tmux new -s"
alias tm="tmux new -A -s main"

# kitty
if grep -q "kitty" <<<"$TERM"; then
	alias icat="kitten icat"
fi

# yazi
function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

source $ZDOTDIR/plugins.zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
