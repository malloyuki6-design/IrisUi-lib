# Changelog

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
