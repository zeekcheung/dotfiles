if status is-interactive
    # Commands to run in interactive sessions can go here

    # remove greeting message
    set -g fish_greeting ""

    # proxy
    function proxy
        set -l host_ip (cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
        set -gx http_proxy $host_ip:10809
        set -gx https_proxy $host_ip:10809

        git config --global http.proxy $host_ip:10809
        git config --global https.proxy $host_ip:10809

        echo "Proxy enabled"
    end

    function unproxy
        set -e http_proxy
        set -e https_proxy

        git config --global --unset http.proxy
        git config --global --unset https.proxy

        echo "Proxy disabled"
    end
    
    # starship
    set -gx STARSHIP_CONFIG ~/.config/starship/config.toml
    starship init fish | source

    # zoxide
    zoxide init fish | source
end

# Nvim
fish_add_path $HOME/.local/share/nvim/mason/bin

# ~/.config/nvchad
function nvchad
    env NVIM_APPNAME=nvchad nvim
end

# ~/.config/lazyvim
function lazyvim
    env NVIM_APPNAME=lazyvim nvim
end

# Rust
fish_add_path $HOME/.cargo/bin

# Go
set -gx GOPATH $HOME/code/go
set -gx GOBIN $GOPATH/bin
fish_add_path /usr/local/go/bin
fish_add_path $GOBIN

# NodeJS
set -U nvm_default_version v20.11.0
fish_add_path $HOME/.local/share/nvm/v20.11.0/bin

# Deno
set -gx DENO_INSTALL $HOME/.deno
fish_add_path $DENO_INSTALL/bin

# pnpm
set -gx PNPM_HOME $HOME/.local/share/pnpm
if not string match -q -- $PNPM_HOME $PATH
    fish_add_path $PNPM_HOME
end
alias pn=pnpm

# Alias
alias cat batcat

alias la "eza -a --git --icons --group-directories-first"
alias ls "eza --git --icons --group-directories-first"
alias ll "eza -l --git --icons --group-directories-first"

alias vi nvim
alias lua luajit
alias python python3

alias bashls bash-language-server
alias dockerls docker-langserver
alias html vscode-html-language-server
alias cssls vscode-css-language-server
alias emmet_ls emmet-ls
alias jsonls vscode-json-languge-server
alias lua_ls lua-language-server
alias prismals prisma-language-server
alias ruff_lsp ruff-lsp
alias tailwindcss tailwindcss-language-server
alias tsserver typescript-language-server
alias volar vue-language-server
alias yamlls yaml-language-server

alias gg lazygit
alias ga "git add"
alias gb "git branch"
alias gc "git commit"
alias gd "git diff"
alias gl "git log"
alias gp "git pull && git push"
alias gs "git stash"
alias gt "git status"

alias apt "sudo apt"
alias update "sudo apt update && sudo apt upgrade"
