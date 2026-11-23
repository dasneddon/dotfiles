
#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 David Sneddon
# This is vibecoded slop! :)
set -euo pipefail

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

# Copy and overwrite existing configurations
install_file() {
    local source="$1"
    local destination="$2"

    if [[ ! -e "$source" ]]; then
        echo "Skipping missing: $source"
        return
    fi

    mkdir -p "$(dirname "$destination")"
    rm -rf "$destination"
    cp -R "$source" "$destination"

    echo "Installed: $destination"
}

# Replace shell and editor configurations
for file in \
    .bashrc \
    .bash_profile \
    .profile \
    .vimrc \
    .dircolors
do
    install_file "$REPO/$file" "$HOME/$file"
done

# Replace Fastfetch configuration
install_file \
    "$REPO/.config/fastfetch" \
    "$HOME/.config/fastfetch"

# Replace Oh My Bash installation with repository links
install_link() {
    local source="$1"
    local destination="$2"

    rm -rf "$destination"
    ln -s "$source" "$destination"

    echo "Linked: $destination"
}

install_link \
    "$REPO/oh-my-bash" \
    "$HOME/.oh-my-bash"

install_link \
    "$REPO/.oh-my-bash-custom" \
    "$HOME/.oh-my-bash-custom"

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

echo
echo "=== Installation complete ==="
echo "Bash: $BASH_PATH"
echo "Fastfetch: $(command -v fastfetch)"
echo "Dotfiles: $REPO"
echo
echo "Restart Terminal to load the configuration."

