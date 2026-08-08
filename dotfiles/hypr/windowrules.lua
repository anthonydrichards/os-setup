-- =============================================================================
-- windowrules.lua – Per-app rules
-- =============================================================================

-- Float small utility dialogs
hl.window_rule({
    match = {
        class = "^(pavucontrol)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(blueman-manager)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(nm-connection-editor)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(lxappearance)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(thunar)$",
        title = "^(File Operation Progress)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(polkit-gnome-authentication-agent-1)$",
    },
    float = true,
})

-- Chromium web apps – tile normally
hl.window_rule({
    match = {
        class = "^(chromium)$",
        title = "^(Amazon Music)$",
    },
    float = false,
})

hl.window_rule({
    match = {
        class = "^(chromium)$",
        title = "^(GitHub)$",
    },
    float = false,
})

-- Assign apps to workspaces
hl.window_rule({
    match = {
        class = "^(kitty)$",
    },
    workspace = "1",
})

hl.window_rule({
    match = {
        class = "^(chromium)$",
    },
    workspace = "2",
})

hl.window_rule({
    match = {
        class = "^(code)$",
    },
    workspace = "3",
})

hl.window_rule({
    match = {
        class = "^(steam)$",
    },
    workspace = "4",
})

-- Fix Steam black window
hl.window_rule({
    match = {
        class = "^(steam)$",
        title = "^()$",
    },
    stay_focused = true,
    min_size = { 1, 1 },
})

-- Fix XWayland scaling artifacts
hl.window_rule({
    match = {
        xwayland = 1,
    },
    rounding = 0,
})

-- Idle inhibit for fullscreen apps and games
hl.window_rule({
    match = {
        class = ".*",
    },
    idle_inhibit = "fullscreen",
})

hl.window_rule({
    match = {
        class = "^(steam_app_.*)$",
    },
    idle_inhibit = "focus",
})
