local map = vim.keymap.set

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
map("n", "n", "nzz", { desc = "Move to next search result and center cursor" })
map("n", "N", "Nzz", { desc = "Move to previous search result and center cursor" })
