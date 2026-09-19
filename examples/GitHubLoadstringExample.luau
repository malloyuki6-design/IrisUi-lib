local IRISHUB_URL = "https://raw.githubusercontent.com/malloyuki6-design/IrisUi-lib/main/dist/IrisHub.luau"

local function loadIrisHub()
    local request = game.HttpGet
    assert(type(request) == "function", "IrisHub: game:HttpGet is unavailable in this environment.")

    local downloaded, source = pcall(function()
        return game:HttpGet(IRISHUB_URL)
    end)
    assert(downloaded, "IrisHub: failed to download the GitHub build. " .. tostring(source))
    assert(type(source) == "string" and #source > 0, "IrisHub: GitHub returned an empty library response.")

    local compiler = loadstring
    if type(compiler) ~= "function" then
        compiler = load
    end
    assert(type(compiler) == "function", "IrisHub: this runtime does not expose loadstring or load.")

    local compiled, compileError = compiler(source)
    assert(type(compiled) == "function", "IrisHub: downloaded build failed to compile. " .. tostring(compileError))

    local executed, library = pcall(compiled)
    assert(executed, "IrisHub: downloaded build failed while loading. " .. tostring(library))
    assert(type(library) == "table" and type(library.Create) == "function", "IrisHub: downloaded file is not a valid IrisHub build.")

    return library
end

local IrisHub = loadIrisHub()

local UI = IrisHub.Create({
    Name = "IrisHubExample",
    Title = "IrisHub",
    Subtitle = "Universal UI Framework • GitHub Loadstring Demo",
    Theme = "Iris",
    DefaultTab = "Main",
    DefaultSection = "MAIN",
    DefaultIcon = "lucide:layout-dashboard",
    Size = UDim2.fromOffset(900, 620),
    MinSize = Vector2.new(560, 380),
    MaxSize = Vector2.new(1320, 900),
    ToggleKey = Enum.KeyCode.RightControl,
    Draggable = true,
    Resizable = true,
    ConfigName = "IrisHubExample",
    Animation = true
})

local Window = UI.Windows[1]
assert(Window, "IrisHub: Create did not return a default window.")

local function notify(title, description, kind, duration)
    UI:Notify({
        Title = title,
        Description = description,
        Type = kind or "Info",
        Duration = duration or 3,
        Icon = (kind == "Success" and "lucide:circle-check") or (kind == "Warning" and "lucide:triangle-alert") or (kind == "Error" and "lucide:circle-x") or "lucide:info"
    })
end

local Main = Window:GetTab("Main")
assert(Main, "IrisHub: default Main tab was not created.")

local Pages = Window:Section({Title = "PAGES", Icon = "lucide:layout-grid"})
local Features = Pages:Tab({Title = "Features", Icon = "lucide:sliders-horizontal"})
local Appearance = Pages:Tab({Title = "Appearance", Icon = "lucide:palette"})
local Utilities = Pages:Tab({Title = "Utilities", Icon = "lucide:settings"})
local About = Pages:Tab({Title = "About", Icon = "lucide:info"})

local Extras = Window:Section({Title = "SYSTEM", Icon = "lucide:box"})
local KeySystem = Extras:Tab({Title = "Key System", Icon = "lucide:key"})
local Configs = Extras:Tab({Title = "Configs", Icon = "lucide:folder-cog"})

local progress = Main:Progress({
    Title = "Showcase coverage",
    Min = 0,
    Max = 100,
    Default = 76,
    Decimals = 0
})

Main:Paragraph({
    Title = "Welcome to IrisHub",
    Content = "A complete public example built around the current IrisHub API. Explore controls, grouped navigation, icons, themes, backgrounds, notifications, configurations, and the key-system adapter layer.",
    Height = 86
})

Main:Status({
    Title = "Framework status",
    Description = "IrisHub loaded successfully",
    State = "Success"
})

Main:Section({Title = "Runtime", Description = "Information from the loaded library"})
Main:KeyValue({Key = "Version", Value = UI:GetVersion()})
Main:KeyValue({Key = "Theme", Value = UI.ThemeName})
Main:KeyValue({Key = "Tabs", Value = tostring(#Window.TabOrder)})
Main:Tag({Text = "GITHUB BUILD", Icon = "lucide:github"})

Main:Alert({
    Type = "Info",
    Title = "Controls",
    Description = "RightControl toggles the window. The title bar can be dragged and the lower-right corner can be resized."
})

local openFeatures = Main:Button({
    Title = "Open feature playground",
    Description = "Jump directly to the controls showcase.",
    Icon = "lucide:sliders-horizontal",
    Callback = function()
        Window:SetVisible(true)
        Window:SelectTab("Features")
        notify("Navigation", "Feature playground opened.", "Success")
    end
})

Main:Tooltip({Target = openFeatures, Text = "Switch to the Features tab."})
Main:Divider()

Main:CodeBlock({
    Language = "luau",
    Code = [[local IrisHub = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()

local UI = IrisHub.Create({
    Title = "My Hub",
    Theme = "Iris",
    DefaultIcon = "lucide:layout-dashboard"
})]],
    Height = 116
})

Features:Section({Title = "Controls", Description = "Reactive components from the public API"})

local enabled = Features:Toggle({
    Title = "Advanced mode",
    Description = "Updates the showcase progress and stores the setting.",
    Default = true,
    Icon = "lucide:zap",
    Callback = function(value)
        progress:Set(value and 94 or 36)
        UI:SetConfig("AdvancedMode", value)
        notify("Advanced mode", value and "Enabled" or "Disabled", value and "Success" or "Warning")
    end
})

Features:Dropdown({
    Title = "Quality preset",
    Options = {
        {Value = "Balanced", Label = "Balanced", Icon = "lucide:gauge"},
        {Value = "Performance", Label = "Performance", Icon = "lucide:rocket"},
        {Value = "Quality", Label = "Quality", Icon = "lucide:sparkles"},
        {Value = "Experimental", Label = "Experimental", Icon = "lucide:flask-conical"}
    },
    Default = "Balanced",
    Callback = function(value)
        UI:SetConfig("QualityPreset", value)
        notify("Quality", tostring(value) .. " selected.", "Info", 2.4)
    end
})

local systems = Features:MultiDropdown({
    Title = "Enabled systems",
    Options = {"Visuals", "Automation", "Statistics", "Notifications", "Diagnostics"},
    Default = {"Visuals", "Notifications"},
    Callback = function(values)
        UI:SetConfig("EnabledSystems", values)
    end
})

Features:ImageDropdown({
    Title = "Profile preset",
    Options = {
        {Value = "Aurora", Label = "Aurora", Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150"},
        {Value = "Nebula", Label = "Nebula", Image = "rbxthumb://type=AvatarHeadShot&id=261&w=150&h=150"},
        {Value = "Violet", Label = "Violet", Image = "rbxthumb://type=AvatarHeadShot&id=156&w=150&h=150"}
    },
    Default = "Aurora",
    Callback = function(value)
        UI:SetConfig("ProfilePreset", value)
    end
})

Features:Slider({
    Title = "Showcase coverage",
    Min = 0,
    Max = 100,
    Increment = 1,
    Default = 76,
    Decimals = 0,
    Callback = function(value)
        progress:Set(value)
    end
})

Features:Input({
    Title = "Display name",
    Placeholder = "Enter a display name",
    Default = "IrisHub User",
    Callback = function(value)
        UI:SetConfig("DisplayName", value)
    end
})

Features:Keybind({
    Title = "Notification key",
    Default = "F6",
    Callback = function(key, pressed)
        if pressed then
            notify("Keybind", tostring(key) .. " activated.", "Success", 2.4)
        end
    end
})

Features:Button({
    Title = "Notification demo",
    Icon = "lucide:bell",
    Callback = function()
        notify("IrisHub", "Notification system is working.", "Success")
    end
})

Features:Tag({Text = "LUCIDE", Icon = "lucide:sparkles"})
Features:Tag({Text = "GEIST", Icon = "geist:star"})
Features:Tag({Text = "CRAFT", Icon = "craft:layers"})

Appearance:Section({Title = "Theme", Description = "Change the visual system at runtime"})

Appearance:Dropdown({
    Title = "Theme",
    Options = UI:GetThemes(),
    Default = UI.ThemeName,
    Callback = function(themeName)
        UI:SetTheme(themeName)
        notify("Theme", tostring(themeName) .. " applied.", "Success")
    end
})

Appearance:ColorPicker({
    Title = "Accent color",
    Default = UI:GetThemeValue("Accent"),
    Callback = function(value)
        UI:SetTheme({Accent = value})
    end
})

local glass = Appearance:Toggle({
    Title = "Soft surfaces",
    Description = "Adjust the shared transparency token.",
    Default = UI:GetThemeValue("Transparency") > 0,
    Callback = function(value)
        UI:SetTheme({Transparency = value and 0.06 or 0})
    end
})

Appearance:Section({Title = "Background", Description = "Use a Roblox texture ID on the window surface"})

local backgroundId = Appearance:Input({
    Title = "Texture ID",
    Placeholder = "rbxassetid://1234567890",
    Default = "",
    Callback = function(value)
        UI:SetConfig("BackgroundTexture", value)
    end
})

Appearance:Button({
    Title = "Apply background",
    Icon = "lucide:image",
    Callback = function()
        local value = tostring(backgroundId:Get() or "")
        if value == "" then
            notify("Background", "Enter a Roblox texture ID first.", "Warning")
            return
        end
        Window:SetBackgroundImage(value, 0.88, UDim2.fromOffset(128, 128), Color3.new(1, 1, 1))
        notify("Background", "Texture applied.", "Success")
    end
})

Appearance:Button({
    Title = "Clear background",
    Icon = "lucide:eraser",
    Callback = function()
        Window:ClearBackgroundImage()
        notify("Background", "Texture cleared.", "Info")
    end
})

Appearance:Image({
    Image = "rbxthumb://type=AvatarBust&id=1&w=420&h=420",
    Caption = "IrisHub image component",
    Height = 160
})

Appearance:Avatar({
    Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150",
    Name = "IrisHub",
    Status = "Universal UI framework"
})

Appearance:Card({
    Title = "Design language",
    Description = "Compact navigation, curved surfaces, restrained accents, and runtime theming.",
    Height = 82
})

local themeStatus = Appearance:Status({
    Title = "Theme engine",
    Description = "Live and reactive",
    State = "Success"
})
Appearance:Tooltip({Target = themeStatus, Text = "Theme changes propagate through registered components."})

Utilities:Section({Title = "Tools", Description = "Utility components and runtime demonstrations"})

Utilities:Search({
    Placeholder = "Search playground...",
    Callback = function(value)
        if value ~= "" then
            notify("Search", "Query: " .. value, "Info", 2)
        end
    end
})

local loading = Utilities:Loading({Text = "Background operation"})

Utilities:Button({
    Title = "Toggle loading",
    Icon = "lucide:loader-circle",
    Callback = function()
        loading:Set(not loading:Get())
    end
})

Utilities:ContextMenu({
    Title = "Context actions",
    Items = {
        {Title = "Refresh", Callback = function() notify("Context", "Refresh requested.", "Info") end},
        {Title = "Save profile", Callback = function() UI:SaveConfig("IrisHubExample"); notify("Config", "Profile saved.", "Success") end},
        {Title = "Disabled action", Disabled = true},
        {Title = "Hide window", Callback = function() UI:SetUIVisible(false) end}
    }
})

Utilities:Button({
    Title = "Open modal",
    Icon = "lucide:message-square",
    Callback = function()
        UI:CreateModal({
            Title = "IrisHub modal",
            Description = "This modal uses the public callback-driven API.",
            CancelText = "Cancel",
            ConfirmText = "Continue",
            OnCancel = function()
                notify("Modal", "Cancelled.", "Warning")
            end,
            OnConfirm = function()
                notify("Modal", "Confirmed.", "Success")
            end
        })
    end
})

Utilities:CodeBlock({
    Language = "luau",
    Code = [[UI:Notify({
    Icon = "lucide:bell",
    Title = "Hello",
    Description = "IrisHub is running.",
    Type = "Success",
    Duration = 3
})]],
    Height = 112
})

Configs:Section({Title = "Configuration manager", Description = "Named profiles backed by the library config API"})
local configPanel = Configs:ConfigPanel({
    Title = "Profiles",
    Description = "Save, load, and delete IrisHub configuration profiles.",
    DefaultName = "IrisHubExample",
    OnSave = function(ok, result, name)
        notify("Configs", ok and ("Saved " .. tostring(name)) or tostring(result), ok and "Success" or "Warning")
    end,
    OnLoadResult = function(ok, result, name)
        notify("Configs", ok and ("Loaded " .. tostring(name)) or tostring(result), ok and "Success" or "Warning")
    end,
    OnDelete = function(ok, result, name)
        notify("Configs", ok and ("Deleted " .. tostring(name)) or tostring(result), ok and "Success" or "Warning")
    end
})

Configs:Button({
    Title = "Export config",
    Icon = "lucide:upload",
    Callback = function()
        local ok, result = UI:ExportConfig()
        notify("Configs", ok and "Configuration exported." or tostring(result), ok and "Success" or "Warning")
    end
})

Configs:Button({
    Title = "List configs",
    Icon = "lucide:list",
    Callback = function()
        local names = UI:ListConfigs()
        notify("Configs", #names > 0 and table.concat(names, ", ") or "No saved configurations.", "Info", 3.5)
    end
})

KeySystem:Section({Title = "Provider adapters", Description = "Available key-system providers in the IrisHub API"})
KeySystem:Dropdown({
    Title = "Provider",
    Options = UI:GetKeyProviders(),
    Default = "Luarmor",
    Callback = function(provider)
        UI:SetConfig("KeyProvider", provider)
    end
})

KeySystem:Tag({Text = "PLATOBOOST", Icon = "lucide:key"})
KeySystem:Tag({Text = "PANDA DEVELOPMENT", Icon = "lucide:shield-check"})
KeySystem:Tag({Text = "LUARMOR", Icon = "lucide:badge-check"})

KeySystem:Button({
    Title = "Open key-system demo",
    Icon = "lucide:key-round",
    Callback = function()
        local providerName = UI:GetConfig("KeyProvider", "Luarmor")
        UI:CreateKeySystem({
            Provider = providerName,
            Description = "This example uses a local validator to demonstrate the adapter UI. Connect a real provider validator for production use.",
            Validate = function(key)
                local accepted = key == "IRISHUB-DEMO"
                return accepted, accepted and "Demo key accepted." or "Use IRISHUB-DEMO for this local example."
            end,
            OnSuccess = function()
                notify("Key system", "Access granted.", "Success")
            end,
            OnFailure = function(_, message)
                notify("Key system", tostring(message), "Warning")
            end
        })
    end
})

About:Section({Title = "About IrisHub", Description = "Open-source universal Roblox UI framework"})
About:Paragraph({
    Title = "Built for developers",
    Content = "Component references support runtime updates, visibility changes, theme propagation, cleanup, and structured navigation."
})
About:Status({Title = "Repository", Description = "Hosted on GitHub", State = "Success"})
About:KeyValue({Key = "Library version", Value = UI:GetVersion()})
About:KeyValue({Key = "Distribution", Value = "dist/IrisHub.luau"})
About:Tag({Text = "OPEN SOURCE", Icon = "lucide:github"})

local versionButton = About:Button({
    Title = "Show runtime version",
    Icon = "lucide:badge-info",
    Callback = function()
        notify("IrisHub", "Running version " .. UI:GetVersion(), "Info")
    end
})
About:Tooltip({Target = versionButton, Text = "Reads the version directly from the loaded runtime."})

UI:SetConfig("AdvancedMode", enabled:Get())
UI:SetConfig("Theme", UI.ThemeName)
UI:SetConfig("GlassSurfaces", glass:Get())
UI:SetConfig("EnabledSystems", systems:GetSelected())
