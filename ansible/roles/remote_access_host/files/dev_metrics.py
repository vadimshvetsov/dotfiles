#!/usr/bin/env python3
"""Count-only local Herdr/filesystem snapshot; never export terminal content."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def inventory_count(binary, group, home):
    env = {**os.environ, 'HOME': home, 'XDG_CONFIG_HOME': home + '/.config',
           'HERDR_SOCKET_PATH': home + '/.config/herdr/herdr.sock'}
    try:
        run = subprocess.run([binary, group, 'list'], env=env, stdin=subprocess.DEVNULL,
                             stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
                             text=True, timeout=5, check=True)
        rows = json.loads(run.stdout)['result'][{'workspace': 'workspaces', 'agent': 'agents'}[group]]
        if not isinstance(rows, list):
            return None
        return len(rows)
    except (OSError, subprocess.SubprocessError, ValueError, KeyError, TypeError):
        return None


def snapshot(binary, disk, home):
    usage = shutil.disk_usage(disk)
    return {'disk_free_bytes': usage.free, 'disk_total_bytes': usage.total,
            'spaces': inventory_count(binary, 'workspace', home),
            'agents': inventory_count(binary, 'agent', home),
            'sampled_at': datetime.now(timezone.utc).isoformat()}


def write_snapshot(destination, value):
    path = Path(destination)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode='w', dir=path.parent, delete=False) as file:
            temporary = file.name
            json.dump(value, file, allow_nan=False)
            file.write('\n')
        os.chmod(temporary, 0o640)
        os.replace(temporary, path)
    finally:
        if temporary and os.path.exists(temporary):
            os.unlink(temporary)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    for name in ['herdr', 'home', 'disk', 'output']:
        parser.add_argument('--' + name, required=True)
    args = parser.parse_args()
    write_snapshot(args.output, snapshot(args.herdr, args.disk, args.home))
