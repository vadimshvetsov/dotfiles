"""Development counters never export agent content or turn failures into zero."""
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('dev_metrics', Path(__file__).resolve().parents[1] /
    'ansible/roles/remote_access_host/files/dev_metrics.py')
metrics = importlib.util.module_from_spec(spec)
spec.loader.exec_module(metrics)


class DevelopmentCollectorTests(unittest.TestCase):
    def test_counts_only_and_missing_server(self):
        payload = {'result': {'agents': [{'agent': 'opencode', 'text': 'private prompt'}]}}
        with patch.object(metrics.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, json.dumps(payload))):
            self.assertEqual(metrics.inventory_count('/bin/herdr', 'agent', '/home/owner'), 1)
        with patch.object(metrics.subprocess, 'run', side_effect=subprocess.CalledProcessError(1, ['herdr'])):
            self.assertIsNone(metrics.inventory_count('/bin/herdr', 'agent', '/home/owner'))

    def test_atomic_private_snapshot(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / 'metrics.json'
            output.write_text('previous')
            with patch.object(metrics.os, 'replace', side_effect=OSError('failed')):
                with self.assertRaises(OSError):
                    metrics.write_snapshot(output, {'spaces': 2})
            self.assertEqual(output.read_text(), 'previous')
            self.assertEqual(list(Path(directory).iterdir()), [output])
            metrics.write_snapshot(output, {'spaces': 2})
            self.assertEqual(json.loads(output.read_text()), {'spaces': 2})
            self.assertEqual(output.stat().st_mode & 0o777, 0o640)


if __name__ == '__main__':
    unittest.main()
