vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4

local default_compiler = 'g++'
local default_compile_args = {
  -- Select a language standard
  '-std=c++23',
  -- Disable compiler extensions
  '-pedantic-errors',
  -- Increase warning level
  '-Wall',
  '-Weffc++',
  '-Wextra',
  '-Wconversion',
  '-Wsign-conversion',
  -- Treat warnings as errors
  '-Werror',
}

---Compile the current file
---@param args? {compiler?:string, compile_args?:string, output?:string, silent?:boolean}
function CompileCurrentFile(args)
  args = args or {}
  local filename = vim.fn.expand '%'
  local compiler = args.compiler or default_compiler
  local compile_args = args.compile_args
  if type(compile_args) == 'table' then
    compile_args = table.concat(compile_args, ' ')
  end
  compile_args = compile_args or table.concat(default_compile_args, ' ')
  local output = args.output or ('bin/' .. vim.fn.fnamemodify(filename, ':t:r'))
  local silent = args.silent or false

  -- Create the output directory if it doesn't exist
  local output_dir = vim.fn.fnamemodify(output, ':h')
  if vim.fn.isdirectory(output_dir) == 0 then
    vim.fn.mkdir(output_dir, 'p')
  end

  local command = string.format('%s %s %s -o %s', compiler, compile_args, filename, output)
  local error = vim.fn.system(command)

  if not silent then
    vim.notify(string.format('Compiling %s...\nCommand: %s', filename, command), vim.log.levels.INFO)
    if error ~= '' then
      vim.notify(error, vim.log.levels.ERROR)
    else
      vim.notify(string.format('Compiled successfully!\nCheck %s.', output), vim.log.levels.INFO)
    end
  end
end

-- Set a custom command to compile the current file
vim.api.nvim_buf_create_user_command(0, 'CompileCurrentFile', ':lua CompileCurrentFile({silent=true})', {})

-- Set a keymap to compile the current file
vim.api.nvim_buf_set_keymap(0, 'n', '<F5>', ':lua CompileCurrentFile({silent=true})<cr>',
  { noremap = true, silent = true })
