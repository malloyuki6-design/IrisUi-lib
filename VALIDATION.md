# IrisHub v2.3.0 Validation

Static validation targets the runtime problems observed in Roblox screenshots.

- Tab method collision: fixed by storing the internal tab button in `TabButton`.
- Blurry CanvasGroup rendering: eliminated from primary UI, notifications, and key system.
- Stuck detached shadow: eliminated.
- Empty-tab section visibility: section children are explicitly owned and refreshed when tabs activate.
- Icon resolution: common bundled icon fallbacks are available, with provider registration overrides.
- Secondary mouse interaction: uses `MouseButton2Click`.
- `dist/IrisHub.luau`: rebuilt from `src/IrisHub.luau`.

A real Roblox Studio/client play-test remains necessary for final engine/runtime verification.
