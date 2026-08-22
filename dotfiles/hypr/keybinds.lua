-- =============================================================================
-- keybinds.lua – All Hyprland keybindings
-- Modifier: SUPER (Win key)
-- See KEYBINDS.md for the human-friendly table.
-- =============================================================================

local mod = "SUPER"

-- ---------------------------------------------------------------------------
-- APPLICATION LAUNCHERS (Run-or-raise via script)
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("chromium"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("code"))
hl.bind(mod .. " + SHIFT + F", hl.dsp.exec_cmd("thunar"))

-- ---------------------------------------------------------------------------
-- WEB APPS (Chromium app mode, run-or-raise)
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + F1", hl.dsp.exec_cmd("~/.local/bin/webapp \"Amazon Music\"  \"https://music.amazon.co.uk\" \"--app=https://music.amazon.co.uk\""))
hl.bind(mod .. " + F2", hl.dsp.exec_cmd("~/.local/bin/webapp \"GitHub\"        \"https://github.com\"          \"--app=https://github.com\""))

-- ---------------------------------------------------------------------------
-- LAUNCHER / SYSTEM
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("~/.local/bin/powermenu"))

-- ---------------------------------------------------------------------------
-- SCREENSHOT (hyprshot)
-- ---------------------------------------------------------------------------
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output  -o ~/Pictures/Screenshots"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region  -o ~/Pictures/Screenshots"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window  -o ~/Pictures/Screenshots"))

-- ---------------------------------------------------------------------------
-- AUDIO
-- ---------------------------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@   5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume         @DEFAULT_AUDIO_SINK@   5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute           @DEFAULT_AUDIO_SINK@   toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute           @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- ---------------------------------------------------------------------------
-- WINDOW FOCUS (arrow keys)
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
-- Vim-style aliases
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- ---------------------------------------------------------------------------
-- WINDOW MOVEMENT
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- ---------------------------------------------------------------------------
-- WINDOW RESIZE (mouse or keyboard)
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + ALT + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(mod .. " + ALT + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(mod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(mod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

-- ---------------------------------------------------------------------------
-- LAYOUT TOGGLES
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + S", hl.dsp.layout("togglesplit"))

-- Float toggle
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))

-- ---------------------------------------------------------------------------
-- WORKSPACES (1-9)
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = 9 }))

-- Move window to workspace (silent = don't follow)
hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))

-- Scroll through workspaces with mouse wheel over bar
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ---------------------------------------------------------------------------
-- SPECIAL WORKSPACE (scratchpad)
-- ---------------------------------------------------------------------------
hl.bind(mod .. " + grave", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:scratchpad" }))
