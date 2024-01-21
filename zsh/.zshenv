# Manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/tpm

export PATH=$HOME/.local/share/nvim/mason/bin:$PATH

# ~/.config/nvchad
function nvchad {
	env NVIM_APPNAME=nvchad nvim
}

# ~/.config/lazyvim
function lazyvim {
	env NVIM_APPNAME=lazyvim nvim
}

# Rust
. "$HOME/.cargo/env"

# Go
export GOPATH=$HOME/code/go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH
export PATH=/usr/local/go/bin:$PATH

# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse
--inline-info
--ansi
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
--preview='bat --color=always {}'
--preview-window=right,60%
"
