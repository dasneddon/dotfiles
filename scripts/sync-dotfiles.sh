#!/usr/bin/env bash

set -euo pipefail

REPO="$HOME/dotfiles"
DEST="$HOME"
OSH_DIR="${OSH:-$HOME/.oh-my-bash}"

# Verify Git repository
if ! git -C "$REPO" rev-parse --is-inside-work-tree \
    >/dev/null 2>&1; then
    echo "Dotfiles repository not found" >&2
    exit 1
fi

# Pull latest changes without interactive authentication
GIT_TERMINAL_PROMPT=0 git -C "$REPO" pull --ff-only

# Install Oh My Bash if missing
if [[ ! -f "$OSH_DIR/oh-my-bash.sh" ]]; then
    git -C "$REPO" submodule update --init --recursive
    mkdir -p "$OSH_DIR"
    rsync -a --exclude='/.git' "$REPO/oh-my-bash/" "$OSH_DIR/"
    echo "Installed Oh My Bash"
fi

# Force-overwrite existing configuration files

rsync -aI \
    --exclude='/.git/' \
    --exclude='/.github/' \
    --exclude='/scripts/' \
    --exclude='/README*' \
    --exclude='/LICENSE' \
    --exclude='/.gitignore' \
    --exclude='/oh-my-bash/' \
    --exclude='/.gitmodules' \
    "$REPO/" "$DEST/"

