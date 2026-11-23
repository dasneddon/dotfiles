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
export PATH=$PATH:~/.cargo/bin #Rust

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
    alias install="sudo apt-get install"
    echo "Package manager recognized as APT (Debian based)"
elif command -v pacman >/dev/null 2>&1; then
    if command -v yay >/dev/null 2>&1; then
        alias update="sudo pacman -Syu && yay -Sua"
        echo "Package manager recognized as Pacman and Yay (Arch based)"
    else
        alias update="sudo pacman -Syu"
        echo "Package manager recognized as Pacman (Arch based)"
    fi
    alias install="sudo pacman -S"
elif command -v brew >/dev/null 2>&1; then
    alias update="brew update && brew upgrade"
    echo "Package manager recognized as Homebrew (Mac)"
elif command -v zypper >/dev/null 2>&1; then
    . /etc/os-release
    alias install="sudo zypper install"
    case "$ID" in
        opensuse-tumbleweed)
            alias update="sudo zypper dup"
            echo "Package manager recognized as Zypper (openSUSE Tumbleweed)"
            ;;
        opensuse-leap)
            alias update="sudo zypper ref && sudo zypper up"
            echo "Package manager recognizzed as Zypper (openSUSE Leap)"
            ;;
        *)
            echo "Package manager recognized as Zypper (Unsupported Distro - Update Dotfiles)"
            ;;
    esac
else
    echo "Bash does not recognise this OS's package manager, update dotfiles"
fi
