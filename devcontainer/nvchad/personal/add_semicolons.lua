local map = vim.keymap.set

map("i", "<leader>;", "<Esc>mlA;<Esc>`la", { desc = "Insert semicolon at the end of the line in insert mode" })
map("n", "<leader>;", "mlA;<Esc>`l", { desc = "Insert semicolon at the end of the line in normal mode" })

map("i", "<leader>,", "<Esc>mlA,<Esc>`la", { desc = "Insert comma at the end of the line in insert mode" })
map("n", "<leader>,", "mlA,<Esc>`l", { desc = "Insert comma at the end of the line in normal mode" })

