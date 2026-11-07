# AGENTS.md

This repo manages cross-platform dotfiles and tooling with Ansible.

## Layout

`home/` mirrors the home directory. A file's path under `home/` is the path Ansible links it to under `$HOME`. For example `home/.config/nvim` links to `~/.config/nvim`, and `home/.zshrc` links to `~/.zshrc`.

Put a new dotfile at its mirrored path under `home/`, then point the owning role's `*_source_dir` at it. Do not invent a flat directory next to `home/`.

`home/.claude/CLAUDE.md` is a symlink to `../AGENTS.md`, so global AI instructions live in one file.

`agents/` sits outside `home/` because nothing links it into the home directory.

Machine-local files are deliberately not tracked: `~/.zprofile`, `~/.zshenv`, `~/.work_zshrc`, and `~/.claude/rules/`. Do not add them. This repo is public.

## Common commands

### Ansible setup

```bash
ansible-galaxy collection install -r requirements.yml
ansible-playbook -K ansible/bootstrap.yml
```

`ansible/bootstrap.yml` contains CLI tools only. GUI applications, desktop fonts
and X11 clipboard integration belong in the separate optional playbook:

```bash
ansible-playbook -K ansible/gui_bootstrap.yml
```

Keep GUI dependencies disabled in the CLI bootstrap, including indirect role
dependencies. Optional desktop providers can stay in their owning CLI role when
disabled by default and explicitly enabled by the GUI profile. LazyVim owns
`lazyvim_install_xclip` (default `false`); the GUI playbook reuses its clipboard
tasks without running the full editor role.

Use `-K` only if a run reaches privileged tasks and needs a sudo password. `-K` asks for the sudo/become password. It does not force every task to use sudo. Do not configure `ansible.cfg` to globally prompt for a become password.

Run non-privileged tags without `-K`. Add `-K` for tagged runs that hit privileged tasks, such as shell changes or Linux package installs.

OpenCode is included in the default CLI bootstrap. Use `-t opencode` to run only
OpenCode and its dependencies. Skills are dependencies of that role, not a direct
bootstrap target.

```bash
# Run only OpenCode and its dependencies
ansible-playbook ansible/bootstrap.yml -t opencode

# zsh bootstrap with sudo/become prompt if needed
ansible-playbook -K ansible/bootstrap.yml -t zsh
```

### Testing

After changing any Ansible file, lint the full Ansible surface.

```bash
uvx ansible-lint ansible
```

After editing Markdown files, run markdown lint.

```bash
npx markdownlint-cli2
```

For container checks, build containers and open distro shells.

```bash
docker compose up --build -d
docker compose exec debian bash
docker compose exec redhat bash
```
