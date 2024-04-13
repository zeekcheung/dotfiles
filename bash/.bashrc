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

# default prompt
# PS2='[\u@\h \W]\$ '

# custom prompt like starship without git branch
# PS1='\[\e[1m\e[33m\]\u \[\e[1m\e[36m\]\w\n\[\e[1m\e[32m\]❯ \[\e[0m\]'

parse_git_branch() {
	# Check if the current directory is a Git repository
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		# Retrieve the name of the current branch
		local branch_name
		branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)
		if [ -n "$branch_name" ]; then
			echo -e "\e[1;37mon \e[1;35m \e[0m\e[1;35m$branch_name\e[0m"
		fi
	fi
}

# custom prompt like starship with git branch
PS1='\[\e[1m\e[33m\]\u \[\e[1m\e[36m\]\w\[\e[0m\]\[\e[1m\e[32m\] $(parse_git_branch)\[\e[1m\]\n\[\e[1m\e[32m\]❯ \[\e[0m\]'

# add a newline before each prompt except the first line
PROMPT_COMMAND="export PROMPT_COMMAND=echo"
alias clear="unset PROMPT_COMMAND; clear; PROMPT_COMMAND='export PROMPT_COMMAND=echo'"
