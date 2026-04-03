-- ================================================
--          CoiledTom Hub | GUI BASE v1.0
--      Tema Neon Escuro | Gesto 3 Dedos
-- ================================================

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================================================
--               CONFIGURACOES GLOBAIS
-- ================================================

local CONFIG = {
    Title    = "CoiledTom Hub",
    Version  = "v1.0",
    HoldTime = 0.3,
    -- Altura total = topbar (46) + corpo (334) = 380
    TopbarH  = 46,
    BodyH    = 334,
    GuiW     = 460,
    AnimSpeed = 0.25,
}
CONFIG.GuiSize = UDim2.new(0, CONFIG.GuiW, 0, CONFIG.TopbarH + CONFIG.BodyH)

local COLORS = {
    Rosa     = Color3.fromRGB(255, 0, 140),
    Azul     = Color3.fromRGB(0, 150, 255),
    Vermelho = Color3.fromRGB(255, 50, 50),
    Roxo     = Color3.fromRGB(160, 0, 255),
    Amarelo  = Color3.fromRGB(255, 220, 0),
    Verde    = Color3.fromRGB(0, 220, 100),
    Branco   = Color3.fromRGB(220, 220, 220),
}

local currentAccent = COLORS.Rosa

-- ================================================
--               UTILITARIOS
-- ================================================

local function tween(obj, props, duration, style, direction)
    TweenService:Create(obj, TweenInfo.new(
        duration or CONFIG.AnimSpeed,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    ), props):Play()
end

local function setCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function setPadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 6)
    p.PaddingBottom = UDim.new(0, bottom or 6)
    p.PaddingLeft   = UDim.new(0, left   or 8)
    p.PaddingRight  = UDim.new(0, right  or 8)
    p.Parent = parent
end

local function newLabel(text, parent, size, pos, color, font)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Size = size or UDim2.new(1, 0, 0, 20)
    lbl.Position = pos or UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    lbl.Font = font or Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local accentElements = {}

local function registerAccent(instance, property)
    table.insert(accentElements, { instance = instance, property = property })
    instance[property] = currentAccent
end

local function applyAccentColor(color)
    currentAccent = color
    for _, e in ipairs(accentElements) do
        if e.instance and e.instance.Parent then
            tween(e.instance, { [e.property] = color }, 0.3)
        end
    end
end

-- ================================================
--               SCREENUI
-- ================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoiledTomHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

-- ================================================
--   CONTAINER PRINCIPAL (sem ClipsDescendants)
--   Envolve topbar + corpo, permite bordas livres
-- ================================================

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = CONFIG.GuiSize
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Parent = ScreenGui

-- ================================================
--   TOPBAR — frame proprio com cantos arredondados
--   Fica por cima do corpo, sem ser cortada
-- ================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, CONFIG.TopbarH + 14) -- +14 para cobrir a juncao com o corpo
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = currentAccent
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 12
TopBar.ClipsDescendants = false
TopBar.Parent = Container
setCorner(TopBar, 14)  -- cantos arredondados nos 4 cantos; os inferiores ficam cobertos pelo corpo
registerAccent(TopBar, "BackgroundColor3")

-- ================================================
--   CORPO DA GUI (fica abaixo, cobre cantos inf. da topbar)
-- ================================================

local BodyFrame = Instance.new("Frame")
BodyFrame.Name = "BodyFrame"
BodyFrame.Size = UDim2.new(1, 0, 0, CONFIG.BodyH + 20) -- +20 para cobrir o overlap generoso
BodyFrame.Position = UDim2.new(0, 0, 0, CONFIG.TopbarH - 6) -- sobe 6px para eliminar gap
BodyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
BodyFrame.BorderSizePixel = 0
BodyFrame.ZIndex = 10
BodyFrame.ClipsDescendants = true  -- clips somente dentro do corpo
BodyFrame.Parent = Container
setCorner(BodyFrame, 14)  -- cantos arredondados nos 4; os sup. ficam cobertos pela topbar

-- Gradiente de fundo sutil no corpo
local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 14)),
})
bgGrad.Rotation = 135
bgGrad.Parent = BodyFrame

-- Borda neon no container inteiro (stroke externo)
-- Aplicada no topbar e no body separadamente para cobrir tudo
local topStroke = Instance.new("UIStroke")
topStroke.Thickness = 1.5
topStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
topStroke.Transparency = 0.5
registerAccent(topStroke, "Color")
topStroke.Parent = TopBar

