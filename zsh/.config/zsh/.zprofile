# Profile File: Read at Login! Only login-time config (e.g. PATH extensions, session vars)!
# Execution Order: .zshenv ➜ .zprofile ➜ .zshrc ➜ .zlogin ➜ .zlogout

# Ensure arrays are unique globally
typeset -gU path fpath manpath cdpath

# Use a hard-coded prefix for zero login-time cost
if [[ -d /opt/homebrew ]]; then          # Apple Silicon
  export HOMEBREW_PREFIX=/opt/homebrew
elif [[ -d /usr/local/Homebrew ]]; then  # Intel
  export HOMEBREW_PREFIX=/usr/local
else                                     # Fallback (rare)
  echo "Not in standard locations, it's possible Homebrew isn't installed!"
  export HOMEBREW_PREFIX=""
fi

# Early exit if Homebrew is not installed
[[ -z $HOMEBREW_PREFIX ]] && return 0

# Prepend in one array call i.e. (no external calls)
path=(
  $HOMEBREW_PREFIX/{bin,sbin}(N/)
  $path
)

manpath=(
  $HOMEBREW_PREFIX/share/man(N/)
  $manpath
)

fpath=(
  $HOMEBREW_PREFIX/share/zsh/site-functions(N/)
  $fpath
)
# Local binaries (only if they exist)
path=($HOME/.local/bin(N-/) $path)

# System binaries/admin fallback (after Homebrew)
path+=(/usr/local/{bin,sbin}(N/))

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#           Login Session-Wide Settings          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Core environment setup
# export GPG_TTY=$TTY

# Conda/Mamba (session-level preferences)
export MAMBA_CHANGEPS1=false
export CONDA_CHANGEPS1=false
export CONDA_AUTO_ACTIVATE_BASE=false
export CONDA_ENVS_PATH="$HOME/.conda/envs"

# PATH modifications
export PATH="/opt/homebrew/opt/trash/bin:$PATH"

# Default EDITOR (set once per session)
[[ -z $EDITOR ]] && for e in nvim vim vi nano; do
  (( $+commands[$e] )) && { export EDITOR=$e; break; }
done

# Default VISUAL (set once per session)
[[ -z $VISUAL ]] && for v in code vim; do
  (( $+commands[$v] )) && { export VISUAL=$v; break; }
done

# Homebrew Configuration
export HOMEBREW_NO_ANALYTICS=1           # Privacy
export HOMEBREW_NO_ENV_HINTS=1           # Clean output
export HOMEBREW_NO_AUTO_UPDATE=          # Skip auto updates (faster but riskier)
export HOMEBREW_BUNDLE_NO_LOCK=1         # No lock files for brew bundle
export HOMEBREW_INSTALL_CLEANUP=1        # Auto cleanup
export HOMEBREW_FORCE_BREWED_CURL=1      # Consistent curl version
export HOMEBREW_BUNDLE_FILE=~/.brewfile   # Default Brewfile path

# Man Configuration
export MANWIDTH='100'
export MANPAGER='nvim +Man!'

# Less Configuration
export PAGER=less
export LESS='-~ --tabs=4 --incsearch -i --LONG-PROMPT -c -d -J --jump-target=10 -S -R -s'
export LESSOPEN="|$HOME/scripts/lessfilter.sh %s"

# Less Colors
if [[ ${PAGER} == 'less' ]]; then
    (( ! ${+LESS_TERMCAP_mh} )) && export LESS_TERMCAP_mh=$'\e[2m'             # Turn on dim mode
    (( ! ${+LESS_TERMCAP_mr} )) && export LESS_TERMCAP_mr=$'\e[7m'             # Turn on reverse mode
    (( ! ${+LESS_TERMCAP_me} )) && export LESS_TERMCAP_me=$'\e[0m'             # Turn off all attributes
    (( ! ${+LESS_TERMCAP_mb} )) && export LESS_TERMCAP_mb=$'\E[1;31m'          # Begins blinking
    (( ! ${+LESS_TERMCAP_se} )) && export LESS_TERMCAP_se=$'\e[27;0m'          # Exit standout mode
    (( ! ${+LESS_TERMCAP_so} )) && export LESS_TERMCAP_so=$'\e[1;33m'          # Begin standout mode
    (( ! ${+LESS_TERMCAP_ue} )) && export LESS_TERMCAP_ue=$'\e[24;0m'          # Exit underline mode
    (( ! ${+LESS_TERMCAP_md} )) && export LESS_TERMCAP_md=$'\e[01;34m'         # Turn on bold mode
    (( ! ${+LESS_TERMCAP_us} )) && export LESS_TERMCAP_us=$'\e[4;1;38;5;250m'  # Begin underline mode
fi