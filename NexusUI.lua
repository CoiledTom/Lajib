--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝

    NexusUI v1.0 — Holographic Manhwa UI Library
    Inspired by Solo Leveling / System Panels
    Author: CoiledTom
    
    USAGE:
    local Nexus = loadstring(game:HttpGet("..."))()
    
    local Window = Nexus:CreateWindow({
        Title = "SYSTEM",
        SubTitle = "Hunter Status",
        Logo = "rbxassetid://...",
        Theme = "Holographic",  -- "Holographic" | "Crimson" | "Void"
        Size = UDim2.new(0, 580, 0, 420),
        Blur = true,
        Sounds = true,
        ToggleKey = Enum.KeyCode.RightShift,
    })
    
    local Tab = Window:AddTab({ Title = "Status", Icon = "rbxassetid://..." })
    local Section = Tab:AddSection({ Title = "Hunter Info" })
    
    Section:AddButton({ Title = "Confirm", Callback = function() end })
    Section:AddToggle({ Title = "Auto Farm", Default = false, Callback = function(v) end })
    Section:AddSlider({ Title = "Speed", Min = 0, Max = 100, Default = 16, Callback = function(v) end })
--]]

-- ============================================================
--  NEXUS UI — CORE
-- ============================================================

local NexusUI = {}
NexusUI.__index = NexusUI

-- ── Services ──────────────────────────────────────────────
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local SoundService   = game:GetService("SoundService")
local CoreGui        = game:GetService("CoreGui")

local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()
local Camera         = workspace.CurrentCamera

-- ── Tween Helper ──────────────────────────────────────────
local function Tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t or 0.25, style, dir), props):Play()
end

-- ── Color3 Shortcuts ──────────────────────────────────────
local function C3(r, g, b)
    return Color3.fromRGB(r, g, b)
end

local function C3H(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber("0x"..hex:sub(1,2)),
        tonumber("0x"..hex:sub(3,4)),
        tonumber("0x"..hex:sub(5,6))
    )
end

-- ── Themes ────────────────────────────────────────────────
local Themes = {
    Holographic = {
        Background     = C3(4,  8,  20),
        Surface        = C3(8,  16, 38),
        SurfaceAlt     = C3(12, 22, 50),
        Border         = C3(0,  180, 255),
        BorderGlow     = C3(0,  220, 255),
        Accent         = C3(0,  200, 255),
        AccentSecond   = C3(80, 230, 255),
        AccentDim      = C3(0,  80,  120),
        Text           = C3(200, 240, 255),
        TextDim        = C3(100, 160, 200),
        TextMuted      = C3(60,  100, 140),
        Success        = C3(0,   255, 180),
        Warning        = C3(255, 200, 0),
        Error          = C3(255, 60,  80),
        TabActive      = C3(0,   200, 255),
        TabInactive    = C3(30,  50,  80),
        ToggleOn       = C3(0,   200, 255),
        ToggleOff      = C3(25,  40,  65),
        SliderFill     = C3(0,   200, 255),
        SliderBg       = C3(15,  30,  55),
        DropdownBg     = C3(6,   14,  30),
        NotifBg        = C3(5,   12,  28),
        NotifBorder    = C3(0,   200, 255),
        ScanlineColor  = C3(0,   150, 200),
        GridColor      = C3(0,   60,  100),
    },
    Crimson = {
        Background     = C3(18, 4,  8),
        Surface        = C3(32, 8,  14),
        SurfaceAlt     = C3(42, 12, 20),
        Border         = C3(255, 50, 80),
        BorderGlow     = C3(255, 80, 100),
        Accent         = C3(255, 50, 80),
        AccentSecond   = C3(255, 120, 140),
        AccentDim      = C3(120, 20, 35),
        Text           = C3(255, 220, 225),
        TextDim        = C3(200, 140, 150),
        TextMuted      = C3(140, 80,  95),
        Success        = C3(0,   255, 150),
        Warning        = C3(255, 200, 0),
        Error          = C3(255, 60,  80),
        TabActive      = C3(255, 50,  80),
        TabInactive    = C3(60,  15,  25),
        ToggleOn       = C3(255, 50,  80),
        ToggleOff      = C3(55,  15,  25),
        SliderFill     = C3(255, 50,  80),
        SliderBg       = C3(45,  12,  20),
        DropdownBg     = C3(20,  5,   10),
        NotifBg        = C3(16,  4,   8),
        NotifBorder    = C3(255, 50,  80),
        ScanlineColor  = C3(200, 40,  60),
        GridColor      = C3(100, 20,  35),
    },
    Void = {
        Background     = C3(6,  4,  16),
        Surface        = C3(14, 10, 32),
        SurfaceAlt     = C3(20, 14, 44),
        Border         = C3(140, 80, 255),
        BorderGlow     = C3(160, 100, 255),
        Accent         = C3(140, 80,  255),
        AccentSecond   = C3(180, 140, 255),
        AccentDim      = C3(60,  30,  120),
        Text           = C3(220, 210, 255),
        TextDim        = C3(150, 130, 210),
        TextMuted      = C3(90,  75,  140),
        Success        = C3(80,  255, 180),
        Warning        = C3(255, 200, 0),
        Error          = C3(255, 70,  90),
        TabActive      = C3(140, 80,  255),
        TabInactive    = C3(40,  25,  80),
        ToggleOn       = C3(140, 80,  255),
        ToggleOff      = C3(35,  22,  70),
        SliderFill     = C3(140, 80,  255),
        SliderBg       = C3(28,  18,  58),
        DropdownBg     = C3(8,   5,   20),
        NotifBg        = C3(6,   4,   16),
        NotifBorder    = C3(140, 80,  255),
        ScanlineColor  = C3(100, 60,  200),
        GridColor      = C3(50,  30,  100),
    },
}

-- ── Sound IDs (Roblox free assets) ────────────────────────
local Sounds = {
    Click   = 6895079185,
    Toggle  = 7660533840,
    Hover   = 9119713951,
    Open    = 4590662766,
    Close   = 4590663291,
    Notif   = 9120404895,
    Tab     = 9116738440,
    Slider  = 9119717749,
    Typed   = 0,
}

-- ── Icon Sprites (ImageLabel ImageRectOffset/Size) ─────────
-- Uses a single spritesheet approach similar to WindUI.
-- Replace with your own spritesheet asset ID.
local ICON_SHEET = "rbxassetid://11293981586" -- Lucide-style Roblox spritesheet

local Icons = {
    Home      = { X=0,   Y=0   },
    Settings  = { X=100, Y=0   },
    Info      = { X=200, Y=0   },
    Star      = { X=300, Y=0   },
    Shield    = { X=0,   Y=100 },
    Sword     = { X=100, Y=100 },
    Globe     = { X=200, Y=100 },
    Bell      = { X=300, Y=100 },
    Eye       = { X=0,   Y=200 },
    Lock      = { X=100, Y=200 },
    User      = { X=200, Y=200 },
    Search    = { X=300, Y=200 },
    Check     = { X=0,   Y=300 },
    X         = { X=100, Y=300 },
    Warning   = { X=200, Y=300 },
    ChevDown  = { X=300, Y=300 },
    ChevUp    = { X=0,   Y=400 },
    ChevRight = { X=100, Y=400 },
    Palette   = { X=200, Y=400 },
    Zap       = { X=300, Y=400 },
}

-- ── Utility: Create Instance Helper ───────────────────────
local function New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

-- ── Utility: Make Draggable ───────────────────────────────
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
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
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ── Utility: Stroke (UIStroke wrapper) ────────────────────
local function AddStroke(parent, color, thickness, transparency)
    return New("UIStroke", {
        Color        = color,
        Thickness    = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent       = parent,
    })
end

-- ── Utility: Corner ───────────────────────────────────────
local function AddCorner(parent, radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

-- ── Utility: Gradient ─────────────────────────────────────
local function AddGradient(parent, color0, color1, rotation)
    return New("UIGradient", {
        Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, color0), ColorSequenceKeypoint.new(1, color1) }),
        Rotation = rotation or 90,
        Parent = parent,
    })
end

-- ── Utility: Padding ──────────────────────────────────────
local function AddPadding(parent, t, b, l, r)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 4),
        PaddingBottom = UDim.new(0, b or 4),
        PaddingLeft   = UDim.new(0, l or 8),
        PaddingRight  = UDim.new(0, r or 8),
        Parent        = parent,
    })
end

-- ── Utility: PlaySound ────────────────────────────────────
local function PlaySound(id, vol)
    if id == 0 then return end
    local s = Instance.new("Sound")
    s.SoundId    = "rbxassetid://"..tostring(id)
    s.Volume     = vol or 0.4
    s.RollOffMaxDistance = 10
    s.Parent     = SoundService
    s:Play()
    game:GetService("Debris"):AddItem(s, 3)
end

-- ── Utility: Glow Frame ───────────────────────────────────
local function AddGlowEffect(parent, color, size)
    -- Simulates outer glow via a slightly larger, transparent frame behind
    local glow = New("Frame", {
        Size              = UDim2.new(1, size or 6, 1, size or 6),
        Position          = UDim2.new(0, -(size or 3), 0, -(size or 3)),
        BackgroundColor3  = color,
        BackgroundTransparency = 0.85,
        ZIndex            = parent.ZIndex - 1,
        Parent            = parent.Parent,
    })
    AddCorner(glow, 10)
    return glow
