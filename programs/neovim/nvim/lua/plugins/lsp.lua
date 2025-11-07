return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "nvimdev/lspsaga.nvim",
    "kevinhwang91/nvim-ufo",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Configure diagnostics
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        }
      },
      severity_sort = true, -- Used by lspsaga
    })

    -- Configure keymaps
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
      -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      -- Activate codelens
      -- vim.lsp.codelens.refresh()
      -- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      --   buffer = bufnr,
      --   callback = vim.lsp.codelens.refresh,
      -- })
    end

    -- Add nvim-ufo folding capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }


    -- Configure / Enable lsps
    vim.lsp.config('lua_ls', {
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
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('pylsp')
    vim.lsp.enable('pyright')
    vim.lsp.enable('ruff')
    vim.lsp.enable('yamlls')
    vim.lsp.enable('html')
    vim.lsp.enable('cssls')
    vim.lsp.config('gopls', {
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
    })
    vim.lsp.enable('gopls')
    vim.lsp.enable('spectral')
    vim.lsp.enable('ansiblels')
    vim.lsp.enable('dockerls')
    vim.lsp.enable('docker_compose_language_service')
    vim.lsp.enable('phpactor')
    vim.lsp.enable('jsonls')
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('angularls')
    vim.lsp.enable('bashls')
    vim.lsp.enable('nixd')
    vim.lsp.enable('helm_ls')

    vim.lsp.config('*', {
      on_attach = on_attach,
      capabilities = capabilities
    })
  end,
}
