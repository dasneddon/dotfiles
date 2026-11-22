#!/usr/bin/env bash

set -euo pipefail

REPO="$HOME/dotfiles"
DEST="$HOME"

# Verify Git repository
if ! git -C "$REPO" rev-parse --is-inside-work-tree \
    >/dev/null 2>&1; then
    echo "Dotfiles repository not found" >&2
    exit 1
fi

# Pull latest changes without interactive authentication
GIT_TERMINAL_PROMPT=0 git -C "$REPO" pull --ff-only

# Force-overwrite existing configuration files

rsync -aI \
    --exclude='/.git/' \
    --exclude='/.github/' \
    --exclude='/scripts/' \
    --exclude='/README*' \
    --exclude='/LICENSE' \
    --exclude='/.gitignore' \
    "$REPO/" "$DEST/"