end

-- ── Utility: Scanline texture ─────────────────────────────
local function AddScanlines(parent, color)
    local scan = New("Frame", {
        Size                  = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ZIndex                 = parent.ZIndex + 2,
        Parent                 = parent,
    })
    -- Repeating thin lines via ImageLabel (use a scanline texture)
    New("ImageLabel", {
        Size                  = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Image                 = "rbxassetid://8992230677", -- subtle scanline texture
        ImageTransparency     = 0.94,
        ImageColor3           = color,
        ScaleType             = Enum.ScaleType.Tile,
        TileSize              = UDim2.new(0, 4, 0, 4),
        ZIndex                = parent.ZIndex + 2,
        Parent                = scan,
    })
    return scan
end

-- ── Notification System (global, created once) ────────────
local NotifContainer
local function EnsureNotifContainer(theme)
    if NotifContainer and NotifContainer.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "NexusUI_Notif"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    NotifContainer = New("Frame", {
        Size                  = UDim2.new(0, 320, 1, -20),
        Position              = UDim2.new(1, -330, 0, 10),
        BackgroundTransparency = 1,
        Parent                = sg,
    })
    New("UIListLayout", {
        SortOrder        = Enum.SortOrder.LayoutOrder,
        FillDirection    = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding          = UDim.new(0, 8),
        Parent           = NotifContainer,
    })
end

-- ============================================================
--  WINDOW CLASS
-- ============================================================

local Window = {}
Window.__index = Window

function NexusUI:CreateWindow(cfg)
    cfg = cfg or {}
    local self       = setmetatable({}, Window)
    self.Title       = cfg.Title    or "NEXUS SYSTEM"
    self.SubTitle    = cfg.SubTitle or "v1.0"
    self.Logo        = cfg.Logo
    self.ThemeName   = cfg.Theme    or "Holographic"
    self.Theme       = Themes[self.ThemeName] or Themes.Holographic
    self.SoundsOn    = cfg.Sounds   ~= false
    self.BlurOn      = cfg.Blur     ~= false
    self.ToggleKey   = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.WinSize     = cfg.Size     or UDim2.new(0, 600, 0, 440)
    self.Visible     = true
    self.Tabs        = {}
    self.ActiveTab   = nil
    self.T           = self.Theme

    EnsureNotifContainer(self.Theme)

    -- ── ScreenGui ──────────────────────────────────────────
    local gui = Instance.new("ScreenGui")
    gui.Name          = "NexusUI_"..self.Title
    gui.ResetOnSpawn  = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder  = 100
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.Gui = gui

    -- ── Blur Effect ───────────────────────────────────────
    if self.BlurOn then
        local blur = Instance.new("BlurEffect")
        blur.Size   = 0
        blur.Parent = Camera
        self.BlurEffect = blur
        Tween(blur, { Size = 6 }, 0.4)
    end

    -- ── Background Grid (holographic grid lines) ──────────
    local bgFrame = New("Frame", {
        Size                  = UDim2.new(1,0,1,0),
        BackgroundColor3      = C3(0,0,0),
        BackgroundTransparency = 0.5,
        Parent                = gui,
    })
    -- subtle grid via tiled ImageLabel
    New("ImageLabel", {
        Size                  = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Image                 = "rbxassetid://8992230677",
        ImageColor3           = self.T.GridColor,
        ImageTransparency     = 0.96,
        ScaleType             = Enum.ScaleType.Tile,
        TileSize              = UDim2.new(0, 40, 0, 40),
        Parent                = bgFrame,
    })
    self.BgFrame = bgFrame

    -- ── Main Window Frame ─────────────────────────────────
    local win = New("Frame", {
        Size                  = UDim2.new(0, 0, 0, 0),  -- starts at 0 for open anim
        Position              = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint           = Vector2.new(0.5, 0.5),
        BackgroundColor3      = self.T.Background,
        BackgroundTransparency = 0.08,
        ClipsDescendants      = true,
        Parent                = gui,
    })
    AddCorner(win, 12)
    AddStroke(win, self.T.Border, 1.5, 0.1)
    self.Win = win

    -- Inner glow frame
    local innerGlow = New("Frame", {
        Size                  = UDim2.new(1, 16, 1, 16),
        Position              = UDim2.new(0, -8, 0, -8),
        BackgroundColor3      = self.T.AccentDim,
        BackgroundTransparency = 0.7,
        ZIndex                = win.ZIndex - 1,
        Parent                = win.Parent,
    })
    AddCorner(innerGlow, 16)
    self.InnerGlow = innerGlow

    -- Scanlines overlay
    AddScanlines(win, self.T.ScanlineColor)

    -- ── Title Bar ─────────────────────────────────────────
    local titleBar = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = self.T.Surface,
        BackgroundTransparency = 0.1,
        ZIndex           = win.ZIndex + 1,
        Parent           = win,
    })
    AddCorner(titleBar, 12)
    -- bottom corners squared
    New("Frame", {
        Size             = UDim2.new(1, 0, 0.5, 0),
        Position         = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = self.T.Surface,
        BackgroundTransparency = 0.1,
        ZIndex           = titleBar.ZIndex,
        Parent           = titleBar,
    })
    -- Gradient accent line at bottom of title bar
    local accentLine = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = self.T.Accent,
        ZIndex           = titleBar.ZIndex + 1,
        Parent           = titleBar,
    })
    AddGradient(accentLine, self.T.AccentDim, self.T.Accent, 0)

    -- Logo / Icon
    local logoX = 14
    if self.Logo then
        New("ImageLabel", {
            Size                  = UDim2.new(0,28,0,28),
            Position              = UDim2.new(0, logoX, 0.5, -14),
            BackgroundTransparency = 1,
            Image                 = self.Logo,
            ImageColor3           = self.T.Accent,
            ZIndex                = titleBar.ZIndex + 2,
            Parent                = titleBar,
        })
        logoX = logoX + 36
    else
        -- Hex symbol as decoration
        local hexIcon = New("ImageLabel", {
            Size                  = UDim2.new(0, 28, 0, 28),
            Position              = UDim2.new(0, logoX, 0.5, -14),
            BackgroundTransparency = 1,
            Image                 = "rbxassetid://11585707530", -- hexagon icon
            ImageColor3           = self.T.Accent,
            ZIndex                = titleBar.ZIndex + 2,
            Parent                = titleBar,
        })
        logoX = logoX + 36
    end

    -- Title text
    New("TextLabel", {
        Size             = UDim2.new(0, 250, 1, 0),
        Position         = UDim2.new(0, logoX, 0, 0),
        BackgroundTransparency = 1,
        Text             = self.Title,
        TextColor3       = self.T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 15,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = titleBar.ZIndex + 2,
        Parent           = titleBar,
    })
    New("TextLabel", {
        Size             = UDim2.new(0, 250, 1, 0),
        Position         = UDim2.new(0, logoX, 0, 16),
        BackgroundTransparency = 1,
        Text             = self.SubTitle,
        TextColor3       = self.T.TextDim,
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = titleBar.ZIndex + 2,
        Parent           = titleBar,
    })

    -- Status indicator (animated blinking dot)
    local statusDot = New("Frame", {
        Size             = UDim2.new(0, 7, 0, 7),
        Position         = UDim2.new(1, -55, 0.5, -3.5),
        BackgroundColor3 = self.T.Success,
        ZIndex           = titleBar.ZIndex + 2,
        Parent           = titleBar,
    })
    AddCorner(statusDot, 4)
    New("TextLabel", {
        Size             = UDim2.new(0, 40, 1, 0),
        Position         = UDim2.new(1, -48, 0, 0),
        BackgroundTransparency = 1,
        Text             = "ACTIVE",
        TextColor3       = self.T.Success,
        Font             = Enum.Font.GothamBold,
        TextSize          = 9,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = titleBar.ZIndex + 2,
        Parent           = titleBar,
    })
    -- Blinking animation for status dot
    task.spawn(function()
        while statusDot and statusDot.Parent do
            Tween(statusDot, { BackgroundTransparency = 0.7 }, 0.8)
            task.wait(0.8)
            Tween(statusDot, { BackgroundTransparency = 0 }, 0.8)
            task.wait(0.8)
        end
    end)

    -- Close button
    local closeBtn = New("TextButton", {
        Size             = UDim2.new(0, 28, 0, 28),
        Position         = UDim2.new(1, -10, 0.5, -14),
        AnchorPoint      = Vector2.new(1, 0),
        BackgroundColor3 = C3(200, 40, 60),
        BackgroundTransparency = 0.5,
        Text             = "",
        ZIndex           = titleBar.ZIndex + 3,
        Parent           = titleBar,
    })
    AddCorner(closeBtn, 6)
    New("ImageLabel", {
        Size                  = UDim2.new(0, 14, 0, 14),
        Position              = UDim2.new(0.5, -7, 0.5, -7),
        BackgroundTransparency = 1,
        Image                 = "rbxassetid://7072725342", -- X icon
        ImageColor3           = C3(255, 255, 255),
        ZIndex                = closeBtn.ZIndex + 1,
        Parent                = closeBtn,
    })
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, { BackgroundTransparency = 0.1 }, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, { BackgroundTransparency = 0.5 }, 0.15)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        if self.SoundsOn then PlaySound(Sounds.Close) end
        self:Toggle(false)
    end)

    -- Minimize button
    local minBtn = New("TextButton", {
        Size             = UDim2.new(0, 28, 0, 28),
        Position         = UDim2.new(1, -44, 0.5, -14),
        AnchorPoint      = Vector2.new(1, 0),
        BackgroundColor3 = C3(200, 160, 0),
        BackgroundTransparency = 0.5,
        Text             = "",
        ZIndex           = titleBar.ZIndex + 3,
        Parent           = titleBar,
    })
    AddCorner(minBtn, 6)
    New("Frame", {
        Size             = UDim2.new(0, 10, 0, 2),
        Position         = UDim2.new(0.5, -5, 0.5, -1),
        BackgroundColor3 = C3(255, 255, 255),
        ZIndex           = minBtn.ZIndex + 1,
        Parent           = minBtn,
    })
    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, { BackgroundTransparency = 0.1 }, 0.15)
    end)
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, { BackgroundTransparency = 0.5 }, 0.15)
    end)
    minBtn.MouseButton1Click:Connect(function()
        if self.SoundsOn then PlaySound(Sounds.Click) end
        self:Toggle(not self.Visible)
    end)

    MakeDraggable(win, titleBar)

    -- ── Tab Bar ───────────────────────────────────────────
    local tabBar = New("ScrollingFrame", {
        Size                = UDim2.new(0, 150, 1, -48),
        Position            = UDim2.new(0, 0, 0, 48),
        BackgroundColor3    = self.T.Surface,
        BackgroundTransparency = 0.2,
        BorderSizePixel     = 0,
        ScrollBarThickness  = 0,
        CanvasSize          = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex              = win.ZIndex + 1,
        Parent              = win,
    })
    New("UIListLayout", {
        SortOrder         = Enum.SortOrder.LayoutOrder,
        FillDirection     = Enum.FillDirection.Vertical,
        Padding           = UDim.new(0, 4),
        Parent            = tabBar,
    })
    AddPadding(tabBar, 8, 8, 6, 6)
    -- Vertical right border
    local tabBorder = New("Frame", {
        Size             = UDim2.new(0, 1, 1, -48),
        Position         = UDim2.new(0, 150, 0, 48),
        BackgroundColor3 = self.T.Border,
        BackgroundTransparency = 0.7,
        ZIndex           = win.ZIndex + 2,
        Parent           = win,
    })
    self.TabBar    = tabBar
    self.TabBorder = tabBorder

    -- ── Content Area ──────────────────────────────────────
    local contentArea = New("Frame", {
        Size                = UDim2.new(1, -151, 1, -48),
        Position            = UDim2.new(0, 151, 0, 48),
        BackgroundTransparency = 1,
        ClipsDescendants    = true,
        ZIndex              = win.ZIndex + 1,
        Parent              = win,
    })
    self.ContentArea = contentArea

    -- ── Corner decorations ────────────────────────────────
    local function CornerDeco(px, py, rx, ry)
        local deco = New("Frame", {
            Size             = UDim2.new(0, 12, 0, 12),
            Position         = UDim2.new(px, rx, py, ry),
            BackgroundTransparency = 1,
            ZIndex           = win.ZIndex + 10,
            Parent           = win,
        })
        New("Frame", {
            Size             = UDim2.new(1, 0, 0, 2),
            BackgroundColor3 = self.T.Accent,
            Parent           = deco,
        })
        New("Frame", {
            Size             = UDim2.new(0, 2, 1, 0),
            BackgroundColor3 = self.T.Accent,
            Parent           = deco,
        })
        return deco
    end
    CornerDeco(0,0,0,0)
    CornerDeco(1,0,-12,0)
    CornerDeco(0,1,0,-12)
    CornerDeco(1,1,-12,-12)

    -- ── Open Animation ────────────────────────────────────
    if self.SoundsOn then PlaySound(Sounds.Open) end
    Tween(win, { Size = self.WinSize }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- ── Toggle key ────────────────────────────────────────
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then
            self:Toggle(not self.Visible)
        end
    end)

    return self