local bodyStroke = Instance.new("UIStroke")
bodyStroke.Thickness = 1.5
bodyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
registerAccent(bodyStroke, "Color")
bodyStroke.Parent = BodyFrame

-- ================================================
--   CONTEUDO DA TOPBAR
-- ================================================

-- Icone (bolinha colorida, igual screenshot)
local IconDot = Instance.new("Frame")
IconDot.Size = UDim2.new(0, 12, 0, 12)
IconDot.Position = UDim2.new(0, 14, 0, 17)
IconDot.BorderSizePixel = 0
IconDot.ZIndex = 14
IconDot.Parent = TopBar
setCorner(IconDot, 6)
registerAccent(IconDot, "BackgroundColor3")

-- Titulo
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = CONFIG.Title
TitleLabel.Size = UDim2.new(0, 180, 0, 26)
TitleLabel.Position = UDim2.new(0, 32, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 14
TitleLabel.Parent = TopBar

-- Versao
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Text = CONFIG.Version
VersionLabel.Size = UDim2.new(0, 44, 0, 26)
VersionLabel.Position = UDim2.new(0, 182, 0, 10)
VersionLabel.BackgroundTransparency = 1
VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionLabel.TextTransparency = 0.4
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 11
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.ZIndex = 14
VersionLabel.Parent = TopBar

-- Botao fechar — usa o simbolo "-" que renderiza em qualquer fonte Roblox
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "-"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.BackgroundTransparency = 0.4
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 15
CloseBtn.Parent = TopBar
setCorner(CloseBtn, 8)

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0.1 }, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0.4 }, 0.15)
end)
CloseBtn.MouseButton1Click:Connect(function()
    -- Anima fechando
    tween(Container, { Size = UDim2.new(0, CONFIG.GuiW, 0, 0) }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    task.wait(0.22)
    ScreenGui.Enabled = false
    Container.Size = CONFIG.GuiSize
end)

-- Draggable pela topbar
local dragging, dragStart, startPos = false, nil, nil
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = Container.Position
    end
end)
TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Container.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ================================================
--               ABAS (TABS)
-- ================================================

