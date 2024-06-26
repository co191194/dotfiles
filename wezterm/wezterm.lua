-- window's bar and tab settings
require("format")
-- status settings
require("status")
-- require("event")
-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Firefly Traditional"

config.window_background_opacity = 0.75

local host_env = os.getenv("OS")
if host_env == "Windows_NT" then
	config.default_prog = { "pwsh", "-Login" }
elseif host_env == "Linux" then
	config.default_prog = { "bash", "-l" }
elseif host_env == "Darwin" then
end

config.font_size = 12.0
config.font = wezterm.font_with_fallback({
  "Hack Nerd Font",
  "源柔ゴシック等幅",
})

config.window_frame = {
	font = wezterm.font({ family = "Hack Nerd Font", weight = "Bold" }),
	font_size = 12.0,
}

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

config.status_update_interval = 1000

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

local mousebinds = require("mousebinds")
config.disable_default_mouse_bindings = false
config.mouse_bindings = mousebinds.mouse_bindings

-- config.ssh_domains = require("ssh")
config.ssh_domains = wezterm.default_ssh_domains()

return config
