# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃              Pure Prompt Config              ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

(( $fpath[(Ie)/opt/homebrew/share/zsh/site-functions] )) || fpath+=(/opt/homebrew/share/zsh/site-functions)

autoload -Uz add-zsh-hook
autoload -U promptinit; promptinit

# --- Pure options (must be set BEFORE `prompt pure`) ------------------------

PURE_SUSPENDED_JOBS_SYMBOL=
PURE_PROMPT_SYMBOL="❯"
PURE_PROMPT_VICMD_SYMBOL="❮"

zstyle :prompt:pure:title show no
zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:path:separator dim yes
zstyle :prompt:pure:environment:node_version show yes

zstyle :prompt:pure:prompt:success color green
zstyle :prompt:pure:custom:suffix color magenta     # git counts
zstyle :prompt:pure:execution_time color yellow     # timer

# --- Pure options (must be set BEFORE `prompt pure`) ------------------------

prompt pure

# --- Pure options (must be set BEFORE `prompt pure`) ------------------------

# Show only the last N directories, with a leading …/ when truncated
typeset -gi PATH_DEPTH=3    # change to 4 if you prefer

if (( $+functions[prompt_pure_render_dimmed_path] )) \
   && (( ! $+functions[_pure_orig_render_dimmed_path] )); then
  functions -c prompt_pure_render_dimmed_path _pure_orig_render_dimmed_path
  prompt_pure_render_dimmed_path() {
    local -i n=$PATH_DEPTH m=$(( PATH_DEPTH + 1 ))
    _pure_orig_render_dimmed_path "${1:-${(%):-%(${m}~|…/%${n}~|%~)}}"
  }
fi

# ============================================================================
# Reorder: put the custom suffix (git counts) BEFORE the execution time.
#
# Pure builds PROMPT once in `prompt pure` as a template, with the execution
# time segment (psvar[19]) immediately followed by the custom suffix segment
# (psvar[23]). Each keeps its own color, so we only need to swap the two
# strings. If your Pure version words them differently the match fails and
# PROMPT is left untouched (nothing breaks, the order just stays default).
# ============================================================================

() {
  local seg_time='%(19V. %F{$prompt_pure_colors[execution_time]}%19v%f.)'
  local seg_custom='%(23V. %F{$prompt_pure_colors[custom:suffix]}%23v%f.)'
  local both="${seg_time}${seg_custom}"

  if [[ $PROMPT == *"$both"* ]]; then
    PROMPT="${PROMPT%%"$both"*}${seg_custom}${seg_time}${PROMPT#*"$both"}"
  fi
}

# ============================================================================
# Status segment (right prompt) - only shows when something is non-zero
# ============================================================================

typeset -g STATUS_SYMBOL='󰅙'               # generic failure
typeset -g STATUS_SIGNAL_SYMBOL='󱐋'        # 128+N
typeset -g STATUS_PIPE_SUCCESS_SYMBOL='󰗠'

# Per-code overrides (icons have NO trailing space; one is added automatically)
typeset -gA STATUS_ICON=( 126 '󰀨'  127 '󰋗'  130 '✖' )
typeset -gA STATUS_NAME=(
  # --- sysexits.h (BSD convention) ---
  64  USAGE         # command used incorrectly (bad args or flags)
  65  DATAERR       # input data was malformed or wrong
  66  NOINPUT       # input file missing or unreadable
  69  UNAVAIL       # required service or resource unavailable
  70  SOFTWARE      # internal software error (a bug in the program)
  71  OSERR         # operating system error (fork failed, out of resources)
  74  IOERR         # I/O error while reading or writing
  75  TEMPFAIL      # temporary failure, retrying later may work
  77  NOPERM        # permission denied
  78  CONFIG        # configuration error or bad config file
  # --- shell / common conventions ---
  124 TIMEOUT       # GNU timeout: command timed out
  125 TIMEOUT-ERR   # timeout itself failed (also docker: daemon error)
  126 NOEXEC        # found but not executable
  127 NOTFOUND      # command not found
  128 BADEXIT       # invalid argument to exit
  130 SIGINT        # Ctrl-C
)

typeset -g STATUS_SUCCESS_STYLE='%B%F{#66E33B}'
typeset -g STATUS_FAILURE_STYLE='%B%F{#fb4934}'
typeset -g STATUS_SEPARATOR=' | '

