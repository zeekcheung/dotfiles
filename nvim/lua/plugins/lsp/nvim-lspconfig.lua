return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "b0o/SchemaStore.nvim", version = false },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local root_pattern = require("lspconfig.util").root_pattern

    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    ----------------------------------------------------------
    -- Configure language servers via nvim-lspconfig
    ----------------------------------------------------------

    -- set keymaps
    local on_attach = function(client, bufnr)
      local wk = require("which-key")

      wk.register({
        ["K"] = { vim.lsp.buf.hover, "Hover" },
        ["gr"] = { "<cmd>Telescope lsp_references<CR>", "Goto References" },
        ["gD"] = { vim.lsp.buf.declaration, "Goto Declaration" },
        ["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Goto Definition" },
        ["gt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Show Lsp type definitions" },
        ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
        ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
      }, {
        buffer = bufnr,
        silent = true,
      })

      wk.register({
        ["<leader>c"] = { name = "Code" },
        ["<leader>ca"] = { vim.lsp.buf.code_action, "Code Actions" },
        ["<leader>cd"] = { vim.diagnostic.open_float, "Line Diagnostics" },
        ["<leader>cf"] = {
          function()
            vim.lsp.buf.format({
              filter = function(_client)
                --  only use null-ls for formatting instead of lsp server
                return _client.name == "null-ls"
              end,
              bufnr = bufnr,
            })
          end,
          "Format Document",
        },
      }, { buffer = bufnr, silent = true })

      wk.register({
        ["<leader>r"] = { name = "Refactor" },
        ["<leader>rn"] = { vim.lsp.buf.rename, "Rename" },
      }, { buffer = bufnr, silent = true })
    end

    -- enable autocompletion
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local icons = require("utils.icons")
    local signs = {
      Error = icons.DiagnosticError,
      Warn = icons.DiagnosticWarn,
      Hint = icons.DiagnosticHint,
      Info = icons.DiagnosticInfo,
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- configure bash language server
    lspconfig.bashls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "sh", "bash" },
    })

    -- configure c/cpp language server
    lspconfig.clangd.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure docker compose language server
    lspconfig.docker_compose_language_service.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure docker language server
    lspconfig.dockerls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure go language server
    lspconfig.gopls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
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
            fieldalignment = true,
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

    -- configure html language server
    lspconfig.html.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure css language server
    lspconfig.cssls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        less = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    })

    -- configure emmet language server
    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "vue" },
    })

    -- configure json language server
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      -- lazy-load schemastore when needed
      on_new_config = function(new_config)
        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
      end,
      settings = {
        json = {
          format = {
            enable = true,
          },
          validate = { enable = true },
        },
      },
    })

    -- configure lua language server
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            checkThirdParty = false,
            ignoreDir = {
              ".vscode",
              ".git",
            },
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
          completion = {
            callSnippet = "Replace",
          },
          hint = {
            enable = true,
          },
          diagnostics = {
            enable = true,
            globals = {
              "vim",
            },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    -- configure markdown language server
    lspconfig.marksman.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "markdown", "md" },
    })

    -- configure prisma language server
    lspconfig.prismals.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure python language server
    lspconfig.pyright.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    -- configure python language server
    lspconfig.ruff_lsp.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure tailwindcss server
    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts"),
      settings = {
        tailwindCSS = {
          classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning",
          },
          validate = true,
        },
      },
    })

    -- configure toml language server
    lspconfig.taplo.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure javascrip/typescript language server
    lspconfig.tsserver.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = root_pattern("package.json"),
      single_file_support = false,
      settings = {
        javascript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        typescript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        completions = {
          completeFunctionCalls = true,
        },
      },
    })

    -- configure javascript/typescript language server
    lspconfig.denols.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = root_pattern("deno.json", "deno.jsonc"),
      settings = {
        deno = {
          enable = true,
          suggest = {
            imports = {
              hosts = {
                ["https://crux.land"] = true,
                ["https://deno.land"] = true,
                ["https://x.nest.land"] = true,
              },
            },
          },
        },
      },
    })

    -- configure vue language server
    lspconfig.volar.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "vue" },
    })

    -- configure yaml language server
    lspconfig.yamlls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        yaml = {
          keyOrdering = false,
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
          },
        },
        redhat = {
          telemetry = {
            enabled = false,
          },
        },
      },
    })
  end,
}
