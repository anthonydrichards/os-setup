#!/usr/bin/env bash
# =============================================================================
# install_arch_hyprland.sh
# Full unattended-ish Arch Linux installer for:
#   Ryzen 9 5950X | RTX 3090 | 32 GB DDR4 | 2 TB NVMe Gen3 | 2560x1440@165Hz
# Run from Arch live ISO as root.
# =============================================================================
set -euo pipefail

# ---------------------------------------------------------------------------
# USER-EDITABLE VARIABLES
# ---------------------------------------------------------------------------
DISK="/dev/nvme0n1"          # Target disk – confirmed before wiping
HOSTNAME="archbox"
USERNAME="user"
LOCALE="en_GB.UTF-8"
KEYMAP="gb"
TIMEZONE="Europe/London"
# EFI and root partition sizes (rest of disk goes to root)
EFI_SIZE="512MiB"
SWAP_SIZE="16GiB"            # zram is added post-install; this is a fallback swap partition
ROOT_FS="ext4"               # or btrfs – change to btrfs if you prefer subvolumes

# ---------------------------------------------------------------------------
# COLOUR HELPERS
# ---------------------------------------------------------------------------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# PREREQUISITES CHECK
# ---------------------------------------------------------------------------
[[ $EUID -ne 0 ]] && error "Must run as root."
command -v pacstrap &>/dev/null || error "Not running from Arch live ISO."
ping -c1 -W3 archlinux.org &>/dev/null || error "No internet. Configure network first (use ip/iwctl)."

# ---------------------------------------------------------------------------
# DISK SELECTION & CONFIRMATION
# ---------------------------------------------------------------------------
info "Available disks:"
lsblk -d -o NAME,SIZE,MODEL

echo
warn "Target disk is: ${DISK}"
warn "ALL DATA ON ${DISK} WILL BE PERMANENTLY DESTROYED."
read -r -p "Type YES (uppercase) to continue: " CONFIRM
[[ "${CONFIRM}" != "YES" ]] && error "Aborted by user."

# ---------------------------------------------------------------------------
# SET NTP
# ---------------------------------------------------------------------------
info "Enabling NTP..."
timedatectl set-ntp true

# ---------------------------------------------------------------------------
# PARTITION
# ---------------------------------------------------------------------------
info "Partitioning ${DISK}..."
# Wipe existing partition table
wipefs -af "${DISK}"
sgdisk --zap-all "${DISK}"

# Layout:
#   Part 1 – EFI System Partition (FAT32)
#   Part 2 – Linux swap
#   Part 3 – Linux root (ext4 / btrfs)
sgdisk -n 1:0:+${EFI_SIZE}  -t 1:ef00 -c 1:"EFI"  "${DISK}"
sgdisk -n 2:0:+${SWAP_SIZE} -t 2:8200 -c 2:"swap" "${DISK}"
sgdisk -n 3:0:0             -t 3:8300 -c 3:"root" "${DISK}"

# Determine partition names (nvme uses p-suffix, sata does not)
if [[ "${DISK}" == *nvme* ]]; then
    PART_EFI="${DISK}p1"
    PART_SWAP="${DISK}p2"
    PART_ROOT="${DISK}p3"
else
    PART_EFI="${DISK}1"
    PART_SWAP="${DISK}2"
    PART_ROOT="${DISK}3"
fi

# ---------------------------------------------------------------------------
# FORMAT
# ---------------------------------------------------------------------------
info "Formatting partitions..."
mkfs.fat -F32 -n EFI "${PART_EFI}"
mkswap -L swap "${PART_SWAP}"
if [[ "${ROOT_FS}" == "btrfs" ]]; then
    mkfs.btrfs -L root -f "${PART_ROOT}"
else
    mkfs.ext4 -L root -F "${PART_ROOT}"
fi

# ---------------------------------------------------------------------------
# MOUNT
# ---------------------------------------------------------------------------
info "Mounting file systems..."
mount "${PART_ROOT}" /mnt

