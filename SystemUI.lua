-- =========================================================================
-- [ SYSTEM UI LIBRARY ] - Manhwa/Holographic Theme
-- =========================================================================

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local UI_NAME = "SystemUI_CoiledTom"

-- Importando Ícones
-- Nota: Em produção, substitua pelo link RAW do seu repositório.
local Icons = loadstring(game:HttpGet("SEU_LINK_RAW_AQUI/Icons.lua"))()

local SystemUI = {
    Config = {}
}

local Themes = {
    Holographic = {
        Background = Color3.fromRGB(10, 15, 25),
        Accent = Color3.fromRGB(0, 220, 255),
        Text = Color3.fromRGB(240, 240, 255),
        DimText = Color3.fromRGB(150, 160, 180),
        GlassTransparency = 0.3,
        Success = Color3.fromRGB(50, 255, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50),
        Info = Color3.fromRGB(50, 150, 255)
    },
    Crimson = {
        Background = Color3.fromRGB(20, 10, 10),
        Accent = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(255, 240, 240),
        DimText = Color3.fromRGB(180, 150, 150),
        GlassTransparency = 0.3,
        Success = Color3.fromRGB(50, 255, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50),
        Info = Color3.fromRGB(50, 150, 255)
    },
    Void = {
        Background = Color3.fromRGB(15, 10, 25),
        Accent = Color3.fromRGB(150, 0, 255),
        Text = Color3.fromRGB(250, 240, 255),
        DimText = Color3.fromRGB(160, 150, 180),
        GlassTransparency = 0.3,
        Success = Color3.fromRGB(50, 255, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50),
        Info = Color3.fromRGB(50, 150, 255)
    }
}

local Fonts = {
    Main = Enum.Font.GothamMedium,
    Bold = Enum.Font.GothamBold
}

local function CreateTween(instance, properties, time, style, direction)
    time = time or 0.3
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(instance, TweenInfo.new(time, style, direction), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
        end
    end)
end

-- =========================================================================
-- [ CONFIG SYSTEM (INTERNAL) ]
-- =========================================================================

function SystemUI:SaveConfig(filename)
    if not isfolder("SystemUI_Configs") then
        makefolder("SystemUI_Configs")
    end
    writefile("SystemUI_Configs/"..filename..".json", HttpService:JSONEncode(self.Config))
end

function SystemUI:LoadConfig(filename)
    if isfile("SystemUI_Configs/"..filename..".json") then
        local decoded = HttpService:JSONDecode(readfile("SystemUI_Configs/"..filename..".json"))
        for k, v in pairs(decoded) do
            self.Config[k] = v
        end
    end
end

-- =========================================================================
-- [ NOTIFICATION SYSTEM ]
-- =========================================================================

