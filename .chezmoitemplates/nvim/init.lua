-- Markup startup time
_G.StartTime = vim.uv.hrtime()

-- Enable byte-compilation cache for lua config files
if vim.loader then
  vim.loader.enable()
end

-- Disable builtin plugins
vim.g.loaded_gzip = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_tutor = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1

-- Disable builtin providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Helpers ====================================================================

local map = vim.keymap.set

--- Get highlight group
---@param opts vim.api.keyset.get_highlight
local function get_hl(opts)
  return vim.api.nvim_get_hl(0, opts)
end

--- Set highlight group
---@param name string
---@param val vim.api.keyset.highlight
local function set_hl(name, val)
  return vim.api.nvim_set_hl(0, name, val)
end

-- Helper to create a user command
---@param name string
---@param cmd string|fun(args: vim.api.keyset.create_user_command.command_args)
---@param opts? vim.api.keyset.user_command
local function new_usercmd(name, cmd, opts)
  return vim.api.nvim_create_user_command(name, cmd, opts or {})
end

-- Custom autocommand group
local gr = vim.api.nvim_create_augroup("custom-config", {})

-- Helper to create an autocommand
---@param event string|string[] The event(s) to trigger on (e.g., 'BufWritePost')
---@param pattern string|string[]|nil Filter for the event (e.g., '*.lua')
---@param callback function|string The function to run when the event triggers
---@param desc string A short description for the autocommand
local function new_autocmd(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  return vim.api.nvim_create_autocmd(event, opts)
end

-- Add plugin to current session
---@param specs (string|vim.pack.Spec)[] List of plugin specifications
---@param opts? vim.pack.keyset.add Options
local function add(specs, opts)
  opts = opts or {}
  -- Don't need to confirm initial install by default
  opts.confirm = (opts.confirm ~= nil) and opts.confirm or false
  return vim.pack.add(specs, opts)
end

add({ "https://github.com/nvim-mini/mini.nvim" })

local misc = require("mini.misc")

-- Execute immediately.
-- Use for what must be executed during startup.
-- Like colorscheme, statusline, tabline, dashboard, etc.
---@param f function Function to execute
local function now(f)
  -- Errors will be reported as warnings to not block code execution and load all plugins
  misc.safely("now", f)
end

-- Execute a bit later.
-- Use for things not needed during startup.
---@param f function Function to execute
local function later(f)
  -- Errors will be reported as warnings to not block code execution and load all plugins
  misc.safely("later", f)
end

-- Check if nvim is started with file args, like `nvim -- path/to/file`
local has_file_args = vim.fn.argc(-1) > 0

-- Use only if needed during startup when nvim is started with file args, but otherwise delaying is fine
local now_if_args = has_file_args and now or later

-- `vim.pack.add()` hook helper
---@param plugin_name string The name of the plugin to watch
---@param kinds string[] List of change types to monitor (e.g., {'add', 'change'})
---@param callback function The function to run after the plugin is loaded
---@param desc string Description for the hook
local function on_packchanged(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
      return
    end
    if not ev.data.active then
      vim.cmd.packadd(plugin_name)
    end
    callback()
  end
  new_autocmd("PackChanged", "*", f, desc)
end

--- Expand filesystem paths and normalize separators to forward slashes.
--- Handles environment variables (e.g., $HOME) and ~ shorthand.
---@param path string The raw path string to resolve (e.g., "~/Documents")
local function resolve_path(path)
  return vim.fn.expand(path):gsub("\\", "/")
end

-- Get path from env or fallback
---@param env_var string environment variable of path
---@param fallback string fallback path
local function get_path_from_env(env_var, fallback)
  local path = os.getenv(env_var)
  return path and resolve_path(path) or resolve_path(fallback)
end

-- Basics =====================================================================

-- Common configuration presets
now(function()
  -- Make sure MiniBasics can use `<Leader>` key to toggle common options
  vim.g.mapleader = " "

  require("mini.basics").setup({
    options = {
      -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
      extra_ui = true,
      -- Presets for window borders ('single', 'double', ...)
      -- Default 'auto' infers from 'winborder' option
      win_borders = "rounded",
    },
    mappings = {
      -- Basic mappings (better 'jk', save with Ctrl+S, ...)
      basic = true,
      -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
      option_toggle_prefix = "<Leader>u",
      -- Create `<C-hjkl>` mappings for window navigation
      windows = true,
      -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
      move_with_alt = true,
    },
  })

  -- Options ==================================================================

  vim.opt.backup = false
  vim.opt.swapfile = false
  vim.opt.autowrite = true
  vim.opt.autochdir = true
  vim.opt.switchbuf = "useopen,usetab"
  vim.opt.jumpoptions = "stack,view"
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.shiftround = true
  vim.opt.completeopt = "menuone,noselect,fuzzy"
  vim.opt.completetimeout = 100
  vim.opt.inccommand = "nosplit"
  vim.opt.relativenumber = true
  -- vim.opt.scrolloff = 8
  -- vim.opt.sidescrolloff = 8
  vim.opt.wrap = false
  vim.opt.list = false
  vim.opt.wildmode = "noselect:lastused,full"
  vim.opt.winblend = 0
  vim.opt.pumblend = 0
  vim.opt.helpheight = 10
  vim.opt.spelllang = "en_us,cjk"
  -- vim.opt.iskeyword:remove("_")
  vim.opt.foldlevel = 99
  vim.opt.foldmethod = "indent"
  vim.opt.foldtext = "v:lua.FoldText()"
  vim.opt.foldopen:remove({ "hor", "search" })
  vim.opt.statuscolumn = "%!v:lua.StatusColumn()"
  vim.opt.fillchars = {
    fold = " ",
    foldsep = " ",
    foldinner = " ",
    foldopen = "",
    foldclose = "",
    diff = "╱",
    eob = " ",
  }
  vim.opt.sessionoptions = "buffers,curdir,folds,globals,help,skiprtp,tabpages,winsize"

  -- Schedule the setting after `UIEnter` because it can increase startup-time
  new_autocmd("UIEnter", "*", function()
    vim.opt.clipboard = "unnamedplus"
  end, "Sync clipboard between OS and Neovim")

  function FoldText()
    return vim.fn.getline(vim.v.foldstart)
  end

  function ClickFold()
    local pos = vim.fn.getmousepos()
    vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
    vim.cmd("normal! za")
  end

  function StatusColumn()
    local win = vim.g.statusline_winid
    local buf = vim.api.nvim_win_get_buf(win)
    local lnum = vim.v.lnum

    -- Get sign extmarks
    local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, { lnum - 1, 0 }, { lnum - 1, -1 }, {
      details = true,
      type = "sign",
    })

    -- Get signs
    local signs = {}
    for _, mark in ipairs(extmarks) do
      local extmark_details = mark[4] or {}
      local name = extmark_details.sign_hl_group or extmark_details.sign_name or ""
      local kind = (name:find("GitSign") or name:find("MiniDiffSign")) and "git" or "sign"
      if not signs[kind] or (extmark_details.priority or 0) > (signs[kind].priority or 0) then
        signs[kind] = { text = extmark_details.sign_text, texthl = extmark_details.sign_hl_group }
      end
    end

    -- Build left sign
    local left = "  "
    if signs.sign then
      local text = vim.fn.strcharpart(signs.sign.text or "", 0, 2)
      left = text .. string.rep(" ", 2 - vim.fn.strchars(text))
      if signs.sign.texthl then
        left = "%#" .. signs.sign.texthl .. "#" .. left .. "%*"
      end
    end

    -- Build right sign (fold sign)
    local fold_level = vim.fn.foldlevel(lnum)
    local right = "  "
    if fold_level > 0 then
      if vim.fn.foldclosed(lnum) ~= -1 then
        right = "%#Folded# %*"
      elseif signs.git then
        local text = vim.fn.strcharpart(signs.git.text or "", 0, 2)
        right = text .. string.rep(" ", 2 - vim.fn.strchars(text))
        if signs.git.texthl then
          right = "%#" .. signs.git.texthl .. "#" .. right .. "%*"
        end
      end
    end

    -- Build line number
    local num = (vim.wo[win].relativenumber and vim.v.relnum ~= 0) and vim.v.relnum or lnum

    return left .. "%=" .. num .. " " .. "%@v:lua.ClickFold@" .. right .. "%T"
  end

  -- Hide the statusline on startup
  if has_file_args then
    -- Set an empty statusline till mini.statusline loads
    vim.opt.statusline = " "
  else
    -- Hide the statusline on the starter page
    vim.opt.laststatus = 0
  end

  -- Keymaps ==================================================================

  -- Better escape
  map("i", "jj", "<Esc>", { desc = "Better Escape" })

  -- Better indenting
  map("x", "<", "<gv", { desc = "Better Indent" })
  map("x", ">", ">gv", { desc = "Better Outdent" })

  -- Misc
  map("v", "<C-c>", '"+y', { desc = "Copy Selection" })
  map("v", "<C-x>", '"+d', { desc = "Cut Selection" })
  map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
  map({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>", { desc = "Undo" })
  map({ "n", "i", "v" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "Save File" })

  -- Window splits
  map("n", "\\", "<Cmd>split<CR>", { desc = "Horizontal Split" })
  map("n", "|", "<Cmd>vsplit<CR>", { desc = "Vertical Split" })

  -- Buffers
  map("n", "<Tab>", "<Cmd>bn<CR>", { desc = "Next Buffer" })
  map("n", "<S-Tab>", "<Cmd>bp<CR>", { desc = "Previous Buffer" })
  map("n", "<Leader>bd", "<Cmd>:bd<CR>", { desc = "Delete Buffer and Window" })
  map("n", "<Leader>bo", function()
    local cur = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= cur and vim.bo[buf].buflisted then
        pcall(vim.api.nvim_buf_delete, buf, { force = false })
      end
    end
  end, { desc = "Delete Other Buffers" })

  -- Tabs
  map("n", "<Leader><tab><tab>", "<Cmd>tabnew<CR>", { desc = "New Tab" })
  map("n", "<Leader><tab>d", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
  map("n", "<Leader><tab>o", "<Cmd>tabonly<CR>", { desc = "Close Other Tabs" })
  map("n", "<Leader><tab>]", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
  map("n", "<Leader><tab>n", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
  map("n", "<Leader><tab>[", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
  map("n", "<Leader><tab>p", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
  map("n", "<Leader><tab>f", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
  map("n", "<Leader><tab>l", "<Cmd>tablast<CR>", { desc = "Last Tab" })

  -- Terminal
  map("n", "<Leader>th", "<Cmd>horizontal term<CR>", { desc = "Open terminal horizontally" })
  map("n", "<Leader>tv", "<Cmd>vertical term<CR>", { desc = "Open terminal vertically" })
  map("n", "<Leader>tt", "<Cmd>term<CR>", { desc = "Open terminal vertically" })
  map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", remap = true })

  -- Comment
  map("n", "<C-/>", ":norm gcc<CR>", { desc = "Toggle comment", silent = true })
  map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })

  -- LSP
  for _, k in ipairs({ "a", "i", "n", "r", "t", "x" }) do
    vim.keymap.del("n", "gr" .. k)
  end
  vim.keymap.del("x", "gra")
  map("n", "K", function()
    vim.lsp.buf.hover({
      border = "rounded",
      max_width = math.floor(vim.o.columns * 0.8),
      max_height = math.floor(vim.o.lines * 0.8),
    })
  end, { desc = "Hover" })
  map("n", "gd", vim.lsp.buf.definition, { desc = "Source Definition" })
  map("n", "gD", vim.lsp.buf.type_definition, { desc = "Type Definition" })
  map("n", "gr", vim.lsp.buf.references, { desc = "References" })
  map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
  map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })
  map("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
  map("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  map("n", "<Leader>cl", vim.lsp.codelens.run, { desc = "Code Lens" })
  map("n", "<Leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
  map("n", "<Leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "Toggle inlay hints" })

	-- Quickfix/Location
	-- stylua: ignore start
	map("n", "<Leader>xq", function() vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen") end, { desc = "Quickfix list" })
	map("n", "<Leader>xl", function() vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen") end, { desc = "Location list" })
  -- stylua: ignore end

  -- Quit
  map({ "n", "x" }, "<Leader>qw", function()
    vim.cmd(#vim.fn.win_findbuf(vim.api.nvim_get_current_buf()) > 1 and "q" or "bd")
  end, { desc = "Quit Window" })
  map({ "n", "x" }, "<Leader>qq", "<Cmd>qa<CR>", { desc = "Quit All" })

  -- Clear search and stop snippet on escape
  map({ "n", "i", "s" }, "<Esc>", function()
    vim.cmd("noh")
    return "<Esc>"
  end, { expr = true, desc = "Escape and Clear hlsearch" })

  --- Resize the current window in an absolute screen direction.
  --- @param dir "left"|"right"|"up"|"down" The direction to move the window border.
  --- @param amount? number The distance to move (defaults to 1).
  local function resize(dir, amount)
    amount = amount or 1
    local cur_win = vim.api.nvim_get_current_win()
    local has_right = vim.fn.winnr("l") ~= vim.fn.winnr()
    local has_bottom = vim.fn.winnr("j") ~= vim.fn.winnr()

    if dir == "left" or dir == "right" then
      local modifier = (dir == "right") and 1 or -1
      local actual_amount = has_right and (amount * modifier) or -(amount * modifier)
      vim.api.nvim_win_set_width(cur_win, vim.api.nvim_win_get_width(cur_win) + actual_amount)
    elseif dir == "up" or dir == "down" then
      local modifier = (dir == "down") and 1 or -1
      local actual_amount = has_bottom and (amount * modifier) or -(amount * modifier)
      vim.api.nvim_win_set_height(cur_win, vim.api.nvim_win_get_height(cur_win) + actual_amount)
    end
  end

  -- Resizing
  -- stylua: ignore start
  map({ "n", "t" }, "<C-Right>", function() resize("right") end, { desc = "Resize Right" })
  map({ "n", "t" }, "<C-Left>",  function() resize("left")  end, { desc = "Resize Left" })
  map({ "n", "t" }, "<C-Down>",  function() resize("down")  end, { desc = "Resize Down" })
  map({ "n", "t" }, "<C-Up>",    function() resize("up")    end, { desc = "Resize Up" })
  -- stylua: ignore end

  -- Plugins
  map("n", "<Leader>pd", function()
    -- stylua: ignore start
    local inactive = vim
      .iter(vim.pack.get())
      :filter(function(x) return not x.active end)
      :map(function(x) return x.spec.name end)
      :totable()
    -- stylua: ignore end

    vim.pack.del(inactive)
    vim.notify("Deleted " .. #inactive .. " plugins.")
  end, { desc = "Delete Plugins" })
  map("n", "<Leader>pu", vim.pack.update, { desc = "Update Plugins" })

  -- lazygit
  if vim.fn.executable("lazygit") == 1 then
    vim.keymap.set("n", "<Leader>gg", function()
      -- Dimensions
      local width = math.floor(vim.o.columns * 0.75)
      local height = math.floor(vim.o.lines * 0.75)

      -- Create an unlisted, scratch buffer for the terminal
      local buf = vim.api.nvim_create_buf(false, true)

      -- Open the floating window and switch focus to it
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "none",
      })

      -- Open lazygit inside the terminal buffer
      vim.fn.jobstart("lazygit", {
        term = true,
        on_exit = function()
          -- Automatically close the window and delete the buffer when lazygit exits
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end,
      })

      -- Enter terminal mode immediately
      vim.cmd("startinsert")
    end, { desc = "LazyGit" })
  end

  -- Autocmds =================================================================

  -- Better format options
  new_autocmd("FileType", "*", function()
    vim.opt.formatoptions = "rqn1lj"
    vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
  end, "Better format options")

  -- Change tab size to 4 for some languages
  new_autocmd("FileType", { "c", "cpp", "cs", "go", "rust", "python", "fish", "ps1" }, function()
    vim.cmd("setlocal tabstop=4 softtabstop=4 shiftwidth=4")
  end, "4-space indentation")

  -- Better editing experience
  new_autocmd("FileType", { "markdown", "gitcommit" }, function()
    vim.cmd("setlocal tabstop=2 softtabstop=2 shiftwidth=2 formatoptions-=r spell")
  end, "Better editing experience")

  -- Change commentstring for cmd/bat script
  new_autocmd("FileType", "dosbatch", function()
    vim.opt_local.commentstring = ":: %s"
  end, "Commentstring for scripts")

  -- Remove trailing empty line for PowerShell files
  new_autocmd("BufWritePre", { "*.ps1", "*.psm1", "*.psd1" }, function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local last_content = 0
    for i = #lines, 1, -1 do
      if lines[i] ~= "" then
        last_content = i
        break
      end
    end
    if #lines > last_content + 1 then
      vim.api.nvim_buf_set_lines(0, last_content + 1, #lines, false, {})
    end
  end, "Remove trailing empty line")

  -- Check if we need to reload the file when it changed
  new_autocmd({ "FocusGained", "TermClose", "TermLeave" }, "*", function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end, "Reload changed file")

  -- Resize splits if window got resized
  new_autocmd({ "VimResized" }, "*", function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end, "Resize splits")

  -- Close some filetypes with <q>
  new_autocmd(
    "FileType",
    { "checkhealth", "diff", "git", "help", "lspinfo", "notify", "qf", "startuptime", "nvim-undotree" },
    function(event)
      vim.bo[event.buf].buflisted = false
      vim.schedule(function()
        map("n", "q", function()
          vim.cmd("close")
          pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end, {
          buffer = event.buf,
          silent = true,
          desc = "Quit buffer",
        })
      end)
    end,
    "Close with q"
  )

  -- Setup options for terminal windows
  new_autocmd("TermOpen", "*", function()
    vim.opt_local.statuscolumn = ""
  end, "Terminal options")

  -- Close terminal window on exit
  new_autocmd("TermClose", "*", function()
    vim.cmd("bd!")
  end, "Close terminal")
end)

-- Miscellaneous small but useful functions
now(function()
  -- Makes `:h MiniMisc.put()` and `:h MiniMisc.put_text()` public
  require("mini.misc").setup()

  -- Change current working directory based on the current file path
  MiniMisc.setup_auto_root({
    ".git",
    "Makefile",
    "CMakeLists.txt",
    "Cargo.toml",
    "go.mod",
    "package.json",
    "pyproject.toml",
  })

  -- Restore latest cursor position on file open
  MiniMisc.setup_restore_cursor()

  -- Synchronize terminal emulator background with Neovim's background to remove
  -- possibly different color padding around Neovim instance
  -- MiniMisc.setup_termbg_sync()
end)

-- Extra 'mini.nvim' functionality
later(function()
  require("mini.extra").setup()
end)

-- UI =========================================================================

-- Colorscheme
now(function()
  add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  })

  require("catppuccin").setup({
    term_colors = true,
    lsp_styles = {
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
    },
    integrations = {
      mini = true,
    },
  })

  vim.cmd("colorscheme catppuccin-nvim")
end)

-- Icon provider
now(function()
  -- Set up to not prefer extension-based icon for some extensions
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  require("mini.icons").setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
    directory = {
      dist = { glyph = "󱧼", hl = "MiniIconsGreen" },
      build = { glyph = "󱧼", hl = "MiniIconsGreen" },
      src = { glyph = "󰴉", hl = "MiniIconsGreen" },
      [".vscode"] = { glyph = "󰉋", hl = "MiniIconsYellow" },
    },
    extension = {
      ttf = { glyph = "", hl = "MiniIconsRed" },
    },
    file = {
      arch = { glyph = "󰣇", hl = "MiniIconsAzure" },
      config = { glyph = "󰒓", hl = "MiniIconsCyan" },
      env = { glyph = "󰒓", hl = "MiniIconsYellow" },
      profile = { glyph = "󰒓", hl = "MiniIconsGrey" },
      README = { glyph = "󰍔", hl = "MiniIconsBlue" },
      ["README.md"] = { glyph = "󰍔", hl = "MiniIconsBlue" },
      ["README.txt"] = { glyph = "󰍔", hl = "MiniIconsBlue" },
      ["dot_gitconfig"] = { glyph = "󰒓", hl = "MiniIconsGrey" },
      ["dot_ripgreprc"] = { glyph = "󰒓", hl = "MiniIconsGrey" },
      [".chezmoiignore"] = { glyph = "󰒓", hl = "MiniIconsGrey" },
      [".bash_profile"] = { glyph = "", hl = "MiniIconsGreen" },
      [".bashrc"] = { glyph = "", hl = "MiniIconsGreen" },
      [".shellrc"] = { glyph = "", hl = "MiniIconsGreen" },
      [".zshrc"] = { glyph = "", hl = "MiniIconsGreen" },
    },
    filetype = {
      nuon = { glyph = "", hl = "MiniIconsPurple" },
    },
  })

  -- Mock 'nvim-tree/nvim-web-devicons' for plugins without 'mini.icons' support.
  MiniIcons.mock_nvim_web_devicons()

  -- Add LSP kind icons
  MiniIcons.tweak_lsp_kind()
end)

-- Notifications provider
now(function()
  require("mini.notify").setup({
    lsp_progress = {
      enable = false,
    },
    window = {
      config = function()
        local has_statusline = vim.o.laststatus > 0
        local pad = vim.o.cmdheight + (has_statusline and 1 or 0)

        return {
          width = math.floor(vim.o.columns * 0.4),
          anchor = "SE",
          col = vim.o.columns,
          row = vim.o.lines - pad,
          border = "rounded",
        }
      end,
      max_width_share = 0.5,
      winblend = 25,
    },
  })
end)

-- Start screen
now(function()
  local starter = require("mini.starter")

  starter.setup({
    evaluate_single = true,
    items = {
      { name = "Config", action = "Pick config", section = "" },
      { name = "Dotfiles", action = "Pick dotfiles", section = "" },
      { name = "Files", action = "Pick files", section = "" },
      { name = "Grep", action = "Pick grep_live", section = "" },
      { name = "Edit", action = "ene | startinsert", section = "" },
      { name = "Notes", action = "Pick notes", section = "" },
      { name = "Projects", action = "Pick projects", section = "" },
      { name = "Recent", action = "Pick oldfiles", section = "" },
      { name = "Sessions", action = [[lua MiniSessions.select("read")]], section = "" },
      { name = "Xtensions", action = [[lua vim.pack.update()]], section = "" },
      { name = "Quit", action = "qa", section = "" },
    },
    footer = "",
    content_hooks = {
      starter.gen_hook.adding_bullet(" "),
      starter.gen_hook.aligning("center", "center"),
    },

    -- Need to use j/k to navigation so delete them from `query_updaters`
    query_updaters = "abcdefghilmnopqrstuvwxyz0123456789_-.",
    silent = true,
  })

  -- Use j/k to navigation
  new_autocmd("FileType", "ministarter", function(args)
    -- stylua: ignore start
    map("n", "j", function() MiniStarter.update_current_item("next") end, { buffer = args.buf, silent = true })
    map("n", "k", function() MiniStarter.update_current_item("prev") end, { buffer = args.buf, silent = true })
    -- stylua: ignore end
  end, "MiniStarter navigation")

  -- Calculate startup time
  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Calculate startup time",
    once = true,
    callback = function()
      if vim.bo.filetype == "ministarter" then
        local ms = math.floor((vim.uv.hrtime() - _G.StartTime) / 1e6)
        starter.config.footer = string.format("  Neovim started in %dms", ms)
        pcall(starter.refresh)
      end
    end,
  })
end)

-- Statusline
now(function()
  vim.opt.laststatus = 3

  -- Helper to get mode-based colors for Git/Progress sections
  local function get_devinfo_hl(mode_hl)
    local m_hl = get_hl({ name = mode_hl, link = false })
    local d_hl = get_hl({ name = "MiniStatuslineDevinfo" })
    set_hl("MiniStatuslineDevinfo", { fg = m_hl.bg, bg = d_hl.bg })
    return "MiniStatuslineDevinfo"
  end

  -- Helper for colored Diff with icons
  local function diff_section()
    local d = vim.b.minidiff_summary or vim.b.gitsigns_status_dict or {}
    ---@diagnostic disable-next-line: redefined-local
    local add, chg, del = d.add or 0, d.change or 0, d.delete or 0
    if add + chg + del == 0 then
      return ""
    end -- Hide if all are 0

    local parts = {}
    if add > 0 then
      table.insert(parts, string.format("%%#MiniDiffSignAdd# %d", add))
    end
    if chg > 0 then
      table.insert(parts, string.format("%%#MiniDiffSignChange# %d", chg))
    end
    if del > 0 then
      table.insert(parts, string.format("%%#MiniDiffSignDelete# %d", del))
    end

    return table.concat(parts, " ")
  end

  -- Helper for active LSP names
  local function lsp_section()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      return ""
    end
    local names = {}
    for _, client in pairs(clients) do
      table.insert(names, client.name)
    end
    return " " .. table.concat(names, ", ")
  end

  -- Helper for colorizing text
  local function colorful_text(str, hl)
    return string.format("%%#%s#%s", hl, str)
  end

  require("mini.statusline").setup({
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 0 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local devinfo_hl = get_devinfo_hl(mode_hl)

        -- Diagnostics
        local diagnostics = MiniStatusline.section_diagnostics({
          trunc_width = 70,
          icon = "",
          signs = {
            ERROR = colorful_text(" ", "DiagnosticError"),
            WARN = colorful_text(" ", "DiagnosticWarn"),
            INFO = colorful_text(" ", "DiagnosticInfo"),
            HINT = colorful_text(" ", "DiagnosticHint"),
          },
        })

        -- File Stats
        local ft = vim.bo.filetype
        local f_filename = vim.fn.expand("%:p")
        local r_filename = vim.fn.expand("%:.")
        local f_icon, f_hl = MiniIcons.get("file", f_filename)
        local ft_icon, ft_hl = MiniIcons.get("filetype", ft)
        local file_comp = string.format("%%#%s#%s%%#MiniStatuslineFilename# %s", f_hl, f_icon, r_filename)
        local type_comp = string.format("%%#%s#%s%%#MiniStatuslineFilename# %s", ft_hl, ft_icon, ft)
        local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
        local format = ({ unix = "", dos = "", mac = "" })[vim.bo.fileformat] or vim.bo.fileformat
        local progress_pct = math.floor(vim.fn.line(".") / vim.fn.line("$") * 100)
        local progress = progress_pct == 0 and "TOP"
          or progress_pct == 100 and "BOT"
          or string.format("%2d%%%%", progress_pct)
        local location = string.format("%4d:%-3d", vim.fn.line("."), vim.fn.col("."))

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode:upper() } },
          { hl = devinfo_hl, strings = { git } },
          "%<",
          { hl = "MiniStatuslineFilename", strings = { file_comp, diagnostics .. "%#MiniStatuslineFilename#" } },
          "%=",
          { hl = "MiniStatuslineFilename", strings = { diff_section() .. "%#MiniStatuslineFilename#", lsp_section() } },
          { hl = "MiniStatuslineFilename", strings = { type_comp } },
          { hl = "MiniStatuslineFilename", strings = { encoding, string.format(" %s ", format) } },
          { hl = devinfo_hl, strings = { progress } },
          { hl = mode_hl, strings = { location } },
        })
      end,
    },
  })
end)

-- Tabline
now(function()
  -- Click Handlers
  _G.BufSwitch = function(buf, _, btn)
    if btn == "l" then
      vim.api.nvim_set_current_buf(buf)
    end
  end
  _G.BufClose = function(buf, _, btn)
    if btn == "l" then
      _ = MiniBufremove and MiniBufremove.delete(buf, false) or pcall(vim.api.nvim_buf_delete, buf, {})
    end
  end

  local last_click = 0
  local timeout = 300

  _G.BufNew = function()
    local now_click = vim.uv.now()
    if now_click - last_click < timeout then
      vim.cmd("enew")
    end
    last_click = now_click
  end

  -- Tabline Builder
  _G.MyTabline = function()
    local s = ""
    local cur = vim.api.nvim_get_current_buf()

    for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      local is_sel = b.bufnr == cur
      local hl = (b.bufnr == cur) and "%#TabLineSel#" or "%#TabLine#"
      local name = b.name ~= "" and vim.fn.fnamemodify(b.name, ":t") or "[No Name]"

      -- Colorful file icon
      local ic, h = MiniIcons.get("file", name)
      local h_name = h .. "Tab"
      set_hl(h_name, {
        fg = get_hl({ name = h }).fg,
        bg = get_hl({ name = is_sel and "Normal" or "TabLine" }).bg,
      })
      local icon, icon_hl = ic, "%#" .. h_name .. "#"

      -- Close icon or colorized modification dot
      local close = "󰅖"
      local dot_hl = hl -- Default to normal tab text color
      if b.changed == 1 then
        close = "●"
        dot_hl = "%#DiagnosticHint#"
      end

      -- Render tab
      s = s
        .. string.format(
          "%%%d@v:lua.BufSwitch@%s  %s%s %s%s  %%%d@v:lua.BufClose@%s%s  %%X%%X",
          b.bufnr,
          hl,
          icon_hl,
          icon,
          hl,
          name,
          b.bufnr,
          dot_hl,
          close
        )
    end

    -- return s .. "%#TabLineFill#%="
    return s .. "%@v:lua.BufNew@%#TabLineFill#%=%X"
  end

  -- Activation
  vim.opt.showtabline = 2
  vim.opt.tabline = "%!v:lua.MyTabline()"
end)

-- Animation
later(function()
  local mouse_scrolled = false

  for _, dir in ipairs({ "Up", "Down" }) do
    local key = "<ScrollWheel" .. dir .. ">"
    map({ "n", "i", "v" }, key, function()
      mouse_scrolled = true
      return key
    end, { expr = true })
  end

  local animate = require("mini.animate")

  animate.setup({
    scroll = {
      timing = animate.gen_timing.linear({ duration = 20, unit = "total" }),
      subscroll = animate.gen_subscroll.equal({
        predicate = function(total_scroll)
          if mouse_scrolled then
            mouse_scrolled = false
            return false
          end
          return total_scroll > 1
        end,
      }),
    },
    cursor = { enable = false },
    resize = { enable = false },
    open = { enable = false },
    close = { enable = false },
  })

  vim.g.minianimate_disable = true
end)

-- Indent scope
later(function()
  require("mini.indentscope").setup({
    symbol = "│",
    options = {
      try_as_border = true,
    },
  })

  -- Disable Indentscope in MiniStarter
  local function disable_indentscope()
    vim.b.miniindentscope_disable = true
  end
  if vim.bo.filetype == "ministarter" then
    disable_indentscope()
  end
  new_autocmd("FileType", "ministarter", disable_indentscope, "Disable Indentscope in MiniStarter")
end)
-- Highlight patterns in text
later(function()
  local hipatterns = require("mini.hipatterns")

  -- Highlight task comment
  ---@param keyword string highlight pattern keyword
  ---@param group_name string highlight group
  local hi_comment = function(keyword, group_name)
    -- Generate case-insensitive pattern matching to the end of the line
    local pattern = keyword:gsub("%a", function(c)
      return string.format("[%s%s]", c:lower(), c:upper())
    end)

    return {
      pattern = "%f[%w]" .. pattern .. "%f[%W].*",
      group = function(buf_id, _, data)
        -- Fetch the Treesitter node at the start of the match
        local ok, node = pcall(vim.treesitter.get_node, { bufnr = buf_id, pos = { data.line - 1, data.from_col - 1 } })

        if ok and node then
          -- Walk up the syntax tree to see if we are inside a comment
          local n = node ---@type TSNode?
          while n do
            if n:type():find("comment") then
              return group_name
            end
            n = n:parent()
          end
        end

        -- Return nil to skip highlighting if not in a comment
        return nil
      end,
    }
  end

  hipatterns.setup({
    highlighters = {
      -- Highlight task comments
      note = hi_comment("note", "MiniHipatternsNote"),
      todo = hi_comment("todo", "MiniHipatternsTodo"),
      hack = hi_comment("hack", "MiniHipatternsHack"),
      fixme = hi_comment("fixme", "MiniHipatternsFixme"),

      -- Highlight hex color string (#aabbcc) with that color as a background
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Experimental builtin message + cmdline
now(function()
  require("vim._core.ui2").enable({
    enable = true,
    msg = {
      cmd = { height = 0.4 },
      dialog = { height = 0.4 },
      msg = { height = 0.4, timeout = 4000 },
      pager = { height = 1 },
      targets = {
        [""] = "msg",
        empty = "cmd",
        bufwrite = "msg",
        confirm = "cmd",
        emsg = "pager",
        echo = "msg",
        echomsg = "msg",
        echoerr = "pager",
        completion = "cmd",
        list_cmd = "msg",
        lua_error = "pager",
        lua_print = "msg",
        progress = "pager",
        rpc_error = "pager",
        quickfix = "msg",
        search_count = "cmd",
        shell_cmd = "pager",
        shell_err = "pager",
        shell_out = "pager",
        shell_ret = "msg",
        undo = "msg",
        verbose = "pager",
        wildmenu = "cmd",
        wmsg = "msg",
        cmdline = "msg",
      },
    },
  })
end)

-- Autohighlight word under cursor with a customizable delay
later(function()
  require("mini.cursorword").setup({
    delay = 1000,
  })

  set_hl("MiniCursorword", { link = "LspReferenceText" })
  set_hl("MiniCursorwordCurrent", { link = "LspReferenceText" })
end)

-- Coding =====================================================================

-- Completion and signature help
now_if_args(function()
  require("mini.completion").setup({
    -- Disable certain automatic actions (virtually) by setting very high delay time (like 10^7)
    delay = { completion = 100, info = 10 ^ 7, signature = 50 },
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, {
          -- Hide noisy text, prioritize snippets
          kind_priority = { Snippet = 99, Text = -1 },
        })
      end,
    },
  })

  -- Customize info and signature windows
  new_autocmd("User", { "MiniCompletionWindowOpen", "MiniCompletionWindowUpdate" }, function(args)
    -- local kind = args.data.kind ---@type "info"|"signature"
    local win_id = args.data.win_id

    -- vim.wo[win_id].winblend = 25
    local config = vim.api.nvim_win_get_config(win_id)
    config.border = "rounded"
    config.title = ""
    vim.api.nvim_win_set_config(win_id, config)
  end, "Customize info and signature windows")

  -- Set 'omnifunc' for LSP completion only when an LSP attaches
  new_autocmd("LspAttach", nil, function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end, "Set 'omnifunc' for LSP")

  -- Tell LSP servers we support mini.completion features
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- Manage and expand snippets
later(function()
  add({ "https://github.com/rafamadriz/friendly-snippets" })

  -- Define language patterns to work better with 'friendly-snippets'
  local latex_patterns = { "latex/**/*.json", "**/latex.json" }
  local lang_patterns = {
    tex = latex_patterns,
    plaintex = latex_patterns,
    -- Recognize special injected language of markdown tree-sitter parser
    markdown_inline = { "markdown.json" },
  }

  local snippets = require("mini.snippets")
  local config_path = vim.fn.stdpath("config")

  snippets.setup({
    snippets = {
      -- Always load 'snippets/global.json' from config directory
      snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
      -- Load from 'snippets/' directory of plugins, like 'friendly-snippets'
      snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
    },
    mappings = { expand = "", jump_next = "", jump_prev = "", stop = "<esc>" },
    expand = {
      match = function(snips)
        -- Do not match with whitespace to cursor's left
        return snippets.default_match(snips, { pattern_fuzzy = "%S+" })
      end,
      insert = function(snippet)
        return MiniSnippets.default_insert(snippet, {
          empty_tabstop = "",
          empty_tabstop_final = "",
        })
      end,
    },
  })

  -- Show snippets as candidates in 'mini.completion' menu
  MiniSnippets.start_lsp_server()

  -- Clear hl for MiniSessions
  for _, hl in ipairs({
    "MiniSnippetsCurrent",
    "MiniSnippetsCurrentReplace",
    "MiniSnippetsFinal",
    "MiniSnippetsUnvisited",
    "MiniSnippetsVisited",
  }) do
    set_hl(hl, { underdouble = false })
  end

  -- Tab: Completion Menu Next > Snippet Jump Next > Literal Tab
  map("i", "<Tab>", function()
    if vim.fn.pumvisible() ~= 0 then
      -- If completion menu is open, go to next item
      return "<C-n>"
    elseif MiniSnippets.session.get() ~= nil then
      -- If a snippet is active, jump to next stop
      MiniSnippets.session.jump("next")
      return ""
    else
      -- Otherwise, insert a normal tab
      return "<Tab>"
    end
  end, { expr = true, desc = "Smart Tab" })

  -- S-Tab: Completion Menu Prev > Snippet Jump Prev > Literal S-Tab
  map("i", "<S-Tab>", function()
    if vim.fn.pumvisible() ~= 0 then
      return "<C-p>"
    elseif MiniSnippets.session.get() ~= nil then
      MiniSnippets.session.jump("prev")
      return ""
    else
      return "<S-Tab>"
    end
  end, { expr = true, desc = "Smart S-Tab" })
end)

-- Comment lines
later(function()
  require("mini.comment").setup()
end)

-- Move any selection in any direction
later(function()
  require("mini.move").setup()
end)

-- Autopairs functionality
now(function()
  require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { "string" },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  })

  -- Disable mini.surround for some buffers to prevent conflicts
  new_autocmd("FileType", { "markdown" }, function()
    vim.b.minipairs_disable = true
  end, "Disable mini.surround")
end)

-- Surround actions: add/delete/replace/find/highlight
later(function()
  require("mini.surround").setup({
    custom_surroundings = {
      ["("] = { input = { "%b()", "^.%s*().-()%s*.$" }, output = { left = "(", right = ")" } },
      [")"] = { input = { "%b()", "^.().*().$" }, output = { left = "( ", right = " )" } },
      ["["] = { input = { "%b[]", "^.%s*().-()%s*.$" }, output = { left = "[", right = "]" } },
      ["]"] = { input = { "%b[]", "^.().*().$" }, output = { left = "[ ", right = " ]" } },
      ["{"] = { input = { "%b{}", "^.%s*().-()%s*.$" }, output = { left = "{", right = "}" } },
      ["}"] = { input = { "%b{}", "^.().*().$" }, output = { left = "{ ", right = " }" } },
      ["<"] = { input = { "%b<>", "^.%s*().-()%s*.$" }, output = { left = "<", right = ">" } },
      [">"] = { input = { "%b<>", "^.().*().$" }, output = { left = "< ", right = " >" } },
    },
    -- Get behavior closest to 'tpope/vim-surround'
    mappings = {
      add = "ys",
      delete = "ds",
      replace = "cs",
      find = "",
      find_left = "",
      highlight = "",
      suffix_last = "",
      suffix_next = "",
    },
    search_method = "cover_or_next",
  })

  -- Remap adding surrounding to Visual mode selection
  vim.keymap.del("x", "ys")
  vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
end)

-- Extend and create a/i textobjects, like `:h a(`, `:h a'`, and more)
later(function()
  local ai = require("mini.ai")
  ai.setup({
    -- 'mini.ai' can be extended with custom textobjects
    custom_textobjects = {
      -- buffer
      g = MiniExtra.gen_ai_spec.buffer(),
      -- function
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      -- class
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      -- code block
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      -- tag
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    },
    n_lines = 500,
  })
end)

-- Split and join arguments
later(function()
  require("mini.splitjoin").setup({
    mappings = {
      toggle = "gs",
      split = "gS",
      join = "gJ",
    },
  })
end)

-- Align text interactively
later(function()
  require("mini.align").setup()
end)

-- Enhanced increment/decrement
later(function()
  add({ "https://github.com/monaqa/dial.nvim" })

  local augend = require("dial.augend")

  local default_group = {
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.integer.alias.octal,
    augend.integer.alias.binary,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%Y年%-m月%-d日"],
    augend.date.alias["%m/%d"],
    augend.date.alias["%H:%M:%S"],
    augend.date.alias["%H:%M"],
    augend.constant.alias.en_weekday,
    augend.constant.alias.en_weekday_full,
    augend.constant.alias.bool,
    augend.constant.alias.Bool,
    augend.semver.alias.semver,
    augend.date.new({
      pattern = "%Y-%m",
      default_kind = "month",
      only_valid = true,
      word = false,
    }),
    augend.constant.new({
      elements = { "and", "or" },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "start", "end" },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "&&", "||" },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
      -- stylua: ignore
      elements = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
      -- stylua: ignore
      elements = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" },
      word = false,
      cyclic = true,
    }),
  }

  local filetype_groups = {
    typescript = {
      augend.constant.new({ elements = { "let", "const" } }),
    },
    css = {
      augend.hexcolor.new({ case = "lower" }),
      augend.hexcolor.new({ case = "upper" }),
    },
    markdown = {
      augend.constant.new({
        elements = { "[ ]", "[x]" },
        word = false,
        cyclic = true,
      }),
      -- augend.misc.alias.markdown_header,
    },
  }

  -- Register default group
  require("dial.config").augends:register_group({ default = default_group })

  -- Register filetype groups
  for ft, group in pairs(filetype_groups) do
    -- Merge the default_group into the specific filetype group
    vim.list_extend(group, default_group)
    require("dial.config").augends:on_filetype({ [ft] = group })
  end

  map("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", remap = true })
  map("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", remap = true })
  map("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", remap = true })
  map("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", remap = true })
