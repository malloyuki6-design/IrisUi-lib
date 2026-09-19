local IrisHub = {}
IrisHub.__index = IrisHub
IrisHub.Version = "2.2.2"
IrisHub.Name = "IrisHub"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local ParentGui = (gethui and gethui()) or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui")) or CoreGui

local Themes = {
    Iris = {
        Background = Color3.fromRGB(10, 11, 18),
        Surface = Color3.fromRGB(18, 20, 31),
        Surface2 = Color3.fromRGB(25, 28, 42),
        Surface3 = Color3.fromRGB(34, 37, 55),
        Border = Color3.fromRGB(55, 60, 84),
        Text = Color3.fromRGB(247, 248, 255),
        Muted = Color3.fromRGB(164, 168, 194),
        Accent = Color3.fromRGB(157, 132, 255),
        Accent2 = Color3.fromRGB(105, 190, 255),
        AccentSoft = Color3.fromRGB(58, 50, 98),
        Success = Color3.fromRGB(84, 205, 142),
        Warning = Color3.fromRGB(241, 190, 82),
        Danger = Color3.fromRGB(238, 92, 112),
        Overlay = Color3.fromRGB(7, 8, 12),
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.80,
        Transparency = 0,
        Radius = 12,
        Font = Enum.Font.Gotham,
        TitleFont = Enum.Font.GothamBold,
        SmallFont = Enum.Font.GothamMedium
    },
    Midnight = {
        Background = Color3.fromRGB(10, 14, 21),
        Surface = Color3.fromRGB(16, 21, 31),
        Surface2 = Color3.fromRGB(22, 28, 41),
        Surface3 = Color3.fromRGB(28, 36, 52),
        Border = Color3.fromRGB(46, 57, 78),
        Text = Color3.fromRGB(240, 247, 255),
        Muted = Color3.fromRGB(139, 157, 179),
        Accent = Color3.fromRGB(83, 171, 255),
        Accent2 = Color3.fromRGB(137, 122, 255),
        AccentSoft = Color3.fromRGB(37, 67, 96),
        Success = Color3.fromRGB(81, 207, 145),
        Warning = Color3.fromRGB(241, 188, 81),
        Danger = Color3.fromRGB(239, 98, 118),
        Overlay = Color3.fromRGB(4, 6, 10),
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.5,
        Transparency = 0.03,
        Radius = 10,
        Font = Enum.Font.Gotham,
        TitleFont = Enum.Font.GothamBold,
        SmallFont = Enum.Font.GothamMedium
    },
    Light = {
        Background = Color3.fromRGB(244, 246, 252),
        Surface = Color3.fromRGB(255, 255, 255),
        Surface2 = Color3.fromRGB(239, 242, 249),
        Surface3 = Color3.fromRGB(231, 235, 244),
        Border = Color3.fromRGB(216, 220, 232),
        Text = Color3.fromRGB(29, 32, 42),
        Muted = Color3.fromRGB(100, 106, 122),
        Accent = Color3.fromRGB(111, 91, 230),
        Accent2 = Color3.fromRGB(76, 148, 232),
        AccentSoft = Color3.fromRGB(222, 218, 250),
        Success = Color3.fromRGB(52, 169, 106),
        Warning = Color3.fromRGB(206, 147, 44),
        Danger = Color3.fromRGB(207, 72, 92),
        Overlay = Color3.fromRGB(23, 24, 31),
        Shadow = Color3.fromRGB(28, 30, 38),
        ShadowTransparency = 0.38,
        Transparency = 0.02,
        Radius = 10,
        Font = Enum.Font.Gotham,
        TitleFont = Enum.Font.GothamBold,
        SmallFont = Enum.Font.GothamMedium
    }
}

local function CloneTable(source)
    local result = {}
    for key, value in pairs(source) do
        if type(value) == "table" then
            result[key] = CloneTable(value)
        else
            result[key] = value
        end
    end
    return result
end

local function Merge(base, patch)
    local result = CloneTable(base)
    for key, value in pairs(patch or {}) do
        if type(value) == "table" and type(result[key]) == "table" then
            result[key] = Merge(result[key], value)
        else
            result[key] = value
        end
    end
    return result
end

local function SafeName(value)
    local text = tostring(value or "IrisHub")
    return text:gsub("[^%w_%-]", "")
end

local function Clamp(value, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, value))
end

local function Round(value, step)
    if not step or step == 0 then
        return value
    end
    return math.floor(value / step + 0.5) * step
end

local function FormatValue(value, decimals)
    if type(value) ~= "number" then
        return tostring(value)
    end
    if decimals and decimals > 0 then
        return string.format("%." .. tostring(decimals) .. "f", value)
    end
    if value % 1 == 0 then
        return tostring(math.floor(value))
    end
    return string.format("%.2f", value)
end

local function ColorToHex(value)
    if typeof(value) ~= "Color3" then return "#FFFFFF" end
    return string.format("#%02X%02X%02X", math.floor(value.R * 255 + 0.5), math.floor(value.G * 255 + 0.5), math.floor(value.B * 255 + 0.5))
end

local function HexToColor(value)
    local clean = tostring(value or ""):gsub("#", "")
    if #clean ~= 6 then return nil end
    local r = tonumber(clean:sub(1, 2), 16)
    local g = tonumber(clean:sub(3, 4), 16)
    local b = tonumber(clean:sub(5, 6), 16)
    if not r or not g or not b then return nil end
    return Color3.fromRGB(r, g, b)
end


local IconProviders = {
    Lucide = {
        Name = "Lucide Icons",
        Prefix = "lucide:",
        Website = "https://lucide.dev/"
    },
    Geist = {
        Name = "Geist Icons",
        Prefix = "geist:",
        Website = "https://vercel.com/geist/icons"
    },
    Craft = {
        Name = "Craft Icons",
        Prefix = "craft:",
        Website = "https://www.figma.com/community/file/1415718327120418204"
    }
}

local IconRegistry = {
    Assets = {},
    Fallbacks = {
        home = "⌂",
        house = "⌂",
        settings = "⚙",
        gear = "⚙",
        user = "●",
        users = "●●",
        dashboard = "◈",
        layout = "▦",
        menu = "☰",
        search = "⌕",
        bell = "◔",
        notification = "◔",
        shield = "◇",
        key = "◆",
        lock = "■",
        unlock = "□",
        star = "★",
        sparkles = "✦",
        info = "i",
        warning = "!",
        error = "×",
        success = "✓",
        check = "✓",
        close = "×",
        plus = "+",
        minus = "−",
        chevronright = "›",
        chevrondown = "⌄",
        palette = "◉",
        code = "<>"
    }
}

local function CopyText(value)
    local text = tostring(value or "")
    local clipboard = setclipboard or toclipboard or (syn and syn.write_clipboard)
    if type(clipboard) == "function" then
        local ok = pcall(clipboard, text)
        return ok
    end
    return false
end

local function IsTextGui(instance)
    return instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")
end

local function Fire(callback, ...)
    if type(callback) ~= "function" then
        return
    end
    task.spawn(function(...)
        local ok = pcall(callback, ...)
        return ok
    end, ...)
end

local function New(className, properties, parent)
    local instance = Instance.new(className)
    for key, value in pairs(properties or {}) do
        instance[key] = value
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function Corner(parent, radius)
    return New("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end

local function Stroke(parent, color, transparency, thickness)
    return New("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, parent)
end

local function Padding(parent, left, right, top, bottom)
    return New("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or left or 0),
        PaddingTop = UDim.new(0, top or left or 0),
        PaddingBottom = UDim.new(0, bottom or top or left or 0)
    }, parent)
end

local function Tween(instance, properties, duration, easing)
    local info = TweenInfo.new(duration or 0.18, easing or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function SetText(label, text)
    if IsTextGui(label) then
        label.Text = tostring(text or "")
    end
end

local function CreateShadow(parent, transparency)
    local shadow = New("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = transparency or 0.8,
        BorderSizePixel = 0,
        AnchorPoint = parent.AnchorPoint,
        Position = UDim2.new(parent.Position.X.Scale, parent.Position.X.Offset + 8, parent.Position.Y.Scale, parent.Position.Y.Offset + 9),
        Size = UDim2.new(parent.Size.X.Scale, parent.Size.X.Offset + 12, parent.Size.Y.Scale, parent.Size.Y.Offset + 12),
        ZIndex = math.max(0, parent.ZIndex - 1)
    }, parent.Parent)
    Corner(shadow, 14)
    return shadow
end

local ConnectionBag = {}
ConnectionBag.__index = ConnectionBag

function ConnectionBag.new()
    return setmetatable({Items = {}}, ConnectionBag)
end

function ConnectionBag:Add(item)
    table.insert(self.Items, item)
    return item
end

function ConnectionBag:Clear()
    for index = #self.Items, 1, -1 do
        local item = self.Items[index]
        local kind = typeof(item)
        if kind == "RBXScriptConnection" then
            pcall(function() item:Disconnect() end)
        elseif kind == "Instance" then
            pcall(function() item:Destroy() end)
        elseif type(item) == "function" then
            pcall(item)
        end
        self.Items[index] = nil
    end
end

local Component = {}
Component.__index = Component

function Component.new(library, kind, instance, metadata)
    return setmetatable({
        Library = library,
        Kind = kind,
        Instance = instance,
        Data = metadata or {},
        Connections = ConnectionBag.new(),
        DynamicConnections = ConnectionBag.new(),
        Children = {},
        Destroyed = false
    }, Component)
end

function Component:AddConnection(connection)
    if self.Destroyed then
        pcall(function() connection:Disconnect() end)
        return connection
    end
    return self.Connections:Add(connection)
end

function Component:SetVisible(value)
    if self.Destroyed then return self end
    if self.Instance then
        self.Instance.Visible = value == true
    end
    return self
end

function Component:SetEnabled(value)
    if self.Destroyed then return self end
    self.Data.Enabled = value ~= false
    local root = self.Instance
    if root then
        root.Active = self.Data.Enabled
        if root:IsA("TextButton") then
            root.AutoButtonColor = self.Data.Enabled
        end
        local shield = self.Data.DisabledShield
        if not self.Data.Enabled then
            if not shield or not shield.Parent then
                shield = New("Frame", {BackgroundColor3 = self.Library.Theme.Background, BackgroundTransparency = 0.82, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1000}, root)
                shield.Active = true
                self.Data.DisabledShield = shield
            end
            shield.Visible = true
        elseif shield then
            shield.Visible = false
        end
    end
    return self
end

function Component:Get()
    return self.Data.Value
end

function Component:Set(value)
    self.Data.Value = value
    return self
end

function Component:Update(patch)
    patch = patch or {}
    local valueSet = false
    for key, value in pairs(patch) do
        if key == "Title" then
            self:SetTitle(value)
        elseif key == "Description" then
            self:SetDescription(value)
        elseif key == "Enabled" then
            self:SetEnabled(value)
        elseif key == "Callback" then
            self:SetCallback(value)
        elseif key == "Value" then
            valueSet = true
        elseif key == "Options" and type(self.SetOptions) == "function" then
            self:SetOptions(value)
        else
            self.Data[key] = value
        end
    end
    if valueSet and type(self.Set) == "function" then
        self:Set(patch.Value)
    elseif patch.Value ~= nil then
        self.Data.Value = patch.Value
    end
    return self
end

function Component:SetTitle(value)
    if self.Destroyed then return self end
    local label = self.Data.Title or self.Data.Label
    if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
        label.Text = tostring(value or "")
    end
    self.Data.TitleValue = tostring(value or "")
    return self
end

function Component:SetDescription(value)
    if self.Destroyed then return self end
    local label = self.Data.Description or self.Data.Content
    if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
        label.Text = tostring(value or "")
    end
    self.Data.DescriptionValue = tostring(value or "")
    return self
end

function Component:SetCallback(callback)
    if self.Destroyed then return self end
    if type(callback) == "function" then
        self.Data.Callback = callback
    else
        self.Data.Callback = nil
    end
    return self
end

function Component:IsEnabled()
    return self.Destroyed == false and self.Data.Enabled ~= false
end

function Component:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    self.Connections:Clear()
    self.DynamicConnections:Clear()
    for _, child in ipairs(self.Children) do
        if child and child.Destroy then
            pcall(function() child:Destroy() end)
        end
    end
    if self.Instance then
        pcall(function() self.Instance:Destroy() end)
    end
end

local function ResolveIcon(icon)
    if icon == nil then return nil, nil end
    if typeof(icon) == "Instance" and icon:IsA("ImageLabel") then
        return icon.Image, nil
    end
    if type(icon) == "number" then
        return "rbxassetid://" .. tostring(icon), nil
    end
    local value = tostring(icon)
    local asset = IconRegistry.Assets[value]
    if asset then return asset, nil end
    local provider, name = value:match("^(%w+):(.*)$")
    if provider and name then
        local providerData = IconProviders[provider:sub(1, 1):upper() .. provider:sub(2):lower()]
        if providerData then
            local registered = IconRegistry.Assets[value]
            if registered then return registered, nil end
            return nil, IconRegistry.Fallbacks[string.lower(name:gsub("[_%-]", ""))] or "•"
        end
    end
    if value:match("^rbxassetid://") or value:match("^rbxthumb://") or value:match("^rbxgameasset://") then
        return value, nil
    end
    if value:match("^https?://") then
        local direct = IconRegistry.Assets[value]
        if direct then return direct, nil end
        return nil, "•"
    end
    return nil, value
end

local function CreateIcon(parent, icon, size, color, xAlignment)
    if not icon then return nil end
    local imageAsset, fallbackText = ResolveIcon(icon)
    local anchor = xAlignment == "right" and 1 or 0
    local offset = xAlignment == "right" and -12 or 12
    if imageAsset then
        return New("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(size or 18, size or 18),
            Image = imageAsset,
            ImageColor3 = color or Color3.new(1, 1, 1),
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(anchor, 0.5),
            Position = UDim2.new(anchor, offset, 0.5, 0)
        }, parent)
    end
    return New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(size or 18, size or 18),
        Font = Enum.Font.GothamBold,
        Text = fallbackText or "•",
        TextSize = math.max(11, (size or 18) - 2),
        TextColor3 = color or Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        AnchorPoint = Vector2.new(anchor, 0.5),
        Position = UDim2.new(anchor, offset, 0.5, 0)
    }, parent)
end

