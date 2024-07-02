# Use XDG paths for consolidating configuration locations
# https://wiki.archlinux.org/title/XDG_Base_Directory
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# language environment
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# man pager
set -gx MANPAGER "sh -c 'col -bx | bat --theme=ansi -l man -p'"
set -gx MANROFFOPT -c

# n/node.js
set -gx N_PREFIX $HOME/.n

# path
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $N_PREFIX/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $XDG_DATA_HOME/nvim/mason/bin
fish_add_path $XDG_DATA_HOME/share/bob/nvim-bin

# fzf
set -gx FZF_DEFAULT_OPTS "
--layout=reverse
--inline-info
--ansi
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
--preview='fzf-preview {}'
--preview-window=right,60%
--color=fg:#908caa,bg:#232136,hl:#ea9a97
--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
--color=border:#44415a,header:#3e8fb0,gutter:#232136
--color=spinner:#f6c177,info:#9ccfd8,separator:#44415a
--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
"
