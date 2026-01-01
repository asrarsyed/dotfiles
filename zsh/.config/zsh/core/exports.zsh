# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#             Interactive Environments           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# History Settings
export HISTSIZE=100000
export SAVEHIST=100000

# Ensure the history directory exists
[[ -d "$XDG_STATE_HOME/history" ]] || mkdir -p "$XDG_STATE_HOME/history"

# General History Files (for various tools)
export HISTFILE="$XDG_STATE_HOME/history/.zsh_history"
export R_HISTFILE="$XDG_STATE_HOME/history/.r_history"
export NPM_HISTORY="$XDG_STATE_HOME/history/.npm_history"
export LESSHISTFILE="$XDG_STATE_HOME/history/.less_history"
export BASH_HISTFILE="$XDG_STATE_HOME/history/.bash_history"
export MYSQL_HISTFILE="$XDG_STATE_HOME/history/.mysql_history"
export SQLITE_HISTORY="$XDG_STATE_HOME/history/.sqlite_history"
export PYTHONHISTFILE="$XDG_STATE_HOME/history/.python_history"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/history/.node_repl_history"

# Homebrew Configuration
export HOMEBREW_VERBOSE=1                # Detailed debug output (slower)

# Autosuggest config (BEFORE sourcing)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20 # ignore commands longer than 20 lines
# optional ignores:
# ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *" # never suggest cd commands
# ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *" # ignore commands longer than 50 chars
# unset ZSH_AUTOSUGGEST_USE_ASYNC # disable async suggestions (for debugging)

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#              LS_COLORS Configuration            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Code 	  Effects         Notes
# ----    -------         -----
# 00      Reset           Set display state to default
# 01      Bold            Set color intensity to bold
# 02      Faint           Set color intensity to faint
# 03      Italic          Display text as italic
# 04      Underline       Display text as underline
# 07      Reverse         Reverse foreground and background
# 08      Erase           Display text as blank spaces
# 09      Strikethrough   Display text as strikethrough

# Available color codes:
# 30 - 90 : Black
# 31 - 91 : Red
# 32 - 92 : Green
# 33 - 93 : Yello
# 34 - 94 : Blue (purple)
# 35 - 95 : Purple (pink)
# 36 - 96 : Cyan (maroon)
# 37 - 97 : White

# Hidden files (green)
LS_COLORS+=":.*=92"

# Text & markup files (yellow)
LS_COLORS+=":*.md=93:*.txt=93:*.html=93"

# Shell and scripting files (yellow)
LS_COLORS+=":*.bash=95:*.zsh=95:*.fish=95"
LS_COLORS+=":*.bat=95:*.cmd=95"

# Config & dotfiles (yellow)
LS_COLORS+=":*.in=93:*.conf=93"
LS_COLORS+=":*.json=93:*.toml=93:*.yml=93"
LS_COLORS+=":.zshenv=93:.zshrc=93:.zprofile=93:.zlogin=93:.zlogout=93:.zsh_history=93"
LS_COLORS+=":.bashrc=93:.bash_profile=93:.gitconfig=93:.gitignore=93:.gitsecret=93:.editorconfig=93"

# Brewfile (purple)
LS_COLORS+=":.brewfile=95"

# Documentation & licenses (orange)
LS_COLORS+=":*README.md=91:*README=91:*LICENSE=91:*COPYING=91:*CHANGELOG=91"
LS_COLORS+=":*.rst=91:*.org=91"

# Design, assets, and images (pink)
LS_COLORS+=":*.png=95:*.jpg=95:*.jpeg=95:*.gif=95:*.webp=95:*.svg=95"
LS_COLORS+=":*.psd=95:*.ai=95:*.ico=95"

# Build systems & package managers (red)
LS_COLORS+=":*CMakeLists.txt=36:*.cmake=36:*.ninja=36"
LS_COLORS+=":*build.gradle=36:*pom.xml=36"
LS_COLORS+=":*package.json=36:*package-lock.json=36:*yarn.lock=36"
LS_COLORS+=":*requirements.txt=36:*pyproject.toml=36"

# Data & database files (red)
LS_COLORS+=":*.csv=36:*.tsv=36:*.sql=36"
LS_COLORS+=":*.db=36:*.sqlite=36:*.sqlite3=36"

# Final export
export LS_COLORS