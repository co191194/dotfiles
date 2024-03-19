-- window's bar and tab settings
require("format")
-- status settings 
require("status")
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

config.font_size = 14.0
config.font = require("wezterm").font("HackGen Console NF")

config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 12.0,
}

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

config.status_update_interval = 1000

local act = wezterm.action

config.disable_default_mouse_bindings = false
config.mouse_bindings = {
	-- right click copy & paste
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local is_selection = window:get_selection_text_for_pane(pane) ~= ""
			if is_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

return config
