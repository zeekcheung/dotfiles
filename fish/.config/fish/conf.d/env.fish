# language environment
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# n/node.js
set -gx N_PREFIX $HOME/.n

# fzf
set -gx FZF_DEFAULT_OPTS "
--layout=reverse
--inline-info
--ansi
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
--preview='bat --color=always {}'
--preview-window=right,60%
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"
