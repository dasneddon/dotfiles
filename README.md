<!--
SPDX-License-Identifier: GPL-3.0-only
Copyright (C) 2026 David Sneddon
-->
# Dotfiles

Personal configuration files, shell customizations, installation scripts, and command-line utilities for Linux and macOS.

This repository provides a consistent terminal and development environment across multiple operating systems while accommodating differences between distributions, package managers, and hardware platforms.

The project emphasizes Bash, Vim, traditional Unix utilities, portability, and reproducible system configuration.

## v1.2.0 Release Notes

- Added machine-specific PATH configuration through `~/.path`.
- Included a commented `.path.example` template for local configuration.
- Local PATH entries are appended without adding duplicate or nonexistent directories.
- Machine-specific paths remain outside version control.

## v1.1.0 Release Notes

- Added Slackware support using Slackpkg. The installer checks for `rsync`, `git`, `vim`, and `tmux` and installs only missing commands from that bundle.
- Updated Linux distribution detection in the installer and Bash configuration to use `ID`, then recognized family names in `ID_LIKE`, from `/etc/os-release` (or `/usr/lib/os-release` when the former is unavailable). Legacy release files provide a fallback, including `/etc/slackware-version`.
- Standardized package management aliases: `update`, `pkginstall`, `pkgremove`, and `pkgsearch`. Use `pkginstall` for package installation; the standard Unix `install` command remains available.
- Made Fastfetch optional on Slackware. The installer warns when it is absent, shell startup runs it only when available, and the Linux installer reports `Not installed` when it is missing.

**Validation status:** Slackware support has not been runtime-tested. These notes describe the implementation; successful installation and package operations on Slackware have not been verified.

## Features

- Automated, cross-platform installation.
- Operating system and package manager detection.
- Installation of essential command-line utilities.
- Custom Oh My Bash theme with Git integration.
- Fastfetch system information reporting.
- Standardized Bash aliases and functions.
- Customized Vim editing environment.
- Terminal directory colors.
- Automated configuration synchronization.
- Git submodule management.
- Platform-specific configuration handling.
- Machine-specific PATH configuration.

## Supported Platforms

| Operating System | Package Manager |
|---|---|
| Debian | APT |
| Ubuntu | APT |
| Linux Mint | APT |
| Fedora | DNF |
| Arch Linux | Pacman |
| openSUSE Leap | Zypper |
| openSUSE Tumbleweed | Zypper |
| Slackware (not runtime-tested) | Slackpkg |
| macOS — Intel | Homebrew |
| macOS — Apple Silicon | Homebrew |

Other distributions using these package managers may also be compatible, although compatibility is not guaranteed.

## Installation

### Prerequisites

- Bash
- Git
- Internet connectivity
- A supported package manager
- Administrative privileges where required

