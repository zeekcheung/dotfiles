#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias c="clear"
alias ~='cd ~'
alias ..='cd ..'
alias ls='ls --color=auto'
alias l='ls -al'
alias ll='ls -l'
alias la='ls -a'
alias tree="tree -C"
alias open="xdg-open"
alias grep='grep --color=auto'

alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gp="git pull && git push"
alias gt="git status"
alias gg="lazygit"

alias vi='vim'

alias t="tmux"
alias ta="tmux attach -t"
alias td="tmux detach"
alias tk="tmux kill-session -t"
alias tl="tmux ls"
alias tn="tmux new -s"
alias tm="tmux new -A -s main"

PS2='[\u@\h \W]\$ '
