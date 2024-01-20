export EDITOR=nvim

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

# nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse
--inline-info
--ansi
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
--preview='bat --color=always {}'
--preview-window=right,60%
"

