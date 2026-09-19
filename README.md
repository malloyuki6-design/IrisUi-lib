# IrisHub

IrisHub is an open-source universal Roblox/Luau UI framework focused on polished interfaces, consistent component APIs, responsive controls, runtime theming, and cleanup-safe component lifecycles.

## v2.0.0 highlights

- Refined window chrome with minimize, maximize, focus, resize, drag and optional toggle-key support
- Runtime scale and min/max size constraints
- Cross-platform button activation through Roblox's `Activated` and `SecondaryActivated` events
- Reactive component references with `Set`, `Get`, `Update`, `SetTitle`, `SetDescription`, `SetCallback`, `SetVisible`, `SetEnabled`, `IsEnabled` and `Destroy`
- New Progress, Status, Badge, KeyValue, Alert and CodeBlock components
- Section aliases plus `Expand` and `Collapse`
- Richer dropdown APIs including `FindOption`, `Clear`, `GetSelected`, `Select` and `Deselect`
- Dynamic dropdown renderers now clean their temporary connections before rebuilding
- Improved runtime theme propagation
- `UISizeConstraint` and `UIScale` integration for more predictable UI sizing
- Standalone distribution regenerated from source

## Quick start

```lua
local IrisHub = require(game.ReplicatedStorage.IrisHub)

local UI = IrisHub.Create({
    Name = "MyInterface",
    Title = "My Hub",
    Subtitle = "Powered by IrisHub",
    Theme = "Iris",
    UIScale = 1,
    MinSize = Vector2.new(460, 320),
    ToggleKey = Enum.KeyCode.RightControl
})

local Window = UI.Windows[1]
local Main = Window:GetTab("Main")

Main:Toggle({
    Title = "Feature",
    Description = "An animated toggle.",
    Default = true,
    Callback = function(value)
        print("Feature:", value)
    end
})

Main:Dropdown({
    Title = "Mode",
    Options = {"Balanced", "Performance", "Visual"},
    Default = "Balanced"
})

local progress = Main:Progress({
    Title = "Progress",
    Min = 0,
    Max = 100,
    Default = 72
})

progress:Set(86)
```

## Component catalog

### Layout and information

`Section` / `Accordion`, `Label`, `Paragraph`, `Divider`, `Card`, `KeyValue`, `Badge`, `Status`, `Alert`, `CodeBlock`, `Image`, `Avatar`

### Controls

`Button`, `Toggle`, `Dropdown`, `MultiDropdown`, `ImageDropdown`, `Slider`, `Input`, `Keybind`, `ColorPicker`, `Search`

### Advanced UI

`Progress`, `Loading`, `Modal`, `ContextMenu`, `Tooltip`

## Window options

| Property | Type | Description |
|---|---|---|
| `Name` | string | ScreenGui base name |
| `Title` | string | Window title |
| `Subtitle` | string | Supporting text |
| `Theme` | string | Built-in or registered theme |
| `ThemeData` | table | Inline theme token overrides |
| `Size` | UDim2 | Initial size |
| `Position` | UDim2 | Initial position |
| `MinSize` | Vector2 | Minimum window size |
| `MaxSize` | Vector2 | Maximum window size |
| `UIScale` | number | Root UI scale |
| `Resizable` | boolean | Enables the resize grip |
| `Draggable` | boolean | Enables title-bar dragging |
| `ToggleKey` | EnumItem/string | Optional visibility toggle key |
| `DisplayOrder` | number | ScreenGui display order |
| `OnClose` | function | Called before the window is destroyed |
| `Config` | table | Initial configuration state |
| `ConfigName` | string | Default config file name |

## Component contract

Every created component is a reference object. Common methods:

```lua
Component:Get()
Component:Set(value)
Component:Update({
    Title = "Updated title",
    Description = "Updated description",
    Enabled = true
})
Component:SetTitle("Updated title")
Component:SetDescription("Updated description")
Component:SetCallback(function(value) end)
Component:SetVisible(true)
Component:SetEnabled(false)
Component:IsEnabled()
Component:Destroy()
```

Component methods are chainable where practical.

## Themes

Built-in themes:

- `Iris`
- `Midnight`
- `Light`

Register and switch themes at runtime:

```lua
UI:RegisterTheme("Ocean", {
    Accent = Color3.fromRGB(70, 170, 255),
    Accent2 = Color3.fromRGB(130, 120, 255)
})

UI:SetTheme("Ocean")
```

## Notifications

```lua
UI:Notify({
    Title = "Saved",
    Description = "Your configuration was saved.",
    Type = "Success",
    Duration = 4
})
```

## Configuration

IrisHub exposes simple configuration state plus optional file persistence when the current runtime provides `writefile`, `readfile`, and `isfile`.

```lua
UI:SetConfig("enabled", true)
UI:SaveConfig("profile")

local ok, data = UI:LoadConfig("profile")
```

## GitHub loadstring

For executor-style runtimes that provide `loadstring` and `game:HttpGet`, host the generated `dist/IrisHub.luau` file in a public GitHub repository and use its raw URL:

```lua
local IrisHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPOSITORY/main/dist/IrisHub.luau"))()

local UI = IrisHub.Create({
    Title = "My Hub",
    Subtitle = "Powered by IrisHub",
    Theme = "Iris"
})

local Window = UI.Windows[1]
local Main = Window:GetTab("Main")

Main:Button({
    Title = "Hello",
    Callback = function()
        UI:Notify({
            Title = "IrisHub",
            Description = "The GitHub loadstring is working.",
            Type = "Success"
        })
    end
})
```

Use a tagged release or pinned commit for production so updates do not silently change the runtime your script loads. For normal Roblox experiences, prefer a ModuleScript/packaged distribution instead of remote code execution. See `examples/GitHubLoadstringExample.luau` for the full showcase.

## Distribution

`dist/IrisHub.luau` is generated directly from `src/IrisHub.luau` with `python build.py`.

## Runtime note

The source is designed for Roblox LocalScript/ModuleScript execution. The sandbox used to prepare this repository does not contain Roblox Studio, so a Studio play-test is still required for runtime validation of UI input, sizing and rendering across devices.

## License

MIT. See `LICENSE`.
