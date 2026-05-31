-- keybinds

hl.bind(MAIN_MOD .. " + Return", hl.dsp.exec_cmd(TERMINAL)) --terminal
hl.bind(MAIN_MOD .. " + Space", hl.dsp.exec_cmd(MENU))      --app select menu rofi
hl.bind(MAIN_MOD .. " + E", hl.dsp.exec_cmd(FILE_MANAGER))      -- file manager
hl.bind(MAIN_MOD .. " + C", hl.dsp.window.close())          -- Close window

--screenshots
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/scripts/hyprshot_once.sh -m window -o ~/Pictures/Screenshots"))
hl.bind("Print", hl.dsp.exec_cmd("~/.config/scripts/hyprshot_once.sh -m region -o ~/Pictures/Screenshots"))
hl.bind(MAIN_MOD .. " + Print", hl.dsp.exec_cmd("~/.config/scripts/hyprshot_once.sh -m output -o ~/Pictures/Screenshots"))

hl.bind(MAIN_MOD .. " + X", hl.dsp.exec_cmd("hyprlock"))                                       --hyprlock
hl.bind(MAIN_MOD .. " + M", hl.dsp.exec_cmd("wlogout"))                                        --wlogout
hl.bind(MAIN_MOD .. " + T", hl.dsp.exec_cmd("~/.config/scripts/theme_switcher.sh"))            -- theme selector
hl.bind(MAIN_MOD .. " + W", hl.dsp.exec_cmd("~/.config/scripts/wallpaper.sh"))                 -- wallpaper randomizer
hl.bind(MAIN_MOD .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/scripts/wallpaper.sh s"))       -- wallpaper selector
hl.bind(MAIN_MOD .. " + SHIFT + V",
  hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p \"Clipboard\" | cliphist decode | wl-copy")) -- Clipboard

hl.bind(MAIN_MOD .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MAIN_MOD .. " + P", hl.dsp.window.pseudo())

hl.bind(MAIN_MOD .. " + SHIFT + Z", hl.dsp.layout("togglesplit"))

-- move focus
hl.bind(MAIN_MOD .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(MAIN_MOD .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(MAIN_MOD .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(MAIN_MOD .. " + J", hl.dsp.focus({ direction = "down" }))


-- resize active window
hl.bind(MAIN_MOD .. " + SHIFT + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. " + SHIFT + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. " + SHIFT + J", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(MAIN_MOD .. " + SHIFT + K", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  -- Switch workspaces with mainMod + [0-9]
  hl.bind(MAIN_MOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
  -- Move active window to a workspace with mainMod + SHIFT + [0-9]
  hl.bind(MAIN_MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(MAIN_MOD .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(MAIN_MOD .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(MAIN_MOD .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MAIN_MOD .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))



-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(MAIN_MOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MAIN_MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })



-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
