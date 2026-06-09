-- =========================================================================
--  S Y S T E M U I  —  Manhwa / Holographic UI Library
--  Author : CoiledTom
--  Version: 1.0
--  Icons  : Footagesus  (https://github.com/Footagesus/Icons)
-- =========================================================================

--[[
    USAGE:
    local SystemUI = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/SystemUI.lua"
    ))()

    local Win = SystemUI:CreateWindow({
        Title     = "SYSTEM INTERFACE",
        SubTitle  = "SystemUI v1.0",
        Theme     = "Holographic",
        Size      = UDim2.new(0, 620, 0, 460),
        Blur      = true,
        Sounds    = true,
        ToggleKey = Enum.KeyCode.RightShift,
    })
--]]

-- =========================================================================
--  SERVICES
-- =========================================================================
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")
local DataStoreService  = (pcall(function() return game:GetService("DataStoreService") end)) and game:GetService("DataStoreService") or nil

local Player   = Players.LocalPlayer
local Mouse    = Player:GetMouse()

-- =========================================================================
--  ICON TABLE  (subset — full list loaded from Icons.lua in same repo)
--  Keys are used WITHOUT the "lucide-" prefix inside the library.
-- =========================================================================
local Icons = {
    ["swords"]            = "rbxassetid://136706030972957",
    ["shield"]            = "rbxassetid://95947024046823",
    ["settings"]          = "rbxassetid://118767869684987",
    ["user"]              = "rbxassetid://91038720573702",
    ["home"]              = "rbxassetid://72439829413534",
    ["zap"]               = "rbxassetid://75083553875438",
    ["star"]              = "rbxassetid://76393426717560",
    ["heart"]             = "rbxassetid://104024975985082",
    ["terminal"]          = "rbxassetid://85895680427867",
    ["cpu"]               = "rbxassetid://82261696017296",
    ["layers"]            = "rbxassetid://115677869862476",
    ["globe"]             = "rbxassetid://91578636792490",
    ["lock"]              = "rbxassetid://104029888571804",
    ["unlock"]            = "rbxassetid://88993398716753",
    ["eye"]               = "rbxassetid://103453088591782",
    ["eye-off"]           = "rbxassetid://75219555028082",
    ["crosshair"]         = "rbxassetid://81843052736832",
    ["target"]            = "rbxassetid://79613779060571",
    ["activity"]          = "rbxassetid://94212016861936",
    ["alert-triangle"]    = "rbxassetid://76780680785474",
    ["alert-circle"]      = "rbxassetid://94316067940497",
    ["check-circle"]      = "rbxassetid://118094706578090",
    ["info"]              = "rbxassetid://76867440028631",
    ["x-circle"]          = "rbxassetid://115590742668987",
    ["bell"]              = "rbxassetid://99765256875028",
    ["search"]            = "rbxassetid://70697824516673",
    ["list"]              = "rbxassetid://104143523459978",
    ["code"]              = "rbxassetid://76988695779820",
    ["image"]             = "rbxassetid://96249494753289",
    ["users"]             = "rbxassetid://83571484618143",
    ["save"]              = "rbxassetid://78451773038609",
    ["download"]          = "rbxassetid://98764963621439",
    ["upload"]            = "rbxassetid://93136954756149",
    ["trash"]             = "rbxassetid://103788609637012",
    ["edit"]              = "rbxassetid://113905620447193",
    ["plus"]              = "rbxassetid://73817248905432",
    ["minus"]             = "rbxassetid://72396019561034",
    ["x"]                 = "rbxassetid://122042099975048",
    ["chevron-down"]      = "rbxassetid://77272073754490",
    ["chevron-up"]        = "rbxassetid://119613028994729",
    ["chevron-left"]      = "rbxassetid://139421474285698",
    ["chevron-right"]     = "rbxassetid://117607657527049",
    ["sliders"]           = "rbxassetid://108745625680419",
    ["keyboard"]          = "rbxassetid://72009524046804",
    ["palette"]           = "rbxassetid://127673985186028",
    ["maximize-2"]        = "rbxassetid://135948396609248",
    ["minimize-2"]        = "rbxassetid://100793898424879",
    ["square"]            = "rbxassetid://75272915739209",
    ["wifi"]              = "rbxassetid://104697082175742",
    ["database"]          = "rbxassetid://99447165148834",
    ["box"]               = "rbxassetid://91697882590083",
    ["compass"]           = "rbxassetid://96432386267019",
    ["map"]               = "rbxassetid://105494875068376",
    ["clock"]             = "rbxassetid://126259032907535",
    ["calendar"]          = "rbxassetid://89655093459272",
    ["flag"]              = "rbxassetid://76079601571116",
    ["anchor"]            = "rbxassetid://92181172123618",
    ["lightning-bolt"]    = "rbxassetid://75083553875438",
    ["flame"]             = "rbxassetid://116476754213268",
    ["snowflake"]         = "rbxassetid://88726534960073",
    ["sword"]             = "rbxassetid://136706030972957",
    ["shield-check"]      = "rbxassetid://73817248905432",
    ["command"]           = "rbxassetid://90994490716490",
    ["radio"]             = "rbxassetid://99628923540956",
    ["power"]             = "rbxassetid://84600047069286",
    ["refresh-cw"]        = "rbxassetid://78956681942188",
    ["rotate-cw"]         = "rbxassetid://91478325124813",
}

-- Helper: resolve "lucide-X" or bare "X"
local function ResolveIcon(iconStr)
    if not iconStr then return nil end
    local key = iconStr:gsub("^lucide%-", "")
    return Icons[key]
end

-- =========================================================================
--  THEMES
-- =========================================================================
local Themes = {
    Holographic = {
        Background   = Color3.fromRGB(10, 15, 25),
        HeaderBg     = Color3.fromRGB(8, 12, 22),
        Accent       = Color3.fromRGB(0, 220, 255),
        AccentDim    = Color3.fromRGB(0, 140, 180),
        SecondaryBg  = Color3.fromRGB(15, 22, 38),
        ComponentBg  = Color3.fromRGB(20, 28, 48),
        Text         = Color3.fromRGB(230, 240, 255),
        DimText      = Color3.fromRGB(120, 140, 175),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 60, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(80, 180, 255),
        ToggleOn     = Color3.fromRGB(10, 50, 80),
        ToggleOff    = Color3.fromRGB(30, 38, 60),
        SliderFill   = Color3.fromRGB(0, 200, 240),
        TabActive    = Color3.fromRGB(0, 50, 80),
        TabHover     = Color3.fromRGB(0, 30, 50),
        SectionBg    = Color3.fromRGB(12, 18, 32),
        SeparatorClr = Color3.fromRGB(0, 150, 200),
        NotifBg      = Color3.fromRGB(10, 15, 25),
    },
    Crimson = {
        Background   = Color3.fromRGB(20, 10, 12),
        HeaderBg     = Color3.fromRGB(15, 8, 10),
        Accent       = Color3.fromRGB(255, 50, 80),
        AccentDim    = Color3.fromRGB(180, 30, 55),
        SecondaryBg  = Color3.fromRGB(30, 14, 18),
        ComponentBg  = Color3.fromRGB(38, 18, 22),
        Text         = Color3.fromRGB(255, 230, 235),
        DimText      = Color3.fromRGB(160, 110, 120),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 60, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(255, 80, 120),
        ToggleOn     = Color3.fromRGB(80, 10, 20),
        ToggleOff    = Color3.fromRGB(50, 22, 28),
        SliderFill   = Color3.fromRGB(255, 50, 80),
        TabActive    = Color3.fromRGB(70, 10, 18),
        TabHover     = Color3.fromRGB(50, 8, 14),
        SectionBg    = Color3.fromRGB(22, 10, 14),
        SeparatorClr = Color3.fromRGB(200, 30, 60),
        NotifBg      = Color3.fromRGB(20, 10, 12),
    },
    Void = {
        Background   = Color3.fromRGB(8, 6, 18),
        HeaderBg     = Color3.fromRGB(6, 4, 14),
        Accent       = Color3.fromRGB(160, 80, 255),
        AccentDim    = Color3.fromRGB(100, 50, 180),
        SecondaryBg  = Color3.fromRGB(14, 10, 28),
        ComponentBg  = Color3.fromRGB(20, 14, 38),
        Text         = Color3.fromRGB(235, 225, 255),
        DimText      = Color3.fromRGB(120, 100, 160),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 60, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(160, 80, 255),
        ToggleOn     = Color3.fromRGB(50, 20, 90),
        ToggleOff    = Color3.fromRGB(30, 20, 55),
        SliderFill   = Color3.fromRGB(160, 80, 255),
        TabActive    = Color3.fromRGB(40, 16, 80),
        TabHover     = Color3.fromRGB(28, 12, 55),
        SectionBg    = Color3.fromRGB(10, 7, 22),
        SeparatorClr = Color3.fromRGB(120, 50, 220),
        NotifBg      = Color3.fromRGB(8, 6, 18),
    },
}

