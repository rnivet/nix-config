-- The formatting plugin
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        go = { "gofumpt", "goimports_reviser" },
        -- json = { "fixjson" },
        --html = { "prettier" },
        html = { "htmlbeautifier" },
        python = { "black" },
        sh = { "shfmt" }
      },
      formatters = {
        goimports_reviser = {
          command = "goimports-reviser",
          args = { "-project-name", "gitlabdev.vadesecure.com", "$FILENAME" },
          stdin = false,
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      }
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)", noremap = true, silent = true })
  end
}