end

-- ── Toggle Window Visibility ─────────────────────────────
function Window:Toggle(state)
    self.Visible = state
    if state then
        self.Win.Visible = true
        if self.BlurOn and self.BlurEffect then
            Tween(self.BlurEffect, { Size = 6 }, 0.3)
        end
        Tween(self.Win, { Size = self.WinSize }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        if self.SoundsOn then PlaySound(Sounds.Open) end
    else
        Tween(self.Win, { Size = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quart)
        if self.BlurOn and self.BlurEffect then
            Tween(self.BlurEffect, { Size = 0 }, 0.3)
        end
        if self.SoundsOn then PlaySound(Sounds.Close) end
        task.delay(0.35, function()
            if not self.Visible then
                self.Win.Visible = false
            end
        end)
    end
end

-- ── Notification ──────────────────────────────────────────
function Window:Notify(cfg)
    cfg = cfg or {}
    local T       = self.Theme
    local title   = cfg.Title   or "SYSTEM ALERT"
    local desc    = cfg.Desc    or ""
    local icon    = cfg.Icon    or "info"
    local nType   = cfg.Type    or "default"  -- "success"|"warning"|"error"|"default"
    local duration = cfg.Duration or 4

    local borderCol = T.NotifBorder
    if nType == "success" then borderCol = T.Success
    elseif nType == "warning" then borderCol = T.Warning
    elseif nType == "error"   then borderCol = T.Error
    end

    if self.SoundsOn then PlaySound(Sounds.Notif) end

    -- Card
    local card = New("Frame", {
        Size                  = UDim2.new(1, 0, 0, 72),
        BackgroundColor3      = T.NotifBg,
        BackgroundTransparency = 0.08,
        Position              = UDim2.new(1, 10, 0, 0), -- starts offscreen
        Parent                = NotifContainer,
    })
    AddCorner(card, 10)
    AddStroke(card, borderCol, 1.5, 0.1)

    -- Left accent stripe
    New("Frame", {
        Size             = UDim2.new(0, 3, 0.7, 0),
        Position         = UDim2.new(0, 6, 0.15, 0),
        BackgroundColor3 = borderCol,
        ZIndex           = card.ZIndex + 1,
        Parent           = card,
    })
    AddCorner(_, 2)

    -- Icon area
    local iconFrame = New("Frame", {
        Size                  = UDim2.new(0, 36, 0, 36),
        Position              = UDim2.new(0, 16, 0.5, -18),
        BackgroundColor3      = borderCol,
        BackgroundTransparency = 0.82,
        ZIndex                = card.ZIndex + 1,
        Parent                = card,
    })
    AddCorner(iconFrame, 8)
    New("ImageLabel", {
        Size                  = UDim2.new(0, 20, 0, 20),
        Position              = UDim2.new(0.5, -10, 0.5, -10),
        BackgroundTransparency = 1,
        Image                 = "rbxassetid://7072718857", -- bell/alert icon
        ImageColor3           = borderCol,
        ZIndex                = card.ZIndex + 2,
        Parent                = iconFrame,
    })

    -- Texts
    New("TextLabel", {
        Size             = UDim2.new(1, -72, 0, 22),
        Position         = UDim2.new(0, 60, 0, 10),
        BackgroundTransparency = 1,
        Text             = title:upper(),
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = card.ZIndex + 1,
        Parent           = card,
    })
    New("TextLabel", {
        Size             = UDim2.new(1, -72, 0, 28),
        Position         = UDim2.new(0, 60, 0, 30),
        BackgroundTransparency = 1,
        Text             = desc,
        TextColor3       = T.TextDim,
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        ZIndex           = card.ZIndex + 1,
        Parent           = card,
    })

    -- Progress bar (timer)
    local progBg = New("Frame", {
        Size             = UDim2.new(1, -16, 0, 2),
        Position         = UDim2.new(0, 8, 1, -5),
        BackgroundColor3 = T.SurfaceAlt,
        ZIndex           = card.ZIndex + 1,
        Parent           = card,
    })
    AddCorner(progBg, 2)
    local progFill = New("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = borderCol,
        ZIndex           = progBg.ZIndex + 1,
        Parent           = progBg,
    })
    AddCorner(progFill, 2)
    Tween(progFill, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)

    -- Slide in
    Tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Auto dismiss
    task.delay(duration, function()
        Tween(card, { Position = UDim2.new(1, 10, 0, 0) }, 0.35, Enum.EasingStyle.Quart)
        task.delay(0.4, function()
            card:Destroy()
        end)
    end)

    return card
end

-- ── Add Tab ───────────────────────────────────────────────
function Window:AddTab(cfg)
    cfg = cfg or {}
    local T = self.Theme

    local tab = {}
    tab.Title    = cfg.Title or "TAB"
    tab.Icon     = cfg.Icon
    tab.Sections = {}
    tab.Window   = self
    tab.Theme    = T

    -- Tab button
    local btn = New("TextButton", {
        Size                  = UDim2.new(1, 0, 0, 38),
        BackgroundColor3      = T.TabInactive,
        BackgroundTransparency = 0.4,
        Text                  = "",
        ZIndex                = self.TabBar.ZIndex + 1,
        Parent                = self.TabBar,
    })
    AddCorner(btn, 8)

    -- Active indicator bar (left side)
    local indicator = New("Frame", {
        Size             = UDim2.new(0, 2.5, 0, 0),
        Position         = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint      = Vector2.new(0, 0.5),
        BackgroundColor3 = T.TabActive,
        ZIndex           = btn.ZIndex + 2,
        Parent           = btn,
    })
    AddCorner(indicator, 2)

    -- Icon
    local iconOffset = 12
    if tab.Icon then
        New("ImageLabel", {
            Size                  = UDim2.new(0, 18, 0, 18),
            Position              = UDim2.new(0, iconOffset, 0.5, -9),
            BackgroundTransparency = 1,
            Image                 = tab.Icon,
            ImageColor3           = T.TextMuted,
            ZIndex                = btn.ZIndex + 1,
            Parent                = btn,
        })
        tab.IconLabel = btn:FindFirstChild("ImageLabel")
        iconOffset = iconOffset + 24
    end

    -- Title label
    local titleLbl = New("TextLabel", {
        Size             = UDim2.new(1, -(iconOffset+6), 1, 0),
        Position         = UDim2.new(0, iconOffset, 0, 0),
        BackgroundTransparency = 1,
        Text             = tab.Title:upper(),
        TextColor3       = T.TextMuted,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })

    -- Content frame for this tab
    local content = New("ScrollingFrame", {
        Size                = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel     = 0,
        ScrollBarThickness  = 3,
        ScrollBarImageColor3 = T.AccentDim,
        CanvasSize          = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible             = false,
        ZIndex              = self.ContentArea.ZIndex + 1,
        Parent              = self.ContentArea,
    })
    New("UIListLayout", {
        SortOrder        = Enum.SortOrder.LayoutOrder,
        FillDirection    = Enum.FillDirection.Vertical,
        Padding          = UDim.new(0, 10),
        Parent           = content,
    })
    AddPadding(content, 10, 10, 10, 10)

    tab.Button    = btn
    tab.Indicator = indicator
    tab.TitleLbl  = titleLbl
    tab.Content   = content

    -- Hover
    btn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(btn, { BackgroundTransparency = 0.2 }, 0.15)
            Tween(titleLbl, { TextColor3 = T.TextDim }, 0.15)
        end
        if self.SoundsOn then PlaySound(Sounds.Hover, 0.2) end
    end)
    btn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(btn, { BackgroundTransparency = 0.4 }, 0.15)
            Tween(titleLbl, { TextColor3 = T.TextMuted }, 0.15)
        end
    end)

    -- Click → select
    btn.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
        if self.SoundsOn then PlaySound(Sounds.Tab) end
    end)

    table.insert(self.Tabs, tab)

    -- Auto select first tab
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end

    setmetatable(tab, { __index = Tab })
    return tab
