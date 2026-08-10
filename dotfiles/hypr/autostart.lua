-- =============================================================================
-- autostart.lua – Programs launched at Hyprland startup
-- =============================================================================

-- Wallpaper daemon
-- Status bar

-- Notification daemon

-- Clipboard manager (records clipboard history)

-- Idle / autolock

-- Polkit agent (for privilege dialogs)

-- Gnome keyring (for SSH/GPG/secrets)

-- Network manager tray applet

-- Bluetooth tray

-- Removable media automounter

-- XDG autostart (e.g. for apps that register with XDG)

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper -c \"$HOME/.config/hypr/hyprpaper.conf\"")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh,pkcs11")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("udiskie --tray")
    hl.exec_cmd("dex --autostart --environment Hyprland")
end)
