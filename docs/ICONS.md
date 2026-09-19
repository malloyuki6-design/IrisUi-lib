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

IrisHub includes functional Roblox-hosted fallback assets for common Lucide-style names such as `home`, `settings`, `user`, `search`, `bell`, `sparkles`, `palette`, and `sliders`. Projects can override these with `RegisterIcon` or `RegisterIconSet`. Namespaced icons that are not registered use a crisp text glyph fallback instead of creating an invalid ImageLabel. This keeps the UI functional while projects prepare their own Roblox-hosted icon assets.

## Provider sources

Lucide Icons: https://lucide.dev/

Geist Icons: https://vercel.com/geist/icons

Craft Icons: https://www.figma.com/community/file/1415718327120418204

## Built-in catalog

```lua
local catalog = UI:GetIconCatalog()
```

The catalog exposes the bundled fallback asset names. Geist and Craft remain supported as provider namespaces through custom Roblox-hosted asset registration.

## Footagesus Icons integration

IrisHub resolves missing named icons through the Footagesus Icons runtime when the execution environment permits HTTP and dynamic loading. Lucide, Geist, and Craft namespaces can be requested with `lucide:name`, `geist:name`, and `craft:name`. Locally registered Roblox assets remain the first lookup path.
