# AGENTS.md

This repo manages cross-platform dotfiles and tooling with Ansible.

## Common commands

### Ansible setup

```bash
ansible-galaxy collection install -r requirements.yml
ansible-playbook -K ansible/bootstrap.yml
```

Use `-K` only if a run reaches privileged tasks and needs a sudo password. `-K` asks for the sudo/become password. It does not force every task to use sudo. Do not configure `ansible.cfg` to globally prompt for a become password.

Run non-privileged tags without `-K`. Add `-K` for tagged runs that hit privileged tasks, such as shell changes or Linux package installs.

OpenCode is intended to be run explicitly by tag. Skills are dependencies of that role, not a direct bootstrap target.

```bash
# OpenCode bootstrap
ansible-playbook ansible/bootstrap.yml -t opencode

# zsh bootstrap with sudo/become prompt if needed
ansible-playbook -K ansible/bootstrap.yml -t zsh
```

`bootstrap.yml` does not currently use Ansible's `never` opt-in tag.

### Testing

After changing any Ansible file, lint the full Ansible surface.

```bash
uvx ansible-lint ansible
```

After editing Markdown files, run markdown lint.

```bash
npx markdownlint-cli2 "**/*.md" "#**/node_modules/**"
```

For container checks, build containers and open distro shells.

```bash
docker compose up --build -d
docker compose exec debian bash
docker compose exec redhat bash
```
