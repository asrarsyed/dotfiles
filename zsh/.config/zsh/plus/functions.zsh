# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#                Bindkey Functions               ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Replace multiple dots (.. -> ../., ... -> ../../., etc.)
function replace_multiple_dots() {
  local dots=$LBUFFER[-3,-1]
  if [[ $dots =~ "^[ //\"']?\.\.$" ]]; then
    LBUFFER=$LBUFFER[1,-3]'../.'
  fi
  zle self-insert
}
zle -N replace_multiple_dots
bindkey "." replace_multiple_dots

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#             Shell Wrapper Functions            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Save original function
eval "$(typeset -f zap | sed 's/^zap/original_zap/')"

# Wrap Zap + override update self
zap() {
  if [[ "$1" == "update" && ( "$2" == "self" || "$2" == "all" ) ]]; then
      :  # no-op
  else
      original_zap "$@"
  fi
}

# Wrap stow
stow() {
  # Check if the first argument is invalid
  if [[ $# -eq 0 || "$1" == "." || "$1" == "./" || "$1" == "*" || "$1" == "*/" ]]; then
    echo "🔴 Unsafe stow invocation blocked."
    echo "🟢 Use: stow package1 package2 or stowdots"
    return 1
  fi
  # Otherwise, call the real stow
  command stow "$@"
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃       Dynamic-Neovim-Profile-Switcher         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Usage: nvims [profile] [nvim-args]
# Companion functions: nvims_install, nvims_tmp
# Completion: compdef _nvims nvims

nvims() {
    emulate -L zsh
    setopt pipefail no_unset

    local base="${XDG_CONFIG_HOME:-$HOME/.config}/nvim-profiles"
    local profile="$1"
    local -a args profiles

    # Silent no-op if base doesn't exist yet
    [[ -d "$base" ]] || return 0

    # If first arg is a valid profile, use it directly
    if [[ -n "$profile" && -d "${base}/${profile}" ]]; then
        args=("${@:2}")
    else
        # Collect available profiles via pure zsh globbing
        profiles=("${base}"/*(N:t))

        # Silent no-op if no profiles exist
        (( ${#profiles} )) || return 0

        profile=$(printf '%s\n' "${profiles[@]}" | fzf \
            --prompt=" Neovim Profile: " \
            --height=~50% \
            --layout=reverse \
            --border \
            --exit-0)

        [[ -n "$profile" ]] || return 0
        args=("$@")
    fi

    # Profile already validated above — no redundant directory re-check needed
    NVIM_APPNAME="${base:t}/${profile}" command nvim "${args[@]}"
}

nvims_tmp() {
    emulate -L zsh
    setopt pipefail no_unset

    local base="${XDG_CONFIG_HOME:-$HOME/.config}/nvim-profiles"
    local tmp_link="${base}/tmp"

    mkdir -p "$base" || return 1
    [[ -L "$tmp_link" ]] && rm "$tmp_link"

    ln -s "${PWD:A}" "$tmp_link" || return 1
    nvims tmp
}

nvims_install() {
    emulate -L zsh
    setopt pipefail no_unset

    local base="${XDG_CONFIG_HOME:-$HOME/.config}/nvim-profiles"
    local url="$1"
    local profile="$2"

    if [[ -z "$url" || -z "$profile" ]]; then
        print -P "%F{yellow}Usage:%f nvims_install <git-url> <profile-name>" >&2
        return 1
    fi

    local dest="${base}/${profile}"

    if [[ -d "$dest" ]]; then
        print -P "%F{red}Error:%f Profile '%B${profile}%b' already exists at ${dest}." >&2
        return 1
    fi

    mkdir -p "$base" || return 1
    [[ "$url" != *.git ]] && url="${url}.git"

    git clone "$url" "$dest" || return 1
    nvims "$profile"
}

# Modern zsh completion using compdef
_nvims() {
    emulate -L zsh

    local base="${XDG_CONFIG_HOME:-$HOME/.config}/nvim-profiles"
    local -a profiles

    profiles=("${base}"/*(N:t))
    _describe 'nvim profiles' profiles
}

compdef _nvims nvims