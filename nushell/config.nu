# Nushell Config File
#
# version = "0.88.1"

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
  separator: "#d3c6aa"
  leading_trailing_space_bg: { attr: "n" }
  header: { fg: "#a7c080" attr: "b" }
  empty: "#7fbbb3"
  bool: {|| if $in { "#83c092" } else { "light_gray" } }
  int: "#d3c6aa"
  filesize: {|e|
      if $e == 0b {
          "#d3c6aa"
      } else if $e < 1mb {
          "#83c092"
      } else {{ fg: "#7fbbb3" }}
  }
  duration: "#d3c6aa"
  date: {|| (date now) - $in |
      if $in < 1hr {
          { fg: "#e67e80" attr: "b" }
      } else if $in < 6hr {
          "#e67e80"
      } else if $in < 1day {
          "#dbbc7f"
      } else if $in < 3day {
          "#a7c080"
      } else if $in < 1wk {
          { fg: "#a7c080" attr: "b" }
      } else if $in < 6wk {
          "#83c092"
      } else if $in < 52wk {
          "#7fbbb3"
      } else { "dark_gray" }
  }
  range: "#d3c6aa"
  float: "#d3c6aa"
  string: "#d3c6aa"
  nothing: "#d3c6aa"
  binary: "#d3c6aa"
  cellpath: "#d3c6aa"
  row_index: { fg: "#a7c080" attr: "b" }
  record: "#d3c6aa"
  list: "#d3c6aa"
  block: "#d3c6aa"
  hints: "dark_gray"
  search_result: { fg: "#e67e80" bg: "#d3c6aa" }

  shape_and: { fg: "#d699b6" attr: "b" }
  shape_binary: { fg: "#d699b6" attr: "b" }
  shape_block: { fg: "#7fbbb3" attr: "b" }
  shape_bool: "#83c092"
  shape_custom: "#a7c080"
  shape_datetime: { fg: "#83c092" attr: "b" }
  shape_directory: "#83c092"
  shape_external: "#83c092"
  shape_externalarg: { fg: "#a7c080" attr: "b" }
  shape_filepath: "#83c092"
  shape_flag: { fg: "#7fbbb3" attr: "b" }
  shape_float: { fg: "#d699b6" attr: "b" }
  shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
  shape_globpattern: { fg: "#83c092" attr: "b" }
  shape_int: { fg: "#d699b6" attr: "b" }
  shape_internalcall: { fg: "#83c092" attr: "b" }
  shape_list: { fg: "#83c092" attr: "b" }
  shape_literal: "#7fbbb3"
  shape_match_pattern: "#a7c080"
  shape_matching_brackets: { attr: "u" }
  shape_nothing: "#83c092"
  shape_operator: "#dbbc7f"
  shape_or: { fg: "#d699b6" attr: "b" }
  shape_pipe: { fg: "#d699b6" attr: "b" }
  shape_range: { fg: "#dbbc7f" attr: "b" }
  shape_record: { fg: "#83c092" attr: "b" }
  shape_redirection: { fg: "#d699b6" attr: "b" }
  shape_signature: { fg: "#a7c080" attr: "b" }
  shape_string: "#a7c080"
  shape_string_interpolation: { fg: "#83c092" attr: "b" }
  shape_table: { fg: "#7fbbb3" attr: "b" }
  shape_variable: "#d699b6"

  background: "#2f383e"
  foreground: "#d3c6aa"
  cursor: "#d3c6aa"
}

