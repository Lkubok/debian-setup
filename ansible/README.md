# Ansible Setup for kubok.dev

This Ansible configuration automates the setup of kubok.dev server with all required packages from `../packages/packages.txt`.

## Prerequisites

1. **Install Ansible** on your local machine:
   ```bash
   # On macOS
   brew install ansible

   # On Debian/Ubuntu
   sudo apt install ansible

   # Using pip
   pip install ansible
   ```

2. **SSH Access** to kubok.dev:
   - Ensure you can SSH into kubok.dev: `ssh root@kubok.dev`
   - Set up SSH key authentication (recommended)

## Directory Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── inventories/
│   └── hosts.ini           # Server inventory
├── playbooks/
│   └── setup.yml           # Main setup playbook
└── roles/                  # For future role-based organization
```

## Configuration

### 1. Update Inventory

Edit `inventories/hosts.ini` if you need to change the username or add SSH options:

```ini
[kubok_dev]
kubok.dev ansible_user=your_username ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### 2. Test Connectivity

```bash
cd ansible
ansible kubok_dev -m ping
```

Expected output:
```
kubok.dev | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Usage

### Run the Setup Playbook

Install all packages from packages.txt:

```bash
cd ansible
ansible-playbook playbooks/setup.yml
```

### Dry Run (Check Mode)

See what changes would be made without applying them:

```bash
ansible-playbook playbooks/setup.yml --check
```

### Upgrade System Packages

Run with package upgrade enabled:

```bash
ansible-playbook playbooks/setup.yml -e "upgrade_packages=true"
```

### Run Specific Tasks

Using tags (if you add them to the playbook):

```bash
ansible-playbook playbooks/setup.yml --tags "packages"
```

## Common Commands

### Check server facts
```bash
ansible kubok_dev -m setup
```

### Run ad-hoc commands
```bash
# Check disk space
ansible kubok_dev -m shell -a "df -h"

# Check installed package
ansible kubok_dev -m shell -a "dpkg -l | grep git"

# Reboot server
ansible kubok_dev -m reboot
```

### Verbose output for debugging
```bash
ansible-playbook playbooks/setup.yml -v   # verbose
ansible-playbook playbooks/setup.yml -vv  # more verbose
ansible-playbook playbooks/setup.yml -vvv # very verbose
```

## What the Playbook Does

1. Updates apt cache
2. (Optional) Upgrades all system packages
3. Installs all packages listed in packages.txt:
   - Development tools (git, vim, curl, wget, build-essential)
   - System utilities (htop, tree, tmux, mc, screen, rsync)
   - Network tools (net-tools, openssh-server, openssh-client)
   - Compression tools (zip, unzip, tar, gzip)
   - Text processing tools (jq)
   - System monitoring (lsof, strace, dstat)
   - Additional packages (nodejs)
4. Ensures SSH service is running and enabled
5. Displays installed package versions

## Customization

### Adding More Packages

Edit `playbooks/setup.yml` and add packages to the `packages` list:

```yaml
vars:
  packages:
    # ... existing packages ...
    - your-new-package
```

### Creating Roles

For more complex setups, create roles:

```bash
cd ansible
ansible-galaxy init roles/webserver
```

Then reference the role in your playbook.

## Troubleshooting

### SSH Connection Issues
```bash
# Test SSH directly
ssh -vvv root@kubok.dev

# Use specific SSH key
ansible-playbook playbooks/setup.yml --private-key=~/.ssh/your_key
```

### Permission Issues
```bash
# Prompt for become password
ansible-playbook playbooks/setup.yml --ask-become-pass
```

### Package Not Found
Ensure the package name is correct for Debian. Check with:
```bash
ssh root@kubok.dev "apt-cache search package-name"
```

## Next Steps

- Create separate playbooks for different services (web server, database, etc.)
- Use Ansible Vault to encrypt sensitive data
- Set up continuous deployment pipelines
- Create roles for reusable configurations
