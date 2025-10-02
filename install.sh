#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PACKAGE_LIST="packages/packages.txt"
LOG_FILE="install.log"

# Functions
log() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "This script must be run as root or with sudo"
        exit 1
    fi
}

update_system() {
    log "Updating package lists..."
    apt-get update || {
        error "Failed to update package lists"
        exit 1
    }
}

install_package() {
    local package=$1

    if dpkg -l | grep -q "^ii  $package "; then
        warn "Package '$package' is already installed"
        return 0
    fi

    log "Installing $package..."
    if apt-get install -y "$package" >> "$LOG_FILE" 2>&1; then
        log "Successfully installed $package"
        return 0
    else
        error "Failed to install $package"
        return 1
    fi
}

install_from_list() {
    local list_file=$1

    if [ ! -f "$list_file" ]; then
        error "Package list file not found: $list_file"
        exit 1
    fi

    local total=0
    local installed=0
    local failed=0
    local skipped=0

    # Count total packages
    total=$(grep -v '^#' "$list_file" | grep -v '^[[:space:]]*$' | wc -l)

    log "Found $total packages to install"
    echo ""

    # Read and install packages
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        package=$(echo "$line" | awk '{print $1}')

        if install_package "$package"; then
            if dpkg -l | grep -q "^ii  $package "; then
                ((installed++))
            else
                ((skipped++))
            fi
        else
            ((failed++))
        fi
    done < "$list_file"

    echo ""
    log "Installation complete!"
    log "Total packages: $total"
    log "Installed: $installed"
    log "Skipped (already installed): $skipped"
    log "Failed: $failed"

    if [ $failed -gt 0 ]; then
        warn "Some packages failed to install. Check $LOG_FILE for details."
        return 1
    fi

    return 0
}

upgrade_system() {
    log "Upgrading installed packages..."
    apt-get upgrade -y || {
        warn "Some packages failed to upgrade"
    }
}

cleanup() {
    log "Cleaning up..."
    apt-get autoremove -y
    apt-get autoclean
}

show_help() {
    cat << EOF
Debian Package Installer

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help          Show this help message
    -l, --list FILE     Specify custom package list file (default: packages/packages.txt)
    -u, --upgrade       Upgrade system after installing packages
    -c, --cleanup       Run cleanup after installation
    --no-update         Skip system update before installation

EXAMPLES:
    sudo ./install.sh
    sudo ./install.sh --upgrade --cleanup
    sudo ./install.sh --list my-packages.txt

EOF
}

# Main script
main() {
    local do_upgrade=false
    local do_cleanup=false
    local do_update=true

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                PACKAGE_LIST="$2"
                shift 2
                ;;
            -u|--upgrade)
                do_upgrade=true
                shift
                ;;
            -c|--cleanup)
                do_cleanup=true
                shift
                ;;
            --no-update)
                do_update=false
                shift
                ;;
            *)
                error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Start installation
    log "Starting Debian package installation"
    log "Log file: $LOG_FILE"
    echo ""

    check_root

    if [ "$do_update" = true ]; then
        update_system
    fi

    install_from_list "$PACKAGE_LIST"

    if [ "$do_upgrade" = true ]; then
        upgrade_system
    fi

    if [ "$do_cleanup" = true ]; then
        cleanup
    fi

    log "All done!"
}

main "$@"
