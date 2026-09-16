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

On Debian or Ubuntu, use apt.

```sh
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```

Install Ansible Galaxy collections, then run bootstrap.

```sh
ansible-galaxy collection install -r requirements.yml
ansible-playbook -K ansible/bootstrap.yml
```

Use `-K` only when a run reaches privileged tasks and needs a sudo password. `-K` asks for the sudo/become password. It does not force every task to use sudo.

Run a tagged bootstrap when needed. OpenCode is intended to be run explicitly by tag. Skills are dependencies of that role, not a direct bootstrap target.

```sh
ansible-playbook ansible/bootstrap.yml -t opencode
ansible-playbook -K ansible/bootstrap.yml -t zsh
```

`bootstrap.yml` does not currently use Ansible's `never` opt-in tag.

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
