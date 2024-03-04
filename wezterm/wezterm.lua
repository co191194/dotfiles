-- ウィンドウバータイトルとタブタイトルの設定
require("format")
-- ステータスバーの設定
require("status")
-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = "Catppuccin Macchiato"

config.window_background_opacity = 0.75

config.default_prog = { "pwsh", "-Login" }

config.font_size = 14.0
config.font = require("wezterm").font("HackGen Console NF")

config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 12.0,
}

config.disable_default_key_bindings = false
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

config.status_update_interval = 1000

-- and finally, return the configuration to wezterm
return config
