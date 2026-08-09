# Arch Linux + Hyprland Setup

A complete, minimal-but-polished Arch Linux + Hyprland desktop install.

**Hardware target:** Ryzen 9 5950X · RTX 3090 · 32 GB DDR4 · 2 TB NVMe · 2560×1440 @ 165 Hz  
**Visual style:** Solarized Night · JetBrainsMono Nerd Font  
**Stack:** Hyprland · Waybar · Kitty · Fuzzel · Mako · Chromium · VS Code · Steam

---

## Directory Structure

```
.
├── install_arch_hyprland.sh   # Step 1 – run from Arch live ISO as root
├── bootstrap_user.sh          # Step 2 – run after first boot as your user
├── dotfiles/
│   ├── hypr/                  # Hyprland, Hyprpaper, Hyprlock, Hypridle
│   ├── waybar/                # Bar config + Solarized CSS
│   ├── kitty/                 # Terminal emulator
│   ├── fuzzel/                # App launcher
│   ├── mako/                  # Notifications
│   ├── gtk-3.0/               # GTK3 theme settings
│   ├── gtk-4.0/               # GTK4 theme settings
│   ├── scripts/               # ror, webapp, powermenu helpers
│   ├── bash/                  # .bashrc, .bash_profile
│   └── nvim/                  # init.vim
├── README.md                  # This file
└── KEYBINDS.md                # Keybinding cheat sheet
```

---

## Step-by-Step Usage

### Prerequisites

1. Boot the **Arch Linux live ISO** (latest, x86_64).
2. Connect to the internet:
   - Ethernet: usually auto-configures via DHCP.
   - Wi-Fi: `iwctl station wlan0 connect "SSID"` then enter passphrase.
3. Verify connectivity: `ping archlinux.org`

---

### Step 1 – Base Install

```bash
# As root on the live ISO:
curl -fsSL https://raw.githubusercontent.com/anthonydrichards/os-setup/main/install_arch_hyprland.sh \
    -o /tmp/install.sh
bash /tmp/install.sh
```

> **Edit variables at the top of the script first** (disk, hostname, username, etc.)

The script will:
- Rank UK mirrors
- Partition and format the NVMe (`EFI + swap + root`)
- Install base system, AMD microcode, GRUB, NetworkManager, and `iwd` (`iwctl`)
- Configure locale (`en_GB.UTF-8`), keymap (`gb`), timezone (`Europe/London`)
- Set `nvidia_drm.modeset=1` kernel parameter
- Create your user with `wheel` group (sudo)
- Add NVIDIA pacman hook for automatic initramfs rebuilds

After it finishes:
```bash
umount -R /mnt
reboot
```

Change root and user passwords on first login:
```bash
passwd root
passwd <username>
```

---

### Step 2 – Post-Install Bootstrap

Clone this repository as your user, then run the bootstrap:

```bash
git clone https://github.com/anthonydrichards/os-setup.git ~/os-setup
cd ~/os-setup
chmod +x bootstrap_user.sh
./bootstrap_user.sh
```

The script will:
- Enable multilib (32-bit libs for Steam/Proton)
- Install all official repo packages (Hyprland stack, NVIDIA libs, gaming, CLI tools)
- Build and install `yay` (AUR helper)
- Install AUR packages (`visual-studio-code-bin`, `bibata-cursor-theme`, `adw-gtk3`, `papirus-icon-theme`)
- Enable system services: bluetooth, greetd
- Enable user services: pipewire, wireplumber
- Download the space wallpaper
- Symlink all dotfiles into `~/.config/`
- Apply GTK/cursor theme via `gsettings`
- Configure greetd + regreet login manager
- Set up zram for in-memory swap

---

### Step 3 – First Boot to Desktop

1. Reboot: `sudo reboot`
2. At the **regreet** login screen, select `Hyprland` as the session and log in.
3. Hyprland will start. Waybar appears at the top.

---

## Post-Boot Checklist

### Verify 165 Hz

```bash
hyprctl monitors
# Should show: refreshRate: 165.000000
```

If not, edit `dotfiles/hypr/monitors.lua` and `hyprctl reload`.

### Verify NVIDIA Acceleration

```bash
nvidia-smi
glxinfo | grep "OpenGL renderer"   # should show RTX 3090
# Wayland acceleration:
LIBVA_DRIVER_NAME=nvidia vainfo    # libva-nvidia-driver check
```

### Audio

```bash
wpctl status     # pipewire/wireplumber running
pavucontrol      # GUI mixer
```

### Bluetooth

```bash
bluetoothctl power on
bluetoothctl scan on
# Then pair via blueman-manager (tray icon or SUPER+SHIFT+B)
```

### Network

```bash
nmcli device status
# Or click the network tray icon (nm-applet)
```

### Steam / Proton

1. Launch Steam: `SUPER+4` (workspace 4) or `SUPER+Space` → type Steam
2. Log in, install World of Warcraft via Lutris or Steam with Proton.
3. Enable Steam Play: Steam → Settings → Compatibility → Enable Steam Play for all titles
4. Use **Proton-GE** for best WoW compatibility (install via ProtonUp-Qt).

### Run-or-Raise

- `SUPER+T` → Kitty terminal (opens or focuses existing window)
- `SUPER+B` → Chromium (opens or focuses)
- `SUPER+C` → VS Code (opens or focuses)

### Web App Keybinds

- `SUPER+F1` → Amazon Music (Chromium app mode, run-or-raise)
- `SUPER+F2` → GitHub (Chromium app mode, run-or-raise)

### Lock / Idle / Login Flow

- Manual lock: `SUPER+Escape` → hyprlock
- Idle auto-dim: 3 min; auto-lock: 5 min; display off: 8 min
- Suspend: 30 min idle (edit `dotfiles/hypr/hypridle.conf` to change)
- Login screen: greetd + regreet with wallpaper

---

## Customisation

| File | Purpose |
|------|---------|
| `dotfiles/hypr/monitors.lua` | Change resolution / refresh rate |
| `dotfiles/hypr/keybinds.lua` | All keyboard shortcuts |
| `dotfiles/waybar/config.jsonc` | Bar modules |
| `dotfiles/waybar/style.css` | Bar colours |
| `dotfiles/kitty/kitty.conf` | Terminal font/colours |
| `dotfiles/hypr/hyprlock.conf` | Lock screen layout |
| `dotfiles/hypr/hypridle.conf` | Idle timeouts |
| `dotfiles/bash/.bashrc` | Shell aliases, prompt, env |

---

## Assumptions & Notes

- GRUB is the bootloader; system boots in UEFI mode.
- The NVIDIA driver stack (`nvidia-open-dkms`, `nvidia-utils`) is used for the target RTX 3090 hardware. nouveau is blacklisted automatically by the NVIDIA packages.
- `nvidia_drm.modeset=1` is set in GRUB kernel parameters for proper Wayland support.
- AMD CPU microcode (`amd-ucode`) is installed for Ryzen 9 5950X.
- Caps Lock is remapped to Escape (see `input.lua` – remove `caps:escape` to revert).
- Default passwords are `changeme` – **change immediately** after install.
- The wallpaper is downloaded from GitHub; if the URL changes, update `WALLPAPER_URL` in `bootstrap_user.sh`.
- `dex` must be installed for XDG autostart (`yay -S dex` or `pacman -S dex`).
- `hyprpaper` must be installed: `sudo pacman -S hyprpaper`.
