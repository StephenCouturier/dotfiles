local wezterm = require('wezterm')
local platform = require('utils.platform')()
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'CTRL' -- to not conflict with Windows key shortcuts
end

-- stylua: ignore
local keys = {
   -- misc/useful --
   -- { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   -- { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   -- { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   -- { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   -- {
   --    key = 'F5',
   --    mods = 'NONE',
   --    action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   -- },
   -- { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   -- { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = "CTRL", action = act.Search({ CaseInSensitiveString = '' }) },
   { key = 'k',   mods = 'CTRL', action = act.Multiple {
      act.ClearScrollback 'ScrollbackAndViewport',
      act.SendKey { key = 'L', mods = 'CTRL' },
     }
   },
   {
      key = 'u',
      mods = mod.SUPER,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- cursor movement --
   -- { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\x1bOH' },
   -- { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\x1bOF' },
   -- { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\x15' },

   -- copy/paste --
   { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },

   -- tabs --
   -- tabs: spawn+close
   { key = 'c',          mods = 'LEADER',     action = act.SpawnTab('DefaultDomain') },
   { key = 'n',          mods = 'LEADER',     action = act.SpawnTab('DefaultDomain') },
   -- { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'WSL:Ubuntu' }) },
   -- { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
   -- { key = '[',          mods = mod.SUPER,     action = act.ActivateTabRelative(-1) },
   -- { key = ']',          mods = mod.SUPER,     action = act.ActivateTabRelative(1) },
   -- { key = 'p',          mods = 'LEADER', action = act.MoveTabRelative(-1) },
   -- { key = 'n',          mods = 'LEADER', action = act.MoveTabRelative(1) },

   -- window --
   -- spawn windows
   -- { key = 'c',          mods = 'LEADER',     action = act.SpawnWindow },

   -- background controls --
   -- {
   --    key = [[/]],
   --    mods = mod.SUPER,
   --    action = wezterm.action_callback(function(window, _pane)
   --       backdrops:random(window)
   --    end),
   -- },
   -- {
   --    key = [[,]],
   --    mods = mod.SUPER,
   --    action = wezterm.action_callback(function(window, _pane)
   --       backdrops:cycle_back(window)
   --    end),
   -- },
   -- {
   --    key = [[.]],
   --    mods = mod.SUPER,
   --    action = wezterm.action_callback(function(window, _pane)
   --       backdrops:cycle_forward(window)
   --    end),
   -- },
   {
      key = 'b',
      mods = 'LEADER',
      action = act.InputSelector({
         title = 'Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },

   -- panes --
   -- panes: split panes
   {
      key = 's',
      mods = 'LEADER',
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = 'v',
      mods = 'LEADER',
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

   -- panes: zoom+close pane
   { key = 'f', mods = 'LEADER',     action = act.TogglePaneZoomState },
   { key = 'x',     mods = 'LEADER',     action = act.CloseCurrentPane({ confirm = false }) },

   -- panes: navigation
   { key = 'k',     mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
   { key = 'j',     mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
   { key = 'h',     mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
   { key = 'l',     mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
   -- {
   --    key = 'p',
   --    mods = mod.SUPER_REV,
   --    action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   -- },

   -- key-tables --
   -- resizes fonts
   -- {
   --    key = 'f',
   --    mods = 'LEADER',
   --    action = act.ActivateKeyTable({
   --       name = 'resize_font',
   --       one_shot = false,
   --       timemout_miliseconds = 1000,
   --    }),
   -- },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
}

for i = 1, 8 do
   table.insert(keys, {
      key = tostring(i),
      mods = 'LEADER',
      action = act.ActivateTab(i - 1),
   })
end

-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true,
   leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 2000 },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