end

-- ── Select Tab ────────────────────────────────────────────
function Window:SelectTab(tab)
    local T = self.Theme
    -- Deactivate previous
    if self.ActiveTab and self.ActiveTab ~= tab then
        local prev = self.ActiveTab
        Tween(prev.Button,    { BackgroundTransparency = 0.4 }, 0.2)
        Tween(prev.TitleLbl,  { TextColor3 = T.TextMuted }, 0.2)
        Tween(prev.Indicator, { Size = UDim2.new(0, 2.5, 0, 0) }, 0.2, Enum.EasingStyle.Quart)
        prev.Content.Visible = false
        if prev.IconLabel then
            Tween(prev.IconLabel, { ImageColor3 = T.TextMuted }, 0.2)
        end
    end

    self.ActiveTab = tab

    -- Activate
    Tween(tab.Button,    { BackgroundTransparency = 0.05 }, 0.2)
    Tween(tab.TitleLbl,  { TextColor3 = T.TabActive }, 0.2)
    Tween(tab.Indicator, { Size = UDim2.new(0, 2.5, 0.7, 0) }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    if tab.IconLabel then
        Tween(tab.IconLabel, { ImageColor3 = T.TabActive }, 0.2)
    end

    -- Fade in content
    tab.Content.Visible = true
    tab.Content.GroupTransparency = 1
    Tween(tab.Content, { GroupTransparency = 0 }, 0.25)
end

-- ============================================================
--  TAB CLASS
-- ============================================================

local Tab = {}
Tab.__index = Tab

-- ── Add Section ───────────────────────────────────────────
function Tab:AddSection(cfg)
    cfg = cfg or {}
    local T = self.Theme or self.Window.Theme

    local section = {}
    section.Title   = cfg.Title or "SECTION"
    section.Tab     = self
    section.Theme   = T
    section.Items   = {}

    -- Section container
    local frame = New("Frame", {
        Size                = UDim2.new(1, 0, 0, 0),
        BackgroundColor3    = T.Surface,
        BackgroundTransparency = 0.25,
        AutomaticSize       = Enum.AutomaticSize.Y,
        ZIndex              = self.Content.ZIndex + 1,
        Parent              = self.Content,
    })
    AddCorner(frame, 10)
    AddStroke(frame, T.Border, 1, 0.7)
    AddPadding(frame, 10, 10, 10, 10)

    New("UIListLayout", {
        SortOrder        = Enum.SortOrder.LayoutOrder,
        FillDirection    = Enum.FillDirection.Vertical,
        Padding          = UDim.new(0, 8),
        Parent           = frame,
    })

    -- Section header
    local headerFrame = New("Frame", {
        Size                = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder         = 0,
        Parent              = frame,
    })
    -- Left accent line
    New("Frame", {
        Size             = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = T.Accent,
        Parent           = headerFrame,
    })
    AddCorner(_, 2)
    New("TextLabel", {
        Size             = UDim2.new(1, -10, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Title:upper(),
        TextColor3       = T.Accent,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = headerFrame,
    })
    -- Separator line after header
    local sep = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = T.Border,
        BackgroundTransparency = 0.75,
        LayoutOrder      = 1,
        Parent           = frame,
    })

    section.Frame    = frame
    section.LayoutOrder = 2

    setmetatable(section, { __index = Section })
    return section
end

-- ============================================================
--  SECTION CLASS (all components)
-- ============================================================

local Section = {}
Section.__index = Section

-- Helper: next layout order
local function NextOrder(section)
    section._order = (section._order or 1) + 1
    return section._order
end

-- ── Component Base Frame ──────────────────────────────────
local function CompFrame(section, height)
    local T = section.Theme
    local f = New("Frame", {
        Size                = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1,
        LayoutOrder         = NextOrder(section),
        Parent              = section.Frame,
    })
    return f, T
end

-- ── LABEL ─────────────────────────────────────────────────
function Section:AddLabel(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 24)
    New("TextLabel", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Label",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = cfg.Size or 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = f,
    })
    local lbl = {}
    function lbl:Set(text) f:FindFirstChildOfClass("TextLabel").Text = text end
    return lbl
end

-- ── PARAGRAPH ─────────────────────────────────────────────
function Section:AddParagraph(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y

    New("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text             = cfg.Content or "",
        TextColor3       = T.TextDim,
        Font             = Enum.Font.Gotham,
        TextSize         = cfg.Size or 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        Parent           = f,
    })
    local para = {}
    function para:Set(text) f:FindFirstChildOfClass("TextLabel").Text = text end
    return para
end

-- ── SEPARATOR ─────────────────────────────────────────────
function Section:AddSeparator(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 14)
    local line = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = T.Border,
        BackgroundTransparency = 0.6,
        Parent           = f,
    })
    if cfg.Title then
        local bg = New("Frame", {
            Size             = UDim2.new(0, 0, 0, 14),
            Position         = UDim2.new(0.5, 0, 0, 0),
            AnchorPoint      = Vector2.new(0.5, 0),
            BackgroundColor3 = T.Surface,
            AutomaticSize    = Enum.AutomaticSize.X,
            ZIndex           = line.ZIndex + 1,
            Parent           = f,
        })
        AddPadding(bg, 0, 0, 6, 6)
        New("TextLabel", {
            Size             = UDim2.new(0, 0, 1, 0),
            AutomaticSize    = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text             = cfg.Title,
            TextColor3       = T.TextMuted,
            Font             = Enum.Font.Gotham,
            TextSize         = 10,
            ZIndex           = bg.ZIndex + 1,
            Parent           = bg,
        })
    end
end

