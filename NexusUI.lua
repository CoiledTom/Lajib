-- =========================================================================
--  ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
--  ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
--  ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
--  ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
--  ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║
--  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝
--
--  NexusUI v1.0 — Manhwa/Holographic UI Library
--  Created by CoiledTom
--  Icons by Footagesus: github.com/Footagesus/Icons
-- =========================================================================

local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")

local Player   = Players.LocalPlayer
local Mouse    = Player:GetMouse()

-- =========================================================================
-- [ TEMAS ]
-- =========================================================================
local Themes = {
    Holographic = {
        Background     = Color3.fromRGB(10, 15, 25),
        Surface        = Color3.fromRGB(15, 22, 38),
        Accent         = Color3.fromRGB(0, 220, 255),
        AccentGlow     = Color3.fromRGB(0, 160, 200),
        SecondAccent   = Color3.fromRGB(120, 80, 255),
        Text           = Color3.fromRGB(240, 240, 255),
        DimText        = Color3.fromRGB(130, 145, 170),
        TabActive      = Color3.fromRGB(0, 180, 220),
        SectionBg      = Color3.fromRGB(12, 18, 32),
        ComponentBg    = Color3.fromRGB(18, 25, 42),
        StrokeColor    = Color3.fromRGB(0, 120, 160),
        ToggleOff      = Color3.fromRGB(35, 42, 60),
        Success        = Color3.fromRGB(0, 220, 120),
        Error          = Color3.fromRGB(255, 60, 80),
        Warning        = Color3.fromRGB(255, 180, 0),
        Info           = Color3.fromRGB(0, 180, 255),
        GlassTransp    = 0.25,
    },
    Crimson = {
        Background     = Color3.fromRGB(18, 8, 10),
        Surface        = Color3.fromRGB(28, 12, 16),
        Accent         = Color3.fromRGB(255, 50, 80),
        AccentGlow     = Color3.fromRGB(200, 30, 55),
        SecondAccent   = Color3.fromRGB(255, 120, 60),
        Text           = Color3.fromRGB(255, 235, 240),
        DimText        = Color3.fromRGB(180, 130, 140),
        TabActive      = Color3.fromRGB(220, 40, 65),
        SectionBg      = Color3.fromRGB(20, 10, 13),
        ComponentBg    = Color3.fromRGB(30, 14, 18),
        StrokeColor    = Color3.fromRGB(160, 25, 45),
        ToggleOff      = Color3.fromRGB(50, 25, 30),
        Success        = Color3.fromRGB(0, 220, 120),
        Error          = Color3.fromRGB(255, 60, 80),
        Warning        = Color3.fromRGB(255, 180, 0),
        Info           = Color3.fromRGB(255, 100, 50),
        GlassTransp    = 0.25,
    },
    Void = {
        Background     = Color3.fromRGB(8, 6, 16),
        Surface        = Color3.fromRGB(14, 10, 28),
        Accent         = Color3.fromRGB(160, 80, 255),
        AccentGlow     = Color3.fromRGB(110, 50, 200),
        SecondAccent   = Color3.fromRGB(200, 100, 255),
        Text           = Color3.fromRGB(230, 225, 255),
        DimText        = Color3.fromRGB(140, 125, 175),
        TabActive      = Color3.fromRGB(140, 65, 230),
        SectionBg      = Color3.fromRGB(10, 8, 20),
        ComponentBg    = Color3.fromRGB(18, 13, 35),
        StrokeColor    = Color3.fromRGB(90, 40, 160),
        ToggleOff      = Color3.fromRGB(35, 25, 55),
        Success        = Color3.fromRGB(0, 220, 120),
        Error          = Color3.fromRGB(255, 60, 80),
        Warning        = Color3.fromRGB(255, 180, 0),
        Info           = Color3.fromRGB(160, 100, 255),
        GlassTransp    = 0.25,
    },
}

-- =========================================================================
-- [ ÍCONES LUCIDE — via IconBrowser de Footagesus ]
-- =========================================================================
local Icons = {}
local ICON_REPO = "https://raw.githubusercontent.com/Footagesus/Icons/main/"

local function GetIcon(name)
    if Icons[name] then return Icons[name] end
    local ok, data = pcall(function()
        return game:HttpGet(ICON_REPO .. name .. ".png")
    end)
    return nil
end

local function ApplyIcon(imageLabel, iconName, color)
    if not iconName or iconName == "" then return end
    -- Usa o IconBrowser do Footagesus (asset IDs mapeados)
    -- Fallback: tenta carregar via HttpGet se for URL
    local cleanName = iconName:gsub("lucide%-", "")
    -- O IconBrowser carrega como ImageLabel via seu sistema interno
    -- Para compatibilidade total, usamos uma tabela de asset IDs conhecidos
    -- e deixamos o dev expandir via IconBrowser.lua no mesmo repo
    local knownIcons = {
        ["swords"]         = "rbxassetid://11293977920",
        ["shield"]         = "rbxassetid://11293978153",
        ["settings"]       = "rbxassetid://11293978320",
        ["user"]           = "rbxassetid://11293977605",
        ["home"]           = "rbxassetid://11293977418",
        ["zap"]            = "rbxassetid://11293978460",
        ["star"]           = "rbxassetid://11293978240",
        ["heart"]          = "rbxassetid://11293977720",
        ["target"]         = "rbxassetid://11293978350",
        ["code"]           = "rbxassetid://11293977248",
        ["globe"]          = "rbxassetid://11293977680",
        ["lock"]           = "rbxassetid://11293977820",
        ["unlock"]         = "rbxassetid://11293978010",
        ["eye"]            = "rbxassetid://11293977530",
        ["bell"]           = "rbxassetid://11293977160",
        ["search"]         = "rbxassetid://11293978100",
        ["trash"]          = "rbxassetid://11293977960",
        ["edit"]           = "rbxassetid://11293977500",
        ["plus"]           = "rbxassetid://11293978060",
        ["minus"]          = "rbxassetid://11293977870",
        ["x"]              = "rbxassetid://11293978110",
        ["check"]          = "rbxassetid://11293977210",
        ["chevron-right"]  = "rbxassetid://11293977230",
        ["chevron-down"]   = "rbxassetid://11293977220",
        ["list"]           = "rbxassetid://11293977800",
        ["layers"]         = "rbxassetid://11293977760",
        ["cpu"]            = "rbxassetid://11293977290",
        ["activity"]       = "rbxassetid://11293977120",
        ["alert-triangle"] = "rbxassetid://11293977130",
        ["info"]           = "rbxassetid://11293977740",
    }
    local assetId = knownIcons[cleanName]
    if assetId and imageLabel then
        imageLabel.Image = assetId
        if color then
            imageLabel.ImageColor3 = color
        end
    end
end

