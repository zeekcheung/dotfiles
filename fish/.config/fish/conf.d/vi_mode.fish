# Enable vi mode
set -g fish_key_bindings fish_vi_key_bindings

# Custom bindings
bind -M insert -m default jj cancel repaint-mode
set -g fish_sequence_key_delay_ms 200

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
        bind -M $mode \ef forward-word
    end
end
