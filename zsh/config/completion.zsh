ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
mkdir -p $ZSH_CACHE_DIR

# Enable auto completion
autoload -U compinit
compinit -d $ZSH_CACHE_DIR/.zcompdump

# Load advanced auto completion module
zmodload zsh/complist

# Auto completion options
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" squeeze-slashes true
zstyle ":completion:*" file-sort change
zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"

# Use shift-tab to access previous completion
bindkey '^[[Z' reverse-menu-complete
