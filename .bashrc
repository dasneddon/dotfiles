# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 David Sneddon
##Bash Initializaion
#Prevent duplicate initialization
if [[ -n ${_BASHRC_LOADED:-} ]]; then
    return 0
fi
_BASHRC_LOADED=1
# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

##Color Words
colorword() {
    local color="$1"
    shift
    printf '\033[%sm%s\033[0m' "$color" "$*"
}

#Declare Dotfiles Git repository
dotfiles() {
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

export LANG=en_US.UTF-8
export EDITOR='vim'

##Oh-My-Bash
OSH="$HOME/.oh-my-bash"
OSH_CUSTOM="$HOME/.oh-my-bash-custom"
OSH_THEME="dave"
# OMB_CASE_SENSITIVE="true"
# OMB_HYPHEN_SENSITIVE="false"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_OSH_DAYS=13 #change auto-update timeframe
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"
# SCM_GIT_IGNORE_UNTRACKED="true"
HIST_STAMPS=[yyyy-mm-dd]
#OMB_DEFAULT_ALIASES="check"
OMB_USE_SUDO=true
OMB_PROMPT_SHOW_PYTHON_VENV=true

completions=(
  git
  ssh
  docker
  system
  tmux
)

aliases=(
    general
)

plugins=(
    git
    bashmarks
    tmux
    colored-man-pages
    sudo
)

source "$OSH"/oh-my-bash.sh

##Paths
export PATH=$PATH:~/bin:~/.cargo/bin
#User Binaries:Rust

##Fastfetch
command -v fastfetch >/dev/null 2>&1 && fastfetch

# Configure colored directory listings
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G'
else
    if command -v dircolors >/dev/null 2>&1; then
        if [[ -f "$HOME/.dircolors" ]]; then
            eval "$(dircolors -b "$HOME/.dircolors")"
        else
            eval "$(dircolors -b)"
        fi
    fi

    alias ls='ls --color=auto'
fi

#Dotfiles Git Repo
dotfiles() {
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

##Package Manager
if command -v apt-get >/dev/null 2>&1; then
    alias update="sudo apt-get update && sudo apt-get upgrade -y"
    alias pkginstall="sudo apt-get install"
    echo "Package manager recognized as $(colorword 31 Debian) based $(colorword '1;31' APT)." 
elif command -v pacman >/dev/null 2>&1; then
    if command -v yay >/dev/null 2>&1; then
        alias update="sudo pacman -Syu && yay -Sua"
       echo "Package managers recognized as $(colorword '38;2;23;147;209' "Arch Linux") based $(colorword '1;34' "Pacman and Yay")." 
    else
        alias update="sudo pacman -Syu"
        echo "Package manager recognized as $(colorword '38;2;23;147;209' "Arch Linux") based $(colorword '1;34' "Pa    cman")."
    fi
    alias pkginstall="sudo pacman -S"
elif command -v brew >/dev/null 2>&1; then
    alias update="brew update && brew upgrade"
    echo "Package manager recognized as $(colorword 35 "macOS") based $(colorword '1;35' Homebrew)."
elif command -v zypper >/dev/null 2>&1; then
    . /etc/os-release
    alias pkginstall="sudo zypper install"
    case "$ID" in
        opensuse-tumbleweed)
            alias update="sudo zypper dup"
            echo "Package manager recognized as $(colorword 32 Zypper) for $(colorword 32 openSUSE) $(colorword '1;32' Tumbleweed)."
            ;;
        opensuse-leap)
            alias update="sudo zypper ref && sudo zypper up"
            echo "Package manager recognized as $(colorword 32 Zypper) for $(colorword 32 "openSUSE Leap")."
            ;;
        *)
            echo "Package manager recognized as $(colorword 32 SUSE) based $(colorword 32 Zypper)."
            echo "$(colorword '5;31' "No package manager aliases set, unsupported distro")"
            ;;
    esac
elif command -v dnf >/dev/null 2>&1; then
    alias update="sudo dnf upgrade"
    alias pkginstall="sudo dnf install"
    echo "Package manager recognized as $(colorword 31 RedHat) based $(colorword '1;34' DNF)."
else
    echo "$(colorword '5;31' "Bash does not recognise this distro's package manager, update dotfiles")"
fi
