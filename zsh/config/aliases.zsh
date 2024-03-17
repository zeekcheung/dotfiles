# misc
alias cd="z"
alias ~="cd ~"
alias ..="cd .."
alias ls="eza --color=auto"
# alias ls="ls --color=auto"
alias l="ls -al"
alias la="ls -a"
alias ll="ls -l"
alias tree="eza --tree"
# alias tree="tree -C"

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
