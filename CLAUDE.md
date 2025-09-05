# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Ansible Playbook Execution

```bash
# macOS setup
ansible-playbook -K playbooks/mac/zsh.yml      # Install Zsh configuration
ansible-playbook -K playbooks/mac/apps.yml     # Install macOS applications
ansible-playbook -K playbooks/mac/development.yml  # Development environment setup
ansible-playbook -K playbooks/mac/vim.yml      # Vim/Neovim setup

# Linux setup
ansible-playbook -K playbooks/linux/zsh.yml    # Install Zsh configuration
ansible-playbook -K playbooks/linux/apps.yml   # Install Linux applications
ansible-playbook -K playbooks/linux/development.yml  # Development environment setup
ansible-playbook -K playbooks/linux/vim.yml    # Vim/Neovim setup

# Cross-platform
ansible-playbook ansible/bootstrap.yml         # Install LazyVim and development tools
```

### Testing and Validation

```bash
# Build and run test containers
docker compose up --build -d

# Access test environments
docker-compose exec debian bash
docker-compose exec redhat bash

# Clean Neovim cache/data
make clean_nvim
```

## Repository Architecture

### Infrastructure as Code Design

This dotfiles repository follows an **Infrastructure as Code** philosophy using Ansible for cross-platform configuration management. The architecture separates concerns by OS (mac/, linux/) while maintaining shared configuration logic.

### Key Architectural Components

**Configuration Management Layer:**

- `ansible.cfg` and `hosts` files configure Ansible to run locally
- Platform-specific playbooks in `playbooks/mac/` and `playbooks/linux/`
- Shared cross-platform playbooks for universal tools
- Role-based approach for complex installations (roles/neovim/, roles/lazygit/, roles/alacritty/, roles/fonts/, roles/lazyvim/)

**Application Configuration Layer:**

- `alacritty/` - Terminal emulator with Dracula theme and FiraCode Nerd Font
- `config/lazyvim/` - LazyVim Neovim configuration
- `iterm2/` - macOS terminal profile configuration
- Legacy `vim/` configuration for CoC (Conquer of Completion)

**Testing Infrastructure:**

- Docker-based validation using `docker-compose.yml`
- Debian and RedHat containers for multi-distro testing
- Volume mounting enables live testing of configuration changes

### Configuration Philosophy

**Cross-Platform Compatibility:**
The repository supports Darwin (macOS), Debian, and RedHat systems through:

- OS-specific task files that handle platform differences
- Version-pinned dependencies (e.g., Neovim 0.10.1)
- Conditional logic in Ansible tasks based on `ansible_distribution`

**Modular Design:**

- Each application has isolated configuration directories
- Complex installations broken into reusable Ansible roles
- Clear separation between system setup and user configuration

**Theme Consistency:**
Dracula theme is consistently applied across:

- Alacritty terminal configuration
- Neovim color scheme preferences

## Important Development Notes

### LazyVim Configuration Structure

LazyVim is installed via the bootstrap process using the official LazyVim starter template:

- Automatically clones from <https://github.com/LazyVim/starter>
- Installs required dependencies: ripgrep, fzf, fd, and xclip (Linux)
- Custom configurations can be added to `~/.config/nvim/` after installation

### Ansible Role Dependencies

Complex installations use dedicated roles:

- `roles/neovim/` handles cross-platform Neovim installation
- `roles/lazygit/` manages the Git TUI tool installation
- `roles/alacritty/` handles terminal emulator setup
- `roles/fonts/` manages font installation across platforms
- `roles/lazyvim/` handles LazyVim installation and setup
- Roles include platform-specific task files and proper dependency management

### Testing Workflow

Use the Docker testing environment for validating changes:

1. Modify configurations locally
2. Run `docker compose up --build -d` to create test containers
3. Execute playbooks against containers to validate changes
4. Test both Debian and RedHat environments for cross-platform compatibility

### Version Management

- Neovim is pinned to version 0.10.1 for stability
- LazyVim uses the latest starter template from GitHub
- Application versions are managed through Ansible variables for easy updates
