#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 David Sneddon
set -euo pipefail

read -r -p "This will overwrite the dotfiles in your home directory! Type 'yes' to confirm: " CONFIRM

case "$CONFIRM" in
    [Yy][Ee][Ss])
        echo "Installing"
        ;;
    *)
        echo "Aborting!" >&2
        exit 1
        ;;
esac

# Ensure Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Error: This installer requires Linux." >&2
    exit 1
fi

# Do not run the entire installer as root
if [[ "$(id -u)" -eq 0 ]]; then
    echo "Error: Run this script as your normal user." >&2
    exit 1
fi
# Ensure sync script is present
if [[ ! -f "$HOME/dotfiles/scripts/sync-dotfiles.sh" ]]; then
    echo "Error: Sync script not found, clone the repository"
    exit 1
fi

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

echo "=== Installing dotfiles ==="

# Ensure the Oh My Bash submodule is available
if [[ ! -f "$REPO/oh-my-bash/oh-my-bash.sh" ]]; then
    echo "Initializing Oh My Bash..."
    git -C "$REPO" submodule update --init --recursive
fi

bash "$REPO/sync-dotfiles.sh"

echo
echo "=== Installation complete ==="
echo "Fastfetch: $(command -v fastfetch)"
echo "Dotfiles: $REPO"
echo
echo "Restart Terminal to load the configuration."

