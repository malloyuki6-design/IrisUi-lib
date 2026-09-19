# IrisHub v2.1.0 Validation

Static validation completed after the 2.1.0 UI and runtime fixes.

## Reported runtime errors fixed

- `CreateTab`: fixed tab activation code that referenced `self.Window.Tabs` from a Window method context.
- `CreateTab`: fixed window-order registration from `self.WindowOrder` to the owning library registry.
- `CreateWindow`: fixed the `Minimize` UI instance colliding with `Window:Minimize()`. The UI field is now `MinimizeButton`.
- Showcase example: fixed `Window.Windows[1]:GetTab("Main")` to `Window:GetTab("Main")`.

## UI refresh

- Removed the raster image shadow that made the window edge look soft.
- Added a native crisp shadow frame, layered surface gradient, stronger contrast, header status, navigation label, content panel, and version footer.
- Improved tab active/hover states and borders.
- Increased default window size and tightened spacing.
- Added `Window:GetActiveTab()`, `Window:SelectTab(name)`, and `Window:SetStatus(text, color)`.
- Updated dynamic component theme rendering so dropdown and menu options use the current theme.

## Static checks

- IrisHub validator: PASS
- Website JavaScript syntax: PASS
- Source/dist synchronization: PASS
- Source/dist SHA-256: 570f886a497ae7cae045dc646c12ed56238142072d3afa6b0f4f045cab341aef
- Forbidden `--` comment marker in runtime source/examples/tests: PASS
- Window API references used by examples: PASS
- No `Window.Windows` misuse in examples: PASS
- No minimize method/property collision: PASS
- No `self.Window.Tabs` activation misuse: PASS
- No `self.WindowOrder` registration misuse: PASS

## Runtime limitation

The source cannot be executed inside Roblox Studio in this environment, so final rendering, input, and executor-specific behavior still require a Studio/in-game test.
