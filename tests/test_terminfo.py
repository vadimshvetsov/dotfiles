"""Check the terminal capabilities needed for ZLE redraw over Ghostty SSH."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import unittest

SOURCE = (Path(__file__).resolve().parents[1]
          / "ansible/roles/zsh/files/xterm-ghostty.terminfo")


@unittest.skipUnless(shutil.which("tic") and shutil.which("zsh"),
                     "Requires ncurses tic and Zsh")
class GhosttyTerminfoTest(unittest.TestCase):
    def test_ghostty_has_cursor_movement_and_line_erase(self):
        with tempfile.TemporaryDirectory(prefix="dotfiles-terminfo-") as root:
            subprocess.run(["tic", "-x", "-o", root, str(SOURCE)],
                           check=True, capture_output=True, text=True)
            env = dict(os.environ, TERM="xterm-ghostty", TERMINFO=root)
            result = subprocess.run(
                ["zsh", "-fc", 'zmodload zsh/terminfo && '
                 '[[ -n ${terminfo[cub1]} && -n ${terminfo[el]} ]]'],
                env=env, capture_output=True, text=True, timeout=10,
            )
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
