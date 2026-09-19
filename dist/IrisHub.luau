local IrisHub = {}
IrisHub.__index = IrisHub
IrisHub.Version = "2.7.0"
IrisHub.Name = "IrisHub"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local ParentGui = (gethui and gethui()) or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui")) or CoreGui

local Themes = {
    Iris = {
        Background = Color3.fromRGB(9, 10, 15),
        Surface = Color3.fromRGB(15, 17, 24),
        Surface2 = Color3.fromRGB(21, 24, 33),
        Surface3 = Color3.fromRGB(28, 32, 44),
        Border = Color3.fromRGB(44, 49, 66),
        Text = Color3.fromRGB(247, 248, 255),
        Muted = Color3.fromRGB(164, 168, 194),
        Accent = Color3.fromRGB(157, 132, 255),
        Accent2 = Color3.fromRGB(105, 190, 255),
        AccentSoft = Color3.fromRGB(49, 42, 83),
        Success = Color3.fromRGB(84, 205, 142),
        Warning = Color3.fromRGB(241, 190, 82),
        Danger = Color3.fromRGB(238, 92, 112),
        Overlay = Color3.fromRGB(7, 8, 12),
        Shadow = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.80,
        Transparency = 0,
        Radius = 15,
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
        Radius = 13,
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
        Radius = 13,
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
        Website = "https://lucide.dev/",
        Source = "https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/"
    },
    Geist = {
        Name = "Geist Icons",
        Prefix = "geist:",
        Website = "https://vercel.com/geist/icons",
        Source = "https://github.com/geist-org/geist"
    },
    Craft = {
        Name = "Craft Icons",
        Prefix = "craft:",
        Website = "https://www.figma.com/community/file/1415718327120418204",
        Source = "https://www.figma.com/community/file/1415718327120418204"
    }
}

local IconRegistry = {
    Assets = {},
    BuiltinAssets = {
        activity = "rbxassetid://10709752035",
        alertcircle = "rbxassetid://10709752996",
        alerttriangle = "rbxassetid://10709753149",
        archive = "rbxassetid://10709762233",
        bell = "rbxassetid://10709775704",
        book = "rbxassetid://10709781824",
        bookopen = "rbxassetid://10709781717",
        bot = "rbxassetid://10709782230",
        bug = "rbxassetid://10709782845",
        calendar = "rbxassetid://10709789505",
        camera = "rbxassetid://10709789686",
        check = "rbxassetid://10709790644",
        checkcircle = "rbxassetid://10709790387",
        chevrondown = "rbxassetid://10709790948",
        chevronleft = "rbxassetid://10709791281",
        chevronright = "rbxassetid://10709791437",
        chevronup = "rbxassetid://10709791523",
        circle = "rbxassetid://10709798174",
        clipboard = "rbxassetid://10709799288",
        clipboardcopy = "rbxassetid://10709798574",
        clock = "rbxassetid://10709805144",
        code = "rbxassetid://10709810463",
        cog = "rbxassetid://10709810948",
        copy = "rbxassetid://10709812159",
        cpu = "rbxassetid://10709813383",
        crown = "rbxassetid://10709818626",
        database = "rbxassetid://10709818996",
        delete = "rbxassetid://10709819059",
        download = "rbxassetid://10723344270",
        edit = "rbxassetid://10734883598",
        eye = "rbxassetid://10723346959",
        eyeoff = "rbxassetid://10723346871",
        externalink = "rbxassetid://10723346684",
        file = "rbxassetid://10723374641",
        filecode = "rbxassetid://10723356507",
        filecog = "rbxassetid://10723356830",
        filejson = "rbxassetid://10723364435",
        filter = "rbxassetid://10723375128",
        flame = "rbxassetid://10723376114",
        folder = "rbxassetid://10723387563",
        folderopen = "rbxassetid://10723386277",
        gamepad = "rbxassetid://10723395457",
        gamepad2 = "rbxassetid://10723395215",
        gem = "rbxassetid://10723396000",
        globe = "rbxassetid://10723404337",
        grab = "rbxassetid://10723404472",
        gripvertical = "rbxassetid://10723405236",
        heart = "rbxassetid://10723406885",
        helpcircle = "rbxassetid://10723406988",
        home = "rbxassetid://10723407389",
        image = "rbxassetid://10723415040",
        info = "rbxassetid://10723415903",
        key = "rbxassetid://10723416652",
        keyboard = "rbxassetid://10723416765",
        layers = "rbxassetid://10723424505",
        layout = "rbxassetid://10723425376",
        layoutdashboard = "rbxassetid://10723424646",
        layoutgrid = "rbxassetid://10723424838",
        link = "rbxassetid://10723426722",
        list = "rbxassetid://10723433811",
        loader = "rbxassetid://10723434070",
        lock = "rbxassetid://10723434711",
        login = "rbxassetid://10723434830",
        logout = "rbxassetid://10723434906",
        mail = "rbxassetid://10734885430",
        map = "rbxassetid://10734886202",
        mappin = "rbxassetid://10734886004",
        maximize = "rbxassetid://10734886735",
        maximize2 = "rbxassetid://10734886496",
        megaphone = "rbxassetid://10734887454",
        menu = "rbxassetid://10734887784",
        messagecircle = "rbxassetid://10734888000",
        messagesquare = "rbxassetid://10734888228",
        mic = "rbxassetid://10734888864",
        minimize = "rbxassetid://10734895698",
        minimize2 = "rbxassetid://10734895530",
        minus = "rbxassetid://10734896206",
        monitor = "rbxassetid://10734896881",
        moon = "rbxassetid://10734897102",
        morehorizontal = "rbxassetid://10734897250",
        morevertical = "rbxassetid://10734897387",
        mouse = "rbxassetid://10734898592",
        move = "rbxassetid://10734900011",
        navigation = "rbxassetid://10734906744",
        package = "rbxassetid://10734909540",
        paintbrush = "rbxassetid://10734910187",
        palette = "rbxassetid://10734910430",
        paperclip = "rbxassetid://10734910927",
        pause = "rbxassetid://10734919336",
        pencil = "rbxassetid://10734919691",
        play = "rbxassetid://10734923549",
        plus = "rbxassetid://10734924532",
        power = "rbxassetid://10734930466",
        refreshccw = "rbxassetid://10734933056",
        refreshcw = "rbxassetid://10734933222",
        rocket = "rbxassetid://10734934585",
        save = "rbxassetid://10734941499",
        search = "rbxassetid://10734943674",
        send = "rbxassetid://10734943902",
        server = "rbxassetid://10734949856",
        settings = "rbxassetid://10734950309",
        settings2 = "rbxassetid://10734950020",
        share = "rbxassetid://10734950813",
        shield = "rbxassetid://10734951847",
        shieldalert = "rbxassetid://10734951173",
        shieldcheck = "rbxassetid://10734951367",
        sidebar = "rbxassetid://10734954301",
        sliders = "rbxassetid://10734963400",
        slidershorizontal = "rbxassetid://10734963191",
        smartphone = "rbxassetid://10734963940",
        star = "rbxassetid://10734966248",
        sun = "rbxassetid://10734974297",
        tag = "rbxassetid://10734976528",
        tags = "rbxassetid://10734976739",
        target = "rbxassetid://10734977012",
        terminal = "rbxassetid://10734982144",
        trash = "rbxassetid://10747362393",
        trash2 = "rbxassetid://10747362241",
        unlock = "rbxassetid://10747366027",
        upload = "rbxassetid://10747366434",
        user = "rbxassetid://10747373176",
        usercheck = "rbxassetid://10747371901",
        usercog = "rbxassetid://10747372167",
        userminus = "rbxassetid://10747372346",
        userplus = "rbxassetid://10747372702",
        userx = "rbxassetid://10747372992",
        users = "rbxassetid://10747373426",
        verified = "rbxassetid://10747374131",
        view = "rbxassetid://10747375132",
        volume = "rbxassetid://10747376008",
        volume2 = "rbxassetid://10747375679",
        volumex = "rbxassetid://10747375880",
        wand = "rbxassetid://10747376565",
        wrench = "rbxassetid://10747383470",
        x = "rbxassetid://10747384394",
        xcircle = "rbxassetid://10747383819"
    },
    Aliases = {
        dashboard = "layoutdashboard", house = "home",
        gear = "settings", settings2 = "settings2",
        account = "user", person = "user", profile = "user",
        magnifyingglass = "search", find = "search",
        notification = "bell", notifications = "bell",
        sparkle = "star", sparkles = "star", magic = "wand",
        colors = "palette", theme = "palette", paint = "paintbrush",
        controls = "slidershorizontal", options = "sliders", tune = "slidershorizontal",
        chevrondown = "chevrondown", chevronleft = "chevronleft", chevronright = "chevronright", chevronup = "chevronup",
        error = "xcircle", warning = "alerttriangle",
        success = "checkcircle",
        close = "x", cancel = "x",
        remove = "minus", add = "plus",
        maximize = "maximize2", minimize = "minimize2",
        context = "morevertical", more = "morehorizontal",
        github = "code",
        keyround = "key", lockkeyhole = "lock", unlockkeyhole = "unlock",
        circlehelp = "helpcircle", circlealert = "alertcircle", trianglealert = "alerttriangle",
        circlex = "xcircle", circlecheck = "checkcircle", ellipsis = "morehorizontal", ellipsisvertical = "morevertical",
        refresh = "refreshcw", palette2 = "palette", sliders2 = "slidershorizontal"
    },
    Glyphs = {
        alertcircle = "!", alerttriangle = "!", archive = "[]", bell = "*", book = "[ ]", bookopen = "[ ]", bot = "o", bug = "x",
        calendar = "[]", camera = "o", check = "+", checkcircle = "o", circle = "o", clipboard = "[]", clipboardcopy = "[]", clock = "o",
        code = "<> ", cog = "*", copy = "[]", cpu = "[]", crown = "A", database = "[]", delete = "x", download = "v", edit = "/",
        eye = "o", eyeoff = "x", externalink = ">", file = "[]", filecode = "<> ", filecog = "*", filejson = "{}", filter = "=",
        flame = "*", folder = "[]", folderopen = "[]", gamepad = "[]", gamepad2 = "[]", gem = "*", globe = "o", grab = "+", gripvertical = "...",
        heart = "<3", helpcircle = "?", home = "^", image = "[]", info = "i", key = "K", keyboard = "[]", layers = "[]", layout = "[]",
        layoutdashboard = "[]", layoutgrid = "[]", link = ">", list = "=", loader = "o", lock = "#", login = ">", logout = "<", mail = "@",
        map = "[]", mappin = ".", maximize = "[]", maximize2 = "[]", menu = "=", messagecircle = "o", messagesquare = "[]", mic = "o",
        minimize = "-", minimize2 = "-", minus = "-", monitor = "[]", moon = "o", morehorizontal = "...", morevertical = "...", mouse = "o",
        move = "+", navigation = ">", package = "[]", paintbrush = "*", palette = "o", paperclip = "+", pause = "||", pencil = "/", play = ">",
        plus = "+", power = "o", refreshccw = "<", refreshcw = ">", rocket = "^", save = "[]", search = "?", send = ">", server = "[]",
        settings = "*", settings2 = "*", share = ">", shield = "#", shieldalert = "!", shieldcheck = "+", sidebar = "[]", sliders = "=",
        slidershorizontal = "=", smartphone = "[]", star = "*", sun = "o", tag = "<>", tags = "<>", target = "o", terminal = ">_",
        trash = "x", trash2 = "x", unlock = "o", upload = "^", user = "o", usercheck = "+", usercog = "*", userminus = "-",
        userplus = "+", userx = "x", users = "oo", verified = "+", view = "o", volume = "v", volume2 = "v", volumex = "x", wand = "*",
        wrench = "+", x = "x", xcircle = "x"
    }
}

