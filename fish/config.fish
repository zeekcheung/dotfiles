if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Fish
set -g fish_greeting ""

function fish_postcmd --on-event fish_postexec
  echo
end
# Fish end

# Starship
set -gx STARSHIP_CONFIG ~/.config/starship/config.toml
starship init fish | source
# Starship end

# Rust
set PATH $HOME/.cargo/bin $PATH
# Rust end

# Go
set PATH $HOME/go/bin $PATH
# Go end