end)

-- Editor ===================================================================

-- Get user input
now(function()
  local input = require("mini.input")
  input.setup({
    handlers = {
      view = input.gen_view.floatwin({
        style = "TM",
        adjust_config = function(_, config)
          local width = math.floor(0.5 * vim.o.columns)

          config.border = "rounded"
          config.width = width
          config.row = math.floor(0.15 * vim.o.lines)
          config.col = math.floor(0.5 * (vim.o.columns - width))
          return config
        end,
      }),
    },
  })
end)

-- Session management
now(function()
  require("mini.sessions").setup()

	-- stylua: ignore start
	map({ "n", "v", "x" }, "<Leader>qd", '<Cmd>lua MiniSessions.select("delete")<CR>', { desc = "Delete Session" })
	map({ "n", "v", "x" }, "<Leader>qn", '<Cmd>lua MiniSessions.write(vim.fn.input("Session name: "))<CR>', { desc = "New Session" })
	map({ "n", "v", "x" }, "<Leader>qs", '<Cmd>lua MiniSessions.select("read")<CR>', { desc = "Select Session" })
	map({ "n", "v", "x" }, "<Leader>qW", '<Cmd>lua MiniSessions.write()<CR>', { desc = "Write Current" })
	map({ "n", "v", "x" }, "<Leader>qr", '<Cmd>lua MiniSessions.restart({ force = true })<CR>', { desc = "Restart Session" })
  -- stylua: ignore end
end)

