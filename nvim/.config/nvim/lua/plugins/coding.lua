local border_with_highlight = require("util.highlight").border_with_highlight

return {
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      opts.window = {
        completion = {
          side_padding = 1,
          border = border_with_highlight("CmpBorder"),
          winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
          scrollbar = false,
        },
        documentation = {
          border = border_with_highlight("CmpDocBorder"),
          winhighlight = "Normal:CmpDoc",
        },
        -- documentation = cmp.config.disable,
      }
    end,
  },

  -- Command line completion
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp = require("cmp")

      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },

  -- Codeium
  {
    "Exafunction/codeium.vim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-cmp",
        opts = function(_, opts)
          opts.experimental.ghost_text = false
        end,
      },
    },
    config = function()
      vim.keymap.set("i", "<C-f>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-.>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-l>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },
}
