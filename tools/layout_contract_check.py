from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE = (ROOT / 'src' / 'IrisHub.luau').read_text(encoding='utf-8')
EXAMPLE = (ROOT / 'examples' / 'GitHubLoadstringExample.luau').read_text(encoding='utf-8')

assert 'ClipsDescendants = true' in SOURCE
assert 'AutomaticSize = Enum.AutomaticSize.Y' not in SOURCE
assert 'function comp:Reflow()' in SOURCE
assert 'comp.Data.Value = box.Text' in SOURCE
assert 'self.TabOrder = {}' not in SOURCE
assert 'TabOrder = {}' in SOURCE
assert 'table.insert(self.TabOrder, proxy)' in SOURCE
assert 'local fallbackAsset = IconRegistry.BuiltinAssets.helpcircle or IconRegistry.BuiltinAssets.info' in SOURCE
assert 'IconRegistry.Glyphs' not in SOURCE or 'TextLabel' in SOURCE
for expected in ['lucide:layout-dashboard', 'lucide:sparkles', 'lucide:palette', 'lucide:settings', 'lucide:info']:
    assert expected in EXAMPLE, f'missing canonical example icon: {expected}'

# Guard against hard-coded tiny rows that can under-size wrapped text.
for pattern in [
    r'local rowHeight = opts\.Height or math\.max\(58, 37 \+ descriptionHeight\)',
    r'local height = opts\.Height or math\.max\(50, 31 \+ measured\)',
    r'local height = opts\.Height or math\.max\(74, measured \+ 48\)',
]:
    assert not re.search(pattern, SOURCE)

print('IrisHub layout/icon contract checks passed')