-- =========================================================================
--  UTILITY
-- =========================================================================
local function CT(instance, props, time, style, dir)
    local t = TweenService:Create(
        instance,
        TweenInfo.new(
            time or 0.25,
            style or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function MakePadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 4)
    p.PaddingBottom = UDim.new(0, bottom or 4)
    p.PaddingLeft   = UDim.new(0, left   or 8)
    p.PaddingRight  = UDim.new(0, right  or 8)
    p.Parent = parent
    return p
end

local function MakeIcon(parent, iconKey, size, pos, color)
    local assetId = ResolveIcon(iconKey)
    if not assetId then return nil end
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, size or 16, 0, size or 16)
    img.Position = pos or UDim2.new(0, 0, 0.5, -(size or 16) / 2)
    img.BackgroundTransparency = 1
    img.Image = assetId
    img.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
    img.Parent = parent
    return img
end

-- Auto-resize UIListLayout container
local function AutoSize(listLayout, frame)
    local function update()
        frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset,
            0, listLayout.AbsoluteContentSize.Y + 12)
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
    update()
end

-- =========================================================================
--  DRAG SYSTEM
-- =========================================================================
local function MakeDraggable(frame, handle)
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            mousePos  = input.Position
            framePos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- =========================================================================
--  RESIZE SYSTEM
-- =========================================================================
local function MakeResizable(frame, minW, minH)
    minW = minW or 400
    minH = minH or 300
    local rHandle = Instance.new("Frame")
    rHandle.Size = UDim2.new(0, 14, 0, 14)
    rHandle.Position = UDim2.new(1, -14, 1, -14)
    rHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    rHandle.BackgroundTransparency = 0.85
    rHandle.BorderSizePixel = 0
    rHandle.ZIndex = 10
    rHandle.Parent = frame
    MakeCorner(rHandle, 3)

    local grip = Instance.new("TextLabel")
    grip.Size = UDim2.new(1, 0, 1, 0)
    grip.BackgroundTransparency = 1
    grip.Text = "⋱"
    grip.TextColor3 = Color3.fromRGB(200, 220, 255)
    grip.Font = Enum.Font.GothamBold
    grip.TextSize = 11
    grip.ZIndex = 11
    grip.Parent = rHandle

    local resizing, startPos, startSize = false, nil, nil
    rHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            resizing  = true
            startPos  = input.Position
            startSize = frame.AbsoluteSize
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            local nW = math.max(minW, startSize.X + delta.X)
            local nH = math.max(minH, startSize.Y + delta.Y)
            frame.Size = UDim2.new(0, nW, 0, nH)
        end
    end)
end

-- =========================================================================
--  CONFIG SYSTEM (DataStore / DataModel cache)
-- =========================================================================
local ConfigCache = {}

local function SaveConfig(windowName, data)
    ConfigCache[windowName] = data
    -- Attempt writefile for executors
    pcall(function()
        if writefile then
            writefile("SystemUI_" .. windowName .. ".json",
                game:GetService("HttpService"):JSONEncode(data))
        end
    end)
end

local function LoadConfig(windowName)
    -- Attempt readfile for executors
    local ok, raw = pcall(function()
        if readfile then
            return readfile("SystemUI_" .. windowName .. ".json")
        end
    end)
    if ok and raw then
        local ok2, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw)
        end)
        if ok2 and data then
            ConfigCache[windowName] = data
            return data
        end
    end
    return ConfigCache[windowName] or {}
end

-- =========================================================================
--  NOTIFICATION SYSTEM
-- =========================================================================
local NotifGui = nil
local NotifContainer = nil
local function EnsureNotifGui(theme)
    if NotifGui and NotifGui.Parent then return end
    NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "SystemUI_Notifs"
    NotifGui.ResetOnSpawn = false
    NotifGui.IgnoreGuiInset = true
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotifGui.Parent = CoreGui

    NotifContainer = Instance.new("Frame")
    NotifContainer.Name = "Container"
    NotifContainer.Size = UDim2.new(0, 280, 1, -20)
    NotifContainer.Position = UDim2.new(1, -295, 0, 10)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Parent = NotifGui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 8)
    layout.Parent = NotifContainer
end

local function SendNotification(config, theme)
    EnsureNotifGui(theme)
    local T = theme

    local typeColors = {
        success = T.Success,
        error   = T.Error,
        warning = T.Warning,
        info    = T.Info,
    }
    local typeIcons = {
        success = "check-circle",
        error   = "x-circle",
        warning = "alert-triangle",
        info    = "info",
    }

    local nType    = (config.Type or "info"):lower()
    local accentC  = typeColors[nType] or T.Accent
    local iconKey  = typeIcons[nType] or "bell"
    local duration = config.Duration or 3

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 30, 0, 70)
    Frame.Position = UDim2.new(0, 0, 0, 0)
    Frame.BackgroundColor3 = T.NotifBg
    Frame.BackgroundTransparency = 0.05
    Frame.ClipsDescendants = true
    Frame.Parent = NotifContainer
    MakeCorner(Frame, 8)
    MakeStroke(Frame, accentC, 1, 0.15)

    -- Accent side bar
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0, 3, 1, 0)
    Bar.BackgroundColor3 = accentC
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame
    MakeCorner(Bar, 2)

    -- Icon
    MakeIcon(Frame, iconKey, 18, UDim2.new(0, 14, 0.5, -9), accentC)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -45, 0, 22)
    Title.Position = UDim2.new(0, 38, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Notification"
    Title.TextColor3 = accentC
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    -- Desc
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -45, 0, 28)
    Desc.Position = UDim2.new(0, 38, 0, 30)
    Desc.BackgroundTransparency = 1
    Desc.Text = config.Desc or config.Description or ""
    Desc.TextColor3 = T.DimText
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 11
    Desc.TextWrapped = true
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Frame

    -- Progress bar
    local ProgBg = Instance.new("Frame")
    ProgBg.Size = UDim2.new(1, 0, 0, 2)
    ProgBg.Position = UDim2.new(0, 0, 1, -2)
    ProgBg.BackgroundColor3 = T.ComponentBg
    ProgBg.BorderSizePixel = 0
    ProgBg.Parent = Frame

    local Prog = Instance.new("Frame")
    Prog.Size = UDim2.new(1, 0, 1, 0)
    Prog.BackgroundColor3 = accentC
    Prog.BorderSizePixel = 0
    Prog.Parent = ProgBg

    -- Animate in
    CT(Frame, {Size = UDim2.new(1, 0, 0, 70)}, 0.4, Enum.EasingStyle.Back)

    -- Countdown progress
    CT(Prog, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)

    -- Animate out
    task.delay(duration, function()
        if not Frame or not Frame.Parent then return end
        CT(Frame, {Size = UDim2.new(1, 30, 0, 70), BackgroundTransparency = 1}, 0.35)
        task.wait(0.4)
        if Frame and Frame.Parent then Frame:Destroy() end
    end)
end

-- =========================================================================
--  MAIN LIBRARY
-- =========================================================================
local SystemUI = {}