typeset -g STATUS_IGNORE_SIGPIPE=true         # `yes | head` isn't an error
typeset -g STATUS_SHOW_SINGLE_SUCCESS=false   # true: show a green icon after every success
typeset -ga STATUS_QUIET_CMDS=(grep diff cmp) # exit 1 here isn't an error

typeset -g _status_last_cmd
_status_preexec() { _status_last_cmd=${${(z)1}[1]} }
add-zsh-hook preexec _status_preexec

precmd_pipestatus() {
  local -a codes=("${pipestatus[@]}")   # must stay the first line
  local -a segs
  local c i icon name any_fail=false

  # SIGPIPE (141) inside a multi-command pipeline is normal
  if [[ $STATUS_IGNORE_SIGPIPE == true ]] && (( ${#codes} > 1 )); then
    for i in {1..${#codes}}; do
      (( codes[i] == 141 )) && codes[i]=0
    done
  fi

  # grep/diff/cmp returning exactly 1 is "no match / differs", not a failure
  if (( ${#codes} == 1 && codes[1] == 1 )) \
     && (( ${STATUS_QUIET_CMDS[(Ie)$_status_last_cmd]} )); then
    codes=(0)
  fi

  for c in $codes; do (( c != 0 )) && any_fail=true; done

  if [[ $any_fail == false ]]; then
    if [[ $STATUS_SHOW_SINGLE_SUCCESS == true ]]; then
      RPROMPT="${STATUS_SUCCESS_STYLE}${STATUS_PIPE_SUCCESS_SYMBOL}%f%b"
    else
      RPROMPT=
    fi
    return
  fi

  for c in $codes; do
    if (( c == 0 )); then
      segs+=("${STATUS_SUCCESS_STYLE}${STATUS_PIPE_SUCCESS_SYMBOL}%f%b")
      continue
    fi

    icon=${STATUS_ICON[$c]:-$STATUS_SYMBOL}
    name=${STATUS_NAME[$c]}

    if [[ -z $name ]]; then
      if (( c > 128 && c <= 127 + ${#signals} )) && [[ -n ${signals[c-127]} ]]; then
        icon=$STATUS_SIGNAL_SYMBOL
        name="SIG${signals[c-127]}"
      elif (( c != 1 )); then
        name=$c                          # custom code: show the number
      fi                                 # code 1: icon only
    fi

    segs+=("${STATUS_FAILURE_STYLE}${icon}${name:+ $name}%f%b")
  done

  RPROMPT="${(pj:${STATUS_SEPARATOR}:)segs}"
}

# ============================================================================
# Jobs count (right prompt)
# ============================================================================

typeset -g RP_JOBS_STYLE='%B%F{#a9a1e1}'

_rprompt_jobs_precmd() {
  # Single quotes: this is expanded at draw time, not now
  RPROMPT="${RPROMPT}"'${${${(M)#jobstates:#(running|suspended):*}:#0}:+  ${RP_JOBS_STYLE}✦ ${(M)#jobstates:#(running|suspended):*}%f%b}'
}

# ============================================================================
# Git counts (Pure's custom suffix, psvar[23])
# ============================================================================

typeset -g _git_counts=

_git_counts_precmd() {
  _git_counts=

  # One git call; failing outside a work tree also covers "not a repo"
  local out
  out=$(GIT_OPTIONAL_LOCKS=0 command git status --porcelain=v2 \
        --ignore-submodules=all 2>/dev/null) || return
  [[ -z $out ]] && return

  local line x y
  local -i staged=0 modified=0 deleted=0 renamed=0 untracked=0 conflicted=0

  for line in "${(@f)out}"; do
    case $line in
      '?'*)   (( ++untracked ))  ;;
      u\ *)   (( ++conflicted )) ;;
      [12]\ *)
        x=${line[3]} y=${line[4]}
        [[ $x == R ]] && (( ++renamed ))
        [[ $x != . ]] && (( ++staged ))
        [[ $y == M ]] && (( ++modified ))
        [[ $y == D ]] && (( ++deleted ))
        ;;
    esac
  done

  # Join with single spaces; Pure's template already adds one space before it
  local -a parts
  (( conflicted )) && parts+=("󱓈 $conflicted")
  (( deleted ))    && parts+=("×$deleted")
  (( renamed ))    && parts+=("»$renamed")
  (( modified ))   && parts+=("!$modified")
  (( staged ))     && parts+=("+$staged")
  (( untracked ))  && parts+=("?$untracked")
  _git_counts="${(j: :)parts}"
}

prompt_pure_precustom() {
  # IMPORTANT - FOR CUSTOM GIT COUNTS
  psvar[23]=$_git_counts

  # determine if prompt should be split, and how much to truncate path
  local min_height=$(( $LINES >= 20 ))
  local max_width=$(( $COLUMNS <= 50 ))

  # split prompt if sufficient vertical space or not enough width
  if (( $min_height || $max_width )); then
    zstyle :prompt:pure:preprompt newline true
    local zero='%([BSUbfksu]|([FK]|){*})'
    local expanded_prompt="${(S%%)PROMPT//$~zero/}"
    cols=$(( $COLUMNS - ${#expanded_prompt} + ${(c)#$(print -nP '%~')} + 5))
    if (($cols > $COLUMNS)); then
      cols=$COLUMNS
    fi
    typeset -g prompt_newline=$'\n%{\r%}'
  else
    zstyle :prompt:pure:preprompt newline false
    cols=$(( $COLUMNS * 1/4 ))
    typeset -g prompt_newline=' '
  fi

  typeset -g prompt_pure_path_segment="%F{$prompt_pure_colors[path]}$(print -nP '%${cols}<…<%~%<<')%f"
}

# IMPORTANT - re-render preprompt when window changes
TRAPWINCH() {
  prompt_pure_preprompt_render
}

# Hook order: pipestatus FIRST (must read $pipestatus before anything else runs),
# then git counts, both before Pure's own precmd. Safe to re-source.

precmd_functions=(precmd_pipestatus _rprompt_jobs_precmd _git_counts_precmd ${precmd_functions:#(precmd_pipestatus|_rprompt_jobs_precmd|_git_counts_precmd)})

# ============================================================================
# TMUX newline behavior - blank line between prompts (tmux-aware)
# Pure's own initial newline is swallowed; we print our own from precmd.
# ============================================================================

if (( $+functions[prompt_pure_preprompt_render] )) \
   && (( ! $+functions[_pure_orig_preprompt_render] )); then
  functions -c prompt_pure_preprompt_render _pure_orig_preprompt_render
  prompt_pure_preprompt_render() {
    if [[ $1 == precmd ]]; then
      _pure_orig_preprompt_render "$@" >/dev/null
    else
      _pure_orig_preprompt_render "$@"
    fi
  }
fi

if [[ -n $TMUX ]]; then
  PROMPT_NEEDS_NEWLINE=true     # tmux: blank line before the first prompt
else
  PROMPT_NEEDS_NEWLINE=false    # otherwise: none before the first prompt
fi

_my_newline_precmd() {
  [[ $PROMPT_NEEDS_NEWLINE == true ]] && print
  PROMPT_NEEDS_NEWLINE=true
}
add-zsh-hook precmd _my_newline_precmd

function clear() {
  if [[ -n $TMUX ]]; then
    PROMPT_NEEDS_NEWLINE=true
  else
    PROMPT_NEEDS_NEWLINE=false
  fi
  command clear "$@"
}

# ============================================================================
# Legacy for reference
# ============================================================================

# if [[ -n $TMUX ]]; then
#   PROMPT_NEEDS_NEWLINE=true     # In tmux: newline on first prompt
# else
#   PROMPT_NEEDS_NEWLINE=false    # Otherwise: no newline initially
# fi

# # Wrap Pure's renderer to swallow its initial newline when not needed.
# # Guarded so a re-source doesn't wrap the wrapper (infinite recursion).
# if (( $+functions[prompt_pure_preprompt_render] )) \
#    && (( ! $+functions[_pure_orig_preprompt_render] )); then
#   functions -c prompt_pure_preprompt_render _pure_orig_preprompt_render
#   prompt_pure_preprompt_render() {
#     if [[ $1 == precmd && $PROMPT_NEEDS_NEWLINE != true ]]; then
#       _pure_orig_preprompt_render "$@" >/dev/null
#     else
#       _pure_orig_preprompt_render "$@"
#     fi
#     if [[ $1 == precmd ]]; then
#       PROMPT_NEEDS_NEWLINE=true
#     fi
#   }
# fi

# # Clear command patch (preserve behavior)
# function clear() {
#   if [[ -n $TMUX ]]; then
#     PROMPT_NEEDS_NEWLINE=true
#   else
#     PROMPT_NEEDS_NEWLINE=false
#   fi
#   command clear "$@"
# }