-- =========================================================================
-- [ UTILITÁRIOS ]
-- =========================================================================
local function Tween(obj, props, t, style, dir)
    t     = t     or 0.3
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
    tw:Play()
    return tw
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function RippleEffect(btn, theme)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = theme.Accent
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = btn.ZIndex + 1
    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
    local mp = UserInputService:GetMouseLocation()
    local abs = btn.AbsolutePosition
    ripple.Position = UDim2.new(0, mp.X - abs.X, 0, mp.Y - abs.Y)
    ripple.Parent = btn
    Tween(ripple, {Size = UDim2.new(0, btn.AbsoluteSize.X * 2.5, 0, btn.AbsoluteSize.X * 2.5), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quad)
    task.delay(0.5, function() ripple:Destroy() end)
end

-- Config DataStore via writefile/readfile (executores modernos)
local function SaveData(key, data)
    pcall(function()
        local encoded = HttpService:JSONEncode(data)
        writefile("NexusUI_" .. key .. ".json", encoded)
    end)
end

local function LoadData(key)
    local ok, result = pcall(function()
        if isfile("NexusUI_" .. key .. ".json") then
            return HttpService:JSONDecode(readfile("NexusUI_" .. key .. ".json"))
        end
    end)
    if ok and result then return result end
    return {}
end

-- =========================================================================
-- [ BIBLIOTECA PRINCIPAL ]
-- =========================================================================
local NexusUI = {}
NexusUI.__index = NexusUI
local UI_NAME = "NexusUI_Main"

-- =========================================================================
-- [ NOTIFICAÇÕES ]
-- =========================================================================
local NotifGui = nil
local function EnsureNotifGui(theme)
    if CoreGui:FindFirstChild("NexusUI_Notifs") then
        NotifGui = CoreGui:FindFirstChild("NexusUI_Notifs")
        return
    end
    NotifGui = Instance.new("ScreenGui")
    NotifGui.Name        = "NexusUI_Notifs"
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotifGui.ResetOnSpawn = false
    NotifGui.Parent      = CoreGui

    local Container = Instance.new("Frame")
    Container.Name              = "Container"
    Container.Size              = UDim2.new(0, 290, 1, -20)
    Container.Position          = UDim2.new(1, -305, 0, 10)
    Container.BackgroundTransparency = 1
    Container.Parent            = NotifGui

    local Layout = Instance.new("UIListLayout")
    Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    Layout.Padding           = UDim.new(0, 8)
    Layout.Parent            = Container
end

local function Notify(theme, cfg)
    EnsureNotifGui(theme)
    local title    = cfg.Title    or "Nexus"
    local desc     = cfg.Desc     or ""
    local notType  = cfg.Type     or "info"
    local duration = cfg.Duration or 4

    local typeColors = {
        success = theme.Success,
        error   = theme.Error,
        warning = theme.Warning,
        info    = theme.Info,
    }
    local typeIcons = {
        success = "check",
        error   = "x",
        warning = "alert-triangle",
        info    = "info",
    }
    local accentColor = typeColors[notType] or theme.Accent

    local Container = NotifGui:FindFirstChild("Container")

    local NFrame = Instance.new("Frame")
    NFrame.Size                  = UDim2.new(1, 30, 0, 72)
    NFrame.BackgroundColor3      = theme.Surface
    NFrame.BackgroundTransparency = 0.1
    NFrame.ClipsDescendants      = true
    NFrame.Parent                = Container

    Instance.new("UICorner", NFrame).CornerRadius = UDim.new(0, 8)

    local NStroke = Instance.new("UIStroke", NFrame)
    NStroke.Color       = accentColor
    NStroke.Thickness   = 1.2
    NStroke.Transparency = 0.3

    -- Barra lateral colorida
    local SideBar = Instance.new("Frame")
    SideBar.Size            = UDim2.new(0, 3, 1, 0)
    SideBar.BackgroundColor3 = accentColor
    SideBar.BorderSizePixel  = 0
    SideBar.Parent          = NFrame
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 4)

    -- Ícone de tipo
    local IcoImg = Instance.new("ImageLabel")
    IcoImg.Size                   = UDim2.new(0, 16, 0, 16)
    IcoImg.Position               = UDim2.new(0, 14, 0, 10)
    IcoImg.BackgroundTransparency = 1
    IcoImg.ImageColor3            = accentColor
    IcoImg.Parent                 = NFrame
    ApplyIcon(IcoImg, "lucide-" .. (typeIcons[notType] or "info"), accentColor)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size              = UDim2.new(1, -70, 0, 20)
    TitleLbl.Position          = UDim2.new(0, 36, 0, 8)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text              = title
    TitleLbl.TextColor3        = accentColor
    TitleLbl.Font              = Enum.Font.GothamBold
    TitleLbl.TextSize          = 13
    TitleLbl.TextXAlignment    = Enum.TextXAlignment.Left
    TitleLbl.Parent            = NFrame

    local DescLbl = Instance.new("TextLabel")
    DescLbl.Size              = UDim2.new(1, -20, 0, 36)
    DescLbl.Position          = UDim2.new(0, 14, 0, 30)
    DescLbl.BackgroundTransparency = 1
    DescLbl.Text              = desc
    DescLbl.TextColor3        = theme.DimText
    DescLbl.Font              = Enum.Font.GothamMedium
    DescLbl.TextSize          = 11
    DescLbl.TextWrapped       = true
    DescLbl.TextXAlignment    = Enum.TextXAlignment.Left
    DescLbl.Parent            = NFrame

    -- Barra de progresso
    local ProgressBg = Instance.new("Frame")
    ProgressBg.Size            = UDim2.new(1, 0, 0, 2)
    ProgressBg.Position        = UDim2.new(0, 0, 1, -2)
    ProgressBg.BackgroundColor3 = theme.ToggleOff
    ProgressBg.BorderSizePixel  = 0
    ProgressBg.Parent          = NFrame

    local ProgressFill = Instance.new("Frame")
    ProgressFill.Size            = UDim2.new(1, 0, 1, 0)
    ProgressFill.BackgroundColor3 = accentColor
    ProgressFill.BorderSizePixel  = 0
    ProgressFill.Parent          = ProgressBg

    -- Animação entrada
    NFrame.Position = UDim2.new(0, 40, 0, 0)
    NFrame.BackgroundTransparency = 1
    Tween(NFrame, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.1}, 0.4, Enum.EasingStyle.Back)
    Tween(NStroke, {Transparency = 0.3}, 0.4)

    -- Progresso e saída
    Tween(ProgressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    task.delay(duration, function()
        local out = Tween(NFrame, {Position = UDim2.new(0, 40, 0, 0), BackgroundTransparency = 1}, 0.35)
        out.Completed:Wait()
        NFrame:Destroy()
    end)
end

-- =========================================================================
-- [ CREATE WINDOW ]
-- =========================================================================
function NexusUI:CreateWindow(cfg)
    cfg = cfg or {}

    local themeName  = cfg.Theme     or "Holographic"
    local theme      = Themes[themeName] or Themes.Holographic
    local winTitle   = cfg.Title     or "SYSTEM INTERFACE"
    local winSub     = cfg.SubTitle  or "NexusUI v1.0"
    local useBlur    = cfg.Blur      ~= false
    local winSize    = cfg.Size      or UDim2.new(0, 620, 0, 460)
    local toggleKey  = cfg.ToggleKey or Enum.KeyCode.RightShift

    -- Limpa GUI antiga
    if CoreGui:FindFirstChild(UI_NAME) then
        CoreGui[UI_NAME]:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name          = UI_NAME
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn  = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent        = CoreGui

    -- Blur
    local BlurEffect = nil
    if useBlur then
        BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Name   = "NexusBlur"
        BlurEffect.Size   = 0
        BlurEffect.Parent = Lighting
        Tween(BlurEffect, {Size = 14}, 0.5)
    end

    -- ===== JANELA PRINCIPAL =====
    local W = winSize
    local MainFrame = Instance.new("Frame")
    MainFrame.Name                  = "MainFrame"
    MainFrame.Size                  = UDim2.new(0, 0, 0, 0)
    MainFrame.Position              = UDim2.new(0.5, -W.X.Offset/2, 0.5, -W.Y.Offset/2)
    MainFrame.BackgroundColor3      = theme.Background
    MainFrame.BackgroundTransparency = theme.GlassTransp
    MainFrame.ClipsDescendants      = true
    MainFrame.Parent                = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local WinStroke = Instance.new("UIStroke", MainFrame)
    WinStroke.Color       = theme.Accent
    WinStroke.Thickness   = 1.5
    WinStroke.Transparency = 0.15

    -- Animação de abertura
    Tween(MainFrame, {Size = W}, 0.55, Enum.EasingStyle.Exponential)

    -- ===== HEADER BAR =====
    local Header = Instance.new("Frame")
    Header.Name             = "Header"
    Header.Size             = UDim2.new(1, 0, 0, 52)
    Header.BackgroundColor3 = theme.Surface
    Header.BackgroundTransparency = 0.2
    Header.BorderSizePixel  = 0
    Header.ZIndex           = 3
    Header.Parent           = MainFrame

    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

    -- Linha inferior do header
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size            = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position        = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = theme.Accent
    HeaderLine.BackgroundTransparency = 0.6
    HeaderLine.BorderSizePixel  = 0
    HeaderLine.Parent          = Header

    -- Ícone decorativo esquerdo
    local AccentDot = Instance.new("Frame")
    AccentDot.Size            = UDim2.new(0, 3, 0, 30)
    AccentDot.Position        = UDim2.new(0, 12, 0.5, -15)
    AccentDot.BackgroundColor3 = theme.Accent
    AccentDot.BorderSizePixel  = 0
    AccentDot.Parent          = Header
    Instance.new("UICorner", AccentDot).CornerRadius = UDim.new(1, 0)

    -- Títulos
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size              = UDim2.new(0, 350, 0, 20)
    TitleLbl.Position          = UDim2.new(0, 22, 0, 7)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text              = winTitle
    TitleLbl.TextColor3        = theme.Accent
    TitleLbl.Font              = Enum.Font.GothamBold
    TitleLbl.TextSize          = 15
    TitleLbl.TextXAlignment    = Enum.TextXAlignment.Left
    TitleLbl.ZIndex            = 4
    TitleLbl.Parent            = Header

    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size              = UDim2.new(0, 350, 0, 14)
    SubLbl.Position          = UDim2.new(0, 22, 0, 27)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text              = winSub
    SubLbl.TextColor3        = theme.DimText
    SubLbl.Font              = Enum.Font.Gotham
    SubLbl.TextSize          = 11
    SubLbl.TextXAlignment    = Enum.TextXAlignment.Left
    SubLbl.ZIndex            = 4
    SubLbl.Parent            = Header

    local AuthorLbl = Instance.new("TextLabel")
    AuthorLbl.Size              = UDim2.new(0, 200, 0, 12)
    AuthorLbl.Position          = UDim2.new(0, 22, 0, 40)
    AuthorLbl.BackgroundTransparency = 1
    AuthorLbl.Text              = "Created by CoiledTom"
    AuthorLbl.TextColor3        = Color3.fromRGB(80, 90, 110)
    AuthorLbl.Font              = Enum.Font.Gotham
    AuthorLbl.TextSize          = 9
    AuthorLbl.TextXAlignment    = Enum.TextXAlignment.Left
    AuthorLbl.ZIndex            = 4
    AuthorLbl.Parent            = Header

    -- ===== BOTÕES DE JANELA =====
    local function MakeWinBtn(symbol, posOffset, hoverColor)
        local Btn = Instance.new("TextButton")
        Btn.Size              = UDim2.new(0, 22, 0, 22)
        Btn.Position          = UDim2.new(1, posOffset, 0.5, -11)
        Btn.BackgroundColor3  = theme.ComponentBg
        Btn.BackgroundTransparency = 0.3
        Btn.Text              = symbol
        Btn.TextColor3        = theme.DimText
        Btn.Font              = Enum.Font.GothamBold
        Btn.TextSize          = 12
        Btn.ZIndex            = 5
        Btn.Parent            = Header
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color       = theme.StrokeColor
        Stroke.Transparency = 0.7
        Btn.MouseEnter:Connect(function()
            Tween(Btn, {BackgroundColor3 = hoverColor, TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
            Tween(Stroke, {Transparency = 0.3}, 0.15)
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Btn, {BackgroundColor3 = theme.ComponentBg, TextColor3 = theme.DimText}, 0.15)
            Tween(Stroke, {Transparency = 0.7}, 0.15)
        end)
        return Btn
    end

    local CloseBtn    = MakeWinBtn("✕", -34, theme.Error)
    local MaxBtn      = MakeWinBtn("□", -60, theme.Accent)
    local MinBtn      = MakeWinBtn("−", -86, theme.Warning)

    -- ===== TABS SIDEBAR =====
    local TabSide = Instance.new("Frame")
    TabSide.Name             = "TabSide"
    TabSide.Size             = UDim2.new(0, 155, 1, -58)
    TabSide.Position         = UDim2.new(0, 0, 0, 53)
    TabSide.BackgroundColor3 = theme.SectionBg
    TabSide.BackgroundTransparency = 0.35
    TabSide.BorderSizePixel  = 0
    TabSide.Parent           = MainFrame

    local TabSideStroke = Instance.new("UIStroke", TabSide)
    TabSideStroke.Color       = theme.StrokeColor
    TabSideStroke.Thickness   = 1
    TabSideStroke.Transparency = 0.6
    TabSideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size                 = UDim2.new(1, -8, 1, -10)
    TabScroll.Position             = UDim2.new(0, 4, 0, 5)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness   = 2
    TabScroll.ScrollBarImageColor3 = theme.Accent
    TabScroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
    TabScroll.Parent               = TabSide

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding   = UDim.new(0, 4)
    TabLayout.Parent    = TabScroll

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingTop    = UDim.new(0, 4)
    TabPad.PaddingBottom = UDim.new(0, 4)
    TabPad.Parent        = TabScroll

    -- ===== PAGE CONTAINER =====
    local PageCont = Instance.new("Frame")
    PageCont.Name             = "PageCont"
    PageCont.Size             = UDim2.new(1, -163, 1, -62)
    PageCont.Position         = UDim2.new(0, 158, 0, 57)
    PageCont.BackgroundTransparency = 1
    PageCont.ClipsDescendants = true
    PageCont.Parent           = MainFrame

    -- ===== ESTADO DA JANELA =====
    local WindowObj   = {}
    local tabsList    = {}
    local activeTab   = nil
    local isMinimized = false
    local isVisible   = true
    local configData  = LoadData(winTitle:gsub("%s","_"))

    -- Draggable pelo header
    MakeDraggable(MainFrame, Header)

    -- ===== FECHAR =====
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Exponential)
        if BlurEffect then Tween(BlurEffect, {Size = 0}, 0.4) end
        task.delay(0.45, function()
            ScreenGui:Destroy()
            if BlurEffect then BlurEffect:Destroy() end
        end)
    end)

    -- ===== MINIMIZAR =====
    MinBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            isMinimized = false
            Tween(MainFrame, {Size = W}, 0.4, Enum.EasingStyle.Back)
        else
            isMinimized = true
            Tween(MainFrame, {Size = UDim2.new(W.X.Scale, W.X.Offset, 0, 52)}, 0.35, Enum.EasingStyle.Quart)
        end
    end)

    -- ===== RESTAURAR =====
    MaxBtn.MouseButton1Click:Connect(function()
        isMinimized = false
        Tween(MainFrame, {Size = W}, 0.4, Enum.EasingStyle.Back)
    end)

    -- ===== TOGGLE KEY =====
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == toggleKey then
            isVisible = not isVisible
            if isVisible then
                MainFrame.Visible = true
                Tween(MainFrame, {Size = W}, 0.4, Enum.EasingStyle.Back)
                if BlurEffect then Tween(BlurEffect, {Size = 14}, 0.4) end
            else
                local t = Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.35, Enum.EasingStyle.Quart)
                if BlurEffect then Tween(BlurEffect, {Size = 0}, 0.35) end
                t.Completed:Connect(function() MainFrame.Visible = false end)
            end
        end
    end)

    -- ===== NOTIFY =====
    function WindowObj:Notify(cfg2)
        Notify(theme, cfg2)
    end

    -- ===== SAVE / LOAD CONFIG =====
    function WindowObj:SaveConfig()
        SaveData(winTitle:gsub("%s","_"), configData)
    end
    function WindowObj:LoadConfig()
        configData = LoadData(winTitle:gsub("%s","_"))
    end

    -- =========================================================================
    -- [ ADD TAB ]
    -- =========================================================================
    function WindowObj:AddTab(tabCfg)
        tabCfg = tabCfg or {}
        local tabTitle = tabCfg.Title or "Tab"
        local tabIcon  = tabCfg.Icon  or ""

        -- Botão da aba
        local TabBtn = Instance.new("Frame")
        TabBtn.Size             = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = theme.ComponentBg
        TabBtn.BackgroundTransparency = 1
        TabBtn.Parent           = TabScroll
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 7)

        local TabBtnStroke = Instance.new("UIStroke", TabBtn)
        TabBtnStroke.Color        = theme.Accent
        TabBtnStroke.Transparency = 1
        TabBtnStroke.Thickness    = 1

        -- Ícone
        local TabIco = Instance.new("ImageLabel")
        TabIco.Size                   = UDim2.new(0, 14, 0, 14)
        TabIco.Position               = UDim2.new(0, 10, 0.5, -7)
        TabIco.BackgroundTransparency = 1
        TabIco.ImageColor3            = theme.DimText
        TabIco.Parent                 = TabBtn
        if tabIcon ~= "" then
            ApplyIcon(TabIco, tabIcon, theme.DimText)
        end

        local TabTxt = Instance.new("TextLabel")
        TabTxt.Size              = UDim2.new(1, tabIcon ~= "" and -30 or -16, 1, 0)
        TabTxt.Position          = UDim2.new(0, tabIcon ~= "" and 28 or 10, 0, 0)
        TabTxt.BackgroundTransparency = 1
        TabTxt.Text              = tabTitle
        TabTxt.TextColor3        = theme.DimText
        TabTxt.Font              = Enum.Font.GothamMedium
        TabTxt.TextSize          = 13
        TabTxt.TextXAlignment    = Enum.TextXAlignment.Left
        TabTxt.Parent            = TabBtn

        local TabHitbox = Instance.new("TextButton")
        TabHitbox.Size              = UDim2.new(1, 0, 1, 0)
        TabHitbox.BackgroundTransparency = 1
        TabHitbox.Text              = ""
        TabHitbox.ZIndex            = 2
        TabHitbox.Parent            = TabBtn

        -- Indicador lateral ativo
        local ActiveBar = Instance.new("Frame")
        ActiveBar.Size            = UDim2.new(0, 3, 0, 0)
        ActiveBar.Position        = UDim2.new(0, 0, 0.5, 0)
        ActiveBar.AnchorPoint     = Vector2.new(0, 0.5)
        ActiveBar.BackgroundColor3 = theme.Accent
        ActiveBar.BorderSizePixel  = 0
        ActiveBar.Parent          = TabBtn
        Instance.new("UICorner", ActiveBar).CornerRadius = UDim.new(1, 0)

        -- Página
        local Page = Instance.new("ScrollingFrame")
        Page.Size                 = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness   = 2
        Page.ScrollBarImageColor3 = theme.Accent
        Page.CanvasSize           = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize  = Enum.AutomaticSize.Y
        Page.Visible              = false
        Page.Parent               = PageCont

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding   = UDim.new(0, 8)
        PageLayout.Parent    = Page

        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop    = UDim.new(0, 6)
        PagePad.PaddingBottom = UDim.new(0, 10)
        PagePad.PaddingLeft   = UDim.new(0, 4)
        PagePad.PaddingRight  = UDim.new(0, 4)
        PagePad.Parent        = Page

        local tabData = {Button = TabBtn, Page = Page, ActiveBar = ActiveBar, Txt = TabTxt, Ico = TabIco, BtnStroke = TabBtnStroke}
        table.insert(tabsList, tabData)

        local function ActivateTab()
            for _, td in pairs(tabsList) do
                Tween(td.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(td.BtnStroke, {Transparency = 1}, 0.2)
                Tween(td.Txt, {TextColor3 = theme.DimText}, 0.2)
                Tween(td.ActiveBar, {Size = UDim2.new(0, 3, 0, 0)}, 0.25, Enum.EasingStyle.Back)
                td.Page.Visible = false
                if td.Ico then Tween(td.Ico, {ImageColor3 = theme.DimText}, 0.2) end
            end
            Tween(TabBtn, {BackgroundTransparency = 0.65}, 0.25)
            Tween(TabBtnStroke, {Transparency = 0.5}, 0.25)
            Tween(TabTxt, {TextColor3 = theme.Accent}, 0.25)
            Tween(ActiveBar, {Size = UDim2.new(0, 3, 0, 22)}, 0.3, Enum.EasingStyle.Back)
            if TabIco then Tween(TabIco, {ImageColor3 = theme.Accent}, 0.25) end
            -- Animação de entrada da página
            Page.Position = UDim2.new(0, 15, 0, 0)
            Page.GroupTransparency = 1
            Page.Visible  = true
            Tween(Page, {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}, 0.35, Enum.EasingStyle.Quart)
            activeTab = tabData
        end

        TabHitbox.MouseButton1Click:Connect(ActivateTab)
        TabHitbox.MouseEnter:Connect(function()
            if activeTab ~= tabData then
                Tween(TabBtn, {BackgroundTransparency = 0.82}, 0.15)
            end
        end)
        TabHitbox.MouseLeave:Connect(function()
            if activeTab ~= tabData then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)

        if #tabsList == 1 then ActivateTab() end

        -- =========================================================================
        -- [ TAB OBJECT ]
        -- =========================================================================
        local TabObj = {}

        -- ===== ADD SECTION =====
        function TabObj:AddSection(secCfg)
            secCfg = secCfg or {}
            local secTitle = secCfg.Title or "Section"
            local secIcon  = secCfg.Icon  or ""

            local SecFrame = Instance.new("Frame")
            SecFrame.Size             = UDim2.new(1, 0, 0, 32)
            SecFrame.AutomaticSize    = Enum.AutomaticSize.Y
            SecFrame.BackgroundColor3 = theme.SectionBg
            SecFrame.BackgroundTransparency = 0.3
            SecFrame.Parent           = Page
            Instance.new("UICorner", SecFrame).CornerRadius = UDim.new(0, 8)

            local SecStroke = Instance.new("UIStroke", SecFrame)
            SecStroke.Color       = theme.StrokeColor
            SecStroke.Transparency = 0.55
            SecStroke.Thickness   = 1

            local SecLayout = Instance.new("UIListLayout")
            SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SecLayout.Padding   = UDim.new(0, 5)
            SecLayout.Parent    = SecFrame

            local SecPad = Instance.new("UIPadding")
            SecPad.PaddingTop    = UDim.new(0, 8)
            SecPad.PaddingBottom = UDim.new(0, 8)
            SecPad.PaddingLeft   = UDim.new(0, 8)
            SecPad.PaddingRight  = UDim.new(0, 8)
            SecPad.Parent        = SecFrame

            -- Header da seção
            local SecHeader = Instance.new("Frame")
            SecHeader.Size             = UDim2.new(1, 0, 0, 20)
            SecHeader.BackgroundTransparency = 1
            SecHeader.LayoutOrder      = 0
            SecHeader.Parent           = SecFrame

            if secIcon ~= "" then
                local SIco = Instance.new("ImageLabel")
                SIco.Size                   = UDim2.new(0, 12, 0, 12)
                SIco.Position               = UDim2.new(0, 0, 0.5, -6)
                SIco.BackgroundTransparency = 1
                SIco.ImageColor3            = theme.Accent
                SIco.Parent                 = SecHeader
                ApplyIcon(SIco, secIcon, theme.Accent)
            end

            local SecTitleLbl = Instance.new("TextLabel")
            SecTitleLbl.Size              = UDim2.new(1, 0, 1, 0)
            SecTitleLbl.Position          = secIcon ~= "" and UDim2.new(0, 18, 0, 0) or UDim2.new(0, 0, 0, 0)
            SecTitleLbl.BackgroundTransparency = 1
            SecTitleLbl.Text              = secTitle
            SecTitleLbl.TextColor3        = theme.Accent
            SecTitleLbl.Font              = Enum.Font.GothamBold
            SecTitleLbl.TextSize          = 11
            SecTitleLbl.TextXAlignment    = Enum.TextXAlignment.Left
            SecTitleLbl.Parent            = SecHeader

            local SecLine = Instance.new("Frame")
            SecLine.Size             = UDim2.new(1, 0, 0, 1)
            SecLine.BackgroundColor3 = theme.StrokeColor
            SecLine.BackgroundTransparency = 0.5
            SecLine.BorderSizePixel  = 0
            SecLine.LayoutOrder      = 1
            SecLine.Parent           = SecFrame

            local SecObj = {}
            local compOrder = 2

            local function NextOrder()
                compOrder = compOrder + 1
                return compOrder
            end

            -- Helper: cria frame base de componente
            local function CompBase(h)
                h = h or 36
                local F = Instance.new("Frame")
                F.Size             = UDim2.new(1, 0, 0, h)
                F.BackgroundColor3 = theme.ComponentBg
                F.BackgroundTransparency = 0.45
                F.LayoutOrder      = NextOrder()
                F.Parent           = SecFrame
                Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
                local S = Instance.new("UIStroke", F)
                S.Color       = theme.StrokeColor
                S.Transparency = 0.7
                S.Thickness   = 1
                return F, S
            end

            local function CompLabel(parent, txt, xOff, yOff, w, h, color, font, size, xa)
                local L = Instance.new("TextLabel")
                L.Size              = UDim2.new(w or 0, 0, h or 1, 0)
                L.Position          = UDim2.new(0, xOff, 0, yOff or 0)
                L.BackgroundTransparency = 1
                L.Text              = txt
                L.TextColor3        = color or theme.Text
                L.Font              = font or Enum.Font.GothamMedium
                L.TextSize          = size or 13
                L.TextXAlignment    = xa or Enum.TextXAlignment.Left
                L.Parent            = parent
                return L
            end

            -- ===================================================
            -- ADD BUTTON
            -- ===================================================
            function SecObj:AddButton(bCfg)
                bCfg = bCfg or {}
                local F, S = CompBase(36)
                local hitbox = Instance.new("TextButton")
                hitbox.Size              = UDim2.new(1, 0, 1, 0)
                hitbox.BackgroundTransparency = 1
                hitbox.Text              = ""
                hitbox.ZIndex            = 2
                hitbox.ClipsDescendants  = true
                hitbox.Parent            = F

                if bCfg.Icon and bCfg.Icon ~= "" then
                    local BIco = Instance.new("ImageLabel")
                    BIco.Size                   = UDim2.new(0, 14, 0, 14)
                    BIco.Position               = UDim2.new(0, 10, 0.5, -7)
                    BIco.BackgroundTransparency = 1
                    BIco.ImageColor3            = theme.Accent
                    BIco.ZIndex                 = 3
                    BIco.Parent                 = F
                    ApplyIcon(BIco, bCfg.Icon, theme.Accent)
                end

                CompLabel(F, bCfg.Title or "Button", bCfg.Icon and 30 or 12, 0, 1, 1)

                -- Seta decorativa
                local Arrow = Instance.new("TextLabel")
                Arrow.Size              = UDim2.new(0, 20, 1, 0)
                Arrow.Position          = UDim2.new(1, -24, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text              = "›"
                Arrow.TextColor3        = theme.DimText
                Arrow.Font              = Enum.Font.GothamBold
                Arrow.TextSize          = 18
                Arrow.Parent            = F

                hitbox.MouseEnter:Connect(function()
                    Tween(F, {BackgroundTransparency = 0.15}, 0.15)
                    Tween(S, {Transparency = 0.3, Color = theme.Accent}, 0.15)
                    Tween(Arrow, {TextColor3 = theme.Accent}, 0.15)
                end)
                hitbox.MouseLeave:Connect(function()
                    Tween(F, {BackgroundTransparency = 0.45}, 0.15)
                    Tween(S, {Transparency = 0.7, Color = theme.StrokeColor}, 0.15)
                    Tween(Arrow, {TextColor3 = theme.DimText}, 0.15)
                end)
                hitbox.MouseButton1Down:Connect(function()
                    RippleEffect(hitbox, theme)
                    Tween(F, {BackgroundTransparency = 0.05}, 0.1)
                end)
                hitbox.MouseButton1Up:Connect(function()
                    Tween(F, {BackgroundTransparency = 0.15}, 0.1)
                    if bCfg.Callback then task.spawn(bCfg.Callback) end
                end)
            end

            -- ===================================================
            -- ADD TOGGLE
            -- ===================================================
            function SecObj:AddToggle(tCfg)
                tCfg = tCfg or {}
                local key     = tCfg.Flag    or tCfg.Title or tostring(math.random())
                local state   = configData[key] ~= nil and configData[key] or (tCfg.Default or false)

                local F, S = CompBase(36)
                CompLabel(F, tCfg.Title or "Toggle", 12, 0, 1, 1)

                local Switch = Instance.new("Frame")
                Switch.Size            = UDim2.new(0, 42, 0, 22)
                Switch.Position        = UDim2.new(1, -50, 0.5, -11)
                Switch.BackgroundColor3 = state and theme.AccentGlow or theme.ToggleOff
                Switch.Parent          = F
                Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

                local Circle = Instance.new("Frame")
                Circle.Size            = UDim2.new(0, 18, 0, 18)
                Circle.Position        = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                Circle.BackgroundColor3 = state and theme.Accent or theme.DimText
                Circle.Parent          = Switch
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

                -- Glow no circle
                local Glow = Instance.new("UIStroke", Circle)
                Glow.Color       = theme.Accent
                Glow.Transparency = state and 0.4 or 1
                Glow.Thickness   = 2

                local Hitbox = Instance.new("TextButton")
                Hitbox.Size              = UDim2.new(1, 0, 1, 0)
                Hitbox.BackgroundTransparency = 1
                Hitbox.Text              = ""
                Hitbox.Parent            = F

                local toggling = false
                Hitbox.MouseButton1Click:Connect(function()
                    if toggling then return end
                    toggling = true
                    state = not state
                    configData[key] = state
                    if state then
                        Tween(Circle, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = theme.Accent}, 0.25, Enum.EasingStyle.Back)
                        Tween(Switch, {BackgroundColor3 = theme.AccentGlow}, 0.25)
                        Tween(Glow, {Transparency = 0.4}, 0.25)
                    else
                        Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = theme.DimText}, 0.25, Enum.EasingStyle.Back)
                        Tween(Switch, {BackgroundColor3 = theme.ToggleOff}, 0.25)
                        Tween(Glow, {Transparency = 1}, 0.25)
                    end
                    task.delay(0.3, function() toggling = false end)
                    if tCfg.Callback then task.spawn(tCfg.Callback, state) end
                end)

                F.MouseEnter:Connect(function() Tween(S, {Transparency = 0.4, Color = theme.Accent}, 0.15) end)
                F.MouseLeave:Connect(function() Tween(S, {Transparency = 0.7, Color = theme.StrokeColor}, 0.15) end)

                local Ctrl = {}
                function Ctrl:Set(v)
                    state = v
                    configData[key] = v
                    if v then
                        Tween(Circle, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = theme.Accent}, 0.25)
                        Tween(Switch, {BackgroundColor3 = theme.AccentGlow}, 0.25)
                    else
                        Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = theme.DimText}, 0.25)
                        Tween(Switch, {BackgroundColor3 = theme.ToggleOff}, 0.25)
                    end
                end
                function Ctrl:Get() return state end
                return Ctrl
            end

            -- ===================================================
            -- ADD SLIDER
            -- ===================================================
            function SecObj:AddSlider(sCfg)
                sCfg = sCfg or {}
                local key   = sCfg.Flag    or sCfg.Title or tostring(math.random())
                local min   = sCfg.Min     or 0
                local max   = sCfg.Max     or 100
                local round = sCfg.Round   ~= false
                local val   = configData[key] ~= nil and configData[key] or (sCfg.Default or min)
                val = math.clamp(val, min, max)

                local F, S = CompBase(52)
                F.Size = UDim2.new(1, 0, 0, 52)

                CompLabel(F, sCfg.Title or "Slider", 12, 8, 0.7, 0, theme.Text, Enum.Font.GothamMedium, 13)

                local ValLbl = Instance.new("TextLabel")
                ValLbl.Size              = UDim2.new(0, 50, 0, 18)
                ValLbl.Position          = UDim2.new(1, -58, 0, 6)
                ValLbl.BackgroundTransparency = 1
                ValLbl.Text              = tostring(round and math.round(val) or val)
                ValLbl.TextColor3        = theme.Accent
                ValLbl.Font              = Enum.Font.GothamBold
                ValLbl.TextSize          = 13
                ValLbl.TextXAlignment    = Enum.TextXAlignment.Right
                ValLbl.Parent            = F

                -- Track
                local Track = Instance.new("Frame")
                Track.Size             = UDim2.new(1, -24, 0, 5)
                Track.Position         = UDim2.new(0, 12, 1, -14)
                Track.BackgroundColor3 = theme.ToggleOff
                Track.BorderSizePixel  = 0
                Track.Parent           = F
                Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame")
                Fill.Size             = UDim2.new((val - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = theme.Accent
                Fill.BorderSizePixel  = 0
                Fill.Parent           = Track
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                -- Thumb
                local Thumb = Instance.new("Frame")
                Thumb.Size            = UDim2.new(0, 14, 0, 14)
                Thumb.AnchorPoint     = Vector2.new(0.5, 0.5)
                Thumb.Position        = UDim2.new((val - min) / (max - min), 0, 0.5, 0)
                Thumb.BackgroundColor3 = theme.Accent
                Thumb.ZIndex          = 3
                Thumb.Parent          = Track
                Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)
                local ThumbGlow = Instance.new("UIStroke", Thumb)
                ThumbGlow.Color       = theme.Accent
                ThumbGlow.Transparency = 0.5
                ThumbGlow.Thickness   = 2

                local Hitbox = Instance.new("TextButton")
                Hitbox.Size              = UDim2.new(1, 0, 0, 28)
                Hitbox.Position          = UDim2.new(0, 0, 1, -22)
                Hitbox.BackgroundTransparency = 1
                Hitbox.Text              = ""
                Hitbox.ZIndex            = 4
                Hitbox.Parent            = F

                local dragging = false
                local function UpdateSlider(inputX)
                    local abs   = Track.AbsolutePosition
                    local tSize = Track.AbsoluteSize
                    local pct   = math.clamp((inputX - abs.X) / tSize.X, 0, 1)
                    local raw   = min + (max - min) * pct
                    local v     = round and math.round(raw) or (math.floor(raw * 100 + 0.5) / 100)
                    val = v
                    configData[key] = v
                    Fill.Size    = UDim2.new(pct, 0, 1, 0)
                    Thumb.Position = UDim2.new(pct, 0, 0.5, 0)
                    ValLbl.Text  = tostring(round and math.round(v) or v)
                    if sCfg.Callback then sCfg.Callback(v) end
                end

                Hitbox.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                       inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        Tween(Thumb, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
                        UpdateSlider(inp.Position.X)
                    end
                end)
                Hitbox.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                       inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        Tween(Thumb, {Size = UDim2.new(0, 14, 0, 14)}, 0.15)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or
                                     inp.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(inp.Position.X)
                    end
                end)

                F.MouseEnter:Connect(function() Tween(S, {Transparency = 0.4, Color = theme.Accent}, 0.15) end)
                F.MouseLeave:Connect(function() Tween(S, {Transparency = 0.7, Color = theme.StrokeColor}, 0.15) end)

                local Ctrl = {}
                function Ctrl:Set(v)
                    v = math.clamp(v, min, max)
                    val = v
                    local pct = (v - min) / (max - min)
                    Fill.Size  = UDim2.new(pct, 0, 1, 0)
                    Thumb.Position = UDim2.new(pct, 0, 0.5, 0)
                    ValLbl.Text = tostring(round and math.round(v) or v)
                end
                function Ctrl:Get() return val end
                return Ctrl
            end

            -- ===================================================
            -- ADD TEXTBOX / ADD INPUT
            -- ===================================================
            local function BuildTextbox(cfg2)
                cfg2 = cfg2 or {}
                local F, S = CompBase(44)
                F.Size = UDim2.new(1, 0, 0, 44)
                CompLabel(F, cfg2.Title or "Input", 12, 4, 0.6, 0, theme.DimText, Enum.Font.Gotham, 11)

                local TB = Instance.new("TextBox")
                TB.Size              = UDim2.new(1, -24, 0, 22)
                TB.Position          = UDim2.new(0, 12, 1, -26)
                TB.BackgroundColor3  = theme.SectionBg
                TB.BackgroundTransparency = 0.3
                TB.Text              = cfg2.Default or ""
                TB.PlaceholderText   = cfg2.Placeholder or "..."
                TB.PlaceholderColor3 = theme.DimText
                TB.TextColor3        = theme.Text
                TB.Font              = Enum.Font.GothamMedium
                TB.TextSize          = 13
                TB.TextXAlignment    = Enum.TextXAlignment.Left
                TB.ClearTextOnFocus  = cfg2.ClearOnFocus or false
                TB.Parent            = F
                Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 5)

                local TBStroke = Instance.new("UIStroke", TB)
                TBStroke.Color       = theme.StrokeColor
                TBStroke.Transparency = 0.6
                TBStroke.Thickness   = 1

                local TBPad = Instance.new("UIPadding", TB)
                TBPad.PaddingLeft = UDim.new(0, 8)

                TB.Focused:Connect(function() Tween(TBStroke, {Transparency = 0.2, Color = theme.Accent}, 0.2) end)
                TB.FocusLost:Connect(function(enter)
                    Tween(TBStroke, {Transparency = 0.6, Color = theme.StrokeColor}, 0.2)
                    if cfg2.Callback then cfg2.Callback(TB.Text, enter) end
                end)

                F.MouseEnter:Connect(function() Tween(S, {Transparency = 0.4, Color = theme.Accent}, 0.15) end)
                F.MouseLeave:Connect(function() Tween(S, {Transparency = 0.7, Color = theme.StrokeColor}, 0.15) end)

                local Ctrl = {}
                function Ctrl:Set(v) TB.Text = tostring(v) end
                function Ctrl:Get() return TB.Text end
                return Ctrl
            end

            function SecObj:AddTextbox(cfg2) return BuildTextbox(cfg2) end
            function SecObj:AddInput(cfg2)   return BuildTextbox(cfg2) end

            -- ===================================================
            -- ADD DROPDOWN
            -- ===================================================
            function SecObj:AddDropdown(dCfg)
                dCfg = dCfg or {}
                local key      = dCfg.Flag    or dCfg.Title or tostring(math.random())
                local options  = dCfg.Options or {}
                local selected = configData[key] or dCfg.Default or (options[1] or "")
                local open     = false

                local F, S = CompBase(36)
                CompLabel(F, dCfg.Title or "Dropdown", 12, 0, 0.55, 1, theme.Text)

                local SelLbl = Instance.new("TextLabel")
                SelLbl.Size              = UDim2.new(0.45, -30, 1, 0)
                SelLbl.Position          = UDim2.new(0.55, 0, 0, 0)
                SelLbl.BackgroundTransparency = 1
                SelLbl.Text              = tostring(selected)
                SelLbl.TextColor3        = theme.Accent
                SelLbl.Font              = Enum.Font.GothamMedium
                SelLbl.TextSize          = 12
                SelLbl.TextXAlignment    = Enum.TextXAlignment.Right
                SelLbl.TextTruncate      = Enum.TextTruncate.AtEnd
                SelLbl.Parent            = F

                local Arrow = Instance.new("TextLabel")
                Arrow.Size              = UDim2.new(0, 20, 1, 0)
                Arrow.Position          = UDim2.new(1, -24, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text              = "▾"
                Arrow.TextColor3        = theme.DimText
                Arrow.Font              = Enum.Font.GothamBold
                Arrow.TextSize          = 14
                Arrow.Parent            = F

                -- Menu dropdown
                local Menu = Instance.new("Frame")
                Menu.Size             = UDim2.new(1, 0, 0, 0)
                Menu.Position         = UDim2.new(0, 0, 1, 4)
                Menu.BackgroundColor3 = theme.Surface
                Menu.BackgroundTransparency = 0.05
                Menu.ClipsDescendants = true
                Menu.ZIndex           = 10
                Menu.Visible          = false
                Menu.Parent           = F
                Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 7)
                local MStroke = Instance.new("UIStroke", Menu)
                MStroke.Color     = theme.Accent
                MStroke.Transparency = 0.5
                MStroke.Thickness = 1

                local MScroll = Instance.new("ScrollingFrame")
                MScroll.Size                 = UDim2.new(1, 0, 1, 0)
                MScroll.BackgroundTransparency = 1
                MScroll.ScrollBarThickness   = 2
                MScroll.ScrollBarImageColor3 = theme.Accent
                MScroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
                MScroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
                MScroll.Parent               = Menu

                local MLayout = Instance.new("UIListLayout")
                MLayout.SortOrder = Enum.SortOrder.LayoutOrder
                MLayout.Parent    = MScroll

                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size              = UDim2.new(1, 0, 0, 28)
                    OptBtn.BackgroundTransparency = 1
                    OptBtn.Text              = "  " .. tostring(opt)
                    OptBtn.TextColor3        = opt == selected and theme.Accent or theme.DimText
                    OptBtn.Font              = Enum.Font.GothamMedium
                    OptBtn.TextSize          = 12
                    OptBtn.TextXAlignment    = Enum.TextXAlignment.Left
                    OptBtn.ZIndex            = 11
                    OptBtn.Parent            = MScroll

                    OptBtn.MouseEnter:Connect(function()
                        Tween(OptBtn, {BackgroundTransparency = 0.7}, 0.1)
                        OptBtn.TextColor3 = theme.Text
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        Tween(OptBtn, {BackgroundTransparency = 1}, 0.1)
                        OptBtn.TextColor3 = opt == selected and theme.Accent or theme.DimText
                    end)
                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        configData[key] = opt
                        SelLbl.Text = tostring(opt)
                        -- Reseta cores
                        for _, ch in ipairs(MScroll:GetChildren()) do
                            if ch:IsA("TextButton") then
                                ch.TextColor3 = ch.Text:gsub("^%s+","") == tostring(selected) and theme.Accent or theme.DimText
                            end
                        end
                        open = false
                        Tween(Menu, {Size = UDim2.new(1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quart)
                        task.delay(0.26, function() Menu.Visible = false end)
                        Tween(Arrow, {Rotation = 0}, 0.25)
                        if dCfg.Callback then dCfg.Callback(opt) end
                    end)
                end

                local Hitbox = Instance.new("TextButton")
                Hitbox.Size              = UDim2.new(1, 0, 1, 0)
                Hitbox.BackgroundTransparency = 1
                Hitbox.Text              = ""
                Hitbox.ZIndex            = 2
                Hitbox.Parent            = F

                local optH = math.min(#options * 28 + 4, 150)
                Hitbox.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        Menu.Visible = true
                        Tween(Menu, {Size = UDim2.new(1, 0, 0, optH)}, 0.3, Enum.EasingStyle.Back)
                        Tween(Arrow, {Rotation = 180}, 0.25)
                        Tween(S, {Transparency = 0.3, Color = theme.Accent}, 0.2)
                    else
                        Tween(Menu, {Size = UDim2.new(1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quart)
                        task.delay(0.26, function() Menu.Visible = false end)
                        Tween(Arrow, {Rotation = 0}, 0.25)
                        Tween(S, {Transparency = 0.7, Color = theme.StrokeColor}, 0.2)
                    end
                end)

                F.MouseEnter:Connect(function() if not open then Tween(S, {Transparency = 0.4, Color = theme.Accent}, 0.15) end end)
                F.MouseLeave:Connect(function() if not open then Tween(S, {Transparency = 0.7, Color = theme.StrokeColor}, 0.15) end end)

                local Ctrl = {}
                function Ctrl:Set(v) selected = v; SelLbl.Text = tostring(v); configData[key] = v end
                function Ctrl:Get() return selected end
                return Ctrl
            end

            -- ===================================================
            -- ADD MULTI DROPDOWN
            -- ===================================================
            function SecObj:AddMultiDropdown(dCfg)
                dCfg = dCfg or {}
                local key      = dCfg.Flag    or dCfg.Title or tostring(math.random())
                local options  = dCfg.Options or {}
                local selected = configData[key] or dCfg.Default or {}
                local open     = false

                local F, S = CompBase(36)
                CompLabel(F, dCfg.Title or "Multi Select", 12, 0, 0.55, 1, theme.Text)

                local SelLbl = Instance.new("TextLabel")
                SelLbl.Size              = UDim2.new(0.45, -30, 1, 0)
                SelLbl.Position          = UDim2.new(0.55, 0, 0, 0)
                SelLbl.BackgroundTransparency = 1
                SelLbl.Text              = #selected > 0 and table.concat(selected, ", ") or "None"
                SelLbl.TextColor3        = theme.Accent
                SelLbl.Font              = Enum.Font.GothamMedium
                SelLbl.TextSize          = 11
                SelLbl.TextXAlignment    = Enum.TextXAlignment.Right
                SelLbl.TextTruncate      = Enum.TextTruncate.AtEnd
                SelLbl.Parent            = F

                local Arrow = Instance.new("TextLabel")
                Arrow.Size              = UDim2.new(0, 20, 1, 0)
                Arrow.Position          = UDim2.new(1, -24, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text              = "▾"
                Arrow.TextColor3        = theme.DimText
                Arrow.Font              = Enum.Font.GothamBold
                Arrow.TextSize          = 14
                Arrow.Parent            = F

                local Menu = Instance.new("Frame")
                Menu.Size             = UDim2.new(1, 0, 0, 0)
                Menu.Position         = UDim2.new(0, 0, 1, 4)
                Menu.BackgroundColor3 = theme.Surface
                Menu.BackgroundTransparency = 0.05
                Menu.ClipsDescendants = true
                Menu.ZIndex           = 10
                Menu.Visible          = false
                Menu.Parent           = F
                Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 7)
                local MStroke2 = Instance.new("UIStroke", Menu)
                MStroke2.Color = theme.Accent; MStroke2.Transparency = 0.5; MStroke2.Thickness = 1

                local MScroll2 = Instance.new("ScrollingFrame")
                MScroll2.Size = UDim2.new(1,0,1,0); MScroll2.BackgroundTransparency=1
                MScroll2.ScrollBarThickness=2; MScroll2.ScrollBarImageColor3=theme.Accent
                MScroll2.CanvasSize=UDim2.new(0,0,0,0); MScroll2.AutomaticCanvasSize=Enum.AutomaticSize.Y
                MScroll2.Parent=Menu
                local ML2=Instance.new("UIListLayout"); ML2.SortOrder=Enum.SortOrder.LayoutOrder; ML2.Parent=MScroll2

                local function IsSelected(v)
                    for _,s in ipairs(selected) do if s==v then return true end end
                    return false
                end
                local function UpdateSelLabel()
                    SelLbl.Text = #selected>0 and table.concat(selected,", ") or "None"
                end

                for _,opt in ipairs(options) do
                    local Row=Instance.new("Frame"); Row.Size=UDim2.new(1,0,0,28); Row.BackgroundTransparency=1; Row.ZIndex=11; Row.Parent=MScroll2
                    local Check=Instance.new("Frame"); Check.Size=UDim2.new(0,14,0,14); Check.Position=UDim2.new(0,8,0.5,-7)
                    Check.BackgroundColor3=IsSelected(opt) and theme.Accent or theme.ToggleOff; Check.ZIndex=12; Check.Parent=Row
                    Instance.new("UICorner",Check).CornerRadius=UDim.new(0,3)
                    local OLbl=Instance.new("TextLabel"); OLbl.Size=UDim2.new(1,-30,1,0); OLbl.Position=UDim2.new(0,28,0,0)
                    OLbl.BackgroundTransparency=1; OLbl.Text=tostring(opt)
                    OLbl.TextColor3=IsSelected(opt) and theme.Text or theme.DimText
                    OLbl.Font=Enum.Font.GothamMedium; OLbl.TextSize=12; OLbl.TextXAlignment=Enum.TextXAlignment.Left; OLbl.ZIndex=12; OLbl.Parent=Row

                    local RowBtn=Instance.new("TextButton"); RowBtn.Size=UDim2.new(1,0,1,0); RowBtn.BackgroundTransparency=1
                    RowBtn.Text=""; RowBtn.ZIndex=13; RowBtn.Parent=Row

                    RowBtn.MouseButton1Click:Connect(function()
                        local sel=IsSelected(opt)
                        if sel then
                            for i,s in ipairs(selected) do if s==opt then table.remove(selected,i) break end end
                            Tween(Check,{BackgroundColor3=theme.ToggleOff},0.15); OLbl.TextColor3=theme.DimText
                        else
                            table.insert(selected,opt)
                            Tween(Check,{BackgroundColor3=theme.Accent},0.15); OLbl.TextColor3=theme.Text
                        end
                        configData[key]=selected; UpdateSelLabel()
                        if dCfg.Callback then dCfg.Callback(selected) end
                    end)
                end

                local Hitbox2=Instance.new("TextButton"); Hitbox2.Size=UDim2.new(1,0,1,0); Hitbox2.BackgroundTransparency=1; Hitbox2.Text=""; Hitbox2.ZIndex=2; Hitbox2.Parent=F
                local optH2=math.min(#options*28+4,150)
                Hitbox2.MouseButton1Click:Connect(function()
                    open=not open
                    if open then Menu.Visible=true; Tween(Menu,{Size=UDim2.new(1,0,0,optH2)},0.3,Enum.EasingStyle.Back); Tween(Arrow,{Rotation=180},0.25)
                    else Tween(Menu,{Size=UDim2.new(1,0,0,0)},0.25); task.delay(0.26,function() Menu.Visible=false end); Tween(Arrow,{Rotation=0},0.25) end
                end)
                F.MouseEnter:Connect(function() Tween(S,{Transparency=0.4,Color=theme.Accent},0.15) end)
                F.MouseLeave:Connect(function() Tween(S,{Transparency=0.7,Color=theme.StrokeColor},0.15) end)

                local Ctrl={}
                function Ctrl:Get() return selected end
                return Ctrl
            end

            -- ===================================================
            -- ADD KEYBIND
            -- ===================================================
            function SecObj:AddKeybind(kCfg)
                kCfg = kCfg or {}
                local key      = kCfg.Flag    or kCfg.Title or tostring(math.random())
                local current  = configData[key] or kCfg.Default or Enum.KeyCode.Unknown
                local listening = false

                local F, S = CompBase(36)
                CompLabel(F, kCfg.Title or "Keybind", 12, 0, 0.65, 1, theme.Text)

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Size              = UDim2.new(0, 70, 0, 22)
                KeyBtn.Position          = UDim2.new(1, -80, 0.5, -11)
                KeyBtn.BackgroundColor3  = theme.SectionBg
                KeyBtn.Text              = tostring(current.Name or "None"):gsub("^Enum%.KeyCode%.","")
                KeyBtn.TextColor3        = theme.Accent
                KeyBtn.Font              = Enum.Font.GothamBold
                KeyBtn.TextSize          = 11
                KeyBtn.Parent            = F
                Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 5)
                local KStroke = Instance.new("UIStroke", KeyBtn)
                KStroke.Color = theme.StrokeColor; KStroke.Transparency=0.5; KStroke.Thickness=1

                KeyBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    KeyBtn.Text = "..."
                    KeyBtn.TextColor3 = theme.Warning
                    Tween(KStroke,{Color=theme.Warning,Transparency=0.2},0.15)
                    local conn; conn = UserInputService.InputBegan:Connect(function(inp, gp)
                        if gp then return end
                        if inp.UserInputType == Enum.UserInputType.Keyboard then
                            current = inp.KeyCode
                            configData[key] = inp.KeyCode
                            KeyBtn.Text = inp.KeyCode.Name:gsub("^Enum%.KeyCode%.","")
                            KeyBtn.TextColor3 = theme.Accent
                            Tween(KStroke,{Color=theme.StrokeColor,Transparency=0.5},0.15)
                            listening = false
                            conn:Disconnect()
                            if kCfg.Callback then kCfg.Callback(inp.KeyCode) end
                        end
                    end)
                end)

                F.MouseEnter:Connect(function() Tween(S,{Transparency=0.4,Color=theme.Accent},0.15) end)
                F.MouseLeave:Connect(function() Tween(S,{Transparency=0.7,Color=theme.StrokeColor},0.15) end)

                local Ctrl={}
                function Ctrl:Get() return current end
                return Ctrl
            end

            -- ===================================================
            -- ADD COLOR PICKER
            -- ===================================================
            function SecObj:AddColorPicker(cpCfg)
                cpCfg = cpCfg or {}
                local color = cpCfg.Default or Color3.fromRGB(0,220,255)
                local open  = false

                local F, S = CompBase(36)
                CompLabel(F, cpCfg.Title or "Color", 12, 0, 0.7, 1, theme.Text)

                local Preview = Instance.new("Frame")
                Preview.Size            = UDim2.new(0, 28, 0, 20)
                Preview.Position        = UDim2.new(1, -38, 0.5, -10)
                Preview.BackgroundColor3 = color
                Preview.BorderSizePixel  = 0
                Preview.Parent          = F
                Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 5)
                local PStroke = Instance.new("UIStroke", Preview); PStroke.Color=theme.StrokeColor; PStroke.Transparency=0.5; PStroke.Thickness=1

                -- Panel RGB simplificado
                local Panel = Instance.new("Frame")
                Panel.Size            = UDim2.new(1,0,0,100)
                Panel.Position        = UDim2.new(0,0,1,4)
                Panel.BackgroundColor3 = theme.Surface
                Panel.BackgroundTransparency = 0.05
                Panel.ClipsDescendants = true
                Panel.ZIndex          = 10
                Panel.Visible         = false
                Panel.Parent          = F
                Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 7)
                local CPStroke = Instance.new("UIStroke",Panel); CPStroke.Color=theme.Accent; CPStroke.Transparency=0.5; CPStroke.Thickness=1

                local r,g,b = color.R*255, color.G*255, color.B*255

                local function MakeChannelSlider(label, yPos, initVal, onChanged)
                    local Lbl=Instance.new("TextLabel"); Lbl.Size=UDim2.new(0,14,0,14); Lbl.Position=UDim2.new(0,8,0,yPos)
                    Lbl.BackgroundTransparency=1; Lbl.Text=label; Lbl.TextColor3=theme.DimText; Lbl.Font=Enum.Font.GothamBold; Lbl.TextSize=11; Lbl.ZIndex=11; Lbl.Parent=Panel

                    local Trk=Instance.new("Frame"); Trk.Size=UDim2.new(1,-75,0,4); Trk.Position=UDim2.new(0,25,0,yPos+5)
                    Trk.BackgroundColor3=theme.ToggleOff; Trk.BorderSizePixel=0; Trk.ZIndex=11; Trk.Parent=Panel
                    Instance.new("UICorner",Trk).CornerRadius=UDim.new(1,0)

                    local Fl=Instance.new("Frame"); Fl.Size=UDim2.new(initVal/255,0,1,0); Fl.BackgroundColor3=theme.Accent; Fl.BorderSizePixel=0; Fl.ZIndex=12; Fl.Parent=Trk
                    Instance.new("UICorner",Fl).CornerRadius=UDim.new(1,0)

                    local ValL=Instance.new("TextLabel"); ValL.Size=UDim2.new(0,35,0,14); ValL.Position=UDim2.new(1,-42,0,yPos)
                    ValL.BackgroundTransparency=1; ValL.Text=tostring(math.round(initVal)); ValL.TextColor3=theme.Accent
                    ValL.Font=Enum.Font.GothamBold; ValL.TextSize=11; ValL.TextXAlignment=Enum.TextXAlignment.Right; ValL.ZIndex=11; ValL.Parent=Panel

                    local Hx=Instance.new("TextButton"); Hx.Size=UDim2.new(0,Trk.AbsoluteSize.X,0,16); Hx.Position=UDim2.new(0,25,0,yPos-2)
                    Hx.BackgroundTransparency=1; Hx.Text=""; Hx.ZIndex=13; Hx.Parent=Panel

                    local drg=false
                    Hx.InputBegan:Connect(function(inp)
                        if inp.UserInputType==Enum.UserInputType.MouseButton1 then
                            drg=true
                            local pct=math.clamp((inp.Position.X-Trk.AbsolutePosition.X)/Trk.AbsoluteSize.X,0,1)
                            local v=math.round(pct*255); Fl.Size=UDim2.new(pct,0,1,0); ValL.Text=tostring(v); onChanged(v)
                        end
                    end)
                    Hx.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end end)
                    UserInputService.InputChanged:Connect(function(inp)
                        if drg and inp.UserInputType==Enum.UserInputType.MouseMovement then
                            local pct=math.clamp((inp.Position.X-Trk.AbsolutePosition.X)/Trk.AbsoluteSize.X,0,1)
                            local v=math.round(pct*255); Fl.Size=UDim2.new(pct,0,1,0); ValL.Text=tostring(v); onChanged(v)
                        end
                    end)
                end

                local function Refresh()
                    color=Color3.fromRGB(r,g,b)
                    Preview.BackgroundColor3=color
                    if cpCfg.Callback then cpCfg.Callback(color) end
                end

                MakeChannelSlider("R", 6,  r, function(v) r=v; Refresh() end)
                MakeChannelSlider("G", 36, g, function(v) g=v; Refresh() end)
                MakeChannelSlider("B", 66, b, function(v) b=v; Refresh() end)

                local Hitbox3=Instance.new("TextButton"); Hitbox3.Size=UDim2.new(1,0,1,0); Hitbox3.BackgroundTransparency=1; Hitbox3.Text=""; Hitbox3.ZIndex=2; Hitbox3.Parent=F
                Hitbox3.MouseButton1Click:Connect(function()
                    open=not open
                    if open then Panel.Visible=true; Tween(Panel,{Size=UDim2.new(1,0,0,100)},0.3,Enum.EasingStyle.Back)
                    else Tween(Panel,{Size=UDim2.new(1,0,0,0)},0.25); task.delay(0.26,function() Panel.Visible=false end) end
                end)

                F.MouseEnter:Connect(function() Tween(S,{Transparency=0.4,Color=theme.Accent},0.15) end)
                F.MouseLeave:Connect(function() Tween(S,{Transparency=0.7,Color=theme.StrokeColor},0.15) end)

                local Ctrl={}
                function Ctrl:Get() return color end
                function Ctrl:Set(c) color=c; Preview.BackgroundColor3=c end
                return Ctrl
            end

            -- ===================================================
            -- ADD LABEL
            -- ===================================================
            function SecObj:AddLabel(lCfg)
                lCfg = type(lCfg)=="string" and {Title=lCfg} or lCfg or {}
                local F, _ = CompBase(28)
                CompLabel(F, lCfg.Title or "", 12, 0, 1, 1, theme.DimText, Enum.Font.Gotham, 12)
            end

            -- ===================================================
            -- ADD PARAGRAPH
            -- ===================================================
            function SecObj:AddParagraph(pCfg)
                pCfg = pCfg or {}
                local lines = math.max(2, math.ceil(#(pCfg.Content or "") / 55))
                local h = 16 + lines * 14 + 10
                local F, _ = CompBase(h)
                F.Size = UDim2.new(1, 0, 0, h)
                if pCfg.Title then
                    CompLabel(F, pCfg.Title, 12, 4, 1, 0, theme.Text, Enum.Font.GothamBold, 12)
                end
                local TLbl = Instance.new("TextLabel")
                TLbl.Size              = UDim2.new(1, -24, 1, -20)
                TLbl.Position          = UDim2.new(0, 12, 0, pCfg.Title and 18 or 6)
                TLbl.BackgroundTransparency = 1
                TLbl.Text              = pCfg.Content or ""
                TLbl.TextColor3        = theme.DimText
                TLbl.Font              = Enum.Font.Gotham
                TLbl.TextSize          = 11
                TLbl.TextWrapped       = true
                TLbl.TextXAlignment    = Enum.TextXAlignment.Left
                TLbl.TextYAlignment    = Enum.TextYAlignment.Top
                TLbl.Parent            = F
            end

            -- ===================================================
            -- ADD SEPARATOR
            -- ===================================================
            function SecObj:AddSeparator()
                local Sep = Instance.new("Frame")
                Sep.Size             = UDim2.new(1, 0, 0, 1)
                Sep.BackgroundColor3 = theme.StrokeColor
                Sep.BackgroundTransparency = 0.4
                Sep.BorderSizePixel  = 0
                Sep.LayoutOrder      = NextOrder()
                Sep.Parent           = SecFrame
            end

            -- ===================================================
            -- ADD PROGRESS BAR
            -- ===================================================
            function SecObj:AddProgressBar(pbCfg)
                pbCfg = pbCfg or {}
                local val = pbCfg.Default or 0
                local F, S = CompBase(44)
                F.Size = UDim2.new(1, 0, 0, 44)
                CompLabel(F, pbCfg.Title or "Progress", 12, 6, 0.7, 0, theme.Text)

                local ValLbl2 = Instance.new("TextLabel")
                ValLbl2.Size=UDim2.new(0,40,0,16); ValLbl2.Position=UDim2.new(1,-50,0,5)
                ValLbl2.BackgroundTransparency=1; ValLbl2.Text=tostring(val).."%"
                ValLbl2.TextColor3=theme.Accent; ValLbl2.Font=Enum.Font.GothamBold; ValLbl2.TextSize=12
                ValLbl2.TextXAlignment=Enum.TextXAlignment.Right; ValLbl2.Parent=F

                local PBg=Instance.new("Frame"); PBg.Size=UDim2.new(1,-24,0,6); PBg.Position=UDim2.new(0,12,1,-14)
                PBg.BackgroundColor3=theme.ToggleOff; PBg.BorderSizePixel=0; PBg.Parent=F
                Instance.new("UICorner",PBg).CornerRadius=UDim.new(1,0)

                local PFill2=Instance.new("Frame"); PFill2.Size=UDim2.new(val/100,0,1,0); PFill2.BackgroundColor3=theme.Accent; PFill2.BorderSizePixel=0; PFill2.Parent=PBg
                Instance.new("UICorner",PFill2).CornerRadius=UDim.new(1,0)

                local Ctrl={}
                function Ctrl:Set(v)
                    v=math.clamp(v,0,100); val=v
                    Tween(PFill2,{Size=UDim2.new(v/100,0,1,0)},0.3)
                    ValLbl2.Text=tostring(math.round(v)).."%"
                end
                function Ctrl:Get() return val end
                return Ctrl
            end

            -- ===================================================
            -- ADD IMAGE
            -- ===================================================
            function SecObj:AddImage(iCfg)
                iCfg = iCfg or {}
                local h = iCfg.Height or 80
                local F, _ = CompBase(h)
                F.Size = UDim2.new(1, 0, 0, h)
                local Img=Instance.new("ImageLabel"); Img.Size=UDim2.new(1,-24,1,-24); Img.Position=UDim2.new(0,12,0,12)
                Img.BackgroundTransparency=1; Img.Image=iCfg.Image or ""; Img.ScaleType=Enum.ScaleType.Fit; Img.Parent=F
            end

            -- ===================================================
            -- ADD SEARCH BOX
            -- ===================================================
            function SecObj:AddSearchBox(sbCfg)
                sbCfg = sbCfg or {}
                local F, S = CompBase(36)

                local MagIco=Instance.new("TextLabel"); MagIco.Size=UDim2.new(0,16,0,16); MagIco.Position=UDim2.new(0,10,0.5,-8)
                MagIco.BackgroundTransparency=1; MagIco.Text="⌕"; MagIco.TextColor3=theme.DimText; MagIco.Font=Enum.Font.GothamBold
                MagIco.TextSize=16; MagIco.Parent=F

                local TB2=Instance.new("TextBox"); TB2.Size=UDim2.new(1,-36,0,22); TB2.Position=UDim2.new(0,28,0.5,-11)
                TB2.BackgroundTransparency=1; TB2.Text=""; TB2.PlaceholderText=sbCfg.Placeholder or "Search..."
                TB2.PlaceholderColor3=theme.DimText; TB2.TextColor3=theme.Text; TB2.Font=Enum.Font.GothamMedium
                TB2.TextSize=13; TB2.ClearTextOnFocus=false; TB2.TextXAlignment=Enum.TextXAlignment.Left; TB2.Parent=F

                TB2.Changed:Connect(function(prop)
                    if prop=="Text" and sbCfg.Callback then sbCfg.Callback(TB2.Text) end
                end)
                TB2.Focused:Connect(function() Tween(S,{Transparency=0.3,Color=theme.Accent},0.15) end)
                TB2.FocusLost:Connect(function() Tween(S,{Transparency=0.7,Color=theme.StrokeColor},0.15) end)
                F.MouseEnter:Connect(function() Tween(S,{Transparency=0.4,Color=theme.Accent},0.15) end)
                F.MouseLeave:Connect(function() Tween(S,{Transparency=0.7,Color=theme.StrokeColor},0.15) end)
            end

            -- ===================================================
            -- ADD CODE BLOCK
            -- ===================================================
            function SecObj:AddCodeBlock(cbCfg)
                cbCfg = cbCfg or {}
                local code = cbCfg.Code or ""
                local lines = math.max(3, select(2, code:gsub("\n","")) + 1)
                local h = math.min(lines * 16 + 20, 150)
                local F, _ = CompBase(h)
                F.Size = UDim2.new(1, 0, 0, h)
                F.BackgroundColor3 = Color3.fromRGB(8,12,20)
                F.BackgroundTransparency = 0.1

                local CodeLbl=Instance.new("TextLabel"); CodeLbl.Size=UDim2.new(1,-16,1,-16); CodeLbl.Position=UDim2.new(0,8,0,8)
                CodeLbl.BackgroundTransparency=1; CodeLbl.Text=code; CodeLbl.TextColor3=theme.Accent
                CodeLbl.Font=Enum.Font.Code; CodeLbl.TextSize=12; CodeLbl.TextXAlignment=Enum.TextXAlignment.Left
                CodeLbl.TextYAlignment=Enum.TextYAlignment.Top; CodeLbl.TextWrapped=true; CodeLbl.RichText=true; CodeLbl.Parent=F
            end

            -- ===================================================
            -- ADD LIST
            -- ===================================================
            function SecObj:AddList(listCfg)
                listCfg = listCfg or {}
                local items = listCfg.Items or {}
                local h = #items * 28 + 8
                local F, _ = CompBase(h)
                F.Size = UDim2.new(1, 0, 0, h)
                for i, item in ipairs(items) do
                    local Row=Instance.new("Frame"); Row.Size=UDim2.new(1,-16,0,26); Row.Position=UDim2.new(0,8,0,(i-1)*28+4)
                    Row.BackgroundColor3=theme.SectionBg; Row.BackgroundTransparency=0.5; Row.BorderSizePixel=0; Row.Parent=F
                    Instance.new("UICorner",Row).CornerRadius=UDim.new(0,4)
                    local Dot=Instance.new("Frame"); Dot.Size=UDim2.new(0,5,0,5); Dot.Position=UDim2.new(0,8,0.5,-2.5)
                    Dot.BackgroundColor3=theme.Accent; Dot.BorderSizePixel=0; Dot.Parent=Row
                    Instance.new("UICorner",Dot).CornerRadius=UDim.new(1,0)
                    CompLabel(Row, tostring(item), 20, 0, 1, 1, theme.Text, Enum.Font.GothamMedium, 12)
                end
            end

            -- ===================================================
            -- ADD PLAYER LIST
            -- ===================================================
            function SecObj:AddPlayerList(plCfg)
                plCfg = plCfg or {}
                local plrs = Players:GetPlayers()
                local h = math.min(#plrs * 32 + 8, 160)
                local F, _ = CompBase(h)
                F.Size = UDim2.new(1, 0, 0, h)
                F.ClipsDescendants = true

                local PScroll=Instance.new("ScrollingFrame"); PScroll.Size=UDim2.new(1,-8,1,-8); PScroll.Position=UDim2.new(0,4,0,4)
                PScroll.BackgroundTransparency=1; PScroll.ScrollBarThickness=2; PScroll.ScrollBarImageColor3=theme.Accent
                PScroll.CanvasSize=UDim2.new(0,0,0,0); PScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; PScroll.Parent=F
                local PLayout=Instance.new("UIListLayout"); PLayout.SortOrder=Enum.SortOrder.LayoutOrder; PLayout.Padding=UDim.new(0,3); PLayout.Parent=PScroll

                for _, p in ipairs(plrs) do
                    local Row=Instance.new("TextButton"); Row.Size=UDim2.new(1,0,0,28); Row.BackgroundColor3=theme.ComponentBg
                    Row.BackgroundTransparency=0.5; Row.Text=""; Row.Parent=PScroll
                    Instance.new("UICorner",Row).CornerRadius=UDim.new(0,5)
                    local PLbl=Instance.new("TextLabel"); PLbl.Size=UDim2.new(1,-10,1,0); PLbl.Position=UDim2.new(0,10,0,0)
                    PLbl.BackgroundTransparency=1; PLbl.Text=p.Name; PLbl.TextColor3=theme.Text; PLbl.Font=Enum.Font.GothamMedium
                    PLbl.TextSize=12; PLbl.TextXAlignment=Enum.TextXAlignment.Left; PLbl.Parent=Row
                    Row.MouseButton1Click:Connect(function()
                        if plCfg.Callback then plCfg.Callback(p) end
                    end)
                    Row.MouseEnter:Connect(function() Tween(Row,{BackgroundTransparency=0.2},0.1); PLbl.TextColor3=theme.Accent end)
                    Row.MouseLeave:Connect(function() Tween(Row,{BackgroundTransparency=0.5},0.1); PLbl.TextColor3=theme.Text end)
                end
            end

            -- ===================================================
            -- ADD CONFIG SYSTEM (UI button pair save/load)
            -- ===================================================
            function SecObj:AddConfigSystem()
                local F, _ = CompBase(36)
                local SaveBtn=Instance.new("TextButton"); SaveBtn.Size=UDim2.new(0.48,0,0,26); SaveBtn.Position=UDim2.new(0,8,0.5,-13)
                SaveBtn.BackgroundColor3=theme.AccentGlow; SaveBtn.BackgroundTransparency=0.3; SaveBtn.Text="Save Config"
                SaveBtn.TextColor3=theme.Text; SaveBtn.Font=Enum.Font.GothamBold; SaveBtn.TextSize=12; SaveBtn.Parent=F
                Instance.new("UICorner",SaveBtn).CornerRadius=UDim.new(0,5)

                local LoadBtn=Instance.new("TextButton"); LoadBtn.Size=UDim2.new(0.48,0,0,26); LoadBtn.Position=UDim2.new(0.52,-4,0.5,-13)
                LoadBtn.BackgroundColor3=theme.SectionBg; LoadBtn.BackgroundTransparency=0.3; LoadBtn.Text="Load Config"
                LoadBtn.TextColor3=theme.Text; LoadBtn.Font=Enum.Font.GothamBold; LoadBtn.TextSize=12; LoadBtn.Parent=F
                Instance.new("UICorner",LoadBtn).CornerRadius=UDim.new(0,5)

                SaveBtn.MouseButton1Click:Connect(function()
                    WindowObj:SaveConfig()
                    Notify(theme, {Title="Config", Desc="Saved successfully.", Type="success", Duration=2})
                end)
                LoadBtn.MouseButton1Click:Connect(function()
                    WindowObj:LoadConfig()
                    Notify(theme, {Title="Config", Desc="Loaded successfully.", Type="info", Duration=2})
                end)
            end

            return SecObj
        end -- AddSection

        return TabObj
    end -- AddTab

    return WindowObj
end -- CreateWindow

return NexusUI
