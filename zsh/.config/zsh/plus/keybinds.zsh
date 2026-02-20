# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#                Custom Keybindings              ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Use "bindkey -l" to list available key bindings
# Use "bindkey -M viins" to list key bindings for insert mode
# Use "bindkey -M vicmd" to list key bindings for command mode

# Use human-friendly identifiers.
typeset -gA key_info
key_info=(
  'Control'         '\C-'
  'ControlLeft'     '\e[1;5D \e[5D \e\e[D \eOd'
  'ControlRight'    '\e[1;5C \e[5C \e\e[C \eOc'
  'ControlPageUp'   '\e[5;5~'
  'ControlPageDown' '\e[6;5~'
  'Escape'          '\e'
  'Meta'            '\M-'
  'MetaLeft'        '[D'
  'MetaRight'       '[C'

  'Tab'             '^I'
  'Backspace'       "^?"
  'Delete'          "$terminfo[kdch1]"
  'BackTab'         "$terminfo[kcbt]"

  # Function keys
  'F1'              "$terminfo[kf1]"
  'F2'              "$terminfo[kf2]"
  'F3'              "$terminfo[kf3]"
  'F4'              "$terminfo[kf4]"
  'F5'              "$terminfo[kf5]"
  'F6'              "$terminfo[kf6]"
  'F7'              "$terminfo[kf7]"
  'F8'              "$terminfo[kf8]"
  'F9'              "$terminfo[kf9]"
  'F10'             "$terminfo[kf10]"
  'F11'             "$terminfo[kf11]"
  'F12'             "$terminfo[kf12]"
  'Insert'          "$terminfo[kich1]"
  'Home'            "$terminfo[khome]"
  'PageUp'          "$terminfo[kpp]"
  'End'             "$terminfo[kend]"
  'PageDown'        "$terminfo[knp]"

  # Arrows
  'Up'              "$terminfo[kcuu1]"
  'Left'            "$terminfo[kcub1]"
  'Down'            "$terminfo[kcud1]"
  'Right'           "$terminfo[kcuf1]"

  # Shift + Arrows
  'ShiftUp'         "$terminfo[kPRV]"
  'ShiftDown'       "$terminfo[kNXT]"
  'ShiftLeft'       "$terminfo[kLFT]"
  'ShiftRight'      "$terminfo[kRIT]"
)

# Set empty $key_info values to an invalid UTF-8 sequence to induce silent
# bindkey failure.
for key in "${(k)key_info[@]}"; do
  if [[ -z "$key_info[$key]" ]]; then
    key_info[$key]='�'
  fi
done
unset key

# Ensure terminfo exists (cross-platform safety)
zmodload zsh/terminfo 2>/dev/null

# Enable vi mode
bindkey -v

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃            Global / Esc sequences            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Autosuggestions
bindkey "${key_info[Control]}X${key_info[Control]}E" autosuggest-execute # Accept and execute suggestion
bindkey "${key_info[Control]}X${key_info[Control]}S" autosuggest-toggle  # Toggle suggestions on/off

# Quick commands
bindkey -s "${key_info[Escape]}l" 'ls\n'


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                 Insert Mode                  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Insert mode readline-style helpers
bindkey -M viins "${key_info[Control]}A" beginning-of-line
bindkey -M viins "${key_info[Control]}E" end-of-line
bindkey -M viins "${key_info[Control]}F" forward-word
bindkey -M viins "${key_info[Control]}W" backward-word
bindkey -M viins "${key_info[Control]}X" backward-kill-word

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                 Command Mode                 ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# History substring search
bindkey -M vicmd 'k' history-substring-search-up   # 'k' (vi command mode): Search upwards in history
bindkey -M vicmd 'j' history-substring-search-down # 'j' (vi command mode): Search downwards in history

# History substring search (global arrows)
# Up Arrow: Search upwards in history
bindkey -M viins  '^[[A' history-substring-search-up
bindkey -M viins  '^[OA'  history-substring-search-up
bindkey -M vicmd  '^[[A' history-substring-search-up
bindkey -M vicmd  '^[OA'  history-substring-search-up
# bindkey "${key_info[Down]}" history-substring-search-down 
bindkey -M viins  '^[[B' history-substring-search-down
bindkey -M viins  '^[OB'  history-substring-search-down
bindkey -M vicmd  '^[[B' history-substring-search-down
bindkey -M vicmd  '^[OB'  history-substring-search-down

# Run after Atuin cache_init (deferred)
bindkey -M viins  '^[[A' history-substring-search-up
bindkey -M viins  '^[OA'  history-substring-search-up
bindkey -M viins  '^[[B' history-substring-search-down
bindkey -M viins  '^[OB'  history-substring-search-down

bindkey -M vicmd  '^[[A' history-substring-search-up
bindkey -M vicmd  '^[OA'  history-substring-search-up
bindkey -M vicmd  '^[[B' history-substring-search-down
bindkey -M vicmd  '^[OB'  history-substring-search-down

# Ctrl-R → Atuin search
bindkey -M viins '^R' atuin-search-viins
bindkey -M vicmd '/' atuin-search