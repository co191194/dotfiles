local wezterm = require("wezterm")

wezterm.on("toggle-font-size", function(window, _)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = not overrides.font_size and 10.0 or nil

  window:set_config_overrides(overrides)
end)

local DPI_CHANGE_NUM = 140
local DPI_CHANGE_FONT_SIZE = 12.0

local prev_dpi = 0

wezterm.on("window-focus-changed", function(window, _)
  local dpi = window:get_dimensions().dpi

  if dpi == prev_dpi then
    return
  end

  local overrides = window:get_config_overrides() or {}
  overrides.font_size = dpi < DPI_CHANGE_NUM and DPI_CHANGE_FONT_SIZE or nil

  window:set_config_overrides(overrides)

  prev_dpi = dpi
end)

local TITLE_BAR_DISPLAY_TIME = 3000

local disable_window_decorations = function(window, interval)
  if interval then
    wezterm.sleep_ms(interval)
  end

  local overrides = window:get_config_overrides() or {}
  overrides.window_decorations = nil
  window:set_config_overrides(overrides)
end

wezterm.on("show-title-bar", function(window, _)
  local overrides = window:get_config_overrides() or {}

  overrides.window_decorations = "TITLE | RESIZE"
  window:set_config_overrides(overrides)

  disable_window_decorations(window, TITLE_BAR_DISPLAY_TIME)
end)

wezterm.on("window-focus-changed", function(window, _)
  if window:is_focused() then
    return
  end

  disable_window_decorations(window)
end)