for iconName, asset in pairs(IconRegistry.BuiltinAssets) do
    IconRegistry.Assets[iconName] = asset
    for providerKey in pairs(IconProviders) do
        IconRegistry.Assets[string.lower(providerKey) .. ":" .. iconName] = asset
    end
end
for aliasName, canonicalName in pairs(IconRegistry.Aliases) do
    local asset = IconRegistry.BuiltinAssets[canonicalName]
    if asset then
        IconRegistry.Assets[aliasName] = asset
        for providerKey in pairs(IconProviders) do
            IconRegistry.Assets[string.lower(providerKey) .. ":" .. aliasName] = asset
            IconRegistry.Assets[string.lower(providerKey) .. ":" .. canonicalName] = asset
        end
    end
end

local function NormalizeIconName(value)
    return string.lower(tostring(value or ""):gsub("[_%s%-]", ""))
end

local function IconAliasAsset(name)
    local normalized = NormalizeIconName(name)
    local alias = IconRegistry.Aliases[normalized]
    if alias and IconRegistry.BuiltinAssets[alias] then
        return IconRegistry.BuiltinAssets[alias]
    end
    return IconRegistry.BuiltinAssets.helpcircle or IconRegistry.BuiltinAssets.info
end

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
        pcall(callback, ...)
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
        PaddingBottom = UDim.new(0, bottom or top or 0)
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

local function MeasureTextHeight(text, font, textSize, width, minimum)
    local content = tostring(text or "")
    local safeWidth = math.max(80, tonumber(width) or 480)
    local safeMinimum = tonumber(minimum) or 16
    local ok, bounds = pcall(function()
        return TextService:GetTextSize(content, textSize or 12, font or Enum.Font.Gotham, Vector2.new(safeWidth, 10000))
    end)
    if ok and bounds then
        return math.max(safeMinimum, math.ceil(bounds.Y))
    end
    local lineCount = math.max(1, math.ceil(#content / math.max(1, math.floor(safeWidth / math.max(7, (textSize or 12) * 0.52)))))
    return math.max(safeMinimum, lineCount * math.max(14, (textSize or 12) + 5))
end

local function CreateShadow(parent, transparency)
    return nil
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
                shield = New("Frame", {BackgroundColor3 = self.Library.Theme.Background, BackgroundTransparency = 0.72, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1000}, root)
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
    if self.Data.PopupTracking then
        pcall(function() self.Data.PopupTracking:Disconnect() end)
        self.Data.PopupTracking = nil
    end
    if self.Data.Popup then
        pcall(function() self.Data.Popup:Destroy() end)
        self.Data.Popup = nil
    end
    if self.Instance then
        pcall(function() self.Instance:Destroy() end)
    end
end

local RemoteIconModule
local RemoteIconAttempted = false
local RemoteIconURL = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"

local function GetRemoteIconModule()
    if RemoteIconAttempted then
        return RemoteIconModule
    end
    RemoteIconAttempted = true
    local compiler = loadstring
    if type(compiler) ~= "function" then
        compiler = load
    end
    if type(compiler) ~= "function" or type(game.HttpGet) ~= "function" then
        return nil
    end
    local ok, result = pcall(function()
        local source = game:HttpGet(RemoteIconURL)
        local chunk = compiler(source)
        if type(chunk) ~= "function" then
            return nil
        end
        local module = chunk()
        if type(module) ~= "table" then
            return nil
        end
        if type(module.SetIconsType) == "function" then
            pcall(function() module:SetIconsType("lucide") end)
        end
        return module
    end)
    if ok and type(result) == "table" then
        RemoteIconModule = result
    end
    return RemoteIconModule
end

local function NormalizeIconResult(result)
    if type(result) == "string" and result ~= "" then
        return result, nil, nil
    end
    if type(result) ~= "table" then
        return nil, nil, nil
    end
    local image = result.image or result.Image or result.asset or result.Asset or result[1]
    local metadata = result.metadata or result.Metadata or result[2]
    if type(image) == "string" and image ~= "" then
        local parts = type(metadata) == "table" and metadata.Parts or nil
        return image, metadata, parts
    end
    return nil, nil, nil
end

local function ResolveRemoteIcon(value, provider, name)
    local module = GetRemoteIconModule()
    if not module or type(module.Icon2) ~= "function" then
        return nil, nil, nil
    end
    local ok, result = pcall(function()
        return module.Icon2(name or value, provider or "lucide")
    end)
    if not ok then
        ok, result = pcall(function()
            return module:Icon2(name or value, provider or "lucide")
        end)
    end
    if not ok then
        return nil, nil, nil
    end
    return NormalizeIconResult(result)
end

local function ResolveIconData(icon)
    if icon == nil then return nil, nil, nil end
    if typeof(icon) == "Instance" and icon:IsA("ImageLabel") then
        return icon.Image, nil, nil
    end
    if type(icon) == "number" then
        return "rbxassetid://" .. tostring(icon), nil, nil
    end
    local value = tostring(icon)
    if value:match("^rbxassetid://") or value:match("^rbxthumb://") or value:match("^rbxgameasset://") then
        return value, nil, nil
    end
    local exact = IconRegistry.Assets[value]
    if exact then
        return exact, nil, nil
    end
    local normalized = NormalizeIconName(value)
    local normalizedAsset = IconRegistry.Assets[normalized]
    if normalizedAsset then
        return normalizedAsset, nil, nil
    end
    local provider, name = value:match("^([^:]+):(.*)$")
    if provider and name then
        local providerLower = string.lower(provider)
        if providerLower == "lucide" or providerLower == "geist" or providerLower == "craft" then
            local known = IconRegistry.Assets[providerLower .. ":" .. NormalizeIconName(name)]
            if known then
                return known, nil, nil
            end
            local asset, metadata, parts = ResolveRemoteIcon(value, providerLower, name)
            if asset then
                return asset, metadata, parts
            end
            return IconAliasAsset(name), nil, nil
        end
    end
    if value:match("^https?://") then
        return nil, nil, nil
    end
    local asset, metadata, parts = ResolveRemoteIcon(value, "lucide", value)
    if asset then
        return asset, metadata, parts
    end
    return IconAliasAsset(value), nil, nil
end

local function ResolveIcon(icon)
    local asset, metadata = ResolveIconData(icon)
    return asset, metadata
end

local function CreateIcon(parent, icon, size, color, xAlignment)
    if icon == nil then return nil end
    local asset, metadata, parts = ResolveIconData(icon)
    if not asset then return nil end
    local iconSize = tonumber(size) or 18
    local anchor = xAlignment == "right" and 1 or 0
    local offset = xAlignment == "right" and -12 or 12
    local container = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(iconSize, iconSize),
        AnchorPoint = Vector2.new(anchor, 0.5),
        Position = UDim2.new(anchor, offset, 0.5, 0),
        ZIndex = (tonumber(parent.ZIndex) or 1) + 1
    }, parent)
    local function addImage(imageAsset, imageMetadata)
        local image = New("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Image = imageAsset,
            ImageColor3 = color or Color3.new(1, 1, 1),
            ScaleType = Enum.ScaleType.Fit,
            ResampleMode = Enum.ResamplerMode.Default,
            ZIndex = container.ZIndex
        }, container)
        if type(imageMetadata) == "table" then
            if typeof(imageMetadata.ImageRectSize) == "Vector2" then image.ImageRectSize = imageMetadata.ImageRectSize end
            local rectPosition = imageMetadata.ImageRectPosition or imageMetadata.ImageRectOffset
            if typeof(rectPosition) == "Vector2" then image.ImageRectOffset = rectPosition end
            if imageMetadata.ScaleType and typeof(imageMetadata.ScaleType) == "EnumItem" then image.ScaleType = imageMetadata.ScaleType end
        end
        return image
    end
    addImage(asset, metadata)
    if type(parts) == "table" then
        for _, part in ipairs(parts) do
            local partAsset, partMetadata = ResolveIconData(part)
            if partAsset then addImage(partAsset, partMetadata) end
        end
    end
    container:SetAttribute("IrisIcon", true)
    container:SetAttribute("IrisIconName", tostring(icon))
    return container
end

local function SetIconColor(icon, color)
    if not icon then return end
    if icon:IsA("ImageLabel") then
        icon.ImageColor3 = color
        return
    end
    if icon:IsA("TextLabel") then
        icon.TextColor3 = color
        return
    end
    if icon:IsA("Frame") then
        for _, child in ipairs(icon:GetDescendants()) do
            if child:IsA("ImageLabel") then child.ImageColor3 = color end
            if child:IsA("TextLabel") then child.TextColor3 = color end
        end
    end
end

local function PositionPopup(library, popup, anchor, width, height)
    if not library or not library.PopupLayer or not popup or not anchor then return end
    if not popup.Parent then return end
    local viewport = library.PopupLayer.AbsoluteSize
    if viewport.X <= 0 or viewport.Y <= 0 then
        local camera = workspace.CurrentCamera
        viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    end
    local anchorPosition = anchor.AbsolutePosition
    local anchorSize = anchor.AbsoluteSize
    local popupWidth = math.max(180, tonumber(width) or 220)
    local popupHeight = math.max(40, tonumber(height) or 120)
    local x = Clamp(anchorPosition.X, 8, math.max(8, viewport.X - popupWidth - 8))
    local belowY = anchorPosition.Y + anchorSize.Y + 8
    local aboveY = anchorPosition.Y - popupHeight - 8
    local y = belowY
    if y + popupHeight > viewport.Y - 8 and aboveY >= 8 then
        y = aboveY
    else
        y = Clamp(y, 8, math.max(8, viewport.Y - popupHeight - 8))
    end
    popup.Position = UDim2.fromOffset(x, y)
    popup.Size = UDim2.fromOffset(popupWidth, popupHeight)
