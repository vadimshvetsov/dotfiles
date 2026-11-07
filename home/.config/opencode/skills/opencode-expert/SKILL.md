---
name: opencode-expert
description: Configure and troubleshoot OpenCode 2 CLI, agents, skills, MCP, plugins, permissions, and authentication.
---

# OpenCode 2

Read the repository AGENTS.md first. Verify commands against the installed
`opencode --help` and relevant subcommand help. Use Context7 and current official
V2 documentation; V1 APIs and flags are not interchangeable with V2.

## Commands

- `opencode`: start the terminal UI in the current project.
- `opencode --standalone`: use a private server instead of a shared background service.
- `opencode run --agent <id> --model <provider/model> <message>`: noninteractive request.
- `opencode debug config --standalone`: inspect configuration sources without a model request.
- `opencode debug agents --standalone`: inspect resolved agents and ordered permissions.
- `opencode debug paths`: inspect config, data, cache and state locations without starting a server.
- `opencode auth list --standalone`: inspect connected integrations.
- `opencode auth login`: connect through the supported interactive account flow.
- `opencode models`: list the model catalog.
- `opencode plugin --help`: inspect V2 plugin management commands.
- `opencode service status`: inspect the shared background service.

For the TUI, select an agent in the UI or set project `default_agent`.
The V2 TUI has no global `--agent` flag; `opencode run` has one.

## Configuration

Global server configuration is `~/.config/opencode/opencode.json`.
Project configuration is `opencode.json` or `.opencode/opencode.json`.
Global client settings are `~/.config/opencode/cli.json`. Put the theme and TUI
plugins there. V1 `tui.json(c)` is retained only for migration and rollback.

Native V2 uses `agents`, `system`, `disabled`, and an ordered `permissions`
array with `action`, `resource`, `effect`. Actions include `shell`, `subagent`,
`edit`, and `skill`. The last matching permission wins. Supported V1 agent
frontmatter and permission maps remain compatible through in-memory migration;
do not mix V1 and V2 formats inside an individual agent definition.

## Skills and instructions

Skills live at `~/.config/opencode/skills/<id>/SKILL.md` and are loaded on demand.
Keep supporting scripts and references beside the manifest. Denied skills are
hidden from that agent. Keep agent prompts short and repository-specific
installation procedures in the repository AGENTS.md.

Follow dotfiles AGENTS.md for the Ansible-managed skill catalog. A discovered
`npx skills add` command identifies a source; permanent setup goes through
Ansible. Preserve credentials and running Herdr/Collie sessions.

## Plugins and integrations

V2 plugin implementations require an `id` and `setup(ctx)` definition.
Configured local plugin paths point to directories. A V1 plugin function does
not become V2-compatible by renaming its file. Server and TUI plugins have
different contexts. Use the official Herdr integration appropriate to V2.
The V2 server API differs from V1; client integrations must support it.

OAuth credentials stay outside Git. Never export credentials to logs or docs,
copy refresh tokens from another machine, or insert an API key for a user who
asked to use a ChatGPT subscription. Installation checks do not need a model
request or an account login.

## References

- [Configuration](https://opencode.ai/docs/config/)
- [V1 migration](https://opencode.ai/docs/migrate-v1/)
- [Agents](https://opencode.ai/docs/agents/)
- [Skills](https://opencode.ai/docs/skills/)
- [CLI settings](https://opencode.ai/docs/cli/config/)
- [Plugin migration](https://opencode.ai/docs/build/plugins/migrate-v1/)
