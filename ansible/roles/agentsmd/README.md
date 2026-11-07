# Global agent instructions

This role supports macOS and Linux. It installs no packages and needs no sudo;
run it as the user whose home directory should receive the instructions.

It links `~/AGENTS.md` and `~/.claude/CLAUDE.md` to the sources under `home/`.
The old `~/CLAUDE.md` entry is removed only when it is a symlink. A regular file
or directory at that path is preserved.
