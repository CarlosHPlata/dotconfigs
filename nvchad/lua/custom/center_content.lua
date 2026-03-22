local map = vim.keymap.set

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor"})
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll down and center cursor"})
map("n", "n", "nzz", { desc = "Center at next search" })
map("n", "N", "Nzz", { desc = "Center at prev search" })
