local IrisHub = require(game.ReplicatedStorage.IrisHub)

local UI = IrisHub.Create({
    Name = "IrisHubShowcase",
    Title = "IrisHub",
    Subtitle = "Universal UI Framework",
    Theme = "Iris",
    Size = UDim2.fromOffset(760, 540),
    MinSize = Vector2.new(560, 390),
    MaxSize = Vector2.new(1200, 760),
    UIScale = 1,
    ToggleKey = Enum.KeyCode.RightControl,
    Draggable = true,
    Resizable = true
})

local Window = UI.Windows[1]
local Dashboard = Window:GetTab("Main")
local Controls = Window:CreateTab({Title = "Controls", Icon = "rbxassetid://10734952330"})
local Visuals = Window:CreateTab({Title = "Visuals", Icon = "rbxassetid://10734951010"})
local Tools = Window:CreateTab({Title = "Tools", Icon = "rbxassetid://10734950309"})
local About = Window:CreateTab({Title = "About", Icon = "rbxassetid://10734950020"})

local function notify(title, description, kind)
    UI:Notify({
        Title = title,
        Description = description,
        Type = kind or "Info",
        Duration = 2.8
    })
end

Dashboard:Paragraph({
    Title = "Welcome to IrisHub",
    Content = "A complete showcase for the IrisHub component system. Use the tabs to explore controls, visuals, tools, runtime theming, and interactive API behavior.",
    Height = 88
})

Dashboard:Status({Title = "Framework", Description = "All systems ready", State = "Success"})
Dashboard:Badge({Text = "OPEN SOURCE"})
Dashboard:KeyValue({Key = "Version", Value = UI:GetVersion()})
Dashboard:KeyValue({Key = "Theme", Value = UI.ThemeName})
Dashboard:KeyValue({Key = "Components", Value = "25+ primitives"})

local previewProgress = Dashboard:Progress({
    Title = "Showcase completion",
    Min = 0,
    Max = 100,
    Default = 78,
    Decimals = 0
})

Dashboard:Alert({
    Type = "Info",
    Title = "Interactive example",
    Description = "Every control in this menu uses the public IrisHub API instead of directly manipulating internal UI objects."
})

local openTools = Dashboard:Button({
    Title = "Open tools",
    Icon = "rbxassetid://10734950020",
    Callback = function()
        Window:SelectTab("Tools")
        notify("Tools", "Tools tab activated", "Success")
    end
})

Dashboard:Tooltip({
    Target = openTools,
    Text = "Switches to the tools playground tab."
})

Dashboard:Divider()

Dashboard:CodeBlock({
    Language = "luau",
    Code = [[local Window = IrisHub.Create({
    Title = "My Hub",
    Theme = "Iris"
})

local Main = Window:GetTab("Main")

Main:Toggle({
    Title = "Example",
    Default = true
})]],
    Height = 154,
    OnCopy = function(success)
        if success then notify("Clipboard", "Example code copied", "Success") end
    end
})

Controls:Section({Title = "Core controls", Description = "Reactive components and state updates"})

local featureToggle = Controls:Toggle({
    Title = "Advanced mode",
    Description = "Changes the state of the progress example.",
    Default = true,
    Callback = function(value)
        previewProgress:Set(value and 92 or 34)
        notify("Advanced mode", value and "Enabled" or "Disabled", value and "Success" or "Warning")
    end
})

local mode = Controls:Dropdown({
    Title = "Performance mode",
    Options = {
        {Value = "Balanced", Label = "Balanced", Icon = "rbxassetid://10734950309"},
        {Value = "Performance", Label = "Performance"},
        {Value = "Quality", Label = "Quality"},
        {Value = "Experimental", Label = "Experimental", Disabled = false}
    },
    Default = "Balanced",
    Callback = function(value)
        notify("Mode", "Selected " .. tostring(value), "Info")
    end
})

Controls:MultiDropdown({
    Title = "Enabled systems",
    Options = {"ESP", "Automation", "Notifications", "Statistics", "Diagnostics"},
    Default = {"ESP", "Notifications"},
    Callback = function(values)
        UI:SetConfig("EnabledSystems", values)
    end
})

