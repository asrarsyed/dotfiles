# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#               ZSH Compdump Manager             ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Ensure XDG_CACHE_HOME is set with fallback
local zcachedir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Specify default zcompdump location
local zcompdump="${zcachedir}/zcompdump"

# Ensure cache directory exists
[[ -d "$zcachedir" ]] || mkdir -p "$zcachedir"

# Load completions
autoload -Uz compinit

# Regenerate if file exists and is older than 24h
for dump in "${zcompdump}"(N.mh+24); do
    compinit -d "${zcompdump}"
done

# Always load (and implicitly create if missing)
compinit -C -d "${zcompdump}"

# Compile zcompdump in background if needed
{
    if [[ -s "${zcompdump}" && (! -s "${zcompdump}.zwc" || "${zcompdump}" -nt "${zcompdump}.zwc") ]]; then
        zcompile "${zcompdump}"
    fi
} &!

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#              ZSH Completion Styling            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# https://thevaluable.dev/zsh-completion-guide-examples/

# Makes every character a word boundary, allowing tab completion to work inside words with dashes, underscores, or dots
WORDCHARS='' # Redundant with setopt complete_in_word: improve edge-case completion behavior

if [[ -z $_ZSTYLE_INIT_DONE ]]; then
  _ZSTYLE_INIT_DONE=1
  # Case-insensitive matching (ranked from slowest-fastest)
  # zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
  # zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+r:|?=**'
  # zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
  # zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

  # Menu-based selection
  zstyle ':completion:*:default' menu select
  zstyle ':completion:*' increment yes
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' squeeze-slashes yes  # replace // with /; may inadvertently mask issues when debugging paths

  # Use faster hashtable for completion caching
  zstyle ':completion:*' rehash false  # improves performance
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path $zcachedir
  zstyle ':completion:*' accept-exact '*(N)'

  # Group and organize completion results (Formatting)
  zstyle -d ':completion:*' format
  zstyle ':completion:*:descriptions' format '[%d]'
  zstyle ':completion:*:git-checkout:*' sort false
  zstyle ':completion:*:warnings' format '%F{red}--- no matches ---%f' # Minimal
  # zstyle ':completion:*:warnings' format '%B%F{red}No matches for:''%F{white}%d%b' # Detailed
  zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
  zstyle ':completion:*:messages' format '%F{purple} -- %d --%f'

  # Group and organize completion results
  zstyle ':completion:*' group-name '' # speeds up rendering; may reduce clarity when there are many suggestions
  zstyle ':completion:*' file-sort modification  # show recently used files first
  zstyle ':completion:*' list-dirs-first yes
  zstyle ':completion:*' ignored-patterns '.git'

  # Colorize completion candidates
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' special-dirs true

  # _complete is base completer (standard completion for commands, files, etc.)
  # _approximate will fix completion if there are no exact matches (e.g., correct typos)
  # _extensions will complete glob patterns with extensions (e.g., `*.txt` or `*.sh`)
  # _history will search through the shell's command history for matches
  # _match will complete substrings or patterns within a word
  # Optimize completion order (faster than history-based)
  zstyle ':completion:*' completer _complete _match _approximate
  zstyle ':completion:*' approximate 1  # allows 1 typo; adjust as needed

  # Optimize cd completion (faster path handling)
  zstyle ':completion:*:cd:*' tag-order local-directories directory-stack named-directories path-directories
  zstyle ':completion:*:cd:*' group-order local-directories directory-stack named-directories path-directories

  # Optimize sudo completion (faster path search)
  zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

  # Testing these below (gotta organize if I keep)

  # Affects how completions are grouped for commands; could improve clarity
  zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

  # Useful if you often do ssh <TAB> or scp <TAB> — it reads /etc/ssh_known_hosts and ~/.ssh/known_hosts
  zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
  
  # Controls how // is treated during completions (collapse // to /)
  zstyle ':completion:*' squeeze-slashes true
fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#             ZSH Modules & Utilities            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Load required modules (synchronously - they're tiny and needed immediately)
zmodload zsh/complist
zmodload zsh/complete
zmodload zsh/zutil

# Load utilities
autoload -Uz zmv
autoload -Uz colors && colors
autoload -Uz add-zsh-hook  # Load once here

# History search functions
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#             Colors & Visual Settings           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Disable paste highlighting
zle_highlight=('paste:none')

# OS-specific ls aliases
case $OSTYPE in
    darwin*) alias ls='ls -G';;
    linux*) alias ls='ls --color=auto';;
esac

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#                Custom Keybindings              ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Use "bindkey -l" to list available key bindings
# Use "bindkey -M viins" to list key bindings for insert mode
# Use "bindkey -M vicmd" to list key bindings for command mode

# Autosuggestions
bindkey '^X^E' autosuggest-execute  # Accept and execute suggestion
bindkey '^X^S' autosuggest-toggle   # Toggle suggestions on/off

# History substring search
bindkey '^[[A' history-substring-search-up            # Up Arrow: Search upwards in history (matches current input substring)
bindkey '^[[B' history-substring-search-down          # Down Arrow: Search downwards in history (matches current input substring)
bindkey -M vicmd 'k' history-substring-search-up      # 'k' (vi command mode): Search upwards in history (substring match)
bindkey -M vicmd 'j' history-substring-search-down    # 'j' (vi command mode): Search downwards in history (substring match)

# Quick commands
bindkey -s '\el' 'ls\n'                               # [Esc-l] - runs command: ls

# Readline emulation
bindkey '^w' backward-kill-word
bindkey '^e' end-of-line
bindkey '^a' beginning-of-line
bindkey '^f' forward-word