function IrisHub.new(options)
    options = options or {}
    local themeName = options.Theme or "Iris"
    local theme = Themes[themeName] or Themes.Iris
    theme = Merge(theme, options.ThemeData)
    local self = setmetatable({
        Options = options,
        ThemeName = themeName,
        Theme = theme,
        Connections = ConnectionBag.new(),
        Components = {},
        Windows = {},
        Notifications = {},
        WindowOrder = {},
        Destroyed = false,
        Config = options.Config or {}
    }, IrisHub)

    local guiName = SafeName(options.Name or "IrisHub") .. "_" .. tostring(math.random(10000, 99999))
    local gui = New("ScreenGui", {
        Name = guiName,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = options.DisplayOrder or 100
    }, ParentGui)
    self.Gui = gui
    return self
end

function IrisHub:GetThemeValue(key)
    return self.Theme[key]
end

function IrisHub:SetTheme(theme)
    if type(theme) == "string" then
        self.ThemeName = theme
        local nextTheme = CloneTable(Themes[theme] or Themes.Iris)
        for key in pairs(self.Theme) do self.Theme[key] = nil end
        for key, value in pairs(nextTheme) do self.Theme[key] = value end
    elseif type(theme) == "table" then
        for key, value in pairs(theme) do self.Theme[key] = value end
    end
    self:RefreshTheme()
    return self
end

function IrisHub:RegisterTheme(name, theme)
    assert(type(name) == "string", "Theme name must be a string")
    assert(type(theme) == "table", "Theme must be a table")
    Themes[name] = Merge(Themes.Iris, theme)
    return self
end

function IrisHub:GetThemes()
    local names = {}
    for name in pairs(Themes) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function IrisHub:GetWindow(name)
    for _, window in ipairs(self.Windows) do
        if window and window.Title and window.Title.Text == tostring(name) then return window end
    end
    return nil
end

function IrisHub:GetComponent(kind)
    for _, component in ipairs(self.Components) do
        if component and component.Kind == kind and not component.Destroyed then return component end
    end
    return nil
end

function IrisHub:SetUIVisible(value)
    if self.Gui then self.Gui.Enabled = value == true end
    for _, window in ipairs(self.Windows) do if window and not window.Destroyed then window.Root.Visible = value == true end end
    return self
end


function IrisHub:RefreshTheme()
    local theme = self.Theme
    for _, record in ipairs(self.Components) do
        if record and record.ApplyTheme then
            pcall(record.ApplyTheme, record, theme)
        end
    end
    for _, window in ipairs(self.Windows) do
        if window and window.ApplyTheme then
            pcall(window.ApplyTheme, window, theme)
        end
    end
    return self
end

function IrisHub:_register(component)
    table.insert(self.Components, component)
    return component
end


function IrisHub:RegisterIcon(name, asset)
    assert(type(name) == "string", "Icon name must be a string")
    assert(type(asset) == "string" or type(asset) == "number", "Icon asset must be a string or number")
    IconRegistry.Assets[name] = type(asset) == "number" and "rbxassetid://" .. tostring(asset) or asset
    return self
end

function IrisHub:RegisterIconSet(provider, icons)
    assert(type(provider) == "string", "Icon provider must be a string")
    assert(type(icons) == "table", "Icon set must be a table")
    for name, asset in pairs(icons) do
        local key = string.lower(provider) .. ":" .. string.lower(tostring(name))
        self:RegisterIcon(key, asset)
    end
    return self
end

function IrisHub:GetIconProviders()
    local result = {}
    for key, value in pairs(IconProviders) do
        result[key] = CloneTable(value)
    end
    return result
end

function IrisHub:ResolveIcon(icon)
    local asset, fallback = ResolveIcon(icon)
    return asset or fallback
end

local Window = {}
Window.__index = Window

function Window:ApplyTheme(theme)
    if self.Destroyed then return end
    self.Main.BackgroundColor3 = theme.Surface
    self.Main.BackgroundTransparency = theme.Transparency
    self.Stroke.Color = theme.Border
    self.Title.TextColor3 = theme.Text
    self.Subtitle.TextColor3 = theme.Muted
    self.Close.BackgroundColor3 = theme.Surface2
    self.Close.TextColor3 = theme.Muted
    self.MinimizeButton.BackgroundColor3 = theme.Surface2
    self.MinimizeButton.TextColor3 = theme.Muted
    self.MaximizeButton.BackgroundColor3 = theme.Surface2
    self.MaximizeButton.TextColor3 = theme.Muted
    self.AccentLine.BackgroundColor3 = theme.Accent
    self.Sidebar.BackgroundColor3 = theme.Background
    self.Breadcrumb.TextColor3 = theme.Muted
    for _, tab in pairs(self.Tabs) do
        if tab.ApplyTheme then tab:ApplyTheme(theme) end
    end
end

function Window:SetTitle(title, subtitle)
    self.Title.Text = tostring(title or "IrisHub")
    if subtitle ~= nil then
        self.Subtitle.Text = tostring(subtitle)
    end
    return self
end

function Window:SetSize(size, animate)
    if typeof(size) ~= "UDim2" then return self end
    self.Size = size
    self.PreviousSize = size
    if animate == false then self.Main.Size = size else Tween(self.Main, {Size = size}, 0.22, Enum.EasingStyle.Quart) end
    return self
end

function Window:SetPosition(position, animate)
    if typeof(position) ~= "UDim2" then return self end
    if animate == false then self.Main.Position = position else Tween(self.Main, {Position = position}, 0.22, Enum.EasingStyle.Quart) end
    return self
end

function Window:Focus()
    if self.Destroyed then return self end
    self.Root.Visible = true
    self.Main.ZIndex = 50
    self.Library._FocusedWindow = self
    return self
end

function Window:SetVisible(value)
    self.Root.Visible = value == true
    return self
end

function Window:Minimize()
    if self.Destroyed then return self end
    self.Minimized = not self.Minimized
    local target = self.Minimized and UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 58) or self.Size
    Tween(self.Main, {Size = target}, 0.24, Enum.EasingStyle.Quart)
    self.Pages.Visible = not self.Minimized
    self.Sidebar.Visible = not self.Minimized
    self.Breadcrumb.Visible = not self.Minimized
    return self
end

function Window:Maximize()
    if self.Destroyed then return self end
    if not self.Maximized then
        self.PreviousPosition = self.Main.Position
        self.PreviousSize = self.Main.Size
        Tween(self.Main, {Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -28, 1, -28)}, 0.24, Enum.EasingStyle.Quart)
        self.Maximized = true
    else
        Tween(self.Main, {Position = self.PreviousPosition or UDim2.fromScale(0.5, 0.5), Size = self.PreviousSize or self.Size}, 0.24, Enum.EasingStyle.Quart)
        self.Maximized = false
    end
    return self
end

