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

## GitHub CLI

GitHub CLI is included in the default CLI bootstrap on macOS and Ubuntu/Debian.
Install or update only this tool without sudo:

```sh
ansible-playbook ansible/bootstrap.yml -t gh
```

The `github_cli` role (`gh` and `github_cli` tags) resolves the latest stable
official release on each run, verifies its SHA-256 digest and installs a
user-local binary at `~/.local/bin/gh` on x64/arm64. Set `github_cli_version` to
an explicit release for rollback. Existing Homebrew/system packages are left
installed; keep `~/.local/bin` first in `PATH` to use the managed version.

The role does not sign in, modify Git identity or credential helpers, or copy
tokens. Existing GitHub CLI credentials remain untouched. Authorize each machine
separately when GitHub access is needed:

```sh
gh auth login --hostname github.com --git-protocol https --web
gh auth status --hostname github.com
```

## Herdr

```sh
ansible-playbook ansible/bootstrap.yml -t herdr
```

Ansible resolves the latest stable GitHub release on every run, on macOS and
Ubuntu/Debian x64/arm64. It verifies the release asset's published SHA-256 digest
and installs `~/.local/bin/herdr`. The default is `herdr_version: latest`;
a specific version can be supplied explicitly for a controlled rollback.
The role links `~/.config/herdr/config.toml`, preserves an existing regular file
as `config.toml.pre-dotfiles`, and runs `herdr config check`.
It does not restart a daemon or configure web access.

Run as the owner on either OS. Linux administrators running the local playbook
as root must set `-e dotfiles_user=<account>`; the role resolves that account's
home and creates user files as that account. This shared account resolution is
provided by `user_context`. Tests may override `dotfiles_home` for an isolated
home directory without changing the real account.

## OpenCode

New sessions default to Jabba the Hutt (`jabba-the-hutt`). This repository's
project configuration overrides that default with IG-88 (`ig-88`) for dotfiles
maintenance. Other projects can set their own `default_agent` explicitly.

The role installs OpenCode, Node.js/npx for MCP servers, and its skill catalog:

```sh
ansible-playbook ansible/bootstrap.yml -t opencode
```

On both macOS and Linux, Ansible resolves the current stable `@opencode/cli`
release from npm on every run, verifies the native archive using the package's
SHA-512 integrity, and links the executable into `~/.local/bin`. The default is
`opencode_version: latest`; a specific V2 version can be supplied for rollback.
The shared
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
a model request. OpenCode background updates are disabled: Ansible owns updates and checks
for the latest stable release each time the role is applied. User authentication stays outside the repository.

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

Start `opencode` from `~/dev/dotfiles`. The project-level `opencode.json` selects
IG-88 automatically; the V2 TUI does not use a global `--agent` flag.
IG-88 uses mode `all`, so it also remains callable as a subagent. The installation
workflow lives in the repository `AGENTS.md`, keeping the agent prompt small.

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
configuration, and installs Herdr's OpenCode integration. Herdr and OpenCode resolve the latest stable vendor release on every run and
verify its published integrity. Collie remains checksum-pinned. All platforms
use user-local binaries; macOS uses launchd for local server services.

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

## Global instructions and editor tools

```sh
ansible-playbook ansible/bootstrap.yml -t agentsmd
ansible-playbook ansible/bootstrap.yml -t neovim,lazygit
ansible-playbook -K ansible/bootstrap.yml -t lazyvim
```

`agentsmd` links the shared `home/AGENTS.md` into the home directory, Claude's
configuration and OpenCode's global configuration. Existing regular files are
preserved; a legacy home `CLAUDE.md` is removed only if it is a symlink.

Neovim and Lazygit use checksum-pinned official archives on Linux/macOS x64/arm64
and user-local executable links. Neovim is not compiled on the target. Lazygit
does not install an editor as a dependency. The editor role includes Neovim,
Node.js, command-line search tools, tree-sitter CLI and a C compiler. Ubuntu uses
`fd-find` with a user-local `fd` link; macOS uses Homebrew for helper tools.
Linux administrators can run the local playbook as root with
`-e dotfiles_user=<owner>`; user files and plugin builds still run as that owner.

LazyVim keeps static Lua links in `~/.config/nvim`; lock/extras JSON files are
seeded from dotfiles when their sources change. Ansible restores locked plugins
and installs configured syntax parsers before marking the bootstrap complete.
A second run skips that bootstrap while still checking initialization. The role
keeps the CLI clipboard profile and optional `lazyvim_install_xclip: false`.

OpenCode uses native V2 client settings in `~/.config/opencode/cli.json`, a
V2-compatible Herdr integration and the V2-compatible Neovim plugin revision.
Supported V1 agent definitions are normalized by V2; no model request is needed
for configuration validation. Only the OpenAI provider is enabled for this
ChatGPT subscription setup. Account identifiers and tokens stay outside Git.

## CLI role integration test

The integration check installs global instructions, Herdr, OpenCode and dependencies in a disposable
home, verifies preservation of existing configs, and requires `changed=0` on a
second run. It needs network access, Git and Ansible, and runs as a regular user.
The installer is user-local on both systems, so it also works on a Mac without
Homebrew Herdr/OpenCode installations. It does not authenticate or call models.

```sh
python3 tests/check_cli_roles.py
# Or use an isolated current Ansible controller:
python3 tests/check_cli_roles.py --runner 'uvx --from ansible-core ansible-playbook'
```
