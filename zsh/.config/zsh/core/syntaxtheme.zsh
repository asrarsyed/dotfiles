# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃          Syntax Highlighting Config          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# ZSH_HIGHLIGHT_MAXLENGTH=120

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃          Syntax Highlighting - Main          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Commands & execution
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bg=black,bold'           # unknown tokens / errors
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=green,bold'                  # shell reserved words (if, for)
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'                        # aliases            
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=magenta'                      # suffix aliases (requires zsh 5.1.1 or newer)
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=magenta,underline'            # global aliases
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'                             # shell builtin commands (shift, pwd, zstyle)
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'                        # function names
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'                        # command names
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'                # precommand modifiers (e.g., noglob, builtin)
# ZSH_HIGHLIGHT_STYLES[arg0]=''                                      # a command word other than command, precommand, alias, function, or shell builtin command

# Arguments & options
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=blue'                 # single-hyphen options (-o)
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=blue'                 # double-hyphen options (--option)
ZSH_HIGHLIGHT_STYLES[assign]='fg=magenta,bold'                       # parameter assignments (x=foo and x=( ))

# Strings & quoting
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'             # single-quoted arguments ('foo')
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'             # double-quoted arguments ("foo")
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'             # dollar-quoted arguments ($'foo')
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=magenta'     # parameter expansion inside double quotes ($foo inside "")
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=magenta,bold'  # backslash escape sequences inside double-quoted arguments (\" in "foo\"bar")

# Filesystem
ZSH_HIGHLIGHT_STYLES[path]='fg=green,bold,underline'                 # existing filenames
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=cyan'                   # path separators in filenames (/); if unset, path is used (default)
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=green,bold,underline'          # prefixes of existing filenames
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=cyan'            # path separators in prefixes of existing filenames (/); if unset, path_prefix is used (default)
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=magenta,bold,underline'      # a directory name in command position when the AUTO_CD option is set
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta,bold'                     # globbing expressions (*.txt)

# Syntax & structure
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white,bold'               # command separation tokens (;, &&)
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan,standout,bold'      # history expansion expressions (!foo and ^foo^bar)
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=red,underline'        # arithmetic expansion $(( 42 )))
ZSH_HIGHLIGHT_STYLES[redirection]='fg=blue,standout,bold'            # redirection operators (<, >, etc)
ZSH_HIGHLIGHT_STYLES[comment]='fg=yellow,bg=black,underline'         # comments, when setopt INTERACTIVE_COMMENTS is in effect (echo # foo)
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=blue'                           # numeric file descriptor (the 2 in echo foo {fd}>&2)

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃     Syntax Highlighting - Miscellaneous      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Rainbow brackets
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-6]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-7]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=white,bg=black,bold'

# Special
ZSH_HIGHLIGHT_STYLES[cursor]='standout'
ZSH_HIGHLIGHT_STYLES[line]='none'
