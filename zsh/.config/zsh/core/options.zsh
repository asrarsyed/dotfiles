# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#            ZSH Setup Option Settings           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# NOTE:
# History deduplication options are intentionally unset.
# zsh-autosuggestions works best with full, non-deduplicated history
# (it relies on recency and frequency, not uniqueness).
# Completion behavior is tuned for fzf-tab and widget-based menus,
# not menu_complete or sh-style word splitting.

# General shell behavior
unsetopt beep                  # don't beep on command input error
setopt auto_cd                 # change to a directory if its name is typed alone
setopt glob_dots               # include hidden files in globbing
setopt nomatch                 # don't generate errors for unmatched glob patterns
setopt interactive_comments    # allow comments while typing commands
setopt complete_in_word        # complete inside a word (e.g., "file" -> "filename" on tab)
setopt equals                  # expand =command to command pathname
setopt glob                    # enable globbing
setopt extended_glob           # enable extended globbing
setopt hash_cmds               # put path in hash when each command is executed

# History settings
setopt bang_hist               # treat the '!' character specially during expansion
setopt append_history          # add new entries to history file
setopt EXTENDED_HISTORY        # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY      # Write to the history file immediately, not when the shell exits
setopt share_history           # share history between all sessions
unsetopt hist_ignore_all_dups    # Delete an old recorded event if a new event is a duplicate
unsetopt hist_ignore_dups        # Do not record an event that was just recorded again
unsetopt hist_save_no_dups       # Do not write a duplicate event to the history file
unsetopt hist_find_no_dups        # do not display a event previously found in history
unsetopt hist_ignore_space       # do not record an entry starting with a space
setopt hist_expire_dups_first   # expire a duplicate event first when trimming history
setopt hist_reduce_blanks      # remove superfluous blanks before recording entry
unsetopt hist_verify             # do not execute immediately upon history expansion
unsetopt hist_no_store           # history commands are not registered in history

# Completion settings
setopt list_packed             # compactly display completion list
setopt auto_remove_slash       # automatically remove trailing / in completions
setopt auto_param_slash        # automatically append trailing / in directory name to prepare for next completion
# setopt auto_param_keys         # automatically completes bracket correspondence, etc.
setopt mark_dirs               # append trailing / to filename expansions when they match a directory
setopt list_types              # display file type identifier in list of possible completions (ls -f)
unsetopt menu_complete         # prevents Zsh from auto-selecting the first completion (to avoid issues with vim plugin)s
setopt auto_menu               # shows the completion menu on successive Tab presses.
setopt magic_equal_subst       # allow command-line arguments to be completed after "=" (e.g., --prefix=/usr)

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#              Miscellaneous Options             ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Job control and background process management
setopt long_list_jobs          # make internal command jobs output jobs -l by default
setopt notify                  # notify as soon as background job finishes (don't wait for prompt)
setopt pushd_silent            # don't show contents of directory stack on every pushd,popd

# Directory stack management
setopt auto_pushd              # put the directory in the directory stack even when cd'ing normally
setopt pushd_ignore_dups       # delete old duplicates in the directory stack
setopt pushdminus              # swap + - behavior

# Security and Safety
setopt rm_star_wait            # confirm before rm * is executed
unsetopt no_clobber            # prevent overwriting files with > redirection

# Additional settings
setopt auto_resume             # sutomatically resume suspended jobs when re-entering commands
setopt chase_links             # symbolic links are converted to linked paths before execution
setopt path_dirs               # find subdirectories in path when / is included in command name
setopt no_nomatch              # silently ignore unmatched globs
unsetopt sh_word_split           # faster word movement by using shell word style
setopt no_flow_control          # disable flow control (ctrl-s, ctrl-q) for faster terminal response%
setopt pipe_fail               # fail pipelines if any part fails (better for scripts & automation)