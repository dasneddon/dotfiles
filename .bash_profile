# .bash_profile -*- mode: sh -*-
if [[ "$(uname)" == "Darwin" ]]; then
    # Synchronize dotfiles on interactive login
case $- in
    *i*)
        if [ -x "$HOME/dotfiles/scripts/sync-dotfiles.sh" ]; then
            "$HOME/dotfiles/scripts/sync-dotfiles.sh" ||
                echo "Dotfiles synchronization failed" >&2
        fi
        ;;
esac
# Load login settings and environment variables
if [[ -f ~/.profile ]]; then
  source ~/.profile
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Load interactive settings
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$HOME/.local/tmux/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export ANT_HOME="$HOME/.local/ant"
export PATH="$HOME/.local/bin:$ANT_HOME/bin:$PATH"
fi