-- Navigate and manipulate file system
now_if_args(function()
  require("mini.files").setup({
    mappings = {
      go_in = "L",
      go_in_plus = "l",
      synchronize = "<CR>",
    },
    windows = { preview = true },
  })

  -- Customize MiniFiles windows
  new_autocmd("User", "MiniFilesWindowOpen", function(args)
    local win_id = args.data.win_id

    -- vim.wo[win_id].winblend = 25
    local config = vim.api.nvim_win_get_config(win_id)
    config.border = "rounded"
    vim.api.nvim_win_set_config(win_id, config)
  end, "Customize MiniFiles windows")

  map("n", "<Leader>e", function()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end, { desc = "File Explorer (Root)" })

  map("n", "<Leader>E", function()
    local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    vim.schedule(function()
      MiniFiles.reveal_cwd()
    end)
  end, { desc = "File Explorer (CWD)" })
end)

-- Track and reuse file system visits (Better oldfiles & Better marks)
later(function()
  require("mini.visits").setup()
end)

-- Pick anything
later(function()
  require("mini.pick").setup({
    options = { use_cache = true },
    window = {
      config = function()
        local height = math.floor(0.618 * vim.o.lines)
        local width = math.floor(0.618 * vim.o.columns)

        return {
          anchor = "NW",
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
          border = "rounded",
        }
      end,
    },
  })

  -- `:Pick files` with `cwd`
  MiniPick.registry.files = function(local_opts)
    local opts = { source = { cwd = local_opts.cwd } }
    local_opts.cwd = nil
    return MiniPick.builtin.files(local_opts, opts)
  end

  -- `:Pick config`
  MiniPick.registry.config = function()
    return MiniPick.builtin.files({ tool = "fd" }, {
      source = { name = "Config", cwd = vim.fn.stdpath("config") },
    })
  end

  -- `:Pick plugins`
  MiniPick.registry.plugins = function()
    return MiniExtra.pickers.explorer(
      { cwd = resolve_path(vim.fn.stdpath("data") .. "/site/pack/core/opt") },
      { source = { name = "Plugins" } }
    )
  end

  -- `:Pick dotfiles`
  MiniPick.registry.dotfiles = function()
    return MiniPick.builtin.files(nil, {
      source = { name = "Dotfiles", cwd = get_path_from_env("DOT_ROOT", "~/.local/share/chezmoi") },
    })
  end

  -- `:Pick notes`
  MiniPick.registry.notes = function()
    return MiniPick.builtin.files(
      nil,
      { source = { name = "Notes", cwd = get_path_from_env("NOTE_ROOT", "~/OneDrive/Notes") } }
    )
  end

  -- `:Pick projects`
  MiniPick.registry.projects = function()
    return MiniExtra.pickers.explorer(
      { cwd = get_path_from_env("PROJECT_ROOT", "~/projects") },
      { source = { name = "Projects" } }
    )
  end

  map("n", "<Leader><space>", "<Cmd>Pick files<CR>", { desc = "Smart" })
  map("n", "<Leader>:", '<Cmd>Pick history scope=":"<CR>', { desc = "Command History" })
  map("n", "<Leader>/", '<Cmd>Pick history scope="/"<CR>', { desc = "Search History" })
  map("n", "<Leader>fb", "<Cmd>Pick buffers<CR>", { desc = "Buffers" })
  map("n", "<Leader>fc", "<Cmd>Pick config<CR>", { desc = "Config" })
  map("n", "<Leader>fd", "<Cmd>Pick dotfiles<CR>", { desc = "Dotfiles" })
  map("n", "<Leader>ff", "<Cmd>Pick files<CR>", { desc = "Files" })
  map("n", "<Leader>fg", "<Cmd>Pick git_files<CR>", { desc = "Git Files" })
  map("n", "<Leader>fn", "<Cmd>Pick notes<CR>", { desc = "Notes" })
  map("n", "<Leader>fp", "<Cmd>Pick projects<CR>", { desc = "Projects" })
  map("n", "<Leader>fr", "<Cmd>Pick oldfiles<CR>", { desc = "Oldfiles" })
  map("n", "<Leader>gb", "<Cmd>Pick git_branches<CR>", { desc = "Git Branches" })
  map("n", "<Leader>gh", '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', { desc = "Git Hunks (Buffer)" })
  map("n", "<Leader>gH", '<Cmd>Pick git_hunks scope="staged"<CR>', { desc = "Git Hunks (All)" })
  map("n", "<Leader>gm", '<Cmd>Pick git_commits path="%"<CR>', { desc = "Git Commits (Buffer)" })
  map("n", "<Leader>gM", "<Cmd>Pick git_commits<CR>", { desc = "Git Commits (All)" })
  map("n", "<Leader>sc", "<Cmd>Pick commands<CR>", { desc = "Commands" })
  map("n", "<Leader>sC", '<Cmd>Pick history scope=":"<CR>', { desc = "Command History" })
  map("n", "<Leader>sd", '<Cmd>Pick diagnostic scope="current"<CR>', { desc = "Diagnostic (Buffer)" })
  map("n", "<Leader>sD", '<Cmd>Pick diagnostic scope="all"<CR>', { desc = "Diagnostic (Workspace)" })
  map("n", "<Leader>sg", "<Cmd>Pick grep_live<CR>", { desc = "Grep live" })
  map("n", "<Leader>sh", "<Cmd>Pick help<CR>", { desc = "Help tags" })
  map("n", "<Leader>sH", "<Cmd>Pick hl_groups<CR>", { desc = "Highlight groups" })
  map("n", "<Leader>sk", "<Cmd>Pick keymaps<CR>", { desc = "Keymaps" })
  map("n", "<Leader>sl", '<Cmd>Pick buf_lines scope="current"<CR>', { desc = "Lines (Buffer)" })
  map("n", "<Leader>sL", '<Cmd>Pick buf_lines scope="all"<CR>', { desc = "Lines (All)" })
  map("n", "<Leader>sm", "<Cmd>Pick marks<CR>", { desc = "Marks" })
  map("n", "<Leader>sr", "<Cmd>Pick registers<CR>", { desc = "Registers" })
  map("n", "<Leader>sR", "<Cmd>Pick resume<CR>", { desc = "Resume" })
  map("n", "<Leader>ss", '<Cmd>Pick lsp scope="document_symbol"<CR>', { desc = "Symbols (Document)" })
  map("n", "<Leader>sS", '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>', { desc = "Symbols (Workspace)" })
  map("n", "<Leader>sw", '<Cmd>Pick grep pattern="<cword>"<CR>', { desc = "Grep Current Word" })
  map("n", "<Leader>uc", "<Cmd>Pick colorschemes<CR>", { desc = "Toggle colorschemes" })
end)

