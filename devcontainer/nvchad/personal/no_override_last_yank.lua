local map = vim.keymap.set

map("x", "<leader>p", '"_dP', { desc = "Paste before and send to black hole" })
map("n", "<leader>d", '"_dp', { desc = "Paste after and send to black hole" })
map("v", "<leader>d", '"_dp', { desc = "Paste after and send to black hole" })
