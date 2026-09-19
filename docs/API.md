# IrisHub API Reference

## Library factory

`IrisHub.Create(options)` creates a library instance and its default window. `IrisHub.new(options)` creates only the library instance; call `:CreateWindow(options)` to create windows manually.

### Library methods

| Method | Purpose |
|---|---|
| `Create(options)` | Static constructor |
| `new(options)` | Constructor |
| `GetThemeValue(key)` | Read a theme token |
| `SetTheme(theme)` | Activate a built-in or inline theme |
| `RegisterTheme(name, theme)` | Register a custom theme |
| `GetThemes()` | Return sorted theme names |
| `RefreshTheme()` | Reapply theme tokens |
| `GetWindow(name)` | Find the first window by title |
| `GetComponent(kind)` | Find the first live component of a kind |
| `SetUIVisible(boolean)` | Show/hide the library ScreenGui |
| `Notify(options)` | Create a notification |
| `CreateModal(options, window?)` | Create an overlay modal |
| `CreateKeySystem(options)` | Create a validation overlay |
| `SaveConfig(name?)` | Persist config when file APIs exist |
| `LoadConfig(name?)` | Load config when file APIs exist |
| `SetConfig(key, value)` | Store a config value |
| `GetConfig(key, fallback?)` | Read a config value |
| `GetVersion()` | Return the library version |
| `Destroy()` | Tear down the complete library |

## Window

### Window options

| Property | Type | Default |
|---|---|---|
| `Title` | string | `IrisHub` |
| `Subtitle` | string | `Universal interface` |
| `Size` | UDim2 | 640×460 |
| `Position` | UDim2 | centered |
| `MinSize` | Vector2 | 420×300 |
| `MaxSize` | Vector2 | 1600×1000 |
| `UIScale` | number | 1 |
| `Resizable` | boolean | true |
| `Draggable` | boolean | true |
| `ToggleKey` | EnumItem/string | nil |
| `OnClose` | function | nil |

### Window methods

`CreateTab(options)`

`GetTab(name)`

`SetTitle(title, subtitle?)`

`SetSize(size, animate?)`

`SetPosition(position, animate?)`

`SetVisible(boolean)`

`Focus()`

`Minimize()`

`Maximize()`

`Destroy()`

## Tab

Every tab supports these aliases:

`Label`, `Paragraph`, `Divider`, `Button`, `Toggle`, `Dropdown`, `MultiDropdown`, `ImageDropdown`, `Slider`, `Input`, `Keybind`, `ColorPicker`, `Image`, `Avatar`, `Card`, `Loading`, `Progress`, `Status`, `Badge`, `KeyValue`, `Alert`, `CodeBlock`, `Modal`, `Search`, `Section`, `Accordion`, `ContextMenu`, `Tooltip`.

## Component base API

Every component returns a reference object.

`Get()`

`Set(value)`

`Update(patch)`

`SetTitle(value)`

`SetDescription(value)`

`SetCallback(function?)`

`SetVisible(boolean)`

`SetEnabled(boolean)`

`IsEnabled()`

`Destroy()`

`Update` recognizes `Title`, `Description`, `Enabled`, `Callback`, `Value`, and `Options` when the component implements `SetOptions`.

## Dropdown API

```lua
local mode = Tab:Dropdown({
    Title = "Mode",
    Options = {
        {Value = "balanced", Label = "Balanced"},
        {Value = "performance", Label = "Performance"}
    },
    Default = "balanced"
})

mode:Set("performance")
mode:SetOptions({"Balanced", "Performance", "Visual"})
mode:FindOption("performance")
mode:Clear()
```

## MultiDropdown API

```lua
local filters = Tab:MultiDropdown({
    Title = "Filters",
    Options = {"Players", "NPCs", "Items"}
})

filters:Select("Players")
filters:Deselect("Players")
filters:SelectAll()
filters:GetSelected()
filters:Clear()
```

## ImageDropdown option shape

```lua
{
    Value = "sunset",
    Label = "Sunset",
    Image = "rbxassetid://123456",
    Icon = "rbxassetid://123456",
    Description = "Optional metadata",
    Disabled = false
}
```

## Slider

```lua
local power = Tab:Slider({
    Title = "Power",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 50,
    Decimals = 0,
    Callback = function(value)
    end
})

power:Set(75)
```

## Progress

```lua
local progress = Tab:Progress({
    Title = "Download",
    Min = 0,
    Max = 100,
    Default = 40
})

progress:Set(100)
progress:SetRange(0, 200)
```

## Status, Badge and Alert

```lua
local status = Tab:Status({
    Title = "Connection",
    Description = "Connected",
    State = "Success"
})

status:Set("Warning", "Latency is elevated")

local badge = Tab:Badge({Text = "BETA"})
badge:Set("LIVE")

local alert = Tab:Alert({
    Type = "Info",
    Title = "Heads up",
    Description = "This is an informational alert."
})
```

## CodeBlock

```lua
local code = Tab:CodeBlock({
    Language = "luau",
    Code = 'print("Hello IrisHub")',
    OnCopy = function(copied)
    end
})

code:Set('print("Updated")')
code:SetLanguage("lua")
code:Copy()
```
