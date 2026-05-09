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

Run a tagged bootstrap when needed.

```sh
ansible-playbook ansible/bootstrap.yml -t skills
ansible-playbook -K ansible/bootstrap.yml -t zsh
```

## OpenCode

`~/.config/opencode` is symlinked from `config/opencode` via Ansible. Agent files live in `config/opencode/agents`. Global skills install to `~/.agents/skills`. Custom OpenCode skills live in `~/.config/opencode/skills`.

```sh
npx skills add <skill>
```
