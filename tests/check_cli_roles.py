"""Install Herdr/OpenCode in a disposable HOME and require an unchanged rerun.

Usage: python3 tests/check_cli_roles.py --runner 'uvx --from ansible-core ansible-playbook'
Requires network access and Git. macOS packages must already be installed.
"""
import argparse
import json
import os
from pathlib import Path
import platform
import re
import shlex
import shutil
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runner", default="ansible-playbook")
    args = parser.parse_args()
    if os.geteuid() == 0:
        parser.error("Run as a regular user, not root")
    if platform.system() == "Darwin":
        for app in ("herdr", "opencode"):
            if not shutil.which(app):
                parser.error(f"Install {app} before the macOS test; it does not sandbox Homebrew")
    repo = Path(__file__).resolve().parents[1]
    with tempfile.TemporaryDirectory(prefix="dotfiles-cli-test-") as root:
        home = Path(root)
        config = home / ".config"
        (config / "herdr").mkdir(parents=True)
        (config / "herdr/config.toml").write_text("# original Herdr config\n")
        (config / "opencode").mkdir()
        (config / "opencode/local.txt").write_text("preserve this file\n")
        command = shlex.split(args.runner) + [
            "ansible/bootstrap.yml", "-t", "herdr,opencode", "-e",
            json.dumps({"dotfiles_home": root, "dotfiles_repo_dir": str(repo)}),
        ]
        for iteration in (1, 2):
            print(f"CLI roles pass {iteration}: {home}", flush=True)
            result = subprocess.run(command, cwd=repo, text=True,
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                    timeout=900)
            if result.returncode:
                raise RuntimeError(result.stdout[-15000:])
            recap = re.findall(r"changed=(\d+).*unreachable=(\d+).*failed=(\d+)",
                               result.stdout)
            if not recap or any(int(n) for n in recap[-1][1:]):
                raise RuntimeError(result.stdout[-5000:])
            if iteration == 2 and int(recap[-1][0]):
                raise AssertionError("Second pass changed state:\n" + result.stdout[-8000:])
            print("changed={}, unreachable={}, failed={}".format(*recap[-1]), flush=True)
        assert (config / "herdr/config.toml.pre-dotfiles").read_text() == "# original Herdr config\n"
        assert (config / "opencode.pre-dotfiles/local.txt").read_text() == "preserve this file\n"
        assert (config / "herdr/config.toml").is_symlink()
        assert (config / "opencode").is_dir() and not (config / "opencode").is_symlink()
        assert (config / "opencode/opencode.json").is_symlink()
        installed_skills = {manifest.parent.name for manifest in (config / "opencode/skills").glob("*/SKILL.md")}
        assert installed_skills
        assert not (home / ".agents/skills").exists()
        executable = (shutil.which("opencode") if platform.system() == "Darwin"
                      else str(home / ".local/bin/opencode"))
        env = dict(os.environ, HOME=root, XDG_CONFIG_HOME=str(config),
                   XDG_DATA_HOME=str(home / ".local/share"),
                   XDG_CACHE_HOME=str(home / ".cache"),
                   XDG_STATE_HOME=str(home / ".local/state"),
                   PATH=str(home / ".local/bin") + os.pathsep + os.environ["PATH"])
        for agent in ("boba-fett", "ig-88", "jabba-the-hutt", "dengar", "zuckuss", "4-lom"):
            result = subprocess.run([executable, "debug", "agent", agent], env=env,
                                    cwd=home, capture_output=True, text=True,
                                    check=True, timeout=60)
            profile = json.loads(result.stdout)
            assert not any(rule["permission"] == "skills" for rule in profile["permission"])
            rules = [rule for rule in profile["permission"] if rule["permission"] == "skill"]
            wildcard = max(i for i, rule in enumerate(rules) if rule["pattern"] == "*")
            assert rules[wildcard]["action"] == "deny", agent
            actual = {rule["pattern"] for rule in rules[wildcard + 1:] if rule["action"] == "allow"}
            assert actual <= installed_skills, (agent, actual - installed_skills)
        print("Installation, preservation, idempotence and resolved agent permissions passed.")


if __name__ == "__main__":
    main()
