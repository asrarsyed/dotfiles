# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#            Syntax Highlighting Config           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ZSH_HIGHLIGHT_MAXLENGTH=120
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Rainbow brackets
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=blue'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-level-6]='fg=red'

# Errors
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,underline'

# Keywords
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=blue'

# Commands
ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta' # first command in pipeline
ZSH_HIGHLIGHT_STYLES[precommand]='fg=cyan' # precommand → sudo, time, etc.
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=magenta' # alias visibility
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=magenta' # alias visibility

# Strings
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=yellow'

# Variables & Assignments
ZSH_HIGHLIGHT_STYLES[assign]='fg=yellow'

# Redirections
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'

# Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=248'

# Paths
ZSH_HIGHLIGHT_STYLES[path]='none'