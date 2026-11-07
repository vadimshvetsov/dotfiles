# Dotfiles

## Prerequisites

- Install `git`
- Clone this repo

```sh
git clone https://github.com/vadimshvetsov/dotfiles.git && cd dotfiles
```

## Installation

Install Ansible. On macOS, use Homebrew.

```sh
brew install ansible
```

On Ubuntu, use the [Ansible PPA](https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu).
These commands require an account with sudo privileges.

```sh
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

On Debian, use the distribution repository instead of adding the Ubuntu PPA
with the commands above.

```sh
sudo apt update
sudo apt install ansible
```

Verify the installation before running any playbooks:

```sh
ansible --version
ansible-playbook --version
```

Run the remaining commands from the root of the cloned repository.

Install Ansible Galaxy collections, then run the CLI bootstrap.
The CLI playbook does not install Ghostty, desktop fonts or X11 clipboard tools.

```sh
ansible-galaxy collection install -r requirements.yml
ansible-playbook -K ansible/bootstrap.yml
```

GUI applications and desktop assets are a separate, optional step:

```sh
ansible-playbook -K ansible/gui_bootstrap.yml
```

`gui_bootstrap.yml` installs Nerd Fonts, Ghostty and the X11 clipboard tool `xclip`
on supported Linux distributions. macOS uses its built-in clipboard tools.
Run both playbooks for a desktop setup; use only `bootstrap.yml` for a headless
SSH development machine. Fonts are rendered by the terminal on the client,
so the SSH server does not need the desktop fonts role.

The LazyVim role owns the optional X11 provider, controlled by
`lazyvim_install_xclip` (default: `false`). The GUI playbook enables it and reuses
only the clipboard tasks, without reinstalling the editor stack. The CLI
bootstrap leaves it disabled. The Neovim configuration keeps its existing OSC 52
clipboard support for SSH/Herdr/tmux sessions without a display.

Use `-K` only when a run reaches privileged tasks and needs a sudo password. `-K` asks for the sudo/become password. It does not force every task to use sudo.

Run a tagged bootstrap when needed. OpenCode is included in the default CLI bootstrap. Use `-t opencode` to run only
OpenCode and its dependencies. Skills are dependencies of that role, not a direct
bootstrap target.

```sh
ansible-playbook ansible/bootstrap.yml -t opencode
ansible-playbook -K ansible/bootstrap.yml -t zsh
```

## Layout

`home/` mirrors the home directory. A file's path under `home/` is the path Ansible links it to under `$HOME`.

```text
home/
  AGENTS.md                  -> ~/AGENTS.md
  .claude/CLAUDE.md          -> ~/.claude/CLAUDE.md   (symlink to ../AGENTS.md)
  .zshrc                     -> ~/.zshrc
  .zshrc_aliases             -> ~/.zshrc_aliases
  .config/ghostty/           -> ~/.config/ghostty
  .config/herdr/config.toml  -> ~/.config/herdr/config.toml
  .config/nvim/              -> ~/.config/nvim
  .config/opencode/          -> ~/.config/opencode
  .config/tmux/              -> ~/.config/tmux
```

Add a new dotfile by putting it at its mirrored path under `home/`, then pointing a role's `*_source_dir` at it.

`agents/` sits outside `home/` because nothing links it into the home directory. It holds per-agent `opencode.yml` and `prompt.md` sources.

Machine-local files stay out of the repo: `~/.zprofile`, `~/.zshenv`, `~/.work_zshrc`, and `~/.claude/rules/`.

## OpenCode

`~/.config/opencode` is symlinked from `home/.config/opencode` via Ansible. Agent files live in `home/.config/opencode/agents`. Global skills install to `~/.agents/skills`. Custom OpenCode skills live in `~/.config/opencode/skills`.

```sh
npx skills add <skill>
```
