local IrisHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/malloyuki6-design/IrisUi-lib/refs/heads/main/dist/IrisHub.luau"))()

local UI = IrisHub.Create({
    Name = "IrisHubExample",
    Title = "IrisHub",
    Subtitle = "Universal UI Framework • GitHub Loadstring Demo",
    Theme = "Iris",
    DefaultIcon = "lucide:info",
    Size = UDim2.fromOffset(900, 620),
    MinSize = Vector2.new(620, 420),
    MaxSize = Vector2.new(1280, 860),
    UIScale = 1,
    ToggleKey = Enum.KeyCode.RightControl,
    Draggable = true,
    Resizable = true,
    ConfigName = "IrisHubExample"
})

local Window = UI.Windows[1]
local Dashboard = Window:GetTab("Main")
local Features = Window:CreateTab({Title = "Features", Icon = "lucide:sparkles"})
local Appearance = Window:CreateTab({Title = "Appearance", Icon = "lucide:palette"})
local Utilities = Window:CreateTab({Title = "Utilities", Icon = "lucide:settings"})
local About = Window:CreateTab({Title = "About", Icon = "lucide:info"})

local function notify(title, description, kind, duration)
    UI:Notify({
        Title = title,
        Description = description,
        Type = kind or "Info",
        Duration = duration or 3
    })
end

Dashboard:Paragraph({
    Title = "Welcome to IrisHub",
    Content = "This example is loaded directly from GitHub and demonstrates the public IrisHub API, runtime updates, themes, stateful controls, notifications, configuration, and utility components.",
    Height = 86
})

Dashboard:Status({
    Title = "Framework status",
    Description = "IrisHub is running normally",
    State = "Success"
})

Dashboard:Section({Title = "Runtime overview", Description = "Live information from the loaded library"})
Dashboard:KeyValue({Key = "Version", Value = UI:GetVersion()})
Dashboard:KeyValue({Key = "Theme", Value = UI.ThemeName})
Dashboard:KeyValue({Key = "Tabs", Value = "5"})
Dashboard:Badge({Text = "GITHUB BUILD"})

local progress = Dashboard:Progress({
    Title = "Example coverage",
    Min = 0,
    Max = 100,
    Default = 72,
    Decimals = 0
})

Dashboard:Alert({
    Type = "Info",
    Title = "Tip",
    Description = "Press RightControl to hide or show the window. Drag the title bar to reposition it and use the resize grip in the lower-right corner."
})

local openFeatures = Dashboard:Button({
    Title = "Open feature playground",
    Description = "Jump to the controls showcase.",
    Callback = function()
        Window:SetVisible(true)
        Window:SelectTab("Features")
        notify("Navigation", "Feature playground opened.", "Success")
    end
})

Dashboard:Tooltip({
    Target = openFeatures,
    Text = "Switches to the Features tab."
})

Dashboard:Divider()

Dashboard:CodeBlock({
    Language = "luau",
    Code = [[local IrisHub = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()

local UI = IrisHub.Create({
    Title = "My Hub",
    Theme = "Iris"
})]],
    Height = 116
})

Features:Section({Title = "Controls", Description = "Interactive components with real callbacks"})

local enabled = Features:Toggle({
    Title = "Enable advanced mode",
    Description = "Updates the progress indicator and saves state to the config object.",
    Default = true,
    Callback = function(value)
        progress:Set(value and 94 or 34)
        UI:SetConfig("AdvancedMode", value)
        notify("Advanced mode", value and "Enabled" or "Disabled", value and "Success" or "Warning")
    end
})

Features:Dropdown({
    Title = "Quality preset",
    Options = {
        {Value = "Balanced", Label = "Balanced"},
        {Value = "Performance", Label = "Performance"},
        {Value = "Quality", Label = "Quality"},
        {Value = "Experimental", Label = "Experimental"}
    },
    Default = "Balanced",
    Callback = function(value)
        UI:SetConfig("QualityPreset", value)
        notify("Preset changed", tostring(value), "Info")
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
        notify("Profile", tostring(value) .. " selected.", "Info")
    end
})

Features:Slider({
    Title = "Example coverage",
    Min = 0,
    Max = 100,
    Increment = 1,
    Default = 72,
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
    Title = "Test notification key",
    Default = "F6",
    Callback = function(key, pressed)
        if pressed then
            notify("Keybind", tostring(key) .. " activated.", "Success")
        end
    end
})

Appearance:Section({Title = "Theme lab", Description = "Change the visual language at runtime"})

Appearance:Dropdown({
    Title = "Theme",
    Options = UI:GetThemes(),
    Default = UI.ThemeName,
    Callback = function(themeName)
        UI:SetTheme(themeName)
        notify("Theme applied", tostring(themeName), "Success")
    end
})

local glass = Appearance:Toggle({
    Title = "Soft surfaces",
    Description = "Increase the shared transparency token.",
    Default = UI:GetThemeValue("Transparency") > 0,
    Callback = function(value)
        UI:SetTheme({Transparency = value and 0.08 or 0.02})
    end
})

