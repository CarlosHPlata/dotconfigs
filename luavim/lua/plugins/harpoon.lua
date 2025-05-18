--[[
  This is a plugin that allows you to save and jump to bookmarks in
  your project. It is a great way to navigate your project.

  check:
  https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#-Installation
--]]
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  event = "BufEnter",
	config = function()
    require("functions.register_mappings")
		local harpoon = require("harpoon")
    harpoon:setup({})

    -- Use telescope to open harpoon window
		--local conf = require("telescope.config").values
		--local function toggle_telescope(harpoon_files)
		--	local file_paths = {}
		--	for _, item in ipairs(harpoon_files.items) do
		--		table.insert(file_paths, item.value)
		--	end

		--	require("telescope.pickers")
		--		.new({}, {
		--			prompt_title = "Harpoon",
		--			finder = require("telescope.finders").new_table({
		--				results = file_paths,
		--			}),
		--			previewer = conf.file_previewer({}),
		--			sorter = conf.generic_sorter({}),
		--		})
		--		:find()
		--end

		--Keymap("n", "<C-e>", function()
		--	toggle_telescope(harpoon:list())
		--end, { desc = "Open harpoon window" })
    Keymap("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add file to Harpoon list" }, "harpoon")
    Keymap("n", "<C-a>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon list" }, "harpoon")

    -- Keymap("n", "<leader>q", function() harpoon:list():select(1) end, { desc = "Select 1st file in Harpoon list" }, "harpoon")
    -- Keymap("n", "<leader>w", function() harpoon:list():select(2) end, { desc = "Select 2nd file in Harpoon list" }, "harpoon")
    -- Keymap("n", "<leader>e", function() harpoon:list():select(3) end, { desc = "Select 3rd file in Harpoon list" }, "harpoon")
    -- Keymap("n", "<leader>r", function() harpoon:list():select(4) end, { desc = "Select 4th file in Harpoon list" }, "harpoon")
    -- Toggle previous & next buffers stored within Harpoon list
    Keymap("n", "<S-Q>", function() harpoon:list():prev() end, { desc = "Go to previous file in Harpoon list" }, "harpoon")
    Keymap("n", "<S-W>", function() harpoon:list():next() end, { desc = "Go to next file in Harpoon list" }, "harpoon")
	end,
}
