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

# add-zsh-hook is loaded already
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