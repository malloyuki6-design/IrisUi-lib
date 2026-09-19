# IrisHub 2.6.0 Validation

## Static checks

- Main library Luau syntax: passed
- GitHub example Luau syntax: passed
- Source to distribution synchronization: passed
- Forbidden `--` comment marker scan: passed
- Website JavaScript syntax: passed
- Runtime API regression checks: passed
- Layout and icon contract checks: passed
- Source and distribution SHA-256 match: passed
- ZIP integrity: passed after final packaging

## UI architecture checks

- Main window no longer uses `CanvasGroup` rasterization.
- Detached shadow rendering was removed from the main window.
- Sidebar navigation uses grouped sections and compact tab rows.
- Tab buttons and section headers use independent text/icon children to prevent overlap.
- Content rows clip accidental overflow and use measured heights where wrapped text is expected.
- Popups remain on the dedicated popup layer when opened.
- Background textures are isolated behind the UI content and can be cleared without leaving a visual layer behind.

## Icon checks

- Local Roblox assets remain the first lookup path.
- Footagesus Icons is used as the runtime fallback for named Lucide, Geist and Craft icons when the execution environment supports HTTP and dynamic loading.
- Icon sprite metadata is applied when returned by the icon runtime.
- Unknown names resolve to a real built-in help icon rather than a box or text placeholder.

## API checks

- `Window:Section(...)` and grouped `:Tab(...)` navigation verified by static contract tests.
- `Window:SetBackgroundImage(...)`, `Window:SetBackgroundTint(...)`, `Window:ClearBackground()` and library background wrappers verified.
- Existing component factory methods remain present.
- Existing config, notification, tag, key-system and icon APIs remain present.

## Runtime limitation

A real Roblox Studio/client play-test is still required for final rendering, asset loading, input and executor-specific HTTP behavior. This environment cannot execute the library inside the Roblox engine.
