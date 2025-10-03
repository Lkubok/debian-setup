# Oh My Zsh Ansible Setup

This role automatically installs and configures Oh My Zsh with Powerlevel10k theme and plugins for specified users.

## Features

- Installs Oh My Zsh for multiple users
- Installs Powerlevel10k theme
- Installs plugins:
  - `zsh-autosuggestions` - suggests commands as you type
  - `zsh-syntax-highlighting` - highlights commands as you type
  - `you-should-use` - reminds you of existing aliases
  - `zsh-bat` - better cat with syntax highlighting
- Deploys custom `.zshrc` configuration
- Sets zsh as default shell (optional)

## Quick Start

### Run for all configured users (root and lukasz):

```bash
cd ansible
ansible-playbook playbooks/zsh-setup.yml
```

### Run for specific users only:

```bash
ansible-playbook playbooks/zsh-setup.yml -e "ohmyzsh_users=['lukasz']"
```

### Don't change default shell:

```bash
ansible-playbook playbooks/zsh-setup.yml -e "set_default_shell=false"
```

## Configuration

### Adding More Users

Edit [playbooks/zsh-setup.yml](playbooks/zsh-setup.yml) or [roles/ohmyzsh/defaults/main.yml](roles/ohmyzsh/defaults/main.yml):

```yaml
ohmyzsh_users:
  - root
  - lukasz
  - anotheruser
```

### Adding More Plugins

Edit [roles/ohmyzsh/defaults/main.yml](roles/ohmyzsh/defaults/main.yml):

```yaml
ohmyzsh_plugins:
  - name: plugin-name
    repo: https://github.com/user/plugin-name.git
```

Then add the plugin to the plugins array in [roles/ohmyzsh/templates/zshrc.j2](roles/ohmyzsh/templates/zshrc.j2):

```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use zsh-bat plugin-name)
```

### Customizing .zshrc

Edit [roles/ohmyzsh/templates/zshrc.j2](roles/ohmyzsh/templates/zshrc.j2) to add:
- Custom aliases
- Environment variables
- PATH modifications
- Additional configurations

You can use Jinja2 templates for user-specific customization:

```bash
{% if username == 'root' %}
export SPECIAL_VAR="root-only"
{% endif %}
```

## What Gets Installed

### Directory Structure

For each user:
```
~/.oh-my-zsh/
├── custom/
│   ├── themes/
│   │   └── powerlevel10k/
│   └── plugins/
│       ├── zsh-autosuggestions/
│       ├── zsh-syntax-highlighting/
│       ├── you-should-use/
│       └── zsh-bat/
~/.zshrc
~/.p10k.zsh (basic config, run `p10k configure` to customize)
```

### Default Aliases (from .zshrc)

- `hh` - HSTR history search
- `top` → `htop`
- `vim` → `nvim`
- `python` → `python3`
- `pip` → `pip3`
- `gbr` - List git branches by date
- `gbclean` - Clean up merged branches

## Post-Installation

After running the playbook:

1. **Login to the server**:
   ```bash
   ssh lukasz@kubok.dev
   ```

2. **Verify zsh is active**:
   ```bash
   echo $SHELL  # Should show /bin/zsh
   ```

3. **Customize Powerlevel10k** (optional):
   ```bash
   p10k configure
   ```

4. **Test plugins**:
   - Start typing a command - you should see suggestions (autosuggestions)
   - Commands should be highlighted (syntax-highlighting)
   - If you type a full command that has an alias, it will remind you (you-should-use)

## Troubleshooting

### Plugin not loading

Check if the plugin is:
1. Cloned in `~/.oh-my-zsh/custom/plugins/`
2. Added to the `plugins=()` array in `~/.zshrc`
3. Sourced correctly (run `source ~/.zshrc`)

### Theme not showing

1. Ensure Powerlevel10k is installed: `ls ~/.oh-my-zsh/custom/themes/powerlevel10k`
2. Check your terminal supports 256 colors
3. Install a Nerd Font for icons (optional but recommended)

### Shell didn't change

Run manually:
```bash
chsh -s /bin/zsh
```

Or re-run playbook:
```bash
ansible-playbook playbooks/zsh-setup.yml -e "set_default_shell=true"
```

## Adding to Main Setup

To run Oh My Zsh setup as part of the main setup, update [playbooks/setup.yml](playbooks/setup.yml):

```yaml
- name: Setup kubok.dev server
  hosts: kubok_dev
  become: yes

  roles:
    - ohmyzsh  # Add this line

  # ... rest of your tasks
```

Or create a combined playbook:

```yaml
---
- import_playbook: setup.yml
- import_playbook: zsh-setup.yml
```
