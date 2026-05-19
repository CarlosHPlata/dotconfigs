require "nvchad.mappings"
require "custom"

-- add yours here
local map = vim.keymap.set

map("n", "<leader>tch", "<cmd>Telescope keymaps<cr>", { desc = "Telescope nvcheatsheet" })

map("n", "<leader>do", "<cmd>DiffviewOpen<cr>",          { desc = "Diffview open" })
map("n", "<leader>dc", "<cmd>DiffviewClose<cr>",         { desc = "Diffview close" })
map("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>",   { desc = "Diffview repo history" })
map("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history" })
