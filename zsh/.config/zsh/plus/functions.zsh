# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#    Functions - Shell Functions for Workflows   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Quick access to configuration files
conf() {
  local file
  case $1 in
    brew)  file="$HOME/.brewfile" ;;
    zsh)   file="$HOME/.config/zsh/.zshrc" ;;
    nvim)  file="$HOME/.config/nvim/init.lua" ;;
    lvim)  file="$HOME/.config/lvim/config.lua" ;;
    tmux)  file="$HOME/.config/tmux/.tmux.conf" ;;;
    *)     echo "Usage: conf +1 {brew|zsh|nvim|lvim|tmux}" ; return 1 ;;
  esac

  # Launch editor
  $EDITOR "$file" || return 1

  # Change to the directory containing the file
  cd "$(dirname "$file")" || return
}

# Copies output of command to system clipboard
copy() {
  local output
  if output=$("$@" 2>&1); then
    echo "$output" | pbcopy
    echo " Output copied to clipboard."
  else
    echo " Command execution failed: $output"
  fi
}

# Summary of most frequently used ZSH commands, ranked by usage.
hstat() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) printf "%d %.2f%% %s\n", CMD[a], CMD[a]*100/count, a }' \
    | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

# Clone git repo or mkdir & then cd into new directory
md() {
  if [[ $1 =~ ^([A-Za-z0-9._%+-]+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    git clone "$1" && cd "$(basename "${1%%.git}")"
  else
    mkdir -p -- "$1" && cd -P -- "$1"
  fi
}

# Dynamic nvim config switcher
nvims() {
  local items config
  # Available configurations
  items=("default" "custom" "kickstart" "LazyVim" "NvChad" "AstroNvim")
  # Show fzf selector with preview
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config: " --height=~50% --layout=reverse --border --exit-0)
  # Handle selection
  if [[ -z $config ]]; then
    # echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  # Launch nvim with selected config
  NVIM_APPNAME=$config command nvim "$@"
}

# Automatically move into the directory when exiting yazi
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return

  TRAPINT()  { rm -f -- "$tmp"; return 130 }
  TRAPTERM() { rm -f -- "$tmp"; return 143 }

  yazi "$@" --cwd-file="$tmp"

  if cwd="$(command cat -- "$tmp")" &&
     [ -n "$cwd" ] &&
     [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#           Measuring Shell Startup Time         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Time shell startup
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# Time shell startup
startuptime() {
    # Initial "cold" run
    local cold=$((TIMEFMT='%mE'; time zsh -i -c exit) 2>/dev/stdout >/dev/null)
    cold=${cold//[ms]/}
    printf "Cold start: %s ms\n\n" $cold
    
    # Warm runs
    local total=0
    printf "Warm starts:\n"
    for i in {1..10}; do
        local ms=$((TIMEFMT='%mE'; time zsh -i -c exit) 2>/dev/stdout >/dev/null)
        ms=${ms//[ms]/}
        printf "%2d: %s ms\n" $i $ms
        (( total += ms ))
    done
    
    printf "\nAverage warm start: %.2f ms\n" $(( total / 10.0 ))
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#         Miniforge Conda/Mamba Functions        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Lazy Load Conda
conda() {
  unfunction conda
  eval "$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook')"
  command conda "$@" # test adding command
}

# Lazy Load Mamba
mamba() {
  unfunction mamba
  eval "$('/opt/homebrew/Caskroom/miniforge/base/bin/mamba' 'shell' 'hook' --shell zsh)"
  mamba "$@"
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#         $ENV / $PATH / $FPATH Functions        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Display the env listed in zsh config
fzenv() {
  local selection key value
  selection=$(env | fzf) || return
  key=${selection%%=*}
  value=${selection#*=}
  printf "%s\n" "$value"
}

# Display the directories listed in the $PATH variable 
paths() {
  echo -e "Index\tPath"
  local IFS=':'
  local i=1
  for dir in $PATH; do
    printf "%3d:\t%s\n" $i "$dir"
    ((i++))
  done
}

# Display the directories listed in the $FPATH variable
fpaths() {
  echo -e "Index\tPath"
  local IFS=':'
  local i=1
  for dir in $FPATH; do
    printf "%3d:\t%s\n" $i "$dir"
    ((i++))
  done
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#            Uncommonly Used Functions           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Get Bundle ID of macOS app
bundleid() {
  local ID=$( osascript -e 'id of app "'"$1"'"' )
  if [ ! -z $ID ]; then
    echo $ID | tr -d '[:space:]' | pbcopy
    echo "$ID (copied to clipboard)"
  fi
}

# Lists all directories (excludes .git/) in the current dir and copies them to clipboard
stowdirs() {
  local dirs
  dirs=$(fd -t d -d 1 --exclude ".git" --exclude "fonts" . | xargs -I{} basename {} | tr '\n' ' ')
  dirs="${dirs% }"
  echo "$dirs"
  printf "%s" "$dirs" | pbcopy
}

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
#        Sandbox Functions - Organize Later      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

disappointed() { echo -n " ಠ_ಠ " |tee /dev/tty| xclip -selection clipboard; }

flip() { echo -n "（╯°□°）╯ ┻━┻" |tee /dev/tty| xclip -selection clipboard; }

shrug() { echo -n "¯\_(ツ)_/¯" |tee /dev/tty| xclip -selection clipboard; }

# Interactive git diff
function fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" \
  | fzf --ansi --preview "echo {} \
    | grep -o '[a-f0-9]\{7\}' \
    | head -1 \
    | xargs -I % sh -c 'git show --color=always %'" \
        --bind "enter:execute:
            (grep -o '[a-f0-9]\{7\}' \
                | head -1 \
                | xargs -I % sh -c 'git show --color=always % \
                | less -R') << 'FZF-EOF'
            {}
FZF-EOF"
}
