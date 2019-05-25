#
# Anaconda
#

# To enable manually:
# ANACONDA_ENABLE=0 . ~/bin/start_anaconda.sh

#
#Instructions on utilizing multiple conda envs (for development, etc):
#https://towardsdatascience.com/environment-management-with-conda-python-2-3-b9961a8a5097
# use 'conda env list' to see what's available
#
# example:
# $ conda create --name visus_public python=3.6 numpy scipy
# $ source activate visus_public
# (visus_public) $            # prompt changes to show current environment
# (visus_public) $ conda list # show installed packages
# (visus_public) $ pip list   # show installed packages by pip (slightly smaller list?)
# (visus_public) $ source deactivate visus_public
# $                           # prompt returns to original
#

#
# Start Anaconda
#
if [ -z $ANACONDA_ENABLE ]; then
  ANACONDA_ENABLE=0
fi
if [ -z $ANACONDA_PYTHON2 ]; then
  ANACONDA_PYTHON2=0   #use python2 instead of python3 (the default)
fi

if [ "$ANACONDA_ENABLE" -eq 1 ]; then
  if [ "$ANACONDA_PYTHON2" -eq 1 ]; then
    add_to_path "$HOME/tools/anaconda2/bin"
    PS1="[conda2] $PS1"
  else
    add_to_path "$HOME/tools/anaconda3/bin"
    #PS1="[conda3] $PS1"
    PS1="$PS1"
  fi
fi


# ANACONDA PROMPT 
# NOTE: anaconda put this in .bash_profile, but it caused problems since it got
# executed before .profile and therefore I lost all my customizations. So I just
# cut n' pasted it over here. Don't quite remember what I did to get conda to
# modify my environment (some conda command, google it), but I just moved it
# over here.

if [ -z $ANACONDA_ENABLE ]; then
  ANACONDA_ENABLE=0
fi
if [ "$ANACONDA_ENABLE" -eq 1 ]; then
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/cam/tools/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/cam/tools/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/cam/tools/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/cam/tools/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
fi



#NOTE: from conda3 installation, not sure if this is important...
    # If this is your first install of dbus, automatically load on login with:
    #     mkdir -p ~/Library/LaunchAgents
    #     cp /Users/cam/tools/anaconda3/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents/
    #     launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist

    # If this is an upgrade and you already have the org.freedesktop.dbus-session.plist loaded:
    #     launchctl unload -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
    #     cp /Users/cam/tools/anaconda3/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents/
    #     launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
#-------------------------------------------------------------------------------
