-- =============================================================================
-- input.lua – Keyboard / mouse / touchpad settings
-- =============================================================================

hl.config({
    input = {
        kb_layout = "gb",
        kb_variant = "",
        kb_model = "",
        kb_options = "caps:escape", -- Caps Lock acts as Escape
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0, -- -1.0 to 1.0 (0 = no accel)
        accel_profile = "flat",
        numlock_by_default = true,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
