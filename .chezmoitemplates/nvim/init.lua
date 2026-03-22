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

local add = vim.pack.add
local map = vim.keymap.set

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

-- Custom autocommand group
local gr = vim.api.nvim_create_augroup("custom-config", {})

-- Helper to create an autocommand
---@param event string|string[] The event(s) to trigger on (e.g., 'BufWritePost')
---@param pattern string|string[]|nil Filter for the event (e.g., '*.lua')
---@param callback function|string The function to run when the event triggers
---@param desc string A short description for the autocommand
local new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

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

-- Mini ======================================================================

-- Colorscheme
now(function()
  add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

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
  })

  vim.cmd("colorscheme catppuccin-nvim")
end)

-- Common configuration presets
now(function()
  -- Make sure MiniBasics can use `<leader>` key to toggle common options
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
      option_toggle_prefix = "<leader>u",
      -- Create `<C-hjkl>` mappings for window navigation
      windows = true,
      -- Create `<M-hjkl>` mappings for navigation in Insert and Command modes
      move_with_alt = true,
    },
  })

  -- Options ==================================================================

  vim.opt.autowrite = true
  vim.opt.backup = false
  vim.opt.swapfile = false
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.shiftround = true
  vim.opt.foldlevel = 99
  vim.opt.foldmethod = "indent"
  vim.opt.inccommand = "nosplit"
  vim.opt.relativenumber = true
  vim.opt.wrap = false
  vim.opt.list = false
  vim.opt.wildmode = "noselect:lastused,full"
  vim.opt.winblend = 0
  vim.opt.pumblend = 0
  vim.opt.helpheight = 10
  vim.opt.spelllang = "en_us,cjk"

  -- Hide the statusline on startup
  if has_file_args then
    -- Set an empty statusline till mini.statusline loads
    vim.opt.statusline = " "
  else
    -- Hide the statusline on the starter page
    vim.opt.laststatus = 0
  end

  -- Setup clipboard lately for better performance
  later(function()
    vim.o.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
  end)

  -- Keymaps ==================================================================

  -- Better escape
  map("i", "jj", "<esc>", { desc = "Better Escape" })

  -- Better paste
  map("n", "p", '"+p', { desc = "Better paste" })

  -- Better indenting
  map("x", "<", "<gv", { desc = "Better indent" })
  map("x", ">", ">gv", { desc = "Better outdent" })

  -- Misc
  map("v", "<C-c>", '"+y', { desc = "Copy selection" })
  map("v", "<C-x>", '"+d', { desc = "Cut selection" })
  map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
  map({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
  map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

  -- Window splits
  map("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })
  map("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })

  -- Buffers
  map("n", "<Tab>", "<cmd>bn<cr>", { desc = "Next buffer" })
  map("n", "<S-Tab>", "<cmd>bp<cr>", { desc = "Previous buffer" })
  map("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
  map("n", "<leader>bo", function()
    local cur = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= cur and vim.bo[buf].buflisted then
        pcall(vim.api.nvim_buf_delete, buf, { force = false })
      end
    end
  end, { desc = "Delete Other Buffers" })

  -- Tabs
  map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
  map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
  map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
  map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
  map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })

  -- Terminal
  map("n", "<leader>th", "<Cmd>horizontal term<CR>", { desc = "Terminal (horizontal)" })
  map("n", "<leader>tv", "<Cmd>vertical term<CR>", { desc = "Terminal (vertical)" })

	-- Quickfix/Location
	-- stylua: ignore start
	map("n", "<leader>xq", function() vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen") end, { desc = "Quickfix list" })
	map("n", "<leader>xl", function() vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen") end, { desc = "Location list" })
  -- stylua: ignore end

  -- Quit
  map({ "n", "v", "x" }, "<leader>qw", "<cmd>exit<cr>", { desc = "Quit Window" })
  map({ "n", "v", "x" }, "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

  -- Comment
  map("n", "<c-/>", ":norm gcc<CR>", { desc = "Toggle comment", silent = true })
  map("v", "<c-/>", "gc", { desc = "Toggle comment", remap = true })
  map("n", "<c-_>", ":norm gcc<CR>", { desc = "Toggle comment", silent = true })
  map("v", "<c-_>", "gc", { desc = "Toggle comment", remap = true })

  -- Clear search and stop snippet on escape
  map({ "i", "n", "s" }, "<esc>", function()
    vim.cmd("noh")
    return "<esc>"
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
  map("n", "<leader>pd", function()
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
  map("n", "<leader>pu", function()
    vim.pack.update()
    vim.schedule(function()
      vim.notify("confirm update (|:write|) or deny update (|:quit|).")
    end)
  end, { desc = "Update Plugins" })
  map("n", "<leader>ux", [[lua vim.pack.update(nil, { offline = true })]], { desc = "Toggle extensions" })

  -- Autocmds =================================================================

  -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
  -- Do on `FileType` to always override these changes from filetype plugins.
  new_autocmd("FileType", nil, function()
    vim.cmd("setlocal formatoptions-=c formatoptions-=o")
  end, "Proper 'formatoptions'")

  -- Change tab size to 4 for some languages
  new_autocmd("FileType", { "c", "cpp", "cs", "go", "rust", "python", "fish" }, function()
    vim.cmd("setlocal tabstop=4 softtabstop=4 shiftwidth=4")
  end, "4-space indentation")

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
    { "checkhealth", "diff", "git", "help", "lspinfo", "notify", "qf", "startuptime" },
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

  -- Run `chezmoi apply` whenever saving a dotfile
  new_autocmd("BufWritePost", resolve_path("~/.local/share/chezmoi/*"), function()
    local path = vim.fn.expand("%")
    vim.fn.system({ "chezmoi", "apply", "--source-path", path })
  end, "Chezmoi apply")
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
  })

  -- Mock 'nvim-tree/nvim-web-devicons' for plugins without 'mini.icons' support.
  MiniIcons.mock_nvim_web_devicons()

  -- Add LSP kind icons
  MiniIcons.tweak_lsp_kind()
end)

-- Notifications provider
now(function()
  require("mini.notify").setup({
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

-- Session management
now(function()
  require("mini.sessions").setup()

	-- stylua: ignore start
	map({ "n", "v", "x" }, "<leader>qd", '<Cmd>lua MiniSessions.select("delete")<CR>', { desc = "Delete Session" })
	map({ "n", "v", "x" }, "<leader>qn", '<Cmd>lua MiniSessions.write(vim.fn.input("Session name: "))<CR>', { desc = "New Session" })
	map({ "n", "v", "x" }, "<leader>qs", '<Cmd>lua MiniSessions.select("read")<CR>', { desc = "Select Session" })
	map({ "n", "v", "x" }, "<leader>qW", '<Cmd>lua MiniSessions.write()<CR>', { desc = "Write Current" })
  -- stylua: ignore end
end)

-- Start screen
now(function()
  require("mini.starter").setup({
    evaluate_single = true,
    items = {
      { name = "Config files", action = "Pick config_files", section = "" },
      { name = "Dotfiles", action = "Pick dotfiles", section = "" },
      { name = "Extensions", action = [[lua vim.pack.update(nil, { offline = true })]], section = "" },
      { name = "Find files", action = "Pick files", section = "" },
      { name = "Grep live", action = "Pick grep_live", section = "" },
      { name = "New file", action = "ene | startinsert", section = "" },
      { name = "Notes", action = "Pick notes", section = "" },
      { name = "Projects", action = "Pick projects", section = "" },
      { name = "Recent files", action = "Pick oldfiles", section = "" },
      { name = "Sessions", action = [[lua MiniSessions.select("read")]], section = "" },
      { name = "Quit", action = "qa", section = "" },
    },

    -- Need to use j/k to navigation so delete them from `query_updaters`
    query_updaters = "abcdefghilmnopqrstuvwxyz0123456789_-.",
    silent = true,
  })

  -- use j/k to navigation
  new_autocmd("User", "MiniStarterOpened", function()
    map("n", "j", '<Cmd>lua MiniStarter.update_current_item("next")<CR>', { buffer = true, silent = true })
    map("n", "k", '<Cmd>lua MiniStarter.update_current_item("prev")<CR>', { buffer = true, silent = true })
  end, "Navigation for Starter screen")
end)

-- Statusline
now(function()
  vim.opt.laststatus = 3

  require("mini.statusline").setup({
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local filename = MiniStatusline.section_filename({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({
          trunc_width = 75,
          signs = { ERROR = " ", WARN = " ", INFO = " ", HINT = " " },
        })
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        -- local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename, diagnostics } },
          "%=", -- End left alignment
          -- { hl = "MiniStatuslineFilename", strings = { search } },
          { hl = "MiniStatuslineDevinfo", strings = { diff, lsp, fileinfo } },
          { hl = mode_hl, strings = { location } },
        })
      end,
    },
  })
end)

-- Tabline
now(function()
  require("mini.tabline").setup({
    tabpage_section = "right",
  })
end)

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

-- Navigate and manipulate file system
now_if_args(function()
  require("mini.files").setup({
    mappings = {
      go_in = "L",
      go_in_plus = "l",
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

  map("n", "<leader>e", function()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end, { desc = "File Explorer" })
end)

-- Miscellaneous small but useful functions
now(function()
  -- Makes `:h MiniMisc.put()` and `:h MiniMisc.put_text()` public
  require("mini.misc").setup()

  -- Change current working directory based on the current file path
  MiniMisc.setup_auto_root()

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

-- Extend and create a/i textobjects, like `:h a(`, `:h a'`, and more)
later(function()
  local ai = require("mini.ai")
  ai.setup({
    -- 'mini.ai' can be extended with custom textobjects
    custom_textobjects = {
      -- buffer
      b = MiniExtra.gen_ai_spec.buffer(),
      -- function
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      -- class
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    },
    n_lines = 500,
  })
end)

-- Align text interactively
later(function()
  require("mini.align").setup()
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

  require("mini.animate").setup({
    scroll = {
      timing = require("mini.animate").gen_timing.linear({ duration = 150, unit = "total" }),
      subscroll = require("mini.animate").gen_subscroll.equal({
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
end)

-- Go forward/backward with square brackets
later(function()
  require("mini.bracketed").setup()
end)

-- Remove buffers
later(function()
  require("mini.bufremove").setup({
    silent = true,
  })

  map("n", "<leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete Buffer" })
  map("n", "<leader>bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>", { desc = "Delete Buffer (force)" })
  map("n", "<leader>bw", "<Cmd>lua MiniBufremove.wipeout()<CR>", { desc = "Wipeout Buffer" })
  map("n", "<leader>bW", "<Cmd>lua MiniBufremove.wipeout(0, true)<CR>", { desc = "Wipeout Buffer (force)" })
  map("n", "<leader>bn", function()
    vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
  end, { desc = "New Buffer (Scratch)" })
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

-- Command line tweaks
later(function()
  require("mini.cmdline").setup({
    autocomplete = { enable = true, delay = 100 },
    autocorrect = { enable = false },
    autopeek = { enable = false },
  })
end)

-- Comment lines
later(function()
  require("mini.comment").setup()
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

  map("n", "<leader>ga", "<Cmd>Git add %<CR>", { desc = "Git Add (Buffer)" })
  map("n", "<leader>gA", "<Cmd>Git add .<CR>", { desc = "Git Add (All)" })
  map("n", "<leader>gb", "<Cmd>Git branch<CR>", { desc = "Git Branch" })
  map("n", "<leader>gc", "<Cmd>Git commit<CR>", { desc = "Git Commit" })
  map("n", "<leader>gC", "<Cmd>Git commit --amend<CR>", { desc = "Git Commit (Amend)" })
  map("n", "<leader>gd", "<Cmd>Git diff<CR>", { desc = "Git Diff (All)" })
  map("n", "<leader>gD", "<Cmd>Git diff -- %<CR>", { desc = "Git Diff (Buffer)" })
  map("n", "<leader>gf", "<Cmd>Git fetch<CR>", { desc = "Git Fetch" })
  map("n", "<leader>gl", "<Cmd>" .. git_log_cmd .. "<CR>", { desc = "Git Log (All)" })
  map("n", "<leader>gL", "<Cmd>" .. git_log_buf_cmd .. "<CR>", { desc = "Git Log (Buffer)" })
  map("n", "<leader>go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", { desc = "Toggle overlay" })
  map("n", "<leader>gp", "<Cmd>Git push<CR>", { desc = "Git Push" })
  map("n", "<leader>gP", "<Cmd>Git push --force-with-lease<CR>", { desc = "Git Push (Force)" })
  map("n", "<leader>gr", "<Cmd>Git rebase<CR>", { desc = "Git Rebase" })
  map("n", "<leader>gs", "<Cmd>Git stash<CR>", { desc = "Git Stash" })
  map("n", "<leader>gt", "<Cmd>Git status<CR>", { desc = "Git Status" })
  map("n", "<leader>gu", "<Cmd>Git pull --rebase<CR>", { desc = "Git Pull (Rebase)" })
end)

-- Highlight patterns in text
later(function()
  local hipatterns = require("mini.hipatterns")
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      -- Highlight a fixed set of common words. Will be highlighted in any place,
      -- not like "only in comments".
      fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
      hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
      todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
      note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),

      -- Highlight hex color string (#aabbcc) with that color as a background
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Indent scope
later(function()
  require("mini.indentscope").setup({
    symbol = "│",
    options = { try_as_border = true },
  })
end)

-- Jump to next/previous single character
later(function()
  require("mini.jump").setup({
    silent = true,
  })
end)

-- Special key mappings
later(function()
  require("mini.keymap").setup()
  -- On `<CR>` try to accept current completion item, fall back to accounting
  -- for pairs from 'mini.pairs'
  MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
  -- On `<BS>` just try to account for pairs from 'mini.pairs'
  MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
end)

-- Move any selection in any direction
later(function()
  require("mini.move").setup()
end)

-- Autopairs functionality
later(function()
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

  -- Get path from env or fallback
  ---@param env_var string environment variable of path
  ---@param fallback string fallback path
  local function get_path_from_env(env_var, fallback)
    local path = os.getenv(env_var)
    return path and resolve_path(path) or resolve_path(fallback)
  end

  -- `:Pick files` with `fd`
  MiniPick.registry.files = function(local_opts)
    return MiniPick.builtin.cli({
      -- Show hidden files
      command = { "fd", "--type=f", "--no-follow", "--color=never", "--hidden" },
      -- Make `:Pick files` accept `cwd`
      spawn_opts = { cwd = resolve_path(local_opts.cwd or vim.fn.getcwd()) },
    }, {
      source = {
        name = "Files (fd)",
        show = function(buf_id, items, query)
          return MiniPick.default_show(buf_id, items, query, { show_icons = true })
        end,
      },
    })
  end

  -- `:Pick config_files`
  MiniPick.registry.config_files = function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config"), name = "config_files" } })
  end

  -- `:Pick plugins`
  MiniPick.registry.plugins = function()
    MiniExtra.pickers.explorer(
      { cwd = resolve_path(vim.fn.stdpath("data") .. "/site/pack/core/opt") },
      { source = { name = "plugins" } }
    )
  end

  -- `:Pick dotfiles`
  MiniPick.registry.dotfiles = function()
    MiniPick.builtin.files(nil, { source = { cwd = get_path_from_env("DOT_ROOT", "~/dotfiles"), name = "dotfiles" } })
  end

  -- `:Pick notes`
  MiniPick.registry.notes = function()
    MiniPick.builtin.files(nil, { source = { cwd = get_path_from_env("NOTE_ROOT", "~/notes"), name = "notes" } })
  end

  -- `:Pick projects`
  MiniPick.registry.projects = function()
    MiniExtra.pickers.explorer(
      { cwd = get_path_from_env("PROJECT_ROOT", "~/projects") },
      { source = { name = "projects" } }
    )
  end

  map("n", "<leader><space>", "<Cmd>Pick files<CR>", { desc = "Files" })
  map("n", "<leader>:", '<Cmd>Pick history scope=":"<CR>', { desc = "Command History" })
  map("n", "<leader>/", '<Cmd>Pick history scope="/"<CR>', { desc = "Search History" })
  map("n", "<leader>fb", "<Cmd>Pick buffers<CR>", { desc = "Buffers" })
  map("n", "<leader>fc", "<Cmd>Pick config_files<CR>", { desc = "Config Files" })
  map("n", "<leader>fd", "<Cmd>Pick dotfiles<CR>", { desc = "Dotfiles" })
  map("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "Files" })
  map("n", "<leader>fg", "<Cmd>Pick git_files<CR>", { desc = "Git Files" })
  map("n", "<leader>fn", "<Cmd>Pick notes<CR>", { desc = "Notes" })
  map("n", "<leader>fp", "<Cmd>Pick projects<CR>", { desc = "Projects" })
  map("n", "<leader>fr", "<Cmd>Pick oldfiles<CR>", { desc = "Recent Files" })
  map("n", "<leader>gb", "<Cmd>Pick git_branches<CR>", { desc = "Git Branches" })
  map("n", "<leader>gh", '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', { desc = "Git Hunks (Buffer)" })
  map("n", "<leader>gH", '<Cmd>Pick git_hunks scope="staged"<CR>', { desc = "Git Hunks (All)" })
  map("n", "<leader>gm", '<Cmd>Pick git_commits path="%"<CR>', { desc = "Git Commits (Buffer)" })
  map("n", "<leader>gM", "<Cmd>Pick git_commits<CR>", { desc = "Git Commits (All)" })
  map("n", "<leader>sc", "<Cmd>Pick commands<CR>", { desc = "Commands" })
  map("n", "<leader>sC", '<Cmd>Pick history scope=":"<CR>', { desc = "Command History" })
  map("n", "<leader>sd", '<Cmd>Pick diagnostic scope="current"<CR>', { desc = "Diagnostic (Buffer)" })
  map("n", "<leader>sD", '<Cmd>Pick diagnostic scope="all"<CR>', { desc = "Diagnostic (Workspace)" })
  map("n", "<leader>sg", "<Cmd>Pick grep_live<CR>", { desc = "Grep live" })
  map("n", "<leader>sh", "<Cmd>Pick help<CR>", { desc = "Help tags" })
  map("n", "<leader>sH", "<Cmd>Pick hl_groups<CR>", { desc = "Highlight groups" })
  map("n", "<leader>sk", "<Cmd>Pick keymaps<CR>", { desc = "Keymaps" })
  map("n", "<leader>sl", '<Cmd>Pick buf_lines scope="current"<CR>', { desc = "Lines (Buffer)" })
  map("n", "<leader>sL", '<Cmd>Pick buf_lines scope="all"<CR>', { desc = "Lines (All)" })
  map("n", "<leader>sm", "<Cmd>Pick marks<CR>", { desc = "Marks" })
  map("n", "<leader>sr", "<Cmd>Pick registers<CR>", { desc = "Registers" })
  map("n", "<leader>sR", "<Cmd>Pick resume<CR>", { desc = "Resume" })
  map("n", "<leader>ss", '<Cmd>Pick lsp scope="document_symbol"<CR>', { desc = "Symbols (Document)" })
  map("n", "<leader>sS", '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>', { desc = "Symbols (Workspace)" })
  map("n", "<leader>sw", '<Cmd>Pick grep pattern="<cword>"<CR>', { desc = "Grep Current Word" })
  map("n", "<leader>uc", "<Cmd>Pick colorschemes<CR>", { desc = "Toggle colorschemes" })
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
    mappings = { expand = "", jump_next = "", jump_prev = "" },
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

-- Split and join arguments
later(function()
  require("mini.splitjoin").setup()
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
    augend.date.alias["%H:%M"],
    augend.constant.alias.en_weekday,
    augend.constant.alias.en_weekday_full,
    augend.constant.alias.bool,
    augend.constant.alias.Bool,
    augend.semver.alias.semver,
    augend.constant.new({
      elements = { "and", "or" },
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
      enabled = true,
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

-- Undo tree
later(function()
  vim.cmd("packadd nvim.undotree")
  map("n", "<leader>uu", require("undotree").open, { desc = "Toggle undotree" })
end)

-- Tree-sitter ================================================================

now_if_args(function()
  -- Update tree-sitter parsers after plugin is updated
  on_packchanged("nvim-treesitter", { "update" }, function()
    vim.cmd("TSUpdate")
  end, "Update tree-sitter parsers")

  add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  })

  -- Install tree-sitter parsers for languages
  local languages = {
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "diff",
    "git_config",
    "gitcommit",
    "git_rebase",
    "gitignore",
    "gitattributes",
    "html",
    "ini",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "nu",
    "powershell",
    "printf",
    "python",
    "query",
    "regex",
    "sql",
    "tmux",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
  end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  new_autocmd("FileType", filetypes, function(ev)
    vim.treesitter.start(ev.buf)

    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end, "Start tree-sitter")

  -- Add new filetype mappings
  vim.filetype.add({
    pattern = {
      [".*/zed/.*%.json"] = "jsonc",
    },
  })
end)

-- Language servers ===========================================================

later(function()
  add({ "https://github.com/neovim/nvim-lspconfig" })

  vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { bang = true })

  vim.lsp.config("lua_ls", {
    on_attach = function(client, _)
      -- Reduce very long list of triggers for better 'mini.completion' experience
      client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
    end,
    settings = {
      Lua = {
        -- Define runtime properties. Use 'LuaJIT', as it is built into Neovim.
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        workspace = {
          ignoreSubmodules = true,
          library = { vim.env.VIMRUNTIME },
        },
        diagnostics = {
          globals = {
            "vim",
            "MiniIcons",
            "MiniSessions",
            "MiniStatusline",
            "MiniCompletion",
            "MiniFiles",
            "MiniMisc",
            "MiniExtra",
            "MiniKeymap",
            "MiniPick",
            "MiniSnippets",
          },
        },
        telemetry = { enable = false },
      },
    },
  })

  vim.lsp.config("bashls", { filetypes = { "bash", "sh", "zsh" } })
  vim.lsp.config("jsonls", {})
  vim.lsp.config("yamlls", {})
  vim.lsp.config("nushell", {})
  vim.lsp.config("powershell_es", {})
  vim.lsp.config("taplo", {})
  vim.lsp.config("marksman", {})
  vim.lsp.config("ty", {})
  vim.lsp.config("ruff", {})
  vim.lsp.config("tsgo", {})
  vim.lsp.config("biome", { workspace_required = false })
  vim.lsp.config("cssls", {})
  vim.lsp.config("html", {})
  vim.lsp.config("gopls", {})
  vim.lsp.config("clangd", {})
  vim.lsp.config("dockerls", {})
  vim.lsp.config("docker_compose_language_service", {})

  vim.lsp.enable({
    "lua_ls",
    "bashls",
    "nushell",
    "powershell_es",
    "jsonls",
    "yamlls",
    "taplo",
    "marksman",
    "ty",
    "ruff",
    "tsgo",
    "biome",
    "cssls",
    "html",
    "gopls",
    "clangd",
    "dockerls",
    "docker_compose_language_service",
  })

  new_autocmd("LspAttach", "*", function()
    map("n", "K", function()
      vim.lsp.buf.hover({
        border = "rounded",
        max_width = math.floor(vim.o.columns * 0.8),
        max_height = math.floor(vim.o.lines * 0.8),
      })
    end, { desc = "Hover" })
    map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })
    map("n", "gd", vim.lsp.buf.definition, { desc = "Source Definition" })
    map("n", "gD", vim.lsp.buf.type_definition, { desc = "Type Definition" })
    -- map("n", "gr", vim.lsp.buf.references, { desc = "References" })
    map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
    map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
    map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Code Lens" })
    map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
  end, "Set lsp keymaps")
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
end)

-- Formatting =================================================================

later(function()
  add({ "https://github.com/stevearc/conform.nvim" })

  require("conform").setup({
    default_format_opts = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      fish = { "fish_indent" },
      json = { "biome", "prettierd", stop_after_first = true },
      jsonc = { "biome", "prettierd", stop_after_first = true },
      yaml = { "prettierd" },
      markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
      python = { "ruff_format" },
      typescript = { "biome", "prettierd", stop_after_first = true },
      typescriptreact = { "biome", "prettierd", stop_after_first = true },
      javascript = { "biome", "prettierd", stop_after_first = true },
      javascriptreact = { "biome", "prettierd", stop_after_first = true },
      vue = { "biome", "prettierd", stop_after_first = true },
      css = { "biome", "prettierd", stop_after_first = true },
      html = { "biome", "prettierd", stop_after_first = true },
      graphql = { "biome", "prettierd", stop_after_first = true },
      handlebars = { "prettierd" },
      scss = { "prettierd" },
      less = { "prettierd" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      xml = { "xmlformatter" },
    },
  })

  -- stylua: ignore start
  map("n", "<leader>cf", [[lua require("conform").format()]], { desc = "Format Buffer" })
  map("x", "<leader>cf", [[lua require("conform").format()]], { desc = "Format Selection" })
  map("n", "<leader>uf", function() vim.b.disable_autoformat = not vim.b.disable_autoformat end, { desc = "Toggle format (Buffer)" })
  map("n", "<leader>uF", function() vim.g.disable_autoformat = not vim.g.disable_autoformat end, { desc = "Toggle format (Global)" })
  -- stylua: ignore end

  vim.api.nvim_create_user_command("ConformDisable", function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = "Disable autoformat-on-save",
    bang = true,
  })
  vim.api.nvim_create_user_command("ConformEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, {
    desc = "Re-enable autoformat-on-save",
  })
end)