-- Diff hunks
later(function()
  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "▎", change = "▎", delete = "" },
    },
  })
end)

-- Git integration
later(function()
  require("mini.git").setup()

  -- Customize statusline section_git
  new_autocmd("User", "MiniGitUpdated", function(data)
    -- Use only HEAD name as summary string
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or ""
  end, "Customize statusline section_git")

  -- Align blame output with source
  new_autocmd("User", "MiniGitCommandSplit", function(au_data)
    if au_data.data.git_subcommand ~= "blame" then
      return
    end

    -- Align blame output with source
    local win_src = au_data.data.win_source
    vim.wo.wrap = false
    vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })

    -- Bind both windows so that they scroll together
    vim.wo[win_src].scrollbind = true
    vim.wo.scrollbind = true
  end, "Align git blame")

  local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
  local git_log_buf_cmd = git_log_cmd .. " --follow -- %"

  map("n", "<Leader>ga", "<Cmd>Git add %<CR>", { desc = "Git Add (Buffer)" })
  map("n", "<Leader>gA", "<Cmd>Git add .<CR>", { desc = "Git Add (All)" })
  map("n", "<Leader>gb", "<Cmd>Git branch<CR>", { desc = "Git Branch" })
  map("n", "<Leader>gc", "<Cmd>Git commit<CR>", { desc = "Git Commit" })
  map("n", "<Leader>gC", "<Cmd>Git commit --amend<CR>", { desc = "Git Commit (Amend)" })
  map("n", "<Leader>gd", "<Cmd>Git diff<CR>", { desc = "Git Diff (All)" })
  map("n", "<Leader>gD", "<Cmd>Git diff -- %<CR>", { desc = "Git Diff (Buffer)" })
  map("n", "<Leader>gf", "<Cmd>Git fetch<CR>", { desc = "Git Fetch" })
  map("n", "<Leader>gl", "<Cmd>" .. git_log_cmd .. "<CR>", { desc = "Git Log (All)" })
  map("n", "<Leader>gL", "<Cmd>" .. git_log_buf_cmd .. "<CR>", { desc = "Git Log (Buffer)" })
  map("n", "<Leader>go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", { desc = "Toggle overlay" })
  map("n", "<Leader>gp", "<Cmd>Git push<CR>", { desc = "Git Push" })
  map("n", "<Leader>gP", "<Cmd>Git push --force-with-lease<CR>", { desc = "Git Push (Force)" })
  map("n", "<Leader>gr", "<Cmd>Git rebase<CR>", { desc = "Git Rebase" })
  map("n", "<Leader>gs", "<Cmd>Git stash<CR>", { desc = "Git Stash" })
  map("n", "<Leader>gt", "<Cmd>Git status<CR>", { desc = "Git Status" })
  map("n", "<Leader>gu", "<Cmd>Git pull --rebase<CR>", { desc = "Git Pull (Rebase)" })
