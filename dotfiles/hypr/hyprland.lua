-- =============================================================================
-- Hyprland main config
-- Hardware: Ryzen 9 5950X | RTX 3090 | 2560x1440@165Hz
-- =============================================================================

-- Source modular configs
local config_dir = os.getenv("HOME") .. "/.config/hypr"

dofile(config_dir .. "/monitors.lua")
dofile(config_dir .. "/input.lua")
dofile(config_dir .. "/appearance.lua")
dofile(config_dir .. "/keybinds.lua")
dofile(config_dir .. "/windowrules.lua")
dofile(config_dir .. "/autostart.lua")

-- ---------------------------------------------------------------------------
-- GENERAL
-- ---------------------------------------------------------------------------

hl.curve("easeOut", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("easeIn", { type = "bezier", points = { { 0.7, 0 }, { 0.84, 0 } } })
hl.curve("slide", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4,
    bezier = "easeOut",
    style = "slide",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "easeIn",
    style = "slide",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 6,
    bezier = "default",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 4,
    bezier = "easeOut",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4,
    bezier = "slide",
})

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "0")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(268bd2ff)", "rgba(2aa198ff)" }, angle = 45 },
            inactive_border = "rgba(073642aa)",
        },
        layout = "dwindle",
        resize_on_border = true,
        allow_tearing = false,
    },
    -- ---------------------------------------------------------------------------
    -- DECORATION
    -- ---------------------------------------------------------------------------
    decoration = {
        rounding = 8,
        active_opacity = 0.95,
        inactive_opacity = 0.7,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            noise = 0.02,
            contrast = 0.9,
            brightness = 0.8,
        },
        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
            color = "rgba(00000088)",
        },
    },
    -- ---------------------------------------------------------------------------
    -- ANIMATIONS
    -- ---------------------------------------------------------------------------
    animations = {
        enabled = true,
    },
    -- ---------------------------------------------------------------------------
    -- LAYOUTS
    -- ---------------------------------------------------------------------------
    dwindle = {
        preserve_split = true,
        smart_split = true,
        smart_resizing = true,
    },
    master = {
        new_status = "master",
    },
    -- ---------------------------------------------------------------------------
    -- MISCELLANEOUS
    -- ---------------------------------------------------------------------------
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },
    -- ---------------------------------------------------------------------------
    -- CURSOR
    -- ---------------------------------------------------------------------------
    cursor = {
        no_hardware_cursors = 0,
    },
    -- ---------------------------------------------------------------------------
    -- ENVIRONMENT VARIABLES
    -- ---------------------------------------------------------------------------
    -- NVIDIA
})
