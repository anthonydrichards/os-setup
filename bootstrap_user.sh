#!/usr/bin/env bash
# =============================================================================
# bootstrap_user.sh
# Run after first boot as the regular user (sudo access required).
# Installs all packages, AUR packages, enables services, deploys dotfiles.
# =============================================================================
set -euo pipefail

# ---------------------------------------------------------------------------
# VARIABLES
# ---------------------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles" && pwd)"
AUR_HELPER="yay"
WALLPAPER_URL="https://raw.githubusercontent.com/dharmx/walls/main/solarized/a_planet_in_space_with_clouds.jpg"
WALLPAPER_DEST="${HOME}/.local/share/backgrounds/space.jpg"

# ---------------------------------------------------------------------------
# HELPERS
# ---------------------------------------------------------------------------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# PREREQUISITES
# ---------------------------------------------------------------------------
[[ $EUID -eq 0 ]] && error "Do NOT run as root. Run as your regular user with sudo access."
command -v sudo &>/dev/null || error "sudo not found."
ping -c1 -W3 archlinux.org &>/dev/null || error "No internet connection."
[[ -d "${DOTFILES_DIR}" ]] || error "dotfiles/ directory not found next to this script."

# ---------------------------------------------------------------------------
# PACMAN CONFIGURATION
# ---------------------------------------------------------------------------
info "Configuring pacman..."
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
# Enable multilib for 32-bit Steam/Proton libs
if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo -e '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist' | sudo tee -a /etc/pacman.conf
fi
sudo pacman -Syu --noconfirm

# ---------------------------------------------------------------------------
# OFFICIAL REPO PACKAGES
# ---------------------------------------------------------------------------
info "Installing official repo packages..."
sudo pacman -S --needed --noconfirm \
    \
    `# --- Wayland / Hyprland stack ---` \
    hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    wayland wayland-protocols libdrm \
    \
    `# --- Display / Login ---` \
    greetd greetd-regreet cage \
    \
    `# --- Bar / Notifications / Clipboard ---` \
    waybar \
    mako \
    wl-clipboard cliphist \
    \
    `# --- Launcher / Idle / Lock ---` \
    fuzzel \
    hypridle hyprlock \
    \
    `# --- Terminal / File managers ---` \
    kitty \
    thunar thunar-archive-plugin thunar-volman tumbler \
    yazi \
    \
    `# --- Screenshot ---` \
    hyprshot \
    \
    `# --- Audio ---` \
    pipewire pipewire-alsa pipewire-pulse wireplumber \
    pavucontrol \
    \
    `# --- Bluetooth ---` \
    bluez bluez-utils blueman \
    \
    `# --- Network ---` \
    network-manager-applet \
    \
    `# --- NVIDIA ---` \
    nvidia-open-dkms nvidia-utils nvidia-settings \
    lib32-nvidia-utils opencl-nvidia \
    libvdpau libva-nvidia-driver \
    \
    `# --- Vulkan (gaming) ---` \
    vulkan-icd-loader lib32-vulkan-icd-loader \
    \
    `# --- Gaming ---` \
    steam gamemode lib32-gamemode \
    mangohud lib32-mangohud \
    \
    `# --- Fonts ---` \
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji \
    \
    `# --- GTK theming ---` \
    gtk3 gtk4 gsettings-desktop-schemas \
    lxappearance \
    xdg-user-dirs \
    \
    `# --- Shell / CLI tools ---` \
    bash bash-completion \
    git git-delta gh \
    neovim \
    tmux \
    btop htop \
    eza bat ripgrep fd zoxide fzf \
    wget curl unzip zip p7zip \
    man-db man-pages \
    jq \
    \
    `# --- Misc system ---` \
    polkit polkit-gnome \
    gnome-keyring libsecret seahorse \
    gvfs gvfs-mtp \
    playerctl \
    brightnessctl \
    udiskie \
    \
    `# --- Chromium ---` \
    chromium \
    \
    `# --- Calculator ---` \
    qalculate-gtk \
    \
    `# --- Hyprland extras ---` \
    hyprpaper dex