local tabNames    = { "Aimbot", "Player", "Config" }
local tabButtons  = {}
local tabContents = {}
local activeTab   = nil

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 36)
TabBar.Position = UDim2.new(0, 0, 0, 20) -- 20 = offset do overlap
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 11
TabBar.Parent = BodyFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 2)
TabLayout.Parent = TabBar
setPadding(TabBar, 5, 5, 6, 6)

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -50)
ContentArea.Position = UDim2.new(0, 0, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 11
ContentArea.Parent = BodyFrame

local function switchTab(name)
    if activeTab == name then return end
    activeTab = name
    for n, btn in pairs(tabButtons) do
        if n == name then
            tween(btn, { BackgroundColor3 = currentAccent }, 0.18)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tween(btn, { BackgroundColor3 = Color3.fromRGB(22, 22, 30) }, 0.18)
            btn.TextColor3 = Color3.fromRGB(160, 160, 180)
        end
    end
    for n, frame in pairs(tabContents) do
        frame.Visible = (n == name)
    end
end

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 96, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    btn.ZIndex = 12
    btn.Parent = TabBar
    setCorner(btn, 6)
    tabButtons[name] = btn

    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = currentAccent
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ZIndex = 11
    content.Parent = ContentArea
    tabContents[name] = content

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = content
    setPadding(content, 10, 10, 14, 14)

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ================================================
--         COMPONENTES REUTILIZAVEIS
-- ================================================

-- TOGGLE
local function createToggle(parent, labelText, defaultValue, callback, order)
    local state = defaultValue or false

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    row.Parent = parent
    setCorner(row, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(40, 40, 55)
    stroke.Parent = row

    newLabel(labelText, row, UDim2.new(1, -56, 1, 0), UDim2.new(0, 12, 0, 0))

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 42, 0, 22)
    track.Position = UDim2.new(1, -52, 0.5, -11)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    track.BorderSizePixel = 0
    track.Parent = row
    setCorner(track, 11)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = track
    setCorner(knob, 8)

    local function updateToggle(newState)
        state = newState
        if state then
            tween(track, { BackgroundColor3 = currentAccent }, 0.2)
            tween(knob, { Position = UDim2.new(1, -19, 0.5, -8) }, 0.2)
            local found = false
            for _, e in ipairs(accentElements) do
                if e.instance == track then found = true break end
            end
            if not found then registerAccent(track, "BackgroundColor3") end
        else
            tween(track, { BackgroundColor3 = Color3.fromRGB(40, 40, 55) }, 0.2)
            tween(knob, { Position = UDim2.new(0, 3, 0.5, -8) }, 0.2)
            for i2, e in ipairs(accentElements) do
                if e.instance == track then table.remove(accentElements, i2) break end
            end
        end
        if callback then callback(state) end
    end

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = row
    clickBtn.MouseButton1Click:Connect(function() updateToggle(not state) end)

    updateToggle(state)
    return row, function() return state end
end

-- SLIDER
local function createSlider(parent, labelText, minVal, maxVal, defaultVal, callback, order)
    local value = defaultVal or minVal
    local draggingSlider = false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    container.BorderSizePixel = 0
    container.LayoutOrder = order or 1
    container.Parent = parent
    setCorner(container, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(40, 40, 55)
    stroke.Parent = container

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 24)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = container

    newLabel(labelText, headerFrame, UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 12, 0, 0))

    local valLabel = Instance.new("TextLabel")
    valLabel.Text = tostring(value)
    valLabel.Size = UDim2.new(0.3, -12, 1, 0)
    valLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.TextColor3 = currentAccent
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 13
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = headerFrame
    registerAccent(valLabel, "TextColor3")

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, -24, 0, 6)
    trackBg.Position = UDim2.new(0, 12, 0, 36)
    trackBg.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    trackBg.BorderSizePixel = 0
    trackBg.Parent = container
    setCorner(trackBg, 3)

    local fillPct = (value - minVal) / (maxVal - minVal)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(fillPct, 0, 1, 0)
    fill.BackgroundColor3 = currentAccent
    fill.BorderSizePixel = 0
    fill.Parent = trackBg
    setCorner(fill, 3)
    registerAccent(fill, "BackgroundColor3")

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 14, 0, 14)
    handle.Position = UDim2.new(fillPct, -7, 0.5, -7)
    handle.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
    handle.BorderSizePixel = 0
    handle.ZIndex = 3
    handle.Parent = trackBg
    setCorner(handle, 7)

    local function updateSlider(inputPosX)
        local absPos  = trackBg.AbsolutePosition.X
        local absSize = trackBg.AbsoluteSize.X
        local pct = math.clamp((inputPosX - absPos) / absSize, 0, 1)
        local newVal = math.floor(minVal + (maxVal - minVal) * pct + 0.5)
        value = newVal
        fill.Size = UDim2.new(pct, 0, 1, 0)
        handle.Position = UDim2.new(pct, -7, 0.5, -7)
        valLabel.Text = tostring(newVal)
        if callback then callback(newVal) end
    end

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 0, 28)
    sliderBtn.Position = UDim2.new(0, 0, 0, 26)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 4
    sliderBtn.Parent = container

    sliderBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(inp.Position.X)
        end
    end)
    sliderBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if draggingSlider and (
            inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch
        ) then
            updateSlider(inp.Position.X)
        end
    end)

    return container, function() return value end
end

-- DROPDOWN
local function createDropdown(parent, labelText, options, defaultOption, callback, order)
    local selected = defaultOption or options[1]
    local isOpen   = false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    container.BorderSizePixel = 0
    container.LayoutOrder = order or 1
    container.ClipsDescendants = false
    container.ZIndex = 5
    container.Parent = parent
    setCorner(container, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(40, 40, 55)
    stroke.Parent = container

    newLabel(labelText, container, UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 12, 0, 0))

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0.48, 0, 0, 28)
    dropBtn.Position = UDim2.new(0.52, 0, 0.5, -14)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    dropBtn.TextColor3 = Color3.fromRGB(210, 210, 230)
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextSize = 12
    dropBtn.Text = selected .. "  v"
    dropBtn.BorderSizePixel = 0
    dropBtn.ZIndex = 6
    dropBtn.Parent = container
    setCorner(dropBtn, 6)

    local dropStroke = Instance.new("UIStroke")
    dropStroke.Thickness = 1
    registerAccent(dropStroke, "Color")
    dropStroke.Parent = dropBtn

    local optionPanel = Instance.new("Frame")
    optionPanel.Size = UDim2.new(0.48, 0, 0, #options * 28)
    optionPanel.Position = UDim2.new(0.52, 0, 1, 2)
    optionPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    optionPanel.BorderSizePixel = 0
    optionPanel.ZIndex = 20
    optionPanel.Visible = false
    optionPanel.ClipsDescendants = true
    optionPanel.Parent = container
    setCorner(optionPanel, 6)

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Thickness = 1
    registerAccent(panelStroke, "Color")
    panelStroke.Parent = optionPanel

    local optLayout = Instance.new("UIListLayout")
    optLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optLayout.Parent = optionPanel

    for idx, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        optBtn.TextColor3 = Color3.fromRGB(190, 190, 210)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 12
        optBtn.Text = opt
        optBtn.BorderSizePixel = 0
        optBtn.LayoutOrder = idx
        optBtn.ZIndex = 21
        optBtn.Parent = optionPanel

        -- Arredonda primeiro e ultimo item para combinar com o painel
        if idx == 1 or idx == #options then
            setCorner(optBtn, 6)
        end

        optBtn.MouseEnter:Connect(function()
            tween(optBtn, { BackgroundColor3 = Color3.fromRGB(35, 35, 50) }, 0.1)
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, { BackgroundColor3 = Color3.fromRGB(22, 22, 32) }, 0.1)
        end)
        optBtn.MouseButton1Click:Connect(function()
            selected = opt
            dropBtn.Text = opt .. "  v"
            optionPanel.Visible = false
            isOpen = false
            container.ZIndex = 5
            if callback then callback(opt) end
        end)
    end

    dropBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionPanel.Visible = isOpen
        container.ZIndex = isOpen and 50 or 5
    end)

    return container, function() return selected end
