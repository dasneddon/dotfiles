#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 David Sneddon
# This is vibecoded slop! :)
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

# Ensure macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Error: This installer requires macOS." >&2
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

# Locate Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
    BREW=/usr/local/bin/brew
else
    echo "Error: Homebrew must be installed first." >&2
    exit 1
fi

eval "$("$BREW" shellenv)"

# Ensure Homebrew Bash is installed
BASH_PATH="$("$BREW" --prefix)/bin/bash"

if [[ ! -x "$BASH_PATH" ]]; then
    echo "Installing Homebrew Bash..."
    "$BREW" install bash
else
    echo "Homebrew Bash already installed."
fi

# Install Fastfetch only when missing
if ! command -v fastfetch >/dev/null 2>&1; then
    echo "Installing Fastfetch..."
    "$BREW" install fastfetch
else
    echo "Fastfetch already installed."
fi

# Ensure the Oh My Bash submodule is available
if [[ ! -f "$REPO/oh-my-bash/oh-my-bash.sh" ]]; then
    echo "Initializing Oh My Bash..."
    git -C "$REPO" submodule update --init --recursive
fi

# Register Homebrew Bash as a valid login shell
if ! grep -Fxq "$BASH_PATH" /etc/shells; then
    echo "Registering Homebrew Bash..."
    printf '%s\n' "$BASH_PATH" |
        sudo tee -a /etc/shells >/dev/null
fi

# Set Homebrew Bash as the default login shell
CURRENT_SHELL="$(
    dscl . -read "/Users/$(id -un)" UserShell |
        awk '{print $2}'
)"

if [[ "$CURRENT_SHELL" != "$BASH_PATH" ]]; then
    echo "Changing default shell to $BASH_PATH..."
    chsh -s "$BASH_PATH"
else
    echo "Homebrew Bash is already the default shell."
fi

bash "$REPO/scripts/sync-dotfiles.sh"

echo
echo "=== Installation complete ==="
echo "Bash: $BASH_PATH"
echo "Fastfetch: $(command -v fastfetch)"
echo "Dotfiles: $REPO"
echo
echo "Restart Terminal to load the configuration."

