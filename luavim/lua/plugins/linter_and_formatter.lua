--[[
	!!!!!!!!!!!!!!
  WARNING THIS FILE REQUIRES YOU TO HAVE THE
						lsp_config.lua
	FILE FIRST IN YOUR PLUGINS
  !!!!!!!!!!!!!!

  this will make your life easier, is just a linter integrated with vim it also does auto identation
  is best than the old CoC that was difficult to configure
  Check here:
    https://github.com/nvimtools/none-ls.nvim

  If you are using Mason you can install first the formatters and linters
  (Mason is installed from the lsp_config file, no need to add it)
    :Mason

  add diagnostics like:
    null_ls.builtins.diagnostics.stylua

  Note:
    there was a deprecation of unmantained lsp formatters check this thread:
      https://github.com/nvimtools/none-ls.nvim/discussions/81
    You can install those deprecated by installing the extras:
      https://github.com/nvimtools/none-ls-extras.nvim

  How to install new formatters:
    1. check with :Mason the available formatters or linters
    2. add it to the null_ls.builtins for setup
    *3*. Chekc that was not deprecated otherwise look for other solution
--]]
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "neovim/nvim-lspconfig",
  },
  lazy = true,
  event = "LspAttach",
  config = function()
    local null_ls = require("null-ls")
    require("functions.register_mappings")
    null_ls.setup({
      sources = {
        -- require("none-ls.diagnostics.eslint_d"),
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
      },
    })

    -- this next line require lsp_config to work properly
    -- it binds to format the code using a formatter from a lsp parser
    Keymap(
      "n",
      "<leader>fc",
      vim.lsp.buf.format,
      { desc = "Format the code of the current file using LSP" },
      "null-ls.nvim"
    )
  end,
}
