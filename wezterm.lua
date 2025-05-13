local wez = require 'wezterm'
local config = wez.config_builder()

-- OSC 7 on Windows with powershell
-- https://wezterm.org/shell-integration.html#osc-7-on-windows-with-cmdexe

if wez.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { "pwsh.exe", "-NoLogo" }
end

wez.on('format-tab-title', function(tab, _, _, _, _, _)
    local title = tab.tab_title
    if title == nil or #title == 0 then
        local cwd = tab.active_pane.current_working_dir
        if cwd then
            local path = cwd.file_path:gsub("[/\\]$", "")
            local item1, item2 = path:match("([^/\\]+)[/\\]([^/\\]+)$")
            if item1 and item2 then
                title = item1 .. "/" .. item2
            else
                title = path
            end
        end
    end
    return { { Text = title }, }
end)

wez.on('format-window-title', function(tab, _, tabs, _, _)
    local index = ''
    if #tabs > 1 then
        index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end

    local cwd = tab.active_pane.current_working_dir
    if cwd then
        local path = cwd.file_path:gsub("[/\\]$", "")
        if path:sub(1, 3) == "/C:" then
            path = path:sub(2)
        end
        return index .. " " .. path
    end

    return index .. "wezterm"
end)

config.color_scheme = 'Kanagawa (Gogh)'
config.colors = {
    background = '#181818'
}

-- config.font = wez.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
-- config.font = wez.font('CaskaydiaCove Nerd Font', { weight = 'Regular' })
config.font = wez.font('ComicShannsMono Nerd Font', { weight = 'Regular' })
config.font_size = 11

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
    { key = 'v', mods = 'SHIFT|ALT', action = wez.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'h', mods = 'SHIFT|ALT', action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'Space', mods = 'SHIFT|ALT', action = wez.action { ActivatePaneDirection = "Next" } },
    {
        key = 'r',
        mods = 'SHIFT|ALT',
        action = wez.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wez.action_callback(function(window, _, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or thactual line of text they wrote
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
