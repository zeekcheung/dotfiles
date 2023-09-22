local map = vim.keymap.set

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map({ "x", "n", "s" }, "<leader>w", "<cmd>w<cr><esc>", { desc = "Save file" })
-- select all
map({ "n", "v", "x", "i" }, "<C-a>", "ggVG", { desc = "Select All" })

-- quit
map({ "n", "v", "x" }, "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map({ "n", "v", "x" }, "<leader>qw", "<cmd>exit<cr>", { desc = "Quit current window" })

-- clear search with <esc>
map({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- goto line
map({ "n", "v", "x" }, "gls", "^", { desc = "Goto line start" })
map({ "n", "v", "x" }, "gle", "$", { desc = "Goto line end" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- better escape
map("i", "jj", "<esc>", { desc = "Better Escape" })
map("i", "jk", "<esc>", { desc = "Better Escape" })
map("i", "kk", "<esc>", { desc = "Better Escape" })

-- better up/down (ignore indentation)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down", silent = true })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up", silent = true })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down", silent = true })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up", silent = true })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

-- move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- split window
map("n", "\\", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
map("n", "|", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- previous buffer
map("n", "H", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
-- next buffer
map("n", "L", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- lazy
map("n", "<leader>ph", "<cmd>Lazy home<cr>", { desc = "Home" })
map("n", "<leader>pi", "<cmd>Lazy install<cr>", { desc = "Install" })
map("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Update" })
map("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Sync" })
map("n", "<leader>pc", "<cmd>Lazy check<cr>", { desc = "Check" })
map("n", "<leader>px", "<cmd>Lazy clean<cr>", { desc = "Clean" })
map("n", "<leader>pl", "<cmd>Lazy log<cr>", { desc = "Log" })
map("n", "<leader>pr", "<cmd>Lazy restore<cr>", { desc = "Restore" })
map("n", "<leader>pp", "<cmd>Lazy profile<cr>", { desc = "Profile" })
map("n", "<leader>pd", "<cmd>Lazy debug<cr>", { desc = "Debug" })
map("n", "<leader>p?", "<cmd>Lazy help<cr>", { desc = "Help" })