function SystemUI:CreateWindow(config)
    config = config or {}

    local windowTitle = config.Title    or "SYSTEM INTERFACE"
    local subTitle    = config.SubTitle or "SystemUI v1.0"
    local useBlur     = config.Blur  ~= false
    local useSound    = config.Sounds ~= false
    local toggleKey   = config.ToggleKey or Enum.KeyCode.RightShift
    local winSize     = config.Size  or UDim2.new(0, 620, 0, 460)
    local themeName   = config.Theme or "Holographic"
    local T           = Themes[themeName] or Themes.Holographic

    local configName  = windowTitle:gsub("%s+", "_")
    local savedCfg    = LoadConfig(configName)
    local configData  = {}   -- live config values
    local connections = {}   -- for cleanup

    -- Destroy old instance
    if CoreGui:FindFirstChild("SystemUI_Main") then
        CoreGui["SystemUI_Main"]:Destroy()
    end

    -- Screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SystemUI_Main"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- Blur
    local BlurEffect = nil
    if useBlur then
        BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Size = 0
        BlurEffect.Parent = Lighting
        CT(BlurEffect, {Size = 12}, 0.5)
    end

    -- -------------------------------------------------------------------------
    --  MAIN FRAME
    -- -------------------------------------------------------------------------
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -winSize.X.Offset / 2, 0.5, -winSize.Y.Offset / 2)
    MainFrame.BackgroundColor3 = T.Background
    MainFrame.BackgroundTransparency = 0.12
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    MakeCorner(MainFrame, 10)
    MakeStroke(MainFrame, T.Accent, 1.2, 0.25)

    CT(MainFrame, {Size = winSize}, 0.55, Enum.EasingStyle.Exponential)

    -- -------------------------------------------------------------------------
    --  HEADER BAR
    -- -------------------------------------------------------------------------
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 54)
    Header.BackgroundColor3 = T.HeaderBg
    Header.BackgroundTransparency = 0.05
    Header.BorderSizePixel = 0
    Header.ZIndex = 3
    Header.Parent = MainFrame

    -- gradient line under header
    local HLine = Instance.new("Frame")
    HLine.Size = UDim2.new(1, 0, 0, 1)
    HLine.Position = UDim2.new(0, 0, 1, 0)
    HLine.BackgroundColor3 = T.Accent
    HLine.BackgroundTransparency = 0.4
    HLine.BorderSizePixel = 0
    HLine.Parent = Header

    -- Title labels
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -160, 0, 24)
    TitleLabel.Position = UDim2.new(0, 14, 0, 6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = T.Accent
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 4
    TitleLabel.Parent = Header

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -160, 0, 14)
    SubLabel.Position = UDim2.new(0, 14, 0, 28)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = subTitle
    SubLabel.TextColor3 = T.DimText
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.ZIndex = 4
    SubLabel.Parent = Header

    local AuthLabel = Instance.new("TextLabel")
    AuthLabel.Size = UDim2.new(1, -160, 0, 10)
    AuthLabel.Position = UDim2.new(0, 14, 0, 42)
    AuthLabel.BackgroundTransparency = 1
    AuthLabel.Text = "Created by CoiledTom"
    AuthLabel.TextColor3 = T.AccentDim
    AuthLabel.Font = Enum.Font.Gotham
    AuthLabel.TextSize = 10
    AuthLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthLabel.ZIndex = 4
    AuthLabel.Parent = Header

    -- -------------------------------------------------------------------------
    --  WINDOW BUTTONS  [ - ]  [ □ ]  [ X ]
    -- -------------------------------------------------------------------------
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(0, 90, 0, 22)
    BtnContainer.Position = UDim2.new(1, -100, 0.5, -11)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.ZIndex = 5
    BtnContainer.Parent = Header

    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.Padding = UDim.new(0, 6)
    BtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnLayout.Parent = BtnContainer

    local function MakeWinBtn(symbol, accentColor)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 24, 0, 22)
        btn.BackgroundColor3 = T.ComponentBg
        btn.BackgroundTransparency = 0.3
        btn.Text = symbol
        btn.TextColor3 = accentColor
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.ZIndex = 6
        btn.Parent = BtnContainer
        MakeCorner(btn, 5)
        MakeStroke(btn, accentColor, 1, 0.6)

        btn.MouseEnter:Connect(function()
            CT(btn, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            CT(btn, {BackgroundTransparency = 0.3, TextColor3 = accentColor}, 0.15)
        end)
        return btn
    end

    local BtnMin    = MakeWinBtn("−", T.Warning)
    local BtnRestore = MakeWinBtn("□", T.Info)
    local BtnClose  = MakeWinBtn("✕", T.Error)

    -- Body (content below header)
    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.Size = UDim2.new(1, 0, 1, -54)
    Body.Position = UDim2.new(0, 0, 0, 54)
    Body.BackgroundTransparency = 1
    Body.ClipsDescendants = true
    Body.Parent = MainFrame

    -- Tab sidebar
    local TabSidebar = Instance.new("ScrollingFrame")
    TabSidebar.Name = "TabSidebar"
    TabSidebar.Size = UDim2.new(0, 155, 1, -8)
    TabSidebar.Position = UDim2.new(0, 8, 0, 4)
    TabSidebar.BackgroundColor3 = T.SectionBg
    TabSidebar.BackgroundTransparency = 0.3
    TabSidebar.ScrollBarThickness = 0
    TabSidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabSidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabSidebar.ClipsDescendants = true
    TabSidebar.Parent = Body
    MakeCorner(TabSidebar, 8)
    MakeStroke(TabSidebar, T.Accent, 1, 0.7)
    MakePadding(TabSidebar, 6, 6, 6, 6)

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabSidebar

    -- Page container
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -172, 1, -8)
    PageContainer.Position = UDim2.new(0, 168, 0, 4)
    PageContainer.BackgroundTransparency = 1
    PageContainer.ClipsDescendants = true
    PageContainer.Parent = Body

    -- -------------------------------------------------------------------------
    --  DRAGGABLE  +  RESIZABLE
    -- -------------------------------------------------------------------------
    MakeDraggable(MainFrame, Header)
    MakeResizable(MainFrame, 420, 320)

    -- -------------------------------------------------------------------------
    --  MINIMIZE / RESTORE / CLOSE logic
    -- -------------------------------------------------------------------------
    local minimized = false
    local originalSize = winSize
    local visible = true

    local function SetBodyVisible(v)
        Body.Visible = v
    end

    BtnMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            originalSize = MainFrame.Size
            CT(MainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, 54)}, 0.3, Enum.EasingStyle.Quart)
            task.wait(0.15)
            SetBodyVisible(false)
        else
            SetBodyVisible(true)
            CT(MainFrame, {Size = originalSize}, 0.3, Enum.EasingStyle.Back)
        end
    end)

    BtnRestore.MouseButton1Click:Connect(function()
        if minimized then
            minimized = false
            SetBodyVisible(true)
            CT(MainFrame, {Size = originalSize}, 0.3, Enum.EasingStyle.Back)
        else
            -- toggle center
            MainFrame.Position = UDim2.new(0.5, -originalSize.X.Offset / 2,
                0.5, -originalSize.Y.Offset / 2)
        end
    end)

    BtnClose.MouseButton1Click:Connect(function()
        CT(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Quart)
        if BlurEffect then
            CT(BlurEffect, {Size = 0}, 0.35)
        end
        task.wait(0.4)
        ScreenGui:Destroy()
        if BlurEffect and BlurEffect.Parent then BlurEffect:Destroy() end
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    end)

    -- ToggleKey
    local toggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            visible = not visible
            if visible then
                MainFrame.Visible = true
                CT(MainFrame, {Size = minimized and UDim2.new(0, originalSize.X.Offset, 0, 54) or originalSize}, 0.35, Enum.EasingStyle.Back)
            else
                CT(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
                task.wait(0.35)
                MainFrame.Visible = false
            end
        end
    end)
    table.insert(connections, toggleConn)

    -- =========================================================================
    --  WINDOW OBJECT
    -- =========================================================================
    local WindowObj = {
        _theme      = T,
        _gui        = ScreenGui,
        _blur       = BlurEffect,
        _tabs       = {},
        _activeTab  = nil,
        _configName = configName,
        _configData = configData,
        _savedCfg   = savedCfg,
    }

    -- Auto-save helper (called on any component change)
    local autoSaveTimer = nil
    local function TriggerAutoSave()
        if autoSaveTimer then task.cancel(autoSaveTimer) end
        autoSaveTimer = task.delay(1.5, function()
            SaveConfig(configName, configData)
        end)
    end

    -- =========================================================================
    --  Notify
    -- =========================================================================
    function WindowObj:Notify(cfg)
        SendNotification(cfg, T)
    end

    -- =========================================================================
    --  SaveConfig / LoadConfig API
    -- =========================================================================
    function WindowObj:SaveConfig()
        SaveConfig(configName, configData)
    end

    function WindowObj:LoadConfig()
        return LoadConfig(configName)
    end

    -- =========================================================================
    --  AddTab
    -- =========================================================================
    function WindowObj:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabTitle = tabConfig.Title or "Tab"
        local tabIcon  = tabConfig.Icon

        -- Tab button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = T.ComponentBg
        TabBtn.BackgroundTransparency = 0.6
        TabBtn.Text = ""
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.Parent = TabSidebar
        MakeCorner(TabBtn, 6)

        local TabBtnLayout = Instance.new("UIListLayout")
        TabBtnLayout.FillDirection = Enum.FillDirection.Horizontal
        TabBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        TabBtnLayout.Padding = UDim.new(0, 6)
        TabBtnLayout.Parent = TabBtn
        MakePadding(TabBtn, 0, 0, 8, 8)

        -- Icon in tab button
        if tabIcon then
            local ic = MakeIcon(TabBtn, tabIcon, 14, nil, T.DimText)
            if ic then ic.LayoutOrder = 0 end
        end

        local TabLabel = Instance.new("TextLabel")
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabTitle
        TabLabel.TextColor3 = T.DimText
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextSize = 13
        TabLabel.Size = UDim2.new(1, -30, 1, 0)
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.LayoutOrder = 1
        TabLabel.Parent = TabBtn

        -- Page scroll
        local PageScroll = Instance.new("ScrollingFrame")
        PageScroll.Size = UDim2.new(1, 0, 1, 0)
        PageScroll.BackgroundTransparency = 1
        PageScroll.ScrollBarThickness = 2
        PageScroll.ScrollBarImageColor3 = T.Accent
        PageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        PageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        PageScroll.Visible = false
        PageScroll.Parent = PageContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = PageScroll
        MakePadding(PageScroll, 4, 8, 4, 4)

        local tabEntry = {Button = TabBtn, Page = PageScroll, Label = TabLabel}
        table.insert(WindowObj._tabs, tabEntry)

        local function ActivateTab()
            for _, te in ipairs(WindowObj._tabs) do
                CT(te.Button, {BackgroundTransparency = 0.6, BackgroundColor3 = T.ComponentBg}, 0.2)
                CT(te.Label, {TextColor3 = T.DimText}, 0.2)
                te.Page.Visible = false
            end
            CT(TabBtn, {BackgroundTransparency = 0.1, BackgroundColor3 = T.TabActive}, 0.2)
            CT(TabLabel, {TextColor3 = T.Accent}, 0.2)
            PageScroll.Visible = true
            PageScroll.CanvasPosition = Vector2.new(0, 0)
            WindowObj._activeTab = tabEntry
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)
        TabBtn.MouseEnter:Connect(function()
            if WindowObj._activeTab ~= tabEntry then
                CT(TabBtn, {BackgroundTransparency = 0.3, BackgroundColor3 = T.TabHover}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if WindowObj._activeTab ~= tabEntry then
                CT(TabBtn, {BackgroundTransparency = 0.6, BackgroundColor3 = T.ComponentBg}, 0.15)
            end
        end)

        -- Activate first tab automatically
        if #WindowObj._tabs == 1 then
            ActivateTab()
        end

        -- =====================================================================
        --  TAB OBJECT
        -- =====================================================================
        local TabObj = {}

        -- =====================================================================
        --  AddSection
        -- =====================================================================
        function TabObj:AddSection(secConfig)
            secConfig = secConfig or {}
            local secTitle = secConfig.Title or ""
            local secIcon  = secConfig.Icon

            local SecFrame = Instance.new("Frame")
            SecFrame.Size = UDim2.new(1, -8, 0, 0)
            SecFrame.BackgroundColor3 = T.SectionBg
            SecFrame.BackgroundTransparency = 0.2
            SecFrame.AutomaticSize = Enum.AutomaticSize.Y
            SecFrame.ClipsDescendants = false
            SecFrame.Parent = PageScroll
            MakeCorner(SecFrame, 8)
            MakeStroke(SecFrame, T.Accent, 1, 0.65)

            local SecContent = Instance.new("Frame")
            SecContent.Size = UDim2.new(1, 0, 0, 0)
            SecContent.BackgroundTransparency = 1
            SecContent.AutomaticSize = Enum.AutomaticSize.Y
            SecContent.Parent = SecFrame

            local SecLayout = Instance.new("UIListLayout")
            SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SecLayout.Padding = UDim.new(0, 4)
            SecLayout.Parent = SecContent
            MakePadding(SecContent, 6, 8, 8, 8)

            -- Section header
            if secTitle ~= "" then
                local SecHeader = Instance.new("Frame")
                SecHeader.Size = UDim2.new(1, 0, 0, 28)
                SecHeader.BackgroundTransparency = 1
                SecHeader.LayoutOrder = 0
                SecHeader.Parent = SecContent

                local SecHLayout = Instance.new("UIListLayout")
                SecHLayout.FillDirection = Enum.FillDirection.Horizontal
                SecHLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                SecHLayout.Padding = UDim.new(0, 6)
                SecHLayout.Parent = SecHeader

                if secIcon then
                    MakeIcon(SecHeader, secIcon, 14, nil, T.Accent)
                end

                local SecTitle = Instance.new("TextLabel")
                SecTitle.BackgroundTransparency = 1
                SecTitle.Text = secTitle:upper()
                SecTitle.TextColor3 = T.Accent
                SecTitle.Font = Enum.Font.GothamBold
                SecTitle.TextSize = 11
                SecTitle.Size = UDim2.new(1, -30, 1, 0)
                SecTitle.TextXAlignment = Enum.TextXAlignment.Left
                SecTitle.Parent = SecHeader

                -- line
                local SLine = Instance.new("Frame")
                SLine.Size = UDim2.new(1, 0, 0, 1)
                SLine.BackgroundColor3 = T.Accent
                SLine.BackgroundTransparency = 0.7
                SLine.BorderSizePixel = 0
                SLine.LayoutOrder = 1
                SLine.Parent = SecContent
            end

            -- ==================================================================
            --  SECTION OBJECT
            -- ==================================================================
            local SecObj = {}
            local compOrder = 10

            local function NextOrder()
                compOrder = compOrder + 1
                return compOrder
            end

            -- Helper: create a base component row
            local function BaseRow(height)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, height or 36)
                row.BackgroundColor3 = T.ComponentBg
                row.BackgroundTransparency = 0.35
                row.BorderSizePixel = 0
                row.LayoutOrder = NextOrder()
                row.Parent = SecContent
                MakeCorner(row, 5)
                return row
            end

            -- ------------------------------------------------------------------
            --  AddButton
            -- ------------------------------------------------------------------
            function SecObj:AddButton(cfg)
                cfg = cfg or {}
                local row = BaseRow(36)
                local lbl = Instance.new("TextButton")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = ""
                lbl.Parent = row

                local rowLayout = Instance.new("UIListLayout")
                rowLayout.FillDirection = Enum.FillDirection.Horizontal
                rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                rowLayout.Padding = UDim.new(0, 8)
                rowLayout.Parent = row
                MakePadding(row, 0, 0, 10, 10)

                if cfg.Icon then MakeIcon(row, cfg.Icon, 14, nil, T.Accent) end

                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Button"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Size = UDim2.new(1, -30, 1, 0)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row

                local stroke = MakeStroke(row, T.Accent, 1, 0.85)

                lbl.MouseEnter:Connect(function()
                    CT(row, {BackgroundTransparency = 0.1, BackgroundColor3 = T.TabHover}, 0.15)
                    CT(stroke, {Transparency = 0.35}, 0.15)
                end)
                lbl.MouseLeave:Connect(function()
                    CT(row, {BackgroundTransparency = 0.35, BackgroundColor3 = T.ComponentBg}, 0.15)
                    CT(stroke, {Transparency = 0.85}, 0.15)
                end)
                lbl.MouseButton1Down:Connect(function()
                    CT(row, {BackgroundColor3 = T.AccentDim}, 0.1)
                end)
                lbl.MouseButton1Up:Connect(function()
                    CT(row, {BackgroundColor3 = T.TabHover}, 0.1)
                    if cfg.Callback then task.spawn(cfg.Callback) end
                end)
            end

            -- ------------------------------------------------------------------
            --  AddToggle
            -- ------------------------------------------------------------------
            function SecObj:AddToggle(cfg)
                cfg = cfg or {}
                local key = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local state = (savedCfg[key] ~= nil) and savedCfg[key] or (cfg.Default or false)
                configData[key] = state

                local row = BaseRow(36)
                local rowLayout = Instance.new("UIListLayout")
                rowLayout.FillDirection = Enum.FillDirection.Horizontal
                rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                rowLayout.Parent = row
                MakePadding(row, 0, 0, 10, 10)

                if cfg.Icon then MakeIcon(row, cfg.Icon, 14, nil, T.Accent) end

                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Toggle"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Size = UDim2.new(1, -64, 1, 0)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row

                -- Switch track
                local track = Instance.new("Frame")
                track.Size = UDim2.new(0, 40, 0, 20)
                track.BackgroundColor3 = state and T.ToggleOn or T.ToggleOff
                track.BorderSizePixel = 0
                Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
                track.Parent = row
                MakeStroke(track, state and T.Accent or T.DimText, 1, 0.4)

                -- Knob
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 16, 0, 16)
                knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                knob.BackgroundColor3 = state and T.Accent or T.DimText
                Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
                knob.Parent = track

                local clickZone = Instance.new("TextButton")
                clickZone.Size = UDim2.new(1, 0, 1, 0)
                clickZone.BackgroundTransparency = 1
                clickZone.Text = ""
                clickZone.Parent = row

                -- Touch knob too
                local knobBtn = Instance.new("TextButton")
                knobBtn.Size = UDim2.new(1, 0, 1, 0)
                knobBtn.BackgroundTransparency = 1
                knobBtn.Text = ""
                knobBtn.Parent = track

                local function Toggle()
                    state = not state
                    configData[key] = state
                    if state then
                        CT(knob, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = T.Accent}, 0.25)
                        CT(track, {BackgroundColor3 = T.ToggleOn}, 0.25)
                    else
                        CT(knob, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = T.DimText}, 0.25)
                        CT(track, {BackgroundColor3 = T.ToggleOff}, 0.25)
                    end
                    TriggerAutoSave()
                    if cfg.Callback then task.spawn(cfg.Callback, state) end
                end

                clickZone.MouseButton1Click:Connect(Toggle)
                knobBtn.MouseButton1Click:Connect(Toggle)

                -- Fire initial callback
                if cfg.Callback and state then
                    task.spawn(cfg.Callback, state)
                end

                -- Return toggle controller
                local ctrl = {}
                function ctrl:Set(v)
                    state = v
                    Toggle()
                    state = not v -- Toggle() flips, so pre-flip
                    Toggle()
                end
                function ctrl:Get() return state end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddSlider
            -- ------------------------------------------------------------------
            function SecObj:AddSlider(cfg)
                cfg = cfg or {}
                local key     = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local minVal  = cfg.Min or 0
                local maxVal  = cfg.Max or 100
                local default = (savedCfg[key] ~= nil) and savedCfg[key] or (cfg.Default or minVal)
                local round   = cfg.Round or 0
                local value   = default
                configData[key] = value

                local row = BaseRow(52)
                MakePadding(row, 6, 6, 10, 10)

                local topRow = Instance.new("Frame")
                topRow.Size = UDim2.new(1, 0, 0, 18)
                topRow.BackgroundTransparency = 1
                topRow.Parent = row

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Slider"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = topRow

                local valLbl = Instance.new("TextLabel")
                valLbl.Size = UDim2.new(0.3, 0, 1, 0)
                valLbl.Position = UDim2.new(0.7, 0, 0, 0)
                valLbl.BackgroundTransparency = 1
                valLbl.Text = tostring(value)
                valLbl.TextColor3 = T.Accent
                valLbl.Font = Enum.Font.GothamBold
                valLbl.TextSize = 13
                valLbl.TextXAlignment = Enum.TextXAlignment.Right
                valLbl.Parent = topRow

                -- Track
                local trackBg = Instance.new("Frame")
                trackBg.Size = UDim2.new(1, 0, 0, 8)
                trackBg.Position = UDim2.new(0, 0, 1, -12)
                trackBg.BackgroundColor3 = T.ToggleOff
                trackBg.BorderSizePixel = 0
                MakeCorner(trackBg, 4)
                trackBg.Parent = row

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
                fill.BackgroundColor3 = T.SliderFill
                fill.BorderSizePixel = 0
                MakeCorner(fill, 4)
                fill.Parent = trackBg

                local thumb = Instance.new("Frame")
                thumb.Size = UDim2.new(0, 14, 0, 14)
                thumb.Position = UDim2.new((value - minVal) / (maxVal - minVal), -7, 0.5, -7)
                thumb.BackgroundColor3 = T.Accent
                thumb.BorderSizePixel = 0
                MakeCorner(thumb, 7)
                MakeStroke(thumb, T.Background, 2, 0)
                thumb.ZIndex = 3
                thumb.Parent = trackBg

                local dragging = false

                local function UpdateSlider(absPos)
                    local rel = math.clamp((absPos - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
                    local raw = minVal + rel * (maxVal - minVal)
                    if round > 0 then
                        raw = math.round(raw / round) * round
                    else
                        raw = math.round(raw)
                    end
                    raw = math.clamp(raw, minVal, maxVal)
                    value = raw
                    configData[key] = value
                    local pct = (value - minVal) / (maxVal - minVal)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    thumb.Position = UDim2.new(pct, -7, 0.5, -7)
                    valLbl.Text = tostring(value)
                    TriggerAutoSave()
                    if cfg.Callback then task.spawn(cfg.Callback, value) end
                end

                local sliderBtn = Instance.new("TextButton")
                sliderBtn.Size = UDim2.new(1, 0, 0, 20)
                sliderBtn.Position = UDim2.new(0, 0, 1, -18)
                sliderBtn.BackgroundTransparency = 1
                sliderBtn.Text = ""
                sliderBtn.ZIndex = 5
                sliderBtn.Parent = row

                sliderBtn.MouseButton1Down:Connect(function(x)
                    dragging = true
                    UpdateSlider(x)
                end)

                local moveConn = UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input.Position.X)
                    end
                end)
                local upConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                table.insert(connections, moveConn)
                table.insert(connections, upConn)

                -- Fire initial
                if cfg.Callback then task.spawn(cfg.Callback, value) end

                local ctrl = {}
                function ctrl:Set(v)
                    value = math.clamp(v, minVal, maxVal)
                    local pct = (value - minVal) / (maxVal - minVal)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    thumb.Position = UDim2.new(pct, -7, 0.5, -7)
                    valLbl.Text = tostring(value)
                    if cfg.Callback then task.spawn(cfg.Callback, value) end
                end
                function ctrl:Get() return value end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddTextbox  /  AddInput
            -- ------------------------------------------------------------------
            local function _AddTextbox(cfg)
                cfg = cfg or {}
                local row = BaseRow(36)
                MakePadding(row, 0, 0, 10, 10)

                local tbLayout = Instance.new("UIListLayout")
                tbLayout.FillDirection = Enum.FillDirection.Horizontal
                tbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                tbLayout.Padding = UDim.new(0, 8)
                tbLayout.Parent = row

                if cfg.Icon then MakeIcon(row, cfg.Icon, 14, nil, T.Accent) end

                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Input"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Size = UDim2.new(0.4, 0, 1, 0)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row

                local inputBox = Instance.new("TextBox")
                inputBox.Size = UDim2.new(0.55, 0, 0.75, 0)
                inputBox.BackgroundColor3 = T.SectionBg
                inputBox.BackgroundTransparency = 0.2
                inputBox.Text = cfg.Default or ""
                inputBox.PlaceholderText = cfg.Placeholder or "..."
                inputBox.PlaceholderColor3 = T.DimText
                inputBox.TextColor3 = T.Text
                inputBox.Font = Enum.Font.GothamMedium
                inputBox.TextSize = 12
                inputBox.ClearTextOnFocus = cfg.ClearOnFocus or false
                MakeCorner(inputBox, 4)
                MakeStroke(inputBox, T.Accent, 1, 0.6)
                MakePadding(inputBox, 2, 2, 6, 6)
                inputBox.Parent = row

                inputBox.Focused:Connect(function()
                    CT(inputBox, {BackgroundTransparency = 0.05}, 0.15)
                    MakeStroke(inputBox, T.Accent, 1, 0.15)
                end)
                inputBox.FocusLost:Connect(function(enter)
                    CT(inputBox, {BackgroundTransparency = 0.2}, 0.15)
                    if cfg.Callback then task.spawn(cfg.Callback, inputBox.Text, enter) end
                end)

                local ctrl = {}
                function ctrl:Get() return inputBox.Text end
                function ctrl:Set(v) inputBox.Text = v end
                return ctrl
            end

            function SecObj:AddTextbox(cfg) return _AddTextbox(cfg) end
            function SecObj:AddInput(cfg)   return _AddTextbox(cfg) end

            -- ------------------------------------------------------------------
            --  AddDropdown
            -- ------------------------------------------------------------------
            function SecObj:AddDropdown(cfg)
                cfg = cfg or {}
                local key      = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local options  = cfg.Options or {}
                local selected = (savedCfg[key] ~= nil) and savedCfg[key] or (cfg.Default or options[1] or "")
                configData[key] = selected

                local row = BaseRow(36)
                MakePadding(row, 0, 0, 10, 10)

                local ddLayout = Instance.new("UIListLayout")
                ddLayout.FillDirection = Enum.FillDirection.Horizontal
                ddLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                ddLayout.Padding = UDim.new(0, 8)
                ddLayout.Parent = row

                if cfg.Icon then MakeIcon(row, cfg.Icon, 14, nil, T.Accent) end

                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Dropdown"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Size = UDim2.new(0.4, 0, 1, 0)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row

                local ddBtn = Instance.new("TextButton")
                ddBtn.Size = UDim2.new(0.55, 0, 0.75, 0)
                ddBtn.BackgroundColor3 = T.SectionBg
                ddBtn.BackgroundTransparency = 0.2
                ddBtn.Text = selected .. "  ▾"
                ddBtn.TextColor3 = T.Text
                ddBtn.Font = Enum.Font.GothamMedium
                ddBtn.TextSize = 12
                MakeCorner(ddBtn, 4)
                MakeStroke(ddBtn, T.Accent, 1, 0.6)
                ddBtn.Parent = row

                local open = false
                local dropFrame = nil

                ddBtn.MouseButton1Click:Connect(function()
                    if open then
                        open = false
                        if dropFrame then dropFrame:Destroy() dropFrame = nil end
                        return
                    end
                    open = true

                    dropFrame = Instance.new("Frame")
                    dropFrame.Size = UDim2.new(0, ddBtn.AbsoluteSize.X, 0, math.min(#options, 5) * 28 + 8)
                    dropFrame.Position = UDim2.new(0,
                        ddBtn.AbsolutePosition.X - row.AbsolutePosition.X,
                        1, 4)
                    dropFrame.BackgroundColor3 = T.SecondaryBg
                    dropFrame.BackgroundTransparency = 0.05
                    dropFrame.ZIndex = 50
                    dropFrame.Parent = row
                    MakeCorner(dropFrame, 6)
                    MakeStroke(dropFrame, T.Accent, 1, 0.3)

                    local dropLayout = Instance.new("UIListLayout")
                    dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    dropLayout.Padding = UDim.new(0, 2)
                    dropLayout.Parent = dropFrame
                    MakePadding(dropFrame, 4, 4, 4, 4)

                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, 0, 0, 24)
                        optBtn.BackgroundColor3 = T.ComponentBg
                        optBtn.BackgroundTransparency = opt == selected and 0.2 or 0.7
                        optBtn.Text = "  " .. opt
                        optBtn.TextColor3 = opt == selected and T.Accent or T.Text
                        optBtn.Font = Enum.Font.GothamMedium
                        optBtn.TextSize = 12
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.ZIndex = 51
                        MakeCorner(optBtn, 4)
                        optBtn.Parent = dropFrame

                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            configData[key] = selected
                            ddBtn.Text = selected .. "  ▾"
                            TriggerAutoSave()
                            open = false
                            if dropFrame then dropFrame:Destroy() dropFrame = nil end
                            if cfg.Callback then task.spawn(cfg.Callback, selected) end
                        end)
                        optBtn.MouseEnter:Connect(function()
                            CT(optBtn, {BackgroundTransparency = 0.2}, 0.1)
                        end)
                        optBtn.MouseLeave:Connect(function()
                            CT(optBtn, {BackgroundTransparency = opt == selected and 0.2 or 0.7}, 0.1)
                        end)
                    end
                end)

                local ctrl = {}
                function ctrl:Get() return selected end
                function ctrl:Set(v)
                    selected = v
                    ddBtn.Text = selected .. "  ▾"
                    if cfg.Callback then task.spawn(cfg.Callback, selected) end
                end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddMultiDropdown
            -- ------------------------------------------------------------------
            function SecObj:AddMultiDropdown(cfg)
                cfg = cfg or {}
                local key      = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local options  = cfg.Options or {}
                local defaults = cfg.Default or {}
                local selected = {}
                for _, v in ipairs(defaults) do selected[v] = true end
                configData[key] = selected

                local row = BaseRow(36)
                MakePadding(row, 0, 0, 10, 10)

                local mdLayout = Instance.new("UIListLayout")
                mdLayout.FillDirection = Enum.FillDirection.Horizontal
                mdLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                mdLayout.Padding = UDim.new(0, 8)
                mdLayout.Parent = row

                if cfg.Icon then MakeIcon(row, cfg.Icon, 14, nil, T.Accent) end

                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "MultiSelect"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Size = UDim2.new(0.4, 0, 1, 0)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row

                local function SelText()
                    local t = {}
                    for k, v in pairs(selected) do if v then table.insert(t, k) end end
                    return #t > 0 and table.concat(t, ", ") or "None"
                end

                local ddBtn = Instance.new("TextButton")
                ddBtn.Size = UDim2.new(0.55, 0, 0.75, 0)
                ddBtn.BackgroundColor3 = T.SectionBg
                ddBtn.BackgroundTransparency = 0.2
                ddBtn.Text = SelText() .. "  ▾"
                ddBtn.TextColor3 = T.Text
                ddBtn.Font = Enum.Font.Gotham
                ddBtn.TextSize = 11
                ddBtn.TextTruncate = Enum.TextTruncate.AtEnd
                MakeCorner(ddBtn, 4)
                MakeStroke(ddBtn, T.Accent, 1, 0.6)
                ddBtn.Parent = row

                local open = false
                local dropFrame = nil

                ddBtn.MouseButton1Click:Connect(function()
                    if open then
                        open = false
                        if dropFrame then dropFrame:Destroy() dropFrame = nil end
                        return
                    end
                    open = true

                    dropFrame = Instance.new("Frame")
                    dropFrame.Size = UDim2.new(0, ddBtn.AbsoluteSize.X,
                        0, math.min(#options, 5) * 28 + 8)
                    dropFrame.Position = UDim2.new(0,
                        ddBtn.AbsolutePosition.X - row.AbsolutePosition.X, 1, 4)
                    dropFrame.BackgroundColor3 = T.SecondaryBg
                    dropFrame.BackgroundTransparency = 0.05
                    dropFrame.ZIndex = 50
                    dropFrame.Parent = row
                    MakeCorner(dropFrame, 6)
                    MakeStroke(dropFrame, T.Accent, 1, 0.3)

                    local dropLayout = Instance.new("UIListLayout")
                    dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    dropLayout.Padding = UDim.new(0, 2)
                    dropLayout.Parent = dropFrame
                    MakePadding(dropFrame, 4, 4, 4, 4)

                    local optBtns = {}
                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, 0, 0, 24)
                        optBtn.BackgroundColor3 = T.ComponentBg
                        optBtn.BackgroundTransparency = selected[opt] and 0.15 or 0.7
                        optBtn.Text = (selected[opt] and "  ✓ " or "     ") .. opt
                        optBtn.TextColor3 = selected[opt] and T.Accent or T.Text
                        optBtn.Font = Enum.Font.GothamMedium
                        optBtn.TextSize = 12
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.ZIndex = 51
                        MakeCorner(optBtn, 4)
                        optBtn.Parent = dropFrame
                        optBtns[opt] = optBtn

                        optBtn.MouseButton1Click:Connect(function()
                            selected[opt] = not selected[opt]
                            optBtn.Text = (selected[opt] and "  ✓ " or "     ") .. opt
                            optBtn.TextColor3 = selected[opt] and T.Accent or T.Text
                            CT(optBtn, {BackgroundTransparency = selected[opt] and 0.15 or 0.7}, 0.15)
                            configData[key] = selected
                            ddBtn.Text = SelText() .. "  ▾"
                            TriggerAutoSave()
                            if cfg.Callback then task.spawn(cfg.Callback, selected) end
                        end)
                    end
                end)

                local ctrl = {}
                function ctrl:Get()
                    local t = {}
                    for k, v in pairs(selected) do if v then table.insert(t, k) end end
                    return t
                end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddKeybind
            -- ------------------------------------------------------------------
            function SecObj:AddKeybind(cfg)
                cfg = cfg or {}
                local key      = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local saved    = savedCfg[key]
                local current  = saved and Enum.KeyCode[saved] or (cfg.Default or Enum.KeyCode.Unknown)
                configData[key] = current.Name

                local row = BaseRow(36)
                MakePadding(row, 0, 0, 10, 10)

                local kbLayout = Instance.new("UIListLayout")
                kbLayout.FillDirection = Enum.FillDirection.Horizontal
                kbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                kbLayout.Padding = UDim.new(0, 8)
                kbLayout.Parent = row

                if cfg.Icon then MakeIcon(row, cfg.Icon, 14, nil, T.Accent) end

                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Keybind"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Size = UDim2.new(0.55, 0, 1, 0)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row

                local listening = false
                local kbBtn = Instance.new("TextButton")
                kbBtn.Size = UDim2.new(0.4, 0, 0.75, 0)
                kbBtn.BackgroundColor3 = T.SectionBg
                kbBtn.BackgroundTransparency = 0.2
                kbBtn.Text = current == Enum.KeyCode.Unknown and "None" or current.Name
                kbBtn.TextColor3 = T.Accent
                kbBtn.Font = Enum.Font.GothamBold
                kbBtn.TextSize = 11
                MakeCorner(kbBtn, 4)
                MakeStroke(kbBtn, T.Accent, 1, 0.5)
                kbBtn.Parent = row

                kbBtn.MouseButton1Click:Connect(function()
                    listening = true
                    kbBtn.Text = "..."
                    kbBtn.TextColor3 = T.Warning
                end)

                local kbConn = UserInputService.InputBegan:Connect(function(input, gpe)
                    if not listening then return end
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                    listening = false
                    current = input.KeyCode
                    configData[key] = current.Name
                    kbBtn.Text = current.Name
                    kbBtn.TextColor3 = T.Accent
                    TriggerAutoSave()
                    if cfg.Callback then task.spawn(cfg.Callback, current) end
                end)
                table.insert(connections, kbConn)

                -- Key listener for callback
                if cfg.Callback then
                    local pressConn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if gpe then return end
                        if input.KeyCode == current then
                            task.spawn(cfg.Callback, current)
                        end
                    end)
                    table.insert(connections, pressConn)
                end

                local ctrl = {}
                function ctrl:Get() return current end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddColorPicker
            -- ------------------------------------------------------------------
            function SecObj:AddColorPicker(cfg)
                cfg = cfg or {}
                local key      = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local default  = cfg.Default or Color3.fromRGB(0, 220, 255)
                local current  = default

                local row = BaseRow(36)
                MakePadding(row, 0, 0, 10, 10)

                local cpLayout = Instance.new("UIListLayout")
                cpLayout.FillDirection = Enum.FillDirection.Horizontal
                cpLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                cpLayout.Padding = UDim.new(0, 8)
                cpLayout.Parent = row

                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Color"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Size = UDim2.new(0.6, 0, 1, 0)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row

                local preview = Instance.new("TextButton")
                preview.Size = UDim2.new(0, 32, 0, 22)
                preview.BackgroundColor3 = current
                preview.Text = ""
                MakeCorner(preview, 4)
                MakeStroke(preview, T.Accent, 1, 0.4)
                preview.Parent = row

                -- Simple HSV picker popup
                local open = false
                local pickerFrame = nil

                preview.MouseButton1Click:Connect(function()
                    if open then
                        open = false
                        if pickerFrame then pickerFrame:Destroy() pickerFrame = nil end
                        return
                    end
                    open = true

                    pickerFrame = Instance.new("Frame")
                    pickerFrame.Size = UDim2.new(0, 180, 0, 180)
                    pickerFrame.Position = UDim2.new(1, -185, 1, 4)
                    pickerFrame.BackgroundColor3 = T.SecondaryBg
                    pickerFrame.BackgroundTransparency = 0.05
                    pickerFrame.ZIndex = 60
                    pickerFrame.Parent = row
                    MakeCorner(pickerFrame, 8)
                    MakeStroke(pickerFrame, T.Accent, 1, 0.3)
                    MakePadding(pickerFrame, 8, 8, 8, 8)

                    local h, s, v = Color3.toHSV(current)

                    -- Hue slider
                    local hueLabel = Instance.new("TextLabel")
                    hueLabel.Size = UDim2.new(1, 0, 0, 16)
                    hueLabel.BackgroundTransparency = 1
                    hueLabel.Text = "H"
                    hueLabel.TextColor3 = T.DimText
                    hueLabel.Font = Enum.Font.GothamBold
                    hueLabel.TextSize = 11
                    hueLabel.TextXAlignment = Enum.TextXAlignment.Left
                    hueLabel.ZIndex = 61
                    hueLabel.Parent = pickerFrame

                    local function MakeHSVSlider(label, initVal, yPos, gradColors, onChange)
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(0, 16, 0, 14)
                        lbl.Position = UDim2.new(0, 0, 0, yPos)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = label
                        lbl.TextColor3 = T.DimText
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 10
                        lbl.ZIndex = 61
                        lbl.Parent = pickerFrame

                        local track = Instance.new("Frame")
                        track.Size = UDim2.new(1, -20, 0, 14)
                        track.Position = UDim2.new(0, 18, 0, yPos)
                        track.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                        track.BorderSizePixel = 0
                        track.ZIndex = 61
                        MakeCorner(track, 3)
                        track.Parent = pickerFrame

                        local grad = Instance.new("UIGradient")
                        grad.Color = ColorSequence.new(gradColors)
                        grad.Parent = track

                        local knb = Instance.new("Frame")
                        knb.Size = UDim2.new(0, 10, 0, 18)
                        knb.Position = UDim2.new(initVal, -5, 0.5, -9)
                        knb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        knb.BorderSizePixel = 0
                        knb.ZIndex = 62
                        MakeCorner(knb, 3)
                        knb.Parent = track

                        local draggingKnob = false
                        local knbBtn = Instance.new("TextButton")
                        knbBtn.Size = UDim2.new(1, 0, 1, 0)
                        knbBtn.BackgroundTransparency = 1
                        knbBtn.Text = ""
                        knbBtn.ZIndex = 63
                        knbBtn.Parent = track

                        knbBtn.MouseButton1Down:Connect(function()
                            draggingKnob = true
                        end)

                        local mconn = UserInputService.InputChanged:Connect(function(input)
                            if draggingKnob and (input.UserInputType == Enum.UserInputType.MouseMovement) then
                                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                                knb.Position = UDim2.new(rel, -5, 0.5, -9)
                                onChange(rel)
                            end
                        end)
                        local uconn = UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                draggingKnob = false
                            end
                        end)
                        table.insert(connections, mconn)
                        table.insert(connections, uconn)
                        return knb
                    end

                    local hueColors = {}
                    for i = 0, 6 do
                        table.insert(hueColors, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6, 1, 1)))
                    end

                    MakeHSVSlider("H", h, 20, hueColors, function(val)
                        h = val
                        current = Color3.fromHSV(h, s, v)
                        preview.BackgroundColor3 = current
                        if cfg.Callback then task.spawn(cfg.Callback, current) end
                    end)

                    MakeHSVSlider("S", s, 50,
                        {ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                         ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))},
                        function(val)
                            s = val
                            current = Color3.fromHSV(h, s, v)
                            preview.BackgroundColor3 = current
                            if cfg.Callback then task.spawn(cfg.Callback, current) end
                        end)

                    MakeHSVSlider("V", v, 80,
                        {ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
                         ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, 1))},
                        function(val)
                            v = val
                            current = Color3.fromHSV(h, s, v)
                            preview.BackgroundColor3 = current
                            if cfg.Callback then task.spawn(cfg.Callback, current) end
                        end)

                    -- Close btn
                    local closeBtn = Instance.new("TextButton")
                    closeBtn.Size = UDim2.new(1, 0, 0, 24)
                    closeBtn.Position = UDim2.new(0, 0, 1, -30)
                    closeBtn.BackgroundColor3 = T.TabHover
                    closeBtn.BackgroundTransparency = 0.3
                    closeBtn.Text = "Close"
                    closeBtn.TextColor3 = T.Text
                    closeBtn.Font = Enum.Font.GothamMedium
                    closeBtn.TextSize = 12
                    closeBtn.ZIndex = 62
                    MakeCorner(closeBtn, 4)
                    closeBtn.Parent = pickerFrame

                    closeBtn.MouseButton1Click:Connect(function()
                        open = false
                        if pickerFrame then pickerFrame:Destroy() pickerFrame = nil end
                    end)
                end)

                local ctrl = {}
                function ctrl:Get() return current end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddLabel
            -- ------------------------------------------------------------------
            function SecObj:AddLabel(cfg)
                cfg = cfg or {}
                local row = BaseRow(28)
                MakePadding(row, 0, 0, 10, 10)

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = cfg.Title or cfg.Text or ""
                lbl.TextColor3 = T.DimText
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 12
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextWrapped = true
                lbl.Parent = row

                local ctrl = {}
                function ctrl:Set(v) lbl.Text = v end
                function ctrl:Get() return lbl.Text end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddParagraph
            -- ------------------------------------------------------------------
            function SecObj:AddParagraph(cfg)
                cfg = cfg or {}
                local height = cfg.Height or 60

                local row = BaseRow(height)
                MakePadding(row, 6, 6, 10, 10)

                local layout = Instance.new("UIListLayout")
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding = UDim.new(0, 4)
                layout.Parent = row

                if cfg.Title then
                    local titleLbl = Instance.new("TextLabel")
                    titleLbl.Size = UDim2.new(1, 0, 0, 18)
                    titleLbl.BackgroundTransparency = 1
                    titleLbl.Text = cfg.Title
                    titleLbl.TextColor3 = T.Text
                    titleLbl.Font = Enum.Font.GothamBold
                    titleLbl.TextSize = 13
                    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                    titleLbl.LayoutOrder = 0
                    titleLbl.Parent = row
                end

                local bodyLbl = Instance.new("TextLabel")
                bodyLbl.Size = UDim2.new(1, 0, 0, cfg.Title and height - 28 or height - 12)
                bodyLbl.BackgroundTransparency = 1
                bodyLbl.Text = cfg.Content or cfg.Text or ""
                bodyLbl.TextColor3 = T.DimText
                bodyLbl.Font = Enum.Font.Gotham
                bodyLbl.TextSize = 11
                bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
                bodyLbl.TextWrapped = true
                bodyLbl.LayoutOrder = 1
                bodyLbl.Parent = row
            end

            -- ------------------------------------------------------------------
            --  AddSeparator
            -- ------------------------------------------------------------------
            function SecObj:AddSeparator(cfg)
                cfg = cfg or {}
                local sep = Instance.new("Frame")
                sep.Size = UDim2.new(1, 0, 0, 1)
                sep.BackgroundColor3 = T.SeparatorClr
                sep.BackgroundTransparency = 0.5
                sep.BorderSizePixel = 0
                sep.LayoutOrder = NextOrder()
                sep.Parent = SecContent
            end

            -- ------------------------------------------------------------------
            --  AddProgressBar
            -- ------------------------------------------------------------------
            function SecObj:AddProgressBar(cfg)
                cfg = cfg or {}
                local value = cfg.Default or 0

                local row = BaseRow(44)
                MakePadding(row, 6, 6, 10, 10)

                local topRow = Instance.new("Frame")
                topRow.Size = UDim2.new(1, 0, 0, 16)
                topRow.BackgroundTransparency = 1
                topRow.Parent = row

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Progress"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = topRow

                local valLbl = Instance.new("TextLabel")
                valLbl.Size = UDim2.new(0.3, 0, 1, 0)
                valLbl.Position = UDim2.new(0.7, 0, 0, 0)
                valLbl.BackgroundTransparency = 1
                valLbl.Text = tostring(value) .. "%"
                valLbl.TextColor3 = T.Accent
                valLbl.Font = Enum.Font.GothamBold
                valLbl.TextSize = 12
                valLbl.TextXAlignment = Enum.TextXAlignment.Right
                valLbl.Parent = topRow

                local trackBg = Instance.new("Frame")
                trackBg.Size = UDim2.new(1, 0, 0, 8)
                trackBg.Position = UDim2.new(0, 0, 1, -10)
                trackBg.BackgroundColor3 = T.ToggleOff
                trackBg.BorderSizePixel = 0
                MakeCorner(trackBg, 4)
                trackBg.Parent = row

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(value / 100, 0, 1, 0)
                fill.BackgroundColor3 = T.SliderFill
                fill.BorderSizePixel = 0
                MakeCorner(fill, 4)
                fill.Parent = trackBg

                local ctrl = {}
                function ctrl:Set(v)
                    v = math.clamp(v, 0, 100)
                    value = v
                    CT(fill, {Size = UDim2.new(v / 100, 0, 1, 0)}, 0.3)
                    valLbl.Text = tostring(v) .. "%"
                end
                function ctrl:Get() return value end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddImage
            -- ------------------------------------------------------------------
            function SecObj:AddImage(cfg)
                cfg = cfg or {}
                local height = cfg.Height or 100

                local row = BaseRow(height)
                row.BackgroundTransparency = 1

                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(1, 0, 1, 0)
                img.BackgroundTransparency = 1
                img.Image = cfg.Image or ""
                img.ScaleType = cfg.ScaleType or Enum.ScaleType.Fit
                img.Parent = row
                MakeCorner(img, 6)
            end

            -- ------------------------------------------------------------------
            --  AddSearchBox
            -- ------------------------------------------------------------------
            function SecObj:AddSearchBox(cfg)
                cfg = cfg or {}
                local row = BaseRow(36)
                MakePadding(row, 0, 0, 10, 10)

                local sbLayout = Instance.new("UIListLayout")
                sbLayout.FillDirection = Enum.FillDirection.Horizontal
                sbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                sbLayout.Padding = UDim.new(0, 6)
                sbLayout.Parent = row

                MakeIcon(row, "search", 14, nil, T.DimText)

                local inputBox = Instance.new("TextBox")
                inputBox.Size = UDim2.new(1, -28, 0.8, 0)
                inputBox.BackgroundTransparency = 1
                inputBox.Text = ""
                inputBox.PlaceholderText = cfg.Placeholder or "Search..."
                inputBox.PlaceholderColor3 = T.DimText
                inputBox.TextColor3 = T.Text
                inputBox.Font = Enum.Font.GothamMedium
                inputBox.TextSize = 12
                inputBox.TextXAlignment = Enum.TextXAlignment.Left
                inputBox.ClearTextOnFocus = false
                inputBox.Parent = row

                inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if cfg.Callback then task.spawn(cfg.Callback, inputBox.Text) end
                end)

                local ctrl = {}
                function ctrl:Get() return inputBox.Text end
                return ctrl
            end

            -- ------------------------------------------------------------------
            --  AddCodeBlock
            -- ------------------------------------------------------------------
            function SecObj:AddCodeBlock(cfg)
                cfg = cfg or {}
                local height = cfg.Height or 80

                local row = BaseRow(height)
                row.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
                row.BackgroundTransparency = 0.1
                MakePadding(row, 6, 6, 10, 10)

                local code = Instance.new("TextLabel")
                code.Size = UDim2.new(1, 0, 1, 0)
                code.BackgroundTransparency = 1
                code.Text = cfg.Code or cfg.Text or ""
                code.TextColor3 = Color3.fromRGB(180, 255, 180)
                code.Font = Enum.Font.Code
                code.TextSize = 11
                code.TextXAlignment = Enum.TextXAlignment.Left
                code.TextYAlignment = Enum.TextYAlignment.Top
                code.TextWrapped = true
                code.Parent = row
            end

            -- ------------------------------------------------------------------
            --  AddList
            -- ------------------------------------------------------------------
            function SecObj:AddList(cfg)
                cfg = cfg or {}
                local items = cfg.Items or {}

                for i, item in ipairs(items) do
                    local row = BaseRow(30)
                    MakePadding(row, 0, 0, 10, 10)

                    local rowLayout = Instance.new("UIListLayout")
                    rowLayout.FillDirection = Enum.FillDirection.Horizontal
                    rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    rowLayout.Padding = UDim.new(0, 6)
                    rowLayout.Parent = row

                    -- dot
                    local dot = Instance.new("Frame")
                    dot.Size = UDim2.new(0, 5, 0, 5)
                    dot.BackgroundColor3 = T.Accent
                    dot.BorderSizePixel = 0
                    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
                    dot.Parent = row

                    local lbl = Instance.new("TextLabel")
                    lbl.BackgroundTransparency = 1
                    lbl.Text = tostring(item)
                    lbl.TextColor3 = T.Text
                    lbl.Font = Enum.Font.Gotham
                    lbl.TextSize = 12
                    lbl.Size = UDim2.new(1, -20, 1, 0)
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.Parent = row
                end
            end

            -- ------------------------------------------------------------------
            --  AddPlayerList
            -- ------------------------------------------------------------------
            function SecObj:AddPlayerList(cfg)
                cfg = cfg or {}
                local onSelect = cfg.Callback

                local function BuildList()
                    -- Clear existing player rows (re-build on refresh)
                    for _, child in ipairs(SecContent:GetChildren()) do
                        if child:GetAttribute("PlayerRow") then child:Destroy() end
                    end

                    for _, plr in ipairs(Players:GetPlayers()) do
                        if not cfg.IncludeSelf and plr == Player then continue end

                        local row = BaseRow(34)
                        row:SetAttribute("PlayerRow", true)
                        MakePadding(row, 0, 0, 8, 8)

                        local rowLayout = Instance.new("UIListLayout")
                        rowLayout.FillDirection = Enum.FillDirection.Horizontal
                        rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                        rowLayout.Padding = UDim.new(0, 8)
                        rowLayout.Parent = row

                        -- Avatar thumbnail
                        local avatar = Instance.new("ImageLabel")
                        avatar.Size = UDim2.new(0, 24, 0, 24)
                        avatar.BackgroundColor3 = T.ComponentBg
                        avatar.Image = Players:GetUserThumbnailAsync(
                            plr.UserId,
                            Enum.ThumbnailType.HeadShot,
                            Enum.ThumbnailSize.Size48x48
                        )
                        MakeCorner(avatar, 12)
                        avatar.Parent = row

                        local nameLbl = Instance.new("TextLabel")
                        nameLbl.BackgroundTransparency = 1
                        nameLbl.Text = plr.Name
                        nameLbl.TextColor3 = T.Text
                        nameLbl.Font = Enum.Font.GothamMedium
                        nameLbl.TextSize = 12
                        nameLbl.Size = UDim2.new(1, -80, 1, 0)
                        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                        nameLbl.Parent = row

                        local selBtn = Instance.new("TextButton")
                        selBtn.Size = UDim2.new(1, 0, 1, 0)
                        selBtn.BackgroundTransparency = 1
                        selBtn.Text = ""
                        selBtn.Parent = row

                        selBtn.MouseButton1Click:Connect(function()
                            CT(row, {BackgroundColor3 = T.TabActive}, 0.15)
                            task.wait(0.2)
                            CT(row, {BackgroundColor3 = T.ComponentBg}, 0.15)
                            if onSelect then task.spawn(onSelect, plr) end
                        end)
                    end
                end

                BuildList()

                -- Refresh button
                local refRow = BaseRow(28)
                MakePadding(refRow, 0, 0, 10, 10)
                local refBtn = Instance.new("TextButton")
                refBtn.Size = UDim2.new(1, 0, 1, 0)
                refBtn.BackgroundTransparency = 1
                refBtn.Text = "↻  Refresh"
                refBtn.TextColor3 = T.Accent
                refBtn.Font = Enum.Font.GothamBold
                refBtn.TextSize = 12
                refBtn.Parent = refRow
                refBtn.MouseButton1Click:Connect(BuildList)

                Players.PlayerAdded:Connect(BuildList)
                Players.PlayerRemoving:Connect(function()
                    task.wait(0.1)
                    BuildList()
                end)
            end

            -- ------------------------------------------------------------------
            --  AddConfigSystem
            -- ------------------------------------------------------------------
            function SecObj:AddConfigSystem(cfg)
                cfg = cfg or {}

                -- Save button
                self:AddButton({
                    Title = cfg.SaveTitle or "Save Config",
                    Icon  = "save",
                    Callback = function()
                        SaveConfig(configName, configData)
                        SendNotification({
                            Title = "Config Saved",
                            Desc  = "Your configuration has been saved.",
                            Type  = "success",
                            Duration = 2
                        }, T)
                    end
                })

                -- Load button
                self:AddButton({
                    Title = cfg.LoadTitle or "Load Config",
                    Icon  = "download",
                    Callback = function()
                        local loaded = LoadConfig(configName)
                        for k, v in pairs(loaded) do
                            configData[k] = v
                        end
                        SendNotification({
                            Title = "Config Loaded",
                            Desc  = "Configuration restored.",
                            Type  = "info",
                            Duration = 2
                        }, T)
                        if cfg.OnLoad then task.spawn(cfg.OnLoad, loaded) end
                    end
                })

                -- Reset button
                if cfg.ShowReset then
                    self:AddButton({
                        Title = "Reset Config",
                        Icon  = "trash",
                        Callback = function()
                            for k in pairs(configData) do configData[k] = nil end
                            SendNotification({
                                Title = "Config Reset",
                                Desc  = "Configuration cleared.",
                                Type  = "warning",
                                Duration = 2
                            }, T)
                        end
                    })
                end
            end

            return SecObj
        end -- AddSection

        -- Convenience aliases at tab level
        function TabObj:AddButton(cfg)
            local sec = self:AddSection({})
            return sec:AddButton(cfg)
        end
        function TabObj:AddToggle(cfg)
            local sec = self:AddSection({})
            return sec:AddToggle(cfg)
        end
        function TabObj:AddSlider(cfg)
            local sec = self:AddSection({})
            return sec:AddSlider(cfg)
        end

        return TabObj
    end -- AddTab

    -- =========================================================================
    --  Notify (window-level shorthand)
    -- =========================================================================
    function WindowObj:Notify(cfg)
        SendNotification(cfg, T)
    end

    -- =========================================================================
    --  Destroy
    -- =========================================================================
    function WindowObj:Destroy()
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        if BlurEffect and BlurEffect.Parent then BlurEffect:Destroy() end
        if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
    end

    return WindowObj
end -- CreateWindow

return SystemUI
