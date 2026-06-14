-- =========================================================================
--  S Y S T E M U I  v2.0  —  Manhwa / Holographic UI Library
--  Author  : CoiledTom
--  Icons   : Footagesus  (https://github.com/Footagesus/Icons)
--  Repo    : https://github.com/CoiledTom/Lajib
-- =========================================================================
--[[
    local SystemUI = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/SystemUI.lua"
    ))()
--]]

-- =========================================================================
--  SERVICES
-- =========================================================================
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local Player           = Players.LocalPlayer

-- =========================================================================
--  ICONS  — Icons2.lua (raw numeric IDs, no dashes in keys)
--           Falls back to Icons.lua if Icons2 not found
-- =========================================================================
local Icons = {}
do
    local function LoadIconFile(url)
        local ok, result = pcall(function()
            return loadstring(game:HttpGet(url, true))()
        end)
        if ok and type(result) == "table" then
            for k, v in pairs(result) do
                if type(v) == "number" then
                    Icons[k] = "rbxassetid://" .. tostring(v)
                elseif type(v) == "string" then
                    Icons[k] = v
                end
            end
            return true
        end
        return false
    end
    -- Try Icons2 first, fall back to Icons
    if not LoadIconFile("https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/Icons2.lua") then
        LoadIconFile("https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/Icons.lua")
    end
end

-- Normalise: strip "lucide-" prefix + all dashes + lowercase
local function _norm(s) return (s or ""):gsub("^lucide%-",""):gsub("%-",""):lower() end

-- Fallback aliases (normalised → normalised)
local _iconAliases = {
    refreshcw      = {"rotatecw","refresh"},
    trash2         = {"trash","delete"},
    trianglealert  = {"alerttriangle","warning"},
    checkcircle    = {"checkcircle2","check"},
    xcircle        = {"x","closecircle"},
    treepine       = {"tree","leaf"},
    mountainsnow   = {"mountain"},
    waves          = {"water","activity"},
    trendingup     = {"arrowupright"},
    circledot      = {"target"},
    trophy         = {"award","star"},
    rotatecw       = {"refreshcw","refresh"},
    lockkeyhole    = {"lock","keyhole"},
    lockopen       = {"unlock","lockkeyholeopen"},
}

local function ResolveIcon(str)
    if not str then return nil end
    local key = _norm(str)
    if Icons[key] then return Icons[key] end
    local alts = _iconAliases[key]
    if alts then
        for _, alt in ipairs(alts) do
            if Icons[_norm(alt)] then return Icons[_norm(alt)] end
        end
    end
    return nil
end

-- =========================================================================
--  THEMES  (8 total)
-- =========================================================================
local Themes = {

    Holographic = {
        Background   = Color3.fromRGB(10, 15, 25),
        HeaderBg     = Color3.fromRGB(8, 12, 22),
        SectionBg    = Color3.fromRGB(12, 18, 32),
        SecondaryBg  = Color3.fromRGB(15, 22, 38),
        ComponentBg  = Color3.fromRGB(20, 28, 48),
        Accent       = Color3.fromRGB(0, 220, 255),
        AccentDim    = Color3.fromRGB(0, 140, 180),
        Text         = Color3.fromRGB(230, 240, 255),
        DimText      = Color3.fromRGB(100, 130, 170),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 60, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(80, 180, 255),
        ToggleOn     = Color3.fromRGB(0, 50, 80),
        ToggleOff    = Color3.fromRGB(25, 35, 55),
        SliderFill   = Color3.fromRGB(0, 200, 240),
        TabActive    = Color3.fromRGB(0, 45, 75),
        TabHover     = Color3.fromRGB(0, 28, 50),
        SeparatorClr = Color3.fromRGB(0, 150, 200),
        NotifBg      = Color3.fromRGB(10, 15, 25),
    },

    Crimson = {
        Background   = Color3.fromRGB(18, 8, 10),
        HeaderBg     = Color3.fromRGB(12, 5, 7),
        SectionBg    = Color3.fromRGB(22, 10, 12),
        SecondaryBg  = Color3.fromRGB(28, 12, 15),
        ComponentBg  = Color3.fromRGB(36, 16, 20),
        Accent       = Color3.fromRGB(255, 50, 80),
        AccentDim    = Color3.fromRGB(180, 30, 55),
        Text         = Color3.fromRGB(255, 228, 232),
        DimText      = Color3.fromRGB(155, 95, 110),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 80, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(255, 80, 120),
        ToggleOn     = Color3.fromRGB(80, 10, 20),
        ToggleOff    = Color3.fromRGB(45, 18, 24),
        SliderFill   = Color3.fromRGB(255, 50, 80),
        TabActive    = Color3.fromRGB(65, 10, 18),
        TabHover     = Color3.fromRGB(45, 7, 14),
        SeparatorClr = Color3.fromRGB(200, 30, 60),
        NotifBg      = Color3.fromRGB(18, 8, 10),
    },

    Void = {
        Background   = Color3.fromRGB(8, 6, 18),
        HeaderBg     = Color3.fromRGB(5, 4, 14),
        SectionBg    = Color3.fromRGB(10, 7, 22),
        SecondaryBg  = Color3.fromRGB(14, 10, 30),
        ComponentBg  = Color3.fromRGB(20, 14, 40),
        Accent       = Color3.fromRGB(160, 80, 255),
        AccentDim    = Color3.fromRGB(100, 50, 180),
        Text         = Color3.fromRGB(232, 222, 255),
        DimText      = Color3.fromRGB(110, 90, 155),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 60, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(160, 80, 255),
        ToggleOn     = Color3.fromRGB(50, 18, 90),
        ToggleOff    = Color3.fromRGB(28, 18, 52),
        SliderFill   = Color3.fromRGB(160, 80, 255),
        TabActive    = Color3.fromRGB(40, 14, 80),
        TabHover     = Color3.fromRGB(26, 10, 56),
        SeparatorClr = Color3.fromRGB(120, 50, 220),
        NotifBg      = Color3.fromRGB(8, 6, 18),
    },

    Volcano = {
        Background   = Color3.fromRGB(18, 7, 4),
        HeaderBg     = Color3.fromRGB(12, 5, 3),
        SectionBg    = Color3.fromRGB(24, 10, 5),
        SecondaryBg  = Color3.fromRGB(30, 13, 6),
        ComponentBg  = Color3.fromRGB(38, 18, 8),
        Accent       = Color3.fromRGB(255, 110, 20),
        AccentDim    = Color3.fromRGB(190, 70, 10),
        Text         = Color3.fromRGB(255, 235, 215),
        DimText      = Color3.fromRGB(160, 105, 70),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 60, 30),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(255, 150, 50),
        ToggleOn     = Color3.fromRGB(80, 25, 5),
        ToggleOff    = Color3.fromRGB(45, 16, 6),
        SliderFill   = Color3.fromRGB(255, 110, 20),
        TabActive    = Color3.fromRGB(70, 20, 5),
        TabHover     = Color3.fromRGB(48, 14, 4),
        SeparatorClr = Color3.fromRGB(220, 80, 15),
        NotifBg      = Color3.fromRGB(18, 7, 4),
    },

    Love = {
        Background   = Color3.fromRGB(18, 6, 14),
        HeaderBg     = Color3.fromRGB(12, 4, 10),
        SectionBg    = Color3.fromRGB(24, 8, 18),
        SecondaryBg  = Color3.fromRGB(30, 10, 24),
        ComponentBg  = Color3.fromRGB(40, 14, 32),
        Accent       = Color3.fromRGB(255, 90, 155),
        AccentDim    = Color3.fromRGB(200, 55, 115),
        Text         = Color3.fromRGB(255, 228, 242),
        DimText      = Color3.fromRGB(160, 95, 135),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 60, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(255, 120, 180),
        ToggleOn     = Color3.fromRGB(80, 10, 40),
        ToggleOff    = Color3.fromRGB(48, 10, 30),
        SliderFill   = Color3.fromRGB(255, 90, 155),
        TabActive    = Color3.fromRGB(70, 8, 35),
        TabHover     = Color3.fromRGB(48, 6, 25),
        SeparatorClr = Color3.fromRGB(220, 60, 130),
        NotifBg      = Color3.fromRGB(18, 6, 14),
    },

    Forest = {
        Background   = Color3.fromRGB(6, 14, 8),
        HeaderBg     = Color3.fromRGB(4, 10, 6),
        SectionBg    = Color3.fromRGB(8, 18, 10),
        SecondaryBg  = Color3.fromRGB(10, 24, 14),
        ComponentBg  = Color3.fromRGB(14, 32, 18),
        Accent       = Color3.fromRGB(50, 220, 100),
        AccentDim    = Color3.fromRGB(30, 155, 65),
        Text         = Color3.fromRGB(218, 255, 228),
        DimText      = Color3.fromRGB(95, 155, 110),
        Success      = Color3.fromRGB(80, 255, 120),
        Error        = Color3.fromRGB(255, 80, 80),
        Warning      = Color3.fromRGB(255, 200, 0),
        Info         = Color3.fromRGB(50, 220, 100),
        ToggleOn     = Color3.fromRGB(10, 55, 20),
        ToggleOff    = Color3.fromRGB(12, 32, 16),
        SliderFill   = Color3.fromRGB(50, 220, 100),
        TabActive    = Color3.fromRGB(8, 50, 18),
        TabHover     = Color3.fromRGB(6, 32, 12),
        SeparatorClr = Color3.fromRGB(30, 180, 80),
        NotifBg      = Color3.fromRGB(6, 14, 8),
    },

    Ocean = {
        Background   = Color3.fromRGB(4, 12, 26),
        HeaderBg     = Color3.fromRGB(3, 8, 18),
        SectionBg    = Color3.fromRGB(6, 16, 34),
        SecondaryBg  = Color3.fromRGB(8, 20, 44),
        ComponentBg  = Color3.fromRGB(12, 26, 55),
        Accent       = Color3.fromRGB(0, 185, 255),
        AccentDim    = Color3.fromRGB(0, 125, 200),
        Text         = Color3.fromRGB(215, 238, 255),
        DimText      = Color3.fromRGB(95, 145, 185),
        Success      = Color3.fromRGB(0, 255, 190),
        Error        = Color3.fromRGB(255, 80, 80),
        Warning      = Color3.fromRGB(255, 210, 0),
        Info         = Color3.fromRGB(0, 185, 255),
        ToggleOn     = Color3.fromRGB(0, 45, 80),
        ToggleOff    = Color3.fromRGB(10, 28, 58),
        SliderFill   = Color3.fromRGB(0, 185, 255),
        TabActive    = Color3.fromRGB(0, 38, 70),
        TabHover     = Color3.fromRGB(0, 25, 50),
        SeparatorClr = Color3.fromRGB(0, 150, 220),
        NotifBg      = Color3.fromRGB(4, 12, 26),
    },

    Gold = {
        Background   = Color3.fromRGB(14, 11, 4),
        HeaderBg     = Color3.fromRGB(10, 8, 3),
        SectionBg    = Color3.fromRGB(18, 14, 5),
        SecondaryBg  = Color3.fromRGB(24, 18, 6),
        ComponentBg  = Color3.fromRGB(32, 24, 8),
        Accent       = Color3.fromRGB(255, 195, 45),
        AccentDim    = Color3.fromRGB(200, 148, 28),
        Text         = Color3.fromRGB(255, 248, 225),
        DimText      = Color3.fromRGB(160, 138, 78),
        Success      = Color3.fromRGB(0, 255, 160),
        Error        = Color3.fromRGB(255, 80, 80),
        Warning      = Color3.fromRGB(255, 195, 45),
        Info         = Color3.fromRGB(255, 215, 80),
        ToggleOn     = Color3.fromRGB(70, 52, 5),
        ToggleOff    = Color3.fromRGB(40, 30, 8),
        SliderFill   = Color3.fromRGB(255, 195, 45),
        TabActive    = Color3.fromRGB(60, 44, 5),
        TabHover     = Color3.fromRGB(40, 30, 4),
        SeparatorClr = Color3.fromRGB(210, 155, 30),
        NotifBg      = Color3.fromRGB(14, 11, 4),
    },

    Black = {
        Background   = Color3.fromRGB(5, 5, 6),
        HeaderBg     = Color3.fromRGB(3, 3, 4),
        SectionBg    = Color3.fromRGB(8, 8, 10),
        SecondaryBg  = Color3.fromRGB(12, 12, 14),
        ComponentBg  = Color3.fromRGB(16, 16, 20),
        Accent       = Color3.fromRGB(220, 220, 240),
        AccentDim    = Color3.fromRGB(140, 140, 160),
        Text         = Color3.fromRGB(230, 230, 240),
        DimText      = Color3.fromRGB(110, 110, 130),
        Success      = Color3.fromRGB(0, 210, 130),
        Error        = Color3.fromRGB(230, 60, 60),
        Warning      = Color3.fromRGB(220, 180, 0),
        Info         = Color3.fromRGB(180, 180, 255),
        ToggleOn     = Color3.fromRGB(40, 40, 55),
        ToggleOff    = Color3.fromRGB(20, 20, 26),
        SliderFill   = Color3.fromRGB(200, 200, 220),
        TabActive    = Color3.fromRGB(30, 30, 40),
        TabHover     = Color3.fromRGB(20, 20, 28),
        SeparatorClr = Color3.fromRGB(80, 80, 100),
        NotifBg      = Color3.fromRGB(5, 5, 6),
    },

    White = {
        Background   = Color3.fromRGB(240, 242, 248),
        HeaderBg     = Color3.fromRGB(228, 232, 244),
        SectionBg    = Color3.fromRGB(230, 234, 246),
        SecondaryBg  = Color3.fromRGB(220, 226, 240),
        ComponentBg  = Color3.fromRGB(210, 216, 232),
        Accent       = Color3.fromRGB(60, 90, 200),
        AccentDim    = Color3.fromRGB(40, 65, 160),
        Text         = Color3.fromRGB(30, 35, 55),
        DimText      = Color3.fromRGB(100, 110, 150),
        Success      = Color3.fromRGB(0, 160, 90),
        Error        = Color3.fromRGB(200, 40, 50),
        Warning      = Color3.fromRGB(180, 130, 0),
        Info         = Color3.fromRGB(60, 90, 200),
        ToggleOn     = Color3.fromRGB(180, 200, 240),
        ToggleOff    = Color3.fromRGB(190, 196, 215),
        SliderFill   = Color3.fromRGB(60, 90, 200),
        TabActive    = Color3.fromRGB(190, 202, 238),
        TabHover     = Color3.fromRGB(200, 210, 240),
        SeparatorClr = Color3.fromRGB(100, 120, 180),
        NotifBg      = Color3.fromRGB(240, 242, 248),
    },

    Brown = {
        Background   = Color3.fromRGB(20, 13, 8),
        HeaderBg     = Color3.fromRGB(14, 9, 5),
        SectionBg    = Color3.fromRGB(26, 16, 10),
        SecondaryBg  = Color3.fromRGB(34, 21, 13),
        ComponentBg  = Color3.fromRGB(44, 27, 16),
        Accent       = Color3.fromRGB(200, 140, 70),
        AccentDim    = Color3.fromRGB(145, 95, 45),
        Text         = Color3.fromRGB(255, 240, 220),
        DimText      = Color3.fromRGB(160, 125, 90),
        Success      = Color3.fromRGB(0, 220, 140),
        Error        = Color3.fromRGB(220, 70, 60),
        Warning      = Color3.fromRGB(230, 175, 40),
        Info         = Color3.fromRGB(200, 140, 70),
        ToggleOn     = Color3.fromRGB(70, 42, 22),
        ToggleOff    = Color3.fromRGB(44, 27, 16),
        SliderFill   = Color3.fromRGB(200, 140, 70),
        TabActive    = Color3.fromRGB(60, 36, 18),
        TabHover     = Color3.fromRGB(44, 27, 14),
        SeparatorClr = Color3.fromRGB(160, 100, 50),
        NotifBg      = Color3.fromRGB(20, 13, 8),
    },
}