function Window:CreateTab(options)
    options = options or {}
    local theme = self.Library.Theme
    local button = New("TextButton", {
        BackgroundColor3 = theme.Surface2,
        BackgroundTransparency = 0.52,
        Text = "",
        AutoButtonColor = false,
        Size = UDim2.new(1, -16, 0, 42),
        ZIndex = 4
    }, self.TabList)
    Corner(button, theme.Radius - 4)
    local icon = CreateIcon(button, options.Icon, 17, theme.Muted)
    local title = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(options.Icon and 42 or 14, 0),
        Size = UDim2.new(1, options.Icon and -54 or -28, 1, 0),
        Font = theme.SmallFont,
        Text = tostring(options.Title or "Tab"),
        TextSize = 13,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5
    }, button)
    local activeBar = New("Frame", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(3, 22),
        Visible = false,
        ZIndex = 6
    }, button)
    Corner(activeBar, 2)
    local page = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Border,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        ScrollBarImageTransparency = 0.1
    }, self.Pages)
    Padding(page, 2, 6, 6, 20)
    local layout = New("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    local tab = setmetatable({
        Library = self.Library,
        Window = self,
        Button = button,
        Title = title,
        Icon = icon,
        ActiveBar = activeBar,
        ButtonStroke = Stroke(button, theme.Border, 1, 1),
        Page = page,
        Layout = layout,
        Components = {},
        Name = tostring(options.Title or "Tab"),
        ApplyTheme = function(tabSelf, themeData)
            tabSelf.Title.TextColor3 = tabSelf.Active and themeData.Text or themeData.Muted
            tabSelf.Button.BackgroundColor3 = tabSelf.Active and themeData.Surface3 or themeData.Surface2
            tabSelf.Button.BackgroundTransparency = tabSelf.Active and 0 or 0.52
            if tabSelf.ButtonStroke then tabSelf.ButtonStroke.Color = themeData.Border; tabSelf.ButtonStroke.Transparency = tabSelf.Active and 0.18 or 1 end
            if tabSelf.Icon then
                local iconColor = tabSelf.Active and themeData.Accent or themeData.Muted
                if tabSelf.Icon:IsA("ImageLabel") then tabSelf.Icon.ImageColor3 = iconColor end
                if tabSelf.Icon:IsA("TextLabel") then tabSelf.Icon.TextColor3 = iconColor end
            end
            if tabSelf.ActiveBar then tabSelf.ActiveBar.BackgroundColor3 = themeData.Accent end
        end,
        Active = false
    }, {__index = {}})
    local methods = {}
    local proxy = setmetatable(tab, {__index = methods})

    function methods:_add(component)
        table.insert(self.Components, component)
        if component.Kind == "Section" then
            self.ActiveSection = component
        elseif self.ActiveSection and self.ActiveSection.Data.Expanded == false then
            component:SetVisible(false)
        end
        return self.Library:_register(component)
    end

    function methods:SetActive(value)
        self.Active = value == true
        self.Page.Visible = self.Active
        self.Button.BackgroundColor3 = self.Active and self.Library.Theme.Surface3 or self.Library.Theme.Surface2
        self.Button.BackgroundTransparency = self.Active and 0 or 0.52
        if self.ButtonStroke then self.ButtonStroke.Color = self.Library.Theme.Border; self.ButtonStroke.Transparency = self.Active and 0.18 or 1 end
        self.Title.TextColor3 = self.Active and self.Library.Theme.Text or self.Library.Theme.Muted
        if self.Icon then
            local iconColor = self.Active and self.Library.Theme.Accent or self.Library.Theme.Muted
            if self.Icon:IsA("ImageLabel") then self.Icon.ImageColor3 = iconColor end
            if self.Icon:IsA("TextLabel") then self.Icon.TextColor3 = iconColor end
        end
        self.ActiveBar.Visible = self.Active
        if self.Active then
            self.Window.ActiveTab = self
            self.Window.Breadcrumb.Text = self.Name
        end
        return self
    end

    local userConnections = ConnectionBag.new()
    userConnections:Add(button.Activated:Connect(function()
        for _, other in pairs(proxy.Window.Tabs) do
            other:SetActive(false)
        end
        proxy:SetActive(true)
    end))
    userConnections:Add(button.MouseEnter:Connect(function()
        if not proxy.Active then Tween(button, {BackgroundTransparency = 0.28}, 0.14) end
    end))
    userConnections:Add(button.MouseLeave:Connect(function()
        if not proxy.Active then Tween(button, {BackgroundTransparency = 0.52}, 0.14) end
    end))
    proxy.Connections = userConnections

    function methods:Label(opts) return self:CreateLabel(opts) end
    function methods:Paragraph(opts) return self:CreateParagraph(opts) end
    function methods:Divider(opts) return self:CreateDivider(opts) end
    function methods:Button(opts) return self:CreateButton(opts) end
    function methods:Toggle(opts) return self:CreateToggle(opts) end
    function methods:Dropdown(opts) return self:CreateDropdown(opts) end
    function methods:MultiDropdown(opts) return self:CreateMultiDropdown(opts) end
    function methods:ImageDropdown(opts) return self:CreateImageDropdown(opts) end
    function methods:Slider(opts) return self:CreateSlider(opts) end
    function methods:Input(opts) return self:CreateInput(opts) end
    function methods:Keybind(opts) return self:CreateKeybind(opts) end
    function methods:ColorPicker(opts) return self:CreateColorPicker(opts) end
    function methods:Image(opts) return self:CreateImage(opts) end
    function methods:Avatar(opts) return self:CreateAvatar(opts) end
    function methods:Card(opts) return self:CreateCard(opts) end
    function methods:Loading(opts) return self:CreateLoading(opts) end
    function methods:Modal(opts) return self.Library:CreateModal(opts, self.Window) end
    function methods:Search(opts) return self:CreateSearch(opts) end
    function methods:Section(opts) return self:CreateSection(opts) end
    function methods:Accordion(opts) return self:CreateSection(opts) end
    function methods:ContextMenu(opts) return self:CreateContextMenu(opts) end
    function methods:Tooltip(opts) return self:CreateTooltip(opts) end
    function methods:Progress(opts) return self:CreateProgress(opts) end
    function methods:Status(opts) return self:CreateStatus(opts) end
    function methods:Badge(opts) return self:CreateBadge(opts) end
    function methods:KeyValue(opts) return self:CreateKeyValue(opts) end
    function methods:Alert(opts) return self:CreateAlert(opts) end
    function methods:Tag(opts) return self:CreateTag(opts) end
    function methods:ConfigPanel(opts) return self:CreateConfigPanel(opts) end
    function methods:CodeBlock(opts) return self:CreateCodeBlock(opts) end

    function methods:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        if self.Connections then self.Connections:Clear() end
        for _, component in ipairs(self.Components) do
            pcall(function() component:Destroy() end)
        end
        if self.Page then pcall(function() self.Page:Destroy() end) end
        self.Window.Tabs[self.Name] = nil
    end

    local function makeRow(opts, height)
        opts = opts or {}
        local row = New("Frame", {
            BackgroundColor3 = theme.Surface2,
            BackgroundTransparency = opts.Transparent and 1 or 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, height or 54),
            LayoutOrder = opts.LayoutOrder or 0
        }, page)
        Corner(row, math.max(6, theme.Radius - 2))
        Stroke(row, theme.Border, 0.28, 1)
        return row
    end

    function methods:CreateSection(opts)
        opts = opts or {}
        local row = New("TextButton", {
            BackgroundColor3 = theme.Surface,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, opts.Height or 46),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = opts.LayoutOrder or 0
        }, page)
        Corner(row, math.max(6, theme.Radius - 2))
        local line = New("Frame", {BackgroundColor3 = theme.Border, BorderSizePixel = 0, Position = UDim2.new(0, 12, 1, -1), Size = UDim2.new(1, -24, 0, 1)}, row)
        local titleLabel = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -60, 1, 0), Font = theme.TitleFont, Text = tostring(opts.Title or "Section"), TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local description = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(110, 0), Size = UDim2.new(1, -156, 1, 0), Font = theme.Font, Text = tostring(opts.Description or ""), TextSize = 10, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local chevron = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(22, 22), Font = theme.TitleFont, Text = "⌄", TextSize = 15, TextColor3 = theme.Muted}, row)
        local comp = Component.new(self.Library, "Section", row, {Value = true, Expanded = opts.DefaultExpanded ~= false, Title = titleLabel, Description = description, Chevron = chevron, Line = line})
        comp.Index = #self.Components + 1
        local function refresh()
            local expanded = comp.Data.Expanded == true
            comp.Data.Chevron.Text = expanded and "⌄" or "›"
            for i = comp.Index + 1, #self.Components do
                local other = self.Components[i]
                if other and other.Kind == "Section" then break end
                if other then other:SetVisible(expanded) end
            end
        end
        function comp:Set(value)
            self.Data.Expanded = value == true
            self.Data.Value = self.Data.Expanded
            refresh()
            return self
        end
        function comp:Toggle() return self:Set(not self.Data.Expanded) end
        function comp:Expand() return self:Set(true) end
        function comp:Collapse() return self:Set(false) end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Description.TextColor3 = t.Muted; c.Data.Line.BackgroundColor3 = t.Border; c.Data.Chevron.TextColor3 = t.Muted; c.Instance.BackgroundColor3 = t.Surface end
        comp:AddConnection(row.Activated:Connect(function() comp:Toggle() end))
        if not comp.Data.Expanded then refresh() end
        return self:_add(comp)
    end

    function methods:CreateLabel(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 42)
        local label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -28, 1, 0),
            Position = UDim2.fromOffset(14, 0),
            Font = theme.Font,
            Text = tostring(opts.Text or opts.Title or "Label"),
            TextSize = opts.TextSize or 13,
            TextColor3 = opts.Color or theme.Text,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        }, row)
        local comp = Component.new(self.Library, "Label", row, {Value = label.Text, Label = label})
        comp.ApplyTheme = function(c, t) c.Label.TextColor3 = opts.Color or t.Text end
        return self:_add(comp)
    end

    function methods:CreateParagraph(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 74)
        local titleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 9),
            Size = UDim2.new(1, -28, 0, 22),
            Font = theme.TitleFont,
            Text = tostring(opts.Title or "Paragraph"),
            TextSize = 14,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left
        }, row)
        local body = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 31),
            Size = UDim2.new(1, -28, 1, -38),
            Font = theme.Font,
            Text = tostring(opts.Content or opts.Description or ""),
            TextSize = opts.TextSize or 12,
            TextColor3 = theme.Muted,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            RichText = opts.RichText ~= false
        }, row)
        local comp = Component.new(self.Library, "Paragraph", row, {Title = titleLabel, Content = body, Value = opts.Content or opts.Description or ""})
        function comp:Set(value)
            self.Data.Value = value
            self.Data.Content.Text = tostring(value or "")
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Content.TextColor3 = t.Muted end
        return self:_add(comp)
    end

    function methods:CreateDivider(opts)
        opts = opts or {}
        local row = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, opts.Height or 18)}, page)
        New("Frame", {BackgroundColor3 = theme.Border, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.new(1, -4, 0, 1)}, row)
        local comp = Component.new(self.Library, "Divider", row, {})
        comp.ApplyTheme = function(c, t) for _, child in ipairs(c.Instance:GetChildren()) do if child:IsA("Frame") then child.BackgroundColor3 = t.Border end end end
        return self:_add(comp)
    end

    function methods:CreateButton(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 54)
        local button = New("TextButton", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            AutoButtonColor = false
        }, row)
        local label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(opts.Icon and 42 or 14, 0),
            Size = UDim2.new(1, opts.Icon and -62 or -28, 1, 0),
            Font = theme.SmallFont,
            Text = tostring(opts.Title or opts.Text or "Button"),
            TextSize = 13,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left
        }, button)
        CreateIcon(button, opts.Icon, 18, theme.Accent)
        local comp = Component.new(self.Library, "Button", row, {Value = false, Label = label, Enabled = true, Callback = opts.Callback})
        function comp:Set(value)
            self.Data.Value = value
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Label.TextColor3 = t.Text; c.Data.Label.Font = t.SmallFont end
        comp:AddConnection(button.MouseEnter:Connect(function() Tween(row, {BackgroundColor3 = self.Library.Theme.Surface3 or self.Library.Theme.Surface}, 0.14) end))
        comp:AddConnection(button.MouseLeave:Connect(function() Tween(row, {BackgroundColor3 = self.Library.Theme.Surface2}, 0.14) end))
        comp:AddConnection(button.MouseButton1Down:Connect(function() Tween(button, {Size = UDim2.new(0.985, 0, 0.96, 0)}, 0.08) end))
        comp:AddConnection(button.MouseButton1Up:Connect(function() Tween(button, {Size = UDim2.fromScale(1, 1)}, 0.12) end))
        comp:AddConnection(button.Activated:Connect(function() if comp.Data.Enabled ~= false then Fire(comp.Data.Callback) end end))
        return self:_add(comp)
    end

    function methods:CreateToggle(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 58)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 7), Size = UDim2.new(1, -92, 0, 21), Font = theme.SmallFont, Text = tostring(opts.Title or "Toggle"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local desc = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 27), Size = UDim2.new(1, -92, 0, 20), Font = theme.Font, Text = tostring(opts.Description or ""), TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local track = New("Frame", {BackgroundColor3 = theme.Border, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(42, 24)}, row)
        Corner(track, 12)
        local knob = New("Frame", {BackgroundColor3 = theme.Text, BorderSizePixel = 0, Position = UDim2.fromOffset(4, 4), Size = UDim2.fromOffset(16, 16)}, track)
        Corner(knob, 10)
        local click = New("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 18, 1, 18), Position = UDim2.fromOffset(-9, -9), Text = "", AutoButtonColor = false}, track)
        local comp = Component.new(self.Library, "Toggle", row, {Value = opts.Default == true, Title = title, Description = desc, Track = track, Knob = knob, Enabled = true, Callback = opts.Callback})
        local function render(animated)
            local on = comp.Data.Value == true
            local t = on and theme.Accent or theme.Border
            local targetPos = on and UDim2.new(1, -20, 0.5, -8) or UDim2.fromOffset(4, 4)
            if animated then Tween(track, {BackgroundColor3 = t}, 0.18); Tween(knob, {Position = targetPos}, 0.18) else track.BackgroundColor3 = t; knob.Position = targetPos end
        end
        function comp:Set(value)
            self.Data.Value = value == true
            render(true)
            Fire(comp.Data.Callback, self.Data.Value)
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Description.TextColor3 = t.Muted; render(false) end
        comp:AddConnection(click.Activated:Connect(function() if comp.Data.Enabled ~= false then comp:Set(not comp.Data.Value) end end))
        render(false)
        return self:_add(comp)
    end

    local function normalizeOptions(items)
        local list = {}
        if type(items) == "table" then
            for index, value in ipairs(items) do
                if type(value) == "table" then
                    table.insert(list, value)
                else
                    table.insert(list, {Value = value, Label = tostring(value)})
                end
            end
            if #list == 0 then
                for key, value in pairs(items) do
                    if type(value) == "table" then
                        local entry = CloneTable(value)
                        entry.Value = entry.Value or key
                        entry.Label = entry.Label or tostring(key)
                        table.insert(list, entry)
                    else
                        table.insert(list, {Value = key, Label = tostring(value)})
                    end
                end
            end
        end
        return list
    end

    function methods:CreateDropdown(opts)
        opts = opts or {}
        local row = makeRow(opts, 58)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 7), Size = UDim2.new(0.48, 0, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Title or "Dropdown"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local selected = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0), Size = UDim2.new(0.44, 0, 0, 24), Font = theme.Font, Text = tostring(opts.Default or "Select"), TextSize = 12, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local arrow = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(18, 18), Font = theme.TitleFont, Text = "⌄", TextSize = 16, TextColor3 = theme.Muted}, row)
        local hit = New("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false}, row)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6), ClipsDescendants = true, Visible = false, ZIndex = 20}, row)
        Corner(popup, theme.Radius)
        Stroke(popup, theme.Border, 0.15, 1)
        local search = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 30), PlaceholderText = "Search...", PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false, Visible = opts.Search ~= false}, popup)
        Corner(search, 7)
        Padding(search, 10, 10, 0, 0)
        local list = New("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, opts.Search == false and 0 or 46), Size = UDim2.new(1, 0, 1, -(opts.Search == false and 0 or 46)), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollBarThickness = 3, ZIndex = 21}, popup)
        Padding(list, 8, 8, 8, 8)
        local layout2 = New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, list)
        local comp = Component.new(self.Library, "Dropdown", row, {Value = opts.Default, Options = normalizeOptions(opts.Options), Title = title, Selected = selected, Popup = popup, List = list, Search = search, Open = false, OptionButtons = {}, Callback = opts.Callback})
        local renderOptions
        local function closePopup()
            comp.Data.Open = false
            popup.Visible = false
            Tween(row, {ZIndex = 1}, 0.1)
        end
        function comp:Set(value, silent)
            self.Data.Value = value
            local found = value
            for _, item in ipairs(self.Data.Options) do
                if item.Value == value then found = item.Label; break end
            end
            self.Data.Selected.Text = tostring(found or "Select")
            if not silent then Fire(comp.Data.Callback, value) end
            return self
        end
        function comp:SetOptions(items)
            self.Data.Options = normalizeOptions(items)
            renderOptions()
            return self
        end
        function comp:Open()
            comp.Data.Open = true
            popup.Visible = true
            Tween(popup, {Size = UDim2.new(1, 0, 0, math.min(230, 56 + #self.Data.Options * 36))}, 0.18)
            return self
        end
        function comp:Close()
            closePopup()
            return self
        end
        function comp:Clear()
            return self:Set(nil)
        end
        function comp:FindOption(value)
            for _, item in ipairs(self.Data.Options) do if item.Value == value then return item end end
            return nil
        end
        function comp:Toggle()
            if self.Data.Open then return self:Close() end
            return self:Open()
        end
        function renderOptions()
            comp.DynamicConnections:Clear()
            for _, child in ipairs(list:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            comp.Data.OptionButtons = {}
            local filter = string.lower(search.Text or "")
            for _, item in ipairs(comp.Data.Options) do
                local label = tostring(item.Label or item.Value)
                if filter == "" or string.find(string.lower(label), filter, 1, true) then
                    local itemButton = New("TextButton", {BackgroundColor3 = self.Library.Theme.Surface2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 22}, list)
                    Corner(itemButton, 6)
                    local itemLabel = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0), Font = self.Library.Theme.Font, Text = label, TextSize = 12, TextColor3 = item.Disabled and self.Library.Theme.Muted or self.Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23}, itemButton)
                    if item.Icon then CreateIcon(itemButton, item.Icon, 15, self.Library.Theme.Muted) end
                    if not item.Disabled then
                        comp.DynamicConnections:Add(itemButton.Activated:Connect(function() comp:Set(item.Value); closePopup() end))
                        comp.DynamicConnections:Add(itemButton.MouseEnter:Connect(function() Tween(itemButton, {BackgroundColor3 = self.Library.Theme.Border}, 0.1) end))
                        comp.DynamicConnections:Add(itemButton.MouseLeave:Connect(function() Tween(itemButton, {BackgroundColor3 = self.Library.Theme.Surface2}, 0.1) end))
                    end
                    table.insert(comp.Data.OptionButtons, itemButton)
                end
            end
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Selected.TextColor3 = t.Muted; renderOptions() end
        comp:AddConnection(hit.Activated:Connect(function() comp:Toggle() end))
        comp:AddConnection(search:GetPropertyChangedSignal("Text"):Connect(renderOptions))
        renderOptions()
        if opts.Default ~= nil then comp:Set(opts.Default, true) end
        return self:_add(comp)
    end

    function methods:CreateMultiDropdown(opts)
        opts = opts or {}
        opts.Title = opts.Title or "Multi Dropdown"
        local values = opts.Default or {}
        local row = makeRow(opts, 60)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(0.48, 0, 0, 20), Font = theme.SmallFont, Text = opts.Title, TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local selected = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0), Size = UDim2.new(0.45, 0, 0, 30), Font = theme.Font, Text = "0 selected", TextSize = 12, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local hit = New("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false}, row)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6), ClipsDescendants = true, Visible = false, ZIndex = 20}, row)
        Corner(popup, theme.Radius)
        Stroke(popup, theme.Border, 0.15, 1)
        local search = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 30), PlaceholderText = "Search...", PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false}, popup)
        Corner(search, 7)
        Padding(search, 10, 10, 0, 0)
        local actions = New("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 44), Size = UDim2.new(1, -16, 0, 24)}, popup)
        local selectAll = New("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromOffset(70, 24), Text = "Select all", Font = theme.Font, TextSize = 11, TextColor3 = theme.Accent, AutoButtonColor = false}, actions)
        local clearAll = New("TextButton", {BackgroundTransparency = 1, Position = UDim2.fromOffset(74, 0), Size = UDim2.fromOffset(60, 24), Text = "Clear", Font = theme.Font, TextSize = 11, TextColor3 = theme.Muted, AutoButtonColor = false}, actions)
        local list = New("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 72), Size = UDim2.new(1, 0, 1, -72), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollBarThickness = 3, ZIndex = 21}, popup)
        Padding(list, 8, 8, 8, 8)
        New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, list)
        local comp = Component.new(self.Library, "MultiDropdown", row, {Value = values, Options = normalizeOptions(opts.Options), Title = title, Selected = selected, Popup = popup, Search = search, List = list, Open = false, Items = {}, Callback = opts.Callback})
        local function contains(tbl, value)
            for _, v in ipairs(tbl) do if v == value then return true end end
            return false
        end
        local function refreshText()
            selected.Text = tostring(#comp.Data.Value) .. " selected"
        end
        local function render()
            comp.DynamicConnections:Clear()
            for _, child in ipairs(list:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
            local filter = string.lower(search.Text or "")
            for _, item in ipairs(comp.Data.Options) do
                local label = tostring(item.Label or item.Value)
                if filter == "" or string.find(string.lower(label), filter, 1, true) then
                    local btn = New("TextButton", {BackgroundColor3 = contains(comp.Data.Value, item.Value) and self.Library.Theme.Surface or self.Library.Theme.Surface2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false, ZIndex = 22}, list)
                    Corner(btn, 6)
                    local mark = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.fromOffset(20, 32), Font = self.Library.Theme.TitleFont, Text = contains(comp.Data.Value, item.Value) and "✓" or "", TextSize = 13, TextColor3 = self.Library.Theme.Accent, ZIndex = 23}, btn)
                    local lbl = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -44, 1, 0), Font = self.Library.Theme.Font, Text = label, TextSize = 12, TextColor3 = item.Disabled and self.Library.Theme.Muted or self.Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23}, btn)
                    if not item.Disabled then
                        comp.DynamicConnections:Add(btn.Activated:Connect(function()
                            local nextValues = {}
                            local exists = false
                            for _, value in ipairs(comp.Data.Value) do
                                if value == item.Value then exists = true else table.insert(nextValues, value) end
                            end
                            if not exists then table.insert(nextValues, item.Value) end
                            comp.Data.Value = nextValues
                            refreshText()
                            render()
                            Fire(comp.Data.Callback, nextValues)
                        end))
                    end
                end
            end
        end
        function comp:Set(listValue)
            self.Data.Value = type(listValue) == "table" and CloneTable(listValue) or {}
            refreshText()
            render()
            Fire(comp.Data.Callback, self.Data.Value)
            return self
        end
        function comp:SelectAll()
            local all = {}
            for _, item in ipairs(self.Data.Options) do if not item.Disabled then table.insert(all, item.Value) end end
            return self:Set(all)
        end
        function comp:Clear()
            return self:Set({})
        end
        function comp:GetSelected()
            return CloneTable(self.Data.Value)
        end
        function comp:Select(value)
            local nextValues = CloneTable(self.Data.Value)
            if not contains(nextValues, value) then table.insert(nextValues, value) end
            return self:Set(nextValues)
        end
        function comp:Deselect(value)
            local nextValues = {}
            for _, item in ipairs(self.Data.Value) do if item ~= value then table.insert(nextValues, item) end end
            return self:Set(nextValues)
        end
        function comp:Toggle()
            self.Data.Open = not self.Data.Open
            popup.Visible = self.Data.Open
            if self.Data.Open then Tween(popup, {Size = UDim2.new(1, 0, 0, math.min(260, 92 + #self.Data.Options * 36))}, 0.18) end
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Selected.TextColor3 = t.Muted; render() end
        comp:AddConnection(hit.Activated:Connect(function() comp:Toggle() end))
        comp:AddConnection(selectAll.Activated:Connect(function() comp:SelectAll() end))
        comp:AddConnection(clearAll.Activated:Connect(function() comp:Clear() end))
        comp:AddConnection(search:GetPropertyChangedSignal("Text"):Connect(render))
        refreshText()
        render()
        return self:_add(comp)
    end

    function methods:CreateImageDropdown(opts)
        opts = opts or {}
        local row = makeRow(opts, 60)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(0.4, 0, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Title or "Image Dropdown"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local preview = New("ImageLabel", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(38, 38), Image = "", ScaleType = Enum.ScaleType.Crop}, row)
        Corner(preview, 8)
        Stroke(preview, theme.Border, 0.35, 1)
        local hit = New("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false}, row)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6), ClipsDescendants = true, Visible = false, ZIndex = 20}, row)
        Corner(popup, theme.Radius)
        Stroke(popup, theme.Border, 0.15, 1)
        local grid = New("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ZIndex = 21}, popup)
        Padding(grid, 10, 10, 10, 10)
        local gridLayout = New("UIGridLayout", {CellPadding = UDim2.fromOffset(8, 8), CellSize = UDim2.new(0.31, 0, 0, 72), SortOrder = Enum.SortOrder.LayoutOrder}, grid)
        local comp = Component.new(self.Library, "ImageDropdown", row, {Value = opts.Default, Options = normalizeOptions(opts.Options), Title = title, Preview = preview, Popup = popup, Grid = grid, Open = false, Callback = opts.Callback})
        local function render()
            comp.DynamicConnections:Clear()
            for _, child in ipairs(grid:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
            for _, item in ipairs(comp.Data.Options) do
                local card = New("TextButton", {BackgroundColor3 = self.Library.Theme.Surface2, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 22}, grid)
                Corner(card, 8)
                local image = New("ImageLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -14, 0, 42), Position = UDim2.fromOffset(7, 7), Image = tostring(item.Image or item.Icon or ""), ScaleType = Enum.ScaleType.Crop, ZIndex = 23}, card)
                Corner(image, 6)
                local lbl = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 7, 1, -23), Size = UDim2.new(1, -14, 0, 18), Font = self.Library.Theme.Font, Text = tostring(item.Label or item.Value), TextSize = 10, TextColor3 = self.Library.Theme.Text, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 23}, card)
                if not item.Disabled then comp.DynamicConnections:Add(card.Activated:Connect(function() comp:Set(item.Value); popup.Visible = false; comp.Data.Open = false end)) end
            end
        end
        function comp:Set(value, silent)
            self.Data.Value = value
            for _, item in ipairs(self.Data.Options) do if item.Value == value then self.Data.Preview.Image = tostring(item.Image or item.Icon or ""); break end end
            if not silent then Fire(comp.Data.Callback, value) end
            return self
        end
        function comp:Toggle()
            self.Data.Open = not self.Data.Open
            popup.Visible = self.Data.Open
            if self.Data.Open then Tween(popup, {Size = UDim2.new(1, 0, 0, 170)}, 0.18) end
            return self
        end
        function comp:SetOptions(items)
            self.Data.Options = normalizeOptions(items)
            render()
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; render() end
        comp:AddConnection(hit.Activated:Connect(function() comp:Toggle() end))
        render()
        if opts.Default ~= nil then comp:Set(opts.Default, true) end
        return self:_add(comp)
    end

    function methods:CreateSlider(opts)
        opts = opts or {}
        local minValue = tonumber(opts.Min) or 0
        local maxValue = tonumber(opts.Max) or 100
        local increment = tonumber(opts.Increment) or 1
        local default = Clamp(tonumber(opts.Default) or minValue, minValue, maxValue)
        local row = makeRow(opts, 68)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 7), Size = UDim2.new(0.65, 0, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Title or "Slider"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local valueLabel = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 7), Size = UDim2.fromOffset(90, 20), Font = theme.Font, Text = FormatValue(default, opts.Decimals), TextSize = 12, TextColor3 = theme.Accent, TextXAlignment = Enum.TextXAlignment.Right}, row)
        local bar = New("Frame", {BackgroundColor3 = theme.Border, BorderSizePixel = 0, Position = UDim2.new(0, 14, 0, 40), Size = UDim2.new(1, -28, 0, 5)}, row)
        Corner(bar, 5)
        local fill = New("Frame", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Size = UDim2.fromScale((default - minValue) / math.max(maxValue - minValue, 0.00001), 1)}, bar)
        Corner(fill, 5)
        local knob = New("Frame", {BackgroundColor3 = theme.Text, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((default - minValue) / math.max(maxValue - minValue, 0.00001), 0, 0.5, 0), Size = UDim2.fromOffset(14, 14), ZIndex = 3}, bar)
        Corner(knob, 7)
        local hit = New("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 14, 1, 18), Position = UDim2.fromOffset(-7, -9), Text = "", AutoButtonColor = false, ZIndex = 4}, bar)
        local comp = Component.new(self.Library, "Slider", row, {Value = default, Min = minValue, Max = maxValue, Increment = increment, Title = title, ValueLabel = valueLabel, Bar = bar, Fill = fill, Knob = knob, Callback = opts.Callback})
        local dragging = false
        local function setFromX(x)
            local alpha = Clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
            local value = minValue + (maxValue - minValue) * alpha
            value = Clamp(Round(value, increment), minValue, maxValue)
            comp.Data.Value = value
            local pct = (value - minValue) / math.max(maxValue - minValue, 0.00001)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            valueLabel.Text = FormatValue(value, opts.Decimals)
            Fire(comp.Data.Callback, value)
        end
        function comp:Set(value)
            value = Clamp(Round(tonumber(value) or minValue, increment), minValue, maxValue)
            setFromX(bar.AbsolutePosition.X + ((value - minValue) / math.max(maxValue - minValue, 0.00001)) * bar.AbsoluteSize.X)
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.ValueLabel.TextColor3 = t.Accent; c.Data.Fill.BackgroundColor3 = t.Accent; c.Data.Bar.BackgroundColor3 = t.Border end
        comp:AddConnection(hit.MouseButton1Down:Connect(function(x) dragging = true; setFromX(x) end))
        comp:AddConnection(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setFromX(input.Position.X) end
        end))
        comp:AddConnection(UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end))
        return self:_add(comp)
    end

    function methods:CreateInput(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 58)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 6), Size = UDim2.new(0.36, 0, 0, 18), Font = theme.SmallFont, Text = tostring(opts.Title or "Input"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local box = New("TextBox", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0.52, 0, 0, 34), PlaceholderText = tostring(opts.Placeholder or "Enter value..."), PlaceholderColor3 = theme.Muted, Text = tostring(opts.Default or ""), TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left}, row)
        Corner(box, 7)
        Stroke(box, theme.Border, 0.35, 1)
        Padding(box, 10, 10, 0, 0)
        local comp = Component.new(self.Library, "Input", row, {Value = box.Text, Title = title, Box = box, Callback = opts.Callback})
        function comp:Set(value)
            self.Data.Value = tostring(value or "")
            self.Data.Box.Text = self.Data.Value
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Box.BackgroundColor3 = t.Surface; c.Data.Box.TextColor3 = t.Text; c.Data.Box.PlaceholderColor3 = t.Muted end
        comp:AddConnection(box.FocusLost:Connect(function() self.Data.Value = box.Text; Fire(comp.Data.Callback, box.Text) end))
        return self:_add(comp)
    end

    function methods:CreateKeybind(opts)
        opts = opts or {}
        local row = makeRow(opts, 56)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(0.55, 0, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Title or "Keybind"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local keyButton = New("TextButton", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(76, 32), Text = tostring(opts.Default or "None"), Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Text, AutoButtonColor = false}, row)
        Corner(keyButton, 7)
        Stroke(keyButton, theme.Border, 0.35, 1)
        local comp = Component.new(self.Library, "Keybind", row, {Value = opts.Default, Title = title, Button = keyButton, Listening = false, Callback = opts.Callback})
        function comp:Set(value)
            self.Data.Value = value
            self.Data.Button.Text = tostring(value or "None")
            Fire(comp.Data.Callback, value)
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Button.BackgroundColor3 = t.Surface; c.Data.Button.TextColor3 = t.Text end
        comp:AddConnection(keyButton.Activated:Connect(function()
            comp.Data.Listening = true
            keyButton.Text = "Press key"
        end))
        comp:AddConnection(UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if comp.Data.Listening then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    comp.Data.Listening = false
                    comp:Set(input.KeyCode.Name)
                end
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == tostring(comp.Data.Value) then
                Fire(comp.Data.Callback, comp.Data.Value, true)
            end
        end))
        return self:_add(comp)
    end

    function methods:CreateColorPicker(opts)
        opts = opts or {}
        local row = makeRow(opts, 56)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(0.56, 0, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Title or "Color Picker"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local preview = New("TextButton", {BackgroundColor3 = opts.Default or theme.Accent, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(64, 30), Text = "", AutoButtonColor = false}, row)
        Corner(preview, 7)
        Stroke(preview, theme.Border, 0.35, 1)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.fromOffset(270, 140), Position = UDim2.new(1, -270, 1, 7), Visible = false, ZIndex = 30}, row)
        Corner(popup, theme.Radius)
        Stroke(popup, theme.Border, 0.1, 1)
        local hexLabel = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(30, 24), Font = theme.SmallFont, Text = "Hex", TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 31}, popup)
        local hex = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(48, 8), Size = UDim2.fromOffset(210, 28), PlaceholderText = "#8F78FF", PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 11, ClearTextOnFocus = false, ZIndex = 31}, popup)
        Corner(hex, 6)
        Padding(hex, 8, 8, 0, 0)
        local rgb = {}
        local letters = {"R", "G", "B"}
        for i, letter in ipairs(letters) do
            local label = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12 + (i - 1) * 84, 44), Size = UDim2.fromOffset(18, 22), Font = theme.SmallFont, Text = letter, TextSize = 11, TextColor3 = theme.Muted, ZIndex = 31}, popup)
            local box = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(30 + (i - 1) * 84, 42), Size = UDim2.fromOffset(48, 26), Text = "0", TextColor3 = theme.Text, Font = theme.Font, TextSize = 11, ClearTextOnFocus = false, ZIndex = 31}, popup)
            Corner(box, 6)
            Padding(box, 6, 6, 0, 0)
            rgb[i] = box
        end
        local apply = New("TextButton", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 82), Size = UDim2.fromOffset(246, 40), Text = "Apply", Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Text, AutoButtonColor = false, ZIndex = 31}, popup)
        Corner(apply, 7)
        local comp = Component.new(self.Library, "ColorPicker", row, {Value = opts.Default or theme.Accent, Title = title, Preview = preview, Popup = popup, Hex = hex, RGB = rgb, Open = false, Callback = opts.Callback})
        local function toHex(value) return ColorToHex(value) end
        local function fromHex(value) return HexToColor(value) end
        local function renderInputs(value)
            local r, g, b = math.floor(value.R * 255 + 0.5), math.floor(value.G * 255 + 0.5), math.floor(value.B * 255 + 0.5)
            rgb[1].Text, rgb[2].Text, rgb[3].Text = tostring(r), tostring(g), tostring(b)
            hex.Text = toHex(value)
        end
        function comp:Set(value)
            if typeof(value) ~= "Color3" then return self end
            self.Data.Value = value
            self.Data.Preview.BackgroundColor3 = value
            renderInputs(value)
            Fire(comp.Data.Callback, value)
            return self
        end
        function comp:Toggle()
            self.Data.Open = not self.Data.Open
            self.Data.Popup.Visible = self.Data.Open
            return self
        end
        function comp:Open() self.Data.Open = true; self.Data.Popup.Visible = true; return self end
        function comp:Close() self.Data.Open = false; self.Data.Popup.Visible = false; return self end
        local function applyFromInputs()
            local color = fromHex(hex.Text)
            if not color then
                local r = Clamp(tonumber(rgb[1].Text) or 0, 0, 255)
                local g = Clamp(tonumber(rgb[2].Text) or 0, 0, 255)
                local b = Clamp(tonumber(rgb[3].Text) or 0, 0, 255)
                color = Color3.fromRGB(r, g, b)
            end
            comp:Set(color)
            comp:Close()
        end
        comp.ApplyTheme = function(c, t)
            c.Data.Title.TextColor3 = t.Text
            c.Data.Preview.BackgroundColor3 = c.Data.Value
            local previewStroke = c.Data.Preview:FindFirstChildOfClass("UIStroke")
            if previewStroke then previewStroke.Color = t.Border end
            c.Data.Popup.BackgroundColor3 = t.Surface
            c.Data.Hex.BackgroundColor3 = t.Surface2
            c.Data.Hex.TextColor3 = t.Text
            for _, box in ipairs(c.Data.RGB) do
                box.TextColor3 = t.Text
                box.BackgroundColor3 = t.Surface2
            end
            local popupStroke = c.Data.Popup:FindFirstChildOfClass("UIStroke")
            if popupStroke then popupStroke.Color = t.Border end
            local applyButton = c.Data.Popup:FindFirstChild("TextButton")
            if applyButton then applyButton.BackgroundColor3 = t.Accent; applyButton.TextColor3 = t.Text end
        end
        comp:AddConnection(preview.Activated:Connect(function() comp:Toggle() end))
        comp:AddConnection(apply.Activated:Connect(applyFromInputs))
        comp:AddConnection(hex.FocusLost:Connect(function() local value = fromHex(hex.Text); if value then comp:Set(value) end end))
        for _, box in ipairs(rgb) do comp:AddConnection(box.FocusLost:Connect(function() local r = Clamp(tonumber(rgb[1].Text) or 0, 0, 255); local g = Clamp(tonumber(rgb[2].Text) or 0, 0, 255); local b = Clamp(tonumber(rgb[3].Text) or 0, 0, 255); comp:Set(Color3.fromRGB(r, g, b)) end)) end
        renderInputs(comp.Data.Value)
        return self:_add(comp)
    end

    function methods:CreateImage(opts)
        opts = opts or {}
        local row = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, opts.Height or 160)}, page)
        local image = New("ImageLabel", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Image = tostring(opts.Image or ""), ScaleType = opts.ScaleType or Enum.ScaleType.Crop}, row)
        Corner(image, theme.Radius)
        Stroke(image, theme.Border, 0.35, 1)
        local overlay = New("TextLabel", {BackgroundTransparency = 0.28, BackgroundColor3 = theme.Overlay, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 34), Position = UDim2.new(0, 0, 1, -34), Font = theme.SmallFont, Text = tostring(opts.Caption or ""), TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        Padding(overlay, 10, 10, 0, 0)
        Corner(overlay, theme.Radius)
        local comp = Component.new(self.Library, "Image", row, {Value = opts.Image, Image = image, Caption = overlay})
        function comp:Set(value) self.Data.Value = value; self.Data.Image.Image = tostring(value or ""); return self end
        comp.ApplyTheme = function(c, t) c.Data.Image.BackgroundColor3 = t.Surface2; c.Data.Caption.BackgroundColor3 = t.Overlay; c.Data.Caption.TextColor3 = t.Text end
        return self:_add(comp)
    end

    function methods:CreateAvatar(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 64)
        local avatar = New("ImageLabel", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(48, 48), Image = tostring(opts.Image or ""), ScaleType = Enum.ScaleType.Crop}, row)
        Corner(avatar, 24)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(72, 9), Size = UDim2.new(1, -84, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Name or "User"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local status = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(72, 30), Size = UDim2.new(1, -84, 0, 18), Font = theme.Font, Text = tostring(opts.Status or "Online"), TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local comp = Component.new(self.Library, "Avatar", row, {Value = opts.Image, Image = avatar, Title = title, Status = status})
        function comp:Set(value) self.Data.Value = tostring(value); self.Data.Image.Image = self.Data.Value; return self end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Status.TextColor3 = t.Muted; c.Data.Image.BackgroundColor3 = t.Surface2 end
        return self:_add(comp)
    end

    function methods:CreateCard(opts)
        opts = opts or {}
        local height = opts.Height or 100
        local card = makeRow(opts, height)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 10), Size = UDim2.new(1, -28, 0, 22), Font = theme.TitleFont, Text = tostring(opts.Title or "Card"), TextSize = 14, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, card)
        local body = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 35), Size = UDim2.new(1, -28, 1, -46), Font = theme.Font, Text = tostring(opts.Description or opts.Content or ""), TextSize = 11, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, card)
        local comp = Component.new(self.Library, "Card", card, {Title = title, Content = body, Value = body.Text})
        function comp:Set(value) self.Data.Value = tostring(value or ""); self.Data.Content.Text = self.Data.Value; return self end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Content.TextColor3 = t.Muted end
        return self:_add(comp)
    end

    function methods:CreateLoading(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 54)
        local spinner = New("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(14, 14)}, row)
        local ring = New("UIGradient", {Rotation = 25, Color = ColorSequence.new(theme.Accent, theme.Accent2)}, spinner)
        New("UIStroke", {Color = theme.Accent, Thickness = 3, Transparency = 0.15}, spinner)
        Corner(spinner, 20)
        local label = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 0), Size = UDim2.new(1, -66, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Text or "Loading..."), TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local comp = Component.new(self.Library, "Loading", row, {Value = true, Spinner = spinner, Label = label, Enabled = true})
        local rotation = 0
        comp:AddConnection(game:GetService("RunService").Heartbeat:Connect(function(delta)
            if comp.Data.Value and spinner.Parent then rotation += delta * 240; spinner.Rotation = rotation end
        end))
        function comp:Set(value) self.Data.Value = value == true; row.Visible = self.Data.Value; return self end
        comp.ApplyTheme = function(c, t)
            c.Data.Label.TextColor3 = t.Text
            local spinnerStroke = c.Data.Spinner:FindFirstChildOfClass("UIStroke")
            if spinnerStroke then spinnerStroke.Color = t.Accent end
        end
        return self:_add(comp)
    end

    function methods:CreateProgress(opts)
        opts = opts or {}
        local minValue = tonumber(opts.Min) or 0
        local maxValue = tonumber(opts.Max) or 100
        local value = Clamp(tonumber(opts.Default or opts.Value) or minValue, minValue, maxValue)
        local row = makeRow(opts, opts.Height or 62)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(0.65, 0, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Title or "Progress"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local valueLabel = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 8), Size = UDim2.fromOffset(84, 20), Font = theme.Font, Text = FormatValue(value, opts.Decimals), TextSize = 11, TextColor3 = theme.Accent, TextXAlignment = Enum.TextXAlignment.Right}, row)
        local bar = New("Frame", {BackgroundColor3 = theme.Border, BorderSizePixel = 0, Position = UDim2.new(0, 14, 0, 40), Size = UDim2.new(1, -28, 0, 7)}, row)
        Corner(bar, 5)
        local fill = New("Frame", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Size = UDim2.new((value - minValue) / math.max(maxValue - minValue, 0.00001), 0, 1, 0)}, bar)
        Corner(fill, 5)
        local comp = Component.new(self.Library, "Progress", row, {Value = value, Min = minValue, Max = maxValue, Title = title, ValueLabel = valueLabel, Bar = bar, Fill = fill, Callback = opts.Callback})
        local function render(animated)
            local pct = (comp.Data.Value - minValue) / math.max(maxValue - minValue, 0.00001)
            local props = {Size = UDim2.new(pct, 0, 1, 0)}
            if animated then Tween(fill, props, opts.Duration or 0.22) else fill.Size = props.Size end
            valueLabel.Text = FormatValue(comp.Data.Value, opts.Decimals)
        end
        function comp:Set(nextValue, silent)
            self.Data.Value = Clamp(tonumber(nextValue) or minValue, minValue, maxValue)
            render(true)
            if not silent then Fire(comp.Data.Callback, self.Data.Value) end
            return self
        end
        function comp:SetRange(nextMin, nextMax)
            minValue = tonumber(nextMin) or minValue
            maxValue = tonumber(nextMax) or maxValue
            self.Data.Min, self.Data.Max = minValue, maxValue
            return self:Set(self.Data.Value, true)
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.ValueLabel.TextColor3 = t.Accent; c.Data.Bar.BackgroundColor3 = t.Border; c.Data.Fill.BackgroundColor3 = t.Accent end
        render(false)
        return self:_add(comp)
    end

    function methods:CreateStatus(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 50)
        local dot = New("Frame", {BackgroundColor3 = theme.Success, BorderSizePixel = 0, Position = UDim2.fromOffset(14, 18), Size = UDim2.fromOffset(10, 10)}, row)
        Corner(dot, 5)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(32, 7), Size = UDim2.new(1, -46, 0, 18), Font = theme.SmallFont, Text = tostring(opts.Title or "Status"), TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local description = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(32, 26), Size = UDim2.new(1, -46, 0, 16), Font = theme.Font, Text = tostring(opts.Description or opts.Text or "Ready"), TextSize = 10, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local comp = Component.new(self.Library, "Status", row, {Value = opts.State or "Success", Title = title, Description = description, Dot = dot, Callback = opts.Callback})
        local function tone(state)
            local stateName = string.lower(tostring(state or "Success"))
            if stateName == "danger" or stateName == "error" then return self.Library.Theme.Danger end
            if stateName == "warning" then return self.Library.Theme.Warning end
            if stateName == "info" then return self.Library.Theme.Accent2 end
            return self.Library.Theme.Success
        end
        function comp:Set(state, text)
            self.Data.Value = state
            if text ~= nil then self.Data.Description.Text = tostring(text) end
            self.Data.Dot.BackgroundColor3 = tone(state)
            Fire(comp.Data.Callback, state, text)
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Description.TextColor3 = t.Muted; c.Data.Dot.BackgroundColor3 = tone(c.Data.Value) end
        comp.Data.Dot.BackgroundColor3 = tone(comp.Data.Value)
        return self:_add(comp)
    end

    function methods:CreateBadge(opts)
        opts = opts or {}
        local row = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, opts.Height or 34), LayoutOrder = opts.LayoutOrder or 0}, page)
        local badge = New("TextLabel", {BackgroundColor3 = opts.BackgroundColor or theme.AccentSoft or theme.Surface3, BorderSizePixel = 0, Size = UDim2.fromOffset(opts.Width or 90, 24), Position = UDim2.fromOffset(2, 5), Font = theme.SmallFont, Text = tostring(opts.Text or opts.Title or "Badge"), TextSize = 10, TextColor3 = opts.TextColor or theme.Text, TextXAlignment = Enum.TextXAlignment.Center}, row)
        Corner(badge, 7)
        local comp = Component.new(self.Library, "Badge", row, {Value = badge.Text, Badge = badge})
        function comp:Set(value) self.Data.Value = tostring(value or ""); self.Data.Badge.Text = self.Data.Value; return self end
        function comp:SetColors(background, textColor)
            if typeof(background) == "Color3" then self.Data.Badge.BackgroundColor3 = background end
            if typeof(textColor) == "Color3" then self.Data.Badge.TextColor3 = textColor end
            return self
        end
        comp.ApplyTheme = function(c, t) if not opts.BackgroundColor then c.Data.Badge.BackgroundColor3 = t.AccentSoft or t.Surface3 end; if not opts.TextColor then c.Data.Badge.TextColor3 = t.Text end end
        return self:_add(comp)
    end

    function methods:CreateKeyValue(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 48)
        local key = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(0.46, 0, 1, 0), Font = theme.Font, Text = tostring(opts.Key or opts.Title or "Key"), TextSize = 12, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local value = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 0), Size = UDim2.new(0.48, 0, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Value or "—"), TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local comp = Component.new(self.Library, "KeyValue", row, {Value = opts.Value, Key = key, ValueLabel = value})
        function comp:Set(nextValue) self.Data.Value = nextValue; self.Data.ValueLabel.Text = tostring(nextValue or "—"); return self end
        function comp:SetKey(nextKey) self.Data.Key.Text = tostring(nextKey or ""); return self end
        comp.ApplyTheme = function(c, t) c.Data.Key.TextColor3 = t.Muted; c.Data.ValueLabel.TextColor3 = t.Text end
        return self:_add(comp)
    end

    function methods:CreateAlert(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 74)
        local kind = string.lower(tostring(opts.Type or "Info"))
        local tone = kind == "success" and theme.Success or kind == "warning" and theme.Warning or (kind == "danger" or kind == "error") and theme.Danger or theme.Accent2
        local stripe = New("Frame", {BackgroundColor3 = tone, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 7), Size = UDim2.new(0, 3, 1, -14)}, row)
        Corner(stripe, 2)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 9), Size = UDim2.new(1, -28, 0, 20), Font = theme.TitleFont, Text = tostring(opts.Title or "Alert"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local body = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 31), Size = UDim2.new(1, -28, 1, -39), Font = theme.Font, Text = tostring(opts.Description or opts.Content or ""), TextSize = 11, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, row)
        local comp = Component.new(self.Library, "Alert", row, {Value = kind, Title = title, Description = body, Stripe = stripe})
        function comp:Set(state, text)
            self.Data.Value = string.lower(tostring(state or "Info"))
            if text ~= nil then self.Data.Description.Text = tostring(text) end
            self.Data.Stripe.BackgroundColor3 = (self.Data.Value == "success" and self.Library.Theme.Success) or (self.Data.Value == "warning" and self.Library.Theme.Warning) or (self.Data.Value == "danger" or self.Data.Value == "error") and self.Library.Theme.Danger or self.Library.Theme.Accent2
            return self
        end
        comp.ApplyTheme = function(c, t)
            c.Data.Title.TextColor3 = t.Text
            c.Data.Description.TextColor3 = t.Muted
            local state = c.Data.Value
            c.Data.Stripe.BackgroundColor3 = (state == "success" and t.Success) or (state == "warning" and t.Warning) or (state == "danger" or state == "error") and t.Danger or t.Accent2
        end
        return self:_add(comp)
    end


    function methods:CreateTag(opts)
        opts = opts or {}
        local row = New("Frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, opts.Height or 38),
            LayoutOrder = opts.LayoutOrder or 0
        }, page)
        local color = opts.Color or self.Library.Theme.Accent
        local pill = New("Frame", {
            BackgroundColor3 = color,
            BackgroundTransparency = opts.Transparency ~= nil and opts.Transparency or 0.76,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, 4),
            Size = UDim2.fromOffset(120, 28)
        }, row)
        Corner(pill, 14)
        Stroke(pill, color, 0.35, 1)
        local icon = CreateIcon(pill, opts.Icon, 14, color)
        local text = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(opts.Icon and 30 or 10, 0),
            Size = UDim2.new(1, opts.Icon and -38 or -20, 1, 0),
            Font = self.Library.Theme.SmallFont,
            Text = tostring(opts.Text or opts.Title or "Tag"),
            TextSize = opts.TextSize or 11,
            TextColor3 = opts.TextColor or self.Library.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, pill)
        if opts.Icon and icon and icon:IsA("TextLabel") then
            icon.TextColor3 = color
        end
        local textBounds = TextService:GetTextSize(text.Text, text.TextSize, text.Font, Vector2.new(500, 24))
        local width = math.clamp(textBounds.X + (opts.Icon and 42 or 22), 56, 260)
        pill.Size = UDim2.fromOffset(opts.Width or width, 28)
        local comp = Component.new(self.Library, "Tag", row, {Value = text.Text, Pill = pill, Label = text, Icon = icon, Color = color, Height = opts.Height or 38})
        function comp:Set(value)
            self.Data.Value = tostring(value or "")
            self.Data.Label.Text = self.Data.Value
            return self
        end
        function comp:SetColor(value)
            if typeof(value) ~= "Color3" then return self end
            self.Data.Color = value
            self.Data.Pill.BackgroundColor3 = value
            local stroke = self.Data.Pill:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = value end
            if self.Data.Icon then
                if self.Data.Icon:IsA("ImageLabel") then self.Data.Icon.ImageColor3 = value end
                if self.Data.Icon:IsA("TextLabel") then self.Data.Icon.TextColor3 = value end
            end
            return self
        end
        function comp:SetIcon(value)
            if self.Data.Icon then self.Data.Icon:Destroy() end
            self.Data.Icon = CreateIcon(self.Data.Pill, value, 14, self.Data.Color)
            self.Data.Label.Position = UDim2.fromOffset(value and 30 or 10, 0)
            self.Data.Label.Size = UDim2.new(1, value and -38 or -20, 1, 0)
            return self
        end
        comp.ApplyTheme = function(c, t)
            c.Data.Label.TextColor3 = opts.TextColor or t.Text
            local colorValue = c.Data.Color or t.Accent
            c.Data.Pill.BackgroundColor3 = colorValue
            local stroke = c.Data.Pill:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = colorValue end
        end
        return self:_add(comp)
    end

    function methods:CreateConfigPanel(opts)
        opts = opts or {}
        local section = self:CreateSection({Title = opts.Title or "Configurations", Description = opts.Description or "Save and load named profiles."})
        local nameInput = self:CreateInput({Title = "Config name", Placeholder = "Profile name", Default = opts.DefaultName or "IrisHubConfig"})
        local manager = self.Library:CreateConfigManager(opts.DefaultName or "IrisHubConfig")
        nameInput:SetCallback(function(value) manager:SetName(value) end)
        local save = self:CreateButton({Title = "Save configuration", Icon = "lucide:save", Callback = function()
            local ok, result = manager:Save()
            if opts.OnSave then Fire(opts.OnSave, ok, result, manager.Name) end
        end})
        local load = self:CreateButton({Title = "Load configuration", Icon = "lucide:download", Callback = function()
            local ok, result = manager:Load(opts.OnLoad)
            if opts.OnLoadResult then Fire(opts.OnLoadResult, ok, result, manager.Name) end
        end})
        local remove = self:CreateButton({Title = "Delete configuration", Icon = "lucide:trash", Callback = function()
            local ok, result = manager:Delete()
            if opts.OnDelete then Fire(opts.OnDelete, ok, result, manager.Name) end
        end})
        return {Section = section, Input = nameInput, Manager = manager, Save = save, Load = load, Delete = remove}
    end

    function methods:CreateCodeBlock(opts)
        opts = opts or {}
        local code = tostring(opts.Code or opts.Text or "")
        local row = makeRow(opts, opts.Height or math.max(82, 38 + select(2, code:gsub("\n", "")) * 12))
        local language = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 6), Size = UDim2.new(0.5, 0, 0, 16), Font = theme.SmallFont, Text = tostring(opts.Language or "code"), TextSize = 9, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local copy = New("TextButton", {BackgroundColor3 = theme.Surface3 or theme.Surface2, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 5), Size = UDim2.fromOffset(60, 22), Text = "Copy", Font = theme.SmallFont, TextSize = 9, TextColor3 = theme.Text, AutoButtonColor = false}, row)
        Corner(copy, 6)
        local body = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 30), Size = UDim2.new(1, -24, 1, -36), Font = Enum.Font.Code, Text = code, TextSize = opts.TextSize or 11, TextColor3 = theme.Text, TextWrapped = false, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, RichText = false}, row)
        local comp = Component.new(self.Library, "CodeBlock", row, {Value = code, Language = language, Copy = copy, Code = body})
        function comp:Set(value) self.Data.Value = tostring(value or ""); self.Data.Code.Text = self.Data.Value; return self end
        function comp:Copy() return CopyText(self.Data.Value) end
        function comp:SetLanguage(value) self.Data.Language.Text = tostring(value or "code"); return self end
        comp.ApplyTheme = function(c, t) c.Data.Language.TextColor3 = t.Muted; c.Data.Copy.BackgroundColor3 = t.Surface3 or t.Surface2; c.Data.Copy.TextColor3 = t.Text; c.Data.Code.TextColor3 = t.Text end
        comp:AddConnection(copy.Activated:Connect(function()
            local copied = comp:Copy()
            copy.Text = copied and "Copied" or "Copy"
            task.delay(0.9, function() if copy.Parent then copy.Text = "Copy" end end)
            Fire(opts.OnCopy, copied, comp.Data.Value)
        end))
        return self:_add(comp)
    end

    function methods:CreateContextMenu(opts)
        opts = opts or {}
        local trigger = makeRow(opts, opts.Height or 48)
        local label = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Title or "Context Menu"), TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, trigger)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.fromOffset(220, 0), Position = UDim2.new(0, 0, 1, 6), Visible = false, ClipsDescendants = true, ZIndex = 40}, trigger)
        Corner(popup, theme.Radius)
        Stroke(popup, theme.Border, 0.1, 1)
        local list = New("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, popup)
        Padding(popup, 7, 7, 7, 7)
        local comp = Component.new(self.Library, "ContextMenu", trigger, {Value = false, Trigger = trigger, Popup = popup, Title = label, Items = opts.Items or {}, Open = false})
        local function render()
            comp.DynamicConnections:Clear()
            for _, child in ipairs(popup:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
            for _, item in ipairs(comp.Data.Items) do
                local button = New("TextButton", {BackgroundColor3 = self.Library.Theme.Surface2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 30), Text = tostring(item.Title or item.Label or "Item"), Font = self.Library.Theme.Font, TextSize = 11, TextColor3 = item.Disabled and self.Library.Theme.Muted or self.Library.Theme.Text, AutoButtonColor = false, ZIndex = 41}, popup)
                Corner(button, 6)
                Padding(button, 9, 9, 0, 0)
                if not item.Disabled then comp.DynamicConnections:Add(button.Activated:Connect(function() Fire(item.Callback); comp:Close() end)) end
            end
        end
        function comp:Open() self.Data.Open = true; self.Data.Popup.Visible = true; Tween(self.Data.Popup, {Size = UDim2.fromOffset(220, math.min(240, 14 + #self.Data.Items * 34))}, 0.16); return self end
        function comp:Close() self.Data.Open = false; self.Data.Popup.Visible = false; return self end
        function comp:Toggle() if self.Data.Open then return self:Close() end return self:Open() end
        function comp:SetItems(items) self.Data.Items = items or {}; render(); return self end
        comp.ApplyTheme = function(c, t) c.Data.Trigger.BackgroundColor3 = t.Surface2; c.Data.Title.TextColor3 = t.Text; c.Data.Popup.BackgroundColor3 = t.Surface; local stroke = c.Data.Popup:FindFirstChildOfClass("UIStroke"); if stroke then stroke.Color = t.Border end; render() end
        comp:AddConnection(trigger.Activated:Connect(function() comp:Toggle() end))
        comp:AddConnection(trigger.SecondaryActivated:Connect(function() comp:Toggle() end))
        render()
        return self:_add(comp)
    end

    function methods:CreateTooltip(opts)
        opts = opts or {}
        local target = opts.Target
        if type(target) == "table" and target.Instance then target = target.Instance end
        if not target then
            target = makeRow(opts, 42)
            local targetLabel = New("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -24, 1, 0), Position = UDim2.fromOffset(12, 0), Font = theme.Font, Text = tostring(opts.TargetText or "Hover me"), TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left}, target)
        end
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.fromOffset(220, 0), Visible = false, ZIndex = 90, AutomaticSize = Enum.AutomaticSize.Y}, self.Library.Gui)
        Corner(popup, theme.Radius - 2)
        Stroke(popup, theme.Border, 0.1, 1)
        local body = New("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 0), Position = UDim2.fromOffset(10, 8), AutomaticSize = Enum.AutomaticSize.Y, Font = theme.Font, Text = tostring(opts.Text or opts.Description or "Tooltip"), TextSize = 11, TextColor3 = theme.Text, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 91}, popup)
        Padding(popup, 10, 10, 8, 8)
        local controller = {Instance = popup, Target = target, Visible = false, Connections = ConnectionBag.new()}
        function controller:Show()
            if self.Visible then return self end
            local position = target.AbsolutePosition
            local size = target.AbsoluteSize
            popup.Position = UDim2.fromOffset(position.X, position.Y + size.Y + 8)
            popup.Visible = true
            self.Visible = true
            Tween(popup, {BackgroundTransparency = 0}, 0.12)
            return self
        end
        function controller:Hide()
            popup.Visible = false
            self.Visible = false
            return self
        end
        function controller:Destroy()
            self.Connections:Clear()
            pcall(function() popup:Destroy() end)
        end
        controller.Connections:Add(target.MouseEnter:Connect(function() controller:Show() end))
        controller.Connections:Add(target.MouseLeave:Connect(function() controller:Hide() end))
        return controller
    end

    function methods:CreateSearch(opts)
        opts = opts or {}
        local row = makeRow(opts, opts.Height or 48)
        local box = New("TextBox", {BackgroundTransparency = 1, Size = UDim2.new(1, -28, 1, 0), Position = UDim2.fromOffset(14, 0), PlaceholderText = tostring(opts.Placeholder or "Search"), PlaceholderColor3 = theme.Muted, Text = "", TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local comp = Component.new(self.Library, "Search", row, {Value = "", Box = box, Callback = opts.Callback})
        function comp:Set(value) self.Data.Value = tostring(value or ""); self.Data.Box.Text = self.Data.Value; Fire(comp.Data.Callback, self.Data.Value); return self end
        comp:AddConnection(box:GetPropertyChangedSignal("Text"):Connect(function() comp.Data.Value = box.Text; Fire(comp.Data.Callback, box.Text) end))
        comp.ApplyTheme = function(c, t) c.Data.Box.TextColor3 = t.Text; c.Data.Box.PlaceholderColor3 = t.Muted end
        return self:_add(comp)
    end

    self.Tabs[proxy.Name] = proxy
    table.insert(self.Library.WindowOrder, proxy)
    self.TabList.CanvasSize = UDim2.new()
    if not self.ActiveTab then proxy:SetActive(true) end
    return proxy
end

function IrisHub:CreateWindow(options)
    options = options or {}
    local theme = self.Theme
    local root = New("CanvasGroup", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = true}, self.Gui)
    local main = New("Frame", {
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = options.Position or UDim2.fromScale(0.5, 0.5),
        Size = options.Size or UDim2.fromOffset(720, 500),
        ClipsDescendants = false,
        ZIndex = 10
    }, root)
    local shadow = CreateShadow(main, theme.ShadowTransparency or 0.8)
    Corner(main, theme.Radius + 2)
    local outline = Stroke(main, theme.Border, 0.12, 1)
    local gradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Surface3),
            ColorSequenceKeypoint.new(0.18, theme.Surface),
            ColorSequenceKeypoint.new(1, theme.Surface)
        }),
        Rotation = 90
    }, main)
    local minSize = options.MinSize or Vector2.new(520, 360)
    local maxSize = options.MaxSize or Vector2.new(1600, 1000)
    New("UISizeConstraint", {MinSize = minSize, MaxSize = maxSize}, main)

    local top = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 68), ZIndex = 20}, main)
    local brand = New("Frame", {
        BackgroundColor3 = theme.AccentSoft,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(18, 16),
        Size = UDim2.fromOffset(34, 34),
        ZIndex = 21
    }, top)
    Corner(brand, 10)
    Stroke(brand, theme.Accent, 0.35, 1)
    local brandText = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = theme.TitleFont,
        Text = "I",
        TextSize = 17,
        TextColor3 = theme.Text,
        TextTransparency = options.Icon and 1 or 0,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 22
    }, brand)
    local brandIcon = CreateIcon(brand, options.Icon or "lucide:sparkles", 18, theme.Text)
    if brandIcon then
        brandIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        brandIcon.Position = UDim2.fromScale(0.5, 0.5)
        brandIcon.ZIndex = 23
    end
    local title = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(62, 13),
        Size = UDim2.new(1, -215, 0, 24),
        Font = theme.TitleFont,
        Text = tostring(options.Title or "IrisHub"),
        TextSize = 18,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    }, top)
    local subtitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(63, 38),
        Size = UDim2.new(1, -220, 0, 16),
        Font = theme.Font,
        Text = tostring(options.Subtitle or "Universal interface"),
        TextSize = 10,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    }, top)
    local statusDot = New("Frame", {
        BackgroundColor3 = theme.Success,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(63, 56),
        Size = UDim2.fromOffset(6, 6),
        ZIndex = 21
    }, top)
    Corner(statusDot, 3)
    local statusText = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(76, 51),
        Size = UDim2.fromOffset(92, 16),
        Font = theme.Font,
        Text = "READY",
        TextSize = 8,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    }, top)
    local breadcrumb = New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 190, 0, 59),
        Size = UDim2.new(1, -390, 0, 16),
        Font = theme.SmallFont,
        Text = "Main",
        TextSize = 10,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    }, top)

    local function topButton(text, rightOffset, textSize)
        local button = New("TextButton", {
            BackgroundColor3 = theme.Surface2,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, rightOffset, 0.5, 0),
            Size = UDim2.fromOffset(32, 32),
            Text = text,
            Font = theme.TitleFont,
            TextSize = textSize or 13,
            TextColor3 = theme.Muted,
            AutoButtonColor = false,
            ZIndex = 22
        }, top)
        Corner(button, 9)
        Stroke(button, theme.Border, 0.45, 1)
        return button
    end

    local close = topButton("×", -12, 18)
    local minimizeButton = topButton("−", -50, 16)
    local maximize = topButton("□", -88, 12)
    local headerLine = New("Frame", {
        BackgroundColor3 = theme.Border,
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(18, 67),
        Size = UDim2.new(1, -36, 0, 1),
        ZIndex = 20
    }, top)
    local accentLine = New("Frame", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(18, 67),
        Size = UDim2.fromOffset(64, 2),
        ZIndex = 22
    }, top)
    Corner(accentLine, 2)

    local sidebar = New("Frame", {
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(12, 82),
        Size = UDim2.new(0, 170, 1, -96),
        ZIndex = 12
    }, main)
    Corner(sidebar, theme.Radius)
    Stroke(sidebar, theme.Border, 0.42, 1)
    local sidebarHeader = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 12),
        Size = UDim2.new(1, -28, 0, 16),
        Font = theme.SmallFont,
        Text = "NAVIGATION",
        TextSize = 9,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    }, sidebar)
    local tabList = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 1, -64),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ScrollBarThickness = 0,
        ZIndex = 13
    }, sidebar)
    Padding(tabList, 8, 8, 0, 8)
    New("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, tabList)
    local sidebarFooter = New("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 14, 1, -12),
        Size = UDim2.new(1, -28, 0, 14),
        Font = theme.Font,
        Text = "IRISHUB • " .. self.Version,
        TextSize = 8,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14
    }, sidebar)

    local content = New("Frame", {
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(192, 82),
        Size = UDim2.new(1, -204, 1, -96),
        ZIndex = 12
    }, main)
    Corner(content, theme.Radius)
    Stroke(content, theme.Border, 0.42, 1)
    local pages = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = 13
    }, content)

    local window = setmetatable({
        Library = self,
        Root = root,
        Main = main,
        Shadow = shadow,
        Gradient = gradient,
        Size = main.Size,
        Stroke = outline,
        Top = top,
        Brand = brand,
        BrandText = brandText,
        BrandIcon = brandIcon,
        Title = title,
        Subtitle = subtitle,
        StatusDot = statusDot,
        StatusText = statusText,
        Breadcrumb = breadcrumb,
        Close = close,
        MinimizeButton = minimizeButton,
        MaximizeButton = maximize,
        HeaderLine = headerLine,
        AccentLine = accentLine,
        Sidebar = sidebar,
        SidebarHeader = sidebarHeader,
        SidebarFooter = sidebarFooter,
        TabList = tabList,
        Content = content,
        Pages = pages,
        Tabs = {},
        Connections = ConnectionBag.new(),
        Destroyed = false,
        Minimized = false,
        Maximized = false
    }, Window)
    table.insert(self.Windows, window)
    New("UIScale", {Scale = tonumber(options.UIScale) or 1}, root)

    local dragStart
    local dragPosition
    window.Connections:Add(top.InputBegan:Connect(function(input)
        if options.Draggable == false then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            dragPosition = main.Position
            window:Focus()
        end
    end))
    window.Connections:Add(UserInputService.InputChanged:Connect(function(input)
        if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(dragPosition.X.Scale, dragPosition.X.Offset + delta.X, dragPosition.Y.Scale, dragPosition.Y.Offset + delta.Y)
        end
    end))
    window.Connections:Add(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragStart = nil end
    end))
    if options.ToggleKey then
        window.ToggleKey = options.ToggleKey
        window.Connections:Add(UserInputService.InputBegan:Connect(function(input, processed)
            if processed or window.Destroyed then return end
            local target = options.ToggleKey
            if typeof(target) == "EnumItem" and input.KeyCode == target then
                window:SetVisible(not window.Root.Visible)
            elseif type(target) == "string" and input.KeyCode.Name == target then
                window:SetVisible(not window.Root.Visible)
            end
        end))
    end

    if options.Resizable ~= false then
        local resizeGrip = New("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -7, 1, -7), Size = UDim2.fromOffset(26, 26), Text = "↘", Font = theme.SmallFont, TextSize = 13, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 60}, main)
        window.ResizeGrip = resizeGrip
        local resizing = false
        local resizeStart
        local sizeStart
        window.Connections:Add(resizeGrip.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeStart = input.Position
                sizeStart = main.AbsoluteSize
                window:Focus()
            end
        end))
        window.Connections:Add(UserInputService.InputChanged:Connect(function(input)
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - resizeStart
                local width = Clamp(sizeStart.X + delta.X, minSize.X, maxSize.X)
                local height = Clamp(sizeStart.Y + delta.Y, minSize.Y, maxSize.Y)
                window.Size = UDim2.fromOffset(width, height)
                main.Size = window.Size
            end
        end))
        window.Connections:Add(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end
        end))
    end

    window.Connections:Add(close.MouseEnter:Connect(function() Tween(close, {BackgroundColor3 = theme.Danger, TextColor3 = theme.Text}, 0.12) end))
    window.Connections:Add(close.MouseLeave:Connect(function() Tween(close, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = self.Theme.Muted}, 0.12) end))
    window.Connections:Add(minimizeButton.MouseEnter:Connect(function() Tween(minimizeButton, {BackgroundColor3 = self.Theme.Surface3, TextColor3 = self.Theme.Text}, 0.12) end))
    window.Connections:Add(minimizeButton.MouseLeave:Connect(function() Tween(minimizeButton, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = self.Theme.Muted}, 0.12) end))
    window.Connections:Add(maximize.MouseEnter:Connect(function() Tween(maximize, {BackgroundColor3 = self.Theme.Surface3, TextColor3 = self.Theme.Text}, 0.12) end))
    window.Connections:Add(maximize.MouseLeave:Connect(function() Tween(maximize, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = self.Theme.Muted}, 0.12) end))
    window.Connections:Add(close.Activated:Connect(function()
        if type(options.OnClose) == "function" then Fire(options.OnClose, window) end
        window:Destroy()
    end))
    window.Connections:Add(minimizeButton.Activated:Connect(function() window:Minimize() end))
    window.Connections:Add(maximize.Activated:Connect(function() window:Maximize() end))
    window.Connections:Add(main.InputBegan:Connect(function() window:Focus() end))

    function window:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        self.Connections:Clear()
        for _, tab in pairs(self.Tabs) do
            if tab.Connections then tab.Connections:Clear() end
            for _, component in ipairs(tab.Components or {}) do pcall(function() component:Destroy() end) end
        end
        for index = #self.Library.Windows, 1, -1 do
            if self.Library.Windows[index] == self then
                table.remove(self.Library.Windows, index)
                break
            end
        end
        self.Root:Destroy()
    end

    function window:GetTab(name)
        local target = tostring(name)
        for _, tab in pairs(self.Tabs) do
            if tab and not tab.Destroyed and tab.Name == target then
                return tab
            end
        end
        return nil
    end

    function window:GetActiveTab()
        return self.ActiveTab
    end

    function window:SelectTab(name)
        local target = self:GetTab(name)
        if not target then return nil end
        for _, tab in pairs(self.Tabs) do
            if tab ~= target then tab:SetActive(false) end
        end
        target:SetActive(true)
        return target
    end

    function window:SetStatus(text, color)
        self.StatusText.Text = tostring(text or "READY")
        self.StatusText.TextColor3 = color or self.Library.Theme.Muted
        self.StatusDot.BackgroundColor3 = color or self.Library.Theme.Success
        return self
    end

    function window:CreateTab(opts)
        opts = opts or {}
        local tab = Window.CreateTab(self, opts)
        if opts.OnCreated then Fire(opts.OnCreated, tab) end
        return tab
    end

    function window:ApplyTheme(themeData)
        self.Main.BackgroundColor3 = themeData.Surface
        self.Main.BackgroundTransparency = themeData.Transparency
        if self.Gradient then
            self.Gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, themeData.Surface3),
                ColorSequenceKeypoint.new(0.18, themeData.Surface),
                ColorSequenceKeypoint.new(1, themeData.Surface)
            })
        end
        if self.Shadow then
            self.Shadow.BackgroundTransparency = themeData.ShadowTransparency or 0.8
        end
        self.Stroke.Color = themeData.Border
        self.Brand.BackgroundColor3 = themeData.AccentSoft
        local brandStroke = self.Brand:FindFirstChildOfClass("UIStroke")
        if brandStroke then brandStroke.Color = themeData.Accent end
        if self.BrandIcon then
            if self.BrandIcon:IsA("ImageLabel") then self.BrandIcon.ImageColor3 = themeData.Text end
            if self.BrandIcon:IsA("TextLabel") then self.BrandIcon.TextColor3 = themeData.Text end
        end
        self.Title.TextColor3 = themeData.Text
        self.Subtitle.TextColor3 = themeData.Muted
        self.StatusText.TextColor3 = themeData.Muted
        self.StatusDot.BackgroundColor3 = themeData.Success
        self.Breadcrumb.TextColor3 = themeData.Muted
        self.Close.BackgroundColor3 = themeData.Surface2
        self.Close.TextColor3 = themeData.Muted
        self.MinimizeButton.BackgroundColor3 = themeData.Surface2
        self.MinimizeButton.TextColor3 = themeData.Muted
        self.MaximizeButton.BackgroundColor3 = themeData.Surface2
        self.MaximizeButton.TextColor3 = themeData.Muted
        local closeStroke = self.Close:FindFirstChildOfClass("UIStroke")
        if closeStroke then closeStroke.Color = themeData.Border end
        local minStroke = self.MinimizeButton:FindFirstChildOfClass("UIStroke")
        if minStroke then minStroke.Color = themeData.Border end
        local maxStroke = self.MaximizeButton:FindFirstChildOfClass("UIStroke")
        if maxStroke then maxStroke.Color = themeData.Border end
        self.HeaderLine.BackgroundColor3 = themeData.Border
        self.AccentLine.BackgroundColor3 = themeData.Accent
        self.Sidebar.BackgroundColor3 = themeData.Background
        self.SidebarHeader.TextColor3 = themeData.Muted
        self.SidebarFooter.TextColor3 = themeData.Muted
        self.Content.BackgroundColor3 = themeData.Background
        local sidebarStroke = self.Sidebar:FindFirstChildOfClass("UIStroke")
        if sidebarStroke then sidebarStroke.Color = themeData.Border end
        local contentStroke = self.Content:FindFirstChildOfClass("UIStroke")
        if contentStroke then contentStroke.Color = themeData.Border end
        for _, tab in pairs(self.Tabs) do
            if tab.ApplyTheme then tab:ApplyTheme(themeData) end
        end
    end

    local defaultTab = window:CreateTab({
        Title = options.DefaultTab or "Main",
        Icon = options.DefaultIcon
    })
    defaultTab:SetActive(true)
    return window
