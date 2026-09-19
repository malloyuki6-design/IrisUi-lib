# Changelog

## 2.8.0

- Fixed section chevron runtime error caused by assigning Image on a Frame icon container.
- Added animated tab page transitions and window entrance animation.
- Increased window and component corner radii.
- Prioritized the Footagesus icon runtime for explicit lucide, geist, and craft icon namespaces.
- Added ClearBackgroundImage compatibility alias.
- Kept source and distribution builds synchronized.


- Reworked the window layout into a compact WindUI-inspired navigation model.
- Added grouped navigation with `Window:Section(...):Tab(...)`.
- Added Footagesus Icons runtime integration with Lucide, Geist, and Craft namespaces.
- Removed rasterized UI layers from the main window path to preserve text sharpness.
- Added Roblox texture background controls.
- Added `SetBackgroundImage`, `SetBackgroundTint`, and `ClearBackground`.
- Tightened tab, section, and row spacing to reduce visual density and overlap.
- Added locked-tab handling and tab selection helpers.


## 2.5.2

- Fixed overlapping wrapped text by removing competing automatic Y sizing from explicit-height content rows.
- Content rows now clip accidental overflow and respect measured minimum heights.
- Fixed `CreateInput` focus-loss callback state handling.
- Added a real image fallback for unresolved or failed icon assets instead of box glyphs.
- Expanded common Lucide-style icon aliases.
- Switched the public example tabs to canonical namespaced icon identifiers.
- Added layout and icon contract validation.
- Removed the stale bundled source backup from the release.
- Removed unused `WindowOrder` state.
- Rebuilt the distribution file.
