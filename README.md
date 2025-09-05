# Dotfiles

### Prerequisites

- Install `git`
- Clone this repo

```sh
git clone https://github.com/vadimshvetsov/dotfiles.git && cd dotfiles
```

### Installation for OS X

- Install `git` and [`brew`](https://brew.sh/) at master machine

```sh
brew install ansible
```

- Run playbooks for install appropriate things

```sh
ansible-playbook -K playbooks/mac/zsh.yml
```

### Installation for Linux

- Install `ansible` and `git`

```sh
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```

- Run playbooks for install appropriate things

```sh
ansible-playbook -K playbooks/linux/zsh.yml
```

### Testing changes

To test changes run playbook within OS containers. To build and run containers:

```sh
docker compose up --build -d
```

Run interactive shell using:

```sh
docker-compose exec debian bash
```
