"""Config-only smoke tests; no packages, plugins or live home are modified."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SOURCES = Path(__file__).resolve().parents[1] / "home"
ZSH = shutil.which("zsh")


@unittest.skipUnless(ZSH, "Install zsh to run shell configuration tests")
class ZshConfigTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-zsh-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        shutil.copytree(SOURCES / ".config/zsh", self.home / ".config/zsh")
        shutil.copy(SOURCES / ".zshrc", self.home / ".zshrc")
        # The role renders this template and installs plugins; config tests use
        # the completion fallback instead, with no network access required.
        (self.home / ".config/zsh/plugins.zsh").unlink()
        (self.home / ".local/state/zsh").mkdir(parents=True)
        self.env = {
            key: value for key, value in os.environ.items()
            if not key.startswith("XDG_") and key not in {
                "HOME", "ZDOTDIR", "NVM_DIR", "HISTFILE", "PNPM_HOME",
                "ZPLUG_HOME", "ZPLUG_CACHE_DIR",
            }
        }
        self.env.update(HOME=str(self.home), TERM="xterm-256color")

    def shell(self, command):
        result = subprocess.run(
            [ZSH, "-ic", command], env=self.env, text=True,
            capture_output=True, timeout=15,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stderr, "")
        return result.stdout.strip()

    def nvm_fixture(self, selector="22", legacy=False):
        root = self.home / (".nvm" if legacy else ".config/nvm")
        (root / "alias").mkdir(parents=True)
        (root / "alias/default").write_text(selector + "\n")
        (root / "nvm.sh").write_text('nvm() { print -r -- "loaded:$*"; }\n')
        for version in ("v22.9.0", "v22.10.0", "v24.1.0"):
            (root / "versions/node" / version / "bin").mkdir(parents=True)
        return root

    def test_syntax(self):
        for file in (SOURCES / ".config/zsh").glob("*.zsh"):
            if file.name != "plugins.zsh":
                subprocess.run([ZSH, "-n", str(file)], check=True)
        subprocess.run([ZSH, "-n", str(SOURCES / ".zshrc")], check=True)

    def test_shared_config_without_optional_tools(self):
        self.assertEqual(self.shell('print -r -- "$HISTFILE"'),
                         str(self.home / ".local/state/zsh/history"))
        self.assertEqual(self.shell("print -r -- $aliases[h]"), "herdr")
        self.assertEqual(self.shell('print -r -- "$EDITOR"'), "nvim")
        self.assertEqual(self.shell('print -r -- "$path[1]"'),
                         str(self.home / ".local/bin"))
        self.assertEqual(self.shell('print -r -- "$options[sharehistory]"'), "on")

    def test_private_override(self):
        (self.home / ".config/zsh/local.zsh").write_text("export EDITOR=vi\n")
        self.assertEqual(self.shell('print -r -- "$EDITOR"'), "vi")

    def test_nvm_numeric_alias(self):
        root = self.nvm_fixture()
        self.assertEqual(self.shell('print -r -- "$path[1]"'),
                         str(root / "versions/node/v22.10.0/bin"))
        self.assertEqual(self.shell("nvm --version"), "loaded:--version")

    def test_nvm_legacy_home(self):
        root = self.nvm_fixture("22.9.0", legacy=True)
        self.assertEqual(self.shell('print -r -- "$path[1]"'),
                         str(root / "versions/node/v22.9.0/bin"))

    def test_nvm_alias_cycle_does_not_block_shell(self):
        root = self.nvm_fixture("loop")
        (root / "alias/loop").write_text("default\n")
        self.assertEqual(self.shell("print ready"), "ready")

    def test_nvm_latest_and_minor_selectors(self):
        root = self.nvm_fixture("node")
        self.assertEqual(self.shell('print -r -- "$path[1]"'),
                         str(root / "versions/node/v24.1.0/bin"))
        (root / "alias/default").write_text("22.9\n")
        self.assertEqual(self.shell('print -r -- "$path[1]"'),
                         str(root / "versions/node/v22.9.0/bin"))


if __name__ == "__main__":
    unittest.main()
