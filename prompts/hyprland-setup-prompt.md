Great project. To get a **high-quality LLM-generated Hyprland setup** quickly, your prompt should define 5 things clearly:

## 1) Scope and constraints (most important)
Tell the model exactly what to produce and what to avoid.

Use criteria like:
- **Target OS**: Arch Linux (fresh install), Hyprland on Wayland
- **Output format**:  
  1) `install.sh` (idempotent, rerunnable),  
  2) dotfiles repo structure,  
  3) README with post-install steps
- **Package policy**: minimal, no “kitchen sink”; only explicitly listed apps
- **Theme goal**: “Omarchy-like aesthetics, minimal app footprint”
- **Stability preference**: stable packages first, AUR only when necessary
- **No placeholders**: require complete, runnable configs

## 2) Hardware + performance profile
Give concrete hardware facts and ask for tuning decisions justified inline.

You already have:
- RTX 3090 (NVIDIA)
- Ryzen 5950X
- 32 GB RAM
- NVMe SSD

Criteria to include:
- Configure **NVIDIA-compatible Hyprland/Wayland settings**
- Prefer **low-latency UI and smooth animations**
- Keep background services lightweight
- Include optional gaming mode/profile for Steam + WoW usage
- Fast boot/login and low idle overhead

## 3) Exact app set (allowlist)
If you don’t specify this, the model will over-install.

Define:
- **Must-have**: VS Code, Neovim, Git/GitHub CLI, browser, terminal, file manager, launcher, notifications, clipboard, audio controls, screenshot tools
- **Nice-to-have**: web-app launcher, WoW/Steam support
- **Do-not-install**: anything not listed (office suites, mail clients, etc.)

Also specify preferred choices, e.g.:
- Terminal: `kitty`/`wezterm`/`alacritty`
- Bar: `waybar`
- Launcher: `wofi` or `rofi-wayland`
- Notifications: `mako`
- Clipboard: `wl-clipboard` + manager
- File manager: `thunar`/`yazi`/`nnn`

## 4) Behavior requirements (your special features)
This is where you encode what you liked from Omarchy.

Ask explicitly for:
- **Web app launcher framework**:
  - YAML/JSON file of app name + URL + icon
  - command creates fullscreen “app-like” launch (chromium/chrome `--app=URL`)
  - per-app `.desktop` entries
- **Smart keybind behavior**:
  - keybind opens app if absent, focuses existing window if present
  - implement with `hyprctl clients -j` + matcher script
- **Ergonomic split-keyboard binds**:
  - avoid awkward chords
  - prioritize home-row modifiers and two-key combos
  - include a “keybind profile” section for Glove80 ergonomics
- **Modal or leader-based shortcuts** (optional) to reduce chord strain

## 5) Quality gates (force a usable result)
Require the model to self-check output.

Include acceptance criteria:
- Clean boot to Hyprland with no config errors
- All listed keybinds documented and working
- Idempotent install script (`set -euo pipefail`, logging, checks)
- “verify.sh” that confirms binaries/config files/key services
- rollback/uninstall notes
- separate `packages.txt` and `aur-packages.txt`
- comments in config for every non-obvious line

---

## Prompt template you can paste into an LLM

```text
You are generating a production-ready personal Arch Linux + Hyprland setup.

Goal:
- Omarchy-like look/feel, but minimal and custom.
- Prioritize performance and usability over hardening for local threats.
- Only install explicitly requested apps.

My hardware:
- GPU: NVIDIA RTX 3090
- CPU: Ryzen 9 5950X
- RAM: 32GB DDR4
- Storage: 2TB Gen3 NVMe

Primary usage:
- Personal software development
- VS Code as primary editor, Neovim optional
- GitHub remote repos
- Light web browsing
- Occasional World of Warcraft (via Steam/Proton/Lutris-compatible workflow)

Deliverables:
1) install.sh (idempotent, rerunnable, with logging and clear errors)
2) dotfiles directory structure for Hyprland ecosystem
3) README.md with install, usage, customization, troubleshooting
4) verify.sh for post-install validation
5) packages.txt and aur-packages.txt

Constraints:
- Arch Linux + Hyprland (Wayland)
- Stable packages preferred; AUR only if necessary
- No extra apps beyond allowlist
- No placeholders or TODOs; provide complete files
- Script must detect and skip already-installed components
- Include comments for all non-obvious config lines

Allowlist (install only these categories with one concrete choice each):
- Terminal
- Browser
- Launcher
- Status bar
- Notification daemon
- File manager
- Clipboard tools
- Screenshot/screencast tools
- Audio stack/control tools
- VS Code
- Neovim
- Git + GitHub CLI
- Steam + dependencies for occasional gaming

Required behavior:
- Web app launcher system:
  - config file (JSON or YAML) listing app name, URL, icon
  - generate desktop entries
  - launch each as fullscreen app mode (chromium-based --app=URL)
- Smart keybind scripts:
  - “open-or-focus” behavior for key apps
  - if app window exists, focus it; else launch it
- Ergonomic keybind map for split keyboard (Glove80):
  - avoid difficult 3-key chords
  - prefer home-row/leader-based shortcuts
  - include a second alternative keybind profile section

NVIDIA/Wayland requirements:
- Include recommended env vars and Hyprland settings for NVIDIA stability/perf
- Explain each NVIDIA-specific decision in comments

Output format:
- First print final file tree
- Then print each file in full as:
  ### path/to/file
  ```bash|ini|conf|json|yaml
  ...
  ```
- End with “Post-install checklist” and “Known caveats”
```

---

If you want, I can help you do a **second-pass “tightened prompt”** with your exact app choices (kitty vs wezterm, wofi vs rofi, thunar vs yazi, etc.) so the generated output is even less likely to bloat.
