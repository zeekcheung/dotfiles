if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Fish
set -g fish_greeting ""

function fish_postcmd --on-event fish_postexec
  echo
end
# Fish end

# Proxy
function proxy 
	set -l host_ip (cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
	set -gx http_proxy $host_ip:10809
	set -gx https_proxy $host_ip:10809
	echo "Proxy enabled"
end

function unproxy 
	set -e http_proxy
	set -e https_proxy
	echo "Proxy disabled"
end
# Proxy end


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
