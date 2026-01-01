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
zsh-defer source $ZDOTDIR/plus/supercharge.zsh

# Install remaining plugins once
plug "zap-zsh/vim"                               # Mostly key bindings, moderate
plug "Aloxaf/fzf-tab"                            # A heavier plugin for fzf-tabbing
plug "hlissner/zsh-autopair"                     # Slow but essential for experience
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"         # Heavy syntax highlighting last
plug "MichaelAquilina/zsh-you-should-use"        # Reminds you to use existing aliases
plug "zsh-users/zsh-history-substring-search"    # Relatively light, improves navigation?

# Defer ONLY sourcing - execution (explicit entrypoints, minimal delays)
zsh-defer source $ZAP_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZAP_PLUGIN_DIR/vim/vim.plugin.zsh
zsh-defer source $ZAP_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh
zsh-defer source $ZAP_PLUGIN_DIR/zsh-autopair/autopair.zsh
zsh-defer source $ZAP_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh
zsh-defer source $ZAP_PLUGIN_DIR/zsh-you-should-use/you-should-use.plugin.zsh

# Bind autosuggest widgets ONCE, after everything exists
zsh-defer _zsh_autosuggest_bind_widgets

# Final UI sync — ONE redraw - Syntax highlighting MUST be last
zsh-defer source $ZAP_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source $ZDOTDIR/plus/highlighting.zsh

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#    Postload Compinit & Personal Configurations  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

zsh-defer source "$ZDOTDIR/plus/fzfsettings.zsh" # fzf helpers/bindings/plugin
zsh-defer source "$ZDOTDIR/plus/aliases.zsh"     # user-defined command aliases
zsh-defer source "$ZDOTDIR/plus/functions.zsh"   # user-defined shell functions

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#     Initialize and Cache Deterministic Tools   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

function cache_init() {
    local tool=$1
    local init_cmd=$2
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    local cache_file="${cache_dir}/${tool}.zsh"
    local tool_path
    
    # Early exit if tool doesn't exist
    tool_path=$(command -v "$tool") || return 0
    
    # Ensure cache directory exists
    mkdir -p "$cache_dir"
    
    # Regenerate cache if missing or outdated
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        eval "$init_cmd" >| "$cache_file.tmp" && mv "$cache_file.tmp" "$cache_file"
    fi
    
    # Source the cached initialization
    source "$cache_file"
}

zsh-defer cache_init "fzf" "fzf --zsh"
zsh-defer cache_init "zoxide" "zoxide init zsh --hook pwd"
cache_init "starship" "starship init zsh" # ~2–2.3× extra first prompt/command time, i.e., ~230% overhead.

# # Ensure fnm exists
# if (( $+commands[fnm] )); then
#   # Lazy env setup
#   cache_init "fnm" "fnm env --shell zsh --use-on-cd"

#   # Optional: completions
#   FPATH+=~/.config/zsh/completions
#   [[ ! -f ~/.config/zsh/completions/_fnm ]] && fnm completions --shell zsh > ~/.config/zsh/completions/_fnm
#   autoload -Uz _fnm
# fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#            Starship Newline Behavior           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Tmux Newline Behavior
if [[ -n "$TMUX" ]]; then
  PROMPT_NEEDS_NEWLINE=true  # In tmux: show newline on first prompt
else
  PROMPT_NEEDS_NEWLINE=false  # Otherwise: no newline initially
fi

# Add newline before prompt (when needed)
function precmd_starship_newline() {
    if [[ "$PROMPT_NEEDS_NEWLINE" == true ]]; then
        echo
    fi
    PROMPT_NEEDS_NEWLINE=true
}

# add-zsh-hook is loaded in zsh-modules.zsh
add-zsh-hook precmd precmd_starship_newline

# Clear command patch (preserve behavior)
function clear() {
    if [[ -n "$TMUX" ]]; then
        PROMPT_NEEDS_NEWLINE=true
    else
        PROMPT_NEEDS_NEWLINE=false
    fi
    command clear
}