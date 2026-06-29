# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃              Bindkey Functions               ┃
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
# ┃           Shell Wrapper Functions            ┃
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