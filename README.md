# Dotfiles

### Installation
- Install `git` and `python` at master machine
- Install `ansible` with `pip` package manager
```sh
pip install ansible
```
- Clone this repo and jump into `dotfiles` folder
```sh
git clone https://github.com/vadimshvetsov/dotfiles.git && cd dotfiles
```
- Run playbooks for install appropriate things
```sh
ansible-playbook zsh.yml vim.yml
```
