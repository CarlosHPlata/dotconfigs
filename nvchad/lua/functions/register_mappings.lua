-- Function to register a string into the global table
function Keymap(mode, key, action, opts, plugin)
	vim.keymap.set(mode, key, action, opts)
end
