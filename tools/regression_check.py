from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
source = (root / "src" / "IrisHub.luau").read_text()
dist = (root / "dist" / "IrisHub.luau").read_text()
example = (root / "examples" / "GitHubLoadstringExample.luau").read_text()

checks = {
    "source_dist_sync": source == dist,
    "version_2_8": 'IrisHub.Version = "2.8.0"' in source,
    "context_uses_button": "hitTarget.Activated:Connect" in source,
    "context_no_frame_activated": "trigger.Activated:Connect" not in source,
    "context_no_frame_right_click": "trigger.MouseButton2Click" not in source,
    "icons_remote_icon2": "module.Icon2(name or value, provider or \"lucide\")" in source,
    "icons_array_result": "result[1]" in source and "result[2]" in source,
    "icons_no_remote_url_image": 'if value:match("^https?://") then' in source and 'return nil, nil, nil' in source,
    "rounded_window": "Corner(main, math.max(17, theme.Radius + 2))" in source,
    "rounded_rows": "Corner(row, math.max(12, theme.Radius))" in source,
    "section_no_frame_image": "chevron.Image = asset" not in source,
    "section_runtime_guard": "function methods:Section(opts) return self:CreateSection(opts) end" in source,
    "section_chevron_rotation": "SetIconRotation(chevron, expanded and 0 or -90, true)" in source,
    "window_animation": "PresentationScale" in source,
    "background_clear_alias": "function window:ClearBackgroundImage()" in source,
    "example_lucide": 'Icon = "lucide:layout-grid"' in example,
    "example_loadstring": "game:HttpGet" in example,
    "no_comments": "--" not in "\n".join(source.splitlines() + example.splitlines()),
}
failed = [name for name, ok in checks.items() if not ok]
for name, ok in checks.items():
    print(f"{name}: {'ok' if ok else 'FAIL'}")
if failed:
    print("FAILED:", ", ".join(failed))
    sys.exit(1)
print("IrisHub regression checks passed")
