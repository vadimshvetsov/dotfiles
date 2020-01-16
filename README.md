# Dotfiles

### Installation
- Install `git` and [`brew`](https://brew.sh/) at master machine

- Install `python3` with brew for getting pip3

```sh
brew install python3
```

- Install `ansible` with `pip3` package manager

```sh
pip3 install ansible
```

- Clone this repo and jump into `dotfiles` folder
```sh
git clone https://github.com/vadimshvetsov/dotfiles.git && cd dotfiles
```
- Run playbooks for install appropriate things

```sh
ansible-playbook apps.yml terminal.yml vim.yml
```

- Some playbooks have become directives and need permissions to install

```sh
ansible-playbook -K zsh.yml
```

Bugs:

Hyper terminal not reloading shell after `chsh` execution, issue [here](https://github.com/zeit/hyper/issues/81)
As temporary solution - only reboot

Hyper terminal showing % (percent sign) on first tab, issue [here](https://github.com/zeit/hyper/issues/2144)
As temporary fix - adding this to .zshrc
```sh
unsetopt PROMPT_SP
```
