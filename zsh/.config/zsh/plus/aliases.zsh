# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#   Aliases - Common Shortcuts & Command Tweaks  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

alias cb='centerbox' # remove after

# Print working dir & copy to clipboard
alias ywd='pwd && echo -n `pwd`| pbcopy'

# Open current/specified directory in finder
alias op='[[ $# -eq 0 ]] && open . || open "$@"'

# File and directory management
alias ln="ln -vi" # Interactive symbolic link.
alias cp="cp -vi" # Copy files and directories.
alias mv="mv -vi" # Move files and directories.

# Send files and directories to trash.
if command -v trash &> /dev/null; then alias rm='trash -vF'; fi # (trash -vlesyF)

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#         Commonly used Aliases (Grouped)        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# bat (comment when running cache --build)
if command -v bat &> /dev/null; then
  alias cat='bat -pp --theme "gruvbox-dark"'
  alias bat='bat -pp --theme "gruvbox-dark"' 
fi

# brew
if command -v brew &> /dev/null; then
    alias bbcat="cat $HOMEBREW_BUNDLE_FILE"  # View contents of Brewfile
    alias buubc="brew upgrade --cask --greedy"  # Main Command (Upgrade all Casks separately)
    alias buubi="brew update && brew bundle install --cleanup --file=~/.brewfile && brew upgrade"  # Main Command (Upgrade Formulae)
    alias bbcuz="brew bundle cleanup --force --zap --file=~/.brewfile && brew cleanup --prune=all"  # Cleanup unneeded packages aggressively
fi

# btop
if command -v btop &> /dev/null; then
    alias top="btop"
    alias htop="btop"
fi

# clear
if command -v clear &> /dev/null; then
    alias c='clear'
    alias cl='clear'
fi

# exit
if command -v exit &> /dev/null; then
    alias x='exit'
    alias :q='exit'
    alias :wq='exit'
fi

# eza
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first --icons -s name'
    alias lf='eza --group-directories-first --icons -s name -A'
    alias ll='eza --group-directories-first --icons --git -s name -lh'
    alias la='eza --group-directories-first --icons --git -s name -lha'
    alias lld="eza --group-directories-first --icons -s name -l | grep ^d"
    alias tree='ll --tree --level=2'
    alias trees='ll -abhT --level=3 -I .git --no-filesize --no-user --no-time --no-permissions'
fi

# fd
if command -v fd &> /dev/null; then
    alias rmds='fd -HI --type f --glob "{.DS_Store,._.DS_Store}" . --exec rm {} + || true' # non-print
    alias rmDS='fd -HI --type f --glob "{.DS_Store,._.DS_Store}" . --exec rm -v {} + 2>/dev/null || true' # print
else
    alias rmds='find . -type f \( -name ".DS_Store" -o -name "._.DS_Store" \) -delete 2>/dev/null || true' # non-print
    alias rmDS='find . -type f \( -name ".DS_Store" -o -name "._.DS_Store" \) -print -delete 2>/dev/null || true' # print
fi

# help
help() {"$@" --help 2>&1 | bat -p --language=help}
alias -g -- -h='-h 2>&1 | bat --plain --language=help'
alias -g -- --help='--help 2>&1 | bat --plain --language=help --paging=always --style=auto'

# macchina
if command -v macchina &> /dev/null; then
    alias fetch='macchina'
    alias neofetch='macchina'
    alias macchina='macchina; printf "\033[A\033[2K"'
fi

# Suggested workflow:
    # Normal day-to-day: do nothing vs After editing configs: exec zsh
    # After plugin updates: zshrefresh # Update plugins, force recompile all plugins, restart shell
    # Test without compiled plugins: zshcleanup # Restart with no zsh cache and no compiled plugins (debug / comparison)
    # If something is really broken: zshrebuild # Full reset: clear cache, remove compiled plugins, rebuild everything, restart
# zap
if command -v zap &> /dev/null; then
    alias zshrefresh='zap update plugins && zapcompile --force && echo "" && exec zsh'
    alias zshcleanup='rm -rf ~/.cache/zsh ~/.local/share/zap/plugins/**/*.zwc && echo "" && exec zsh'
    alias zshrebuild='echo "🧹 Cleaning zsh cache..." && rm -rf ~/.cache/zsh ~/.local/share/zap/plugins/**/*.zwc(N) >/dev/null 2>&1 && zapcompile --silent && echo "✨ Done. Restarting..." && echo "" && exec zsh'
fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#        Uncommonly Used Aliases (Grouped)       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# curl
if command -v curl &> /dev/null; then
    alias get='curl --fail --continue-at - --location --progress-bar --remote-name --remote-time --connect-timeout 10'
fi

# sudo
if command -v sudo &> /dev/null; then
    alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Reload your Terminal.'"
    alias tobash="sudo chsh $USER -s /opt/homebrew/bin/bash && echo 'Reload your Terminal.'"
    alias tofish="sudo chsh $USER -s /opt/homebrew/bin/fish && echo 'Reload your Terminal.'"
fi

# tmux
if command -v tmux &> /dev/null; then
    alias tm='tmux'
    alias ta='tmux attach'
    alias td='tmux detach'
    alias tn='tmux new-session'
    alias tl='tmux list-sessions'
fi
