# Profile File: Read every time! Only essential environment variables (e.g. PATH, LANG)!
# Execution Order: .zshenv ➜ .zprofile ➜ .zshrc ➜ .zlogin ➜ .zlogout

# ZSH Directory
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# XDG Base Directory Specification
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_PROJECTS_DIR="${XDG_PROJECTS_DIR:-$HOME/Developer}"

# Terminal Settings
export TERM=xterm-256color
export COLORTERM='truecolor'

# Language Settings
export LANG=${LANG:-en_US.UTF-8}

# macOS shell sessions
if [[ "$OSTYPE" == darwin* ]]; then
  export SHELL_SESSIONS_DISABLE=1
fi

# Skip global compinit
skip_global_compinit=1