-- ── BUTTON ────────────────────────────────────────────────
function Section:AddButton(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 36)

    local btn = New("TextButton", {
        Size                = UDim2.new(1, 0, 1, 0),
        BackgroundColor3    = T.SurfaceAlt,
        BackgroundTransparency = 0.3,
        Text                = "",
        ZIndex              = f.ZIndex + 1,
        Parent              = f,
    })
    AddCorner(btn, 8)
    AddStroke(btn, T.Border, 1, 0.7)

    -- Icon
    local textX = 12
    if cfg.Icon then
        New("ImageLabel", {
            Size                  = UDim2.new(0, 16, 0, 16),
            Position              = UDim2.new(0, textX, 0.5, -8),
            BackgroundTransparency = 1,
            Image                 = cfg.Icon,
            ImageColor3           = T.Accent,
            ZIndex                = btn.ZIndex + 1,
            Parent                = btn,
        })
        textX = textX + 22
    end

    New("TextLabel", {
        Size             = UDim2.new(1, -(textX+8), 1, 0),
        Position         = UDim2.new(0, textX, 0, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Button",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })

    -- Right arrow
    New("TextLabel", {
        Size             = UDim2.new(0, 20, 1, 0),
        Position         = UDim2.new(1, -24, 0, 0),
        BackgroundTransparency = 1,
        Text             = ">",
        TextColor3       = T.AccentDim,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })

    -- Hover glow
    btn.MouseEnter:Connect(function()
        Tween(btn, { BackgroundTransparency = 0.05 }, 0.15)
        Tween(btn:FindFirstChildOfClass("UIStroke"), { Transparency = 0.2 }, 0.15)
        if self.Tab.Window.SoundsOn then PlaySound(Sounds.Hover, 0.18) end
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, { BackgroundTransparency = 0.3 }, 0.15)
        Tween(btn:FindFirstChildOfClass("UIStroke"), { Transparency = 0.7 }, 0.15)
    end)
    -- Click press
    btn.MouseButton1Down:Connect(function()
        Tween(btn, { Size = UDim2.new(0.97, 0, 0.9, 0), Position = UDim2.new(0.015, 0, 0.05, 0) }, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        Tween(btn, { Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0) }, 0.12, Enum.EasingStyle.Back)
        if self.Tab.Window.SoundsOn then PlaySound(Sounds.Click) end
        if cfg.Callback then cfg.Callback() end
    end)

    local obj = {}
    function obj:SetTitle(t) btn:FindFirstChildOfClass("TextLabel").Text = t end
    function obj:SetCallback(fn) cfg.Callback = fn end
    return obj
end

-- ── TOGGLE ────────────────────────────────────────────────
function Section:AddToggle(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 36)
    local state = cfg.Default or false

    local row = New("Frame", {
        Size                = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent              = f,
    })

    -- Label
    New("TextLabel", {
        Size             = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Toggle",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = row,
    })

    -- Track
    local track = New("TextButton", {
        Size             = UDim2.new(0, 46, 0, 24),
        Position         = UDim2.new(1, -50, 0.5, -12),
        BackgroundColor3 = state and T.ToggleOn or T.ToggleOff,
        Text             = "",
        ZIndex           = row.ZIndex + 1,
        Parent           = row,
    })
    AddCorner(track, 12)
    AddStroke(track, state and T.Accent or T.Border, 1, state and 0.2 or 0.6)

    -- Knob
    local knob = New("Frame", {
        Size             = UDim2.new(0, 18, 0, 18),
        Position         = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = C3(255, 255, 255),
        ZIndex           = track.ZIndex + 1,
        Parent           = track,
    })
    AddCorner(knob, 9)
    -- Glow on knob when active
    local knobGlow = New("Frame", {
        Size             = UDim2.new(1, 8, 1, 8),
        Position         = UDim2.new(0, -4, 0, -4),
        BackgroundColor3 = T.ToggleOn,
        BackgroundTransparency = state and 0.6 or 1,
        ZIndex           = knob.ZIndex - 1,
        Parent           = knob,
    })
    AddCorner(knobGlow, 13)

    local function SetState(val, noCallback)
        state = val
        if val then
            Tween(track, { BackgroundColor3 = T.ToggleOn }, 0.2)
            Tween(knob,  { Position = UDim2.new(1, -21, 0.5, -9) }, 0.25, Enum.EasingStyle.Back)
            Tween(knobGlow, { BackgroundTransparency = 0.5 }, 0.2)
            Tween(track:FindFirstChildOfClass("UIStroke"), { Transparency = 0.2 }, 0.2)
        else
            Tween(track, { BackgroundColor3 = T.ToggleOff }, 0.2)
            Tween(knob,  { Position = UDim2.new(0, 3, 0.5, -9) }, 0.25, Enum.EasingStyle.Back)
            Tween(knobGlow, { BackgroundTransparency = 1 }, 0.2)
            Tween(track:FindFirstChildOfClass("UIStroke"), { Transparency = 0.6 }, 0.2)
        end
        if not noCallback and cfg.Callback then cfg.Callback(val) end
        if self.Tab.Window.SoundsOn then PlaySound(Sounds.Toggle) end
    end

    track.MouseButton1Click:Connect(function()
        SetState(not state)
    end)
    row.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            SetState(not state)
        end
    end)

    local obj = {}
    obj.Value = state
    function obj:Set(val) SetState(val, true) end
    function obj:Get() return state end
    return obj
end

-- ── SLIDER ────────────────────────────────────────────────
function Section:AddSlider(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 50)
    local min_  = cfg.Min     or 0
    local max_  = cfg.Max     or 100
    local step  = cfg.Step    or 1
    local val   = cfg.Default or min_
    local suffix = cfg.Suffix or ""

    -- Title row
    New("TextLabel", {
        Size             = UDim2.new(1, -60, 0, 20),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Slider",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = f,
    })
    local valLbl = New("TextLabel", {
        Size             = UDim2.new(0, 55, 0, 20),
        Position         = UDim2.new(1, -58, 0, 0),
        BackgroundTransparency = 1,
        Text             = tostring(val)..suffix,
        TextColor3       = T.Accent,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Right,
        Parent           = f,
    })

    -- Track bg
    local trackBg = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 6),
        Position         = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = T.SliderBg,
        Parent           = f,
    })
    AddCorner(trackBg, 3)

    -- Fill
    local fill = New("Frame", {
        Size             = UDim2.new((val - min_)/(max_ - min_), 0, 1, 0),
        BackgroundColor3 = T.SliderFill,
        ZIndex           = trackBg.ZIndex + 1,
        Parent           = trackBg,
    })
    AddCorner(fill, 3)
    AddGradient(fill, T.AccentDim, T.Accent, 0)

    -- Thumb
    local thumb = New("Frame", {
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = UDim2.new((val - min_)/(max_ - min_), -7, 0.5, -7),
        BackgroundColor3 = C3(255, 255, 255),
        ZIndex           = fill.ZIndex + 2,
        Parent           = trackBg,
    })
    AddCorner(thumb, 7)
    AddStroke(thumb, T.Accent, 2, 0)

    -- Thumb glow
    local tGlow = New("Frame", {
        Size             = UDim2.new(1, 10, 1, 10),
        Position         = UDim2.new(0, -5, 0, -5),
        BackgroundColor3 = T.Accent,
        BackgroundTransparency = 0.6,
        ZIndex           = thumb.ZIndex - 1,
        Parent           = thumb,
    })
    AddCorner(tGlow, 12)

    -- Dragging logic
    local dragging = false

    local function UpdateValue(mouseX)
        local abs  = trackBg.AbsolutePosition.X
        local size = trackBg.AbsoluteSize.X
        local t    = math.clamp((mouseX - abs) / size, 0, 1)
        local raw  = min_ + t * (max_ - min_)
        local snapped = math.floor(raw / step + 0.5) * step
        snapped = math.clamp(snapped, min_, max_)
        val = snapped
        local pct = (val - min_) / (max_ - min_)
        Tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) }, 0.06)
        Tween(thumb, { Position = UDim2.new(pct, -7, 0.5, -7) }, 0.06)
        valLbl.Text = tostring(val)..suffix
        if cfg.Callback then cfg.Callback(val) end
    end

    trackBg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateValue(inp.Position.X)
            if self.Tab.Window.SoundsOn then PlaySound(Sounds.Slider, 0.15) end
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
            UpdateValue(inp.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local obj = {}
    obj.Value = val
    function obj:Set(v)
        val = math.clamp(v, min_, max_)
        local pct = (val - min_) / (max_ - min_)
        Tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) }, 0.2)
        Tween(thumb, { Position = UDim2.new(pct, -7, 0.5, -7) }, 0.2)
        valLbl.Text = tostring(val)..suffix
    end
    function obj:Get() return val end
    return obj
end

-- ── KEYBIND ───────────────────────────────────────────────
function Section:AddKeybind(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 36)
    local key   = cfg.Default or Enum.KeyCode.Unknown
    local listening = false

    New("TextLabel", {
        Size             = UDim2.new(1, -100, 1, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Keybind",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = f,
    })

    local box = New("TextButton", {
        Size             = UDim2.new(0, 90, 0, 26),
        Position         = UDim2.new(1, -92, 0.5, -13),
        BackgroundColor3 = T.SurfaceAlt,
        BackgroundTransparency = 0.3,
        Text             = key.Name,
        TextColor3       = T.Accent,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        ZIndex           = f.ZIndex + 1,
        Parent           = f,
    })
    AddCorner(box, 6)
    AddStroke(box, T.Border, 1, 0.6)

    box.MouseButton1Click:Connect(function()
        listening = true
        box.Text = "..."
        Tween(box, { BackgroundTransparency = 0.05 }, 0.1)
        if self.Tab.Window.SoundsOn then PlaySound(Sounds.Click) end
    end)

    UserInputService.InputBegan:Connect(function(inp, gp)
        if not listening then return end
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            key = inp.KeyCode
            box.Text = key.Name
            Tween(box, { BackgroundTransparency = 0.3 }, 0.1)
            if cfg.Callback then cfg.Callback(key) end
        end
    end)

    local obj = {}
    function obj:Get() return key end
    function obj:Set(k) key = k; box.Text = k.Name end
    return obj
end

-- ── TEXTBOX ───────────────────────────────────────────────
function Section:AddTextBox(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 54)

    New("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Input",
        TextColor3       = T.TextDim,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = f,
    })

    local inputBg = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 30),
        Position         = UDim2.new(0, 0, 0, 22),
        BackgroundColor3 = T.DropdownBg,
        BackgroundTransparency = 0.1,
        ZIndex           = f.ZIndex + 1,
        Parent           = f,
    })
    AddCorner(inputBg, 7)
    AddStroke(inputBg, T.Border, 1, 0.7)

    local input = New("TextBox", {
        Size                  = UDim2.new(1, -20, 1, 0),
        Position              = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                  = cfg.Default or "",
        PlaceholderText       = cfg.Placeholder or "Enter text...",
        TextColor3            = T.Text,
        PlaceholderColor3     = T.TextMuted,
        Font                  = Enum.Font.Gotham,
        TextSize              = 12,
        ClearTextOnFocus      = cfg.ClearOnFocus ~= false,
        ZIndex                = inputBg.ZIndex + 1,
        Parent                = inputBg,
    })

    input.Focused:Connect(function()
        Tween(inputBg:FindFirstChildOfClass("UIStroke"), { Transparency = 0.1 }, 0.15)
        Tween(inputBg:FindFirstChildOfClass("UIStroke"), { Color = T.Accent }, 0.15)
    end)
    input.FocusLost:Connect(function(enter)
        Tween(inputBg:FindFirstChildOfClass("UIStroke"), { Transparency = 0.7 }, 0.15)
        Tween(inputBg:FindFirstChildOfClass("UIStroke"), { Color = T.Border }, 0.15)
        if cfg.Callback then cfg.Callback(input.Text, enter) end
    end)

    local obj = {}
    function obj:Get() return input.Text end
    function obj:Set(t) input.Text = t end
    return obj