end)

-- Show next key clues in a bottom right window
later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = { delay = 200, config = { border = "rounded" } },
    -- Define which clues to show. By default shows only clues for custom mappings
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
      {
        { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
        { mode = "n", keys = "<Leader>c", desc = "+Code" },
        { mode = "n", keys = "<Leader>e", desc = "+Explore" },
        { mode = "n", keys = "<Leader>f", desc = "+Find" },
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = "n", keys = "<Leader>p", desc = "+Plugin" },
        { mode = "n", keys = "<Leader>q", desc = "+Session" },
        { mode = "n", keys = "<Leader>s", desc = "+Search" },
        { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
        { mode = "n", keys = "<Leader>u", desc = "+Toggle" },
        { mode = "n", keys = "<Leader>x", desc = "+Quickfix" },
        { mode = "n", keys = "<Leader><tab>", desc = "+Tab" },
        { mode = "x", keys = "<Leader>g", desc = "+Git" },
      },
    },
    -- Explicitly opt-in for set of common keys to trigger clue window
    triggers = {
      { mode = { "n", "x" }, keys = "<Leader>" }, -- Leader triggers
      { mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
      { mode = { "n", "x" }, keys = "]" },
      { mode = "i", keys = "<C-x>" }, -- Built-in completion
      { mode = { "n", "x" }, keys = "g" }, -- `g` key
      { mode = { "n", "x" }, keys = "'" }, -- Marks
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' }, -- Registers
      { mode = { "i", "c" }, keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" }, -- Window commands
      { mode = { "n", "x" }, keys = "s" }, -- `s` key (mini.surround, etc.)
      { mode = { "n", "x" }, keys = "z" }, -- `z` key
    },
  })
