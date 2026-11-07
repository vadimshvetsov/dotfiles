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
clipboard support for SSH/Herdr sessions without a display.

Use `-K` only when a run reaches privileged tasks and needs a sudo password. `-K` asks for the sudo/become password. It does not force every task to use sudo.

Run a tagged bootstrap when needed. OpenCode is included in the default CLI bootstrap. Use `-t opencode` to run only
OpenCode and its dependencies. The OpenCode role installs its selected skills
as part of its configuration.

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
  .config/zsh/               -> ~/.config/zsh/      (individual files)
  .config/ghostty/           -> ~/.config/ghostty
  .config/herdr/config.toml  -> ~/.config/herdr/config.toml
  .config/nvim/              -> ~/.config/nvim
  .config/opencode/          -> ~/.config/opencode      (individual entries)
```

Add a new dotfile by putting it at its mirrored path under `home/`, then pointing a role's `*_source_dir` at it.

`agents/` sits outside `home/` because nothing links it into the home directory. It holds per-agent `opencode.yml` and `prompt.md` sources.

Machine-local files stay out of the repo: `~/.zprofile`, `~/.zshenv`, `~/.work_zshrc`, and `~/.claude/rules/`.

## Zsh

Install only the shell and its configuration on macOS (Homebrew) or
Ubuntu/Debian (APT):

```sh
ansible-playbook -K ansible/bootstrap.yml -t zsh
```

Run as the account being configured. On Linux, an administrator can instead
run the local playbook as root with `-e zsh_user=<account>`; configuration and
plugins are then created as that account, not in root's home. The Linux role also installs the Ghostty `xterm-ghostty` terminfo entry in
`/etc/terminfo`, so SSH input redraws correctly without installing the GUI or
overriding `TERM`. The role registers
the installed shell in `/etc/shells` and sets the target account's login shell.
Use `-e zsh_manage_login_shell=false` to keep the existing login shell.

`~/.zshrc` is a small entry point; the shared configuration lives in
`~/.config/zsh/`. Only Homebrew initialization is macOS-specific (`macos.zsh`).
Aliases, history, completion, Dracula, autosuggestions and syntax highlighting
are shared. Existing regular configuration files are preserved once as
`*.pre-dotfiles` before linking; an old `~/.zshrc_aliases` symlink is removed.

- Configuration: `~/.config/zsh/`.
- Private overrides: `~/.config/zsh/local.zsh` (never tracked or overwritten).
- Plugin repositories: `~/.local/share/zsh/zplug/`.
- Plugin cache: `~/.cache/zsh/zplug/`.
- History: `~/.local/state/zsh/history`; legacy `~/.zsh_history` is copied only
  when the new history does not exist. The original is retained.

Zplug and plugin versions are pinned in `ansible/roles/zsh/defaults/main.yml`;
Ansible renders `plugins.zsh` from these declarations. Shell startup never
installs or updates plugins. Update pins deliberately and rerun the Zsh tag.
The layout uses the standard XDG directories; keep these defaults when running
the role. The shell also honors XDG variables already set by the environment.

Existing `~/.work_zshrc` and `~/.home_zshrc` are still loaded before `local.zsh`.
Machine-local `.zprofile` and `.zshenv` are left untouched. NVM is optional and
lazy-loaded: an existing `~/.nvm` installation is supported, and new installations
can use `~/.config/nvm`. Common numeric default versions are resolved without
loading NVM on every shell start. This role does not install Node or NVM.

Config smoke tests run locally on either OS with Python 3 and Zsh, without
changing the live home, installing packages or downloading plugins:

```sh
python3 -m unittest discover -s tests -v
uvx ansible-lint ansible
```

## Herdr

```sh
ansible-playbook ansible/bootstrap.yml -t herdr
```

macOS uses Homebrew. Ubuntu/Debian installs the official pinned release to
`~/.local/bin/herdr`, verifying its SHA-256 before installation. Linux x86_64 and
aarch64 are supported. Release pins and checksums live in the role defaults.
The role links `~/.config/herdr/config.toml`, preserves an existing regular file
as `config.toml.pre-dotfiles`, and runs `herdr config check`.
It does not start a daemon or configure web access.

Run as the owner on either OS. Linux administrators running the local playbook
as root must set `-e dotfiles_user=<account>`; the role resolves that account's
home and creates user files as that account. This shared account resolution is
provided by `user_context`. Tests may override `dotfiles_home` for an isolated
home directory without changing the real account.

## OpenCode

The role installs OpenCode, Node.js/npx for MCP servers, and its skill catalog:

```sh
ansible-playbook ansible/bootstrap.yml -t opencode
```

On Ubuntu/Debian, the official pinned archive is checked against SHA-256 and the
executable is linked into `~/.local/bin`. macOS uses Homebrew. The shared
`nodejs` role installs a pinned, checksum-verified official Node.js archive for
Linux/macOS x64/arm64 into `~/.local/share/nodejs` and links `node`, `npm` and
`npx` into `~/.local/bin`. It installs no global npm packages and leaves existing
NVM installations intact. NVM may still select a different Node version in your
shell; OpenCode launched from a clean setup can use the managed Node for MCP servers.

Ansible checks out pinned skill source commits once per repository under
`~/.local/share/opencode-skills/sources` and links selected folders into
`~/.config/opencode/skills`. It does not run a skills package manager or populate
`~/.agents/skills`. Add an upstream source and its selected path to
`ansible/roles/skills/defaults/main.yml`; custom skills can live under
`home/.config/opencode/skills` and be listed in `skills_local_items`.

The legacy Next.js skills are kept at their last upstream revision before
removal. The existing `opencode-expert` skill is vendored because its Smithery
source is no longer available.

OpenCode's configuration root is a real directory with individual links for
managed files, agents, commands, themes and plugins. This keeps downloaded
skills and plugin runtime files outside the dotfiles checkout. An unmanaged real
configuration directory is preserved once as `~/.config/opencode.pre-dotfiles`;
an old root symlink is replaced without deleting its target. The role refuses
to overwrite a real configuration when its backup already exists.

The role checks both the executable and resolved configuration without sending
a model request. OpenCode automatic updates are disabled: update the release
pins and rerun Ansible. User authentication stays outside the repository.

For ChatGPT Pro, connect OpenAI using the ChatGPT subscription sign-in option;
do not enter an API key. Browser authorization is an interactive account step,
not part of bootstrap. See the [provider documentation](https://docs.opencode.ai/docs/providers/).

Agent instructions live in `home/.config/opencode/agents`. In each agent's
frontmatter, use `permission.skill` (singular) with `"*": deny` first, then explicit
allowed skills. Denied skills are hidden from that agent's available-skill list.
Skills are loaded on demand; their full instructions are not added to every
prompt. Boba Fett has the development skills, IG-88 has agent/tooling skills,
and the other agents have none. Keep the generator sources in
`agents/<agent>/opencode.yml` synchronized with the deployed Markdown frontmatter.
See [OpenCode skill permissions](https://docs.opencode.ai/docs/skills/#override-per-agent).

### Add a skill while working remotely

From a Herdr/OpenCode session, give IG-88 the discovered installer command as a
source reference and name the intended agent. For example:

> Add the skill from `npx skills add owner/repo --skill skill-name` for Boba Fett.
> Manage it in dotfiles and Ansible, apply it, verify it, and keep other agents denied.

The agent adds the pinned source and selected skill to the Ansible catalog,
grants it to the named agent, and reapplies the OpenCode tag. A new machine gets
the same installation from bootstrap. Running the original installer directly
would bypass this reproducible setup. The workflow is recorded in `AGENTS.md`.

## Paired remote agent access

`ansible/remote_access.yml` installs only Herdr, OpenCode and Collie. It skips
OpenCode's skills dependency and global config link, preserves existing OpenCode
configuration, and installs Herdr's OpenCode integration. Linux binaries and all
Collie binaries use pinned release checksums. macOS uses the existing Homebrew
roles for Herdr/OpenCode and launchd for local server services.

Supply `remote_access_instances`, each with `name`, `port`, exact HTTPS `origin`
and `public` (default false). Public instances also require Cloudflare Access
`access_team` and `access_aud`; their bridge validates the signed JWT in addition
to mandatory device pairing. Separate instances use the same Herdr socket and
independent pairing/state directories. Telemetry and automatic Tailscale Serve
publication are disabled. No application credentials belong in these variables.

On Ubuntu, run `ansible/remote_access_host.yml` as an administrator first. Set
`remote_access_host_user`, `remote_access_host_bind`,
`remote_access_host_ingress_sources` and `remote_access_host_instances`. This
installs nginx without recommended packages, limits its local ingress to the
specified proxy sources, and enables user lingering. The owner needs no sudo.
Then run the user playbook from the target account's dotfiles checkout. Neither
playbook runs zsh or the full bootstrap. Check mode validates configuration;
binary extraction and live service changes wait for the actual run.

Pair each installed PWA/browser separately using
`COLLIE_INSTANCE=<name> collie pair`. Inspect or revoke credentials with
`COLLIE_INSTANCE=<name> collie devices list` and
`COLLIE_INSTANCE=<name> collie devices revoke <label>`. Named configurations live
under `~/.config/herdr/plugins/config/herdr.collie-<name>`; state is owner-only
under `~/.local/state/valarmorghulis/<name>`. Use the same Unix account and default
Herdr session from SSH and web. A server restart ends live pane processes;
disconnecting a client does not. Reapplying the profile never restarts Herdr.

## CLI role integration test

The integration check installs Herdr, OpenCode and dependencies in a disposable
home, verifies preservation of existing configs, and requires `changed=0` on a
second run. It needs network access, Git and Ansible, and runs as a regular user.
On macOS, Herdr and OpenCode must already be installed: the temporary home does
not sandbox Homebrew package changes. It does not authenticate or call models.

```sh
python3 tests/check_cli_roles.py
# Or use an isolated current Ansible controller:
python3 tests/check_cli_roles.py --runner 'uvx --from ansible-core ansible-playbook'
```