end

-- ── DROPDOWN ──────────────────────────────────────────────
function Section:AddDropdown(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 36)
    local options = cfg.Options or {}
    local selected = cfg.Default or (options[1] or "Select...")
    local open = false

    -- Main button
    local btn = New("TextButton", {
        Size                = UDim2.new(1, 0, 1, 0),
        BackgroundColor3    = T.DropdownBg,
        BackgroundTransparency = 0.1,
        Text                = "",
        ZIndex              = f.ZIndex + 1,
        ClipsDescendants    = false,
        Parent              = f,
    })
    AddCorner(btn, 8)
    AddStroke(btn, T.Border, 1, 0.6)

    local selLbl = New("TextLabel", {
        Size             = UDim2.new(1, -36, 1, 0),
        Position         = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text             = selected,
        TextColor3       = T.Text,
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })

    -- Title label above
    New("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 0, -16),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Dropdown",
        TextColor3       = T.TextDim,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })
    f.Size = UDim2.new(1, 0, 0, 52)

    -- Chevron icon
    local chev = New("TextLabel", {
        Size             = UDim2.new(0, 24, 1, 0),
        Position         = UDim2.new(1, -28, 0, 0),
        BackgroundTransparency = 1,
        Text             = "v",
        TextColor3       = T.TextMuted,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })

    -- Dropdown list (spawns as child of gui screen for proper z-order)
    local listFrame = New("Frame", {
        Size                = UDim2.new(0, 0, 0, 0),
        BackgroundColor3    = T.DropdownBg,
        BackgroundTransparency = 0.05,
        ClipsDescendants    = true,
        ZIndex              = 200,
        Visible             = false,
        Parent              = f.Parent.Parent.Parent.Parent, -- contentArea's gui level
    })
    AddCorner(listFrame, 8)
    AddStroke(listFrame, T.Border, 1, 0.4)

    local listLayout = New("UIListLayout", {
        SortOrder        = Enum.SortOrder.LayoutOrder,
        FillDirection    = Enum.FillDirection.Vertical,
        Padding          = UDim.new(0, 2),
        Parent           = listFrame,
    })
    AddPadding(listFrame, 4, 4, 4, 4)

    -- Populate options
    local function PopulateList()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i, opt in ipairs(options) do
            local item = New("TextButton", {
                Size                = UDim2.new(1, 0, 0, 30),
                BackgroundColor3    = opt == selected and T.AccentDim or T.SurfaceAlt,
                BackgroundTransparency = opt == selected and 0.3 or 0.7,
                Text                = opt,
                TextColor3          = opt == selected and T.Accent or T.Text,
                Font                = Enum.Font.Gotham,
                TextSize            = 12,
                ZIndex              = listFrame.ZIndex + 1,
                Parent              = listFrame,
            })
            AddCorner(item, 6)
            item.MouseEnter:Connect(function()
                if opt ~= selected then
                    Tween(item, { BackgroundTransparency = 0.4 }, 0.1)
                end
            end)
            item.MouseLeave:Connect(function()
                if opt ~= selected then
                    Tween(item, { BackgroundTransparency = 0.7 }, 0.1)
                end
            end)
            item.MouseButton1Click:Connect(function()
                selected = opt
                selLbl.Text = opt
                if cfg.Callback then cfg.Callback(opt) end
                if self.Tab.Window.SoundsOn then PlaySound(Sounds.Click) end
                -- Close
                Tween(listFrame, { Size = UDim2.new(listFrame.Size.X.Scale, listFrame.Size.X.Offset, 0, 0) }, 0.2)
                task.delay(0.22, function() listFrame.Visible = false end)
                open = false
                Tween(chev, { Rotation = 0 }, 0.2)
                PopulateList()
            end)
        end
    end
    PopulateList()

    -- Toggle open/close
    local function ToggleDropdown()
        open = not open
        if open then
            -- Position list below button
            local absBtnPos  = btn.AbsolutePosition
            local absBtnSize = btn.AbsoluteSize
            local guiOff     = listFrame.Parent.AbsolutePosition
            local targetH    = math.min(#options * 34 + 10, 160)
            listFrame.Position = UDim2.new(0, absBtnPos.X - guiOff.X, 0, absBtnPos.Y - guiOff.Y + absBtnSize.Y + 4)
            listFrame.Size     = UDim2.new(0, absBtnSize.X, 0, 0)
            listFrame.Visible  = true
            Tween(listFrame, { Size = UDim2.new(0, absBtnSize.X, 0, targetH) }, 0.25, Enum.EasingStyle.Back)
            Tween(chev, { Rotation = 180 }, 0.2)
        else
            Tween(listFrame, { Size = UDim2.new(listFrame.Size.X.Scale, listFrame.Size.X.Offset, 0, 0) }, 0.2)
            task.delay(0.22, function() listFrame.Visible = false end)
            Tween(chev, { Rotation = 0 }, 0.2)
        end
        if self.Tab.Window.SoundsOn then PlaySound(Sounds.Click) end
    end

    btn.MouseButton1Click:Connect(ToggleDropdown)

    -- Close on outside click
    UserInputService.InputBegan:Connect(function(inp)
        if open and inp.UserInputType == Enum.UserInputType.MouseButton1 then
            task.defer(function()
                if open then
                    open = false
                    Tween(listFrame, { Size = UDim2.new(listFrame.Size.X.Scale, listFrame.Size.X.Offset, 0, 0) }, 0.2)
                    task.delay(0.22, function() listFrame.Visible = false end)
                    Tween(chev, { Rotation = 0 }, 0.2)
                end
            end)
        end
    end)

    local obj = {}
    function obj:Get() return selected end
    function obj:Set(v) selected = v; selLbl.Text = v; PopulateList() end
    function obj:SetOptions(opts) options = opts; PopulateList() end
    return obj
end

-- ── MULTI DROPDOWN ────────────────────────────────────────
function Section:AddMultiDropdown(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 52)
    local options  = cfg.Options  or {}
    local selected = cfg.Default  or {}
    local open     = false

    New("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Multi Select",
        TextColor3       = T.TextDim,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = f,
    })

    local btn = New("TextButton", {
        Size                = UDim2.new(1, 0, 0, 34),
        Position            = UDim2.new(0, 0, 0, 16),
        BackgroundColor3    = T.DropdownBg,
        BackgroundTransparency = 0.1,
        Text                = "",
        ZIndex              = f.ZIndex + 1,
        Parent              = f,
    })
    AddCorner(btn, 8)
    AddStroke(btn, T.Border, 1, 0.6)

    local function GetSelText()
        if #selected == 0 then return "None selected"
        elseif #selected == 1 then return selected[1]
        else return #selected.." selected" end
    end

    local selLbl = New("TextLabel", {
        Size             = UDim2.new(1, -36, 1, 0),
        Position         = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text             = GetSelText(),
        TextColor3       = T.Text,
        Font             = Enum.Font.Gotham,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })
    New("TextLabel", {
        Size             = UDim2.new(0, 24, 1, 0),
        Position         = UDim2.new(1, -28, 0, 0),
        BackgroundTransparency = 1,
        Text             = "v",
        TextColor3       = T.TextMuted,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        ZIndex           = btn.ZIndex + 1,
        Parent           = btn,
    })

    local listFrame = New("Frame", {
        Size                = UDim2.new(0, 0, 0, 0),
        BackgroundColor3    = T.DropdownBg,
        BackgroundTransparency = 0.05,
        ClipsDescendants    = true,
        ZIndex              = 200,
        Visible             = false,
        Parent              = f.Parent.Parent.Parent.Parent,
    })
    AddCorner(listFrame, 8)
    AddStroke(listFrame, T.Border, 1, 0.4)
    AddPadding(listFrame, 4, 4, 4, 4)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,2), Parent = listFrame })

    local function IsSelected(opt)
        for _, v in ipairs(selected) do if v == opt then return true end end
        return false
    end

    local function PopulateList()
        for _, c in ipairs(listFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, opt in ipairs(options) do
            local isSel = IsSelected(opt)
            local item = New("TextButton", {
                Size                = UDim2.new(1, 0, 0, 30),
                BackgroundColor3    = isSel and T.AccentDim or T.SurfaceAlt,
                BackgroundTransparency = isSel and 0.3 or 0.7,
                Text                = "",
                ZIndex              = listFrame.ZIndex + 1,
                Parent              = listFrame,
            })
            AddCorner(item, 6)
            -- Checkbox
            local cb = New("Frame", {
                Size             = UDim2.new(0, 14, 0, 14),
                Position         = UDim2.new(0, 8, 0.5, -7),
                BackgroundColor3 = isSel and T.Accent or T.Surface,
                BackgroundTransparency = isSel and 0 or 0.3,
                ZIndex           = item.ZIndex + 1,
                Parent           = item,
            })
            AddCorner(cb, 3)
            if isSel then
                New("TextLabel", {
                    Size             = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    Text             = "✓",
                    TextColor3       = C3(10,10,10),
                    Font             = Enum.Font.GothamBold,
                    TextSize         = 10,
                    ZIndex           = cb.ZIndex + 1,
                    Parent           = cb,
                })
            end
            New("TextLabel", {
                Size             = UDim2.new(1, -30, 1, 0),
                Position         = UDim2.new(0, 28, 0, 0),
                BackgroundTransparency = 1,
                Text             = opt,
                TextColor3       = isSel and T.Accent or T.Text,
                Font             = Enum.Font.Gotham,
                TextSize         = 12,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = item.ZIndex + 1,
                Parent           = item,
            })
            item.MouseButton1Click:Connect(function()
                if IsSelected(opt) then
                    for i, v in ipairs(selected) do
                        if v == opt then table.remove(selected, i) break end
                    end
                else
                    table.insert(selected, opt)
                end
                selLbl.Text = GetSelText()
                if cfg.Callback then cfg.Callback(selected) end
                if self.Tab.Window.SoundsOn then PlaySound(Sounds.Click) end
                PopulateList()
            end)
        end
    end
    PopulateList()

    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            local absBtnPos  = btn.AbsolutePosition
            local absBtnSize = btn.AbsoluteSize
            local guiOff     = listFrame.Parent.AbsolutePosition
            local targetH    = math.min(#options * 34 + 10, 180)
            listFrame.Position = UDim2.new(0, absBtnPos.X - guiOff.X, 0, absBtnPos.Y - guiOff.Y + absBtnSize.Y + 4)
            listFrame.Size     = UDim2.new(0, absBtnSize.X, 0, 0)
            listFrame.Visible  = true
            Tween(listFrame, { Size = UDim2.new(0, absBtnSize.X, 0, targetH) }, 0.25, Enum.EasingStyle.Back)
        else
            Tween(listFrame, { Size = UDim2.new(listFrame.Size.X.Scale, listFrame.Size.X.Offset, 0, 0) }, 0.2)
            task.delay(0.22, function() listFrame.Visible = false end)
        end
    end)

    local obj = {}
    function obj:Get() return selected end
    function obj:Set(v) selected = v; selLbl.Text = GetSelText(); PopulateList() end
    return obj
end

-- ── COLOR PICKER ──────────────────────────────────────────
function Section:AddColorPicker(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 36)
    local color = cfg.Default or Color3.fromRGB(0, 200, 255)
    local open  = false

    New("TextLabel", {
        Size             = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Color",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = f,
    })

    local preview = New("TextButton", {
        Size             = UDim2.new(0, 70, 0, 26),
        Position         = UDim2.new(1, -72, 0.5, -13),
        BackgroundColor3 = color,
        Text             = "",
        ZIndex           = f.ZIndex + 1,
        Parent           = f,
    })
    AddCorner(preview, 6)
    AddStroke(preview, T.Border, 1, 0.5)

    -- Simple H/S/V picker panel
    local pickerPanel = New("Frame", {
        Size                = UDim2.new(0, 240, 0, 160),
        BackgroundColor3    = T.DropdownBg,
        BackgroundTransparency = 0.02,
        Visible             = false,
        ZIndex              = 201,
        Parent              = f,
    })
    AddCorner(pickerPanel, 10)
    AddStroke(pickerPanel, T.Border, 1, 0.4)
    AddPadding(pickerPanel, 10, 10, 10, 10)

    -- RGB Sliders
    local r, g, b = color.R * 255, color.G * 255, color.B * 255

    local function MakeColorSlider(label, default, parent, callback)
        local sf = New("Frame", { Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.None, Parent=parent })
        New("TextLabel", { Size=UDim2.new(0,14,1,0), BackgroundTransparency=1, Text=label, TextColor3=T.TextDim, Font=Enum.Font.GothamBold, TextSize=10, Parent=sf })
        local vLbl = New("TextLabel", { Size=UDim2.new(0,28,1,0), Position=UDim2.new(1,-28,0,0), BackgroundTransparency=1, Text=tostring(math.floor(default)), TextColor3=T.Accent, Font=Enum.Font.GothamBold, TextSize=10, Parent=sf })
        local tbg = New("Frame", { Size=UDim2.new(1,-50,0,5), Position=UDim2.new(0,18,0.5,-2), BackgroundColor3=T.SliderBg, ZIndex=sf.ZIndex+1, Parent=sf })
        AddCorner(tbg,3)
        local tfill = New("Frame", { Size=UDim2.new(default/255,0,1,0), BackgroundColor3=Color3.fromRGB(255,255,255), ZIndex=tbg.ZIndex+1, Parent=tbg })
        AddCorner(tfill,3)
        local val = default
        local drag = false
        tbg.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                local t = math.clamp((inp.Position.X - tbg.AbsolutePosition.X) / tbg.AbsoluteSize.X, 0, 1)
                val = math.floor(t * 255)
                tfill.Size = UDim2.new(t,0,1,0)
                vLbl.Text = tostring(val)
                callback(val)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local t = math.clamp((inp.Position.X - tbg.AbsolutePosition.X) / tbg.AbsoluteSize.X, 0, 1)
                val = math.floor(t * 255)
                tfill.Size = UDim2.new(t,0,1,0)
                vLbl.Text = tostring(val)
                callback(val)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
        end)
        return sf
    end

    local function UpdatePreview()
        local c = Color3.fromRGB(r, g, b)
        color = c
        preview.BackgroundColor3 = c
        if cfg.Callback then cfg.Callback(c) end
    end

    local listLayout2 = New("UIListLayout", { SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6), Parent=pickerPanel })

    MakeColorSlider("R", r, pickerPanel, function(v) r=v; UpdatePreview() end)
    MakeColorSlider("G", g, pickerPanel, function(v) g=v; UpdatePreview() end)
    MakeColorSlider("B", b, pickerPanel, function(v) b=v; UpdatePreview() end)

    New("TextLabel", {
        Size             = UDim2.new(1,0,0,20),
        BackgroundTransparency = 1,
        Text             = "Click outside to close",
        TextColor3       = T.TextMuted,
        Font             = Enum.Font.Gotham,
        TextSize          = 9,
        LayoutOrder       = 99,
        Parent           = pickerPanel,
    })

    preview.MouseButton1Click:Connect(function()
        open = not open
        pickerPanel.Visible = open
        if open then
            local absPos = preview.AbsolutePosition
            local guiOff = pickerPanel.Parent.AbsolutePosition
            pickerPanel.Position = UDim2.new(0, absPos.X - guiOff.X - 170, 0, absPos.Y - guiOff.Y + 32)
        end
    end)

    UserInputService.InputBegan:Connect(function(inp)
        if open and inp.UserInputType == Enum.UserInputType.MouseButton1 then
            task.defer(function()
                if open then
                    open = false
                    pickerPanel.Visible = false
                end
            end)
        end
    end)

    local obj = {}
    function obj:Get() return color end
    function obj:Set(c) color=c; preview.BackgroundColor3=c; r=c.R*255; g=c.G*255; b=c.B*255 end
    return obj
