export-env { load-env {
    config: ($env.config? | default {} | merge {
        show_banner: false # disable the welcome banner at startup
        ls: {
            use_ls_colors: true
            clickable_links: true
        }
        rm: {
            always_trash: false # always act as if -t was given. Can be overridden with -p
        }
        table: {
            mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
            index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
            show_empty: true
            padding: { left: 1, right: 1 }
            trim: {
                methodology: wrapping # wrapping or truncating
                wrapping_try_keep_words: true
                truncating_suffix: "..." # A suffix used by the 'truncating' methodology
            }
            header_on_separator: false
            # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
        }
        error_style: "fancy" # "fancy" or "plain"
        # datetime_format determines what a datetime rendered in the shell would look like.
        # Behavior without this configuration point will be to "humanize" the datetime display,
        # showing something like "a day ago."
        datetime_format: {
            # normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
            # table: '%m/%d/%y %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
        }
        explore: {
            status_bar_background: {fg: "#1D1F21", bg: "#C4C9C6"},
            command_bar_text: {fg: "#C4C9C6"},
            highlight: {fg: "black", bg: "yellow"},
            status: {
                error: {fg: "white", bg: "red"},
                warn: {}
                info: {}
            },
            table: {
                split_line: {fg: "#404040"},
                selected_cell: {bg: light_blue},
                selected_row: {},
                selected_column: {},
            },
        }
        history: {
            max_size: 100_000 # Session has to be reloaded for this to take effect
            sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
            file_format: "plaintext" # "sqlite" or "plaintext"
            isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
        }
        completions: {
            case_sensitive: false
            quick: true
            partial: true    # set this to false to prevent partial filling of the prompt
            algorithm: "prefix"    # prefix or fuzzy
            external: {
                enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
                max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
                completer: null # check 'carapace_completer' above as an example
            }
        }
        filesize: {
            metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
            format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
        }
        cursor_shape: {
            emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
            vi_insert: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
            vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
        }
        use_grid_icons: true
        footer_mode: "25" # always, never, number_of_rows, auto
        float_precision: 2 # the precision for displaying floats in tables
        buffer_editor: "" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
        use_ansi_coloring: true
        bracketed_paste: true # enable bracketed paste, currently useless on windows
        edit_mode: vi # emacs, vi
        shell_integration: false # enables terminal shell integration. Off by default, as some terminals have issues with this.
        render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
        use_kitty_protocol: false # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
        highlight_resolved_externals: false # true enables highlighting of external commands in the repl resolved by which.
        menus: [
            # Configuration for default nushell menus
            # Note the lack of source parameter
            {
                name: completion_menu
                only_buffer_difference: false
                marker: "| "
                type: {
                    layout: columnar
                    columns: 4
                    col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                    col_padding: 2
                }
                style: {
                    text: green
                    selected_text: green_reverse
                    description_text: yellow
                }
            }
            {
                name: history_menu
                only_buffer_difference: true
                marker: "? "
                type: {
                    layout: list
                    page_size: 10
                }
                style: {
                    text: green
                    selected_text: green_reverse
                    description_text: yellow
                }
            }
            {
                name: help_menu
                only_buffer_difference: true
                marker: "? "
                type: {
                    layout: description
                    columns: 4
                    col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                    col_padding: 2
                    selection_rows: 4
                    description_rows: 10
                }
                style: {
                    text: green
                    selected_text: green_reverse
                    description_text: yellow
                }
            }
        ]
    })
}}