-- =========================================================================
--  UTILITIES
-- =========================================================================
local function CT(inst, props, t, style, dir)
    local tw = TweenService:Create(inst,
        TweenInfo.new(t or 0.22, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props)
    tw:Play()
    return tw
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
    return c
end

local function Stroke(p, color, thickness, transp)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transp or 0
    s.Parent = p
    return s
end

local function ListLayout(p, dir, align, pad)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    if align then l.VerticalAlignment = align end
    l.Padding = UDim.new(0, pad or 4)
    l.Parent = p
    return l
end

local function Padding(p, top, bot, left, right)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, top   or 0)
    u.PaddingBottom = UDim.new(0, bot   or 0)
    u.PaddingLeft   = UDim.new(0, left  or 0)
    u.PaddingRight  = UDim.new(0, right or 0)
    u.Parent = p
    return u
end

local function Icon(parent, key, size, x, y, color)
    local id = ResolveIcon(key)
    if not id then return nil end
    local img = Instance.new("ImageLabel")
    img.Size            = UDim2.new(0, size, 0, size)
    img.Position        = UDim2.new(0, x, 0.5, -size/2 + (y or 0))
    img.BackgroundTransparency = 1
    img.Image           = id
    img.ImageColor3     = color
    img.Parent          = parent
    return img
end

-- =========================================================================
--  CONFIG  (readfile / writefile with in-memory fallback)
-- =========================================================================
local _cfgCache = {}

local function SaveConfig(name, data)
    _cfgCache[name] = data
    pcall(function()
        if writefile then
            writefile("SystemUI_"..name..".json",
                game:GetService("HttpService"):JSONEncode(data))
        end
    end)
end

local function LoadConfig(name)
    local ok, raw = pcall(function()
        if readfile then return readfile("SystemUI_"..name..".json") end
    end)
    if ok and raw then
        local ok2, d = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw)
        end)
        if ok2 and d then _cfgCache[name] = d; return d end
    end
    return _cfgCache[name] or {}
end

-- =========================================================================
--  DRAG  (window)
-- =========================================================================
local function MakeDraggable(frame, handle)
    local drag, dragInput, mPos, fPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; mPos = i.Position; fPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == dragInput and drag then
            local d = i.Position - mPos
            frame.Position = UDim2.new(
                fPos.X.Scale, fPos.X.Offset + d.X,
                fPos.Y.Scale, fPos.Y.Offset + d.Y)
        end
    end)
end

-- =========================================================================
--  RESIZE  (window)
-- =========================================================================
local function MakeResizable(frame, minW, minH)
    minW = minW or 380; minH = minH or 280
    local grip = Instance.new("TextButton")
    grip.Size = UDim2.new(0, 16, 0, 16)
    grip.Position = UDim2.new(1, -16, 1, -16)
    grip.BackgroundColor3 = Color3.fromRGB(255,255,255)
    grip.BackgroundTransparency = 0.82
    grip.Text = "⋱"; grip.TextSize = 11
    grip.TextColor3 = Color3.fromRGB(200,220,255)
    grip.Font = Enum.Font.GothamBold
    grip.ZIndex = 10; grip.BorderSizePixel = 0
    grip.Parent = frame; Corner(grip, 4)

    local res, sPos, sSize = false, nil, nil
    grip.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            res = true; sPos = i.Position; sSize = frame.AbsoluteSize
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then res = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if res and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - sPos
            frame.Size = UDim2.new(0, math.max(minW, sSize.X + d.X),
                                   0, math.max(minH, sSize.Y + d.Y))
        end
    end)
    return grip  -- expose for show/hide
end

-- =========================================================================
--  NOTIFICATIONS  (top-level, not clipped)
-- =========================================================================
local _notifGui
local _notifContainer

local function EnsureNotifGui()
    if _notifGui and _notifGui.Parent then return end
    _notifGui = Instance.new("ScreenGui")
    _notifGui.Name = "SystemUI_Notifs"
    _notifGui.ResetOnSpawn = false
    _notifGui.IgnoreGuiInset = true
    _notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _notifGui.Parent = CoreGui
    _notifContainer = Instance.new("Frame")
    _notifContainer.Size = UDim2.new(0, 285, 1, -20)
    _notifContainer.Position = UDim2.new(1, -298, 0, 10)
    _notifContainer.BackgroundTransparency = 1
    _notifContainer.Parent = _notifGui
    local l = ListLayout(_notifContainer, Enum.FillDirection.Vertical, nil, 8)
    l.VerticalAlignment = Enum.VerticalAlignment.Bottom
    l.SortOrder = Enum.SortOrder.LayoutOrder
end

local function SendNotif(cfg, T)
    EnsureNotifGui()
    local typeC = {success=T.Success, error=T.Error, warning=T.Warning, info=T.Info}
    local typeI = {success="check-circle", error="x-circle", warning="triangle-alert", info="info"}
    local nType = (cfg.Type or "info"):lower()
    local aC    = typeC[nType] or T.Accent
    local dur   = cfg.Duration or 3

    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 30, 0, 68)
    F.BackgroundColor3 = T.NotifBg
    F.BackgroundTransparency = 0.08
    F.ClipsDescendants = true
    F.Parent = _notifContainer
    Corner(F, 8); Stroke(F, aC, 1.5, 0.15)

    -- icon (no side bar, flush left)
    local ic = Icon(F, typeI[nType] or "bell", 18, 10, 0, aC)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -42, 0, 22)
    title.Position = UDim2.new(0, 36, 0, 7)
    title.BackgroundTransparency = 1
    title.Text = cfg.Title or "Notification"
    title.TextColor3 = aC
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = F

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -42, 0, 24)
    desc.Position = UDim2.new(0, 36, 0, 29)
    desc.BackgroundTransparency = 1
    desc.Text = cfg.Desc or cfg.Description or ""
    desc.TextColor3 = T.DimText
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 11
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = F

    -- Countdown number (replaces progress bar)
    local timerLbl = Instance.new("TextLabel")
    timerLbl.Size = UDim2.new(0, 32, 0, 18)
    timerLbl.Position = UDim2.new(1, -36, 1, -22)
    timerLbl.BackgroundTransparency = 1
    timerLbl.Text = string.format("%.1f", dur)
    timerLbl.TextColor3 = Color3.fromRGB(
        math.round(aC.R * 255),
        math.round(aC.G * 255),
        math.round(aC.B * 255))
    timerLbl.TextTransparency = 0.3
    timerLbl.Font = Enum.Font.GothamBold
    timerLbl.TextSize = 11
    timerLbl.TextXAlignment = Enum.TextXAlignment.Right
    timerLbl.ZIndex = 3
    timerLbl.Parent = F

    CT(F, {Size = UDim2.new(1, 0, 0, 68)}, 0.4, Enum.EasingStyle.Back)

    -- Countdown task
    task.spawn(function()
        local remaining = dur
        while remaining > 0 and F.Parent do
            task.wait(0.1)
            remaining = math.max(0, remaining - 0.1)
            if F.Parent then
                timerLbl.Text = string.format("%.1f", remaining)
            end
        end
    end)

    task.delay(dur, function()
        if not F or not F.Parent then return end
        CT(F, {BackgroundTransparency = 1, Size = UDim2.new(1, 30, 0, 68)}, 0.3)
        task.wait(0.35)
        if F and F.Parent then F:Destroy() end
    end)
end

-- Module-level Confirm (Y/N) — called by BClose before Win object exists
local function SendConfirm(cfg, T)
    EnsureNotifGui()
    local dur   = cfg.Duration or 12
    local onYes = cfg.OnYes    or function() end
    local onNo  = cfg.OnNo     or function() end

    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 30, 0, 100)
    F.BackgroundColor3 = T.NotifBg
    F.BackgroundTransparency = 0.06
    F.ClipsDescendants = true
    F.Parent = _notifContainer
    Corner(F, 8); Stroke(F, T.Warning, 1.5, 0.2)

    Icon(F, "trianglealert", 18, 10, -16, T.Warning)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -46, 0, 20)
    titleLbl.Position = UDim2.new(0, 36, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = cfg.Title or "Tem certeza?"
    titleLbl.TextColor3 = T.Warning
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = F

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -46, 0, 20)
    descLbl.Position = UDim2.new(0, 36, 0, 28)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = cfg.Desc or ""
    descLbl.TextColor3 = T.DimText
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextWrapped = true
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = F

    local timerL = Instance.new("TextLabel")
    timerL.Size = UDim2.new(0, 28, 0, 16)
    timerL.Position = UDim2.new(1, -32, 0, 8)
    timerL.BackgroundTransparency = 1
    timerL.Text = tostring(dur)
    timerL.TextColor3 = T.DimText
    timerL.Font = Enum.Font.GothamBold
    timerL.TextSize = 11
    timerL.TextXAlignment = Enum.TextXAlignment.Right
    timerL.Parent = F

    local yBtn = Instance.new("TextButton")
    yBtn.Size = UDim2.new(0.48, -2, 0, 26)
    yBtn.Position = UDim2.new(0, 6, 1, -32)
    yBtn.BackgroundColor3 = T.Success
    yBtn.BackgroundTransparency = 0.2
    yBtn.Text = "✓  Sim"
    yBtn.TextColor3 = Color3.fromRGB(255,255,255)
    yBtn.Font = Enum.Font.GothamBold
    yBtn.TextSize = 12
    yBtn.ZIndex = 2
    Corner(yBtn, 5); yBtn.Parent = F

    local nBtn = Instance.new("TextButton")
    nBtn.Size = UDim2.new(0.48, -2, 0, 26)
    nBtn.Position = UDim2.new(0.5, 2, 1, -32)
    nBtn.BackgroundColor3 = T.Error
    nBtn.BackgroundTransparency = 0.2
    nBtn.Text = "✕  Não"
    nBtn.TextColor3 = Color3.fromRGB(255,255,255)
    nBtn.Font = Enum.Font.GothamBold
    nBtn.TextSize = 12
    nBtn.ZIndex = 2
    Corner(nBtn, 5); nBtn.Parent = F

    CT(F, {Size = UDim2.new(1, 0, 0, 100)}, 0.4, Enum.EasingStyle.Back)

    local dismissed = false
    local function Dismiss()
        if dismissed then return end; dismissed = true
        CT(F, {BackgroundTransparency = 1, Size = UDim2.new(1, 30, 0, 100)}, 0.3)
        task.wait(0.35)
        if F and F.Parent then F:Destroy() end
    end

    yBtn.MouseButton1Click:Connect(function() task.spawn(onYes); Dismiss() end)
    nBtn.MouseButton1Click:Connect(function() task.spawn(onNo);  Dismiss() end)

    task.spawn(function()
        local rem = dur
        while rem > 0 and not dismissed and F.Parent do
            task.wait(1); rem = rem - 1
            if F.Parent then timerL.Text = tostring(rem) end
        end
        if not dismissed then Dismiss() end
    end)
end
local SystemUI = {}

