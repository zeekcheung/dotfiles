if status is-interactive
    # Commands to run in interactive sessions can go here

    # remove greeting message
    set -g fish_greeting ""
   
    # starship
    set -gx STARSHIP_CONFIG ~/.config/starship.toml
    starship init fish | source

    # zoxide
    zoxide init fish | source
end

