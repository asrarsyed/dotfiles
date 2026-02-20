# Profile File: Read when Interactive! Aliases, functions, options are set here!
# Execution Order: .zshenv ➜ .zprofile ➜ .zshrc ➜ .zlogin ➜ .zlogout

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#        Starship Configuration File Version      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

(( $+commands[starship] )) && export STARSHIP_CONFIG="$HOME/.config/starship/version01.toml"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#     Preload Options, Exports, Zap Installer    ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local -a core_files=(
    "$ZDOTDIR/core/options.zsh"                  # setopt/unsetopt shell options
    "$ZDOTDIR/core/exports.zsh"                  # PATH, LANG, XDG, other environment variables
    "$HOME/.local/share/zap/zap.zsh"             # Load zap plugin manager installer
)

for file in $core_files; do
    [[ -f $file ]] && source $file
done

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#          Editing zap.zsh Documentation         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Inside zap.zsh replace: _try_source && { ZAP_INSTALLED_PLUGINS+="$plugin_name" && return 0 } || echo " $plugin_name not activated" && return 1
# With Following:
# if [[ -n $ZAP_NO_SOURCE ]]; then
#     ZAP_INSTALLED_PLUGINS+="$plugin_name"
#     return 0
# fi

# _try_source && {
#     ZAP_INSTALLED_PLUGINS+="$plugin_name"
#     return 0
# } || {
#     echo "❌ $plugin_name not activated"
#     return 1
# }

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#          Load Essential Workflow Plugins        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Enable install-only mode
ZAP_NO_SOURCE=1

# Load zsh-defer early
plug "romkatv/zsh-defer"
source $ZAP_PLUGIN_DIR/zsh-defer/zsh-defer.plugin.zsh

# Load compinit, zcompdump, zstyle settings
zsh-defer source $ZDOTDIR/core/supercharge.zsh

# Install remaining plugins once
plug "zap-zsh/vim"                               # Mostly key bindings, moderate
plug "Aloxaf/fzf-tab"                            # A heavier plugin for fzf-tabbing
plug "hlissner/zsh-autopair"                     # Slow but essential for experience
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"         # Heavy syntax highlighting last
plug "zsh-users/zsh-history-substring-search"    # Relatively light, improves navigation?

# Defer ONLY sourcing - execution (explicit entrypoints, minimal delays)
zsh-defer source $ZAP_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZAP_PLUGIN_DIR/vim/vim.plugin.zsh
zsh-defer source $ZAP_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh
zsh-defer source $ZAP_PLUGIN_DIR/zsh-autopair/autopair.zsh
zsh-defer source $ZAP_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh

# Bind autosuggest widgets ONCE, after everything exists
zsh-defer _zsh_autosuggest_bind_widgets

# Final UI sync — ONE redraw - Syntax highlighting MUST be last
zsh-defer source $ZAP_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source $ZDOTDIR/core/syntaxtheme.zsh

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#    Postload Compinit & Personal Configurations  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

zsh-defer source "$ZDOTDIR/plus/fzfconfig.zsh"   # fzf helpers/bindings/plugin
zsh-defer source "$ZDOTDIR/plus/aliases.zsh"     # user-defined command aliases
zsh-defer source "$ZDOTDIR/plus/functions.zsh"   # user-defined shell functions
zsh-defer -c "fpath=($ZDOTDIR/func \$fpath); autoload -Uz $ZDOTDIR/func/*(.:t)" # user-defined shell functions

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#     Initialize and Cache Deterministic Tools   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

function cache_init() {
    local tool=$1
    local init_cmd=$2
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    local cache_file="${cache_dir}/${tool}.zsh"
    
    # Early exit if tool doesn't exist
    (( $+commands[$tool] )) || return 0
    
    mkdir -p "$cache_dir"
    
    # Regenerate cache if missing, empty, or outdated
    if [[ ! -s "$cache_file" ]] || [[ "$commands[$tool]" -nt "$cache_file" ]]; then
        eval "$init_cmd" >| "$cache_file.tmp" 2>/dev/null && {
            mv "$cache_file.tmp" "$cache_file"
            zcompile -U "$cache_file" 2>/dev/null
        }
    fi
    
    # Source the cached initialization
    source "$cache_file"
    
    # Handle completions if third argument provided
    if [[ -n $3 ]]; then
        local completion_cmd=$3
        local completion_file="$ZDOTDIR/completions/_${tool}"
        
        if [[ ! -f "$completion_file" ]] || [[ "$commands[$tool]" -nt "$completion_file" ]]; then
            mkdir -p "$ZDOTDIR/completions"
            eval "$completion_cmd" > "$completion_file" 2>/dev/null
        fi
    fi
}

zsh-defer cache_init "fzf" "fzf --zsh"
zsh-defer cache_init "zoxide" "zoxide init zsh --hook pwd"
zsh-defer cache_init "tv" "tv init zsh" "tv completion zsh"
zsh-defer cache_init "atuin" "atuin init zsh" "atuin gen-completions --shell zsh"
cache_init "starship" "starship init zsh" # ~2–2.3× extra first prompt/command time, i.e., ~230% overhead.
# cache_init "fnm" "fnm env --shell zsh --use-on-cd" "fnm completions --shell zsh"

# Load bindings settings after initializing tools
zsh-defer source "$ZDOTDIR/plus/keybinds.zsh"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃      Generate Completions for CLI Tools      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Helper function to generate completions if tool exists
generate_completion() {
    local tool=$1
    local cmd=$2
    local completion_file="$ZDOTDIR/completions/_${tool}"
    
    (( $+commands[$tool] )) || return 0
    
    if [[ ! -f "$completion_file" ]] || [[ "$commands[$tool]" -nt "$completion_file" ]]; then
        mkdir -p "$ZDOTDIR/completions"
        eval "$cmd" > "$completion_file" 2>/dev/null
    fi
}

# Generate completions for installed tools (deferred, runs after prompt)
zsh-defer generate_completion "glow" "glow completion zsh"
zsh-defer generate_completion "docker" "docker completion zsh"
zsh-defer generate_completion "colima" "colima completion zsh"
zsh-defer generate_completion "rustup" "rustup completions zsh"
zsh-defer generate_completion "cargo" "rustup completions zsh cargo"

# Starship Newline; has to be last
source "$ZDOTDIR/plus/starship.zsh"