end

function IrisHub:Notify(options)
    options = options or {}
    local theme = self.Theme
    local holder = self.NotificationHolder
    if not holder then
        holder = New("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -20, 1, -20), Size = UDim2.fromOffset(370, 460), ZIndex = 100}, self.Gui)
        New("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom}, holder)
        self.NotificationHolder = holder
    end
    local typeName = tostring(options.Type or "Info")
    local accentColor = options.Color or (typeName == "Success" and theme.Success or typeName == "Warning" and theme.Warning or (typeName == "Error" or typeName == "Danger") and theme.Danger or theme.Accent)
    local card = New("CanvasGroup", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 78), LayoutOrder = os.clock() % 1 * 1000, ZIndex = 100, GroupTransparency = 0}, holder)
    Corner(card, theme.Radius + 2)
    Stroke(card, theme.Border, 0.08, 1)
    local accent = New("Frame", {BackgroundColor3 = accentColor, BorderSizePixel = 0, Size = UDim2.fromOffset(3, 78), Position = UDim2.fromOffset(0, 0), ZIndex = 102}, card)
    Corner(accent, 2)
    local icon = CreateIcon(card, options.Icon or (typeName == "Success" and "lucide:check" or typeName == "Warning" and "lucide:warning" or (typeName == "Error" or typeName == "Danger") and "lucide:error" or "lucide:bell"), 19, accentColor)
    if icon then icon.Position = UDim2.fromOffset(16, 18); icon.AnchorPoint = Vector2.new(0, 0) end
    local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(46, 11), Size = UDim2.new(1, -82, 0, 21), Font = theme.TitleFont, Text = tostring(options.Title or "Notification"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 103}, card)
    local desc = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(46, 33), Size = UDim2.new(1, -64, 0, 29), Font = theme.Font, Text = tostring(options.Content or options.Description or ""), TextSize = 11, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 103}, card)
    local close = New("TextButton", {BackgroundTransparency = 1, Position = UDim2.new(1, -34, 0, 9), Size = UDim2.fromOffset(24, 24), Text = "×", Font = theme.TitleFont, TextSize = 15, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 104}, card)
    local progress = New("Frame", {BackgroundColor3 = accentColor, BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -3), Size = UDim2.fromScale(1, 0.04), ZIndex = 104}, card)
    local duration = tonumber(options.Duration)
    local item = {Instance = card, Destroyed = false, Duration = duration or 0, Type = typeName, Progress = progress, Accent = accentColor}
    function item:SetTitle(value) title.Text = tostring(value or ""); return self end
    function item:SetDescription(value) desc.Text = tostring(value or ""); return self end
    function item:SetProgress(value)
        local fraction = Clamp(tonumber(value) or 0, 0, 1)
        progress.Size = UDim2.new(fraction, 0, 0.04, 0)
        return self
    end
    function item:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        for i = #self.Library.Notifications, 1, -1 do
            if self.Library.Notifications[i] == self then table.remove(self.Library.Notifications, i) break end
        end
        Tween(card, {GroupTransparency = 1}, 0.16)
        Tween(card, {Position = UDim2.new(1, 28, 0, 0)}, 0.16)
        task.delay(0.18, function() pcall(function() card:Destroy() end) end)
    end
    item.Library = self
    table.insert(self.Notifications, item)
    self.Connections:Add(close.Activated:Connect(function() item:Destroy() end))
    self.Connections:Add(card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then item:Destroy() end
    end))
    card.Position = UDim2.new(1, 40, 0, 0)
    Tween(card, {Position = UDim2.fromOffset(0, 0)}, 0.18)
    if duration and duration > 0 then
        Tween(progress, {Size = UDim2.new(0, 0, 0.04, 0)}, duration, Enum.EasingStyle.Linear)
        task.delay(duration, function() item:Destroy() end)
    else
        progress.Visible = false
    end
    while #self.Notifications > (tonumber(options.MaxVisible) or 6) do
        local oldest = self.Notifications[1]
        if oldest and oldest ~= item then oldest:Destroy() else break end
    end
    return item
