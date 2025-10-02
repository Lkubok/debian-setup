# Debian Setup Project

A comprehensive tool for managing Debian package installations and system configurations.

## Features

- ✅ Automated package installation from a configurable list
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
│   └── packages.txt           # List of packages to install
├── config-backup/             # Config backup scripts (future)
├── scripts/                   # Additional utility scripts
└── README.md                  # This file
```

## Quick Start

### 1. Install Packages

```bash
sudo ./install.sh
```

### 2. Customize Package List

Edit [packages/packages.txt](packages/packages.txt) to add or remove packages:

```bash
vim packages/packages.txt
```

### 3. Run with Options

```bash
# Install packages and upgrade system
sudo ./install.sh --upgrade --cleanup

# Use custom package list
sudo ./install.sh --list custom-packages.txt

# Skip system update
sudo ./install.sh --no-update
```

## Usage

### Installation Script Options

```
Usage: ./install.sh [OPTIONS]

OPTIONS:
    -h, --help          Show help message
    -l, --list FILE     Specify custom package list file
    -u, --upgrade       Upgrade system after installing packages
    -c, --cleanup       Run cleanup after installation
    --no-update         Skip system update before installation
```

### Package List Format

The [packages/packages.txt](packages/packages.txt) file uses a simple format:

- One package per line
- Lines starting with `#` are comments
- Empty lines are ignored

Example:

```
# Development Tools
git
vim
curl

# System Utilities
htop
tmux
```

## Features in Detail

### Automatic Package Installation

The script will:
1. Update package lists (unless `--no-update` is specified)
2. Check if each package is already installed
3. Install missing packages
4. Log all operations to `install.log`
5. Provide a summary of installed, skipped, and failed packages

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

### Basic Installation

```bash
sudo ./install.sh
```

### Full System Setup

```bash
sudo ./install.sh --upgrade --cleanup
```

### Custom Package List

```bash
sudo ./install.sh --list server-packages.txt
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
