# IrisHub Architecture

## Runtime layers

`IrisHub` is the public runtime entry point. A library instance owns its windows, global connections, notifications, theme state and configuration state.

### Component lifecycle

Every standard tab component is represented by a component reference with:

- `Instance` for its root GuiObject
- `Data` for component state
- `Connections` for persistent event cleanup
- `DynamicConnections` for temporary option-list connections
- `Children` for nested component ownership
- `Destroyed` state for idempotent cleanup

Dynamic dropdown renderers clear their dynamic connection bag before rebuilding options. This prevents repeated search/filter updates from accumulating stale signal connections.

## Window lifecycle

Windows are kept in an array on the library. Destruction removes the exact window instance from that array before the root hierarchy is destroyed.

Windows support:

- title-bar dragging
- maximize/minimize
- optional resizing
- root `UIScale`
- min/max size constraints
- explicit focus
- optional visibility toggle keys

## Theme model

Themes are dictionaries of design tokens. Runtime switching mutates the library's active theme table in place, allowing existing component closures that hold the theme reference to see updated tokens. Components then receive `RefreshTheme` calls for visual properties that need explicit reapplication.

## Input model

Primary button actions use `GuiButton.Activated` and secondary context actions use `GuiButton.SecondaryActivated` so the public interaction layer maps cleanly across click/tap and secondary desktop/mobile input.

## Source and distribution

`src/IrisHub.luau` is authoritative. `dist/IrisHub.luau` is a generated single-file distribution produced by `python build.py`.

## Validation scope

The repository includes deterministic static checks for file presence, balanced delimiters, forbidden comment markers, build synchronization, documentation links and website JavaScript syntax. Roblox Studio execution is not available in the packaging environment, so device-specific UI behavior still requires a Studio play-test.