end

function IrisHub:GetNotifications()
    local result = {}
    for _, item in ipairs(self.Notifications) do
        if item and not item.Destroyed then table.insert(result, item) end
    end
    return result
end

function IrisHub:ClearNotifications()
    for index = #self.Notifications, 1, -1 do
        local item = self.Notifications[index]
        if item and item.Destroy then pcall(function() item:Destroy() end) end
        self.Notifications[index] = nil
    end
    return self
end

function IrisHub:CreateModal(options)
    options = options or {}
    local theme = self.Theme
    local root = New("Frame", {BackgroundColor3 = theme.Overlay, BackgroundTransparency = 0.3, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 80}, self.Gui)
    local card = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = options.Size or UDim2.fromOffset(420, 220), ZIndex = 81}, root)
    Corner(card, theme.Radius + 2)
    Stroke(card, theme.Border, 0.05, 1)
    local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 16), Size = UDim2.new(1, -36, 0, 26), Font = theme.TitleFont, Text = tostring(options.Title or "Modal"), TextSize = 17, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 82}, card)
    local desc = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 48), Size = UDim2.new(1, -36, 0, 72), Font = theme.Font, Text = tostring(options.Description or ""), TextSize = 12, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 82}, card)
    local actions = New("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -18, 1, -18), Size = UDim2.fromOffset(240, 42), ZIndex = 82}, card)
    local cancel = New("TextButton", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Size = UDim2.fromOffset(104, 38), Text = tostring(options.CancelText or "Cancel"), Font = theme.SmallFont, TextSize = 12, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 83}, actions)
    Corner(cancel, 8)
    local confirm = New("TextButton", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Position = UDim2.fromOffset(114, 0), Size = UDim2.fromOffset(126, 38), Text = tostring(options.ConfirmText or "Confirm"), Font = theme.SmallFont, TextSize = 12, TextColor3 = theme.Text, AutoButtonColor = false, ZIndex = 83}, actions)
    Corner(confirm, 8)
    local modal = {Instance = root, Destroyed = false}
    function modal:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        Tween(card, {Size = UDim2.new(card.Size.X.Scale, card.Size.X.Offset - 18, card.Size.Y.Scale, card.Size.Y.Offset - 18), BackgroundTransparency = 1}, 0.16)
        Tween(root, {BackgroundTransparency = 1}, 0.16)
        task.delay(0.18, function() pcall(function() root:Destroy() end) end)
    end
    cancel.Activated:Connect(function() Fire(options.OnCancel); modal:Destroy() end)
    confirm.Activated:Connect(function() Fire(options.OnConfirm); modal:Destroy() end)
    return modal
