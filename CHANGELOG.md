## v2.3.0

- Stability and rendering fixes.

## 2.2.2

- Added the missing ConfigPanel implementation and tab alias.
- Added provider documentation links for Panda Development and Luarmor.
- Improved provider-aware branding metadata.

## 2.2.1

- Fixed provider key-system connection cleanup.
- Added interactive notification cards and notification management APIs.
- Added ConfigPanel composite UI.
- Fixed provider-aware icon color updates for text fallbacks.

## 2.2.0

- Added namespaced icon registry with Lucide, Geist, and Craft provider metadata.
- Added Tag component and runtime tag APIs.
- Expanded notification system with icons, progress control, dismissal, updates, and visible-count culling.
- Added config manager, config listing, delete, export, import, and existence APIs.
- Added key-system provider registry for PlatoBoost, Panda Development, and Luarmor with pluggable validation adapters.
- Added provider cycling, key-link copy, and status feedback to the key-system UI.

# Changelog

## 2.1.0

- Rebuilt the default window visual system for sharper rendering and stronger contrast.
- Replaced the raster image shadow with a crisp native frame shadow.
- Added layered header, navigation panel, content panel, status indicator, and version footer.
- Fixed tab activation to iterate over the owning window's tabs.
- Fixed window tab registration to use the library window order.
- Renamed the minimize button field to avoid colliding with `Window:Minimize()`.
- Fixed the showcase example to use `Window:GetTab("Main")`.
- Added `Window:GetActiveTab()`, `Window:SelectTab(name)`, and `Window:SetStatus(text, color)`.
- Improved runtime theme propagation for dynamic dropdown, image dropdown, multi-dropdown, and context-menu rendering.
- Fixed color picker theme updates and loading spinner theme updates.

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