macOS users must have [Homebrew](https://brew.sh/) installed.

### Clone the repository

```bash
git clone --recurse-submodules \
    https://github.com/dasneddon/dotfiles.git \
    ~/dotfiles
```

The repository should be located at `~/dotfiles`, as this location is used by the installation and synchronization scripts.

### Run the installer

```bash
cd ~/dotfiles
./scripts/installer
```

The installer identifies the operating system and Linux distribution, selects the corresponding package manager, installs the required software, and executes the appropriate platform-specific installation script.

Run the installer as your normal user. Administrative privileges will be requested when necessary.

**WARNING:** Installation may overwrite existing configuration files in your home directory. Back up your existing configurations before proceeding.

### Reload your shell

After installation, open a new terminal session or reload your Bash configuration:

```bash
source ~/.bashrc
```

Alternatively, replace your current shell with a fresh interactive Bash session:

```bash
exec bash -i
```

## Repository Structure

The repository contains configuration files, installation utilities, and third-party dependencies.

```text
dotfiles/
├── .config/
│   └── fastfetch/
├── .oh-my-bash-custom/
│   └── themes/
├── oh-my-bash/
├── scripts/
│   ├── installer
│   ├── linux-installer.sh
│   ├── mac-installer.sh
│   └── sync-dotfiles.sh
├── .bash_profile
├── .bashrc
├── .dircolors
├── .gitignore
├── .gitmodules
├── .path.example
├── .profile
├── .vimrc
├── LICENSE
└── README.md
```

## Installation Scripts

| Script | Description |
|---|---|
| `installer` | Identifies the operating system and distribution, selects the package manager, and coordinates installation |
| `linux-installer.sh` | Performs Linux-specific configuration deployment |
| `mac-installer.sh` | Performs macOS-specific configuration deployment |
| `sync-dotfiles.sh` | Retrieves and synchronizes configuration files |

The primary installer serves as a common entry point across supported operating systems. Platform-specific installation logic is maintained separately to simplify maintenance and accommodate differences between Linux and macOS.

### Software Dependencies

The installation process provides a common collection of command-line utilities.

| Software | Purpose |
|---|---|
| Bash | Command-line shell |
| Git | Distributed version control |
| Vim | Terminal text editor |
| tmux | Terminal multiplexing |
| rsync | File synchronization |
| Fastfetch | System information reporting |
| Oh My Bash | Bash configuration framework |

Software availability and installation procedures depend on the operating system and package manager. Fastfetch is optional and installed separately on Slackware.

### Slackware

Slackware support has not been runtime-tested. Before running the installer, ensure `sudo` is configured for your normal user and Slackpkg has a suitable mirror configured in `/etc/slackpkg/mirrors`.

The installer checks whether `rsync`, `git`, `vim`, and `tmux` are available in `PATH`. If any are missing, it refreshes the package list with `sudo /usr/sbin/slackpkg update` and installs the missing packages using `/usr/sbin/slackpkg` with `-batch=on -default_answer=y`.

Fastfetch is excluded from the Slackware package bundle. Install it separately if desired; its absence does not prevent the Linux installer from reporting completion or the shell from starting. The shell aliases below invoke `slackpkg` by name, so it must be available in your `PATH` when using those aliases.

### macOS

The macOS installation accommodates both Intel and Apple Silicon systems.

Where required, the installer configures Homebrew Bash and registers it as an available login shell.

## Bash Configuration

The Bash configuration provides a consistent interactive shell environment across Linux and macOS.

Features include:

- Custom terminal prompt.
- Git repository status integration.
- Command aliases.
- Reusable shell functions.
- Package manager detection.
- Operating system awareness.
- Terminal color customization.
- Standardized environment variables.
- Fastfetch integration.

### Machine-Specific PATH Configuration

Each machine can extend its `PATH` independently without modifying the shared Bash configuration.

Create a local configuration file if one does not already exist:

```bash
if [[ ! -e "$HOME/.path" && ! -L "$HOME/.path" ]]; then
    cp ~/dotfiles/.path.example ~/.path
fi
vim ~/.path
```

Add one absolute directory path per line:

```text
# Machine-specific binary directories
/usr/local/go/bin
/opt/custom/bin
```

Blank lines, comments, nonexistent directories, and entries already in `PATH` are ignored. Use literal absolute paths; `~` and environment variables are not expanded.

Open a new terminal session to load the paths. The local `~/.path` file is not tracked by Git. Only the example template is maintained in the repository.

### Oh My Bash

[Oh My Bash](https://github.com/ohmybash/oh-my-bash) is included as a Git submodule.

The upstream project provides the underlying Bash configuration framework, while this repository supplies additional configuration and customization.

### Custom Theme

The included `dave` theme provides a customized terminal prompt with information such as:

- Current username.
- Hostname.
- Working directory.
- Git branch.
- Git working tree status.
- Command exit status.
- Time.

The theme is intended to provide useful contextual information without requiring additional commands.

### Package Manager Integration

The Bash configuration identifies Linux distributions using `ID` and then `ID_LIKE` from the operating system release file, with legacy release-file fallbacks. macOS uses Homebrew. It provides these package management aliases for recognized families:

| Alias | Purpose | Example |
|---|---|---|
| `update` | Refresh package information and/or upgrade packages, depending on the platform | `update` |
| `pkginstall` | Install packages | `pkginstall vim` |
| `pkgremove` | Remove packages | `pkgremove vim` |
| `pkgsearch` | Search for packages | `pkgsearch vim` |

The aliases use APT, Pacman, DNF, Zypper, Homebrew, or Slackpkg as appropriate. On Arch systems with Yay installed, `update` also runs `yay -Sua` after `sudo pacman -Syu`. On openSUSE Tumbleweed, `update` uses `sudo zypper dup`; on Leap, it uses `sudo zypper ref && sudo zypper up`. Other recognized SUSE distributions receive the package aliases but no `update` alias. Homebrew aliases are defined only when `brew` is available.

On Slackware, the aliases expand to:

| Alias | Command |
|---|---|
| `update` | `sudo slackpkg update && sudo slackpkg install-new && sudo slackpkg upgrade-all` |
| `pkginstall` | `sudo slackpkg install` |
| `pkgremove` | `sudo slackpkg remove` |
| `pkgsearch` | `sudo slackpkg search` |

These commands retain the native package manager's behavior and prompts. The Slackware `update` alias does not run `slackpkg clean-system`. Use `pkginstall` rather than `install` for package management; `install` remains the standard Unix file installation utility.

## Vim Configuration

The included `.vimrc` provides a standardized editing environment suitable for programming, configuration management, and general system administration.

Features include:

- Syntax highlighting.
- Filetype detection.
- Line numbering.
- Cursor highlighting.
- Language-specific indentation.
- Smart case-sensitive searching.
- Customized keyboard mappings.
- Configuration for Python, Bash, C, C++, and Makefiles.

### Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| F5 | Save the current file |
| F7 | Execute supported Python or Bash scripts |
| F8 | Toggle line numbers |
| F9 | Toggle paste mode |
| Ctrl+L | Clear search highlighting |

Vim is configured as the preferred terminal text editor:

```bash
export EDITOR='vim'
```

## Fastfetch

[Fastfetch](https://github.com/fastfetch-cli/fastfetch) provides system information within the terminal. On Slackware it is optional and must be installed separately. Bash startup invokes it only when the command is available; the Linux installer reports `Not installed` if it is absent.

The configuration is maintained in:

```text
~/.config/fastfetch/
```

Depending on the operating system and available hardware, displayed information may include:

- Operating system and kernel.
- System uptime and load averages.
- Installed packages.
- Shell and terminal.
- Desktop environment and window manager.
- Processor and graphics hardware.
- Memory and swap utilization.
- Storage utilization.
- Network information.
- Display information.
- Battery status.

Run Fastfetch manually:

```bash
fastfetch
```

## Configuration Synchronization

Configuration files are maintained in a dedicated Git repository and synchronized into the user's home directory.

The synchronization script is located at:

```text
~/dotfiles/scripts/sync-dotfiles.sh
```

### Synchronize Configuration Files

```bash
cd ~/dotfiles
./scripts/sync-dotfiles.sh
```

The synchronization process uses Git and rsync to retrieve and deploy configuration files.

The included login configuration also provides support for invoking the synchronization script automatically.

### Update the Repository

To retrieve the latest repository changes:

```bash
git -C ~/dotfiles pull --ff-only
```

To synchronize Git submodules:

```bash
git -C ~/dotfiles submodule sync --recursive
git -C ~/dotfiles submodule update --init --recursive
```

### Managing Configuration Changes

The repository should serve as the source of truth for managed configuration files.

Make permanent changes inside the repository rather than directly modifying deployed configuration files.

For example:

```bash
vim ~/dotfiles/.bashrc
```

Review changes:

```bash
git -C ~/dotfiles diff
```

Deploy the updated configuration:

```bash
~/dotfiles/scripts/sync-dotfiles.sh
```

Direct modifications to deployed configuration files may be overwritten during subsequent synchronization.

Machine-specific PATH entries are an exception: edit `~/.path` directly on each machine rather than modifying the repository template.

## Selective Installation

Running the complete installer is not required. Individual configuration files can be installed independently.

### Vim

```bash
cp -i ~/dotfiles/.vimrc ~/.vimrc
```

### Directory Colors

```bash
cp -i ~/dotfiles/.dircolors ~/.dircolors
```

### Fastfetch

```bash
mkdir -p ~/.config/fastfetch

cp -Ri ~/dotfiles/.config/fastfetch/. \
    ~/.config/fastfetch/
```

Selective installation is useful for users who wish to retain their existing shell environment or adopt only specific components of the repository.

## Troubleshooting

### Missing Git Submodules

Initialize the repository's submodules:

```bash
git -C ~/dotfiles submodule update --init --recursive
```

### Local Changes Prevent Updates

Inspect the repository:

```bash
git -C ~/dotfiles status
git -C ~/dotfiles diff
```

Commit, stash, or deliberately discard conflicting changes before updating.

### Configuration Changes Are Not Visible

Reload the Bash configuration:

```bash
source ~/.bashrc
```

Alternatively, start a new terminal session.

### Installer Permission Denied

Ensure the installer is executable:

```bash
chmod +x ~/dotfiles/scripts/installer
```

Alternatively, invoke it directly with Bash:

```bash
bash ~/dotfiles/scripts/installer
```

### Unsupported Package Manager

The installer requires a recognized package manager. Users of unsupported distributions may install the required dependencies manually and selectively deploy the configuration files.

## Security

Before installing configuration files from this or any other repository:

- Review installation scripts before executing them.
- Back up existing configuration files.
- Run installers as a normal user.
- Review third-party dependencies.
- Keep Git TLS certificate verification enabled.
- Never commit passwords, private keys, access tokens, or other credentials.

Some installation operations require administrative privileges to install software or configure the operating system.

## Contributing

Suggestions, bug reports, and improvements are welcome.

To contribute:

1. Fork the repository.
2. Create a feature branch.
3. Make and test your changes.
4. Submit a pull request.

Changes should prioritize portability, readability, maintainability, and compatibility with existing supported platforms.

## Design Philosophy

This project draws upon traditional Unix principles of simplicity, modularity, portability, and separation of responsibilities.

The objective is not to eliminate differences between operating systems, but to provide a familiar and productive environment regardless of the underlying platform.

The project prioritizes:

- Reproducible system configuration.
- Native package management.
- Minimal unnecessary dependencies.
- Transparent shell scripts.
- Version-controlled configuration.
- Independent, reusable components.
- Consistent command-line workflows.
- Free and open-source software.

## License

Original material in this repository is licensed under the **GNU General Public License, Version 3**, as specified in the [LICENSE](LICENSE) file.

Third-party components retain their respective upstream licenses.

## Author

**David Sneddon**

GitHub: [@dasneddon](https://github.com/dasneddon)

---

*One configuration. Many machines. A consistent environment.*
