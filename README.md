# Dotfiles

Personal configuration files, shell customizations, and utility scripts maintained by **David Sneddon**.

This repository provides a centralized collection of configurations used across my macOS and Linux systems. Its purpose is to maintain a consistent terminal environment while accommodating differences between operating systems, distributions, and individual machines.

The configurations reflect my preference for Bash, Vim, traditional Unix utilities, and command-line workflows.

## Features

- **Cross-platform Bash configuration** for macOS and several Linux distributions.
- **Custom Oh My Bash theme** and shell enhancements.
- **Fastfetch integration** for displaying system information.
- **Package manager detection** with convenient update and installation aliases.
- **Vim configuration** with syntax highlighting, indentation rules, and keyboard shortcuts.
- **Custom directory colors** for terminal listings.
- **Shell utilities** for everyday command-line operations.
- **Optional synchronization** of configuration files from the repository.

## Repository Structure

```text
dotfiles/
├── .config/
│   └── fastfetch/             # Fastfetch configuration
├── .oh-my-bash-custom/
│   └── themes/                # Custom Bash themes
├── oh-my-bash/                # Git submodule
├── scripts/                   # Utility and synchronization scripts
├── .bash_profile              # Bash login configuration
├── .bashrc                   # Interactive Bash configuration
├── .dircolors                # Terminal directory colors
├── .gitignore
├── .gitmodules
├── .profile                  # Login environment settings
├── .vimrc                    # Vim configuration
└── LICENSE                   # GNU GPLv3
```

## Supported Environments

The configurations are primarily intended for:

| Platform | Package Manager |
|---|---|
| Debian / Ubuntu | APT |
| Arch Linux | Pacman |
| Arch Linux with Yay | Pacman / Yay |
| openSUSE Leap | Zypper |
| openSUSE Tumbleweed | Zypper |
| macOS | Homebrew |

Other Unix-like systems may work with modifications.

Some features depend on external utilities being installed.

## Installation

### 1. Clone the repository

```bash
git clone --recurse-submodules \
    https://github.com/dasneddon/dotfiles.git \
    ~/dotfiles
```

The `--recurse-submodules` option retrieves Oh My Bash alongside the repository.

### 2. Install configurations selectively

Configurations can be copied individually rather than deploying the entire repository.

For example:

```bash
cp -i ~/dotfiles/.vimrc ~/.vimrc
cp -i ~/dotfiles/.dircolors ~/.dircolors
```

For Fastfetch:

```bash
mkdir -p ~/.config/fastfetch

cp -Ri ~/dotfiles/.config/fastfetch/. \
    ~/.config/fastfetch/
```

The `-i` option prompts before overwriting existing files.

### 3. Configure Bash

The included `.bashrc` uses Oh My Bash and a custom theme named `dave`.

Install Oh My Bash and the custom theme before activating the configuration.

After setting up the required dependencies, copy the Bash configuration:

```bash
cp -i ~/dotfiles/.bashrc ~/.bashrc
```

Start a new interactive Bash shell to load the configuration.

**Note:** The Bash configuration expects Oh My Bash at `~/.oh-my-bash` and custom themes at `~/.oh-my-bash-custom`. Machine-specific settings should be reviewed before installation.

## Bash Customizations

The `.bashrc` includes several conveniences.

### Package Manager Integration

The shell detects supported package managers and configures aliases appropriate to the environment.

Examples:

```bash
update
```

Updates packages using the detected package manager.

```bash
install vim
```

Installs a package on supported systems where the `install` alias is defined.

The implementation distinguishes between openSUSE Leap and Tumbleweed, including their different recommended update operations.

### Fastfetch

When Fastfetch is installed, it runs automatically in interactive Bash sessions.

### Oh My Bash

The repository uses Oh My Bash with a custom theme and selected completions and plugins.

These provide an enhanced prompt, command completion, Git integration, and other shell conveniences.

### Default Editor

Vim is configured as the preferred terminal editor:

```bash
export EDITOR='vim'
```

## Vim Configuration

The `.vimrc` provides a consistent editing environment with:

- Syntax highlighting and filetype detection.
- Line numbers, cursor highlighting, and status information.
- Four-space indentation for common programming languages.
- Smart case-sensitive searching.
- Python, shell, C, C++, and Makefile-specific settings.
- Keyboard shortcuts for saving, executing scripts, and toggling editor settings.

Selected shortcuts:

| Shortcut | Action |
|---|---|
| F5 | Save current file |
| F7 | Execute Python or Bash script |
| F8 | Toggle line numbers |
| F9 | Toggle paste mode |
| Ctrl+L | Clear search highlighting |

## Configuration Management

This repository serves as a central reference for maintaining configurations across different machines.

Files can be copied, modified, and deployed independently according to each system's requirements. A configuration suitable for a Linux server may not necessarily be appropriate for a macOS workstation.

### Optional Synchronization

The repository includes:

```text
scripts/sync-dotfiles.sh
```

The script retrieves updates using Git and copies repository contents into the user's home directory using `rsync`.

The included `.profile` also contains a hook that invokes the script during interactive login when it is executable.

**Warning:** The synchronization script uses overwrite behavior. It may replace existing configuration files, so review the script and back up local settings before enabling it.

Selective manual installation is preferable when preserving machine-specific configurations.

## Dependencies

Depending on which configurations are used:

- Bash
- Git
- Vim
- Oh My Bash
- Fastfetch
- GNU `dircolors` on applicable Linux systems
- `rsync` for synchronization
- A supported package manager

Not all dependencies are necessary on every machine.

## Security

This repository is intended for configuration files and general-purpose scripts.

Private SSH keys, passwords, authentication tokens, and other sensitive information should not be committed.

Machine-specific configurations should be reviewed before being published or copied between systems.

## License

This repository contains original material distributed under the **GNU General Public License, Version 3 (GPLv3)**, as specified in the [LICENSE](LICENSE) file.

Third-party components, including the Oh My Bash submodule, retain their respective upstream licenses.

## Author

**David Sneddon**

GitHub: [@dasneddon](https://github.com/dasneddon)

---

*Maintained as a personal collection of configurations and an ongoing exploration of Unix-like operating systems, shell environments, and command-line tools.*
