# AGENTS.md

This repo manages cross-platform dotfiles and tooling with Ansible playbooks.

## Common commands

### Ansible playbooks

```bash
ansible-playbook -K playbooks/mac/zsh.yml
ansible-playbook -K playbooks/mac/apps.yml
ansible-playbook -K playbooks/mac/development.yml
ansible-playbook -K playbooks/mac/vim.yml
ansible-playbook -K playbooks/linux/zsh.yml
ansible-playbook -K playbooks/linux/apps.yml
ansible-playbook -K playbooks/linux/development.yml
ansible-playbook -K playbooks/linux/vim.yml
ansible-playbook ansible/bootstrap.yml
```

Example bootstrap tag: opencode.

```bash
# opencode bootstrap
ansible-playbook ansible/bootstrap.yml -t opencode
```

### Testing

```bash
docker compose up --build -d
docker-compose exec debian bash
docker-compose exec redhat bash
make clean_nvim
```
