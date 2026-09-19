from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "src" / "IrisHub.luau"
DIST = ROOT / "dist" / "IrisHub.luau"
DIST.parent.mkdir(parents=True, exist_ok=True)

if not SOURCE.is_file():
    raise FileNotFoundError(SOURCE)

shutil.copyfile(SOURCE, DIST)
print(f"Built {DIST}")
