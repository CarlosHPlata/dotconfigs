return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see the work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript",
        "typescript", "tsx", "json",
        "svelte", "astro", "vue",
      },
    },
  }
}
