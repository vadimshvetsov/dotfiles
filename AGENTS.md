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

## Adding OpenCode skills

When the user supplies a command such as `npx skills add owner/repo --skill name`,
use it as a source locator. Persistent installation must go through dotfiles
Ansible, not an imperative package-manager command on the target machine.

1. Verify the upstream repository, actual `SKILL.md` name, supporting files and
   immutable commit. Reuse an existing pinned repository when possible.
2. Add the repository to `skills_repositories` and the selected skill/path to
   `skills_items` in `ansible/roles/skills/defaults/main.yml`. Locally maintained
   skills belong under `home/.config/opencode/skills` and `skills_local_items`.
3. Grant it only to the requested agent with `permission.skill` (singular).
   Keep `"*": deny` first and specific grants after it. Keep the deployed agent
   Markdown and its `agents/<name>/opencode.yml` source synchronized for this rule.
4. Lint, commit the change, and apply only `ansible/bootstrap.yml -t opencode`
   from the target's checkout as its owner. Verify the resolved agent permissions
   and skill discovery without sending a model request. Do not restart active
   Herdr/Collie services to install a skill.

Skills live in `~/.config/opencode/skills`; upstream checkouts live under
`~/.local/share/opencode-skills/sources`. The role does not populate global
`~/.agents/skills` or install skills for other coding tools. Permissions hide
unapproved skills from each OpenCode agent's available-skill list; this does not
require separate copies of a skill for every agent.