end

-- BUTTON
local function createButton(parent, labelText, callback, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = currentAccent
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = labelText
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order or 1
    btn.Parent = parent
    setCorner(btn, 8)
    registerAccent(btn, "BackgroundColor3")

    btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundColor3 = currentAccent:Lerp(Color3.new(1,1,1), 0.15) }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundColor3 = currentAccent }, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, { Size = UDim2.new(0.97, 0, 0, 34) }, 0.08)
        task.wait(0.1)
        tween(btn, { Size = UDim2.new(1, 0, 0, 36) }, 0.1)
        if callback then callback() end
    end)

    return btn
end

-- SECTION LABEL
local function createSection(parent, text, order)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 20)
    f.BackgroundTransparency = 1
    f.LayoutOrder = order or 0
    f.Parent = parent

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    line.BorderSizePixel = 0
    line.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Text = " " .. text .. " "
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    lbl.TextColor3 = currentAccent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.ZIndex = 2
    lbl.Parent = f
    registerAccent(lbl, "TextColor3")

    return f
end

-- ================================================
--               ABA 1: AIMBOT
-- ================================================

local aimbotContent = tabContents["Aimbot"]
local aimbotValues  = {}

createSection(aimbotContent, "TARGETING", 1)

createToggle(aimbotContent, "Enable Aimbot", false, function(v)
    aimbotValues.aimbot = v
end, 2)

createToggle(aimbotContent, "Precision Mode", false, function(v)
    aimbotValues.precision = v
end, 3)

createSection(aimbotContent, "CONFIGURACOES", 4)

createDropdown(aimbotContent, "Type Of Aim", {
    "Silent Aim", "Mouse Aim", "Body Aim", "Head Aim"
}, "Silent Aim", function(v)
    aimbotValues.aimType = v
end, 5)

createSlider(aimbotContent, "Smoothness", 0, 100, 15, function(v)
    aimbotValues.smoothness = v
end, 6)

createButton(aimbotContent, "Apply Aimbot", function()
    print("[Aimbot] Aplicado:", aimbotValues.aimbot, aimbotValues.aimType, aimbotValues.smoothness)
end, 7)

-- ================================================
--               ABA 2: PLAYER
-- ================================================

local playerContent = tabContents["Player"]
local playerValues  = {}

createSection(playerContent, "MOVEMENT", 1)

createToggle(playerContent, "Speed Boost", false, function(v)
    playerValues.speedBoost = v
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = v and (playerValues.walkSpeed or 32) or 16
        end
    end
end, 2)

createSlider(playerContent, "WalkSpeed", 16, 100, 32, function(v)
    playerValues.walkSpeed = v
    if playerValues.speedBoost then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
end, 3)

createSection(playerContent, "ACOES", 4)

createButton(playerContent, "Reset Player", function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end, 5)

-- ================================================
--               ABA 3: CONFIG
-- ================================================

local configContent = tabContents["Config"]

createSection(configContent, "TEMA DA INTERFACE", 1)

local colorNames = {}
for name in pairs(COLORS) do
    table.insert(colorNames, name)
end
table.sort(colorNames)