end)

-- Special key mappings
later(function()
  require("mini.keymap").setup()

  -- On `<BS>` just try to account for pairs from 'mini.pairs'
  MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
  -- On `<CR>` try to accept current completion item, fall back to accounting
  -- for pairs from 'mini.pairs'
  MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
end)

-- Go forward/backward with square brackets
later(function()
  require("mini.bracketed").setup()
end)

-- Jump to next/previous single character
later(function()
  require("mini.jump").setup({
    silent = true,
  })
end)

-- Remove buffers
later(function()
  require("mini.bufremove").setup({
    silent = true,
  })

  map("n", "<Leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete Buffer" })
  map("n", "<Leader>bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>", { desc = "Delete Buffer (force)" })
  map("n", "<Leader>bw", "<Cmd>lua MiniBufremove.wipeout()<CR>", { desc = "Wipeout Buffer" })
  map("n", "<Leader>bW", "<Cmd>lua MiniBufremove.wipeout(0, true)<CR>", { desc = "Wipeout Buffer (force)" })
  map("n", "<Leader>bn", function()
    vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
  end, { desc = "New Buffer (Scratch)" })
end)

-- Command line tweaks
later(function()
  require("mini.cmdline").setup({
    autocomplete = { enable = true, delay = 250 },
    autocorrect = { enable = false },
    autopeek = { enable = false },
  })
end)

