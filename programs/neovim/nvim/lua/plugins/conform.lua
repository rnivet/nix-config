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
        sh = { "shfmt" },
        nix = { "alejandra" },
        htmlangular = { "prettier" },
      },
      formatters = {
        goimports_reviser = {
          command = "goimports-reviser",
          args = { "-project-name", "gitlabdev.vadesecure.com", "$FILENAME" },
          stdin = false,
        },
      },
      format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { "cs" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        -- ...additional logic...
        return { async = false, timeout_ms = 500, lsp_format = "fallback" }
      end
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
