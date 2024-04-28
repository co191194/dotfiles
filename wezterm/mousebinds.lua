local act = require("wezterm").action
local wezterm = require("wezterm")

return {
  mouse_bindings = {
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
    -- left click show title bar
    -- {
    --   event = { Down = { streak = 1, button = "Left" } },
    --   mods = "NONE",
    --   action = act.EmitEvent("show-title-bar")
    -- }
  },
}