let light_theme = {
  separator: "#dfddc8"
  leading_trailing_space_bg: { attr: "n" }
  header: { fg: "#8da101" attr: "b" }
  empty: "#3a94c5"
  bool: {|| if $in { "#35a77c" } else { "light_gray" } }
  int: "#dfddc8"
  filesize: {|e|
      if $e == 0b {
          "#dfddc8"
      } else if $e < 1mb {
          "#35a77c"
      } else {{ fg: "#3a94c5" }}
  }
  duration: "#dfddc8"
  date: {|| (date now) - $in |
      if $in < 1hr {
          { fg: "#f85552" attr: "b" }
      } else if $in < 6hr {
          "#f85552"
      } else if $in < 1day {
          "#dfa000"
      } else if $in < 3day {
          "#8da101"
      } else if $in < 1wk {
          { fg: "#8da101" attr: "b" }
      } else if $in < 6wk {
          "#35a77c"
      } else if $in < 52wk {
          "#3a94c5"
      } else { "dark_gray" }
  }
  range: "#dfddc8"
  float: "#dfddc8"
  string: "#dfddc8"
  nothing: "#dfddc8"
  binary: "#dfddc8"
  cellpath: "#dfddc8"
  row_index: { fg: "#8da101" attr: "b" }
  record: "#dfddc8"
  list: "#dfddc8"
  block: "#dfddc8"
  hints: "dark_gray"
  search_result: { fg: "#f85552" bg: "#dfddc8" }

  shape_and: { fg: "#df69ba" attr: "b" }
  shape_binary: { fg: "#df69ba" attr: "b" }
  shape_block: { fg: "#3a94c5" attr: "b" }
  shape_bool: "#35a77c"
  shape_custom: "#8da101"
  shape_datetime: { fg: "#35a77c" attr: "b" }
  shape_directory: "#35a77c"
  shape_external: "#35a77c"
  shape_externalarg: { fg: "#8da101" attr: "b" }
  shape_filepath: "#35a77c"
  shape_flag: { fg: "#3a94c5" attr: "b" }
  shape_float: { fg: "#df69ba" attr: "b" }
  shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
  shape_globpattern: { fg: "#35a77c" attr: "b" }
  shape_int: { fg: "#df69ba" attr: "b" }
  shape_internalcall: { fg: "#35a77c" attr: "b" }
  shape_list: { fg: "#35a77c" attr: "b" }
  shape_literal: "#3a94c5"
  shape_match_pattern: "#8da101"
  shape_matching_brackets: { attr: "u" }
  shape_nothing: "#35a77c"
  shape_operator: "#dfa000"
  shape_or: { fg: "#df69ba" attr: "b" }
  shape_pipe: { fg: "#df69ba" attr: "b" }
  shape_range: { fg: "#dfa000" attr: "b" }
  shape_record: { fg: "#35a77c" attr: "b" }
  shape_redirection: { fg: "#df69ba" attr: "b" }
  shape_signature: { fg: "#8da101" attr: "b" }
  shape_string: "#8da101"
  shape_string_interpolation: { fg: "#35a77c" attr: "b" }
  shape_table: { fg: "#3a94c5" attr: "b" }
  shape_variable: "#df69ba"

  background: "#f8f0dc"
  foreground: "#5c6a72"
  cursor: "#5c6a72"
}