end

local function StopPopupTracking(component)
    if component and component.Data and component.Data.PopupTracking then
        pcall(function() component.Data.PopupTracking:Disconnect() end)
        component.Data.PopupTracking = nil
    end
    if component and component.Library and component.Library._OpenPopups then
        component.Library._OpenPopups[component] = nil
    end
end

local function StartPopupTracking(component, anchor, popup, width, height)
    StopPopupTracking(component)
    PositionPopup(component.Library, popup, anchor, width, height)
    if component.Library and component.Library._OpenPopups then
        component.Library._OpenPopups[component] = true
    end
    component.Data.PopupTracking = RunService.RenderStepped:Connect(function()
        if component.Destroyed or not popup.Parent or not popup.Visible then
            StopPopupTracking(component)
            return
        end
        PositionPopup(component.Library, popup, anchor, width, height)
    end)
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
        Destroyed = false,
        Config = options.Config or {},
        _OpenPopups = {},
        _FocusedWindow = nil
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
    local popupLayer = New("Frame", {
        Name = "PopupLayer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 250,
        ClipsDescendants = false
    }, gui)
    self.PopupLayer = popupLayer
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
    local visible = value == true
    if not visible then self:ClosePopups() end
    if self.Gui then self.Gui.Enabled = visible end
    if self.PopupLayer then self.PopupLayer.Visible = visible end
    for _, window in ipairs(self.Windows) do
        if window and not window.Destroyed then window.Root.Visible = visible end
    end
    return self
end


function IrisHub:ClosePopupsExcept(exception)
    for popupComponent in pairs(self._OpenPopups or {}) do
        if popupComponent ~= exception and popupComponent and not popupComponent.Destroyed and type(popupComponent.Close) == "function" then
            pcall(function() popupComponent:Close() end)
        end
    end
    return self
end

function IrisHub:ClosePopups()
    return self:ClosePopupsExcept(nil)
end

function IrisHub:SetBackgroundImage(image, transparency, tileSize, tint)
    for _, window in ipairs(self.Windows) do
        if window and not window.Destroyed and type(window.SetBackgroundImage) == "function" then
            window:SetBackgroundImage(image, transparency, tileSize, tint)
        end
    end
    return self
end

function IrisHub:ClearBackgroundImage()
    for _, window in ipairs(self.Windows) do
        if window and not window.Destroyed and type(window.ClearBackground) == "function" then
            window:ClearBackgroundImage()
        end
    end
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

function IrisHub:RegisterIconURL(name, url)
    assert(type(name) == "string", "Icon name must be a string")
    assert(type(url) == "string", "Icon URL must be a string")
    self.Options.IconURLs = self.Options.IconURLs or {}
    self.Options.IconURLs[name] = url
    return self
end

function IrisHub:RegisterIconURLSet(provider, icons)
    assert(type(provider) == "string", "Icon provider must be a string")
    assert(type(icons) == "table", "Icon URL set must be a table")
    self.Options.IconURLs = self.Options.IconURLs or {}
    for name, url in pairs(icons) do
        self.Options.IconURLs[string.lower(provider) .. ":" .. string.lower(tostring(name))] = url
    end
    return self
end

function IrisHub:GetIconURL(name)
    if type(self.Options.IconURLs) ~= "table" then return nil end
    return self.Options.IconURLs[name] or self.Options.IconURLs[string.lower(tostring(name or ""))]
end

function IrisHub:GetIconProviders()
    local result = {}
    for key, value in pairs(IconProviders) do
        result[key] = CloneTable(value)
    end
    return result
end

function IrisHub:GetIconCatalog()
    return CloneTable(IconRegistry.BuiltinAssets)
end

function IrisHub:ResolveIcon(icon)
    local asset = ResolveIcon(icon)
    return asset
end

local Window = {}
Window.__index = Window

