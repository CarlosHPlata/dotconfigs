--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file
local wezterm = require("wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

------------------- my own variables (change this with your own values)

-- Local programs (Windows host)
local DEFAULT_PROG =
"C:\\Users\\carl_\\AppData\\Local\\Microsoft\\WindowsApps\\Microsoft.PowerShell_8wekyb3d8bbwe\\pwsh.exe"
local WSL_DOMAIN = "WSL:Ubuntu-20.04"

-- SSH servers to multiplex into. Add new boxes here.
-- `name` is what shows in the tab selector and is used as the domain name.
local SSH_HOSTS = {
  { name = "relicario", host = "192.168.1.205", user = "root" },
  { name = "appserver", host = "192.168.1.207", user = "root" },
}

-- Which SSH host to open on launch.
local DEFAULT_SSH_HOST = "relicario"

local DEFAULT_OPACITY = 0.95
local TOGGLE_OPACITY = 1

local COLOR_SCHEME = "Tokyo Night"

-------------------

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.window_decorations = "RESIZE"
config.default_prog = { DEFAULT_PROG }

-- Build SSH multiplexing domains from SSH_HOSTS.
-- multiplexing = "WezTerm" spawns wezterm-mux-server on the remote, so
-- tabs/panes are native WezTerm and persist across disconnects.
-- Requires `wezterm` installed on each Debian server.
config.ssh_domains = {}
for _, h in ipairs(SSH_HOSTS) do
  table.insert(config.ssh_domains, {
    name = h.name,
    remote_address = h.host,
    username = h.user,
    multiplexing = "WezTerm",
    assume_shell = "Posix",
  })
end

-- Auto-connect to the main Debian box on launch.
config.default_domain = DEFAULT_SSH_HOST

config.color_scheme = COLOR_SCHEME
config.font = wezterm.font_with_fallback({
  { family = "JetBrains Mono", weight = "Regular" },
})
config.window_background_opacity = DEFAULT_OPACITY
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Advertise the wezterm terminfo to remote programs (nvim, less, etc.)
-- so they use WezTerm's full capabilities and avoid partial-redraw artifacts.
-- Requires `wezterm.terminfo` installed on each remote (tic -x wezterm.terminfo).
config.term = "wezterm"

-- Coalesce mux-server output before parsing/rendering. Reduces flicker and
-- stale cells when a TUI (nvim) sends many small updates over the wire.
config.mux_output_parser_coalesce_delay_ms = 3

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5,
}

-- Start maximized
wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on("toggle-opacity", function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = TOGGLE_OPACITY
  else
    overrides.window_background_opacity = nil
  end

  window:set_config_overrides(overrides)
end)

-- Build the leader+t spawn-tab choices: every SSH host + local PowerShell + WSL.
local function build_tab_choices()
  local choices = {}
  for _, h in ipairs(SSH_HOSTS) do
    table.insert(choices, { label = "SSH: " .. h.name .. " (" .. h.host .. ")", id = "ssh:" .. h.name })
  end
  table.insert(choices, { label = "PowerShell (local)", id = "powershell" })
  table.insert(choices, { label = "WSL", id = "wsl" })
  return choices
end

-- keybindings
config.leader = { key = "x", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  {
    key = "e",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Rename tab:" },
      }),
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  {
    key = "t",
    mods = "LEADER",
    action = wezterm.action.InputSelector({
      title = "Open New Tab",
      choices = build_tab_choices(),
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id and not label then
          wezterm.log_info("cancelled")
        elseif id == "powershell" then
          window:perform_action(wezterm.action.SpawnTab({ DomainName = "local" }), pane)
        elseif id == "wsl" then
          window:perform_action(wezterm.action.SpawnTab({ DomainName = WSL_DOMAIN }), pane)
        elseif id and id:sub(1, 4) == "ssh:" then
          local ssh_name = id:sub(5)
          window:perform_action(wezterm.action.SpawnTab({ DomainName = ssh_name }), pane)
        else
          wezterm.log_info("unknown id: ", id)
        end
      end),
    }),
  },
  -- Quick SSH host switcher: attach an existing tab/pane to another SSH domain
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.InputSelector({
      title = "Connect to SSH host",
      choices = (function()
        local c = {}
        for _, h in ipairs(SSH_HOSTS) do
          table.insert(c, { label = h.name .. " (" .. h.user .. "@" .. h.host .. ")", id = h.name })
        end
        return c
      end)(),
      action = wezterm.action_callback(function(window, pane, id, _)
        if id then
          window:perform_action(wezterm.action.SpawnTab({ DomainName = id }), pane)
        end
      end),
    }),
  },
  {
    key = "o",
    mods = "LEADER",
    action = wezterm.action.EmitEvent("toggle-opacity"),
  },
  -- tabs
  {
    mods = "LEADER",
    key = "c",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    mods = "LEADER",
    key = "x",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
  {
    mods = "LEADER",
    key = "b",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    mods = "LEADER",
    key = "n",
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- panes
  {
    mods = "LEADER",
    key = ";",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    mods = "LEADER",
    key = "'",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  --pane movements
  {
    mods = "LEADER",
    key = "h",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    mods = "LEADER",
    key = "j",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  {
    mods = "LEADER",
    key = "k",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    mods = "LEADER",
    key = "l",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },

  -- resize panes
  {
    mods = "LEADER",
    key = "LeftArrow",
    action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
  },
  {
    mods = "LEADER",
    key = "DownArrow",
    action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
  },
  {
    mods = "LEADER",
    key = "UpArrow",
    action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
  },
  {
    mods = "LEADER",
    key = "RightArrow",
    action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
  },
}

--set all tabs mappings
for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = wezterm.action.ActivateTab(i),
  })
end

-- Tabs
--config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- tabline.wez status bar (lualine-style; surfaces mode, workspace, SSH domain, time)
tabline.setup({
  options = {
    theme = "tokyonight_night",
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    tab_separators = { left = "", right = "" },
  },
  sections = {
    tabline_a = { "mode" },
    tabline_b = { "workspace" },
    tabline_c = { " " },
    tab_active = {
      "index",
      { "process", padding = { left = 0, right = 1 } },
    },
    tab_inactive = {
      "index",
      { "process", padding = { left = 0, right = 1 } },
    },
    tabline_x = { "ram", "cpu" },
    tabline_y = { "datetime" },
    tabline_z = { "domain" },
  },
})
tabline.apply_to_config(config)

-- and finally, return the configuration to wezterm
return config