createDropdown(configContent, "Cor do Tema", colorNames, "Rosa", function(v)
    local chosen = COLORS[v]
    if chosen then
        applyAccentColor(chosen)
        for _, content in pairs(tabContents) do
            content.ScrollBarImageColor3 = chosen
        end
    end
end, 2)

createSection(configContent, "OPCOES", 3)

createButton(configContent, "Salvar Config", function()
    print("[Config] Configuracoes salvas!")
end, 4)

-- ================================================
--           NOTIFICACAO (TOAST)
-- ================================================

local function showNotification(msg, duration)
    duration = duration or 2.5
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 260, 0, 42)
    toast.Position = UDim2.new(0.5, -130, 1, 10)
    toast.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    toast.BorderSizePixel = 0
    toast.ZIndex = 100
    toast.Parent = ScreenGui
    setCorner(toast, 8)

    local toastStroke = Instance.new("UIStroke")
    toastStroke.Thickness = 1
    toastStroke.Color = currentAccent
    toastStroke.Parent = toast

    local toastLine = Instance.new("Frame")
    toastLine.Size = UDim2.new(0, 3, 1, -12)
    toastLine.Position = UDim2.new(0, 7, 0, 6)
    toastLine.BackgroundColor3 = currentAccent
    toastLine.BorderSizePixel = 0
    toastLine.ZIndex = 101
    toastLine.Parent = toast
    setCorner(toastLine, 2)

    local toastLabel = Instance.new("TextLabel")
    toastLabel.Text = "  " .. msg
    toastLabel.Size = UDim2.new(1, -16, 1, 0)
    toastLabel.Position = UDim2.new(0, 16, 0, 0)
    toastLabel.BackgroundTransparency = 1
    toastLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    toastLabel.Font = Enum.Font.Gotham
    toastLabel.TextSize = 12
    toastLabel.TextXAlignment = Enum.TextXAlignment.Left
    toastLabel.ZIndex = 101
    toastLabel.Parent = toast

    tween(toast, { Position = UDim2.new(0.5, -130, 1, -54) }, 0.3)
    task.wait(duration)
    tween(toast, { Position = UDim2.new(0.5, -130, 1, 10) }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    task.wait(0.28)
    toast:Destroy()
end

-- ================================================
--           ANIMACAO DE ABERTURA
-- ================================================

local function openGui()
    ScreenGui.Enabled = true
    Container.Size = UDim2.new(0, CONFIG.GuiW, 0, 0)
    tween(Container, { Size = CONFIG.GuiSize }, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    switchTab("Aimbot")
    task.wait(0.4)
    task.spawn(showNotification, "CoiledTom Hub ativado!")
end

-- ================================================
--   SISTEMA DE GESTO: DUPLO TOQUE COM 3 DEDOS
--   Detecta 2 toques rapidos com 3 dedos simultaneos
-- ================================================

local touches       = {}
local tapCount      = 0       -- quantos "grupos de 3 dedos" foram detectados
local lastTapTime   = 0       -- tempo do ultimo tap valido
local TAP_INTERVAL  = 0.4     -- janela maxima entre os dois taps (segundos)
local TAP_FINGERS   = 3       -- dedos necessarios simultaneamente

local function countTouches()
    local n = 0
    for _ in pairs(touches) do n += 1 end
    return n
end

local function toggleGui()
    if not ScreenGui.Enabled then
        openGui()
    else
        tween(Container, { Size = UDim2.new(0, CONFIG.GuiW, 0, 0) }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.22)
        ScreenGui.Enabled = false
        Container.Size = CONFIG.GuiSize
    end
end

UIS.TouchStarted:Connect(function(input)
    touches[input] = tick()

    -- Verifica se ha 3 dedos na tela ao mesmo tempo
    if countTouches() == TAP_FINGERS then
        local now = tick()

        if now - lastTapTime <= TAP_INTERVAL then
            -- Segundo tap detectado dentro do intervalo = duplo toque!
            tapCount    = 0
            lastTapTime = 0
            toggleGui()
        else
            -- Primeiro tap — registra e aguarda o segundo
            tapCount    = 1
            lastTapTime = now
        end
    end
end)

UIS.TouchEnded:Connect(function(input)
    touches[input] = nil
end)

-- ================================================
--       ATALHO PC (TESTE): RightShift
-- ================================================

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

-- ================================================
print("[CoiledTom Hub] Carregado! Mobile: duplo toque com 3 dedos | PC: RightShift")
-- ================================================