if [[ "${ROOT_FS}" == "btrfs" ]]; then
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@snapshots
    umount /mnt
    mount -o defaults,noatime,compress=zstd,subvol=@ "${PART_ROOT}" /mnt
    mkdir -p /mnt/{home,.snapshots}
    mount -o defaults,noatime,compress=zstd,subvol=@home "${PART_ROOT}" /mnt/home
    mount -o defaults,noatime,compress=zstd,subvol=@snapshots "${PART_ROOT}" /mnt/.snapshots
fi

mkdir -p /mnt/boot/efi
mount "${PART_EFI}" /mnt/boot/efi
swapon "${PART_SWAP}"

# ---------------------------------------------------------------------------
# MIRROR RANKING (optional – comment out if slow)
# ---------------------------------------------------------------------------
info "Ranking mirrors (UK + worldwide)..."
pacman -Sy --noconfirm reflector
reflector --country 'United Kingdom' --latest 10 --sort rate \
    --save /etc/pacman.d/mirrorlist || \
reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist

# ---------------------------------------------------------------------------
# BASE INSTALL
# ---------------------------------------------------------------------------
info "Installing base system..."
pacstrap -K /mnt \
    base base-devel linux linux-headers linux-firmware \
    amd-ucode \
    networkmanager \
    grub efibootmgr \
    sudo git vim nano \
    zsh bash \
    reflector \
    cryptsetup lvm2

# ---------------------------------------------------------------------------
# FSTAB
# ---------------------------------------------------------------------------
info "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# ---------------------------------------------------------------------------
# CHROOT CONFIGURATION
# ---------------------------------------------------------------------------
info "Configuring system inside chroot..."

arch-chroot /mnt /bin/bash <<CHROOT
set -euo pipefail

# Timezone
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc

# Locale
sed -i "s/^#${LOCALE}/${LOCALE}/" /etc/locale.gen
echo "LANG=${LOCALE}" > /etc/locale.conf
locale-gen

# Keymap (console)
echo "KEYMAP=${KEYMAP}" > /etc/vconsole.conf

# Hostname
echo "${HOSTNAME}" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}
HOSTS

# mkinitcpio – add nvidia modules for early KMS
# Also add encrypt/resume hooks if needed later
sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
# Ensure 'kms' hook is NOT in HOOKS (conflicts with early NVIDIA KMS)
sed -i 's/ kms//' /etc/mkinitcpio.conf
mkinitcpio -P

# Bootloader (GRUB)
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

# GRUB: enable NVIDIA DRM + silent boot
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 rd.udev.log_level=3 nvidia_drm.modeset=1 amd_pstate=active"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Enable NetworkManager
systemctl enable NetworkManager

# Root password
echo "root:changeme" | chpasswd
warn_msg() { echo "[WARN] \$1"; }
warn_msg "Root password set to 'changeme' – change immediately after boot."

# Create user
useradd -m -G wheel,audio,video,storage,optical,input,gamemode -s /bin/bash ${USERNAME}
echo "${USERNAME}:changeme" | chpasswd
warn_msg "User password set to 'changeme' – change after first login."

# Sudo for wheel
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# NVIDIA pacman hook to rebuild initramfs on driver updates
mkdir -p /etc/pacman.d/hooks
cat > /etc/pacman.d/hooks/nvidia.hook <<'HOOK'
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux

[Action]
Description=Rebuild initramfs for NVIDIA driver update
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case \$trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
HOOK

CHROOT

# ---------------------------------------------------------------------------
# DONE
# ---------------------------------------------------------------------------
info "Base install complete."
info "Next: umount -R /mnt && reboot"
echo
warn "After reboot:"
echo "  1. Log in as root, change passwords: passwd root && passwd ${USERNAME}"
echo "  2. Run bootstrap_user.sh as ${USERNAME}"
