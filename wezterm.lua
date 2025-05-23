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
    title = tab.tab_index + 1 .. ".  " .. title
    return { { Text = title } }
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

-- config.leader = { key = 'a', mods = 'CTRL' }
config.leader = { key = 'Space', mods = 'CTRL' }

config.keys = {
    { key = "a",  mods = "LEADER|CTRL",  action = wez.action { SendString = "\x01" } },
    { key = "z",  mods = "LEADER",       action = "TogglePaneZoomState" },

    { key = 'c',  mods = 'LEADER',       action = wez.action.SpawnTab('CurrentPaneDomain') },
    { key = 'n',  mods = 'LEADER',       action = wez.action.ActivateTabRelative(1) },
    { key = 'p',  mods = 'LEADER',       action = wez.action.ActivateTabRelative(-1) },
    { key = ']',  mods = 'LEADER',       action = wez.action.MoveTabRelative(1) },
    { key = '[',  mods = 'LEADER',       action = wez.action.MoveTabRelative(-1) },

    { key = '%',  mods = 'LEADER|SHIFT', action = wez.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '"',  mods = 'LEADER|SHIFT', action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-',  mods = 'LEADER',       action = wez.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\\', mods = 'LEADER',       action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '|',  mods = 'LEADER|SHIFT', action = wez.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    { key = 'o',  mods = 'LEADER',       action = wez.action { ActivatePaneDirection = "Next" } },
    { key = "h",  mods = "LEADER",       action = wez.action { ActivatePaneDirection = "Left" } },
    { key = "j",  mods = "LEADER",       action = wez.action { ActivatePaneDirection = "Down" } },
    { key = "k",  mods = "LEADER",       action = wez.action { ActivatePaneDirection = "Up" } },
    { key = "l",  mods = "LEADER",       action = wez.action { ActivatePaneDirection = "Right" } },

    { key = "1",  mods = "LEADER",       action = wez.action { ActivateTab = 0 } },
    { key = "2",  mods = "LEADER",       action = wez.action { ActivateTab = 1 } },
    { key = "3",  mods = "LEADER",       action = wez.action { ActivateTab = 2 } },
    { key = "4",  mods = "LEADER",       action = wez.action { ActivateTab = 3 } },
    { key = "5",  mods = "LEADER",       action = wez.action { ActivateTab = 4 } },
    { key = "6",  mods = "LEADER",       action = wez.action { ActivateTab = 5 } },
    { key = "7",  mods = "LEADER",       action = wez.action { ActivateTab = 6 } },
    { key = "8",  mods = "LEADER",       action = wez.action { ActivateTab = 7 } },
    { key = "9",  mods = "LEADER",       action = wez.action { ActivateTab = 8 } },

    { key = "&",  mods = "LEADER|SHIFT", action = wez.action { CloseCurrentTab = { confirm = true } } },
    { key = "d",  mods = "LEADER",       action = wez.action { CloseCurrentPane = { confirm = true } } },
    { key = "x",  mods = "LEADER",       action = wez.action { CloseCurrentPane = { confirm = true } } },

    {
        key = ',',
        mods = 'LEADER',
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

    {
        key = "h",
        mods = "LEADER|SHIFT",
        action = wez.action.Multiple({
            wez.action.AdjustPaneSize({ "Left", 5 }),
            wez.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
        }),
    },
    {
        key = "j",
        mods = "LEADER|SHIFT",
        action = wez.action.Multiple({
            wez.action.AdjustPaneSize({ "Down", 5 }),
            wez.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
        }),
    },
    {
        key = "k",
        mods = "LEADER|SHIFT",
        action = wez.action.Multiple({
            wez.action.AdjustPaneSize({ "Up", 5 }),
            wez.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
        }),
    },
    {
        key = "l",
        mods = "LEADER|SHIFT",
        action = wez.action.Multiple({
            wez.action.AdjustPaneSize({ "Right", 5 }),
            wez.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
        }),
    },
}

config.key_tables = {
    resize_pane = {
        { key = "h",      mods = "SHIFT",                 action = wez.action.AdjustPaneSize({ "Left", 5 }) },
        { key = "j",      mods = "SHIFT",                 action = wez.action.AdjustPaneSize({ "Down", 5 }) },
        { key = "k",      mods = "SHIFT",                 action = wez.action.AdjustPaneSize({ "Up", 5 }) },
        { key = "l",      mods = "SHIFT",                 action = wez.action.AdjustPaneSize({ "Right", 5 }) },
        { key = "Escape", action = wez.action.PopKeyTable },
    }
}

return config
