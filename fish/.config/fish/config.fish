if status is-interactive
    # Commands to run in interactive sessions can go here

    # Remove greeting message
    set -g fish_greeting ""

    # Add newline after each command
    function add_newline --on-event fish_postexec
        echo
    end

    fzf --fish | source
    starship init fish | source
    zoxide init fish | source
    alias cd z
end
