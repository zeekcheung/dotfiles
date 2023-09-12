local Util = require("lazyvim.util")

return {
  "nvim-telescope/telescope.nvim",
  commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  keys = {
    { "<leader>/", false },
    { "<leader>sa", false },
    { "<leader>sb", false },
    { "<leader>sc", false },
    { "<leader>sC", false },
    { "<leader>sd", false },
    { "<leader>sD", false },
    { "<leader>sg", false },
    { "<leader>sG", false },
    { "<leader>sh", false },
    { "<leader>sH", false },
    { "<leader>sk", false },
    { "<leader>sM", false },
    { "<leader>sm", false },
    { "<leader>so", false },
    { "<leader>sR", false },
    { "<leader>sw", false },
    { "<leader>sW", false },
    { "<leader>ss", false },
    { "<leader>sS", false },
    { '<leader>s"', false },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Find command history" },
    -- find
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>fF", Util.telescope("files", { hidden = true, no_ignore = true }), desc = "Find files (root dir)" },
    { "<leader>ff", Util.telescope("files"), desc = "Find files (cwd)" },
    { "<leader>fO", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files (root dir)" },
    { "<leader>fo", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Find recent files (cwd)" },
    { "<leader>fr", "<cmd>Telescope registers<cr>", desc = "Find registers" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Find commands" },
    { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Find document diagnostics" },
    { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Find workspace diagnostics" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" },
    { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Find Man" },
    { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Find marks" },
    { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Find notifications" },
    -- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    -- { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<leader>fw", Util.telescope("live_grep"), desc = "Find word (root dir)" },
    { "<leader>fW", Util.telescope("live_grep", { cwd = false }), desc = "Find word (cwd)" },
    { "<leader>fw", Util.telescope("live_grep"), mode = "v", desc = "Find selection word (root dir)" },
    { "<leader>fW", Util.telescope("live_grep", { cwd = false }), mode = "v", desc = "Find selection word (cwd)" },
    -- { "<leader>ft", Util.telescope("colorscheme", { enable_preview = true }), desc = "Find themes" },
    {
      "<leader>fs",
      Util.telescope("lsp_document_symbols", {
        symbols = {
          "Class",
          "Function",
          "Method",
          "Constructor",
          "Interface",
          "Module",
          "Struct",
          "Trait",
          "Field",
          "Property",
        },
      }),
      desc = "Find symbols",
    },
    {
      "<leader>fS",
      Util.telescope("lsp_dynamic_workspace_symbols", {
        symbols = {
          "Class",
          "Function",
          "Method",
          "Constructor",
          "Interface",
          "Module",
          "Struct",
          "Trait",
          "Field",
          "Property",
        },
      }),
      desc = "Find symbols (Workspace)",
    },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
  },
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
          n = { q = actions.close },
        },
      },
      pickers = {
        find_files = {
          initial_mode = "normal",
          ignore_current_buffer = true,
          sort_lastused = true,
        },
      },
    }
  end,
}
