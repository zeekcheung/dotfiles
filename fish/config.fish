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
set PATH /usr/local/go/bin $PATH
set -gx GOPATH $HOME/code/go
set -gx GOBIN $GOPATH/bin
set PATH $GOBIN $PATH
# Go end

# NodeJS
set -U nvm_default_version v18.17.1
# NodeJS end

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
alias pn=pnpm
# pnpm end

# Deno
set -gx DENO_INSTALL "$HOME/.deno"
set PATH $DENO_INSTALL/bin $PATH
# Deno end

# acme.sh
set -gx LE_WORKING_DIR "$HOME/.acme.sh"
function acme.sh
  $HOME/.acme.sh/acme.sh $argv;
end
# acme.sh end
