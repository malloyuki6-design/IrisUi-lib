local IrisHub = require(game.ReplicatedStorage.IrisHub)
assert(IrisHub.GetVersion, "GetVersion API missing")
assert(IrisHub.Create, "Create API missing")

local UI = IrisHub.Create({
    Name = "IrisHubSmoke",
    Title = "Smoke",
    Subtitle = "API validation",
    Resizable = true,
    UIScale = 1
})

assert(UI:GetVersion() == "2.0.0", "Unexpected version")
assert(UI:GetThemes()[1] ~= nil, "Theme registry is empty")

local Window = UI.Windows[1]
assert(Window, "Default window missing")
assert(Window:GetTab("Main"), "Default tab missing")

local Tab = Window:GetTab("Main")
local toggle = Tab:Toggle({Title = "Toggle", Default = true})
local dropdown = Tab:Dropdown({Title = "Mode", Options = {"A", "B"}, Default = "A"})
local multi = Tab:MultiDropdown({Title = "Multi", Options = {"A", "B"}})
local progress = Tab:Progress({Title = "Progress", Min = 0, Max = 100, Default = 25})
local status = Tab:Status({Title = "Status", Description = "Ready", State = "Success"})
local badge = Tab:Badge({Text = "BETA"})
local keyValue = Tab:KeyValue({Key = "Version", Value = UI:GetVersion()})
local alert = Tab:Alert({Type = "Info", Title = "Alert", Description = "Smoke test"})
local code = Tab:CodeBlock({Language = "luau", Code = "print(1)"})
local section = Tab:Section({Title = "Section"})

assert(toggle:IsEnabled(), "Toggle should start enabled")
toggle:Set(false):SetEnabled(true):SetCallback(function() end)
assert(dropdown:FindOption("A"), "Dropdown option lookup failed")
dropdown:Set("B")
multi:Select("A"):Select("B")
assert(#multi:GetSelected() == 2, "Multi selection failed")
progress:Set(75):SetRange(0, 150)
status:Set("Warning", "Check")
badge:Set("LIVE")
keyValue:Set("2.0.0")
alert:Set("Success", "Done")
code:SetLanguage("lua"):Set("print(2)")
section:Collapse():Expand()

UI:SetTheme("Midnight")
UI:SetTheme({Accent = Color3.fromRGB(120, 110, 255)})
UI:SetUIVisible(false)
UI:SetUIVisible(true)

Window:SetSize(UDim2.fromOffset(720, 520), false)
Window:SetPosition(UDim2.fromScale(0.5, 0.5), false)
Window:Focus()

UI:Destroy()
print("IrisHub smoke test passed")
