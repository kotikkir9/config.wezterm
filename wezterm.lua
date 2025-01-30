local wez = require 'wezterm'
local config = wez.config_builder()

config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = 'Kanagawa Dragon (Gogh)'

config.colors = {
    background = '#181818'
}

config.default_prog = { "pwsh" }

-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- config.font = w.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
config.font = wez.font('CaskaydiaCove Nerd Font', { weight = 'Regular' })
-- config.font_size = 10.5

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
    { key = 'd', mods = 'SHIFT|ALT', action = wez.action.CloseCurrentTab { confirm = true } },
    { key = 'p', mods = 'SHIFT|ALT', action = wez.action.ActivateTabRelative(-1) },
    { key = 'n', mods = 'SHIFT|ALT', action = wez.action.ActivateTabRelative(1) },
    { key = 't', mods = 'SHIFT|ALT', action = wez.action.SpawnTab('CurrentPaneDomain') },

    {
        key = 'r',
        mods = 'SHIFT|ALT',
        action = wez.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wez.action_callback(function(window, _, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }
    },

    { key = 'n', mods = 'CTRL|ALT', action = wez.action.MoveTabRelative(1) },
    { key = 'p', mods = 'CTRL|ALT', action = wez.action.MoveTabRelative(-1) },
}

return config