-- difftool
later(function()
  vim.cmd("packadd nvim.difftool")
end)

-- undotree
later(function()
  vim.cmd("packadd nvim.undotree")
  map("n", "<Leader>uu", require("undotree").open, { desc = "Toggle undotree" })
end)

-- Improve viewing Markdown files
later(function()
  add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

  require("render-markdown").setup({
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    checkbox = {
      render_modes = true,
      unchecked = { icon = " " },
      checked = { icon = "󰄳 " },
    },
    html = { comment = { conceal = false } },
    overrides = {
      buftype = {
        nofile = {
          -- Always conceal hover window
          anti_conceal = { enabled = false },
          code = { border = "hide", style = "normal" },
        },
      },
    },
  })
end)

-- Obsidian 🤝 Neovim
later(function()
  add({ "https://github.com/obsidian-nvim/obsidian.nvim" })

  require("obsidian").setup({
    ui = {
      enable = false,
      checkbox = { order = {} },
      bullets = {},
      external_link_icon = {},
    },
    workspaces = {
      { name = "Obsidian", path = get_path_from_env("NOTE_ROOT", "~/OneDrive/Notes") },
    },
    new_notes_location = "current_dir",
    daily_notes = {
      folder = "daily/journals",
      date_format = "%Y-%m-%d",
      template = "daily-journal.md",
      default_tags = { "daily", "journal" },
      workdays_only = false,
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    footer = { enabled = false },
    picker = { name = "mini.pick" },
    completion = { min_chars = 0, match_case = false },
    legacy_commands = false,
  })

  new_usercmd("Today", "Obsidian today", { desc = "Open today daily note", bang = true })
  new_usercmd("Tomorrow", "Obsidian tomorrow", { desc = "Open tomorrow daily note", bang = true })
  new_usercmd("Yesterday", "Obsidian yesterday", { desc = "Open yesterday daily note", bang = true })
end)

-- TreeSitter =================================================================

now_if_args(function()
  add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  })

  -- Check available languages for installation with `require('nvim-treesitter').get_available()`
  -- stylua: ignore
  local languages = {
    "c", "cpp", "go", "gomod", "gowork", "gosum",
    "javascript", "jsdoc", "tsx", "typescript", "css", "html", "sql",
    "python", "bash", "zsh", "nu", "powershell",
    "json", "json5", "yaml", "toml", "xml", "ini",
    "markdown", "markdown_inline",
    "git_config", "gitcommit", "git_rebase", "gitignore", "gitattributes",
    "lua", "vim", "vimdoc", "query", "diff", "printf", "regex",
  }

  -- Install missing parsers and queries for languages
  local installed = require("nvim-treesitter").get_installed()
  local to_install = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
  end, languages)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  -- Enable tree-sitter for filetypes
  new_autocmd("FileType", "*", function(ev)
    local ok = pcall(vim.treesitter.start, ev.buf)
    if ok then
      -- highlighting
      vim.treesitter.start(ev.buf)
      -- fold
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      -- indent
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end, "Start tree-sitter")

  -- Update tree-sitter parsers after plugin is updated
  on_packchanged("nvim-treesitter", { "update" }, function()
    vim.cmd("TSUpdate")
  end, "Update tree-sitter parsers")

  new_usercmd("TSInfo", "checkhealth nvim-treesitter", { desc = "nvim-treesitter info", bang = true })

  -- Add new filetype mappings
  vim.filetype.add({
    extension = {
      nuon = "nu",
    },
    filename = {
      [".sqruff"] = "toml",
      [".chezmoiignore"] = "conf",
      [".shellrc"] = "sh",
      ["dot_bash_profile"] = "sh",
      ["dot_bash_profile.tmpl"] = "sh",
      ["dot_bashrc"] = "sh",
      ["dot_bashrc.tmpl"] = "sh",
      ["dot_profile"] = "sh",
      ["dot_profile.tmpl"] = "sh",
      ["dot_shellrc"] = "sh",
      ["dot_shellrc.tmpl"] = "sh",
      ["dot_zshrc"] = "zsh",
      ["dot_gitconfig"] = "git_config",
    },
    pattern = {
      [".*%.sh.tmpl"] = "sh",
      [".*%.nu.tmpl"] = "nu",
      [".*/dot_ssh/config"] = "sshconfig",
      [".*/zed/.*%.json"] = "jsonc",
    },
  })