end

function IrisHub:SaveConfig(name)
    local file = SafeName(name or self.Options.ConfigName or "IrisHubConfig") .. ".json"
    local data = self.Config or {}
    local encoded = HttpService:JSONEncode(data)
    if writefile then
        writefile(file, encoded)
        return true, file
    end
    return false, "writefile unavailable"
end

function IrisHub:LoadConfig(name)
    local file = SafeName(name or self.Options.ConfigName or "IrisHubConfig") .. ".json"
    if readfile and isfile and isfile(file) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(file)) end)
        if ok and type(data) == "table" then self.Config = data; return true, data end
        return false, data
    end
    return false, "configuration file unavailable"
end

function IrisHub:SetConfig(key, value)
    self.Config[key] = value
    return self
end

function IrisHub:GetConfig(key, fallback)
    local value = self.Config[key]
    if value == nil then return fallback end
    return value
end


function IrisHub:ConfigExists(name)
    local file = SafeName(name or self.Options.ConfigName or "IrisHubConfig") .. ".json"
    return isfile and isfile(file) == true or false
end

function IrisHub:ListConfigs()
    local result = {}
    if type(listfiles) ~= "function" then return result end
    local ok, files = pcall(listfiles, "")
    if not ok or type(files) ~= "table" then return result end
    for _, path in ipairs(files) do
        local normalized = tostring(path):gsub("\\\\", "/")
        local file = normalized:match("([^/]+)\\.json$")
        if file then table.insert(result, file) end
    end
    table.sort(result)
    return result
