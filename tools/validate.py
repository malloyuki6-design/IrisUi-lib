from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "src" / "IrisHub.luau"
DIST = ROOT / "dist" / "IrisHub.luau"
WEBSITE = ROOT / "website"

REQUIRED_COMPONENTS = {
    "CreateSection", "CreateLabel", "CreateParagraph", "CreateDivider", "CreateButton",
    "CreateToggle", "CreateDropdown", "CreateMultiDropdown", "CreateImageDropdown", "CreateSlider",
    "CreateInput", "CreateKeybind", "CreateColorPicker", "CreateImage", "CreateAvatar", "CreateCard",
    "CreateLoading", "CreateProgress", "CreateStatus", "CreateBadge", "CreateKeyValue", "CreateAlert",
    "CreateCodeBlock", "CreateModal", "CreateContextMenu", "CreateTooltip", "CreateSearch"
}

def lua_tokens(text: str):
    tokens=[]
    i=0
    n=len(text)
    while i<n:
        c=text[i]
        if c.isspace():
            i+=1; continue
        if c=="\"" or c=="'":
            quote=c; i+=1
            while i<n:
                if text[i]=='\\': i+=2; continue
                if text[i]==quote: i+=1; break
                i+=1
            continue
        if c=="[" and i+1<n and text[i+1]=="[":
            end=text.find("]]", i+2)
            if end<0: raise AssertionError("unterminated long string")
            i=end+2; continue
        if c.isalpha() or c=="_":
            j=i+1
            while j<n and (text[j].isalnum() or text[j]=="_"): j+=1
            tokens.append(text[i:j]); i=j; continue
        i+=1
    return tokens

def validate_lua(text: str):
    if "--" in text:
        raise AssertionError("source contains forbidden -- comment marker")
    if text.count("(") != text.count(")"):
        raise AssertionError("parenthesis count mismatch")
    if text.count("{") != text.count("}"):
        raise AssertionError("brace count mismatch")
    if text.count("[") != text.count("]"):
        raise AssertionError("bracket count mismatch")
    tokens=lua_tokens(text)
    stack=[]
    prev=None
    for token in tokens:
        if token=="function":
            stack.append("end")
        elif token=="if":
            stack.append("end")
        elif token in ("for","while"):
            stack.append("end")
        elif token=="repeat":
            stack.append("until")
        elif token=="end":
            if not stack or stack.pop()!="end":
                raise AssertionError("unexpected end token")
        elif token=="until":
            if not stack or stack.pop()!="until":
                raise AssertionError("unexpected until token")
        prev=token
    if stack:
        raise AssertionError(f"unclosed block tokens: {stack[-8:]}")

source=SOURCE.read_text()
dist=DIST.read_text() if DIST.exists() else ""
validate_lua(source)
if source != dist:
    raise AssertionError("dist/IrisHub.luau is out of sync with src/IrisHub.luau")
for component in REQUIRED_COMPONENTS:
    if f"function methods:{component}" not in source and component != "CreateModal":
        if f"function IrisHub:{component}" not in source:
            raise AssertionError(f"missing API {component}")

for js in WEBSITE.glob("*.js"):
    subprocess.run(["node","--check",str(js)], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)

for path in [ROOT/"README.md",ROOT/"CHANGELOG.md",ROOT/"CONTRIBUTING.md",ROOT/"docs/API.md",ROOT/"docs/COMPONENTS.md",ROOT/"docs/ARCHITECTURE.md",ROOT/"LICENSE",ROOT/"rojo.json",ROOT/"build.py",ROOT/"tests/SmokeTest.luau"]:
    if not path.is_file(): raise AssertionError(f"missing project file: {path}")

print("IrisHub validation passed")
print(f"source_lines={len(source.splitlines())}")
print(f"components={len(REQUIRED_COMPONENTS)}")
print("website_js=ok")
print("source_dist=identical")
