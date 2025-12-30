import re
import unittest

class TestMikroTikScript(unittest.TestCase):
    def setUp(self):
        with open('resolve_ip_address_list.rsc', 'r') as f:
            self.content = f.read()

    def test_syntax_balance(self):
        """Check for balanced braces, brackets, and quotes."""
        for opening, closing in [('{', '}'), ('[', ']'), ('(', ')')]:
            open_count = self.content.count(opening)
            close_count = self.content.count(closing)
            self.assertEqual(open_count, close_count, f"Mismatched {opening}{closing}")

    def test_os_detection_logic(self):
        """Verify the OS version detection logic."""
        self.assertIn(':local isV7 false', self.content)
        self.assertIn('[:pick $osVersion 0 1] = "7"', self.content)

    def test_domain_lists_not_empty(self):
        """Ensure critical address lists are present."""
        lists = ["chatgpt-allowed", "auth-providers-allowed", "google-allowed", "wechat-allowed"]
        for l in lists:
            self.assertIn(f'"{l}"', self.content)

    def test_no_trailing_spaces_in_domains(self):
        """Ensure no trailing spaces in domains which could cause resolution failure."""
        domains = re.findall(r'"([^"]+)"', self.content)
        for d in domains:
            if "." in d: # Simple heuristic to check if it's a domain
                self.assertEqual(d, d.strip(), f"Domain '{d}' has trailing/leading spaces")

if __name__ == '__main__':
    unittest.main()