end

-- ── PROGRESS BAR ──────────────────────────────────────────
function Section:AddProgressBar(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 44)
    local val   = cfg.Value   or 0
    local max_  = cfg.Max     or 100
    local suffix = cfg.Suffix or "%"

    New("TextLabel", {
        Size             = UDim2.new(1, -50, 0, 20),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Progress",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = f,
    })
    local valLbl = New("TextLabel", {
        Size             = UDim2.new(0, 45, 0, 20),
        Position         = UDim2.new(1, -46, 0, 0),
        BackgroundTransparency = 1,
        Text             = tostring(val)..suffix,
        TextColor3       = T.Accent,
        Font             = Enum.Font.GothamBold,
        TextSize         = 12,
        TextXAlignment   = Enum.TextXAlignment.Right,
        Parent           = f,
    })

    local trackBg = New("Frame", {
        Size             = UDim2.new(1, 0, 0, 8),
        Position         = UDim2.new(0, 0, 0, 28),
        BackgroundColor3 = T.SliderBg,
        Parent           = f,
    })
    AddCorner(trackBg, 4)

    local fill = New("Frame", {
        Size             = UDim2.new(val / max_, 0, 1, 0),
        BackgroundColor3 = T.SliderFill,
        ZIndex           = trackBg.ZIndex + 1,
        Parent           = trackBg,
    })
    AddCorner(fill, 4)
    AddGradient(fill, T.AccentDim, T.Accent, 0)

    -- Animated shimmer effect
    local shimmer = New("Frame", {
        Size             = UDim2.new(0.3, 0, 1, 0),
        BackgroundColor3 = C3(255, 255, 255),
        BackgroundTransparency = 0.8,
        ZIndex           = fill.ZIndex + 1,
        Parent           = fill,
    })
    AddCorner(shimmer, 4)
    task.spawn(function()
        while shimmer and shimmer.Parent do
            shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
            Tween(shimmer, { Position = UDim2.new(1, 0, 0, 0) }, 1.5, Enum.EasingStyle.Linear)
            task.wait(2)
        end
    end)

    local obj = {}
    function obj:Set(v)
        val = math.clamp(v, 0, max_)
        Tween(fill, { Size = UDim2.new(val / max_, 0, 1, 0) }, 0.4, Enum.EasingStyle.Quart)
        valLbl.Text = tostring(math.floor(val))..suffix
    end
    function obj:Get() return val end
    return obj
