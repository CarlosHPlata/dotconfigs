-- This script dynamically loads and requires Lua configuration files from the
-- same directory, excluding itself. It is intended to be used within Neovim's
-- Lua configuration system.
--
-- The script performs the following steps:
-- 1. Retrieves the directory and filename of the current script.
-- 2. Determines the module name from the argument passed when the script is required.
-- 3. Defines a function `scandir` to list all files in a given directory.
-- 4. Filters the list of files to include only Lua files, excluding the current script.
-- 5. Requires each of the filtered Lua files as modules.
--
-- Functions:
-- - `scandir(directory)`: Returns a table of filenames in the specified directory.
--
-- Variables:
-- - `module_directory`: The directory where the current script is located.
-- - `module_filename`: The filename of the current script.
-- - `module_name`: The name of the module, derived from the argument passed when required.
-- - `config_files`: A list of Lua configuration files in the same directory, excluding the current script.

local info = debug.getinfo(1, "S")
local module_directory = string.match(info.source, "^@(.*)/")
local module_filename = string.match(info.source, "/([^/]*)$")

-- Apparently the name of this module is given as an argument when it is
-- required, and apparently we get that argument with three dots.
local module_name = ... or "init.d"

local function scandir(directory)
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('ls -a "' .. directory .. '"')
	for filename in pfile:lines() do
		i = i + 1
		t[i] = filename
	end
	pfile:close()
	return t
end

local config_files = vim.tbl_filter(function(filename)
	local is_lua_module = string.match(filename, "[.]lua$")
	local is_this_file = filename == module_filename
	return is_lua_module and not is_this_file
end, scandir(module_directory))

for _, filename in ipairs(config_files) do
	local config_module = string.match(filename, "(.+).lua$")
	-- print("requiring: " .. module_name.."."..config_module)
	require(module_name .. "." .. config_module)
end
