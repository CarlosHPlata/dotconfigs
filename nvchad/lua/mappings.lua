require "nvchad.mappings"
require "custom"

-- add yours here
local map = vim.keymap.set

map("n", "<leader>tch", "<cmd>Telescope keymaps<cr>". { desc= "Telescope nvcheatsheet" })