function SystemUI:Notify(config)
    local title = config.Title or "SYSTEM"
    local desc = config.Desc or ""
    local type = config.Type or "info"
    local duration = config.Duration or 3
    local theme = Themes["Holographic"] -- Padrão para Notificações fora da Janela

    local NotifGui = CoreGui:FindFirstChild("SystemNotifs")
    if not NotifGui then
        NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "SystemNotifs"
        NotifGui.Parent = CoreGui
        
        local ListContainer = Instance.new("Frame")
        ListContainer.Name = "Container"
        ListContainer.Size = UDim2.new(0, 250, 1, -20)
        ListContainer.Position = UDim2.new(1, -270, 0, 10)
        ListContainer.BackgroundTransparency = 1
        ListContainer.Parent = NotifGui
        
        local Layout = Instance.new("UIListLayout")
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = ListContainer
    end

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 50, 0, 60)
    NotifFrame.BackgroundColor3 = theme.Background
    NotifFrame.BackgroundTransparency = theme.GlassTransparency
    NotifFrame.Parent = NotifGui.Container

    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = theme[type:gsub("^%l", string.upper)] or theme.Accent
    Stroke.Thickness = 1.5
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Stroke.Color
    TitleLabel.Font = Fonts.Bold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -10, 0, 30)
    DescLabel.Position = UDim2.new(0, 10, 0, 25)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.TextColor3 = theme.Text
    DescLabel.Font = Fonts.Main
    DescLabel.TextSize = 12
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = NotifFrame

    CreateTween(NotifFrame, {Size = UDim2.new(1, 0, 0, 60)}, 0.4, Enum.EasingStyle.Back)

    task.delay(duration, function()
        local outTween = CreateTween(NotifFrame, {Size = UDim2.new(0, 0, 0, 60), BackgroundTransparency = 1}, 0.4)
        outTween.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- =========================================================================
-- [ MAIN WINDOW ]
-- =========================================================================

function SystemUI:CreateWindow(config)
    local Title = config.Title or "SYSTEM INTERFACE"
    local SubTitle = config.SubTitle or "SystemUI v1.0"
    local ThemeName = config.Theme or "Holographic"
    local Size = config.Size or UDim2.new(0, 620, 0, 460)
    local UseBlur = config.Blur == nil and true or config.Blur
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    local Theme = Themes[ThemeName] or Themes.Holographic

    if CoreGui:FindFirstChild(UI_NAME) then
        CoreGui[UI_NAME]:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = UI_NAME
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local BlurEffect = nil
    if UseBlur then
        BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Size = 0
        BlurEffect.Parent = Lighting
        CreateTween(BlurEffect, {Size = 15}, 0.5)
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = Theme.GlassTransparency
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true
    
    CreateTween(MainFrame, {Size = Size}, 0.6, Enum.EasingStyle.Exponential)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Theme.Accent
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.2

    -- TopBar / Draggable Area
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 80)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame
    MakeDraggable(TopBar, MainFrame)

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Size = UDim2.new(1, -120, 1, 0)
    HeaderText.Position = UDim2.new(0, 20, 0, 0)
    HeaderText.BackgroundTransparency = 1
    HeaderText.Text = Title .. "\n" .. SubTitle .. "\nCreated by CoiledTom"
    HeaderText.TextColor3 = Theme.Accent
    HeaderText.Font = Fonts.Bold
    HeaderText.TextSize = 14
    HeaderText.LineHeight = 1.2
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.TextYAlignment = Enum.TextXAlignment.Center
    HeaderText.Parent = TopBar

    -- Controles da Janela
    local ControlFrame = Instance.new("Frame")
    ControlFrame.Size = UDim2.new(0, 100, 0, 30)
    ControlFrame.Position = UDim2.new(1, -110, 0, 10)
    ControlFrame.BackgroundTransparency = 1
    ControlFrame.Parent = TopBar

    local function CreateWinButton(text, pos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 25, 0, 25)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.TextColor3 = Theme.DimText
        btn.Font = Fonts.Bold
        btn.TextSize = 14
        btn.Parent = ControlFrame
        btn.MouseEnter:Connect(function() CreateTween(btn, {TextColor3 = Theme.Accent}, 0.2) end)
        btn.MouseLeave:Connect(function() CreateTween(btn, {TextColor3 = Theme.DimText}, 0.2) end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local isMinimized = false
    CreateWinButton("[ - ]", UDim2.new(0, 0, 0, 0), function()
        isMinimized = true
        CreateTween(MainFrame, {Size = UDim2.new(0, Size.X.Offset, 0, 80)}, 0.4)
    end)
    CreateWinButton("[ □ ]", UDim2.new(0, 35, 0, 0), function()
        if isMinimized then
            isMinimized = false
            CreateTween(MainFrame, {Size = Size}, 0.4)
        end
    end)
    CreateWinButton("[ X ]", UDim2.new(0, 70, 0, 0), function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4)
        if BlurEffect then CreateTween(BlurEffect, {Size = 0}, 0.4) end
        task.wait(0.4)
        ScreenGui:Destroy()
        if BlurEffect then BlurEffect:Destroy() end
    end)

    local TitleSeparator = Instance.new("Frame")
    TitleSeparator.Size = UDim2.new(1, -40, 0, 1)
    TitleSeparator.Position = UDim2.new(0, 20, 0, 80)
    TitleSeparator.BackgroundColor3 = Theme.Accent
    TitleSeparator.BorderSizePixel = 0
    TitleSeparator.Parent = MainFrame

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 150, 1, -90)
    TabContainer.Position = UDim2.new(0, 10, 0, 90)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -170, 1, -90)
    PageContainer.Position = UDim2.new(0, 160, 0, 90)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    -- Toggle Key Logic
    local guiVisible = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == ToggleKey then
            guiVisible = not guiVisible
            if guiVisible then
                MainFrame.Visible = true
                CreateTween(MainFrame, {Size = isMinimized and UDim2.new(0, Size.X.Offset, 0, 80) or Size}, 0.4)
                if BlurEffect then CreateTween(BlurEffect, {Size = 15}, 0.4) end
            else
                CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4)
                if BlurEffect then CreateTween(BlurEffect, {Size = 0}, 0.4) end
                task.delay(0.4, function() MainFrame.Visible = false end)
            end
        end
    end)

    local WindowObj = {Tabs = {}}

    -- =========================================================================
    -- [ TAB SYSTEM ]
    -- =========================================================================
    function WindowObj:AddTab(tabConfig)
        local Title = tabConfig.Title or "Tab"
        local IconId = tabConfig.Icon and Icons[tabConfig.Icon] or nil

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Theme.Accent
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Parent = TabBtn

        if IconId then
            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.new(0, 20, 0, 20)
            IconImg.Position = UDim2.new(0, 10, 0.5, -10)
            IconImg.BackgroundTransparency = 1
            IconImg.Image = IconId
            IconImg.ImageColor3 = Theme.DimText
            IconImg.Parent = TabContent
        end

        local TabText = Instance.new("TextLabel")
        TabText.Size = UDim2.new(1, IconId and -40 or -20, 1, 0)
        TabText.Position = UDim2.new(0, IconId and 40 or 10, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = Title
        TabText.TextColor3 = Theme.DimText
        TabText.Font = Fonts.Main
        TabText.TextSize = 14
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabContent

        local PageScroll = Instance.new("ScrollingFrame")
        PageScroll.Size = UDim2.new(1, 0, 1, 0)
        PageScroll.BackgroundTransparency = 1
        PageScroll.ScrollBarThickness = 2
        PageScroll.ScrollBarImageColor3 = Theme.Accent
        PageScroll.Visible = false
        PageScroll.Parent = PageContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = PageScroll

        TabBtn.MouseButton1Click:Connect(function()
            for _, tabData in pairs(WindowObj.Tabs) do
                CreateTween(tabData.Button, {BackgroundTransparency = 1}, 0.3)
                CreateTween(tabData.Text, {TextColor3 = Theme.DimText}, 0.3)
                if tabData.IconImg then CreateTween(tabData.IconImg, {ImageColor3 = Theme.DimText}, 0.3) end
                tabData.Page.Visible = false
            end
            CreateTween(TabBtn, {BackgroundTransparency = 0.8}, 0.3)
            CreateTween(TabText, {TextColor3 = Theme.Accent}, 0.3)
            if IconId then CreateTween(TabContent:FindFirstChildOfClass("ImageLabel"), {ImageColor3 = Theme.Accent}, 0.3) end
            
            PageScroll.Visible = true
            PageScroll.Position = UDim2.new(0, 20, 0, 0)
            CreateTween(PageScroll, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)
        end)

        table.insert(WindowObj.Tabs, {Button = TabBtn, Page = PageScroll, Text = TabText, IconImg = TabContent:FindFirstChildOfClass("ImageLabel")})

        if #WindowObj.Tabs == 1 then
            TabBtn.BackgroundTransparency = 0.8
            TabText.TextColor3 = Theme.Accent
            if IconId then TabContent:FindFirstChildOfClass("ImageLabel").ImageColor3 = Theme.Accent end
            PageScroll.Visible = true
        end

        local TabObj = {}

        -- =========================================================================
        -- [ SECTIONS ]
        -- =========================================================================
        function TabObj:AddSection(secConfig)
            local SecTitle = secConfig.Title or "Section"
            local SecIconId = secConfig.Icon and Icons[secConfig.Icon] or nil

            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 30)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = (SecIconId and "   " or "") .. SecTitle
            SecLabel.TextColor3 = Theme.Accent
            SecLabel.Font = Fonts.Bold
            SecLabel.TextSize = 14
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = PageScroll

            if SecIconId then
                local SIcon = Instance.new("ImageLabel")
                SIcon.Size = UDim2.new(0, 18, 0, 18)
                SIcon.Position = UDim2.new(0, 0, 0.5, -9)
                SIcon.BackgroundTransparency = 1
                SIcon.Image = SecIconId
                SIcon.ImageColor3 = Theme.Accent
                SIcon.Parent = SecLabel
            end

            local SecObj = {}

            -- =========================================================================
            -- [ COMPONENTS ]
            -- =========================================================================
            
            -- BUTTON
            function SecObj:AddButton(cfg)
                local btnText = cfg.Title or "Button"
                local callback = cfg.Callback or function() end

                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, -10, 0, 35)
                Button.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
                Button.BackgroundTransparency = 0.5
                Button.Text = " " .. btnText
                Button.TextColor3 = Theme.Text
                Button.Font = Fonts.Main
                Button.TextSize = 14
                Button.TextXAlignment = Enum.TextXAlignment.Left
                Button.Parent = PageScroll
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)

                local BtnStroke = Instance.new("UIStroke", Button)
                BtnStroke.Color = Theme.Accent
                BtnStroke.Transparency = 1

                Button.MouseEnter:Connect(function()
                    CreateTween(BtnStroke, {Transparency = 0.3}, 0.2)
                    CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(30, 35, 50)}, 0.2)
                end)
                Button.MouseLeave:Connect(function()
                    CreateTween(BtnStroke, {Transparency = 1}, 0.2)
                    CreateTween(Button, {BackgroundColor3 = Color3.fromRGB(20, 25, 40)}, 0.2)
                end)
                Button.MouseButton1Down:Connect(function()
                    CreateTween(Button, {Size = UDim2.new(1, -15, 0, 32)}, 0.1)
                end)
                Button.MouseButton1Up:Connect(function()
                    CreateTween(Button, {Size = UDim2.new(1, -10, 0, 35)}, 0.1)
                    callback()
                end)
            end

            -- TOGGLE
            function SecObj:AddToggle(cfg)
                local toggleText = cfg.Title or "Toggle"
                local state = cfg.Default or false
                local callback = cfg.Callback or function() end

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
                ToggleFrame.BackgroundTransparency = 0.5
                ToggleFrame.Parent = PageScroll
                Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = toggleText
                Label.TextColor3 = Theme.Text
                Label.Font = Fonts.Main
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ToggleFrame

                local Switch = Instance.new("Frame")
                Switch.Size = UDim2.new(0, 40, 0, 20)
                Switch.Position = UDim2.new(1, -50, 0.5, -10)
                Switch.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(40, 45, 60)
                Switch.Parent = ToggleFrame
                Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 16, 0, 16)
                Circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Circle.BackgroundColor3 = Theme.Text
                Circle.Parent = Switch
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = ""
                Btn.Parent = ToggleFrame

                Btn.MouseButton1Click:Connect(function()
                    state = not state
                    if state then
                        CreateTween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.3)
                        CreateTween(Switch, {BackgroundColor3 = Theme.Accent}, 0.3)
                    else
                        CreateTween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.3)
                        CreateTween(Switch, {BackgroundColor3 = Color3.fromRGB(40, 45, 60)}, 0.3)
                    end
                    SystemUI.Config[toggleText] = state
                    callback(state)
                end)
                SystemUI.Config[toggleText] = state
            end

            -- SLIDER (Extremamente suave)
            function SecObj:AddSlider(cfg)
                local title = cfg.Title or "Slider"
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local default = cfg.Default or min
                local callback = cfg.Callback or function() end

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 50)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
                SliderFrame.BackgroundTransparency = 0.5
                SliderFrame.Parent = PageScroll
                Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 5)
                Label.BackgroundTransparency = 1
                Label.Text = title
                Label.TextColor3 = Theme.Text
                Label.Font = Fonts.Main
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 50, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 5)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Theme.Accent
                ValueLabel.Font = Fonts.Bold
                ValueLabel.TextSize = 14
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame

                local BarBG = Instance.new("Frame")
                BarBG.Size = UDim2.new(1, -20, 0, 6)
                BarBG.Position = UDim2.new(0, 10, 0, 35)
                BarBG.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
                BarBG.Parent = SliderFrame
                Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame")
                local fillPct = math.clamp((default - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(fillPct, 0, 1, 0)
                Fill.BackgroundColor3 = Theme.Accent
                Fill.Parent = BarBG
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local SliderBtn = Instance.new("TextButton")
                SliderBtn.Size = UDim2.new(1, 0, 1, 0)
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Text = ""
                SliderBtn.Parent = BarBG

                local dragging = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + ((max - min) * pos))
                    CreateTween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05, Enum.EasingStyle.Linear)
                    ValueLabel.Text = tostring(value)
                    SystemUI.Config[title] = value
                    callback(value)
                end

                SliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        update(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
                SystemUI.Config[title] = default
            end

            -- LABEL / PARAGRAPH
            function SecObj:AddLabel(cfg)
                local text = cfg.Text or "Label"
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -10, 0, 30)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = " " .. text
                Lbl.TextColor3 = Theme.DimText
                Lbl.Font = Fonts.Main
                Lbl.TextSize = 14
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = PageScroll
            end

            return SecObj
        end
        return TabObj
    end
    return WindowObj
end

return SystemUI