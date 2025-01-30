local w = require 'wezterm'
local config = w.config_builder()

config.default_prog = { "pwsh" }
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- config.font = w.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
-- config.font_size = 10.5

config.font = w.font('CaskaydiaCove Nerd Font', { weight = 'Regular' })
-- config.font_size = 11
-- config.cell_width = 0.8

config.colors = {
    background = '#181818'

}

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
-- config.enable_tab_bar = false

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.keys = {
    { key = 'd', mods = 'SHIFT|ALT', action = w.action.CloseCurrentTab { confirm = true } },
    { key = 'p', mods = 'SHIFT|ALT', action = w.action.ActivateTabRelative(-1) },
    { key = 'n', mods = 'SHIFT|ALT', action = w.action.ActivateTabRelative(1) },
    { key = 't', mods = 'SHIFT|ALT', action = w.action.SpawnTab('CurrentPaneDomain') },

    {
        key = 'r',
        mods = 'SHIFT|ALT',
        action = w.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = w.action_callback(function(window, _, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }
    },

    { key = 'n', mods = 'CTRL|ALT', action = w.action.MoveTabRelative(1) },
    { key = 'p', mods = 'CTRL|ALT', action = w.action.MoveTabRelative(-1) },
}

return config