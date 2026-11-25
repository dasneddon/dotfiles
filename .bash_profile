# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 David Sneddon
# .bash_profile -*- mode: sh -*-`
if [[ "$(uname)" == "Darwin" ]]; then
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$HOME/.local/tmux/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export ANT_HOME="$HOME/.local/ant"
export PATH="$HOME/.local/bin:$ANT_HOME/bin:$PATH"
fi
# Load common configuration on both Linux and macOS
if [[ -f "$HOME/.profile" ]]; then
    source "$HOME/.profile"
fi
