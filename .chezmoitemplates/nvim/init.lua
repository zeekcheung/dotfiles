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

-- File names used to identify a root directory
vim.g.root_patterns = {
  ".git",
  "Makefile",
  "CMakeLists.txt",
  "Cargo.toml",
  "go.mod",
  "package.json",
  "pyproject.toml",
}

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
function GetPathFromEnv(env_var, fallback)
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
end)

-- Miscellaneous small but useful functions
now(function()
  -- Makes `:h MiniMisc.put()` and `:h MiniMisc.put_text()` public
  require("mini.misc").setup()

  -- Change current working directory based on the current file path
  MiniMisc.setup_auto_root(vim.g.root_patterns)

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
      snacks = true,
      blink_cmp = true,
      noice = true,
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

  require("mini.statusline").setup({
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 0 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local devinfo_hl = get_devinfo_hl(mode_hl)
        local diagnostics = vim.diagnostic.status()

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

-- Bufferline
now(function()
  add({ { src = "https://github.com/akinsho/bufferline.nvim", name = "bufferline" } })

  require("bufferline").setup({
    options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      indicator = { style = "none" },
      offsets = {
        {
          filetype = "snacks_layout_box",
          text = "Snacks-explorer",
          highlight = "Directory",
          text_align = "left",
        },
      },
      show_duplicate_prefix = false,
      enforce_regular_tabs = true,
      always_show_bufferline = true,
      groups = {
        items = {
          require("bufferline.groups").builtin.pinned:with({ icon = "󰐃" }),
        },
      },
    },
  })

  map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
  map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
  map("n", "<S-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Prev" })
  map("n", "<S-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Next" })
  map("n", "<Leader>bb", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer" })
  map("n", "<Leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Left Buffers" })
  map("n", "<Leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Right Buffers" })
  map("n", "<Leader>bs", "<Cmd>BufferLineSortByDirectory<CR>", { desc = "Sort Buffers by Directory" })
  map("n", "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
  map("n", "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
end)

-- A collection of small QoL plugins
now(function()
  add({ { src = "https://github.com/folke/snacks.nvim", name = "snacks" } })

  require("snacks").setup({
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = {
      preset = {
        -- stylua: ignore
        keys = {
          { icon = " ", key = "d", desc = "Dotfiles", action = ":lua PickDotfiles()", },
          { icon = " ", key = "n", desc = "Notes", action = ":lua PickNotes()", },
          { icon = " ", key = "p", desc = "Projects", action = ":lua PickProjects()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "s", desc = "Restore Session", action = ':lua MiniSessions.select("read")' },
          { icon = " ", key = "x", desc = "Extras", action = ":lua vim.pack.update()" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        function()
          local ms = math.floor((vim.uv.hrtime() - _G.StartTime) / 1e6)
          local str = string.format("  Neovim started in %dms", ms)

          return {
            text = {
              { str, hl = "SnacksDashboardFooter" },
            },
            align = "center",
          }
        end,
      },
    },
    explorer = { enabled = true },
    gitbrowse = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true, only_scope = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = {
      top_down = false,
      -- Avoid icons cannot be rendered properly in the default "compact" style
      icons = { error = "", warn = "", info = "", debug = "", trace = "" },
    },
    picker = {
      -- default layout
      layout = {
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= (vim.o.lines * 2.67) and "default" or "vertical"
        end,
        -- override
        layout = {
          width = 0.8,
          min_width = 70,
          height = 0.8,
          border = "none",
        },
      },
      formatters = {
        file = { filename_first = true },
      },
      win = {
        input = {
          keys = {
            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        files = { hidden = true },
        explorer = {
          layout = {
            layout = { width = 0.3 },
            hidden = { "input", "preview" },
            preview = "main",
          },
          win = {
            list = {
              keys = {
                ["<f2>"] = "explorer_rename",
                ["<LeftRelease>"] = "confirm",
                ["<C-l>"] = { "<cmd>wincmd 2w<CR>", expr = true },
                ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
                ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
              },
            },
          },
          hidden = true,
          exclude = { ".git" },
          include = { "dist" },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scratch = { enabled = true },
    scroll = {
      animate = {
        duration = { step = 5, total = 50 },
      },
      animate_repeat = {
        delay = 100,
        duration = { step = 3, total = 30 },
      },
    },
    statuscolumn = { enabled = true },
    terminal = { win = { wo = { winbar = "" } } },
    util = { enabled = true },
    win = {
      width = 0.85,
      height = 0.85,
      -- border = "rounded",
      -- backdrop = 100,
    },
    words = { enabled = true },
  })

  -- Close terminal window on exit
  new_autocmd("TermClose", "*", function()
    if vim.bo.ft ~= "snacks_terminal" then
      Snacks.bufdelete()
    end
  end, "Close terminal")

  function PickDotfiles()
    Snacks.picker.files({ cwd = GetPathFromEnv("DOT_ROOT", "~/.local/share/chezmoi") })
  end

  function PickNotes()
    Snacks.picker.files({ cwd = GetPathFromEnv("NOTE_ROOT", "~/OneDrive/Notes") })
  end

  function PickProjects()
    Snacks.picker.projects({
      dev = { "~/dev", GetPathFromEnv("PROJECT_ROOT", "~/Projects") },
      patterns = vim.g.root_patterns,
    })
  end

  -- stylua: ignore start
  map("n", "<Leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
  map("n", "<Leader>,", function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
  map("n", "<Leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
  map("n", "<Leader>/", function() Snacks.picker.grep() end, { desc = "Search History" })
  map("n", "<Leader>'", function() Snacks.picker.registers() end, { desc = "Registers" })
  map("n", "<Leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
  map("n", "<Leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })
  map("n", "<Leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
  map("n", "<Leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
  map("n", "<Leader>fb", function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
  map("n", "<Leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
  map("n", "<Leader>ff", function() Snacks.picker.files() end , { desc = "Find Files" })
  map("n", "<Leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
  map("n", "<Leader>fr", function() Snacks.picker.recent() end, { desc = "Find Recent Files" })
  map("n", "<Leader>fd", PickDotfiles, { desc = "Find Dotfiles" })
  map("n", "<Leader>fn", PickNotes, { desc = "Find Note File" })
  map("n", "<Leader>fp", PickProjects, { desc = "Find Projects" })
  map("n", "<Leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
  map("n", "<Leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
  map("n", "<Leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
  map("n", "<Leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
  map("n", "<Leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
  map("n", "<Leader>sc", function() Snacks.picker.commands() end, { desc = "Command" })
  map("n", "<Leader>sC", function() Snacks.picker.command_history() end, { desc = "Command History" })
  map("n", "<Leader>sd", function() Snacks.picker.diagnostics_buffer() end, { desc = "Diagnostic (Buffer)" })
  map("n", "<Leader>sD", function() Snacks.picker.diagnostics() end, { desc = "Diagnostic (Workspace)" })
  map("n", "<Leader>sg", function() Snacks.picker.grep({ hidden = true }) end, { desc = "Grep" })
  map("n", "<Leader>sh", function() Snacks.picker.help() end, { desc = "Help tags" })
  map("n", "<Leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlight groups" })
  map("n", "<Leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
  map("n", "<Leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
  map("n", "<Leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
  map("n", "<Leader>sn", function() Snacks.picker.notifications({ win = { preview = { wo = { wrap = true } } } }) end, { desc = "Notification History" })
  map("n", "<Leader>sr", function() Snacks.picker.resume() end, { desc = "Resume" })
  map("n", "<Leader>sR", function() Snacks.picker.registers() end, { desc = "Registers" })
  map("n", "<Leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "Symbols (Document)" })
  map("n", "<Leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Symbols (Workspace)" })
  map("n", "<Leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep Current Word" })
  map("n", "<Leader>th", function() Snacks.terminal(nil, { win = { position = "bottom", height = 0.5, relative = "editor" } }) end, { desc = "Open terminal horizontally" })
  map("n", "<Leader>tv", function() Snacks.terminal(nil, { win = { position = "right", width = 0.4, relative = "editor" } }) end, { desc = "Open terminal vertically" })
  map("n", "<Leader>tf", function() Snacks.terminal(nil, { win = { position = "float", relative = "editor" } }) end, {desc = "Open terminal floating" })
  map("n", "<Leader>uc", function() Snacks.picker.colorschemes() end, { desc = "Toggle colorschemes" })
  map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
  map("n", "gD", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto Type Definition" })
  map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References" })
  map("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
  Snacks.toggle.option("showtabline", { on = 3, off = 0, global = true }):map("<Leader>ut")
  Snacks.toggle.inlay_hints():map("<leader>uh")
  -- stylua: ignore end
end)

-- Messages, cmdline and the popupmenu
now(function()
  add({
    "https://github.com/folke/noice.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
  })

  require("noice").setup({
    lsp = {
      progress = { enabled = true },
      hover = { enabled = true },
      signature = { enabled = true },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    popupmenu = { enabled = false },
    views = {
      hover = {
        size = {
          max_width = math.floor(vim.o.columns * 0.8),
          max_height = math.floor(vim.o.lines * 0.8),
        },
        scrollbar = false,
      },
      cmdline_popup = {
        size = { max_width = math.floor(vim.o.columns * 0.8) },
      },
    },
    routes = {
      { filter = { mode = "i" }, view = "mini", opts = { skip = true } },
      { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
      { filter = { event = "notify", find = "man.lua" }, opts = { skip = true } },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
            { find = "%d fewer lines" },
            { find = "%d more lines" },
            { find = "E21: Cannot make changes, 'modifiable' is off" },
          },
        },
        opts = { skip = true },
      },
    },
  })
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

-- Coding =====================================================================

-- Completion and signature help
now_if_args(function()
  add({
    -- Keep on semver release. Do not use main/commit, otherwise prebuilt fuzzy binary may fail.
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
    "https://github.com/rafamadriz/friendly-snippets",
  })

  require("blink.cmp").setup({
    fuzzy = {
      -- implementation = "lua",
      sorts = { "exact", "score", "label" },
    },
    keymap = {
      preset = "super-tab",
      ["<CR>"] = {
        function(cmp)
          -- Directly enter new line without select_and_accept for some buffers
          if vim.tbl_contains({ "markdown", "gitcommit" }, vim.bo.ft) then
            return
          end
          if cmp.is_visible() then
            return cmp.select_and_accept()
          end
        end,
        "fallback",
      },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
    },
    completion = {
      keyword = { range = "full" },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      ghost_text = { enabled = false },
      menu = {
        border = "none",
        scrollbar = false,
        draw = {
          align_to = "label",
          -- treesitter = { "lsp" },
          columns = { { "kind_icon" }, { "label" } },
          components = {
            label = {
              text = function(ctx)
                return ctx.label
              end,
            },
            label_detail = {
              text = function(ctx)
                return ctx.label_detail
              end,
            },
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              -- use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              -- use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "none" },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        snippets = {
          score_offset = 0,
        },
        buffer = {
          score_offset = -1,
          opts = {
            get_bufnrs = vim.api.nvim_list_bufs,
          },
          transform_items = function(_, items)
            -- Filter CJK characters
            return vim.tbl_filter(function(item)
              return not item.label:match("[\u{4E00}-\u{9FFF}\u{3040}-\u{309F}\u{30A0}-\u{30FF}\u{AC00}-\u{D7AF}]")
            end, items)
          end,
        },
      },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
    cmdline = {
      enabled = true,
      keymap = {
        -- preset = "inherit",
        ["<CR>"] = {},
        ["<Left>"] = false,
        ["<Right>"] = false,
        ["<Tab>"] = { "insert_next" },
        ["<S-Tab>"] = { "insert_prev" },
      },
      completion = {
        menu = {
          auto_show = function(_)
            return true
          end,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
      },
    },
  })
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

-- Session management
now(function()
  require("mini.sessions").setup()

	-- stylua: ignore start
	map({ "n", "v", "x" }, "<Leader>qd", '<Cmd>lua MiniSessions.select("delete")<CR>', { desc = "Delete Session" })
	map({ "n", "v", "x" }, "<Leader>qn", '<Cmd>lua MiniSessions.write(vim.fn.input("Session name: "))<CR>', { desc = "New Session" })
	map({ "n", "v", "x" }, "<Leader>qs", '<Cmd>lua MiniSessions.select("read")<CR>', { desc = "Select Session" })
	map({ "n", "v", "x" }, "<Leader>qW", '<Cmd>lua MiniSessions.write()<CR>', { desc = "Write Current" })
	map({ "n", "v", "x" }, "<Leader>qr", '<Cmd>lua MiniSessions.restart()<CR>', { desc = "Restart Session" })
  -- stylua: ignore end
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
      { name = "Obsidian", path = GetPathFromEnv("NOTE_ROOT", "~/OneDrive/Notes") },
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
            "Snacks"
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
  local severity_signs = {
    [vim.diagnostic.severity.ERROR] = { sign = " ", hl = "DiagnosticSignError" },
    [vim.diagnostic.severity.WARN] = { sign = " ", hl = "DiagnosticSignWarn" },
    [vim.diagnostic.severity.HINT] = { sign = " ", hl = "DiagnosticSignHint" },
    [vim.diagnostic.severity.INFO] = { sign = " ", hl = "DiagnosticSignInfo" },
  }

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
      text = vim.tbl_map(function(severity)
        return severity.sign
      end, severity_signs),
    },
    status = {
      format = function(severity_counts)
        local items = {}
        for severity in ipairs(vim.diagnostic.severity) do
          local count = severity_counts[severity]
          if count and count ~= 0 then
            table.insert(
              items,
              ("%%#%s#%s%s"):format(severity_signs[severity].hl, severity_signs[severity].sign, count)
            )
          end
        end
        return table.concat(items, " ")
      end,
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
  vim.g.snacks_animate = false

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