end

function IrisHub:DeleteConfig(name)
    local file = SafeName(name or self.Options.ConfigName or "IrisHubConfig") .. ".json"
    if type(delfile) ~= "function" then return false, "delfile unavailable" end
    if type(isfile) == "function" and not isfile(file) then return false, "configuration does not exist" end
    local ok, err = pcall(delfile, file)
    if not ok then return false, err end
    return true, file
end

function IrisHub:ExportConfig()
    return HttpService:JSONEncode(self.Config or {})
end

function IrisHub:ImportConfig(json, apply)
    local ok, data = pcall(function() return HttpService:JSONDecode(tostring(json or "")) end)
    if not ok or type(data) ~= "table" then return false, "invalid configuration JSON" end
    self.Config = data
    if apply and type(apply) == "function" then Fire(apply, data) end
    return true, data
end

function IrisHub:CreateConfigManager(defaultName)
    local library = self
    local manager = {Name = defaultName or self.Options.ConfigName or "IrisHubConfig"}
    function manager:SetName(name) self.Name = SafeName(name or manager.Name) return self end
    function manager:Save(data)
        if data then library.Config = CloneTable(data) end
        return library:SaveConfig(self.Name)
    end
    function manager:Load(apply)
        local ok, data = library:LoadConfig(self.Name)
        if ok and apply then Fire(apply, data) end
        return ok, data
    end
    function manager:Delete() return library:DeleteConfig(self.Name) end
    function manager:Exists() return library:ConfigExists(self.Name) end
    function manager:List() return library:ListConfigs() end
    function manager:Export() return library:ExportConfig() end
    function manager:Import(json, apply) return library:ImportConfig(json, apply) end
    return manager