end)

-- LSP ========================================================================

later(function()
  add({ "https://github.com/neovim/nvim-lspconfig" })

  vim.lsp.config("lua_ls", {
    on_attach = function(client, _)
      -- Reduce very long list of triggers for better 'mini.completion' experience
      client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        -- Define runtime properties. Use 'LuaJIT', as it is built into Neovim.
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        workspace = {
          checkThirdParty = false,
          ignoreSubmodules = true,
          library = {
            vim.env.VIMRUNTIME,
            vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
          },
        },
        diagnostics = {
          -- stylua: ignore
          globals = {
            "vim", "MiniBufremove", "MiniCompletion", "MiniExtra", "MiniFiles",
            "MiniIcons", "MiniKeymap", "MiniMisc", "MiniPick", "MiniSessions",
            "MiniStarter", "MiniStatusline", "MiniSnippets", "MiniTabline",
          },
        },
        telemetry = { enable = false },
        codeLens = { enable = true },
        hint = {
          enable = true,
          setType = false,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
      },
    },
  })

  vim.lsp.config("gopls", {
    ---@type lspconfig.settings.gopls
    settings = {
      gopls = {
        gofumpt = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  })

  vim.lsp.config("tsc", {
    settings = {
      typescript = {
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = false },
          parameterNames = {
            enabled = "literals",
            suppressWhenArgumentMatchesName = true,
          },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  })

  vim.lsp.config("oxlint", {
    root_dir = function(bufnr, on_dir)
      -- prefer the top-level oxlint config if it exists (monorepo support)
      local git = vim.fs.root(bufnr, ".git")
      local markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }
      local root = git and vim.fs.root(git, markers) or vim.fs.root(bufnr, markers)
      if root then
        on_dir(root)
      end
    end,
  })

  vim.lsp.config("bashls", { filetypes = { "bash", "sh", "zsh" } })

  vim.lsp.config("powershell_es", {
    bundle_path = resolve_path(vim.env.LOCAL_PSModulePath),
    ---@type lspconfig.settings.powershell_es
    settings = {
      powershell = {
        codeFormatting = {
          preset = "OTBS",
        },
      },
    },
  })

  vim.lsp.config("jsonls", {
    ---@type lspconfig.settings.jsonls
    settings = {
      json = {
				-- stylua: ignore
        schemas = {
          { fileMatch = { "*.json", "*.jsonc" }, allowTrailingComma = true, },
					{ fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
					{ fileMatch = { "tsconfig.json", "tsconfig.*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
					{ fileMatch = { ".prettierrc", "prettier.config.json" }, url = "https://json.schemastore.org/prettierrc.json" },
					{ fileMatch = { ".eslintrc.json", ".eslintrc" }, url = "https://json.schemastore.org/eslintrc.json" },
        },
      },
    },
  })

  vim.lsp.config("yamlls", {
    ---@type lspconfig.settings.yamlls
    settings = {
      redhat = { telemetry = { enabled = false } },
			-- stylua: ignore
			schemas = {
				{ fileMatch = { ".github/workflows/*.yml", ".github/workflows/*.yaml" }, url = "https://json.schemastore.org/github-workflow.json" },
        { fileMatch = { "docker-compose.yml", "docker-compose.yaml" }, url = "https://json.schemastore.org/docker-compose.json" },
      },
    },
  })

  vim.lsp.inlay_hint.enable(true)

  -- stylua: ignore
  vim.lsp.enable({
    "clangd", "zls", "gopls",
    "tsc", "cssls", "html", "oxlint", "sqruff",
    "ty", "ruff", "lua_ls", "bashls", "nushell", "powershell_es",
    "jsonls", "yamlls", "tombi", "marksman", "rumdl",
    "dockerls", "docker_compose_language_service",
  })

  new_usercmd("LspInfo", "checkhealth vim.lsp", { desc = "lsp info", bang = true })

  -- Disable semantic token highlight to prevent the conflicts with treesitter
  new_autocmd("LspAttach", "*", function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end, "Disable semantic token highlight")
end)

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
later(function()
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      priority = 9999,
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
    float = { border = "rounded" },
  })

  set_hl("DiagnosticUnnecessary", { link = "NONE" })
end)

-- Formatting =================================================================

later(function()
  add({ "https://github.com/stevearc/conform.nvim" })

  require("conform").setup({
    default_format_opts = { timeout_ms = 3000, lsp_format = "fallback" },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 3000, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      go = { "gofumpt", "goimports" },
      typescript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      javascript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      vue = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      css = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      scss = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      less = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      html = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      handlebars = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      json = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      jsonc = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      yaml = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      toml = { "oxfmt", "tombi", stop_after_first = true },
      xml = { "xmlformatter" },
      markdown = { "oxfmt", "rumdl", stop_after_first = true },
      ["markdown.mdx"] = { "oxfmt", "rumdl", stop_after_first = true },
      python = { "ruff_format" },
      lua = { "stylua" },
      sh = { "shfmt" },
      nu = { "nufmt" },
    },
  })

  -- stylua: ignore start
  map("n", "<Leader>cf", function() require("conform").format() end, { desc = "Format Buffer" })
  map("x", "<Leader>cf", function() require("conform").format() end, { desc = "Format Selection" })
  map("n", "<Leader>uf", function() vim.b.disable_autoformat = not vim.b.disable_autoformat end, { desc = "Toggle format (Buffer)" })
  map("n", "<Leader>uF", function() vim.g.disable_autoformat = not vim.g.disable_autoformat end, { desc = "Toggle format (Global)" })
  -- stylua: ignore end

  new_usercmd("ConformDisable", function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, { desc = "Disable autoformat-on-save", bang = true })

  new_usercmd("ConformEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, { desc = "Re-enable autoformat-on-save" })
end)

-- Neovide ====================================================================

if vim.g.neovide then
  vim.g.minianimate_disable = true

  vim.g.neovide_floating_corner_radius = 0.2
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_confirm_quit = false

  -- Smooth cursor
  vim.g.neovide_cursor_animation_length = 0.01
  vim.g.neovide_cursor_short_animation_length = 0.15
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_smooth_blink = true
  -- vim.g.neovide_cursor_vfx_mode = "torpedo"

  map("v", "<C-S-c>", '"+y', { desc = "Copy selection" })
  map({ "n", "v" }, "<C-S-v>", '"+p', { desc = "Paste" })
  map({ "c", "i" }, "<C-S-v>", "<c-r>+", { desc = "Paste" })

  -- stylua: ignore
  local function change_scale_factor(delta) vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta end
  -- stylua: ignore
  map("n", "<c-=>", function() change_scale_factor(1.25) end, { desc = "Zoom in" })
  -- stylua: ignore
  map("n", "<c-->", function() change_scale_factor(1/1.25) end, { desc = "Zoom out" })

  -- Set working directory to home if no directory is specified
  new_autocmd("VimEnter", "*", function()
    if #vim.v.argv == 3 then
      vim.api.nvim_set_current_dir(vim.env.HOME)
    end
  end, "Neovide default cwd")

  -- Sync title bar color with background
  new_autocmd("OptionSet", "background", function()
    vim.g.neovide_title_background_color =
      string.format("%x", get_hl({ id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg)

    -- vim.g.neovide_title_text_color = "pink"
  end, "Neovide saync title bar color")
end
