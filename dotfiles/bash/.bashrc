# =============================================================================
# .bashrc – Interactive bash configuration
# =============================================================================

# Not interactive? Return early.
[[ $- != *i* ]] && return

# ---------------------------------------------------------------------------
# HISTORY
# ---------------------------------------------------------------------------
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T  "
shopt -s histappend
shopt -s cmdhist

# ---------------------------------------------------------------------------
# SHELL OPTIONS
# ---------------------------------------------------------------------------
shopt -s checkwinsize   # update LINES/COLUMNS after each command
shopt -s globstar       # ** glob
shopt -s autocd         # type dir to cd
shopt -s cdspell        # correct minor cd typos

# ---------------------------------------------------------------------------
# PROMPT (minimal, no framework)
# Solarized Night colours via ANSI escape
# ---------------------------------------------------------------------------
_ps1_git() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
    echo " (${branch})"
}

# Colours
_C_RESET='\[\e[0m\]'
_C_CYAN='\[\e[38;5;37m\]'      # Solarized cyan
_C_BLUE='\[\e[38;5;33m\]'      # Solarized blue
_C_GREEN='\[\e[38;5;64m\]'     # Solarized green
_C_YELLOW='\[\e[38;5;136m\]'   # Solarized yellow
_C_MUTED='\[\e[38;5;66m\]'     # Solarized base01

PS1="${_C_CYAN}\u${_C_MUTED}@${_C_BLUE}\h${_C_MUTED}:${_C_GREEN}\w${_C_YELLOW}\$(_ps1_git)${_C_RESET} \$ "

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
export PATH="${HOME}/.local/bin:${PATH}"

# ---------------------------------------------------------------------------
# ENVIRONMENT
# ---------------------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-FRX --mouse'
export MANPAGER='nvim +Man!'

# Wayland / Qt
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland

# ---------------------------------------------------------------------------
# ALIASES
# ---------------------------------------------------------------------------
# ls → eza
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias la='eza -a --icons --group-directories-first'

# bat as cat
alias cat='bat --style=plain'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Editor shortcuts
alias vi='nvim'
alias vim='nvim'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# System
alias pacup='sudo pacman -Syu'
alias update='sudo pacman -Syu && yay -Syu'
alias ports='ss -tulpn'
alias df='df -hT'
alias du='du -sh'

# Hyprland helpers
alias hypreload='hyprctl reload'
alias hyprlog='cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -1)/hyprland.log | tail -50'

# ---------------------------------------------------------------------------
# ZOXIDE (smarter cd)
# ---------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
    alias cd='z'
fi

# ---------------------------------------------------------------------------
# FZF
# ---------------------------------------------------------------------------
if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
    source /usr/share/fzf/key-bindings.bash
fi
if [[ -f /usr/share/fzf/completion.bash ]]; then
    source /usr/share/fzf/completion.bash
fi

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_DEFAULT_OPTS='
  --height=40%
  --layout=reverse
  --border=rounded
  --color=bg+:#073642,bg:#002b36,spinner:#2aa198,hl:#268bd2
  --color=fg:#839496,header:#657b83,info:#b58900,pointer:#2aa198
  --color=marker:#2aa198,fg+:#93a1a1,prompt:#268bd2,hl+:#268bd2
'

# ---------------------------------------------------------------------------
# BASH COMPLETION
# ---------------------------------------------------------------------------
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# ---------------------------------------------------------------------------
# GPGAGENT (for SSH via GPG)
# ---------------------------------------------------------------------------
export GPG_TTY=$(tty)
