export-env { load-env {
    config: ($env.config? | default {} | merge {
        hooks: {
            pre_prompt: [{ null }] # run before the prompt is shown
            pre_execution: [{ null }] # run before the repl input is run
            env_change: {
                PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
            }
            display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
            command_not_found: { null } # return an error message when a command is not found
        }
    })
}}