# Changelog

## 2.0.1

- Fixed `IrisHub.Create()` not creating the default window expected by the documented API.
- Fixed `Window:Minimize()` referencing a nonexistent `Content` field.
- Improved `IrisHub:Destroy()` cleanup for multiple windows and notifications.
- Updated examples and API documentation to match the runtime contract.

## 2.0.0 — 2026-09-19

### UI

- Refined window chrome with maximize control, accent indicator and resize grip
- Added runtime UIScale support
- Added min/max window constraints
- Added optional visibility toggle key
- Added explicit focus behavior
- Improved active tab indicator
- Added polished progress, status, badge, key/value, alert and code components

### API

- Added `SetSize`, `SetPosition`, `Focus` and component callback/title/description helpers
- Added section `Expand` and `Collapse`
- Added dropdown `FindOption` and `Clear`
- Added multi-dropdown `GetSelected`, `Select` and `Deselect`
- Added image dropdown `SetOptions`
- Added `SetRange` to progress components
- Added `SetColors` to badges
- Added `SetKey` to key/value components
- Added `SetLanguage` and `Copy` to code blocks

### Reliability

- Dynamic option-list connections are now isolated and cleaned before rerenders
- Destroyed windows are removed from the library registry
- Primary button interactions now use Roblox's cross-platform `Activated` event
- Secondary context activation now uses `SecondaryActivated`
- `Component:Update` now maps common presentation and state properties to live component methods
- Build script corrected and distribution regenerated from source

## 1.0.0

Initial open-source release.
