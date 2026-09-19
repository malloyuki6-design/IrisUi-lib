# IrisHub Icons

IrisHub supports standard Roblox image assets and namespaced icon identifiers. Namespaces supported by the built-in registry are `lucide:`, `geist:`, and `craft:`.

## Register a single icon

```lua
UI:RegisterIcon("lucide:settings", "rbxassetid://123456789")
```

## Register an icon set

```lua
UI:RegisterIconSet("lucide", {
    settings = "rbxassetid://123456789",
    bell = "rbxassetid://987654321"
})
```

## Use an icon

```lua
Tab:Button({
    Title = "Settings",
    Icon = "lucide:settings",
    Callback = function() end
})
```

When a namespaced icon has not been registered, IrisHub uses a crisp text glyph fallback instead of creating an invalid ImageLabel. This keeps the UI functional while projects prepare their own Roblox-hosted icon assets.

## Provider sources

Lucide Icons: https://lucide.dev/

Geist Icons: https://vercel.com/geist/icons

Craft Icons: https://www.figma.com/community/file/1415718327120418204
