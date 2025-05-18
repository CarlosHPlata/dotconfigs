require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  "lua_ls",
}

vim.diagnostic.config {
  virtual_text = false, -- show virtual text
  signs = true, -- show signs in the linter gutter
  underline = true, -- underline the text when errors
  update_in_insert = false, -- update the diagnostics in insert mode
  severity_sort = true, -- sort the diagnostics by severity
}
vim.o.updatetime = 250 -- set the time it takes to show the diagnostics
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]]
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