# ---------------------------------------------------------------------------
# YAY (AUR HELPER)
# ---------------------------------------------------------------------------
if ! command -v yay &>/dev/null; then
    info "Installing yay..."
    tmp_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "${tmp_dir}/yay"
    (cd "${tmp_dir}/yay" && makepkg -si --noconfirm)
    rm -rf "${tmp_dir}"
fi

# ---------------------------------------------------------------------------
# AUR PACKAGES
# ---------------------------------------------------------------------------
info "Installing AUR packages..."
yay -S --needed --noconfirm \
    visual-studio-code-bin \
    hyprpicker \
    1password \
    opencode-bin \
    \
    `# --- Cursor theme (Bibata – neutral dark, pairs well with Solarized Night) ---` \
    bibata-cursor-theme \
    \
    `# --- GTK theme: Adwaita-dark or Solarized-inspired ---` \
    adw-gtk3 \
    \
    `# --- papirus icons (dark variant works great with Solarized Night) ---` \
    papirus-icon-theme

# ---------------------------------------------------------------------------
# 1PASSWORD CHROMIUM EXTENSION (managed policy)
# ---------------------------------------------------------------------------
info "Configuring 1Password Chromium extension policy..."
CHROMIUM_POLICY_DIR="/etc/chromium/policies/managed"
sudo mkdir -p "${CHROMIUM_POLICY_DIR}"
sudo tee "${CHROMIUM_POLICY_DIR}/1password.json" > /dev/null <<'POLICY'
{
  "ExtensionInstallForcelist": [
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa;https://clients2.google.com/service/update2/crx"
  ]
}
POLICY

# ---------------------------------------------------------------------------
# ENABLE SYSTEM SERVICES
# ---------------------------------------------------------------------------
info "Enabling system services..."
sudo systemctl enable --now bluetooth
sudo systemctl enable greetd

# ---------------------------------------------------------------------------
# ENABLE USER SERVICES
# ---------------------------------------------------------------------------
info "Enabling user services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# ---------------------------------------------------------------------------
# WALLPAPER
# ---------------------------------------------------------------------------
info "Downloading wallpaper..."
mkdir -p "$(dirname "${WALLPAPER_DEST}")"
if [[ ! -f "${WALLPAPER_DEST}" ]]; then
    curl -fsSL "${WALLPAPER_URL}" -o "${WALLPAPER_DEST}" || \
        warn "Wallpaper download failed – place image manually at ${WALLPAPER_DEST}"
else
    info "Wallpaper already present."
fi

# ---------------------------------------------------------------------------
# XDG USER DIRS
# ---------------------------------------------------------------------------
xdg-user-dirs-update

# ---------------------------------------------------------------------------
# DEPLOY DOTFILES
# ---------------------------------------------------------------------------
info "Deploying dotfiles..."

deploy() {
    local src="${DOTFILES_DIR}/$1"
    local dst="${HOME}/$2"
    if [[ ! -e "${src}" ]]; then
        warn "Source missing: ${src} – skipping"
        return
    fi
    mkdir -p "$(dirname "${dst}")"
    # Backup if exists and is not already a symlink to our src
    if [[ -e "${dst}" && ! -L "${dst}" ]]; then
        mv "${dst}" "${dst}.bak.$(date +%s)"
        warn "Backed up existing ${dst}"
    fi
    ln -sf "${src}" "${dst}"
    info "Linked ${dst} -> ${src}"
}

deploy "hypr"                ".config/hypr"
deploy "waybar"              ".config/waybar"
deploy "kitty"               ".config/kitty"
deploy "fuzzel"              ".config/fuzzel"
deploy "mako"                ".config/mako"
deploy "gtk-3.0"             ".config/gtk-3.0"
deploy "gtk-4.0"             ".config/gtk-4.0"
deploy "xfce4"               ".config/xfce4"
deploy "scripts"             ".local/bin"
deploy "bash/.bashrc"        ".bashrc"
deploy "bash/.bash_profile"  ".bash_profile"
deploy "nvim"                ".config/nvim"

# VSCode: install Solarized Night extension
if command -v code &>/dev/null; then
    code --install-extension guilhermerodz.solarized-night --force || \
        warn "VSCode extension install failed – install 'guilhermerodz.solarized-night' manually"
