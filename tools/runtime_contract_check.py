from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE = (ROOT / "src" / "IrisHub.luau").read_text()
EXAMPLE = (ROOT / "examples" / "GitHubLoadstringExample.luau").read_text()

assert "CanvasGroup" not in SOURCE
assert "CreateShadow(main" not in SOURCE
assert "SecondaryActivated" not in SOURCE
assert "TabButton = button" in SOURCE
assert "function methods:Button" in SOURCE
assert "self.TabButton.BackgroundColor3" in SOURCE
assert "component.Data.SectionOwner = self.ActiveSection" in SOURCE
assert "function methods:Refresh()" in SOURCE
assert "function IrisHub:GetIconCatalog()" in SOURCE
assert "Window:SelectTab(\"Features\")" in EXAMPLE
assert not re.search(r"\bDashboard\.Button\s*=", EXAMPLE)

create_window = re.search(r'function IrisHub\.Create\(options\).*?return library\nend', SOURCE, re.S)
assert create_window and "library:CreateWindow(options or {})" in create_window.group(0)

print("IrisHub runtime contract regression checks passed")