end


local KeyProviders = {
    PlatoBoost = {
        Name = "PlatoBoost",
        Website = "https://platoboost.com/"
    },
    ["Panda Development"] = {
        Name = "Panda Development",
        Website = "https://pandadevelopment.net/",
        Docs = "https://doc.pandadevelopment.net/utilizing-panda-auth-on-your-product/roblox-lua"
    },
    Luarmor = {
        Name = "Luarmor",
        Website = "https://luarmor.net/",
        Docs = "https://docs.luarmor.net/"
    }
}

function IrisHub:RegisterKeyProvider(name, provider)
    assert(type(name) == "string", "Provider name must be a string")
    assert(type(provider) == "table", "Provider must be a table")
    KeyProviders[name] = Merge({Name = name}, provider)
    return self
end

function IrisHub:GetKeyProvider(name)
    return KeyProviders[name]
end

function IrisHub:GetKeyProviders()
    local names = {}
    for name in pairs(KeyProviders) do table.insert(names, name) end
    table.sort(names)
    return names
end

function IrisHub:CreateKeySystem(options)
    options = options or {}
    local theme = self.Theme
    local providerName = options.Provider or "PlatoBoost"
    local provider = KeyProviders[providerName]
    if not provider then providerName = "PlatoBoost"; provider = KeyProviders[providerName] end
    local root = New("CanvasGroup", {BackgroundTransparency = 0, GroupTransparency = 0, Size = UDim2.fromScale(1, 1), ZIndex = 70}, self.Gui)
    local scrim = New("Frame", {BackgroundColor3 = theme.Overlay, BackgroundTransparency = 0.18, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 70}, root)
    local card = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = options.Size or UDim2.fromOffset(470, 330), ZIndex = 71}, root)
    Corner(card, theme.Radius + 4)
    Stroke(card, theme.Border, 0.02, 1)
    local accent = New("Frame", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 4), ZIndex = 72}, card)
    Corner(accent, 2)
    local icon = CreateIcon(card, options.Icon or "lucide:key", 20, theme.Accent)
    if icon then icon.Position = UDim2.fromOffset(20, 36); icon.AnchorPoint = Vector2.new(0, 0.5) end
    local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 20), Size = UDim2.new(1, -150, 0, 26), Font = theme.TitleFont, Text = tostring(options.Title or "IrisHub Access"), TextSize = 19, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 72}, card)
    local providerTag = New("TextLabel", {BackgroundColor3 = theme.AccentSoft, BackgroundTransparency = 0.08, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -18, 0, 34), Size = UDim2.fromOffset(124, 26), Font = theme.SmallFont, Text = providerName, TextSize = 10, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 72}, card)
    Corner(providerTag, 13)
    local info = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 60), Size = UDim2.new(1, -40, 0, 40), Font = theme.Font, Text = tostring(options.Description or "Enter your key to continue. Provider adapters can be registered through IrisHub:RegisterKeyProvider."), TextSize = 12, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 72}, card)
    local providerBox = New("Frame", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(20, 108), Size = UDim2.new(1, -40, 0, 42), ZIndex = 72}, card)
    Corner(providerBox, 9)
    Stroke(providerBox, theme.Border, 0.35, 1)
    local providerLabel = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -110, 1, 0), Font = theme.SmallFont, Text = "Provider • " .. providerName, TextSize = 11, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 73}, providerBox)
    local cycle = New("TextButton", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(86, 28), Text = "Change", Font = theme.SmallFont, TextSize = 10, TextColor3 = theme.Accent, AutoButtonColor = false, ZIndex = 73}, providerBox)
    local input = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(20, 162), Size = UDim2.new(1, -40, 0, 42), PlaceholderText = tostring(options.Placeholder or "Paste your key"), PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false, ZIndex = 72}, card)
    Corner(input, 9)
    Stroke(input, theme.Border, 0.35, 1)
    Padding(input, 12, 12, 0, 0)
    local status = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 209), Size = UDim2.new(1, -40, 0, 22), Font = theme.Font, Text = "", TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 72}, card)
    local actions = New("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 246), Size = UDim2.new(1, -40, 0, 42), ZIndex = 72}, card)
    local getKey = New("TextButton", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Size = UDim2.fromOffset(122, 40), Text = "Get Key", Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 73}, actions)
    Corner(getKey, 9)
    Stroke(getKey, theme.Border, 0.28, 1)
    local copyLink = New("TextButton", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(130, 0), Size = UDim2.fromOffset(122, 40), Text = "Copy Link", Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 73}, actions)
    Corner(copyLink, 9)
    Stroke(copyLink, theme.Border, 0.28, 1)
    local submit = New("TextButton", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(136, 40), Text = "Validate Key", Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Text, AutoButtonColor = false, ZIndex = 73}, actions)
    Corner(submit, 9)
    local controller = {Instance = root, Input = input, Provider = providerName, ProviderData = provider, Destroyed = false}
    function controller:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        pcall(function() root:Destroy() end)
    end
    function controller:SetProvider(name)
        local target = KeyProviders[name]
        if not target then return false, "unknown provider" end
        self.Provider = name
        self.ProviderData = target
        providerLabel.Text = "Provider • " .. name
        providerTag.Text = name
        return true, target
    end
    function controller:SetStatus(message, color)
        status.Text = tostring(message or "")
        status.TextColor3 = color or theme.Muted
        return self
    end
    function controller:GetKeyUrl()
        return options.KeyLink or (self.ProviderData and self.ProviderData.KeyLink) or (self.ProviderData and self.ProviderData.Website)
    end
    function controller:Validate(key)
        local validator = options.Validate or (self.ProviderData and self.ProviderData.Validate)
        if type(validator) ~= "function" then
            return false, "No validator is configured for " .. tostring(self.Provider) .. ". Register a provider adapter or pass Validate." 
        end
        local ok, result = pcall(validator, key, self, self.Library)
        if not ok then return false, result end
        if result == true then return true, true end
        return false, result or "Invalid key"
    end
    local names = self:GetKeyProviders()
    local providerIndex = table.find(names, providerName) or 1
    local function cycleProvider()
        providerIndex = providerIndex % #names + 1
        controller:SetProvider(names[providerIndex])
    end
    self.Connections:Add(cycle.Activated:Connect(cycleProvider))
    self.Connections:Add(getKey.Activated:Connect(function()
        local url = controller:GetKeyUrl()
        if type(options.OnGetKey) == "function" then
            Fire(options.OnGetKey, url, controller.Provider, controller)
        elseif url then
            local copied = CopyText(url)
            controller:SetStatus(copied and "Key link copied to clipboard." or tostring(url), theme.Accent)
        else
            controller:SetStatus("No key link configured.", theme.Warning)
        end
    end))
    self.Connections:Add(copyLink.Activated:Connect(function()
        local url = controller:GetKeyUrl()
        if url then
            controller:SetStatus(CopyText(url) and "Provider link copied." or tostring(url), theme.Accent)
        else
            controller:SetStatus("No provider link configured.", theme.Warning)
        end
    end))
    self.Connections:Add(submit.Activated:Connect(function()
        local key = tostring(input.Text or ""):gsub("%s+", "")
        if key == "" then controller:SetStatus("Enter a key first.", theme.Warning); return end
        submit.Active = false
        submit.Text = "Checking..."
        controller:SetStatus("Validating with " .. tostring(controller.Provider) .. "...", theme.Muted)
        local valid, message = controller:Validate(key)
        if valid then
            controller:SetStatus("Access granted.", theme.Success)
            submit.Text = "Verified"
            Fire(options.OnSuccess, key, controller.Provider)
            task.delay(0.25, function() controller:Destroy() end)
        else
            controller:SetStatus(tostring(message), theme.Danger)
            submit.Text = "Validate Key"
            submit.Active = true
            Fire(options.OnFailure, key, message, controller.Provider)
        end
    end))
    return controller
end

function IrisHub:GetVersion()
    return self.Version
end

function IrisHub:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    self.Connections:Clear()
    while #self.Windows > 0 do
        local window = self.Windows[#self.Windows]
        pcall(function() window:Destroy() end)
        if self.Windows[#self.Windows] == window then
            table.remove(self.Windows, #self.Windows)
        end
    end
    while #self.Notifications > 0 do
        local notification = self.Notifications[#self.Notifications]
        pcall(function() notification:Destroy() end)
        table.remove(self.Notifications, #self.Notifications)
    end
    if self.NotificationHolder then pcall(function() self.NotificationHolder:Destroy() end) end
    if self.Gui then pcall(function() self.Gui:Destroy() end) end
end

function IrisHub.Create(options)
    local library = IrisHub.new(options)
    library:CreateWindow(options or {})
    return library
end

IrisHub.Themes = Themes
IrisHub.Components = Component
IrisHub.Utilities = {
    Clamp = Clamp,
    Round = Round,
    FormatValue = FormatValue,
    Merge = Merge
}

return IrisHub
