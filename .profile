# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 David Sneddon
# Synchronize dotfiles on interactive login
case $- in
    *i*)
        if [ -x "$HOME/dotfiles/scripts/sync-dotfiles.sh" ]; then
            "$HOME/dotfiles/scripts/sync-dotfiles.sh" ||
                echo "Dotfiles synchronization failed" >&2
        fi
        ;;
esac
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH=$PATH:/usr/local/go/bin
