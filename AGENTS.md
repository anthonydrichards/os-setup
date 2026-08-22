# AGENTS.md

This is a personal Arch Linux + Hyprland desktop setup repo. There is no build system, test suite, linter, or CI. The "runnable" artifacts are two provisioning scripts and symlinked dotfiles.

## Repo layout

| Path | Purpose |
|------|---------|
| `install_arch_hyprland.sh` | Step 1: Arch base install — run as **root** on live ISO |
| `bootstrap_user.sh` | Step 2: User environment setup — run as **regular user** post-boot |
| `dotfiles/` | Symlinked to `~/.config/<dir>` by bootstrap |
| `dotfiles/scripts/` | Symlinked to `~/.local/bin/` |
| `dotfiles/hypr/` | Hyprland config (Lua API, not `.conf`) |
| `dotfiles/regreet/` | ReGreet Solarized Dark theme (`regreet.css`) |
| `prompts/` | Reference LLM prompt — not executed |

## Provisioning commands

```bash
# Step 1 — from Arch live ISO as root (edit variables at top first)
bash install_arch_hyprland.sh
umount -R /mnt && reboot

# Step 2 — after first boot, as regular user (NOT root)
git clone https://github.com/anthonydrichards/os-setup.git ~/os-setup
cd ~/os-setup
chmod +x bootstrap_user.sh
./bootstrap_user.sh
```

Bootstrap is idempotent (`--needed`, symlink checks, `.bak.<epoch>` backups). Re-running it to redeploy dotfiles is safe.

## Critical constraints

- `install_arch_hyprland.sh` **must run as root**. `bootstrap_user.sh` **rejects root** (`$EUID -eq 0` check).
- Default passwords are `changeme` for both root and user — change immediately.
- Target hardware is hardcoded: Ryzen 9 5950X (`amd-ucode`), RTX 3090 (`nvidia-open-dkms`), NVMe at `/dev/nvme0n1`. Update the variable block at the top of `install_arch_hyprland.sh` for different hardware.
- Locale/region is UK: `en_GB.UTF-8`, keymap `gb`, timezone `Europe/London`. Update for other regions.
- `install_arch_hyprland.sh` uses `wipefs -af` + `sgdisk --zap-all` — **destructive, no recovery**.

## Hyprland Lua config API

All `dotfiles/hypr/*.lua` files use the **new Hyprland Lua API** (`hl.*` global namespace: `hl.config()`, `hl.bind()`, `hl.monitor()`, `hl.window_rule()`, `hl.exec_cmd()`, `hl.on()`, `hl.animation()`, etc.). These are **not** standalone Lua scripts — the `hl` global is injected by Hyprland at load time. `hyprland.lua` is the entrypoint and `dofile()`s the other modules.

Reload after editing:
```bash
hyprctl reload   # or alias: hypreload
```

## Known bugs in keybinds.lua

Two keybind conflicts exist:
- `SUPER+P` bound to both `fuzzel` launcher (line 26) and `hl.dsp.window.pseudo()` (line 87)
- `SUPER+SHIFT+F` bound to both `thunar` (line 15) and toggle maximise (line 86)

## NVIDIA Wayland setup

Key env vars set in `hyprland.lua`: `GBM_BACKEND=nvidia-drm`, `__GLX_VENDOR_LIBRARY_NAME=nvidia`, `LIBVA_DRIVER_NAME=nvidia`, `WLR_NO_HARDWARE_CURSORS=0`. A pacman hook at `/etc/pacman.d/hooks/nvidia.hook` auto-rebuilds initramfs on kernel/NVIDIA updates. The `kms` mkinitcpio hook is removed to avoid NVIDIA conflicts.

Verify NVIDIA after install:
```bash
nvidia-smi
glxinfo | grep "OpenGL renderer"
LIBVA_DRIVER_NAME=nvidia vainfo
hyprctl monitors   # expect refreshRate: 165.000000
```

## Dotfile deployment detail

`bootstrap_user.sh` symlinks `dotfiles/<dir>` → `~/.config/<dir>` for each subdirectory, and `dotfiles/scripts` → `~/.local/bin`. Existing non-symlink targets are backed up as `<target>.bak.<epoch>`.

## Run-or-raise scripts

`dotfiles/scripts/ror` and `dotfiles/scripts/webapp` use `hyprctl clients -j` piped to inline `python3` JSON to find existing windows, then dispatch `focuswindow` or exec the app. They depend on window class/title matching.

## Wallpaper

Downloaded from `dharmx/walls` GitHub repo during bootstrap. If that URL is unavailable, place the wallpaper manually at `~/.local/share/backgrounds/space.jpg`.

## Stray artifacts

`dotfiles/scripts/scripts/` and `dotfiles/hypr/hypr/` are nested duplicate directories — likely harmless since symlinks point to the parent, but anomalous.

## Theme stack

`adw-gtk3-dark` (GTK), `Papirus-Dark` (icons), `Bibata-Modern-Classic` (cursor), `JetBrainsMonoNL Nerd Font`, `Solarized Dark` (VS Code/Neovim).

## AUR packages

`visual-studio-code-bin`, `hyprpicker`, `1password`, `opencode-bin`, `bibata-cursor-theme`, `adw-gtk3`, `papirus-icon-theme` — installed via `yay` in bootstrap.