function SystemUI:CreateWindow(config)
    config = config or {}
    local wTitle      = config.Title       or "SYSTEM INTERFACE"
    local wSub        = config.SubTitle    or "SystemUI v2.0"
    local wSize       = config.Size        or UDim2.new(0, 580, 0, 440)
    local wKey        = config.ToggleKey   or Enum.KeyCode.RightShift
    local wTheme      = config.Theme       or "Holographic"
    local T           = Themes[wTheme]     or Themes.Holographic
    -- Bubble (shrink-to-dot) config
    -- BubbleImage: rbxassetid:// string → shows image
    -- BubbleText: plain text → shows text
    -- If BubbleText looks like an asset ID, treat it as BubbleImage
    local bImage = config.BubbleImage
    local bText  = config.BubbleText or "S.M"
    local bSize  = config.BubbleSize or 52
    -- Auto-detect asset ID passed into BubbleText
    if not bImage and tostring(bText):match("^rbxassetid://") then
        bImage = tostring(bText)
        bText  = "S.M"
    end
    local cfgName     = wTitle:gsub("%s+", "_")
    local savedCfg    = LoadConfig(cfgName)
    local cfgData     = {}
    local conns       = {}

    -- -----------------------------------------------------------------------
    --  LOCK KEY REGISTRY  (group unlock + persistence)
    -- -----------------------------------------------------------------------
    local _unlockedKeys = {}   -- key → true
    local _lockOverlays = {}   -- key → {overlay, overlay, ...}

    -- Load previously saved unlock state
    pcall(function()
        if readfile then
            local raw = readfile("SystemUI_Locks_" .. cfgName .. ".json")
            if raw then
                local ok, saved = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(raw)
                end)
                if ok and type(saved) == "table" then _unlockedKeys = saved end
            end
        end
    end)

    local function _SaveUnlocked()
        pcall(function()
            if writefile then
                writefile("SystemUI_Locks_" .. cfgName .. ".json",
                    game:GetService("HttpService"):JSONEncode(_unlockedKeys))
            end
        end)
    end

    -- Unlock all overlays sharing the same key
    local function _UnlockKey(key)
        _unlockedKeys[key] = true
        _SaveUnlocked()
        local list = _lockOverlays[key] or {}
        for _, ov in ipairs(list) do
            if ov and ov.Parent then
                CT(ov, {BackgroundTransparency = 1}, 0.22)
                task.delay(0.26, function()
                    if ov and ov.Parent then ov:Destroy() end
                end)
            end
        end
        _lockOverlays[key] = {}
    end

    -- Color registry for live theme switching
    local colorRefs = {}
    local function RC(obj, prop, key)
        if obj and prop and key then
            table.insert(colorRefs, {obj, prop, key})
        end
    end
    local function SC(obj, prop, key)
        obj[prop] = T[key]; RC(obj, prop, key)
    end

    -- Destroy old
    if CoreGui:FindFirstChild("SystemUI_Main") then
        CoreGui.SystemUI_Main:Destroy()
    end

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "SystemUI_Main"
    Gui.ResetOnSpawn = false
    Gui.IgnoreGuiInset = true
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = CoreGui

    -- (Blur removido — não afeta Lighting)

    -- -----------------------------------------------------------------------
    --  MAIN FRAME
    -- -----------------------------------------------------------------------
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, -wSize.X.Offset/2, 0.5, -wSize.Y.Offset/2)
    Main.BackgroundColor3 = T.Background
    Main.BackgroundTransparency = 0.1
    Main.ClipsDescendants = false   -- let UICorner handle visual rounding
    Main.Parent = Gui
    Corner(Main, 10)
    local mainStroke = Stroke(Main, T.Accent, 1.2, 0.3)
    RC(mainStroke, "Color", "Accent")
    RC(Main, "BackgroundColor3", "Background")
    CT(Main, {Size = wSize}, 0.5, Enum.EasingStyle.Exponential)

    -- -----------------------------------------------------------------------
    --  HEADER  (top corners rounded, bottom squared)
    -- -----------------------------------------------------------------------
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundColor3 = T.HeaderBg
    Header.BackgroundTransparency = 0.05
    Header.BorderSizePixel = 0
    Header.ClipsDescendants = false
    Header.ZIndex = 3; Header.Parent = Main
    Corner(Header, 10)           -- rounds all 4 corners of the header
    RC(Header, "BackgroundColor3", "HeaderBg")

    -- Square off the BOTTOM half of the header to hide bottom rounded corners
    local HdrBot = Instance.new("Frame")
    HdrBot.Size = UDim2.new(1, 0, 0, 12)
    HdrBot.Position = UDim2.new(0, 0, 1, -12)
    HdrBot.BackgroundColor3 = T.HeaderBg
    HdrBot.BackgroundTransparency = 0.05
    HdrBot.BorderSizePixel = 0
    HdrBot.ZIndex = 3
    HdrBot.Parent = Header
    RC(HdrBot, "BackgroundColor3", "HeaderBg")

    local HLine = Instance.new("Frame")
    HLine.Size = UDim2.new(1, 0, 0, 1)
    HLine.Position = UDim2.new(0, 0, 1, 0)
    HLine.BackgroundColor3 = T.Accent
    HLine.BackgroundTransparency = 0.45
    HLine.BorderSizePixel = 0
    HLine.Parent = Header
    RC(HLine, "BackgroundColor3", "Accent")

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -120, 0, 22)
    TitleLbl.Position = UDim2.new(0, 12, 0, 5)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = wTitle
    TitleLbl.TextColor3 = T.Accent
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 15
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLbl.ZIndex = 4; TitleLbl.Parent = Header
    RC(TitleLbl, "TextColor3", "Accent")

    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size = UDim2.new(1, -120, 0, 13)
    SubLbl.Position = UDim2.new(0, 12, 0, 26)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = wSub
    SubLbl.TextColor3 = T.DimText
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextSize = 11
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left
    SubLbl.TextTruncate = Enum.TextTruncate.AtEnd
    SubLbl.ZIndex = 4; SubLbl.Parent = Header
    RC(SubLbl, "TextColor3", "DimText")

    local AuthLbl = Instance.new("TextLabel")
    AuthLbl.Size = UDim2.new(1, -120, 0, 10)
    AuthLbl.Position = UDim2.new(0, 12, 0, 39)
    AuthLbl.BackgroundTransparency = 1
    AuthLbl.Text = "Created by CoiledTom"
    AuthLbl.TextColor3 = T.AccentDim
    AuthLbl.Font = Enum.Font.Gotham
    AuthLbl.TextSize = 10
    AuthLbl.TextXAlignment = Enum.TextXAlignment.Left
    AuthLbl.TextTruncate = Enum.TextTruncate.AtEnd
    AuthLbl.ZIndex = 4; AuthLbl.Parent = Header
    RC(AuthLbl, "TextColor3", "AccentDim")

    -- Window buttons
    local BtnRow = Instance.new("Frame")
    BtnRow.Size = UDim2.new(0, 88, 0, 22)
    BtnRow.Position = UDim2.new(1, -96, 0.5, -11)
    BtnRow.BackgroundTransparency = 1
    BtnRow.ZIndex = 5; BtnRow.Parent = Header
    ListLayout(BtnRow, Enum.FillDirection.Horizontal, Enum.VerticalAlignment.Center, 5)

    local function WinBtn(sym, clr)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, 22)
        b.BackgroundColor3 = T.ComponentBg
        b.BackgroundTransparency = 0.35
        b.Text = sym; b.TextColor3 = clr
        b.Font = Enum.Font.GothamBold; b.TextSize = 12
        b.ZIndex = 6; b.Parent = BtnRow
        Corner(b, 4); Stroke(b, clr, 1, 0.55)
        b.MouseEnter:Connect(function()
            CT(b, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}, 0.12)
        end)
        b.MouseLeave:Connect(function()
            CT(b, {BackgroundTransparency = 0.35, TextColor3 = clr}, 0.12)
        end)
        return b
    end

    -- Icon-based button (for close) — falls back to text if icon not loaded
    local function WinIconBtn(iconKey, clr)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, 22)
        b.BackgroundColor3 = T.ComponentBg
        b.BackgroundTransparency = 0.35
        b.ZIndex = 6; b.Parent = BtnRow
        Corner(b, 4); Stroke(b, clr, 1, 0.55)
        local ic = Icon(b, iconKey, 12, 6, 0, clr)
        if ic then
            b.Text = ""
        else
            -- fallback text if icon not loaded
            b.Text = "✕"; b.TextColor3 = clr
            b.Font = Enum.Font.GothamBold; b.TextSize = 12
        end
        b.MouseEnter:Connect(function()
            CT(b, {BackgroundTransparency = 0}, 0.12)
            if ic then CT(ic, {ImageColor3 = Color3.fromRGB(255,255,255)}, 0.12)
            else CT(b, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.12) end
        end)
        b.MouseLeave:Connect(function()
            CT(b, {BackgroundTransparency = 0.35}, 0.12)
            if ic then CT(ic, {ImageColor3 = clr}, 0.12)
            else CT(b, {TextColor3 = clr}, 0.12) end
        end)
        return b
    end

    local BMin    = WinBtn("−", T.Warning)
    local BShrink = WinBtn("◎", T.Info)
    local BClose  = WinIconBtn("x", T.Error)  -- X icon from Icons2

    -- -----------------------------------------------------------------------
    --  BODY
    -- -----------------------------------------------------------------------
    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.Size = UDim2.new(1, 0, 1, -52)
    Body.Position = UDim2.new(0, 0, 0, 52)
    Body.BackgroundTransparency = 1
    Body.ClipsDescendants = true
    Body.Parent = Main

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 148, 1, -8)
    Sidebar.Position = UDim2.new(0, 6, 0, 4)
    Sidebar.BackgroundColor3 = T.SectionBg
    Sidebar.BackgroundTransparency = 0.25
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0,0,0,0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.ClipsDescendants = true
    Sidebar.Parent = Body
    Corner(Sidebar, 8)
    local sideStroke = Stroke(Sidebar, T.Accent, 1, 0.7)
    RC(Sidebar, "BackgroundColor3", "SectionBg")
    RC(sideStroke, "Color", "Accent")
    Padding(Sidebar, 5, 5, 5, 5)
    ListLayout(Sidebar, Enum.FillDirection.Vertical, nil, 3)

    -- Page container
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Size = UDim2.new(1, -162, 1, -8)
    Pages.Position = UDim2.new(0, 158, 0, 4)
    Pages.BackgroundTransparency = 1
    Pages.ClipsDescendants = true
    Pages.Parent = Body

    -- Draggable & resizable
    MakeDraggable(Main, Header)
    local ResizeGrip = MakeResizable(Main, 400, 280)

    -- -----------------------------------------------------------------------
    --  STATE  (declared early so closures below capture correct upvalues)
    -- -----------------------------------------------------------------------
    local minimized  = false
    local storedSize = wSize
    local visible    = true
    local inBubbleMode = false

    -- -----------------------------------------------------------------------
    --  BUBBLE  (shrink-to-dot)
    -- -----------------------------------------------------------------------
    local Bubble = Instance.new("Frame")
    Bubble.Name = "Bubble"
    Bubble.Size = UDim2.new(0, bSize, 0, bSize)
    Bubble.Position = UDim2.new(0, 18, 0, 110)  -- left side, below top UI chrome
    Bubble.BackgroundColor3 = T.Background
    Bubble.BackgroundTransparency = 0.04
    Bubble.Visible = false
    Bubble.ZIndex = 50
    Bubble.ClipsDescendants = true
    Bubble.Parent = Gui
    Corner(Bubble, bSize / 2)
    local bubbleStroke = Stroke(Bubble, T.Accent, 2, 0)
    RC(Bubble, "BackgroundColor3", "Background")
    RC(bubbleStroke, "Color", "Accent")

    -- Outer glow ring
    local bubbleGlow = Instance.new("Frame")
    bubbleGlow.Size = UDim2.new(1, 10, 1, 10)
    bubbleGlow.Position = UDim2.new(0, -5, 0, -5)
    bubbleGlow.BackgroundColor3 = T.Accent
    bubbleGlow.BackgroundTransparency = 0.82
    bubbleGlow.ZIndex = 49
    bubbleGlow.Parent = Bubble
    Corner(bubbleGlow, (bSize + 10) / 2)
    RC(bubbleGlow, "BackgroundColor3", "Accent")

    -- Content: image OR text
    if bImage then
        local bImg = Instance.new("ImageLabel")
        bImg.Size = UDim2.new(1, -8, 1, -8)
        bImg.Position = UDim2.new(0, 4, 0, 4)
        bImg.BackgroundTransparency = 1
        bImg.Image = bImage
        bImg.ScaleType = Enum.ScaleType.Fit
        bImg.ZIndex = 52
        bImg.Parent = Bubble
        Corner(bImg, (bSize - 8) / 2)
    else
        local bLbl = Instance.new("TextLabel")
        bLbl.Size = UDim2.new(1, 0, 1, 0)
        bLbl.BackgroundTransparency = 1
        bLbl.Text = bText
        bLbl.TextColor3 = T.Accent
        bLbl.Font = Enum.Font.GothamBold
        bLbl.TextSize = math.clamp(bSize / 3.5, 11, 16)
        bLbl.ZIndex = 52
        bLbl.Parent = Bubble
        RC(bLbl, "TextColor3", "Accent")
    end

    -- Click zone — also serves as drag handle (on top, ZIndex 53)
    local bubbleBtn = Instance.new("TextButton")
    bubbleBtn.Size = UDim2.new(1, 0, 1, 0)
    bubbleBtn.BackgroundTransparency = 1
    bubbleBtn.Text = ""
    bubbleBtn.ZIndex = 53
    bubbleBtn.Parent = Bubble
    -- Drag uses bubbleBtn as handle so input reaches it correctly
    MakeDraggable(Bubble, bubbleBtn)

    -- Pulsing glow
    local function PulseGlow()
        if not Bubble.Visible then return end
        CT(bubbleGlow, {BackgroundTransparency = 0.94}, 0.9, Enum.EasingStyle.Sine).Completed:Connect(function()
            if not Bubble.Visible then return end
            CT(bubbleGlow, {BackgroundTransparency = 0.68}, 0.9, Enum.EasingStyle.Sine).Completed:Connect(function()
                PulseGlow()
            end)
        end)
    end

    -- Helper: restore from bubble/shrunk state
    local function RestoreWindow()
        inBubbleMode = false
        CT(Bubble, {Size = UDim2.new(0, 0, 0, 0)}, 0.22, Enum.EasingStyle.Quart)
        task.wait(0.25)
        Bubble.Visible = false
        Main.BackgroundTransparency = 0.1
        Main.Visible = true
        SubLbl.Visible = true
        AuthLbl.Visible = true
        ResizeGrip.Visible = true
        CT(Main, {Size = storedSize}, 0.38, Enum.EasingStyle.Back)
        visible = true
    end

    -- Bubble tap → restore (use InputBegan for reliable mobile touch)
    bubbleBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            local startPos = i.Position
            local moved = false
            local moveConn = UserInputService.InputChanged:Connect(function(mi)
                if (mi.UserInputType == Enum.UserInputType.MouseMovement
                or mi.UserInputType == Enum.UserInputType.Touch) then
                    if (mi.Position - startPos).Magnitude > 8 then
                        moved = true
                    end
                end
            end)
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    moveConn:Disconnect()
                    if not moved then
                        task.spawn(RestoreWindow)
                    end
                end
            end)
        end
    end)

    -- -----------------------------------------------------------------------
    --  WINDOW BUTTON LOGIC
    -- -----------------------------------------------------------------------

    -- [−] Minimize → compact pill
    BMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            storedSize = Main.Size
            SubLbl.Visible = false
            AuthLbl.Visible = false
            HdrBot.Visible = false    -- hide bottom-square so pill corners all round
            Body.Visible = false
            ResizeGrip.Visible = false
            -- Shrink header to pill height so no overflow
            CT(Header, {Size = UDim2.new(1, 0, 0, 44)}, 0.3, Enum.EasingStyle.Back)
            CT(Main,   {Size = UDim2.new(0, 260, 0, 44)}, 0.3, Enum.EasingStyle.Back)
        else
            HdrBot.Visible = true
            SubLbl.Visible = true
            AuthLbl.Visible = true
            ResizeGrip.Visible = true
            Body.Visible = true
            CT(Header, {Size = UDim2.new(1, 0, 0, 52)}, 0.32, Enum.EasingStyle.Back)
            CT(Main,   {Size = storedSize}, 0.32, Enum.EasingStyle.Back)
        end
    end)

    -- [◎] Shrink to bubble
    BShrink.MouseButton1Click:Connect(function()
        if inBubbleMode then return end
        inBubbleMode = true
        storedSize = minimized and storedSize or Main.Size
        CT(Main, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.9}, 0.25, Enum.EasingStyle.Quart)
        task.wait(0.28)
        Main.Visible = false
        -- Reset state for restore
        Body.Visible = true
        SubLbl.Visible = true
        AuthLbl.Visible = true
        ResizeGrip.Visible = false
        minimized = false
        -- Animate bubble in
        Bubble.Size = UDim2.new(0, 0, 0, 0)
        Bubble.Visible = true
        CT(Bubble, {Size = UDim2.new(0, bSize, 0, bSize)}, 0.42, Enum.EasingStyle.Back)
        task.wait(0.2)
        PulseGlow()
        visible = false
    end)

    -- [✕] Close — Pede confirmação antes de fechar
    BClose.MouseButton1Click:Connect(function()
        SendConfirm({
            Title    = "Fechar GUI?",
            Desc     = "Tem certeza que quer fechar a GUI?",
            Duration = 10,
            OnYes    = function()
                CT(Main, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}, 0.28)
                Bubble.Visible = false
                task.wait(0.32)
                Gui:Destroy()
                for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            end,
            OnNo = function() end,
        }, T)
    end)

    table.insert(conns, UserInputService.InputBegan:Connect(function(i, gpe)
        if gpe then return end
        if i.KeyCode == wKey then
            if inBubbleMode then
                task.spawn(RestoreWindow)
                return
            end
            visible = not visible
            if visible then
                Main.Visible = true
                SubLbl.Visible = not minimized
                AuthLbl.Visible = not minimized
                ResizeGrip.Visible = not minimized
                CT(Main, {Size = minimized and UDim2.new(0, 260, 0, 44) or storedSize}, 0.32, Enum.EasingStyle.Back)
            else
                CT(Main, {Size = UDim2.new(0,0,0,0)}, 0.25)
                task.wait(0.3); Main.Visible = false
            end
        end
    end))

    -- Auto-save
    local _autoTimer
    local function AutoSave()
        if _autoTimer then task.cancel(_autoTimer) end
        _autoTimer = task.delay(1.5, function() SaveConfig(cfgName, cfgData) end)
    end

    -- =========================================================================
    --  WINDOW OBJECT
    -- =========================================================================
    local Win = {
        _tabs = {}, _activeTab = nil,
        _cfgName = cfgName, _cfgData = cfgData,
    }

    function Win:Notify(c)    SendNotif(c, T) end
    function Win:SaveConfig() SaveConfig(cfgName, cfgData) end
    function Win:LoadConfig() return LoadConfig(cfgName) end

    -- Confirm notification with Y / N buttons
    function Win:Confirm(cfg)
        SendConfirm(cfg, T)
    end

    function Win:Destroy()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        if Gui and Gui.Parent then Gui:Destroy() end
    end

    -- Live theme switching
    function Win:SetTheme(name)
        local newT = Themes[name]
        if not newT then return end
        T = newT
        for _, r in ipairs(colorRefs) do
            pcall(function()
                if r[1] and r[1].Parent then
                    CT(r[1], {[r[2]] = newT[r[3]]}, 0.3)
                end
            end)
        end
    end

    -- =========================================================================
    --  ADD TAB
    -- =========================================================================
    function Win:AddTab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"

        -- Sidebar button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = T.ComponentBg
        TabBtn.BackgroundTransparency = 0.55
        TabBtn.Text = ""
        TabBtn.Parent = Sidebar
        Corner(TabBtn, 6)
        RC(TabBtn, "BackgroundColor3", "ComponentBg")

        -- Icon in tab
        local tabIconObj
        if cfg.Icon then
            tabIconObj = Icon(TabBtn, cfg.Icon, 13, 8, 0, T.DimText)
            if tabIconObj then RC(tabIconObj, "ImageColor3", "DimText") end
        end
        local tabIconW = (tabIconObj and 13+6) or 0

        local TabLbl = Instance.new("TextLabel")
        TabLbl.BackgroundTransparency = 1
        TabLbl.Text = tabTitle
        TabLbl.TextColor3 = T.DimText
        TabLbl.Font = Enum.Font.GothamMedium
        TabLbl.TextSize = 12
        TabLbl.Position = UDim2.new(0, 8 + tabIconW, 0, 0)
        TabLbl.Size = UDim2.new(1, -(8 + tabIconW + 6), 1, 0)
        TabLbl.TextXAlignment = Enum.TextXAlignment.Left
        TabLbl.TextTruncate = Enum.TextTruncate.AtEnd
        TabLbl.Parent = TabBtn
        RC(TabLbl, "TextColor3", "DimText")

        -- Page scroll
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = T.Accent
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        Page.Parent = Pages
        RC(Page, "ScrollBarImageColor3", "Accent")

        ListLayout(Page, Enum.FillDirection.Vertical, nil, 7)
        Padding(Page, 4, 8, 4, 4)

        local entry = {Btn = TabBtn, Page = Page, Lbl = TabLbl, IconObj = tabIconObj}
        table.insert(Win._tabs, entry)

        local function Activate()
            for _, te in ipairs(Win._tabs) do
                CT(te.Btn, {BackgroundTransparency = 0.55, BackgroundColor3 = T.ComponentBg}, 0.18)
                CT(te.Lbl, {TextColor3 = T.DimText}, 0.18)
                if te.IconObj then CT(te.IconObj, {ImageColor3 = T.DimText}, 0.18) end
                te.Page.Visible = false
            end
            CT(TabBtn, {BackgroundTransparency = 0.08, BackgroundColor3 = T.TabActive}, 0.18)
            CT(TabLbl, {TextColor3 = T.Accent}, 0.18)
            if tabIconObj then CT(tabIconObj, {ImageColor3 = T.Accent}, 0.18) end
            Page.Visible = true
            Page.CanvasPosition = Vector2.new(0,0)
            Win._activeTab = entry
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        TabBtn.MouseEnter:Connect(function()
            if Win._activeTab ~= entry then
                CT(TabBtn, {BackgroundTransparency = 0.3, BackgroundColor3 = T.TabHover}, 0.14)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Win._activeTab ~= entry then
                CT(TabBtn, {BackgroundTransparency = 0.55, BackgroundColor3 = T.ComponentBg}, 0.14)
            end
        end)

        if #Win._tabs == 1 then Activate() end

        -- =====================================================================
        --  TAB OBJECT
        -- =====================================================================
        local Tab = {}

        function Tab:AddSection(sCfg)
            sCfg = sCfg or {}
            local sTitle = sCfg.Title or ""

            -- Section wrapper
            local SecWrap = Instance.new("Frame")
            SecWrap.Size = UDim2.new(1, -4, 0, 0)
            SecWrap.BackgroundColor3 = T.SectionBg
            SecWrap.BackgroundTransparency = 0.18
            SecWrap.AutomaticSize = Enum.AutomaticSize.Y
            SecWrap.ClipsDescendants = false
            SecWrap.Parent = Page
            Corner(SecWrap, 8)
            local secStroke = Stroke(SecWrap, T.Accent, 1, 0.68)
            RC(SecWrap, "BackgroundColor3", "SectionBg")
            RC(secStroke, "Color", "Accent")

            local SecContent = Instance.new("Frame")
            SecContent.Size = UDim2.new(1, 0, 0, 0)
            SecContent.BackgroundTransparency = 1
            SecContent.AutomaticSize = Enum.AutomaticSize.Y
            SecContent.Parent = SecWrap
            ListLayout(SecContent, Enum.FillDirection.Vertical, nil, 4)
            Padding(SecContent, 6, 8, 7, 7)

            -- Section header
            if sTitle ~= "" then
                local HDR = Instance.new("Frame")
                HDR.Size = UDim2.new(1, 0, 0, 26)
                HDR.BackgroundTransparency = 1
                HDR.LayoutOrder = 0
                HDR.Parent = SecContent

                if sCfg.Icon then
                    local ic = Icon(HDR, sCfg.Icon, 12, 0, 0, T.Accent)
                    if ic then RC(ic, "ImageColor3", "Accent") end
                end
                local secIconW = (sCfg.Icon and ResolveIcon(sCfg.Icon)) and 18 or 0

                local STitle = Instance.new("TextLabel")
                STitle.BackgroundTransparency = 1
                STitle.Text = sTitle:upper()
                STitle.TextColor3 = T.Accent
                STitle.Font = Enum.Font.GothamBold
                STitle.TextSize = 11
                STitle.Position = UDim2.new(0, secIconW, 0, 0)
                STitle.Size = UDim2.new(1, -secIconW, 1, 0)
                STitle.TextXAlignment = Enum.TextXAlignment.Left
                STitle.Parent = HDR
                RC(STitle, "TextColor3", "Accent")

                local SLine = Instance.new("Frame")
                SLine.Size = UDim2.new(1, 0, 0, 1)
                SLine.BackgroundColor3 = T.Accent
                SLine.BackgroundTransparency = 0.72
                SLine.BorderSizePixel = 0
                SLine.LayoutOrder = 1
                SLine.Parent = SecContent
                RC(SLine, "BackgroundColor3", "Accent")
            end

            -- ==================================================================
            --  SECTION OBJECT
            -- ==================================================================
            local Sec = {}
            local _order = 10

            local function NextOrd() _order = _order + 1; return _order end

            -- Base row: outer Frame only, NO UIListLayout
            -- Components add their own content using absolute positioning
            local function BaseRow(h)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, h or 36)
                row.BackgroundColor3 = T.ComponentBg
                row.BackgroundTransparency = 0.38
                row.BorderSizePixel = 0
                row.ClipsDescendants = false
                row.LayoutOrder = NextOrd()
                row.Parent = SecContent
                Corner(row, 5)
                RC(row, "BackgroundColor3", "ComponentBg")
                return row
            end

            -- Lock overlay — center popup, group unlock, fixed/panda validation, key saved
            local function ApplyLock(row, cfg_lock)
                local lockKey       = (type(cfg_lock) == "table") and cfg_lock.LockKey or cfg_lock
                local lockType      = (type(cfg_lock) == "table") and (cfg_lock.LockType or "fixed"):lower() or "fixed"
                local lockServiceID = (type(cfg_lock) == "table") and (cfg_lock.LockServiceID or "") or ""
                local lockGetKeyURL = (type(cfg_lock) == "table") and (cfg_lock.LockGetKeyURL or "") or ""

                if not lockKey then return end

                -- Check if already unlocked this session
                if _unlockedKeys[lockKey] then return end

                -- Check saved key from previous session
                pcall(function()
                    if readfile then
                        local saved = readfile("SystemUI_Lock_" .. cfgName .. "_" .. lockKey .. ".key")
                        if saved and saved ~= "" then
                            -- Re-validate silently or just accept fixed key
                            if lockType ~= "panda" then
                                if saved == lockKey or lockType == "fixed" then
                                    _unlockedKeys[lockKey] = true
                                    return
                                end
                            end
                            -- For panda, store for pre-filling input later
                        end
                    end
                end)
                if _unlockedKeys[lockKey] then return end

                -- Register overlay for group-unlock
                if not _lockOverlays[lockKey] then _lockOverlays[lockKey] = {} end

                -- Build overlay
                local overlay = Instance.new("Frame")
                overlay.Size = UDim2.new(1, 0, 1, 0)
                overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                overlay.BackgroundTransparency = 0.42
                overlay.ZIndex = 10
                overlay.Parent = row
                Corner(overlay, 5)

                table.insert(_lockOverlays[lockKey], overlay)

                -- Lock icon + label centered on overlay
                local lockInner = Instance.new("Frame")
                lockInner.Size = UDim2.new(0, 110, 1, 0)
                lockInner.AnchorPoint = Vector2.new(0.5, 0)
                lockInner.Position = UDim2.new(0.5, 0, 0, 0)
                lockInner.BackgroundTransparency = 1
                lockInner.ZIndex = 11
                lockInner.Parent = overlay

                local lockIc = Icon(lockInner, "lock", 14, 0, 0, T.DimText)
                if lockIc then lockIc.ZIndex = 12 end

                local lockLbl = Instance.new("TextLabel")
                lockLbl.BackgroundTransparency = 1
                lockLbl.Text = "Bloqueado"
                lockLbl.TextColor3 = T.DimText
                lockLbl.Font = Enum.Font.GothamBold
                lockLbl.TextSize = 11
                lockLbl.Position = UDim2.new(0, 20, 0, 0)
                lockLbl.Size = UDim2.new(1, -20, 1, 0)
                lockLbl.TextXAlignment = Enum.TextXAlignment.Left
                lockLbl.ZIndex = 12
                lockLbl.Parent = lockInner

                local keyPopup = nil
                local popOverlay = nil  -- dark bg overlay on Gui

                local function ClosePopup()
                    if popOverlay and popOverlay.Parent then popOverlay:Destroy(); popOverlay = nil end
                    if keyPopup  and keyPopup.Parent  then keyPopup:Destroy();   keyPopup  = nil end
                end

                local clickZone = Instance.new("TextButton")
                clickZone.Size = UDim2.new(1, 0, 1, 0)
                clickZone.BackgroundTransparency = 1
                clickZone.Text = ""
                clickZone.ZIndex = 13
                clickZone.Parent = overlay

                clickZone.MouseButton1Click:Connect(function()
                    if keyPopup and keyPopup.Parent then ClosePopup(); return end

                    -- Semi-transparent dim layer parented to Gui
                    popOverlay = Instance.new("Frame")
                    popOverlay.Size = UDim2.new(1, 0, 1, 0)
                    popOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    popOverlay.BackgroundTransparency = 0.6
                    popOverlay.ZIndex = 95
                    popOverlay.Parent = Gui

                    -- Center popup card parented to Gui
                    keyPopup = Instance.new("Frame")
                    keyPopup.Size = UDim2.new(0, 300, 0, 150)
                    keyPopup.AnchorPoint = Vector2.new(0.5, 0.5)
                    keyPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
                    keyPopup.BackgroundColor3 = T.SecondaryBg
                    keyPopup.BackgroundTransparency = 0.04
                    keyPopup.ZIndex = 96
                    keyPopup.Parent = Gui
                    Corner(keyPopup, 10)
                    Stroke(keyPopup, T.Accent, 1.5, 0.25)

                    -- Popup header
                    local pHeader = Instance.new("Frame")
                    pHeader.Size = UDim2.new(1, 0, 0, 38)
                    pHeader.BackgroundColor3 = T.HeaderBg
                    pHeader.BackgroundTransparency = 0.06
                    pHeader.BorderSizePixel = 0
                    pHeader.ZIndex = 97
                    pHeader.Parent = keyPopup
                    Corner(pHeader, 10)
                    -- square bottom
                    local pHB = Instance.new("Frame")
                    pHB.Size = UDim2.new(1, 0, 0, 10); pHB.Position = UDim2.new(0,0,1,-10)
                    pHB.BackgroundColor3 = T.HeaderBg; pHB.BackgroundTransparency = 0.06
                    pHB.BorderSizePixel = 0; pHB.ZIndex = 97; pHB.Parent = pHeader

                    local pTitle = Instance.new("TextLabel")
                    pTitle.BackgroundTransparency = 1
                    pTitle.Text = lockType == "panda" and "🔑 Verificar Key (Panda)" or "🔑 Inserir Key"
                    pTitle.TextColor3 = T.Accent
                    pTitle.Font = Enum.Font.GothamBold
                    pTitle.TextSize = 13
                    pTitle.Position = UDim2.new(0, 10, 0, 0)
                    pTitle.Size = UDim2.new(1, -50, 1, 0)
                    pTitle.TextXAlignment = Enum.TextXAlignment.Left
                    pTitle.ZIndex = 98
                    pTitle.Parent = pHeader

                    -- Close (×) button in popup
                    local xBtn = Instance.new("TextButton")
                    xBtn.Size = UDim2.new(0, 26, 0, 26)
                    xBtn.Position = UDim2.new(1, -32, 0.5, -13)
                    xBtn.BackgroundColor3 = T.Error
                    xBtn.BackgroundTransparency = 0.4
                    xBtn.Text = "✕"; xBtn.TextColor3 = Color3.fromRGB(255,255,255)
                    xBtn.Font = Enum.Font.GothamBold; xBtn.TextSize = 12
                    xBtn.ZIndex = 98; xBtn.Parent = pHeader; Corner(xBtn, 5)
                    xBtn.MouseButton1Click:Connect(ClosePopup)

                    -- Input
                    local ibg = Instance.new("Frame")
                    ibg.Size = UDim2.new(1, -20, 0, 34)
                    ibg.Position = UDim2.new(0, 10, 0, 48)
                    ibg.BackgroundColor3 = T.ComponentBg
                    ibg.BackgroundTransparency = 0.2
                    ibg.BorderSizePixel = 0
                    ibg.ZIndex = 97
                    ibg.Parent = keyPopup
                    Corner(ibg, 6)
                    local isk = Stroke(ibg, T.Accent, 1, 0.6)

                    local tb = Instance.new("TextBox")
                    tb.Size = UDim2.new(1, -12, 1, 0)
                    tb.Position = UDim2.new(0, 6, 0, 0)
                    tb.BackgroundTransparency = 1
                    tb.Text = ""
                    tb.PlaceholderText = lockType == "panda" and "Sua key Panda..." or "Sua key..."
                    tb.PlaceholderColor3 = T.DimText
                    tb.TextColor3 = T.Text
                    tb.Font = Enum.Font.GothamMedium
                    tb.TextSize = 13
                    tb.ClearTextOnFocus = false
                    tb.ZIndex = 98
                    tb.Parent = ibg
                    Padding(tb, 0, 0, 5, 5)
                    tb.Focused:Connect(function() CT(ibg,{BackgroundTransparency=0.04},0.14); CT(isk,{Transparency=0.15},0.14) end)
                    tb.FocusLost:Connect(function() CT(ibg,{BackgroundTransparency=0.2},0.14); CT(isk,{Transparency=0.6},0.14) end)

                    -- Status label
                    local statusLbl = Instance.new("TextLabel")
                    statusLbl.BackgroundTransparency = 1
                    statusLbl.Text = ""
                    statusLbl.TextColor3 = T.DimText
                    statusLbl.Font = Enum.Font.Gotham
                    statusLbl.TextSize = 11
                    statusLbl.Position = UDim2.new(0, 10, 0, 88)
                    statusLbl.Size = UDim2.new(1, -20, 0, 14)
                    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
                    statusLbl.ZIndex = 97
                    statusLbl.Parent = keyPopup

                    -- Confirm button (shrink to leave room for Get Key btn)
                    local okBtn = Instance.new("TextButton")
                    okBtn.Size  = lockGetKeyURL ~= "" and UDim2.new(0.55, -6, 0, 28) or UDim2.new(1, -20, 0, 28)
                    okBtn.Position = UDim2.new(0, 10, 0, 108)
                    okBtn.BackgroundColor3 = T.Accent
                    okBtn.BackgroundTransparency = 0.2
                    okBtn.Text = lockType == "panda" and "Verificar (Panda)" or "Confirmar"
                    okBtn.TextColor3 = Color3.fromRGB(255,255,255)
                    okBtn.Font = Enum.Font.GothamBold
                    okBtn.TextSize = 12
                    okBtn.ZIndex = 97
                    okBtn.Parent = keyPopup
                    Corner(okBtn, 6)
                    okBtn.MouseEnter:Connect(function() CT(okBtn,{BackgroundTransparency=0},0.12) end)
                    okBtn.MouseLeave:Connect(function() CT(okBtn,{BackgroundTransparency=0.2},0.12) end)

                    -- Get Key button (shown only when lockGetKeyURL is provided)
                    if lockGetKeyURL ~= "" then
                        local gkBtn = Instance.new("TextButton")
                        gkBtn.Size = UDim2.new(0.42, -4, 0, 28)
                        gkBtn.Position = UDim2.new(0.58, -6, 0, 108)
                        gkBtn.BackgroundColor3 = T.ComponentBg
                        gkBtn.BackgroundTransparency = 0.2
                        gkBtn.Text = "Get Key"
                        gkBtn.TextColor3 = T.Accent
                        gkBtn.Font = Enum.Font.GothamBold
                        gkBtn.TextSize = 12
                        gkBtn.ZIndex = 97
                        gkBtn.Parent = keyPopup
                        Corner(gkBtn, 6)
                        Stroke(gkBtn, T.Accent, 1, 0.5)
                        gkBtn.MouseEnter:Connect(function() CT(gkBtn,{BackgroundTransparency=0},0.12) end)
                        gkBtn.MouseLeave:Connect(function() CT(gkBtn,{BackgroundTransparency=0.2},0.12) end)
                        gkBtn.MouseButton1Click:Connect(function()
                            pcall(function() if setclipboard then setclipboard(lockGetKeyURL) end end)
                            statusLbl.Text = "Link copiado!"; statusLbl.TextColor3 = T.Accent
                        end)
                    end

                    -- Close popup when clicking dim overlay
                    local dimBtn = Instance.new("TextButton")
                    dimBtn.Size = UDim2.new(1,0,1,0); dimBtn.BackgroundTransparency=1; dimBtn.Text=""
                    dimBtn.ZIndex = 95; dimBtn.Parent = popOverlay
                    dimBtn.MouseButton1Click:Connect(ClosePopup)

                    -- Validation logic
                    okBtn.MouseButton1Click:Connect(function()
                        local input = tb.Text:gsub("%s+","")
                        if input == "" then
                            statusLbl.Text = "Por favor, insira a key."; statusLbl.TextColor3 = T.Error; return
                        end
                        okBtn.Text = "Verificando..."; statusLbl.Text = ""; statusLbl.TextColor3 = T.DimText

                        task.spawn(function()
                            local valid = false
                            local msg   = "Key inválida."

                            if lockType == "panda" and lockServiceID ~= "" then
                                -- PandAuth — POST para API oficial
                                local function HttpReq(opts)
                                    if syn and syn.request       then return syn.request(opts)
                                    elseif http and http.request then return http.request(opts)
                                    elseif http_request          then return http_request(opts)
                                    elseif request               then return request(opts) end
                                end
                                local function GetHWID()
                                    local ok, h = pcall(gethwid)
                                    if ok and h then return h end
                                    local ok2, h2 = pcall(function()
                                        return tostring(game:GetService("RbxAnalyticsService"):GetClientId()):gsub("-","")
                                    end)
                                    return (ok2 and h2) or tostring(Players.LocalPlayer.UserId)
                                end
                                local ok, res = pcall(HttpReq, {
                                    Url    = "https://new.pandadevelopment.net/api/v1/keys/validate",
                                    Method = "POST",
                                    Headers = { ["Content-Type"] = "application/json" },
                                    Body    = game:GetService("HttpService"):JSONEncode({
                                        ServiceID = lockServiceID,
                                        HWID      = GetHWID(),
                                        Key       = input,
                                    }),
                                })
                                if ok and res then
                                    local ok2, data = pcall(function()
                                        return game:GetService("HttpService"):JSONDecode(res.Body)
                                    end)
                                    if ok2 and type(data) == "table" then
                                        valid = data.Authenticated_Status == "Success"
                                        msg   = valid and "✓ Key Panda válida!" or "✕ Key inválida ou expirada."
                                    else
                                        msg = "✕ Erro ao processar resposta."
                                    end
                                else
                                    msg = "✕ Erro de rede (PandAuth)."
                                end
                            else
                                valid = (input == lockKey)
                                msg   = valid and "✓ Desbloqueado!" or "✕ Key incorreta."
                            end

                            okBtn.Text = lockType == "panda" and "Verificar (Panda)" or "Confirmar"

                            if valid then
                                statusLbl.Text = msg; statusLbl.TextColor3 = T.Success
                                -- Salva key pra não precisar redigitar
                                pcall(function()
                                    if writefile then
                                        writefile("SystemUI_Lock_" .. cfgName .. "_" .. lockKey .. ".key", input)
                                    end
                                end)
                                task.wait(0.5)
                                ClosePopup()
                                _UnlockKey(lockKey)
                            else
                                statusLbl.Text = msg; statusLbl.TextColor3 = T.Error
                                CT(ibg, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.1)
                                task.wait(0.4)
                                CT(ibg, {BackgroundColor3 = T.ComponentBg}, 0.2)
                            end
                        end)
                    end)
                end)
            end

            -- Helper: add icon to row and return next X offset
            local function RowIcon(row, key, baseX, clr)
                if not key then return baseX end
                local ic = Icon(row, key, 14, baseX, 0, clr or T.Accent)
                if ic then RC(ic, "ImageColor3", "Accent") end
                return ic and (baseX + 20) or baseX
            end

            -- Helper: text label inside row at absolute position
            local function RowLabel(row, text, x, rightPad, clrKey, bold)
                local l = Instance.new("TextLabel")
                l.BackgroundTransparency = 1
                l.Text = text
                l.TextColor3 = T[clrKey or "Text"]
                l.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
                l.TextSize = 13
                l.Position = UDim2.new(0, x, 0, 0)
                l.Size = UDim2.new(1, -(x + (rightPad or 10)), 1, 0)
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.TextTruncate = Enum.TextTruncate.AtEnd
                l.Parent = row
                RC(l, "TextColor3", clrKey or "Text")
                return l
            end

            -- ----------------------------------------------------------------
            --  ADD BUTTON
            -- ----------------------------------------------------------------
            function Sec:AddButton(cfg)
                cfg = cfg or {}
                local row = BaseRow(36)
                local xOff = RowIcon(row, cfg.Icon, 10)
                RowLabel(row, cfg.Title or "Button", xOff, 10)
                local sk = Stroke(row, T.Accent, 1, 0.85)
                RC(sk, "Color", "Accent")

                row.MouseEnter:Connect(function()
                    CT(row, {BackgroundTransparency = 0.08, BackgroundColor3 = T.TabHover}, 0.14)
                    CT(sk, {Transparency = 0.3}, 0.14)
                end)
                row.MouseLeave:Connect(function()
                    CT(row, {BackgroundTransparency = 0.38, BackgroundColor3 = T.ComponentBg}, 0.14)
                    CT(sk, {Transparency = 0.85}, 0.14)
                end)
                row.InputBegan:Connect(function(i)
                    if i.UserInputType ~= Enum.UserInputType.MouseButton1
                    and i.UserInputType ~= Enum.UserInputType.Touch then return end
                    CT(row, {BackgroundColor3 = T.AccentDim}, 0.08)
                    task.delay(0.14, function()
                        if row.Parent then CT(row, {BackgroundColor3 = T.TabHover}, 0.1) end
                    end)
                    if cfg.Callback then task.spawn(cfg.Callback) end
                end)

                if cfg.Locked or cfg.LockKey then ApplyLock(row, cfg) end
            end

            -- ----------------------------------------------------------------
            --  ADD TOGGLE
            -- ----------------------------------------------------------------
            function Sec:AddToggle(cfg)
                cfg = cfg or {}
                local key    = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local state  = (savedCfg[key] ~= nil) and savedCfg[key] or (cfg.Default or false)
                cfgData[key] = state

                local row  = BaseRow(36)
                local xOff = RowIcon(row, cfg.Icon, 10)
                local lbl  = RowLabel(row, cfg.Title or "Toggle", xOff, 62)
                local sk   = Stroke(row, T.Accent, 1, 0.85)
                RC(sk, "Color", "Accent")

                -- Track (right side)
                local track = Instance.new("Frame")
                track.Size = UDim2.new(0, 38, 0, 20)
                track.Position = UDim2.new(1, -48, 0.5, -10)
                track.BackgroundColor3 = state and T.ToggleOn or T.ToggleOff
                track.BorderSizePixel = 0
                track.Parent = row
                Corner(track, 10)
                local tsk = Stroke(track, state and T.Accent or T.DimText, 1, 0.35)

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 16, 0, 16)
                knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                knob.BackgroundColor3 = state and T.Accent or T.DimText
                knob.BorderSizePixel = 0
                knob.Parent = track
                Corner(knob, 8)

                local function Toggle()
                    state = not state
                    cfgData[key] = state
                    if state then
                        CT(knob, {Position = UDim2.new(1,-18,0.5,-8), BackgroundColor3 = T.Accent}, 0.22)
                        CT(track, {BackgroundColor3 = T.ToggleOn}, 0.22)
                        CT(tsk, {Color = T.Accent, Transparency = 0.35}, 0.22)
                    else
                        CT(knob, {Position = UDim2.new(0,2,0.5,-8), BackgroundColor3 = T.DimText}, 0.22)
                        CT(track, {BackgroundColor3 = T.ToggleOff}, 0.22)
                        CT(tsk, {Color = T.DimText, Transparency = 0.35}, 0.22)
                    end
                    AutoSave()
                    if cfg.Callback then task.spawn(cfg.Callback, state) end
                end

                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        Toggle()
                    end
                end)
                row.MouseEnter:Connect(function()
                    CT(row, {BackgroundTransparency = 0.08}, 0.14)
                    CT(sk, {Transparency = 0.3}, 0.14)
                end)
                row.MouseLeave:Connect(function()
                    CT(row, {BackgroundTransparency = 0.38}, 0.14)
                    CT(sk, {Transparency = 0.85}, 0.14)
                end)

                if cfg.Callback and state then task.spawn(cfg.Callback, state) end

                if cfg.Locked or cfg.LockKey then ApplyLock(row, cfg) end

                local ctrl = {}
                function ctrl:Set(v)
                    if v ~= state then Toggle() end
                end
                function ctrl:Get() return state end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD SLIDER
            -- ----------------------------------------------------------------
            function Sec:AddSlider(cfg)
                cfg = cfg or {}
                local key    = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local minV   = cfg.Min or 0
                local maxV   = cfg.Max or 100
                local rnd    = cfg.Round or 0
                local val    = (savedCfg[key] ~= nil) and savedCfg[key] or (cfg.Default or minV)
                cfgData[key] = val

                local row = BaseRow(50)

                -- Top row: title + value
                local titleLbl = Instance.new("TextLabel")
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = cfg.Title or "Slider"
                titleLbl.TextColor3 = T.Text
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 13
                titleLbl.Position = UDim2.new(0, 10, 0, 4)
                titleLbl.Size = UDim2.new(0.65, -10, 0, 18)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = row
                RC(titleLbl, "TextColor3", "Text")

                if cfg.Icon then
                    local ic = Icon(row, cfg.Icon, 13, 10, -6, T.Accent)
                    if ic then
                        RC(ic, "ImageColor3", "Accent")
                        titleLbl.Position = UDim2.new(0, 28, 0, 4)
                        titleLbl.Size = UDim2.new(0.65, -28, 0, 18)
                    end
                end

                local valLbl = Instance.new("TextLabel")
                valLbl.BackgroundTransparency = 1
                valLbl.Text = tostring(val)
                valLbl.TextColor3 = T.Accent
                valLbl.Font = Enum.Font.GothamBold
                valLbl.TextSize = 13
                valLbl.Position = UDim2.new(0.65, 0, 0, 4)
                valLbl.Size = UDim2.new(0.35, -10, 0, 18)
                valLbl.TextXAlignment = Enum.TextXAlignment.Right
                valLbl.Parent = row
                RC(valLbl, "TextColor3", "Accent")

                -- Track bg
                local trackBg = Instance.new("Frame")
                trackBg.Size = UDim2.new(1, -20, 0, 6)
                trackBg.Position = UDim2.new(0, 10, 1, -14)
                trackBg.BackgroundColor3 = T.ToggleOff
                trackBg.BorderSizePixel = 0
                Corner(trackBg, 3)
                trackBg.Parent = row
                RC(trackBg, "BackgroundColor3", "ToggleOff")

                local pct = (val - minV) / (maxV - minV)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(pct, 0, 1, 0)
                fill.BackgroundColor3 = T.SliderFill
                fill.BorderSizePixel = 0
                Corner(fill, 3)
                fill.Parent = trackBg
                RC(fill, "BackgroundColor3", "SliderFill")

                local thumb = Instance.new("Frame")
                thumb.Size = UDim2.new(0, 14, 0, 14)
                thumb.Position = UDim2.new(pct, -7, 0.5, -7)
                thumb.BackgroundColor3 = T.Accent
                thumb.BorderSizePixel = 0
                Corner(thumb, 7)
                Stroke(thumb, T.Background, 2, 0)
                thumb.ZIndex = 3
                thumb.Parent = trackBg
                RC(thumb, "BackgroundColor3", "Accent")

                -- Click zone over track
                local hitBtn = Instance.new("TextButton")
                hitBtn.Size = UDim2.new(1, 0, 0, 20)
                hitBtn.Position = UDim2.new(0, 0, 1, -20)
                hitBtn.BackgroundTransparency = 1
                hitBtn.Text = ""
                hitBtn.ZIndex = 5
                hitBtn.Parent = row

                local dragging = false
                local function UpdateSlider(px)
                    local rel = math.clamp((px - trackBg.AbsolutePosition.X) / math.max(1, trackBg.AbsoluteSize.X), 0, 1)
                    local raw = minV + rel * (maxV - minV)
                    if rnd > 0 then raw = math.round(raw / rnd) * rnd
                    else raw = math.round(raw) end
                    raw = math.clamp(raw, minV, maxV)
                    val = raw; cfgData[key] = val
                    local p = (val - minV) / (maxV - minV)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    thumb.Position = UDim2.new(p, -7, 0.5, -7)
                    valLbl.Text = tostring(val)
                    AutoSave()
                    if cfg.Callback then task.spawn(cfg.Callback, val) end
                end

                hitBtn.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateSlider(i.Position.X)
                    end
                end)
                table.insert(conns, UserInputService.InputChanged:Connect(function(i)
                    if not dragging then return end
                    if i.UserInputType == Enum.UserInputType.MouseMovement
                    or i.UserInputType == Enum.UserInputType.Touch then
                        UpdateSlider(i.Position.X)
                    end
                end))
                table.insert(conns, UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end))

                if cfg.Callback then task.spawn(cfg.Callback, val) end

                if cfg.Locked or cfg.LockKey then ApplyLock(row, cfg) end

                local ctrl = {}
                function ctrl:Set(v)
                    val = math.clamp(v, minV, maxV)
                    local p = (val - minV) / (maxV - minV)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    thumb.Position = UDim2.new(p, -7, 0.5, -7)
                    valLbl.Text = tostring(val)
                    if cfg.Callback then task.spawn(cfg.Callback, val) end
                end
                function ctrl:Get() return val end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD TEXTBOX / INPUT
            -- ----------------------------------------------------------------
            local function _TextInput(cfg)
                cfg = cfg or {}
                local row  = BaseRow(36)
                local xOff = RowIcon(row, cfg.Icon, 10)
                RowLabel(row, cfg.Title or "Input", xOff, 135, "Text")

                local tb = Instance.new("TextBox")
                tb.Size = UDim2.new(0, 120, 0, 24)
                tb.Position = UDim2.new(1, -130, 0.5, -12)
                tb.BackgroundColor3 = T.SectionBg
                tb.BackgroundTransparency = 0.2
                tb.Text = cfg.Default or ""
                tb.PlaceholderText = cfg.Placeholder or "..."
                tb.PlaceholderColor3 = T.DimText
                tb.TextColor3 = T.Text
                tb.Font = Enum.Font.GothamMedium
                tb.TextSize = 12
                tb.ClearTextOnFocus = cfg.ClearOnFocus or false
                tb.Parent = row
                Corner(tb, 4); Stroke(tb, T.Accent, 1, 0.6)
                Padding(tb, 0, 0, 5, 5)
                RC(tb, "BackgroundColor3", "SectionBg")
                RC(tb, "TextColor3", "Text")
                RC(tb, "PlaceholderColor3", "DimText")

                tb.Focused:Connect(function()
                    CT(tb, {BackgroundTransparency = 0.05}, 0.14)
                end)
                tb.FocusLost:Connect(function(enter)
                    CT(tb, {BackgroundTransparency = 0.2}, 0.14)
                    if cfg.Callback then task.spawn(cfg.Callback, tb.Text, enter) end
                end)
                local ctrl = {}
                function ctrl:Get() return tb.Text end
                function ctrl:Set(v) tb.Text = v end
                return ctrl
            end

            function Sec:AddTextbox(cfg) return _TextInput(cfg) end
            function Sec:AddInput(cfg)   return _TextInput(cfg) end

            -- ----------------------------------------------------------------
            --  ADD DROPDOWN  (popup parented to Main to avoid ScrollingFrame clip)
            -- ----------------------------------------------------------------
            function Sec:AddDropdown(cfg)
                cfg = cfg or {}
                local key     = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local opts    = cfg.Options or {}
                local sel     = (savedCfg[key] ~= nil) and savedCfg[key] or (cfg.Default or opts[1] or "")
                cfgData[key]  = sel

                local row  = BaseRow(36)
                -- Dropdowns não usam ícone na linha
                RowLabel(row, cfg.Title or "Dropdown", 10, 135, "Text")

                local ddBtn = Instance.new("TextButton")
                ddBtn.Size = UDim2.new(0, 118, 0, 24)
                ddBtn.Position = UDim2.new(1, -128, 0.5, -12)
                ddBtn.BackgroundColor3 = T.SectionBg
                ddBtn.BackgroundTransparency = 0.2
                ddBtn.Text = "  "..sel.."  ▾"
                ddBtn.TextColor3 = T.Text
                ddBtn.Font = Enum.Font.GothamMedium
                ddBtn.TextSize = 11
                ddBtn.TextTruncate = Enum.TextTruncate.AtEnd
                ddBtn.Parent = row
                Corner(ddBtn, 4); Stroke(ddBtn, T.Accent, 1, 0.6)
                RC(ddBtn, "BackgroundColor3", "SectionBg")
                RC(ddBtn, "TextColor3", "Text")

                local open = false
                local dropFrame = nil

                ddBtn.MouseButton1Click:Connect(function()
                    if open then
                        open = false
                        if dropFrame then dropFrame:Destroy(); dropFrame = nil end
                        return
                    end
                    open = true
                    local rp = row.AbsolutePosition - Main.AbsolutePosition
                    dropFrame = Instance.new("Frame")
                    dropFrame.Size = UDim2.new(0, 118, 0, math.min(#opts, 5) * 27 + 8)
                    dropFrame.Position = UDim2.new(0, rp.X + row.AbsoluteSize.X - 128, 0, rp.Y + row.AbsoluteSize.Y + 2)
                    dropFrame.BackgroundColor3 = T.SecondaryBg
                    dropFrame.BackgroundTransparency = 0.04
                    dropFrame.ZIndex = 80
                    dropFrame.Parent = Main
                    Corner(dropFrame, 6); Stroke(dropFrame, T.Accent, 1, 0.28)
                    ListLayout(dropFrame, Enum.FillDirection.Vertical, nil, 2)
                    Padding(dropFrame, 4, 4, 4, 4)

                    for _, opt in ipairs(opts) do
                        local ob = Instance.new("TextButton")
                        ob.Size = UDim2.new(1, 0, 0, 22)
                        ob.BackgroundColor3 = T.ComponentBg
                        ob.BackgroundTransparency = opt == sel and 0.15 or 0.65
                        ob.Text = "  "..opt
                        ob.TextColor3 = opt == sel and T.Accent or T.Text
                        ob.Font = Enum.Font.GothamMedium
                        ob.TextSize = 11
                        ob.TextXAlignment = Enum.TextXAlignment.Left
                        ob.ZIndex = 81
                        Corner(ob, 4)
                        ob.Parent = dropFrame

                        ob.MouseEnter:Connect(function()
                            CT(ob, {BackgroundTransparency = 0.18}, 0.1)
                        end)
                        ob.MouseLeave:Connect(function()
                            CT(ob, {BackgroundTransparency = opt == sel and 0.15 or 0.65}, 0.1)
                        end)
                        ob.MouseButton1Click:Connect(function()
                            sel = opt; cfgData[key] = sel
                            ddBtn.Text = "  "..sel.."  ▾"
                            open = false
                            if dropFrame then dropFrame:Destroy(); dropFrame = nil end
                            AutoSave()
                            if cfg.Callback then task.spawn(cfg.Callback, sel) end
                        end)
                    end
                end)

                local ctrl = {}
                function ctrl:Get() return sel end
                function ctrl:Set(v)
                    sel = v; ddBtn.Text = "  "..sel.."  ▾"
                    if cfg.Callback then task.spawn(cfg.Callback, sel) end
                end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD MULTI-DROPDOWN
            -- ----------------------------------------------------------------
            function Sec:AddMultiDropdown(cfg)
                cfg = cfg or {}
                local key    = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local opts   = cfg.Options or {}
                local sel    = {}
                for _, v in ipairs(cfg.Default or {}) do sel[v] = true end
                cfgData[key] = sel

                local row  = BaseRow(36)
                -- Multi-dropdowns não usam ícone na linha
                RowLabel(row, cfg.Title or "Multi", 10, 135, "Text")

                local function SelTxt()
                    local t = {}
                    for k, v in pairs(sel) do if v then table.insert(t, k) end end
                    return #t > 0 and table.concat(t, ", ") or "None"
                end

                local ddBtn = Instance.new("TextButton")
                ddBtn.Size = UDim2.new(0, 118, 0, 24)
                ddBtn.Position = UDim2.new(1, -128, 0.5, -12)
                ddBtn.BackgroundColor3 = T.SectionBg
                ddBtn.BackgroundTransparency = 0.2
                ddBtn.Text = "  "..SelTxt().."  ▾"
                ddBtn.TextColor3 = T.Text
                ddBtn.Font = Enum.Font.Gotham
                ddBtn.TextSize = 11
                ddBtn.TextTruncate = Enum.TextTruncate.AtEnd
                ddBtn.Parent = row
                Corner(ddBtn, 4); Stroke(ddBtn, T.Accent, 1, 0.6)
                RC(ddBtn, "BackgroundColor3", "SectionBg")
                RC(ddBtn, "TextColor3", "Text")

                local open = false
                local dropFrame = nil

                ddBtn.MouseButton1Click:Connect(function()
                    if open then
                        open = false
                        if dropFrame then dropFrame:Destroy(); dropFrame = nil end
                        return
                    end
                    open = true
                    local rp = row.AbsolutePosition - Main.AbsolutePosition
                    dropFrame = Instance.new("Frame")
                    dropFrame.Size = UDim2.new(0, 118, 0, math.min(#opts, 5) * 27 + 8)
                    dropFrame.Position = UDim2.new(0, rp.X + row.AbsoluteSize.X - 128, 0, rp.Y + row.AbsoluteSize.Y + 2)
                    dropFrame.BackgroundColor3 = T.SecondaryBg
                    dropFrame.BackgroundTransparency = 0.04
                    dropFrame.ZIndex = 80
                    dropFrame.Parent = Main
                    Corner(dropFrame, 6); Stroke(dropFrame, T.Accent, 1, 0.28)
                    ListLayout(dropFrame, Enum.FillDirection.Vertical, nil, 2)
                    Padding(dropFrame, 4, 4, 4, 4)

                    for _, opt in ipairs(opts) do
                        local ob = Instance.new("TextButton")
                        ob.Size = UDim2.new(1, 0, 0, 22)
                        ob.BackgroundColor3 = T.ComponentBg
                        ob.BackgroundTransparency = sel[opt] and 0.15 or 0.65
                        ob.Text = (sel[opt] and "  ✓ " or "    ") .. opt
                        ob.TextColor3 = sel[opt] and T.Accent or T.Text
                        ob.Font = Enum.Font.GothamMedium
                        ob.TextSize = 11
                        ob.TextXAlignment = Enum.TextXAlignment.Left
                        ob.ZIndex = 81
                        Corner(ob, 4)
                        ob.Parent = dropFrame

                        ob.MouseButton1Click:Connect(function()
                            sel[opt] = not sel[opt]
                            ob.Text = (sel[opt] and "  ✓ " or "    ") .. opt
                            ob.TextColor3 = sel[opt] and T.Accent or T.Text
                            CT(ob, {BackgroundTransparency = sel[opt] and 0.15 or 0.65}, 0.12)
                            cfgData[key] = sel
                            ddBtn.Text = "  "..SelTxt().."  ▾"
                            AutoSave()
                            if cfg.Callback then task.spawn(cfg.Callback, sel) end
                        end)
                    end
                end)

                local ctrl = {}
                function ctrl:Get()
                    local t = {}
                    for k, v in pairs(sel) do if v then table.insert(t, k) end end
                    return t
                end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD KEYBIND
            -- ----------------------------------------------------------------
            function Sec:AddKeybind(cfg)
                cfg = cfg or {}
                local key     = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local saved   = savedCfg[key]
                local current = (saved and Enum.KeyCode[saved]) or (cfg.Default or Enum.KeyCode.Unknown)
                cfgData[key]  = current.Name

                local row  = BaseRow(36)
                local xOff = RowIcon(row, cfg.Icon, 10)
                RowLabel(row, cfg.Title or "Keybind", xOff, 100, "Text")

                local listening = false
                local kbBtn = Instance.new("TextButton")
                kbBtn.Size = UDim2.new(0, 82, 0, 24)
                kbBtn.Position = UDim2.new(1, -90, 0.5, -12)
                kbBtn.BackgroundColor3 = T.SectionBg
                kbBtn.BackgroundTransparency = 0.2
                kbBtn.Text = current == Enum.KeyCode.Unknown and "None" or current.Name
                kbBtn.TextColor3 = T.Accent
                kbBtn.Font = Enum.Font.GothamBold
                kbBtn.TextSize = 11
                kbBtn.Parent = row
                Corner(kbBtn, 4); Stroke(kbBtn, T.Accent, 1, 0.5)
                RC(kbBtn, "BackgroundColor3", "SectionBg")
                RC(kbBtn, "TextColor3", "Accent")

                kbBtn.MouseButton1Click:Connect(function()
                    listening = true
                    kbBtn.Text = "..."
                    kbBtn.TextColor3 = T.Warning
                end)
                table.insert(conns, UserInputService.InputBegan:Connect(function(i, gpe)
                    if listening then
                        if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
                        listening = false
                        current = i.KeyCode; cfgData[key] = current.Name
                        kbBtn.Text = current.Name; kbBtn.TextColor3 = T.Accent
                        AutoSave()
                        if cfg.Callback then task.spawn(cfg.Callback, current) end
                    elseif not gpe and cfg.Callback and i.KeyCode == current then
                        task.spawn(cfg.Callback, current)
                    end
                end))

                local ctrl = {}
                function ctrl:Get() return current end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD COLOR PICKER  (popup parented to Main — not clipped)
            -- ----------------------------------------------------------------
            function Sec:AddColorPicker(cfg)
                cfg = cfg or {}
                local key     = cfg.Flag or cfg.Title or tostring(math.random(1e6))
                local current = cfg.Default or Color3.fromRGB(0, 220, 255)

                local row  = BaseRow(36)
                local xOff = RowIcon(row, cfg.Icon, 10)
                RowLabel(row, cfg.Title or "Color", xOff, 55, "Text")

                local preview = Instance.new("TextButton")
                preview.Size = UDim2.new(0, 36, 0, 22)
                preview.Position = UDim2.new(1, -44, 0.5, -11)
                preview.BackgroundColor3 = current
                preview.Text = ""; preview.Parent = row
                Corner(preview, 4); Stroke(preview, T.Accent, 1, 0.4)

                local open = false
                local pFrame = nil
                -- Per-picker drag state
                local isDrag = false
                local dragTrack = nil
                local dragCb = nil

                -- Drag connections (live for picker lifetime)
                local dMov = UserInputService.InputChanged:Connect(function(i)
                    if not isDrag or not dragTrack then return end
                    if i.UserInputType ~= Enum.UserInputType.MouseMovement
                    and i.UserInputType ~= Enum.UserInputType.Touch then return end
                    local rel = math.clamp(
                        (i.Position.X - dragTrack.AbsolutePosition.X) / math.max(1, dragTrack.AbsoluteSize.X),
                        0, 1)
                    if dragCb then dragCb(rel) end
                end)
                local dEnd = UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        isDrag = false; dragTrack = nil; dragCb = nil
                    end
                end)
                table.insert(conns, dMov)
                table.insert(conns, dEnd)

                local function MakeSli(parent, label, yPos, initVal, gradKps, onDrag)
                    local l = Instance.new("TextLabel")
                    l.Size = UDim2.new(0, 12, 0, 14)
                    l.Position = UDim2.new(0, 4, 0, yPos)
                    l.BackgroundTransparency = 1
                    l.Text = label; l.TextColor3 = T.DimText
                    l.Font = Enum.Font.GothamBold; l.TextSize = 10
                    l.ZIndex = 102; l.Parent = parent

                    local tr = Instance.new("Frame")
                    tr.Size = UDim2.new(1, -20, 0, 12)
                    tr.Position = UDim2.new(0, 18, 0, yPos + 1)
                    tr.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    tr.BorderSizePixel = 0; tr.ZIndex = 102
                    Corner(tr, 4); tr.Parent = parent

                    local grad = Instance.new("UIGradient")
                    grad.Color = ColorSequence.new(gradKps)
                    grad.Parent = tr

                    local kn = Instance.new("Frame")
                    kn.Size = UDim2.new(0, 10, 0, 18)
                    kn.Position = UDim2.new(initVal, -5, 0.5, -9)
                    kn.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    kn.BorderSizePixel = 0; kn.ZIndex = 103
                    Corner(kn, 3); Stroke(kn, Color3.fromRGB(80,80,80), 1, 0.5)
                    kn.Parent = tr

                    local hit = Instance.new("TextButton")
                    hit.Size = UDim2.new(1, 0, 1, 0)
                    hit.BackgroundTransparency = 1
                    hit.Text = ""; hit.ZIndex = 104
                    hit.Parent = tr

                    hit.InputBegan:Connect(function(i)
                        if i.UserInputType ~= Enum.UserInputType.MouseButton1
                        and i.UserInputType ~= Enum.UserInputType.Touch then return end
                        isDrag = true; dragTrack = tr
                        dragCb = function(v)
                            kn.Position = UDim2.new(v, -5, 0.5, -9)
                            onDrag(v)
                        end
                        -- immediate
                        local rel = math.clamp(
                            (i.Position.X - tr.AbsolutePosition.X) / math.max(1, tr.AbsoluteSize.X),
                            0, 1)
                        kn.Position = UDim2.new(rel, -5, 0.5, -9)
                        onDrag(rel)
                    end)
                    return {tr=tr, kn=kn, grad=grad, set=function(v)
                        kn.Position = UDim2.new(v,-5,0.5,-9)
                    end}
                end

                preview.MouseButton1Click:Connect(function()
                    if open then
                        open = false
                        if pFrame and pFrame.Parent then pFrame:Destroy(); pFrame = nil end
                        return
                    end
                    open = true
                    local rp = row.AbsolutePosition - Main.AbsolutePosition

                    pFrame = Instance.new("Frame")
                    pFrame.Size = UDim2.new(0, 195, 0, 145)
                    pFrame.Position = UDim2.new(0, rp.X + row.AbsoluteSize.X - 200, 0, rp.Y + row.AbsoluteSize.Y + 4)
                    pFrame.BackgroundColor3 = T.SecondaryBg
                    pFrame.BackgroundTransparency = 0.04
                    pFrame.ZIndex = 90; pFrame.ClipsDescendants = false
                    pFrame.Parent = Main
                    Corner(pFrame, 8); Stroke(pFrame, T.Accent, 1, 0.28)

                    local h, s, v = Color3.toHSV(current)

                    local hueKps = {}
                    for i = 0, 6 do
                        table.insert(hueKps, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6, 1, 1)))
                    end

                    local hSli, sSli, vSli

                    local function Upd()
                        current = Color3.fromHSV(h, s, v)
                        preview.BackgroundColor3 = current
                        -- Update S gradient
                        if sSli then
                            sSli.grad.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                                ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                            })
                        end
                        -- Update V gradient
                        if vSli then
                            vSli.grad.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
                                ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, 1))
                            })
                        end
                        if cfg.Callback then task.spawn(cfg.Callback, current) end
                    end

                    hSli = MakeSli(pFrame, "H", 8, h, hueKps, function(val) h = val; Upd() end)
                    sSli = MakeSli(pFrame, "S", 34, s, {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                    }, function(val) s = val; Upd() end)
                    vSli = MakeSli(pFrame, "V", 60, v, {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, 1))
                    }, function(val) v = val; Upd() end)

                    -- Hex input
                    local hexBg = Instance.new("Frame")
                    hexBg.Size = UDim2.new(1, -8, 0, 22)
                    hexBg.Position = UDim2.new(0, 4, 0, 90)
                    hexBg.BackgroundColor3 = T.ComponentBg
                    hexBg.BackgroundTransparency = 0.3
                    hexBg.ZIndex = 91
                    hexBg.Parent = pFrame; Corner(hexBg, 4)

                    local hexBox = Instance.new("TextBox")
                    hexBox.Size = UDim2.new(1, -8, 1, 0)
                    hexBox.Position = UDim2.new(0, 4, 0, 0)
                    hexBox.BackgroundTransparency = 1
                    hexBox.Text = string.format("%02X%02X%02X",
                        math.round(current.R*255), math.round(current.G*255), math.round(current.B*255))
                    hexBox.TextColor3 = T.Text
                    hexBox.Font = Enum.Font.Code
                    hexBox.TextSize = 12
                    hexBox.PlaceholderText = "HEX"
                    hexBox.ZIndex = 92
                    hexBox.Parent = hexBg

                    hexBox.FocusLost:Connect(function()
                        local hx = hexBox.Text:gsub("#", ""):sub(1,6)
                        if #hx == 6 then
                            local r2 = tonumber(hx:sub(1,2),16)
                            local g2 = tonumber(hx:sub(3,4),16)
                            local b2 = tonumber(hx:sub(5,6),16)
                            if r2 and g2 and b2 then
                                current = Color3.fromRGB(r2, g2, b2)
                                h, s, v = Color3.toHSV(current)
                                hSli.set(h); sSli.set(s); vSli.set(v)
                                preview.BackgroundColor3 = current
                                if cfg.Callback then task.spawn(cfg.Callback, current) end
                            end
                        end
                    end)

                    -- Close
                    local closeBtn = Instance.new("TextButton")
                    closeBtn.Size = UDim2.new(1, -8, 0, 20)
                    closeBtn.Position = UDim2.new(0, 4, 0, 118)
                    closeBtn.BackgroundColor3 = T.TabHover
                    closeBtn.BackgroundTransparency = 0.3
                    closeBtn.Text = "Close"
                    closeBtn.TextColor3 = T.DimText
                    closeBtn.Font = Enum.Font.GothamMedium
                    closeBtn.TextSize = 11
                    closeBtn.ZIndex = 91
                    closeBtn.Parent = pFrame; Corner(closeBtn, 4)
                    closeBtn.MouseButton1Click:Connect(function()
                        open = false
                        if pFrame and pFrame.Parent then pFrame:Destroy(); pFrame = nil end
                    end)
                end)

                local ctrl = {}
                function ctrl:Get() return current end
                function ctrl:Set(c) current = c; preview.BackgroundColor3 = c end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD LABEL
            -- ----------------------------------------------------------------
            function Sec:AddLabel(cfg)
                cfg = cfg or {}
                local row = BaseRow(28)
                local l = Instance.new("TextLabel")
                l.BackgroundTransparency = 1
                l.Text = cfg.Title or cfg.Text or ""
                l.TextColor3 = T.DimText
                l.Font = Enum.Font.Gotham
                l.TextSize = 12
                l.Position = UDim2.new(0, 10, 0, 0)
                l.Size = UDim2.new(1, -20, 1, 0)
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.TextWrapped = true
                l.Parent = row
                RC(l, "TextColor3", "DimText")
                local ctrl = {}
                function ctrl:Set(v) l.Text = v end
                function ctrl:Get() return l.Text end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD PARAGRAPH
            -- ----------------------------------------------------------------
            function Sec:AddParagraph(cfg)
                cfg = cfg or {}
                local h = cfg.Height or 65
                local row = BaseRow(h)
                if cfg.Title then
                    local t = Instance.new("TextLabel")
                    t.BackgroundTransparency = 1
                    t.Text = cfg.Title
                    t.TextColor3 = T.Text
                    t.Font = Enum.Font.GothamBold
                    t.TextSize = 13
                    t.Position = UDim2.new(0, 10, 0, 5)
                    t.Size = UDim2.new(1, -20, 0, 18)
                    t.TextXAlignment = Enum.TextXAlignment.Left
                    t.Parent = row
                    RC(t, "TextColor3", "Text")
                end
                local body = Instance.new("TextLabel")
                body.BackgroundTransparency = 1
                body.Text = cfg.Content or cfg.Text or ""
                body.TextColor3 = T.DimText
                body.Font = Enum.Font.Gotham
                body.TextSize = 11
                body.Position = UDim2.new(0, 10, 0, cfg.Title and 24 or 5)
                body.Size = UDim2.new(1, -20, 0, h - (cfg.Title and 32 or 10))
                body.TextXAlignment = Enum.TextXAlignment.Left
                body.TextWrapped = true
                body.Parent = row
                RC(body, "TextColor3", "DimText")
            end

            -- ----------------------------------------------------------------
            --  ADD SEPARATOR
            -- ----------------------------------------------------------------
            function Sec:AddSeparator()
                local sep = Instance.new("Frame")
                sep.Size = UDim2.new(1, 0, 0, 1)
                sep.BackgroundColor3 = T.SeparatorClr
                sep.BackgroundTransparency = 0.55
                sep.BorderSizePixel = 0
                sep.LayoutOrder = NextOrd()
                sep.Parent = SecContent
                RC(sep, "BackgroundColor3", "SeparatorClr")
            end

            -- ----------------------------------------------------------------
            --  ADD PROGRESS BAR
            -- ----------------------------------------------------------------
            function Sec:AddProgressBar(cfg)
                cfg = cfg or {}
                local val = cfg.Default or 0
                local row = BaseRow(46)

                local tl = Instance.new("TextLabel")
                tl.BackgroundTransparency = 1
                tl.Text = cfg.Title or "Progress"
                tl.TextColor3 = T.Text
                tl.Font = Enum.Font.GothamMedium
                tl.TextSize = 12
                tl.Position = UDim2.new(0, 10, 0, 4)
                tl.Size = UDim2.new(0.65, -10, 0, 18)
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = row; RC(tl, "TextColor3", "Text")

                local vl = Instance.new("TextLabel")
                vl.BackgroundTransparency = 1
                vl.Text = tostring(val).."%"
                vl.TextColor3 = T.Accent
                vl.Font = Enum.Font.GothamBold
                vl.TextSize = 12
                vl.Position = UDim2.new(0.65, 0, 0, 4)
                vl.Size = UDim2.new(0.35, -10, 0, 18)
                vl.TextXAlignment = Enum.TextXAlignment.Right
                vl.Parent = row; RC(vl, "TextColor3", "Accent")

                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(1, -20, 0, 6)
                bg.Position = UDim2.new(0, 10, 1, -12)
                bg.BackgroundColor3 = T.ToggleOff
                bg.BorderSizePixel = 0; Corner(bg, 3)
                bg.Parent = row; RC(bg, "BackgroundColor3", "ToggleOff")

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(val/100, 0, 1, 0)
                fill.BackgroundColor3 = T.SliderFill
                fill.BorderSizePixel = 0; Corner(fill, 3)
                fill.Parent = bg; RC(fill, "BackgroundColor3", "SliderFill")

                local ctrl = {}
                function ctrl:Set(v)
                    v = math.clamp(v, 0, 100)
                    val = v; CT(fill, {Size = UDim2.new(v/100, 0, 1, 0)}, 0.28)
                    vl.Text = tostring(v).."%"
                end
                function ctrl:Get() return val end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD SEARCH BOX
            -- ----------------------------------------------------------------
            function Sec:AddSearchBox(cfg)
                cfg = cfg or {}
                local row = BaseRow(36)
                local ic = Icon(row, "search", 13, 10, 0, T.DimText)
                if ic then RC(ic, "ImageColor3", "DimText") end
                local tb = Instance.new("TextBox")
                tb.Size = UDim2.new(1, -38, 0.8, 0)
                tb.Position = UDim2.new(0, 30, 0.1, 0)
                tb.BackgroundTransparency = 1
                tb.Text = ""
                tb.PlaceholderText = cfg.Placeholder or "Search..."
                tb.PlaceholderColor3 = T.DimText
                tb.TextColor3 = T.Text
                tb.Font = Enum.Font.GothamMedium
                tb.TextSize = 12
                tb.TextXAlignment = Enum.TextXAlignment.Left
                tb.ClearTextOnFocus = false
                tb.Parent = row
                RC(tb, "TextColor3", "Text")
                RC(tb, "PlaceholderColor3", "DimText")
                tb:GetPropertyChangedSignal("Text"):Connect(function()
                    if cfg.Callback then task.spawn(cfg.Callback, tb.Text) end
                end)
                local ctrl = {}
                function ctrl:Get() return tb.Text end
                return ctrl
            end

            -- ----------------------------------------------------------------
            --  ADD CODE BLOCK
            -- ----------------------------------------------------------------
            function Sec:AddCodeBlock(cfg)
                cfg = cfg or {}
                local h = cfg.Height or 75
                local row = BaseRow(h)
                row.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
                row.BackgroundTransparency = 0.1
                local l = Instance.new("TextLabel")
                l.BackgroundTransparency = 1
                l.Text = cfg.Code or cfg.Text or ""
                l.TextColor3 = Color3.fromRGB(160, 255, 160)
                l.Font = Enum.Font.Code
                l.TextSize = 11
                l.Position = UDim2.new(0, 10, 0, 5)
                l.Size = UDim2.new(1, -20, 1, -10)
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.TextYAlignment = Enum.TextYAlignment.Top
                l.TextWrapped = true
                l.Parent = row
            end

            -- ----------------------------------------------------------------
            --  ADD LIST
            -- ----------------------------------------------------------------
            function Sec:AddList(cfg)
                cfg = cfg or {}
                for _, item in ipairs(cfg.Items or {}) do
                    local row = BaseRow(28)
                    local dot = Instance.new("Frame")
                    dot.Size = UDim2.new(0, 4, 0, 4)
                    dot.Position = UDim2.new(0, 10, 0.5, -2)
                    dot.BackgroundColor3 = T.Accent
                    dot.BorderSizePixel = 0
                    dot.Parent = row; Corner(dot, 2); RC(dot, "BackgroundColor3", "Accent")
                    RowLabel(row, tostring(item), 20, 10, "Text")
                end
            end

            -- ----------------------------------------------------------------
            --  ADD IMAGE
            -- ----------------------------------------------------------------
            function Sec:AddImage(cfg)
                cfg = cfg or {}
                local row = BaseRow(cfg.Height or 100)
                row.BackgroundTransparency = 1
                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(1, 0, 1, 0)
                img.BackgroundTransparency = 1
                img.Image = cfg.Image or ""
                img.ScaleType = cfg.ScaleType or Enum.ScaleType.Fit
                img.Parent = row; Corner(img, 6)
            end

            -- ----------------------------------------------------------------
            --  ADD PLAYER LIST
            -- ----------------------------------------------------------------
            function Sec:AddPlayerList(cfg)
                cfg = cfg or {}

                local function Build()
                    for _, c in ipairs(SecContent:GetChildren()) do
                        if c:IsA("Frame") and c:GetAttribute("_plr") then c:Destroy() end
                    end
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if not cfg.IncludeSelf and plr == Player then continue end
                        local row = Instance.new("Frame")
                        row.Size = UDim2.new(1, 0, 0, 32)
                        row.BackgroundColor3 = T.ComponentBg
                        row.BackgroundTransparency = 0.38
                        row.BorderSizePixel = 0
                        row.LayoutOrder = NextOrd()
                        row:SetAttribute("_plr", true)
                        row.Parent = SecContent
                        Corner(row, 5)
                        RC(row, "BackgroundColor3", "ComponentBg")

                        local av = Instance.new("ImageLabel")
                        av.Size = UDim2.new(0, 22, 0, 22)
                        av.Position = UDim2.new(0, 8, 0.5, -11)
                        av.BackgroundColor3 = T.SectionBg
                        av.BorderSizePixel = 0
                        av.Parent = row; Corner(av, 11)
                        pcall(function()
                            av.Image = Players:GetUserThumbnailAsync(
                                plr.UserId,
                                Enum.ThumbnailType.HeadShot,
                                Enum.ThumbnailSize.Size48x48)
                        end)

                        local nameL = Instance.new("TextLabel")
                        nameL.BackgroundTransparency = 1
                        nameL.Text = plr.Name
                        nameL.TextColor3 = T.Text
                        nameL.Font = Enum.Font.GothamMedium
                        nameL.TextSize = 12
                        nameL.Position = UDim2.new(0, 36, 0, 0)
                        nameL.Size = UDim2.new(1, -90, 1, 0)
                        nameL.TextXAlignment = Enum.TextXAlignment.Left
                        nameL.Parent = row
                        RC(nameL, "TextColor3", "Text")

                        local idL = Instance.new("TextLabel")
                        idL.BackgroundTransparency = 1
                        idL.Text = tostring(plr.UserId)
                        idL.TextColor3 = T.DimText
                        idL.Font = Enum.Font.Gotham
                        idL.TextSize = 10
                        idL.Position = UDim2.new(1, -85, 0, 0)
                        idL.Size = UDim2.new(0, 80, 1, 0)
                        idL.TextXAlignment = Enum.TextXAlignment.Right
                        idL.Parent = row
                        RC(idL, "TextColor3", "DimText")

                        row.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1
                            or i.UserInputType == Enum.UserInputType.Touch then
                                CT(row, {BackgroundColor3 = T.TabActive}, 0.12)
                                task.delay(0.2, function()
                                    if row.Parent then CT(row, {BackgroundColor3 = T.ComponentBg}, 0.12) end
                                end)
                                if cfg.Callback then task.spawn(cfg.Callback, plr) end
                            end
                        end)
                    end
                end

                Build()
                Players.PlayerAdded:Connect(Build)
                Players.PlayerRemoving:Connect(function() task.wait(0.05); Build() end)

                -- Refresh button
                local refRow = Instance.new("Frame")
                refRow.Size = UDim2.new(1, 0, 0, 30)
                refRow.BackgroundColor3 = T.ComponentBg
                refRow.BackgroundTransparency = 0.38
                refRow.BorderSizePixel = 0
                refRow.LayoutOrder = NextOrd()
                refRow.Parent = SecContent
                Corner(refRow, 5)
                RC(refRow, "BackgroundColor3", "ComponentBg")

                -- Icon at left
                local refIc = Icon(refRow, "rotatecw", 13, 10, 0, T.Accent)
                if refIc then RC(refIc, "ImageColor3", "Accent") end

                -- Text label beside icon
                local refLbl = Instance.new("TextLabel")
                refLbl.BackgroundTransparency = 1
                refLbl.Text = "Refresh"
                refLbl.TextColor3 = T.Accent
                refLbl.Font = Enum.Font.GothamBold
                refLbl.TextSize = 12
                refLbl.Position = UDim2.new(0, 30, 0, 0)
                refLbl.Size = UDim2.new(1, -30, 1, 0)
                refLbl.TextXAlignment = Enum.TextXAlignment.Left
                refLbl.Parent = refRow
                RC(refLbl, "TextColor3", "Accent")

                -- Invisible click zone over full row
                local refBtn = Instance.new("TextButton")
                refBtn.Size = UDim2.new(1, 0, 1, 0)
                refBtn.BackgroundTransparency = 1
                refBtn.Text = ""
                refBtn.ZIndex = 5
                refBtn.Parent = refRow
                refBtn.MouseButton1Click:Connect(Build)
            end

            -- ----------------------------------------------------------------
            --  ADD CONFIG SYSTEM
            -- ----------------------------------------------------------------
            function Sec:AddConfigSystem(cfg)
                cfg = cfg or {}
                Sec:AddButton({
                    Title = cfg.SaveTitle or "Save Config", Icon = "save",
                    Callback = function()
                        SaveConfig(cfgName, cfgData)
                        SendNotif({Title="Config Saved",Desc="Configuration saved.",Type="success",Duration=2}, T)
                    end
                })
                Sec:AddButton({
                    Title = cfg.LoadTitle or "Load Config", Icon = "download",
                    Callback = function()
                        local d = LoadConfig(cfgName)
                        for k, v in pairs(d) do cfgData[k] = v end
                        SendNotif({Title="Config Loaded",Desc="Configuration restored.",Type="info",Duration=2}, T)
                        if cfg.OnLoad then task.spawn(cfg.OnLoad, d) end
                    end
                })
                if cfg.ShowReset then
                    Sec:AddButton({
                        Title = "Reset Config", Icon = "trash-2",
                        Callback = function()
                            for k in pairs(cfgData) do cfgData[k] = nil end
                            SendNotif({Title="Config Reset",Desc="All settings cleared.",Type="warning",Duration=2}, T)
                        end
                    })
                end
            end

            return Sec
        end -- AddSection

        -- Convenience shorthands on Tab
        function Tab:AddButton(cfg)
            return self:AddSection({}):AddButton(cfg)
        end
        function Tab:AddToggle(cfg)
            return self:AddSection({}):AddToggle(cfg)
        end
        function Tab:AddSlider(cfg)
            return self:AddSection({}):AddSlider(cfg)
        end

        return Tab
    end -- AddTab

    return Win
end -- CreateWindow

return SystemUI
