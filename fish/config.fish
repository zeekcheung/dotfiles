if status is-interactive
    # Commands to run in interactive sessions can go here

    # remove greeting message
    set -g fish_greeting ""
   
    starship init fish | source
    zoxide init fish | source
end

# path
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $N_PREFIX/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.local/share/nvim/mason/bin
