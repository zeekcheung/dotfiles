if status is-interactive
    # Commands to run in interactive sessions can go here

    # remove greeting message
    set -g fish_greeting ""

    # add newline after each command
    function add_newline --on-event fish_postexec
        echo
    end

    starship init fish | source
    zoxide init fish | source
    alias cd z
end