Appearance:ColorPicker({
    Title = "Accent color",
    Default = UI:GetThemeValue("Accent"),
    Callback = function(value)
        UI:SetTheme({Accent = value})
    end
})

Appearance:Image({
    Image = "rbxthumb://type=AvatarBust&id=1&w=420&h=420",
    Caption = "IrisHub visual component",
    Height = 170
})

Appearance:Avatar({
    Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150",
    Name = "IrisHub",
    Status = "Universal UI framework"
})

Appearance:Card({
    Title = "Design language",
    Description = "Layered surfaces, restrained motion, consistent spacing, and runtime theming.",
    Height = 82
})

local themeStatus = Appearance:Status({
    Title = "Theme engine",
    Description = "Live and reactive",
    State = "Success"
})

Appearance:Tooltip({
    Target = themeStatus,
    Text = "Theme changes propagate through registered UI components."
})

Utilities:Section({Title = "Utility playground", Description = "Configuration, loading, menus, and modals"})

Utilities:Search({
    Placeholder = "Search the playground...",
    Callback = function(value)
        if value ~= "" then
            notify("Search", "Query: " .. value, "Info", 2)
        end
    end
})

local loading = Utilities:Loading({Text = "Background operation"})

Utilities:Button({
    Title = "Toggle loading",
    Callback = function()
        loading:Set(not loading:Get())
    end
})

Utilities:Button({
    Title = "Save config",
    Callback = function()
        local ok, result = UI:SaveConfig("IrisHubExample")
        if ok then
            notify("Configuration", "Saved to " .. tostring(result), "Success")
        else
            notify("Configuration", tostring(result), "Warning")
        end
    end
})

Utilities:Button({
    Title = "Load config",
    Callback = function()
        local ok, data = UI:LoadConfig("IrisHubExample")
        if ok then
            notify("Configuration", "Loaded " .. tostring(data.DisplayName or "saved state"), "Success")
        else
            notify("Configuration", tostring(data), "Warning")
        end
    end
})

Utilities:ContextMenu({
    Title = "Context actions",
    Items = {
        {Title = "Refresh", Callback = function() notify("Context", "Refresh requested.", "Info") end},
        {Title = "Save profile", Callback = function() UI:SaveConfig("IrisHubExample"); notify("Context", "Profile save requested.", "Success") end},
        {Title = "Disabled action", Disabled = true},
        {Title = "Hide window", Callback = function() UI:SetUIVisible(false) end}
    }
})

Utilities:Button({
    Title = "Open confirmation modal",
    Callback = function()
        UI:CreateModal({
            Title = "IrisHub modal",
            Description = "This modal is built by the library and can be driven entirely through callbacks.",
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
    Title = "Hello",
    Description = "IrisHub is running.",
    Type = "Success",
    Duration = 3
})]],
    Height = 112
})

About:Section({Title = "About IrisHub", Description = "Open-source universal Roblox UI framework"})
About:Paragraph({
    Title = "Built for extensibility",
    Content = "Use the component references returned by IrisHub to update, enable, disable, hide, show, or destroy UI elements at runtime."
})
About:Status({Title = "Repository", Description = "Hosted on GitHub", State = "Success"})
About:KeyValue({Key = "Library version", Value = UI:GetVersion()})
About:KeyValue({Key = "Distribution", Value = "dist/IrisHub.luau"})
About:Badge({Text = "OPEN SOURCE"})

local versionInfo = About:Button({
    Title = "Show runtime version",
    Callback = function()
        notify("IrisHub", "Running version " .. UI:GetVersion(), "Info")
    end
})

About:Tooltip({
    Target = versionInfo,
    Text = "Reads the version directly from the loaded IrisHub runtime."
})

UI:SetConfig("AdvancedMode", enabled:Get())
UI:SetConfig("Theme", UI.ThemeName)
UI:SetConfig("GlassSurfaces", glass:Get())
UI:SetConfig("EnabledSystems", systems:GetSelected())


local providerTag = About:Tag({Text = "LUARMOR ADAPTER READY", Icon = "lucide:key"})
local notificationDemo = About:Button({
    Title = "Test rich notification",
    Icon = "lucide:bell",
    Callback = function()
        local notice = UI:Notify({
            Title = "IrisHub",
            Description = "Icon-aware notification with progress and manual dismiss.",
            Type = "Success",
            Duration = 5,
            Icon = "lucide:sparkles"
        })
        task.delay(1, function() notice:SetDescription("Notification updated at runtime.") end)
    end
})

local keyDemoButton = About:Button({
    Title = "Open key-system demo",
    Icon = "lucide:key",
    Callback = function()
        UI:CreateKeySystem({
            Provider = "Luarmor",
            Description = "Demo adapter only. Replace Validate with your real provider integration.",
            Validate = function(key)
                return key == "IRISHUB-DEMO", key == "IRISHUB-DEMO" and "Demo key accepted." or "Use IRISHUB-DEMO for this local demo."
            end,
            OnSuccess = function()
                UI:Notify({Title = "Key system", Description = "Demo access granted.", Type = "Success", Icon = "lucide:shield"})
            end
        })
    end
})
