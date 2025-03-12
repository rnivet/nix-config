-- LSP client configs as a plugin
-- Use lsp-format to trigger formatting using LSP formatter
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "nvimdev/lspsaga.nvim",
    "kevinhwang91/nvim-ufo",
    -- "Hoffs/omnisharp-extended-lsp.nvim",
    "seblyng/roslyn.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import cmp_nvim_lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local keymap = vim.keymap -- for conciseness

    local on_attach = function(_, bufnr)
      -- Set LSP keymaps
      local opts = { noremap = true, silent = true }
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP finder"
      keymap.set("n", "gf", "<cmd>Lspsaga finder def+imp+ref<CR>", opts) -- show definition, references

      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Lspsaga finder ref<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Lspsaga finder imp<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", opts) -- show lsp type definitions

      opts.desc = "Show LSP outline"
      keymap.set("n", "go", "<cmd>Lspsaga outline<CR>", opts) -- show lsp type definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "d<", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "d>", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

      -- Activate inlay hints
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      -- Activate codelens
      -- vim.lsp.codelens.refresh()
      -- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      --   buffer = bufnr,
      --   callback = vim.lsp.codelens.refresh,
      -- })
    end

    -- Add nvim-ufo folding capabilities
    local capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }

    -- configure lua_ls server
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          -- make LS recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make LS aware of runtime files
            library = {
              vim.env.VIMRUNTIME
            }
          }
        }
      }
    })

    -- configure pylsp server
    lspconfig.pylsp.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure pyright server
    lspconfig.pyright.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure yamlls server
    lspconfig.yamlls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure html server
    lspconfig.html.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure cssls server
    lspconfig.cssls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure gopls server
    lspconfig.gopls.setup({
      settings = {
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
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure spectral server
    lspconfig.spectral.setup({
      filetypes = { "yaml" },
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure ansiblels server
    lspconfig.ansiblels.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure dockerls server
    lspconfig.dockerls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure docker_compose_ls server
    lspconfig.docker_compose_language_service.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure phpactor server
    lspconfig.phpactor.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure jsonls server
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure ts_ls server
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure bash server
    lspconfig.bashls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    -- configure docker compose server
    lspconfig.docker_compose_language_service.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure omnisharp server
    -- lspconfig.omnisharp.setup({
    --   cmd = { "OmniSharp" },
    --   settings = {
    --     FormattingOptions = {
    --       -- Enables support for reading code style, naming convention and analyzer
    --       -- settings from .editorconfig.
    --       EnableEditorConfigSupport = true,
    --       -- Specifies whether 'using' directives should be grouped and sorted during
    --       -- document formatting.
    --       OrganizeImports = nil,
    --     },
    --     MsBuild = {
    --       -- If true, MSBuild project system will only load projects for files that
    --       -- were opened in the editor. This setting is useful for big C# codebases
    --       -- and allows for faster initialization of code navigation features only
    --       -- for projects that are relevant to code that is being edited. With this
    --       -- setting enabled OmniSharp may load fewer projects and may thus display
    --       -- incomplete reference lists for symbols.
    --       LoadProjectsOnDemand = true,
    --     },
    --     RoslynExtensionsOptions = {
    --       -- Enables support for roslyn analyzers, code fixes and rulesets.
    --       EnableAnalyzersSupport = true,
    --       -- Enables support for showing unimported types and unimported extension
    --       -- methods in completion lists. When committed, the appropriate using
    --       -- directive will be added at the top of the current file. This option can
    --       -- have a negative impact on initial completion responsiveness,
    --       -- particularly for the first few completion sessions after opening a
    --       -- solution.
    --       EnableImportCompletion = true,
    --       -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    --       -- true
    --       AnalyzeOpenDocumentsOnly = true,
    --       EnableDecompilationSupport = true,
    --     },
    --     Sdk = {
    --       -- Specifies whether to include preview versions of the .NET SDK when
    --       -- determining which version to use for project loading.
    --       IncludePrereleases = true,
    --     },
    --   },
    --   handlers = {
    --     ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
    --     ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
    --     ["textDocument/references"] = require('omnisharp_extended').references_handler,
    --     ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
    --   },
    --   keys = {
    --     {
    --       "gd",
    --       function()
    --         require("omnisharp_extended").telescope_lsp_definitions()
    --       end,
    --       desc = "Goto Definition",
    --     },
    --   },
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })

    -- Configure Nix language server
    lspconfig.nixd.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Configure Helm language server
    lspconfig.helm_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Configure Roslyn language server
    require("roslyn").setup({
      exe = 'Microsoft.CodeAnalysis.LanguageServer',
      config = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
        },
      }
    })
  end,
}