end

-- ── IMAGE ─────────────────────────────────────────────────
function Section:AddImage(cfg)
    cfg = cfg or {}
    local h = cfg.Height or 100
    local f, T = CompFrame(self, h)

    local img = New("ImageLabel", {
        Size                  = UDim2.new(1, 0, 1, 0),
        BackgroundColor3      = T.SurfaceAlt,
        BackgroundTransparency = 0.3,
        Image                 = cfg.Image or "",
        ImageColor3           = cfg.Color or C3(255, 255, 255),
        ScaleType             = cfg.ScaleType or Enum.ScaleType.Fit,
        ZIndex                = f.ZIndex + 1,
        Parent                = f,
    })
    AddCorner(img, 8)
    AddStroke(img, T.Border, 1, 0.7)

    local obj = {}
    function obj:Set(id) img.Image = id end
    return obj
end

-- ── AVATAR ────────────────────────────────────────────────
function Section:AddAvatar(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 64)

    local row = New("Frame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Parent=f })

    local imgFrame = New("Frame", {
        Size             = UDim2.new(0, 52, 0, 52),
        Position         = UDim2.new(0, 0, 0.5, -26),
        BackgroundColor3 = T.SurfaceAlt,
        ZIndex           = row.ZIndex + 1,
        Parent           = row,
    })
    AddCorner(imgFrame, 26)
    AddStroke(imgFrame, T.Accent, 2, 0.1)

    local userId = cfg.UserId or (LocalPlayer and LocalPlayer.UserId) or 0
    New("ImageLabel", {
        Size                  = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image                 = "rbxthumb://type=AvatarHeadShot&id="..userId.."&w=150&h=150",
        ZIndex                = imgFrame.ZIndex + 1,
        Parent                = imgFrame,
    })
    AddCorner(_, 26)

    New("TextLabel", {
        Size             = UDim2.new(1, -66, 0, 20),
        Position         = UDim2.new(0, 62, 0.2, 0),
        BackgroundTransparency = 1,
        Text             = cfg.Name or (LocalPlayer and LocalPlayer.Name) or "Player",
        TextColor3       = T.Text,
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = row.ZIndex + 1,
        Parent           = row,
    })
    New("TextLabel", {
        Size             = UDim2.new(1, -66, 0, 16),
        Position         = UDim2.new(0, 62, 0.5, 2),
        BackgroundTransparency = 1,
        Text             = cfg.Role or "Hunter",
        TextColor3       = T.Accent,
        Font             = Enum.Font.Gotham,
        TextSize         = 11,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = row.ZIndex + 1,
        Parent           = row,
    })
end

-- ── SEARCHBAR ─────────────────────────────────────────────
function Section:AddSearchBar(cfg)
    cfg = cfg or {}
    local f, T = CompFrame(self, 34)

    local bg = New("Frame", {
        Size                = UDim2.new(1, 0, 1, 0),
        BackgroundColor3    = T.DropdownBg,
        BackgroundTransparency = 0.1,
        ZIndex              = f.ZIndex + 1,
        Parent              = f,
    })
    AddCorner(bg, 8)
    AddStroke(bg, T.Border, 1, 0.6)

    New("ImageLabel", {
        Size                  = UDim2.new(0, 16, 0, 16),
        Position              = UDim2.new(0, 10, 0.5, -8),
        BackgroundTransparency = 1,
        Image                 = "rbxassetid://3926305904",
        ImageRectOffset       = Vector2.new(964, 324),
        ImageRectSize         = Vector2.new(36, 36),
        ImageColor3           = T.TextMuted,
        ZIndex                = bg.ZIndex + 1,
        Parent                = bg,
    })

    local input = New("TextBox", {
        Size                  = UDim2.new(1, -40, 1, 0),
        Position              = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text                  = "",
        PlaceholderText       = cfg.Placeholder or "Search...",
        TextColor3            = T.Text,
        PlaceholderColor3     = T.TextMuted,
        Font                  = Enum.Font.Gotham,
        TextSize              = 12,
        ClearTextOnFocus      = false,
        ZIndex                = bg.ZIndex + 1,
        Parent                = bg,
    })

    input.Focused:Connect(function()
        Tween(bg:FindFirstChildOfClass("UIStroke"), { Transparency = 0.1, Color = T.Accent }, 0.15)
    end)
    input.FocusLost:Connect(function()
        Tween(bg:FindFirstChildOfClass("UIStroke"), { Transparency = 0.6, Color = T.Border }, 0.15)
    end)
    input:GetPropertyChangedSignal("Text"):Connect(function()
        if cfg.Callback then cfg.Callback(input.Text) end
    end)

    local obj = {}
    function obj:Get() return input.Text end
    function obj:Set(t) input.Text = t end
    return obj
end

-- ============================================================
--  PATCH METATABLES (Tab uses Section methods via Window)
-- ============================================================

for k, v in pairs(Section) do
    Tab[k] = Tab[k] or v
end

-- ============================================================
--  THEME SWITCHER
-- ============================================================

function Window:SetTheme(name)
    local theme = Themes[name]
    if not theme then return end
    self.Theme = theme
    self.T     = theme
    -- Note: Full runtime re-theming would require iterating all children.
    -- For practical use, call SetTheme before adding components.
end

-- ============================================================
--  DEMO USAGE (remove in production)
-- ============================================================

--[[
    -- EXAMPLE USAGE:
    local NexusUI = require(script) -- or loadstring

    local Win = NexusUI:CreateWindow({
        Title    = "SYSTEM INTERFACE",
        SubTitle = "NexusUI v1.0 — By CoiledTom",
        Theme    = "Holographic",
        Size     = UDim2.new(0, 620, 0, 460),
        Blur     = true,
        Sounds   = true,
        ToggleKey = Enum.KeyCode.RightShift,
    })

    -- STATUS TAB
    local statusTab = Win:AddTab({ Title = "Status" })
    local infoSec   = statusTab:AddSection({ Title = "Hunter Profile" })
    infoSec:AddAvatar({})
    infoSec:AddSeparator({ Title = "Stats" })
    infoSec:AddProgressBar({ Title = "EXP", Value = 72, Max = 100 })
    infoSec:AddLabel({ Title = "Class: Shadow Monarch" })
    infoSec:AddParagraph({ Content = "Arise! Summon shadows and conquer dungeons." })

    -- COMBAT TAB
    local combatTab = Win:AddTab({ Title = "Combat" })
    local combatSec = combatTab:AddSection({ Title = "Auto Combat" })
    combatSec:AddToggle({ Title = "Auto Attack",  Default = false, Callback = function(v) print("AutoAtk:", v) end })
    combatSec:AddToggle({ Title = "Auto Dodge",   Default = true,  Callback = function(v) print("Dodge:", v) end })
    combatSec:AddSlider({ Title = "Attack Speed", Min = 1, Max = 10, Default = 5, Suffix = "x", Callback = function(v) print("Speed:", v) end })
    combatSec:AddDropdown({ Title = "Target Mode", Options = {"Nearest","Weakest","Strongest"}, Default = "Nearest", Callback = function(v) print(v) end })
    combatSec:AddButton({ Title = "Start Hunt", Callback = function()
        Win:Notify({ Title = "HUNT STARTED", Desc = "Shadow soldiers have been deployed.", Type = "success", Duration = 4 })
    end})

    -- SETTINGS TAB
    local settTab = Win:AddTab({ Title = "Settings" })
    local settSec = settTab:AddSection({ Title = "Interface" })
    settSec:AddColorPicker({ Title = "Accent Color", Default = Color3.fromRGB(0,200,255), Callback = function(c) print(c) end })
    settSec:AddKeybind({ Title = "Toggle Key", Default = Enum.KeyCode.RightShift, Callback = function(k) print(k) end })
    settSec:AddTextBox({ Title = "Hub Name", Placeholder = "Enter name...", Callback = function(t) print(t) end })
    settSec:AddSearchBar({ Placeholder = "Search settings...", Callback = function(t) print(t) end })
    settSec:AddSeparator({ Title = "Theme" })
    settSec:AddMultiDropdown({ Title = "Active Modules", Options = {"ESP","Aimbot","Speed","Fly","NoClip"}, Callback = function(sel) print(sel) end })
--]]

-- ============================================================
--  RETURN LIBRARY
-- ============================================================

return NexusUI