function Window:ApplyTheme(theme)
    if self.Destroyed then return end
    self.Main.BackgroundColor3 = theme.Surface
    self.Main.BackgroundTransparency = 0
    self.Stroke.Color = theme.Border
    self.Title.TextColor3 = theme.Text
    self.Subtitle.TextColor3 = theme.Muted
    self.StatusText.TextColor3 = theme.Muted
    self.StatusDot.BackgroundColor3 = theme.Success
    self.Breadcrumb.TextColor3 = theme.Muted
    self.Close.BackgroundColor3 = theme.Surface2
    self.Close.TextColor3 = theme.Muted
    self.MinimizeButton.BackgroundColor3 = theme.Surface2
    self.MinimizeButton.TextColor3 = theme.Muted
    self.MaximizeButton.BackgroundColor3 = theme.Surface2
    self.MaximizeButton.TextColor3 = theme.Muted
    self.AccentLine.BackgroundColor3 = theme.Accent
    self.HeaderLine.BackgroundColor3 = theme.Border
    self.Sidebar.BackgroundColor3 = theme.Background
    self.Content.BackgroundColor3 = theme.Background
    self.SidebarHeader.TextColor3 = theme.Muted
    self.SidebarFooter.TextColor3 = theme.Muted
    if self.SidebarDivider then self.SidebarDivider.BackgroundColor3 = theme.Border end
    if self.ContentDivider then self.ContentDivider.BackgroundColor3 = theme.Border end
    if self.BackgroundImage then
        self.BackgroundImage.ImageColor3 = self.BackgroundTint or Color3.new(1, 1, 1)
    end
    if self.BackgroundOverlay then
        self.BackgroundOverlay.BackgroundColor3 = theme.Background
    end
    for _, group in pairs(self.NavGroups or {}) do
        if group.Title then group.Title.TextColor3 = theme.Muted end
    end
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
    local visible = value == true
    if not visible then self.Library:ClosePopups() end
    self.Root.Visible = visible
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
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or self.Library.Gui.AbsoluteSize
        local width = math.max(280, viewport.X - 24)
        local height = math.max(240, viewport.Y - 24)
        Tween(self.Main, {Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(width, height)}, 0.24, Enum.EasingStyle.Quart)
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
    local navSection = options.NavSection and self._EnsureNavSection and self._EnsureNavSection(options.NavSection) or nil
    local button = New("TextButton", {
        BackgroundColor3 = theme.Surface2,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Size = UDim2.new(1, -2, 0, 40),
        ZIndex = 4,
        ClipsDescendants = true,
        LayoutOrder = navSection and navSection:NextOrder() or (#self.TabOrder + 1)
    }, self.TabList)
    Corner(button, 10)
    local icon = CreateIcon(button, options.Icon, 16, theme.Muted)
    local title = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(options.Icon and 38 or 13, 0),
        Size = UDim2.new(1, options.Icon and -50 or -26, 1, 0),
        Font = theme.SmallFont,
        Text = tostring(options.Title or "Tab"),
        TextSize = 11,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5
    }, button)
    local activeBar = New("Frame", {
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(2, 20),
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
        ClipsDescendants = true,
        ScrollBarImageTransparency = 0.1
    }, self.Pages)
    Padding(page, 16, 18, 14, 22)
    local layout = New("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    local tab = setmetatable({
        Library = self.Library,
        Window = self,
        TabButton = button,
        Title = title,
        Icon = icon,
        ActiveBar = activeBar,
        ButtonStroke = Stroke(button, theme.Border, 1, 1),
        Page = page,
        Layout = layout,
        Components = {},
        LayoutCounter = 0,
        Name = tostring(options.Title or "Tab"),
        Locked = options.Locked == true,
        ApplyTheme = function(tabSelf, themeData)
            tabSelf.Title.TextColor3 = tabSelf.Locked and themeData.Muted or (tabSelf.Active and themeData.Text or themeData.Muted)
            tabSelf.TabButton.BackgroundColor3 = tabSelf.Active and themeData.Surface3 or themeData.Surface2
            tabSelf.TabButton.BackgroundTransparency = tabSelf.Active and 0.02 or 1
            if tabSelf.ButtonStroke then tabSelf.ButtonStroke.Color = themeData.Border; tabSelf.ButtonStroke.Transparency = tabSelf.Active and 0.35 or 1 end
            if tabSelf.Icon then
                local iconColor = tabSelf.Active and themeData.Accent or themeData.Muted
                SetIconColor(tabSelf.Icon, iconColor)
            end
            if tabSelf.ActiveBar then tabSelf.ActiveBar.BackgroundColor3 = themeData.Accent end
        end,
        Active = false
    }, {__index = {}})
    local methods = {}
    local proxy = setmetatable(tab, {__index = methods})

    function methods:_add(component)
        self.LayoutCounter = self.LayoutCounter + 1
        if component.Instance and component.Instance.LayoutOrder == 0 then
            component.Instance.LayoutOrder = self.LayoutCounter
        end
        table.insert(self.Components, component)
        if component.Kind == "Section" then
            self.ActiveSection = component
        elseif self.ActiveSection then
            component.Data.SectionOwner = self.ActiveSection
            table.insert(self.ActiveSection.Children, component)
            if self.ActiveSection.Data.Expanded == false then
                component:SetVisible(false)
            end
        end
        return self.Library:_register(component)
    end

    function methods:Reflow()
        if self.Destroyed then return self end
        for _, component in ipairs(self.Components) do
            if component and not component.Destroyed and type(component.Reflow) == "function" then
                pcall(function() component:Reflow() end)
            end
        end
        return self
    end

    function methods:Refresh()
        if self.Destroyed then return self end
        local visible = self.Active == true
        self.Page.Visible = visible
        for _, component in ipairs(self.Components) do
            if component and not component.Destroyed and component.Instance then
                local section = component.Data.SectionOwner
                component.Instance.Visible = visible and not (section and section.Data and section.Data.Expanded == false)
            end
        end
        self:Reflow()
        return self
    end

    function methods:SetActive(value)
        self.Active = value == true
        if self.Active then self.Library:ClosePopups() end
        self.Page.Visible = self.Active
        self.TabButton.BackgroundColor3 = self.Active and self.Library.Theme.Surface3 or self.Library.Theme.Surface2
        self.TabButton.BackgroundTransparency = self.Active and 0.02 or 1
        if self.ButtonStroke then self.ButtonStroke.Color = self.Library.Theme.Border; self.ButtonStroke.Transparency = self.Active and 0.18 or 1 end
        self.Title.TextColor3 = self.Locked and self.Library.Theme.Muted or (self.Active and self.Library.Theme.Text or self.Library.Theme.Muted)
        if self.Icon then
            local iconColor = self.Active and self.Library.Theme.Accent or self.Library.Theme.Muted
            SetIconColor(self.Icon, iconColor)
        end
        self.ActiveBar.Visible = self.Active and not self.Locked
        if self.Active then
            self.Window.ActiveTab = self
            self.Window.Breadcrumb.Text = self.Name
        end
        self:Refresh()
        return self
    end

    local userConnections = ConnectionBag.new()
    userConnections:Add(page:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if page.AbsoluteSize.X > 0 then task.defer(function() if not proxy.Destroyed then proxy:Reflow() end end) end
    end))
    userConnections:Add(button.Activated:Connect(function()
        if proxy.Locked then return end
        for _, other in pairs(proxy.Window.Tabs) do
            if other ~= proxy then other:SetActive(false) end
        end
        proxy:SetActive(true)
    end))
    userConnections:Add(button.MouseEnter:Connect(function()
        if not proxy.Active and not proxy.Locked then Tween(button, {BackgroundTransparency = 0.84}, 0.12) end
    end))
    userConnections:Add(button.MouseLeave:Connect(function()
        if not proxy.Active then Tween(button, {BackgroundTransparency = 1}, 0.12) end
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

    function methods:Select()
        if self.Locked then return self end
        for _, other in pairs(self.Window.Tabs) do
            if other ~= self then other:SetActive(false) end
        end
        return self:SetActive(true)
    end

    function methods:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        if self.Connections then self.Connections:Clear() end
        for _, component in ipairs(self.Components) do
            pcall(function() component:Destroy() end)
        end
        if self.Page then pcall(function() self.Page:Destroy() end) end
        self.Window.Tabs[self.Name] = nil
        if self.Window.ActiveTab == self then self.Window.ActiveTab = nil end
    end

    local function makeRow(opts, height)
        opts = opts or {}
        local minimum = tonumber(height) or 52
        local row = New("Frame", {
            BackgroundColor3 = theme.Surface2,
            BackgroundTransparency = opts.Transparent and 1 or 0.06,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, minimum),
            LayoutOrder = opts.LayoutOrder or 0,
            ClipsDescendants = true,
            AutomaticSize = Enum.AutomaticSize.None
        }, page)
        New("UISizeConstraint", {MinSize = Vector2.new(0, minimum), MaxSize = Vector2.new(math.huge, math.huge)}, row)
        Corner(row, math.max(10, theme.Radius - 2))
        Stroke(row, theme.Border, 0.88, 1)
        return row
    end

    function methods:CreateSection(opts)
        opts = opts or {}
        local titleText = tostring(opts.Title or "Section")
        local descriptionText = tostring(opts.Description or opts.Desc or "")
        local baseHeight = descriptionText ~= "" and 58 or 44
        local row = New("TextButton", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, baseHeight),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = opts.LayoutOrder or 0,
            ClipsDescendants = true
        }, page)
        local titleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(10, descriptionText ~= "" and 5 or 0),
            Size = UDim2.new(1, -44, 0, 19),
            Font = theme.SmallFont,
            Text = titleText,
            TextSize = 12,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, row)
        local description = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(10, 26),
            Size = UDim2.new(1, -44, 0, 17),
            Font = theme.Font,
            Text = descriptionText,
            TextSize = 10,
            TextColor3 = theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Visible = descriptionText ~= ""
        }, row)
        local accent = New("Frame", {
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(2, 22),
            Visible = false
        }, row)
        Corner(accent, 1)
        local chevron = CreateIcon(row, descriptionText ~= "" and "chevron-down" or "chevron-right", 13, theme.Muted, "right")
        if chevron then
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position = UDim2.new(1, -10, 0.5, 0)
        end
        local line = New("Frame", {
            BackgroundColor3 = theme.Border,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 1, -1),
            Size = UDim2.new(1, -20, 0, 1)
        }, row)
        local comp = Component.new(self.Library, "Section", row, {Value = true, Expanded = opts.DefaultExpanded ~= false, Title = titleLabel, Description = description, Chevron = chevron, Line = line, Accent = accent})
        local function refresh()
            local expanded = comp.Data.Expanded == true
            accent.Visible = expanded
            if chevron then
                local iconName = expanded and "chevron-down" or "chevron-right"
                local asset = ResolveIcon(iconName)
                if asset then chevron.Image = asset end
            end
            titleLabel.TextColor3 = expanded and self.Library.Theme.Text or self.Library.Theme.Muted
            for _, child in ipairs(comp.Children) do
                if child and not child.Destroyed then child:SetVisible(expanded) end
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
        function comp:Reflow()
            local width = math.max(160, page.AbsoluteSize.X - 54)
            local required = descriptionText ~= "" and 58 or 44
            self.Instance.Size = UDim2.new(1, -4, 0, required)
            if self.Data.Description.Visible then
                self.Data.Description.Size = UDim2.new(1, -44, 0, 17)
                self.Data.Title.Size = UDim2.new(1, -44, 0, 19)
            end
            return self
        end
        comp.ApplyTheme = function(c, t)
            c.Data.Title.TextColor3 = c.Data.Expanded and t.Text or t.Muted
            c.Data.Description.TextColor3 = t.Muted
            c.Data.Line.BackgroundColor3 = t.Border
            c.Data.Accent.BackgroundColor3 = t.Accent
            SetIconColor(c.Data.Chevron, t.Muted)
        end
        comp:AddConnection(row.Activated:Connect(function() comp:Toggle() end))
        refresh()
        return self:_add(comp)
    end

    function methods:CreateLabel(opts)
        opts = opts or {}
        local text = tostring(opts.Text or opts.Title or "Label")
        local textSize = opts.TextSize or 13
        local width = math.max(160, page.AbsoluteSize.X - 42)
        local height = opts.Height or math.max(36, MeasureTextHeight(text, opts.Font or theme.Font, textSize, width, textSize + 8) + 16)
        local row = makeRow(opts, height)
        local label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -28, 1, 0),
            Position = UDim2.fromOffset(14, 0),
            Font = opts.Font or theme.Font,
            Text = text,
            TextSize = textSize,
            TextColor3 = opts.Color or theme.Text,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        }, row)
        local comp = Component.new(self.Library, "Label", row, {Value = label.Text, Label = label, TextSize = textSize, Font = opts.Font or theme.Font, Color = opts.Color})
        function comp:Reflow()
            local width = math.max(120, page.AbsoluteSize.X - 42)
            if opts.Height == nil then
                local height = math.max(36, MeasureTextHeight(self.Data.Label.Text, self.Data.Font, self.Data.TextSize, width, self.Data.TextSize + 4) + 16)
                self.Instance.Size = UDim2.new(1, -4, 0, height)
            end
            return self
        end
        comp.ApplyTheme = function(c, t) c.Label.TextColor3 = opts.Color or t.Text end
        return self:_add(comp)
    end

    function methods:CreateParagraph(opts)
        opts = opts or {}
        local titleText = tostring(opts.Title or "Paragraph")
        local bodyText = tostring(opts.Content or opts.Description or "")
        local bodySize = opts.TextSize or 12
        local availableWidth = math.max(180, page.AbsoluteSize.X - 42)
        local bodyHeight = MeasureTextHeight(bodyText, theme.Font, bodySize, availableWidth, 18)
        local rowHeight = math.max(tonumber(opts.Height) or 0, math.max(74, bodyHeight + 48))
        local row = makeRow(opts, rowHeight)
        local titleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 9),
            Size = UDim2.new(1, -28, 0, 22),
            Font = theme.TitleFont,
            Text = titleText,
            TextSize = 14,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, row)
        local body = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 32),
            Size = UDim2.new(1, -28, 0, bodyHeight),
            Font = theme.Font,
            Text = bodyText,
            TextSize = bodySize,
            TextColor3 = theme.Muted,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            RichText = opts.RichText ~= false
        }, row)
        local comp = Component.new(self.Library, "Paragraph", row, {Title = titleLabel, Content = body, Value = bodyText})
        function comp:Set(value)
            self.Data.Value = tostring(value or "")
            self.Data.Content.Text = self.Data.Value
            self:Reflow()
            return self
        end
        function comp:Reflow()
            local width = math.max(160, page.AbsoluteSize.X - 42)
            local measured = MeasureTextHeight(self.Data.Content.Text, self.Data.Content.Font, self.Data.Content.TextSize, width, 18)
            local height = math.max(tonumber(opts.Height) or 0, math.max(74, measured + 48))
            self.Instance.Size = UDim2.new(1, -4, 0, height)
            self.Data.Content.Size = UDim2.new(1, -28, 0, measured)
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
        comp:AddConnection(button.MouseButton1Down:Connect(function() Tween(row, {BackgroundTransparency = 0.04}, 0.08) end))
        comp:AddConnection(button.MouseButton1Up:Connect(function() Tween(row, {BackgroundTransparency = 0}, 0.12) end))
        comp:AddConnection(button.Activated:Connect(function() if comp.Data.Enabled ~= false then Fire(comp.Data.Callback) end end))
        return self:_add(comp)
    end

    function methods:CreateToggle(opts)
        opts = opts or {}
        local descriptionText = tostring(opts.Description or "")
        local availableWidth = math.max(180, page.AbsoluteSize.X - 126)
        local descriptionHeight = descriptionText ~= "" and MeasureTextHeight(descriptionText, theme.Font, 11, availableWidth, 16) or 0
        local computedHeight = math.max(58, 37 + descriptionHeight)
        local rowHeight = math.max(tonumber(opts.Height) or 0, computedHeight)
        local row = makeRow(opts, rowHeight)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -94, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Title or "Toggle"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local desc = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 29), Size = UDim2.new(1, -96, 0, math.max(18, descriptionHeight)), Font = theme.Font, Text = descriptionText, TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Visible = descriptionText ~= ""}, row)
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
        function comp:Reflow()
            local width = math.max(160, page.AbsoluteSize.X - 126)
            local measured = descriptionText ~= "" and MeasureTextHeight(self.Data.Description.Text, self.Data.Description.Font, self.Data.Description.TextSize, width, 16) or 0
            local height = math.max(tonumber(opts.Height) or 0, math.max(58, 37 + measured))
            self.Instance.Size = UDim2.new(1, -4, 0, height)
            self.Data.Description.Size = UDim2.new(1, -96, 0, math.max(18, measured))
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
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 7), Size = UDim2.new(1, -178, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Title or "Dropdown"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local selected = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0), Size = UDim2.fromOffset(132, 24), Font = theme.Font, Text = tostring(opts.Default or "Select"), TextSize = 12, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local arrow = CreateIcon(row, "lucide:chevron-down", 15, theme.Muted, "right")
        if arrow then arrow.AnchorPoint = Vector2.new(1, 0.5); arrow.Position = UDim2.new(1, -10, 0.5, 0) end
        local hit = New("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false}, row)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6), ClipsDescendants = true, Visible = false, ZIndex = 20}, row)
        Corner(popup, math.max(11, theme.Radius))
        Stroke(popup, theme.Border, 0.15, 1)
        local search = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 30), PlaceholderText = "Search...", PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false, Visible = opts.Search ~= false}, popup)
        Corner(search, 9)
        Padding(search, 10, 10, 0, 0)
        local list = New("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, opts.Search == false and 0 or 46), Size = UDim2.new(1, 0, 1, -(opts.Search == false and 0 or 46)), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollBarThickness = 3, ZIndex = 21}, popup)
        Padding(list, 8, 8, 8, 8)
        local layout2 = New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, list)
        local comp = Component.new(self.Library, "Dropdown", row, {Value = opts.Default, Options = normalizeOptions(opts.Options), Title = title, Selected = selected, Popup = popup, List = list, Search = search, Open = false, OptionButtons = {}, Callback = opts.Callback})
        local renderOptions
        local popupHeight = math.min(250, 56 + #comp.Data.Options * 36)
        local function closePopup()
            comp.Data.Open = false
            popup.Visible = false
            StopPopupTracking(comp)
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
            popup.Parent = self.Library.PopupLayer or self.Library.Gui
            popup.ZIndex = 250
            popup.Visible = true
            popupHeight = math.min(250, 56 + #self.Data.Options * 36)
            StartPopupTracking(self, row, popup, math.max(220, row.AbsoluteSize.X), popupHeight)
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
                    Corner(itemButton, 8)
                    local itemIcon = item.Icon and CreateIcon(itemButton, item.Icon, 15, self.Library.Theme.Muted) or nil
                    if itemIcon then itemIcon.ZIndex = 23 end
                    local itemLabel = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(itemIcon and 34 or 10, 0), Size = UDim2.new(1, itemIcon and -46 or -20, 1, 0), Font = self.Library.Theme.Font, Text = label, TextSize = 12, TextColor3 = item.Disabled and self.Library.Theme.Muted or self.Library.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 23}, itemButton)
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
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -178, 0, 20), Font = theme.SmallFont, Text = opts.Title, TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
        local selected = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0), Size = UDim2.fromOffset(132, 30), Font = theme.Font, Text = "0 selected", TextSize = 12, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local arrow = CreateIcon(row, "lucide:chevron-down", 15, theme.Muted, "right")
        if arrow then arrow.AnchorPoint = Vector2.new(1, 0.5); arrow.Position = UDim2.new(1, -10, 0.5, 0) end
        local hit = New("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false}, row)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6), ClipsDescendants = true, Visible = false, ZIndex = 20}, row)
        Corner(popup, math.max(11, theme.Radius))
        Stroke(popup, theme.Border, 0.15, 1)
        local search = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(8, 8), Size = UDim2.new(1, -16, 0, 30), PlaceholderText = "Search...", PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false}, popup)
        Corner(search, 9)
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
                    Corner(btn, 8)
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
        function comp:Open()
            self.Data.Open = true
            popup.Parent = self.Library.PopupLayer or self.Library.Gui
            popup.ZIndex = 250
            popup.Visible = true
            local height = math.min(286, 92 + #self.Data.Options * 36)
            StartPopupTracking(self, row, popup, math.max(240, row.AbsoluteSize.X), height)
            return self
        end
        function comp:Close()
            self.Data.Open = false
            popup.Visible = false
            StopPopupTracking(self)
            return self
        end
        function comp:Toggle()
            if self.Data.Open then return self:Close() end
            return self:Open()
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
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -112, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Title or "Image Dropdown"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local preview = New("ImageLabel", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0), Size = UDim2.fromOffset(38, 38), Image = "", ScaleType = Enum.ScaleType.Crop}, row)
        Corner(preview, 10)
        Stroke(preview, theme.Border, 0.35, 1)
        local arrow = CreateIcon(row, "lucide:chevron-down", 14, theme.Muted, "right")
        if arrow then arrow.AnchorPoint = Vector2.new(1, 0.5); arrow.Position = UDim2.new(1, -10, 0.5, 0) end
        local hit = New("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false}, row)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6), ClipsDescendants = true, Visible = false, ZIndex = 20}, row)
        Corner(popup, math.max(11, theme.Radius))
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
                Corner(card, 10)
                local imageSource = tostring(item.Image or item.Icon or "")
                local image = New("ImageLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -14, 0, 42), Position = UDim2.fromOffset(7, 7), Image = imageSource, ScaleType = Enum.ScaleType.Crop, ZIndex = 23}, card)
                Corner(image, 8)
                local lbl = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 7, 1, -23), Size = UDim2.new(1, -14, 0, 18), Font = self.Library.Theme.Font, Text = tostring(item.Label or item.Value), TextSize = 10, TextColor3 = self.Library.Theme.Text, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 23}, card)
                if not item.Disabled then comp.DynamicConnections:Add(card.Activated:Connect(function() comp:Set(item.Value); comp:Close() end)) end
            end
        end
        function comp:Set(value, silent)
            self.Data.Value = value
            for _, item in ipairs(self.Data.Options) do if item.Value == value then self.Data.Preview.Image = tostring(item.Image or item.Icon or ""); break end end
            if not silent then Fire(comp.Data.Callback, value) end
            return self
        end
        function comp:Open()
            self.Data.Open = true
            popup.Parent = self.Library.PopupLayer or self.Library.Gui
            popup.ZIndex = 250
            popup.Visible = true
            StartPopupTracking(self, row, popup, math.max(300, row.AbsoluteSize.X), 190)
            return self
        end
        function comp:Close()
            self.Data.Open = false
            popup.Visible = false
            StopPopupTracking(self)
            return self
        end
        function comp:Toggle()
            if self.Data.Open then return self:Close() end
            return self:Open()
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
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 7), Size = UDim2.new(1, -120, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Title or "Slider"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
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
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 6), Size = UDim2.new(1, -190, 0, 18), Font = theme.SmallFont, Text = tostring(opts.Title or "Input"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local box = New("TextBox", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(164, 34), PlaceholderText = tostring(opts.Placeholder or "Enter value..."), PlaceholderColor3 = theme.Muted, Text = tostring(opts.Default or ""), TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left}, row)
        Corner(box, 9)
        Stroke(box, theme.Border, 0.35, 1)
        Padding(box, 10, 10, 0, 0)
        local comp = Component.new(self.Library, "Input", row, {Value = box.Text, Title = title, Box = box, Callback = opts.Callback})
        function comp:Set(value)
            self.Data.Value = tostring(value or "")
            self.Data.Box.Text = self.Data.Value
            return self
        end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Box.BackgroundColor3 = t.Surface; c.Data.Box.TextColor3 = t.Text; c.Data.Box.PlaceholderColor3 = t.Muted end
        comp:AddConnection(box.FocusLost:Connect(function() comp.Data.Value = box.Text; Fire(comp.Data.Callback, box.Text) end))
        return self:_add(comp)
    end

    function methods:CreateKeybind(opts)
        opts = opts or {}
        local row = makeRow(opts, 56)
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -106, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Title or "Keybind"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local keyButton = New("TextButton", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(76, 32), Text = tostring(opts.Default or "None"), Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Text, AutoButtonColor = false}, row)
        Corner(keyButton, 9)
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
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(0.56, 0, 1, 0), Font = theme.SmallFont, Text = tostring(opts.Title or "Color Picker"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local preview = New("TextButton", {BackgroundColor3 = opts.Default or theme.Accent, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(64, 30), Text = "", AutoButtonColor = false}, row)
        Corner(preview, 7)
        Stroke(preview, theme.Border, 0.35, 1)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.fromOffset(270, 140), Position = UDim2.new(1, -270, 1, 7), Visible = false, ZIndex = 30}, row)
        Corner(popup, math.max(11, theme.Radius))
        Stroke(popup, theme.Border, 0.1, 1)
        local hexLabel = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(30, 24), Font = theme.SmallFont, Text = "Hex", TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 31}, popup)
        local hex = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(48, 8), Size = UDim2.fromOffset(210, 28), PlaceholderText = "#8F78FF", PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 11, ClearTextOnFocus = false, ZIndex = 31}, popup)
        Corner(hex, 8)
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
        Corner(apply, 9)
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
            if self.Data.Open then return self:Close() end
            return self:Open()
        end
        function comp:Open()
            self.Data.Open = true
            self.Data.Popup.Parent = self.Library.PopupLayer or self.Library.Gui
            self.Data.Popup.ZIndex = 250
            self.Data.Popup.Visible = true
            StartPopupTracking(self, row, self.Data.Popup, 280, 214)
            return self
        end
        function comp:Close()
            self.Data.Open = false
            self.Data.Popup.Visible = false
            StopPopupTracking(self)
            return self
        end
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
        local titleText = tostring(opts.Title or "Card")
        local bodyText = tostring(opts.Description or opts.Content or "")
        local bodyHeight = MeasureTextHeight(bodyText, theme.Font, 11, math.max(180, page.AbsoluteSize.X - 48), 18)
        local height = math.max(tonumber(opts.Height) or 0, math.max(100, bodyHeight + 58))
        local card = makeRow(opts, height)
        local icon = opts.Icon and CreateIcon(card, opts.Icon, 17, theme.Accent) or nil
        if icon then
            icon.Position = UDim2.fromOffset(14, 20)
            icon.AnchorPoint = Vector2.new(0, 0.5)
        end
        local titleX = icon and 40 or 14
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(titleX, 10), Size = UDim2.new(1, -titleX - 14, 0, 22), Font = theme.TitleFont, Text = titleText, TextSize = 14, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, card)
        local body = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 36), Size = UDim2.new(1, -28, 0, bodyHeight), Font = theme.Font, Text = bodyText, TextSize = 11, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, card)
        local comp = Component.new(self.Library, "Card", card, {Title = title, Content = body, Value = body.Text})
        function comp:Set(value) self.Data.Value = tostring(value or ""); self.Data.Content.Text = self.Data.Value; self:Reflow(); return self end
        function comp:Reflow()
            local width = math.max(160, page.AbsoluteSize.X - 48)
            local measured = MeasureTextHeight(self.Data.Content.Text, self.Data.Content.Font, self.Data.Content.TextSize, width, 18)
            local height = math.max(tonumber(opts.Height) or 0, math.max(100, measured + 58))
            self.Instance.Size = UDim2.new(1, -4, 0, height)
            self.Data.Content.Size = UDim2.new(1, -28, 0, measured)
            return self
        end
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
        comp:AddConnection(RunService.Heartbeat:Connect(function(delta)
            if comp.Data.Value and spinner.Parent then rotation = rotation + delta * 240; spinner.Rotation = rotation end
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
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -114, 0, 20), Font = theme.SmallFont, Text = tostring(opts.Title or "Progress"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
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
        local statusText = tostring(opts.Description or opts.Text or "Ready")
        local statusHeight = MeasureTextHeight(statusText, theme.Font, 10, math.max(180, page.AbsoluteSize.X - 78), 16)
        local rowHeight = math.max(tonumber(opts.Height) or 0, math.max(50, 31 + statusHeight))
        row.Size = UDim2.new(1, -4, 0, rowHeight)
        local description = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(32, 26), Size = UDim2.new(1, -46, 0, statusHeight), Font = theme.Font, Text = statusText, TextSize = 10, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true}, row)
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
            self:Reflow()
            Fire(comp.Data.Callback, state, text)
            return self
        end
        function comp:Reflow()
            local width = math.max(160, page.AbsoluteSize.X - 78)
            local measured = MeasureTextHeight(self.Data.Description.Text, self.Data.Description.Font, self.Data.Description.TextSize, width, 16)
            local height = math.max(tonumber(opts.Height) or 0, math.max(50, 31 + measured))
            self.Instance.Size = UDim2.new(1, -4, 0, height)
            self.Data.Description.Size = UDim2.new(1, -46, 0, measured)
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
        local titleText = tostring(opts.Title or "Alert")
        local bodyText = tostring(opts.Description or opts.Content or "")
        local bodyHeight = MeasureTextHeight(bodyText, theme.Font, 11, math.max(180, page.AbsoluteSize.X - 56), 18)
        local row = makeRow(opts, math.max(tonumber(opts.Height) or 0, math.max(74, bodyHeight + 50)))
        local kind = string.lower(tostring(opts.Type or "Info"))
        local tone = kind == "success" and theme.Success or kind == "warning" and theme.Warning or (kind == "danger" or kind == "error") and theme.Danger or theme.Accent2
        local stripe = New("Frame", {BackgroundColor3 = tone, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 7), Size = UDim2.new(0, 3, 1, -14)}, row)
        Corner(stripe, 2)
        local icon = CreateIcon(row, opts.Icon or ((kind == "success" and "lucide:check") or (kind == "warning" and "lucide:warning") or ((kind == "danger" or kind == "error") and "lucide:error") or "lucide:info"), 16, tone)
        if icon then
            icon.AnchorPoint = Vector2.new(0, 0)
            icon.Position = UDim2.fromOffset(14, 11)
        end
        local titleOffset = icon and 38 or 14
        local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(titleOffset, 9), Size = UDim2.new(1, -titleOffset - 14, 0, 20), Font = theme.TitleFont, Text = titleText, TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd}, row)
        local body = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 32), Size = UDim2.new(1, -28, 0, bodyHeight), Font = theme.Font, Text = bodyText, TextSize = 11, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, row)
        local comp = Component.new(self.Library, "Alert", row, {Value = kind, Title = title, Description = body, Stripe = stripe})
        function comp:Set(state, text)
            self.Data.Value = string.lower(tostring(state or "Info"))
            if text ~= nil then self.Data.Description.Text = tostring(text) end
            self.Data.Stripe.BackgroundColor3 = (self.Data.Value == "success" and self.Library.Theme.Success) or (self.Data.Value == "warning" and self.Library.Theme.Warning) or (self.Data.Value == "danger" or self.Data.Value == "error") and self.Library.Theme.Danger or self.Library.Theme.Accent2
            self:Reflow()
            return self
        end
        function comp:Reflow()
            local width = math.max(160, page.AbsoluteSize.X - 56)
            local measured = MeasureTextHeight(self.Data.Description.Text, self.Data.Description.Font, self.Data.Description.TextSize, width, 18)
            local height = math.max(tonumber(opts.Height) or 0, math.max(74, measured + 50))
            self.Instance.Size = UDim2.new(1, -4, 0, height)
            self.Data.Description.Size = UDim2.new(1, -28, 0, measured)
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
        if opts.Icon and icon then
            SetIconColor(icon, color)
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
        Corner(copy, 8)
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
        local hitTarget = New("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Text = "", AutoButtonColor = false, Active = true, ZIndex = 50}, trigger)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.fromOffset(228, 0), Position = UDim2.fromOffset(0, 0), Visible = false, ClipsDescendants = true, ZIndex = 250}, self.Library.PopupLayer or self.Library.Gui)
        Corner(popup, math.max(11, theme.Radius))
        Stroke(popup, theme.Border, 0.18, 1)
        local list = New("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, popup)
        Padding(popup, 7, 7, 7, 7)
        local comp = Component.new(self.Library, "ContextMenu", trigger, {Value = false, Trigger = hitTarget, Popup = popup, Title = label, Items = opts.Items or {}, Open = false})
        local function render()
            comp.DynamicConnections:Clear()
            for _, child in ipairs(popup:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
            for _, item in ipairs(comp.Data.Items) do
                local button = New("TextButton", {BackgroundColor3 = self.Library.Theme.Surface2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 30), Text = tostring(item.Title or item.Label or "Item"), Font = self.Library.Theme.Font, TextSize = 11, TextColor3 = item.Disabled and self.Library.Theme.Muted or self.Library.Theme.Text, AutoButtonColor = false, ZIndex = 41}, popup)
                Corner(button, 8)
                Padding(button, 9, 9, 0, 0)
                if not item.Disabled then comp.DynamicConnections:Add(button.Activated:Connect(function() Fire(item.Callback); comp:Close() end)) end
            end
        end
        function comp:Open()
            self.Data.Open = true
            self.Data.Popup.Parent = self.Library.PopupLayer or self.Library.Gui
            self.Data.Popup.ZIndex = 250
            self.Data.Popup.Visible = true
            StartPopupTracking(self, trigger, self.Data.Popup, 240, math.min(280, 14 + #self.Data.Items * 34))
            return self
        end
        function comp:Close()
            self.Data.Open = false
            self.Data.Popup.Visible = false
            StopPopupTracking(self)
            return self
        end
        function comp:Toggle() if self.Data.Open then return self:Close() end return self:Open() end
        function comp:SetItems(items) self.Data.Items = items or {}; render(); return self end
        comp.ApplyTheme = function(c, t) c.Data.Title.TextColor3 = t.Text; c.Data.Popup.BackgroundColor3 = t.Surface; local stroke = c.Data.Popup:FindFirstChildOfClass("UIStroke"); if stroke then stroke.Color = t.Border end; render() end
        comp:AddConnection(hitTarget.Activated:Connect(function() comp:Toggle() end))
        comp:AddConnection(hitTarget.MouseButton2Click:Connect(function() comp:Toggle() end))
        comp:AddConnection(UserInputService.InputBegan:Connect(function(input)
            if not comp.Data.Open then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local p = input.Position
                local pos = comp.Data.Popup.AbsolutePosition
                local size = comp.Data.Popup.AbsoluteSize
                if p.X < pos.X or p.X > pos.X + size.X or p.Y < pos.Y or p.Y > pos.Y + size.Y then comp:Close() end
            end
        end))
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
        local tooltipText = tostring(opts.Text or opts.Description or "Tooltip")
        local tooltipHeight = MeasureTextHeight(tooltipText, theme.Font, 11, 200, 18)
        local popup = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.fromOffset(230, tooltipHeight + 16), Visible = false, ZIndex = 350}, self.Library.PopupLayer or self.Library.Gui)
        Corner(popup, theme.Radius - 2)
        Stroke(popup, theme.Border, 0.1, 1)
        local body = New("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, tooltipHeight), Position = UDim2.fromOffset(10, 8), Font = theme.Font, Text = tooltipText, TextSize = 11, TextColor3 = theme.Text, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 91}, popup)
        local controller = {Library = self.Library, Instance = popup, Target = target, Visible = false, Connections = ConnectionBag.new()}
        function controller:Show()
            if self.Visible then return self end
            local position = target.AbsolutePosition
            local size = target.AbsoluteSize
            local viewport = self.Library.PopupLayer and self.Library.PopupLayer.AbsoluteSize or Vector2.new(1280, 720)
            local width = math.max(180, popup.AbsoluteSize.X)
            local x = Clamp(position.X, 8, math.max(8, viewport.X - width - 8))
            local y = Clamp(position.Y + size.Y + 8, 8, math.max(8, viewport.Y - math.max(40, popup.AbsoluteSize.Y) - 8))
            popup.Position = UDim2.fromOffset(x, y)
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
        controller.Connections:Add(UserInputService.InputChanged:Connect(function(input)
            if controller.Visible and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                controller:Show()
            end
        end))
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
    table.insert(self.TabOrder, proxy)
    self.TabList.CanvasSize = UDim2.new()
    if not self.ActiveTab then proxy:SetActive(true) end
    return proxy
end

function IrisHub:CreateWindow(options)
    options = options or {}
    local theme = self.Theme
    local root = New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Visible = true}, self.Gui)
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local minSize = options.MinSize or Vector2.new(520, 360)
    local maxSize = options.MaxSize or Vector2.new(1600, 1000)
    local viewportMax = Vector2.new(math.max(280, viewport.X - 24), math.max(240, viewport.Y - 24))
    minSize = Vector2.new(math.min(minSize.X, viewportMax.X), math.min(minSize.Y, viewportMax.Y))
    maxSize = Vector2.new(math.min(math.max(maxSize.X, minSize.X), viewportMax.X), math.min(math.max(maxSize.Y, minSize.Y), viewportMax.Y))
    local requestedSize = options.Size or UDim2.fromOffset(720, 500)
    if typeof(requestedSize) == "UDim2" and requestedSize.X.Scale == 0 and requestedSize.Y.Scale == 0 then
        requestedSize = UDim2.fromOffset(Clamp(requestedSize.X.Offset, minSize.X, maxSize.X), Clamp(requestedSize.Y.Offset, minSize.Y, maxSize.Y))
    end

    local main = New("Frame", {
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = options.Position or UDim2.fromScale(0.5, 0.5),
        Size = requestedSize,
        ClipsDescendants = true,
        ZIndex = 10
    }, root)
    Corner(main, math.max(15, theme.Radius + 1))
    local outline = Stroke(main, theme.Border, 0.12, 1)
    New("UISizeConstraint", {MinSize = minSize, MaxSize = maxSize}, main)

    local backgroundImage = New("ImageLabel", {
        Name = "BackgroundImage",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Image = "",
        ImageTransparency = Clamp(tonumber(options.BackgroundImageTransparency) or 0.90, 0, 1),
        ImageColor3 = options.BackgroundTint or Color3.new(1, 1, 1),
        ScaleType = string.lower(tostring(options.BackgroundScaleType or "Tile")) == "stretch" and Enum.ScaleType.Stretch or Enum.ScaleType.Tile,
        TileSize = typeof(options.BackgroundTileSize) == "UDim2" and options.BackgroundTileSize or UDim2.fromOffset(128, 128),
        ZIndex = 11,
        Visible = options.BackgroundImage ~= nil and tostring(options.BackgroundImage) ~= ""
    }, main)
    if options.BackgroundImage ~= nil then
        backgroundImage.Image = type(options.BackgroundImage) == "number" and "rbxassetid://" .. tostring(options.BackgroundImage) or tostring(options.BackgroundImage)
    end
    local backgroundOverlay = New("Frame", {
        Name = "BackgroundOverlay",
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = Clamp(tonumber(options.BackgroundTintTransparency) or 0.84, 0, 1),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 12
    }, main)

    local top = New("Frame", {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.03, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 58), ZIndex = 20}, main)
    local brand = New("Frame", {
        BackgroundColor3 = theme.AccentSoft,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(12, 11),
        Size = UDim2.fromOffset(36, 36),
        ZIndex = 21
    }, top)
    Corner(brand, 12)
    local brandIcon = CreateIcon(brand, options.Icon or "sparkles", 16, theme.Text)
    if brandIcon then brandIcon.AnchorPoint = Vector2.new(0.5, 0.5); brandIcon.Position = UDim2.fromScale(0.5, 0.5); brandIcon.ZIndex = 22 end
    local title = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(62, 8),
        Size = UDim2.new(1, -340, 0, 20),
        Font = theme.TitleFont,
        Text = tostring(options.Title or "IrisHub"),
        TextSize = 14,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 22
    }, top)
    local subtitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(62, 28),
        Size = UDim2.new(1, -350, 0, 13),
        Font = theme.Font,
        Text = tostring(options.Subtitle or "Universal UI"),
        TextSize = 8,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 22
    }, top)
    local statusDot = New("Frame", {BackgroundColor3 = theme.Success, BorderSizePixel = 0, Position = UDim2.fromOffset(63, 46), Size = UDim2.fromOffset(5, 5), ZIndex = 22}, top)
    Corner(statusDot, 3)
    local statusText = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(72, 42), Size = UDim2.fromOffset(80, 13), Font = theme.SmallFont, Text = "READY", TextSize = 8, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22}, top)
    local breadcrumb = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -132, 0, 29), Size = UDim2.fromOffset(126, 16), Font = theme.SmallFont, Text = "Main", TextSize = 9, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 22}, top)

    local function topButton(iconName, rightOffset)
        local button = New("TextButton", {BackgroundColor3 = theme.Surface2, BackgroundTransparency = 0.10, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, rightOffset, 0.5, 0), Size = UDim2.fromOffset(31, 31), Text = "", AutoButtonColor = false, ZIndex = 23}, top)
        Corner(button, 10)
        Stroke(button, theme.Border, 0.60, 1)
        local icon = CreateIcon(button, iconName, 13, theme.Muted)
        if icon then icon.AnchorPoint = Vector2.new(0.5, 0.5); icon.Position = UDim2.fromScale(0.5, 0.5); icon.ZIndex = 24 end
        return button, icon
    end
    local close, closeIcon = topButton("x", -10)
    local minimizeButton, minimizeIcon = topButton("minus", -46)
    local maximize, maximizeIcon = topButton("maximize-2", -82)
    local headerLine = New("Frame", {BackgroundColor3 = theme.Border, BackgroundTransparency = 0.52, BorderSizePixel = 0, Position = UDim2.new(0, 12, 1, -1), Size = UDim2.new(1, -24, 0, 1), ZIndex = 24}, top)
    local accentLine = New("Frame", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Position = UDim2.fromOffset(14, 57), Size = UDim2.fromOffset(62, 2), ZIndex = 25}, main)
    Corner(accentLine, 1)

    local body = New("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 60), Size = UDim2.new(1, 0, 1, -60), ZIndex = 19}, main)
    local sidebar = New("Frame", {BackgroundColor3 = theme.Background, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 0), Size = UDim2.new(0, 182, 1, 0), ClipsDescendants = true, ZIndex = 20}, body)
    local sidebarHeader = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 12), Size = UDim2.new(1, -32, 0, 14), Font = theme.SmallFont, Text = "PAGES", TextSize = 8, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 21}, sidebar)
    local tabList = New("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 1, -68), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollBarThickness = 0, ZIndex = 21}, sidebar)
    Padding(tabList, 11, 11, 6, 14)
    New("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, tabList)
    local sidebarFooter = New("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 16, 1, -12), Size = UDim2.new(1, -30, 0, 13), Font = theme.Font, Text = "IrisHub " .. self.Version, TextSize = 8, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 21}, sidebar)
    local sidebarDivider = New("Frame", {BackgroundColor3 = theme.Border, BackgroundTransparency = 0.40, BorderSizePixel = 0, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(1, 1), ZIndex = 22}, sidebar)
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0)

    local content = New("Frame", {BackgroundColor3 = theme.Background, BorderSizePixel = 0, Position = UDim2.fromOffset(169, 0), Size = UDim2.new(1, -183, 1, 0), ClipsDescendants = true, ZIndex = 20}, body)
    local contentDivider = New("Frame", {BackgroundColor3 = theme.Border, BackgroundTransparency = 0.55, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(1, 1), ZIndex = 22}, content)
    contentDivider.Size = UDim2.new(0, 1, 1, 0)
    local pages = New("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 1, 0), ClipsDescendants = true, ZIndex = 21}, content)

    local window = setmetatable({
        Library = self,
        Root = root,
        Main = main,
        Shadow = nil,
        Gradient = nil,
        Size = main.Size,
        Stroke = outline,
        Top = top,
        Brand = brand,
        BrandText = nil,
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
        SidebarDivider = sidebarDivider,
        TabList = tabList,
        Content = content,
        ContentDivider = contentDivider,
        Pages = pages,
        BackgroundImage = backgroundImage,
        BackgroundOverlay = backgroundOverlay,
        BackgroundTint = options.BackgroundTint or Color3.new(1, 1, 1),
        BackgroundImageTransparency = backgroundImage.ImageTransparency,
        BackgroundTileSize = backgroundImage.TileSize,
        Tabs = {},
        TabOrder = {},
        NavGroups = {},
        Connections = ConnectionBag.new(),
        Destroyed = false,
        Minimized = false,
        Maximized = false
    }, Window)
    table.insert(self.Windows, window)

    local navGroupCount = 0
    local navGroups = window.NavGroups
    local function ensureNavSection(name, icon)
        local key = tostring(name or "GENERAL")
        local existing = navGroups[key]
        if existing then return existing end
        navGroupCount = navGroupCount + 1
        local header = New("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -2, 0, 22), LayoutOrder = navGroupCount * 1000 - 1, ZIndex = 22}, tabList)
        local headerIcon = CreateIcon(header, icon, 11, theme.Muted)
        if headerIcon then
            headerIcon.AnchorPoint = Vector2.new(0, 0.5)
            headerIcon.Position = UDim2.fromOffset(0, 12)
            headerIcon.ZIndex = 23
        end
        local headerLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(headerIcon and 18 or 0, 0),
            Size = UDim2.new(1, headerIcon and -18 or 0, 1, 0),
            Font = theme.SmallFont,
            Text = string.upper(key),
            TextSize = 7,
            TextColor3 = theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 23
        }, header)
        local group = {Name = key, Frame = header, Title = headerLabel, Counter = 0, BaseOrder = navGroupCount * 1000}
        function group:NextOrder()
            self.Counter = self.Counter + 1
            return self.BaseOrder + self.Counter
        end
        navGroups[key] = group
        return group
    end
    window._EnsureNavSection = ensureNavSection

    function window:Section(opts)
        opts = opts or {}
        local section = ensureNavSection(opts.Title or "GENERAL", opts.Icon)
        local controller = {Window = self, Name = section.Name, Title = section.Title}
        function controller:Tab(tabOptions)
            tabOptions = CloneTable(tabOptions or {})
            tabOptions.NavSection = self.Name
            return self.Window:CreateTab(tabOptions)
        end
        function controller:GetTabs()
            local result = {}
            for _, tab in ipairs(self.Window.TabOrder) do
                if tab.NavSection == self.Name then table.insert(result, tab) end
            end
            return result
        end
        return controller
    end

    local requestedScale = tonumber(options.UIScale)
    if requestedScale and math.abs(requestedScale - 1) > 0.001 then
        New("UIScale", {Scale = Clamp(requestedScale, 0.75, 1.5)}, root)
    end

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
        local resizeGrip = New("TextButton", {BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -4, 1, -4), Size = UDim2.fromOffset(20, 20), Text = "", AutoButtonColor = false, ZIndex = 60}, main)
        local gripIcon = CreateIcon(resizeGrip, "grip-diagonal-2", 12, theme.Muted)
        if gripIcon then gripIcon.AnchorPoint = Vector2.new(0.5, 0.5); gripIcon.Position = UDim2.fromScale(0.5, 0.5); gripIcon.ZIndex = 61 end
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

    window.Connections:Add(close.MouseEnter:Connect(function() Tween(close, {BackgroundColor3 = theme.Danger, TextColor3 = theme.Text}, 0.10) end))
    window.Connections:Add(close.MouseLeave:Connect(function() Tween(close, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = self.Theme.Muted}, 0.10) end))
    window.Connections:Add(minimizeButton.MouseEnter:Connect(function() Tween(minimizeButton, {BackgroundColor3 = self.Theme.Surface3, TextColor3 = self.Theme.Text}, 0.10) end))
    window.Connections:Add(minimizeButton.MouseLeave:Connect(function() Tween(minimizeButton, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = self.Theme.Muted}, 0.10) end))
    window.Connections:Add(maximize.MouseEnter:Connect(function() Tween(maximize, {BackgroundColor3 = self.Theme.Surface3, TextColor3 = self.Theme.Text}, 0.10) end))
    window.Connections:Add(maximize.MouseLeave:Connect(function() Tween(maximize, {BackgroundColor3 = self.Theme.Surface2, TextColor3 = self.Theme.Muted}, 0.10) end))
    window.Connections:Add(close.Activated:Connect(function()
        if type(options.OnClose) == "function" then Fire(options.OnClose, window) end
        window:Destroy()
    end))
    window.Connections:Add(minimizeButton.Activated:Connect(function() window:Minimize() end))
    window.Connections:Add(maximize.Activated:Connect(function() window:Maximize() end))
    window.Connections:Add(main.InputBegan:Connect(function() window:Focus() end))

    function window:SetBackgroundImage(image, transparency, tileSize, tint)
        if self.Destroyed then return self end
        if image == nil or tostring(image) == "" then
            self:ClearBackground()
            return self
        end
        self.BackgroundImage.Image = type(image) == "number" and "rbxassetid://" .. tostring(image) or tostring(image)
        if transparency ~= nil then
            self.BackgroundImageTransparency = Clamp(tonumber(transparency) or self.BackgroundImageTransparency, 0, 1)
            self.BackgroundImage.ImageTransparency = self.BackgroundImageTransparency
        end
        if typeof(tileSize) == "UDim2" then
            self.BackgroundTileSize = tileSize
            self.BackgroundImage.TileSize = tileSize
        end
        if typeof(tint) == "Color3" then
            self.BackgroundTint = tint
            self.BackgroundImage.ImageColor3 = tint
        end
        self.BackgroundImage.Visible = true
        return self
    end

    function window:ClearBackground()
        self.BackgroundImage.Image = ""
        self.BackgroundImage.Visible = false
        return self
    end

    function window:SetBackgroundTint(color, overlayTransparency)
        if typeof(color) == "Color3" then
            self.BackgroundTint = color
            self.BackgroundImage.ImageColor3 = color
        end
        if overlayTransparency ~= nil then
            self.BackgroundOverlay.BackgroundTransparency = Clamp(tonumber(overlayTransparency) or 0.84, 0, 1)
        end
        return self
    end

    function window:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        self.Library:ClosePopups()
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
            if tab and not tab.Destroyed and tab.Name == target then return tab end
        end
        return nil
    end

    function window:GetActiveTab() return self.ActiveTab end

    function window:SelectTab(name)
        local target = self:GetTab(name)
        if not target or target.Locked then return nil end
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
        tab.NavSection = opts.NavSection
        if opts.OnCreated then Fire(opts.OnCreated, tab) end
        return tab
    end

    local defaultSection = options.DefaultSection or "MAIN"
    local defaultTab = window:CreateTab({Title = options.DefaultTab or "Main", Icon = options.DefaultIcon or "home", NavSection = defaultSection})
    defaultTab:SetActive(true)
    window:ApplyTheme(theme)
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
    local descriptionText = tostring(options.Content or options.Description or "")
    local descriptionHeight = MeasureTextHeight(descriptionText, theme.Font, 11, 270, 18)
    local cardHeight = math.max(78, 52 + descriptionHeight)
    local card = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, cardHeight), LayoutOrder = math.floor(os.clock() * 1000), ZIndex = 300, AutomaticSize = Enum.AutomaticSize.None}, holder)
    Corner(card, theme.Radius + 2)
    Stroke(card, theme.Border, 0.08, 1)
    local accent = New("Frame", {BackgroundColor3 = accentColor, BorderSizePixel = 0, Size = UDim2.fromOffset(3, cardHeight), Position = UDim2.fromOffset(0, 0), ZIndex = 302}, card)
    Corner(accent, 2)
    local icon = CreateIcon(card, options.Icon or (typeName == "Success" and "lucide:check" or typeName == "Warning" and "lucide:warning" or (typeName == "Error" or typeName == "Danger") and "lucide:error" or "lucide:bell"), 19, accentColor)
    if icon then icon.Position = UDim2.fromOffset(16, 18); icon.AnchorPoint = Vector2.new(0, 0) end
    local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(46, 11), Size = UDim2.new(1, -82, 0, 21), Font = theme.TitleFont, Text = tostring(options.Title or "Notification"), TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 103}, card)
    local desc = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(46, 34), Size = UDim2.new(1, -64, 0, descriptionHeight), Font = theme.Font, Text = descriptionText, TextSize = 11, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 303}, card)
    local close = New("TextButton", {BackgroundTransparency = 1, Position = UDim2.new(1, -34, 0, 9), Size = UDim2.fromOffset(24, 24), Text = "", AutoButtonColor = false, ZIndex = 304}, card)
    local closeIcon = CreateIcon(close, "lucide:x", 13, theme.Muted)
    if closeIcon then closeIcon.AnchorPoint = Vector2.new(0.5, 0.5); closeIcon.Position = UDim2.fromScale(0.5, 0.5); closeIcon.ZIndex = 305 end
    local progress = New("Frame", {BackgroundColor3 = accentColor, BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -3), Size = UDim2.fromScale(1, 0.04), ZIndex = 304}, card)
    local duration = tonumber(options.Duration)
    local item = {Instance = card, Destroyed = false, Duration = duration or 0, Type = typeName, Progress = progress, Accent = accentColor}
    function item:SetTitle(value) title.Text = tostring(value or ""); return self end
    function item:SetDescription(value)
        desc.Text = tostring(value or "")
        local nextHeight = math.max(78, 52 + MeasureTextHeight(desc.Text, theme.Font, 11, 270, 18))
        card.Size = UDim2.new(1, 0, 0, nextHeight)
        accent.Size = UDim2.fromOffset(3, nextHeight)
        return self
    end
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
        Tween(card, {BackgroundTransparency = 1, Position = UDim2.new(1, 28, 0, 0)}, 0.16)
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
    local modalWidth = typeof(options.Size) == "UDim2" and options.Size.X.Offset > 0 and options.Size.X.Offset or 420
    local modalDescription = tostring(options.Description or "")
    local modalDescriptionHeight = MeasureTextHeight(modalDescription, theme.Font, 12, math.max(240, modalWidth - 36), 18)
    local modalHeight = typeof(options.Size) == "UDim2" and options.Size.Y.Offset > 0 and math.max(options.Size.Y.Offset, 146 + modalDescriptionHeight) or math.max(220, 146 + modalDescriptionHeight)
    local card = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = options.Size or UDim2.fromOffset(modalWidth, modalHeight), ZIndex = 501}, root)
    Corner(card, theme.Radius + 2)
    Stroke(card, theme.Border, 0.05, 1)
    local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 16), Size = UDim2.new(1, -36, 0, 26), Font = theme.TitleFont, Text = tostring(options.Title or "Modal"), TextSize = 17, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 82}, card)
    local desc = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 48), Size = UDim2.new(1, -36, 0, modalDescriptionHeight), Font = theme.Font, Text = modalDescription, TextSize = 12, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 502}, card)
    local actions = New("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -18, 1, -18), Size = UDim2.fromOffset(240, 42), ZIndex = 502}, card)
    local cancel = New("TextButton", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Size = UDim2.fromOffset(104, 38), Text = tostring(options.CancelText or "Cancel"), Font = theme.SmallFont, TextSize = 12, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 83}, actions)
    Corner(cancel, 10)
    local confirm = New("TextButton", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Position = UDim2.fromOffset(114, 0), Size = UDim2.fromOffset(126, 38), Text = tostring(options.ConfirmText or "Confirm"), Font = theme.SmallFont, TextSize = 12, TextColor3 = theme.Text, AutoButtonColor = false, ZIndex = 83}, actions)
    Corner(confirm, 10)
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
    local root = New("Frame", {BackgroundTransparency = 0, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 600}, self.Gui)
    local scrim = New("Frame", {BackgroundColor3 = theme.Overlay, BackgroundTransparency = 0.18, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 600}, root)
    local keyWidth = typeof(options.Size) == "UDim2" and options.Size.X.Offset > 0 and options.Size.X.Offset or 470
    local keyDescription = tostring(options.Description or "Enter your key to continue. Provider adapters can be registered through IrisHub:RegisterKeyProvider.")
    local keyDescriptionHeight = MeasureTextHeight(keyDescription, theme.Font, 12, math.max(260, keyWidth - 40), 18)
    local keyHeight = typeof(options.Size) == "UDim2" and options.Size.Y.Offset > 0 and math.max(options.Size.Y.Offset, 286 + keyDescriptionHeight) or math.max(330, 286 + keyDescriptionHeight)
    local card = New("Frame", {BackgroundColor3 = theme.Surface, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = options.Size or UDim2.fromOffset(keyWidth, keyHeight), ZIndex = 601}, root)
    Corner(card, theme.Radius + 4)
    Stroke(card, theme.Border, 0.02, 1)
    local accent = New("Frame", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 4), ZIndex = 72}, card)
    Corner(accent, 2)
    local icon = CreateIcon(card, options.Icon or "lucide:key", 20, theme.Accent)
    if icon then icon.Position = UDim2.fromOffset(20, 36); icon.AnchorPoint = Vector2.new(0, 0.5) end
    local title = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(52, 20), Size = UDim2.new(1, -150, 0, 26), Font = theme.TitleFont, Text = tostring(options.Title or "IrisHub Access"), TextSize = 19, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 72}, card)
    local providerTag = New("TextLabel", {BackgroundColor3 = theme.AccentSoft, BackgroundTransparency = 0.08, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -18, 0, 34), Size = UDim2.fromOffset(124, 26), Font = theme.SmallFont, Text = providerName, TextSize = 10, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 72}, card)
    Corner(providerTag, 13)
    local info = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 60), Size = UDim2.new(1, -40, 0, keyDescriptionHeight), Font = theme.Font, Text = keyDescription, TextSize = 12, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 602}, card)
    local providerY = 70 + keyDescriptionHeight + 18
    local providerBox = New("Frame", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(20, providerY), Size = UDim2.new(1, -40, 0, 42), ZIndex = 602}, card)
    Corner(providerBox, 11)
    Stroke(providerBox, theme.Border, 0.35, 1)
    local providerLabel = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -110, 1, 0), Font = theme.SmallFont, Text = "Provider • " .. providerName, TextSize = 11, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 73}, providerBox)
    local cycle = New("TextButton", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(86, 28), Text = "Change", Font = theme.SmallFont, TextSize = 10, TextColor3 = theme.Accent, AutoButtonColor = false, ZIndex = 73}, providerBox)
    local inputY = providerY + 54
    local input = New("TextBox", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(20, inputY), Size = UDim2.new(1, -40, 0, 42), PlaceholderText = tostring(options.Placeholder or "Paste your key"), PlaceholderColor3 = theme.Muted, TextColor3 = theme.Text, Font = theme.Font, TextSize = 12, ClearTextOnFocus = false, ZIndex = 72}, card)
    Corner(input, 10)
    Stroke(input, theme.Border, 0.35, 1)
    Padding(input, 12, 12, 0, 0)
    local statusY = inputY + 47
    local status = New("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(20, statusY), Size = UDim2.new(1, -40, 0, 22), Font = theme.Font, Text = "", TextSize = 11, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 72}, card)
    local actionsY = statusY + 31
    local actions = New("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(20, actionsY), Size = UDim2.new(1, -40, 0, 42), ZIndex = 602}, card)
    local getKey = New("TextButton", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Size = UDim2.fromOffset(122, 40), Text = "Get Key", Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 73}, actions)
    Corner(getKey, 10)
    Stroke(getKey, theme.Border, 0.28, 1)
    local copyLink = New("TextButton", {BackgroundColor3 = theme.Surface2, BorderSizePixel = 0, Position = UDim2.fromOffset(130, 0), Size = UDim2.fromOffset(122, 40), Text = "Copy Link", Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Muted, AutoButtonColor = false, ZIndex = 73}, actions)
    Corner(copyLink, 10)
    Stroke(copyLink, theme.Border, 0.28, 1)
    local submit = New("TextButton", {BackgroundColor3 = theme.Accent, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(136, 40), Text = "Validate Key", Font = theme.SmallFont, TextSize = 11, TextColor3 = theme.Text, AutoButtonColor = false, ZIndex = 73}, actions)
    Corner(submit, 10)
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
