# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#             Comprehensive FZF Setup            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# FZF Colorschemes
export FZF_GRUVBOX="--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
export FZF_NORD="--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1"
export FZF_CATPPUCCIN_LATTE="--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
export FZF_CATPPUCCIN_FRAPPE="--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284,fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf,marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
export FZF_CATPPUCCIN_MACCHIATO="--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
export FZF_CATPPUCCIN_MOCHA="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# export FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore-vcs --follow --color=never --strip-cwd-prefix --exclude .git"
# See more: https://github.com/junegunn/fzf/blob/master/ADVANCED.md
export FZF_DEFAULT_COMMAND="
  fd \
  --type f \
  --type l \
  --hidden \
  --follow \
  --color=never \
  --strip-cwd-prefix \
  --exclude '.git' \
  --exclude '.DS_Store' \
  --exclude 'node_modules' \
  --exclude '__pycache__' \
  --exclude '.pytest_cache' \
  --exclude 'venv' \
  --exclude '.mypy_cache' \
"

# https://vitormv.github.io/fzf-themes/
export FZF_DEFAULT_OPTS="\
  $FZF_CATPPUCCIN_MOCHA \
  --cycle \
  --keep-right \
  --margin=0,1 \
  --prompt '∷ ' \
  --marker=' ' \
  --pointer=' ' \
  --height='80%' \
  --scrollbar=▏▕ \
  --info='right' \
  --border='bold' \
  --layout='reverse-list' \
  --preview-window='hidden' \
  --preview-window='border-bold' \
  --bind 'ctrl-k:preview-up,ctrl-j:preview-down' \
  --bind 'ctrl-h:preview-page-up,ctrl-l:preview-page-down' \
  --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down' \
  --bind '?:toggle-preview' \
  --bind 'ctrl-o:become(nvim {})' \
  --preview '[[ -f {} ]] && (bat -f --style=rule,numbers,snip,changes,header,header-filesize {} || bat {}) || echo {} 2> /dev/null | head -n500'
"

# FZF Completions
export FZF_COMPLETION_TRIGGER='**'
export FZF_COMPLETION_OPTS='--border --info=inline'

# Tmux Popup Windows
export FZF_TMUX_OPTS="-p"

# CTRL-T − Paste the selected files onto the command-line.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ALT-C − cd into the selected directory.
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {}' --preview-window=right:60%"

# # CTRL-R − Look/Copy/Use previous command from history.
# export FZF_CTRL_R_OPTS="\
#   --preview 'echo {}' --preview-window down:3:hidden:wrap \
#   --bind 'ctrl-y:execute-silent(echo -n {2} | pbcopy)+abort' \
#   --reverse \
#   --border-label-pos='0' \
#   --border-label='Press CTRL-Y to copy command into clipboard'
# "
unset FZF_CTRL_R_OPTS

# FZF-Tab plugin configuration
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' popup-min-size 80 20
zstyle ':fzf-tab:*' switch-group '<' '>'
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# https://dev.to/manofthelionarmy/nvim-fzf-from-terminal-24p3