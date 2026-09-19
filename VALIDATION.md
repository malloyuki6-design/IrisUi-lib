# IrisHub 2.5.2 Validation

## Static checks

- Main library Luau syntax: passed
- Example Luau syntax: passed
- All Luau files syntax: passed
- Forbidden `--` comment marker scan: passed
- Source to distribution synchronization: passed
- Website JavaScript syntax: passed
- Runtime API regression checks: passed
- Layout contract checks: passed
- Icon fallback checks: passed
- ZIP integrity: pending final package

## Layout protections

- Removed automatic Y sizing from content rows that also use explicit measured heights.
- Wrapped text is measured with `TextService` and assigned an explicit height.
- Content rows clip overflow instead of allowing text to draw into neighboring rows.
- User-provided heights are treated as minimum heights when wrapped content requires more space.
- Window content is clamped to the available viewport for offset-based sizes.
- Popups are moved to a dedicated popup layer when opened, so row clipping cannot cut off dropdowns or menus.

## Icon protections

- Namespaced icon names are supported for the tracked Lucide, Geist, and Craft provider namespaces.
- Unknown or unresolved icons use a real built-in help icon instead of a square glyph placeholder.
- A delayed image-load check replaces a failed resolved asset with the built-in help icon.
- Roblox-hosted image assets remain the runtime source of truth.

## Runtime fixes included

- Fixed component callback state access in `CreateInput`.
- Fixed tab ordering registration.
- Fixed stale source backup files being shipped in the release.
- Removed unused `WindowOrder` state.
- Rebuilt `dist/IrisHub.luau` from the current source.

## External runtime limitation

A real Roblox Studio/client play-test is still required for final rendering and input verification. This environment cannot execute the library inside the Roblox engine.