# External completer example
# let carapace_completer = {|spans|
#     carapace $spans.0 nushell $spans | from json
# }

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # disable the welcome banner at startup

    ls: {
        use_ls_colors: true # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }

    rm: {
        always_trash: false # always act as if -t was given. Can be overridden with -p
    }

    table: {
        mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
        index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
        show_empty: true # show 'empty list' and 'empty record' placeholders for command output
        padding: { left: 1, right: 1 } # a left right padding of each column in a table
        trim: {
            methodology: wrapping # wrapping or truncating
            wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
            truncating_suffix: "..." # A suffix used by the 'truncating' methodology
        }
        header_on_separator: false # show header text on separator/border line
        # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
    }

    error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

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
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
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

    color_config: $dark_theme # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
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

    hooks: {
        pre_prompt: [{ null }] # run before the prompt is shown
        pre_execution: [{ null }] # run before the repl input is run
        env_change: {
            PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
        command_not_found: { null } # return an error message when a command is not found
    }

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

    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: history_menu }
        }
        {
            name: help_menu
            modifier: none
            keycode: f1
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: help_menu }
        }
        {
            name: completion_previous_menu
            modifier: shift
            keycode: backtab
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menuprevious }
        }
        {
            name: next_page_menu
            modifier: control
            keycode: char_x
            mode: emacs
            event: { send: menupagenext }
        }
        {
            name: undo_or_previous_page_menu
            modifier: control
            keycode: char_z
            mode: emacs
            event: {
                until: [
                    { send: menupageprevious }
                    { edit: undo }
                ]
            }
        }
        {
            name: escape
            modifier: none
            keycode: escape
            mode: [emacs, vi_normal, vi_insert]
            event: { send: esc }    # NOTE: does not appear to work
        }
        {
            name: cancel_command
            modifier: control
            keycode: char_c
            mode: [emacs, vi_normal, vi_insert]
            event: { send: ctrlc }
        }
        {
            name: quit_shell
            modifier: control
            keycode: char_d
            mode: [emacs, vi_normal, vi_insert]
            event: { send: ctrld }
        }
        {
            name: clear_screen
            modifier: control
            keycode: char_l
            mode: [emacs, vi_normal, vi_insert]
            event: { send: clearscreen }
        }
        {
            name: search_history
            modifier: control
            keycode: char_q
            mode: [emacs, vi_normal, vi_insert]
            event: { send: searchhistory }
        }
        {
            name: open_command_editor
            modifier: control
            keycode: char_o
            mode: [emacs, vi_normal, vi_insert]
            event: { send: openeditor }
        }
        {
            name: move_up
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuup}
                    {send: up}
                ]
            }
        }
        {
            name: move_down
            modifier: none
            keycode: down
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menudown}
                    {send: down}
                ]
            }
        }
        {
            name: move_left
            modifier: none
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuleft}
                    {send: left}
                ]
            }
        }
        {
            name: move_right_or_take_history_hint
            modifier: none
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {send: menuright}
                    {send: right}
                ]
            }
        }
        {
            name: move_one_word_left
            modifier: control
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movewordleft}
        }
        {
            name: move_one_word_right_or_take_history_hint
            modifier: control
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintwordcomplete}
                    {edit: movewordright}
                ]
            }
        }
        {
            name: move_to_line_start
            modifier: none
            keycode: home
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolinestart}
        }
        {
            name: move_to_line_start
            modifier: control
            keycode: char_a
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolinestart}
        }
        {
            name: move_to_line_end_or_take_history_hint
            modifier: none
            keycode: end
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {edit: movetolineend}
                ]
            }
        }
        {
            name: move_to_line_end_or_take_history_hint
            modifier: control
            keycode: char_e
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {edit: movetolineend}
                ]
            }
        }
        {
            name: move_to_line_start
            modifier: control
            keycode: home
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolinestart}
        }
        {
            name: move_to_line_end
            modifier: control
            keycode: end
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolineend}
        }
        {
            name: move_up
            modifier: control
            keycode: char_p
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuup}
                    {send: up}
                ]
            }
        }
        {
            name: move_down
            modifier: control
            keycode: char_t
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menudown}
                    {send: down}
                ]
            }
        }
        {
            name: delete_one_character_backward
            modifier: none
            keycode: backspace
            mode: [emacs, vi_insert]
            event: {edit: backspace}
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: backspace
            mode: [emacs, vi_insert]
            event: {edit: backspaceword}
        }
        {
            name: delete_one_character_forward
            modifier: none
            keycode: delete
            mode: [emacs, vi_insert]
            event: {edit: delete}
        }
        {
            name: delete_one_character_forward
            modifier: control
            keycode: delete
            mode: [emacs, vi_insert]
            event: {edit: delete}
        }
        {
            name: delete_one_character_forward
            modifier: control
            keycode: char_h
            mode: [emacs, vi_insert]
            event: {edit: backspace}
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: char_w
            mode: [emacs, vi_insert]
            event: {edit: backspaceword}
        }
        {
            name: move_left
            modifier: none
            keycode: backspace
            mode: vi_normal
            event: {edit: moveleft}
        }
        {
            name: newline_or_run_command
            modifier: none
            keycode: enter
            mode: emacs
            event: {send: enter}
        }
        {
            name: move_left
            modifier: control
            keycode: char_b
            mode: emacs
            event: {
                until: [
                    {send: menuleft}
                    {send: left}
                ]
            }
        }
        {
            name: move_right_or_take_history_hint
            modifier: control
            keycode: char_f
            mode: emacs
            event: {
                until: [
                    {send: historyhintcomplete}
                    {send: menuright}
                    {send: right}
                ]
            }
        }
        {
            name: redo_change
            modifier: control
            keycode: char_g
            mode: emacs
            event: {edit: redo}
        }
        {
            name: undo_change
            modifier: control
            keycode: char_z
            mode: emacs
            event: {edit: undo}
        }
        {
            name: paste_before
            modifier: control
            keycode: char_y
            mode: emacs
            event: {edit: pastecutbufferbefore}
        }
        {
            name: cut_word_left
            modifier: control
            keycode: char_w
            mode: emacs
            event: {edit: cutwordleft}
        }
        {
            name: cut_line_to_end
            modifier: control
            keycode: char_k
            mode: emacs
            event: {edit: cuttoend}
        }
        {
            name: cut_line_from_start
            modifier: control
            keycode: char_u
            mode: emacs
            event: {edit: cutfromstart}
        }
        {
            name: swap_graphemes
            modifier: control
            keycode: char_t
            mode: emacs
            event: {edit: swapgraphemes}
        }
        {
            name: move_one_word_left
            modifier: alt
            keycode: left
            mode: emacs
            event: {edit: movewordleft}
        }
        {
            name: move_one_word_right_or_take_history_hint
            modifier: alt
            keycode: right
            mode: emacs
            event: {
                until: [
                    {send: historyhintwordcomplete}
                    {edit: movewordright}
                ]
            }
        }
        {
            name: move_one_word_left
            modifier: alt
            keycode: char_b
            mode: emacs
            event: {edit: movewordleft}
        }
        {
            name: move_one_word_right_or_take_history_hint
            modifier: alt
            keycode: char_f
            mode: emacs
            event: {
                until: [
                    {send: historyhintwordcomplete}
                    {edit: movewordright}
                ]
            }
        }
        {
            name: delete_one_word_forward
            modifier: alt
            keycode: delete
            mode: emacs
            event: {edit: deleteword}
        }
        {
            name: delete_one_word_backward
            modifier: alt
            keycode: backspace
            mode: emacs
            event: {edit: backspaceword}
        }
        {
            name: delete_one_word_backward
            modifier: alt
            keycode: char_m
            mode: emacs
            event: {edit: backspaceword}
        }
        {
            name: cut_word_to_right
            modifier: alt
            keycode: char_d
            mode: emacs
            event: {edit: cutwordright}
        }
        {
            name: upper_case_word
            modifier: alt
            keycode: char_u
            mode: emacs
            event: {edit: uppercaseword}
        }
        {
            name: lower_case_word
            modifier: alt
            keycode: char_l
            mode: emacs
            event: {edit: lowercaseword}
        }
        {
            name: capitalize_char
            modifier: alt
            keycode: char_c
            mode: emacs
            event: {edit: capitalizechar}
        }
    ]
}

# Starship prompt
use ~/.cache/starship/init.nu

# Commands
let editor = $env.EDITOR
let appdata = $env.APPDATA
let local_appdata = $env.LOCALAPPDATA

def "config alacritty" [] {
  run-external $editor ($appdata + '\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json')
}

def "config terminal" [] {
  run-external $editor ($appdata + '\alacritty\alacritty.toml')
}

def "config nvim" [] {
  run-external $editor ($local_appdata + '\nvim')
}

# Aliases
alias ll = ls -l

alias vi = nvim

alias gg = lazygit
alias gt = git status
alias ga = git add
alias gb = git branch
alias gc = git commit
alias gp = git pull & git push
alias gs = git stash