Controls:ImageDropdown({
    Title = "Profile preset",
    Options = {
        {Value = "Aurora", Label = "Aurora", Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150"},
        {Value = "Nebula", Label = "Nebula", Image = "rbxthumb://type=AvatarHeadShot&id=261&w=150&h=150"},
        {Value = "Violet", Label = "Violet", Image = "rbxthumb://type=AvatarHeadShot&id=156&w=150&h=150"}
    },
    Default = "Aurora",
    Callback = function(value)
        notify("Preset", tostring(value) .. " selected", "Info")
    end
})

Controls:Slider({
    Title = "Window width",
    Min = 560,
    Max = 900,
    Increment = 20,
    Default = 760,
    Decimals = 0,
    Callback = function(value)
        Window:SetSize(UDim2.fromOffset(value, Window.Size.Y.Offset))
    end
})

local nameInput = Controls:Input({
    Title = "Display name",
    Placeholder = "Enter a name",
    Default = "IrisHub User",
    Callback = function(value)
        UI:SetConfig("DisplayName", value)
    end
})

Controls:Keybind({
    Title = "Quick action",
    Default = "F6",
    Callback = function(key, pressed)
        if pressed then notify("Keybind", tostring(key) .. " activated", "Success") end
    end
})

local color = Controls:ColorPicker({
    Title = "Accent color",
    Default = UI:GetThemeValue("Accent"),
    Callback = function(value)
        UI:SetTheme({Accent = value})
    end
})

Controls:Button({
    Title = "Preview notification",
    Callback = function()
        notify("IrisHub", "Notification system is working.", "Success")
    end
})

Visuals:Section({Title = "Theme lab", Description = "Change the design system at runtime"})

Visuals:Dropdown({
    Title = "Theme",
    Options = UI:GetThemes(),
    Default = UI.ThemeName,
    Callback = function(themeName)
        UI:SetTheme(themeName)
        notify("Theme", tostring(themeName) .. " applied", "Success")
    end
})

Visuals:Toggle({
    Title = "Glass surfaces",
    Description = "Adjust the global window transparency token.",
    Default = UI:GetThemeValue("Transparency") > 0,
    Callback = function(enabled)
        UI:SetTheme({Transparency = enabled and 0.08 or 0})
    end
})

Visuals:Image({
    Image = "rbxthumb://type=AvatarBust&id=1&w=420&h=420",
    Caption = "IrisHub visual component",
    Height = 180
})

Visuals:Avatar({
    Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150",
    Name = "IrisHub",
    Status = "Universal UI framework"
})

Visuals:Card({
    Title = "Design language",
    Description = "Soft surfaces, sharp hierarchy, restrained motion, and consistent component geometry.",
    Height = 88
})

local status = Visuals:Status({Title = "Theme engine", Description = "Live", State = "Success"})
Visuals:Tooltip({Target = status, Text = "Theme changes propagate through registered components."})

Tools:Section({Title = "Playground", Description = "Runtime utilities and API demonstrations"})

Tools:Search({
    Placeholder = "Search playground...",
    Callback = function(value)
        if value ~= "" then notify("Search", "Query: " .. value, "Info") end
    end
})

local loading = Tools:Loading({Text = "Background operation"})

Tools:Button({
    Title = "Toggle loading",
    Callback = function()
        loading:Set(not loading:Get())
    end
})

Tools:ContextMenu({
    Title = "Context actions",
    Items = {
        {Title = "Refresh", Callback = function() notify("Context", "Refresh requested", "Info") end},
        {Title = "Save", Callback = function() UI:SaveConfig("IrisHubShowcase"); notify("Config", "Save requested", "Success") end},
        {Title = "Disabled action", Disabled = true},
        {Title = "Destroy UI", Callback = function() UI:Destroy() end}
    }
})

local modalButton = Tools:Button({
    Title = "Open modal",
    Callback = function()
        UI:CreateModal({
            Title = "IrisHub modal",
            Description = "This is the built-in modal layer. It supports custom text, cancel actions, and confirm actions.",
            CancelText = "Not now",
            ConfirmText = "Continue",
            OnCancel = function()
                notify("Modal", "Cancelled", "Warning")
            end,
            OnConfirm = function()
                notify("Modal", "Confirmed", "Success")
            end
        })
    end
})

Tools:Tooltip({Target = modalButton, Text = "Opens a modal without leaving the current window."})

Tools:Button({
    Title = "Save current config",
    Callback = function()
        local ok, result = UI:SaveConfig("IrisHubShowcase")
        notify("Config", ok and "Saved to " .. tostring(result) or tostring(result), ok and "Success" or "Warning")
    end
})

Tools:Button({
    Title = "Load current config",
    Callback = function()
        local ok = UI:LoadConfig("IrisHubShowcase")
        notify("Config", ok and "Configuration loaded" or "No readable configuration found", ok and "Success" or "Warning")
    end
})

Tools:CodeBlock({
    Language = "luau",
    Code = 'local component = Tab:CreateToggle({Title = "Live", Default = true})\ncomponent:Set(false)\ncomponent:SetEnabled(true)\ncomponent:SetTitle("Updated")',
    Height = 112
})

About:Section({Title = "IrisHub", Description = "Universal UI framework showcase"})
About:Paragraph({
    Title = "Built for developers",
    Content = "IrisHub keeps the component API consistent while exposing runtime control over state, themes, visibility, and lifecycle. This example is intentionally built with public APIs only.",
    Height = 96
})
About:KeyValue({Key = "Version", Value = UI:GetVersion()})
About:KeyValue({Key = "Theme count", Value = tostring(#UI:GetThemes())})
About:KeyValue({Key = "Window", Value = "Resizable + draggable"})
About:Badge({Text = "IRISHUB V2"})
About:Alert({
    Type = "Success",
    Title = "Ready",
    Description = "Use this file as the starting point for your own hub, dashboard, settings panel, or developer menu."
})
About:CodeBlock({
    Language = "luau",
    Code = 'local IrisHub = require(game.ReplicatedStorage.IrisHub)\nlocal UI = IrisHub.Create({Title = "My UI", Theme = "Iris"})',
    Height = 82
})

UI:SetConfig("DisplayName", nameInput:Get())
UI:SetConfig("Mode", mode:Get())
featureToggle:SetCallback(function(value)
    previewProgress:Set(value and 92 or 34)
    UI:SetConfig("AdvancedMode", value)
    notify("Advanced mode", value and "Enabled" or "Disabled", value and "Success" or "Warning")
end)
