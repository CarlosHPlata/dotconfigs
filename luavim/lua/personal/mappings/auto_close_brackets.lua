--[[
-- automatically closes all the brackets and string literals
-- it detect any bracket or string character and provide functionality for auto close
]]

local function check_and_close(char, shouldDoublePrint)
	return function()
		local line = vim.fn.getline(".") -- Get the current line
		local col = vim.fn.col(".") - 1 -- Get the current column (adjusted for zero-indexing)
		local preceding_char = vim.fn.strpart(line, col, 1) -- Get the character before the cursor

		-- Check if the preceding character matches the specified character
		if preceding_char == char then
			return "<Right>"
		else
			local prefix = shouldDoublePrint and char .. char or char
			local sufix = shouldDoublePrint and "<Left>" or ""
			return prefix .. sufix
		end
	end
end


local function backspace_delete_pair(pairs)
	return function()
		local line = vim.fn.getline(".")
    local col = vim.fn.col(".")

		local char_to_delete = vim.fn.strpart(line, col - 2, 1)
		local next_char = vim.fn.strpart(line, col - 1, 1)

		local closing_pair = pairs[char_to_delete]
		if closing_pair ~= nil and closing_pair == next_char then
			return "<Right><BS><BS>"
		end

		return "<BS>"
	end
end

local PAIRS_TABLE = {
	["("] = ")",
	["{"] = "}",
	["["] = "]",
	["<"] = ">",
	["'"] = "'",
	['"'] = '"',
}

-- Delete also the matching brackets when deleting
vim.keymap.set("i", "<BS>", backspace_delete_pair(PAIRS_TABLE), { expr = true })

-- Close brackets automatically, with return
vim.keymap.set("i", "{<cr>", "{<cr>}<C-o><S-o>", { silent = true, desc = "Auto-close curly braces with newline" })
vim.keymap.set("i", "(<cr>", "(<cr>)<C-o><S-o>", { silent = true, desc = "Auto-close parentheses with newline" })
vim.keymap.set("i", "[<cr>", "[<cr>]<C-o><S-o>", { silent = true, desc = "Auto-close square brackets with newline" })

-- Close brackets automatically, with spaces
vim.keymap.set(
	"i",
	"{<SPACE>",
	"{<SPACE><SPACE>}<Left><Left>",
	{ silent = true, desc = "Auto-close square brackets with newline" }
)
vim.keymap.set(
	"i",
	"(<SPACE>",
	"(<SPACE><SPACE>)<Left><Left>",
	{ silent = true, desc = "Auto-close square brackets with newline" }
)
vim.keymap.set(
	"i",
	"[<SPACE>",
	"[<SPACE><SPACE>]<Left><Left>",
	{ silent = true, desc = "Auto-close square brackets with newline" }
)

-- Close brackets without return
vim.keymap.set("i", "(", "()<Left>", { silent = true, desc = "Auto-close parentheses" })
vim.keymap.set("i", "{", "{}<Left>", { silent = true, desc = "Auto-close curly braces" })
vim.keymap.set("i", "[", "[]<Left>", { silent = true, desc = "Auto-close square brackets" })

-- open a new string literal
vim.keymap.set("i", "'", check_and_close("'", true), { expr = true, desc = "Auto-close single quotes" })
vim.keymap.set("i", '"', check_and_close('"', true), { expr = true, desc = "Auto-close double quotes" })
vim.keymap.set("i", "`", check_and_close("`", true), { expr = true, desc = "Auto-close backticks" })

-- If you close a bracket that is already closed, it overwrites
vim.keymap.set(
	"i",
	")",
	check_and_close(")", false),
	{ expr = true, desc = "Overwrite closing parenthesis if already closed" }
)
vim.keymap.set(
	"i",
	"}",
	check_and_close("}", false),
	{ expr = true, desc = "Overwrite closing curly brace if already closed" }
)
vim.keymap.set(
	"i",
	"]",
	check_and_close("]", false),
	{ expr = true, desc = "Overwrite closing square bracket if already closed" }
)

-- Enclose a word in normal mode with "'({[
vim.keymap.set(
	"n",
	"'",
	"mmbi'<Esc>ea'<Esc>`m<Right>",
	{ silent = true, desc = "Enclose word with single quotes in normal mode" }
)
vim.keymap.set(
	"n",
	'"',
	'mmbi"<Esc>ea"<Esc>`m<Right>',
	{ silent = true, desc = "Enclose word with double quotes in normal mode" }
)
vim.keymap.set(
	"n",
	"(",
	"mmbi(<Esc>ea)<Esc>`m<Right>",
	{ silent = true, desc = "Enclose word with parentheses in normal mode" }
)
vim.keymap.set(
	"n",
	"{",
	"mmbi{<Esc>ea}<Esc>`m<Right>",
	{ silent = true, desc = "Enclose word with curly braces in normal mode" }
)
vim.keymap.set(
	"n",
	"[",
	"mmbi[<Esc>ea]<Esc>`m<Right>",
	{ silent = true, desc = "Enclose word with square brackets in normal mode" }
)

-- Enclose a selection in visual mode with "'({[
vim.keymap.set(
	"v",
	"'",
	"<Esc><i'<Esc>>a<Right>'<Esc>",
	{ silent = true, desc = "Enclose selection with single quotes in visual mode" }
)
vim.keymap.set(
	"v",
	'"',
	'<Esc><i"<Esc>>a<Right>"<Esc>',
	{ silent = true, desc = "Enclose selection with double quotes in visual mode" }
)
vim.keymap.set(
	"v",
	"(",
	"<Esc><i(<Esc>>a<Right>)<Esc>",
	{ silent = true, desc = "Enclose selection with parentheses in visual mode" }
)
vim.keymap.set(
	"v",
	"{",
	"<Esc><i{<Esc>>a<Right>}<Esc>",
	{ silent = true, desc = "Enclose selection with curly braces in visual mode" }
)
vim.keymap.set(
	"v",
	"[",
	"<Esc><i[<Esc>>a<Right>]<Esc>",
	{ silent = true, desc = "Enclose selection with square brackets in visual mode" }
)

-- enclose for tags and html
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "jsx", "tsx" },
	callback = function()
		vim.schedule(function()
			vim.keymap.set("i", "<", "<><Left>", { silent = true, buffer = true, desc = "Auto-close angle brackets" })
			vim.keymap.set(
				"i",
				">",
				check_and_close(">", false),
				{ expr = true, buffer = true, desc = "Overwrite closing angle bracket if already closed" }
			)
		end)
	end,
})
