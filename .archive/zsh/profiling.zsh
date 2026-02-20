# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#         Copy to the beginning of .zshenv       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Profiling via: https://kev.inburke.com/kevin/profiling-zsh-startup-time/
: "${PROFILE_STARTUP:=false}"
: "${PROFILE_ALL:=false}"
# Run this to get a profile trace and exit: time zsh -i -c echo
# Or: time PROFILE_STARTUP=true /bin/zsh -i --login -c echo
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%H:%M:%S.%.} %N:%i> '
    #zmodload zsh/datetime
    #PS4='+$EPOCHREALTIME %N:%i> '
    exec 3>&2 2>~/zsh_profile.$$
    setopt xtrace prompt_subst
fi  # "unsetopt xtrace" is at the end of ~/.zshrc

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#          Zsh Startup Profiling Aliases          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Profile interactive shell startup with detailed trace
alias zsh-profile='PROFILE_STARTUP=true zsh -i -c echo && echo "Profile saved to ~/zsh_profile.*"'
# Profile login shell startup with detailed trace
alias zsh-profile-login='PROFILE_STARTUP=true zsh -i --login -c echo && echo "Profile saved to ~/zsh_profile.*"'
# Just time the startup without creating a trace file
alias zsh-time='time zsh -i -c echo'
# View the most recent profile trace
alias zsh-profile-view='cat ~/zsh_profile.*(om[1])'
# Clean up all profile traces
alias zsh-profile-clean='rm -f ~/zsh_profile.* && echo "Cleaned up profile traces"'

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#       Source at end of .zshrc when needed      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Turn off profiling tracing if it was enabled
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
    unsetopt xtrace
fi
