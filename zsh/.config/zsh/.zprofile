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

# Build path array (order matters: most specific → most general)
# Note: Empty $HOMEBREW_PREFIX is safe - (N-/) ignores non-existent paths
path=(
  # User binaries (highest priority)
  ${XDG_BIN_HOME:-$HOME/.local/bin}(N-/)
  
  # Homebrew GNU tools (prefer these over macOS BSD versions)
  $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin(N-/)
  $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin(N-/)
  $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin(N-/)
  $HOMEBREW_PREFIX/opt/grep/libexec/gnubin(N-/)
  $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin(N-/)
  $HOMEBREW_PREFIX/opt/make/libexec/gnubin(N-/)
  
  # Homebrew formula binaries (commonly needed)
  $HOMEBREW_PREFIX/opt/trash/bin(N-/)
  $HOMEBREW_PREFIX/opt/curl/bin(N-/)
  $HOMEBREW_PREFIX/opt/python/libexec/bin(N-/)
  $HOMEBREW_PREFIX/opt/ruby/bin(N-/)
  $HOMEBREW_PREFIX/opt/openssl/bin(N-/)
  
  # Development tools (add what you actually use)
  $HOME/.cargo/bin(N-/)              # Rust
  $HOME/.pyenv/bin(N-/)              # Python version manager
  ${GOPATH:+$GOPATH/bin}(N-/)        # Go
  
  # Homebrew core
  $HOMEBREW_PREFIX/{bin,sbin}(N-/)
  
  # System paths (lowest priority)
  /usr/local/{bin,sbin}(N-/)
  /usr/bin(N-/)
  /bin(N-/)
  /usr/sbin(N-/)
  /sbin(N-/)
)

# Man pages
manpath=(
  $HOME/.local/share/man(N-/)
  
  # Homebrew GNU man pages
  $HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman(N-/)
  $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman(N-/)
  $HOMEBREW_PREFIX/opt/findutils/libexec/gnuman(N-/)
  
  # Homebrew core
  $HOMEBREW_PREFIX/share/man(N-/)
  
  # System
  /usr/share/man(N-/)
)

# Zsh completions
fpath=(
  $XDG_DATA_HOME/zsh/completions(N-/) # custom completions
  $HOMEBREW_PREFIX/share/zsh/site-functions(N-/)
  $HOMEBREW_PREFIX/share/zsh-completions(N-/)
  /usr/share/zsh/site-functions(N-/)
  $fpath
)

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃         Login Session-Wide Settings          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Core environment setup
export GPG_TTY=$(tty)

# Conda/Mamba (session-level preferences)
export MAMBA_CHANGEPS1=false
export CONDA_CHANGEPS1=false
export CONDA_AUTO_ACTIVATE_BASE=false
export CONDA_ENVS_PATH="$HOME/.conda/envs"

# Default EDITOR (set once per session)
[[ -z $EDITOR ]] && for e in nvim vim vi nano; do
  (( $+commands[$e] )) && { export EDITOR=$e; break; }
done

# Default VISUAL (set once per session)
[[ -z $VISUAL ]] && for v in code vim; do
  (( $+commands[$v] )) && { export VISUAL=$v; break; }
done

# Homebrew Configuration
export HOMEBREW_VERBOSE=1                        # Detailed debug output (slower)
export HOMEBREW_NO_ANALYTICS=1                   # Privacy
export HOMEBREW_NO_ENV_HINTS=1                   # Clean output
export HOMEBREW_NO_AUTO_UPDATE=                  # Skip auto updates (faster but riskier)
export HOMEBREW_BUNDLE_NO_LOCK=1                 # No lock files for brew bundle
export HOMEBREW_INSTALL_CLEANUP=1                # Auto cleanup
export HOMEBREW_FORCE_BREWED_GIT=1               # Consistent git version
export HOMEBREW_FORCE_BREWED_CURL=1              # Consistent curl version
export HOMEBREW_NO_INSECURE_REDIRECT=1           # Security
export HOMEBREW_DISPLAY_INSTALL_TIMES=1          # Show install times
export HOMEBREW_BUNDLE_FILE="$HOME/.brewfile"    # Default brewfile path
