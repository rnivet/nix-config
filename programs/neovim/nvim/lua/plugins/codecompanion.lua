-- AI coding assistant
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local opts = {
      adapters = {
        codestral = function()
          return require("codecompanion.adapters").extend("mistral", {
            env = {
              api_key = "CODESTRAL_API_KEY",
              url = "https://codestral.mistral.ai",
            },
            schema = {
              model = {
                default = "codestral-latest"
              }
            }
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "codestral"
        },
        inline = {
          adapter = "codestral"
        },
        cmd = {
          adapter = "codestral"
        }
      },
      display = {
        action_palette = {
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          }
        }
      }
    }
    require("codecompanion").setup(opts)
  end
}