fi

deploy "vscode/settings.json" ".config/Code/User/settings.json"

# Ensure scripts are executable
chmod +x "${HOME}/.local/bin/"* 2>/dev/null || true

# ---------------------------------------------------------------------------
# GSETTINGS (GTK / cursor theme application)
# ---------------------------------------------------------------------------
info "Applying GTK / cursor settings via gsettings..."
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"

gsettings set org.gnome.desktop.interface gtk-theme        "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface icon-theme       "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme     "Bibata-Modern-Classic"
gsettings set org.gnome.desktop.interface cursor-size      24
gsettings set org.gnome.desktop.interface font-name        "JetBrainsMonoNL Nerd Font 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMonoNL Nerd Font Mono 11"
gsettings set org.gnome.desktop.interface clock-format     "24h"
gsettings set org.gnome.desktop.interface color-scheme     "prefer-dark"

# ---------------------------------------------------------------------------
# GREETD CONFIG
# ---------------------------------------------------------------------------
info "Configuring greetd..."
sudo tee /etc/greetd/config.toml > /dev/null <<'GREETD'
[terminal]
vt = 1

[default_session]
command = "dbus-run-session -- cage -s -- regreet"
user = "greeter"
GREETD

# Keep regreet on the same GTK configuration as the desktop session.
sudo install -d -o greeter -g greeter /var/lib/greetd/.config/gtk-3.0 /var/lib/greetd/.config/gtk-4.0
sudo install -m 0644 -o greeter -g greeter "${HOME}/.config/gtk-3.0/settings.ini" /var/lib/greetd/.config/gtk-3.0/settings.ini
sudo install -m 0644 -o greeter -g greeter "${HOME}/.config/gtk-4.0/settings.ini" /var/lib/greetd/.config/gtk-4.0/settings.ini

if [[ -f "${HOME}/.config/gtk-3.0/gtk.css" ]]; then
    sudo install -m 0644 -o greeter -g greeter "${HOME}/.config/gtk-3.0/gtk.css" /var/lib/greetd/.config/gtk-3.0/gtk.css
fi

if [[ -f "${HOME}/.config/gtk-4.0/gtk.css" ]]; then
    sudo install -m 0644 -o greeter -g greeter "${HOME}/.config/gtk-4.0/gtk.css" /var/lib/greetd/.config/gtk-4.0/gtk.css
fi

sudo mkdir -p /etc/greetd
sudo tee /etc/greetd/regreet.toml > /dev/null <<REGREETCONF
[background]
path = "${WALLPAPER_DEST}"
fit = "Cover"

[GTK]
application_id = "regreet"
application_prefer_dark_theme = true
cursor_theme_name = "Bibata-Modern-Classic"
font_name = "JetBrainsMonoNL Nerd Font 12"
icon_theme_name = "Papirus-Dark"
theme_name = "adw-gtk3-dark"

[appearance]
greeting_msg = "Welcome back"

[env]
XCURSOR_THEME = "Bibata-Modern-Classic"
XCURSOR_SIZE = "24"
GTK_THEME = "adw-gtk3-dark"
XDG_CONFIG_HOME = "/var/lib/greetd/.config"
REGREETCONF

# ---------------------------------------------------------------------------
# NVIDIA DRM MODESET (ensure kernel param is set)
# ---------------------------------------------------------------------------
if ! grep -q 'nvidia_drm.modeset=1' /etc/default/grub 2>/dev/null; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia_drm.modeset=1"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# ---------------------------------------------------------------------------
# ZRAM (better than swap partition for desktop)
# ---------------------------------------------------------------------------
if ! pacman -Q zram-generator &>/dev/null; then
    sudo pacman -S --needed --noconfirm zram-generator
fi
sudo tee /etc/systemd/zram-generator.conf > /dev/null <<'ZRAM'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
ZRAM
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service || true

# ---------------------------------------------------------------------------
# DONE
# ---------------------------------------------------------------------------
info "Bootstrap complete."
echo
echo "  Reboot or log out and select Hyprland in greetd/regreet."
echo "  Default keybind to open terminal: SUPER + T"
echo "  See KEYBINDS.md for the full reference."
