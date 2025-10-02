# Debian Setup Project

A comprehensive tool for managing Debian package installations and system configurations.

## Features

- ✅ Automated APT package installation from a configurable list
- ✅ NPM global package installation support
- ✅ Detailed logging and error handling
- ✅ Color-coded output for easy monitoring
- ✅ Skip already installed packages
- ✅ System update and upgrade support
- 🔄 Config backup functionality (coming soon)

## Project Structure

```
debian-setup/
├── install.sh                  # Main installation script
├── packages/
│   ├── packages.txt           # List of APT packages to install
│   └── npm-packages.txt       # List of NPM packages to install
├── config-backup/             # Config backup scripts (future)
├── scripts/                   # Additional utility scripts
└── README.md                  # This file
```

## Quick Start

### 1. Install Packages

```bash
sudo ./install.sh
```

### 2. Customize Package Lists

Edit package lists to add or remove packages:

```bash
vim packages/packages.txt      # APT packages
vim packages/npm-packages.txt  # NPM packages
```

### 3. Run with Options

```bash
# Install both APT and NPM packages
sudo ./install.sh

# Install packages and upgrade system
sudo ./install.sh --upgrade --cleanup

# Install only NPM packages
sudo ./install.sh --npm-only

# Skip NPM packages
sudo ./install.sh --skip-npm

# Use custom package lists
sudo ./install.sh --list custom-packages.txt --npm-list custom-npm.txt
```

## Usage

### Installation Script Options

```
Usage: ./install.sh [OPTIONS]

OPTIONS:
    -h, --help              Show help message
    -l, --list FILE         Specify custom APT package list file
    -n, --npm-list FILE     Specify custom NPM package list file
    -u, --upgrade           Upgrade system after installing packages
    -c, --cleanup           Run cleanup after installation
    --no-update             Skip system update before installation
    --skip-npm              Skip npm package installation
    --npm-only              Only install npm packages (skip apt packages)
```

### Package List Format

Both [packages/packages.txt](packages/packages.txt) and [packages/npm-packages.txt](packages/npm-packages.txt) use a simple format:

- One package per line
- Lines starting with `#` are comments
- Empty lines are ignored

**APT Packages Example:**

```
# Development Tools
git
vim
curl

# System Utilities
htop
tmux
```

**NPM Packages Example:**

```
# AI Tools
@anthropic-ai/claude-code

# Development Tools
typescript
eslint
```

## Features in Detail

### Automatic Package Installation

The script will:
1. Update APT package lists (unless `--no-update` is specified)
2. Check if each APT package is already installed
3. Install missing APT packages
4. Check if npm is available and install NPM packages (unless `--skip-npm` is specified)
5. Check if each NPM package is already installed globally
6. Install missing NPM packages
7. Log all operations to `install.log`
8. Provide a summary of installed, skipped, and failed packages

### Error Handling

- Validates root/sudo privileges
- Checks if package list exists
- Handles installation failures gracefully
- Provides detailed error messages
- Continues with remaining packages if one fails

### Logging

All operations are logged to `install.log` with timestamps and status:
- `[INFO]` - Successful operations
- `[WARN]` - Warnings (e.g., already installed packages)
- `[ERROR]` - Failed operations

## Examples

### Basic Installation (APT + NPM)

```bash
sudo ./install.sh
```

### Full System Setup

```bash
sudo ./install.sh --upgrade --cleanup
```

### NPM Packages Only

```bash
sudo ./install.sh --npm-only
```

### Skip NPM Packages

```bash
sudo ./install.sh --skip-npm
```

### Custom Package Lists

```bash
sudo ./install.sh --list server-packages.txt --npm-list dev-tools.txt
```

## Future Features

### Config Backup (Planned)

The [config-backup/](config-backup/) directory will contain scripts for:
- Backing up configuration files
- Restoring configurations
- Tracking config changes
- Syncing configs across systems

## Requirements

- Debian-based system (Debian, Ubuntu, etc.)
- Root or sudo privileges
- APT package manager

## Troubleshooting

### Permission Denied

Make sure the script is executable:

```bash
chmod +x install.sh
```

### Package Not Found

Ensure the package name is correct and available in your distribution's repositories:

```bash
apt-cache search package-name
```

### Installation Failures

Check the log file for detailed error messages:

```bash
cat install.log
```

## Contributing

Feel free to add more packages to [packages/packages.txt](packages/packages.txt) or customize the installation script for your needs.

## License

Free to use and modify for personal or commercial use.
