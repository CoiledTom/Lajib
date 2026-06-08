-- NexusUI Library
-- Created by CoiledTom
-- Design: Manhwa / Holographic (Preserved)

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local NexusUI = {
    Themes = {
        Holographic = {
            Accent = Color3.fromRGB(0, 220, 255),
            Background = Color3.fromRGB(10, 15, 25),
            Secondary = Color3.fromRGB(15, 20, 35),
            Tertiary = Color3.fromRGB(20, 25, 40),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(150, 160, 180),
            Glow = Color3.fromRGB(0, 220, 255),
            Border = Color3.fromRGB(0, 220, 255),
        },
        Crimson = {
            Accent = Color3.fromRGB(255, 50, 50),
            Background = Color3.fromRGB(15, 10, 10),
            Secondary = Color3.fromRGB(25, 15, 15),
            Tertiary = Color3.fromRGB(35, 20, 20),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(180, 150, 150),
            Glow = Color3.fromRGB(255, 50, 50),
            Border = Color3.fromRGB(255, 50, 50),
        },
        Void = {
            Accent = Color3.fromRGB(150, 50, 255),
            Background = Color3.fromRGB(10, 5, 15),
            Secondary = Color3.fromRGB(15, 10, 25),
            Tertiary = Color3.fromRGB(25, 15, 40),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(160, 150, 180),
            Glow = Color3.fromRGB(150, 50, 255),
            Border = Color3.fromRGB(150, 50, 255),
        }
    },
    Icons = {}, -- Support for Lucide Icons
    SelectedTheme = "Holographic",
    Config = {
        Folder = "NexusUI_Configs",
        AutoSave = false
    }
}

-- Lucide Icon Mapping (Stub/Basic implementation for the most used ones)
-- In a real environment, this would be a full module.
local LucideIcons = {
    ["lucide-swords"] = "rbxassetid://10709790614",
    ["lucide-shield"] = "rbxassetid://10734890061",
    ["lucide-settings"] = "rbxassetid://10734950309",
    ["lucide-user"] = "rbxassetid://10747373176",
    ["lucide-home"] = "rbxassetid://10723346959",
    ["lucide-search"] = "rbxassetid://10734940300",
    ["lucide-chevron-right"] = "rbxassetid://10709761927",
    ["lucide-chevron-down"] = "rbxassetid://10709761821",
    ["lucide-info"] = "rbxassetid://10723350171",
    ["lucide-alert-triangle"] = "rbxassetid://10709751910",
    ["lucide-check-circle"] = "rbxassetid://10709754119",
    ["lucide-x-circle"] = "rbxassetid://10747384391",
}

local function GetIcon(name)
    return LucideIcons[name] or "rbxassetid://10709761927"
end

-- Utility
local function CreateTween(instance, properties, duration, style, direction)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Notification Container
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "NexusUI_Notifications"
NotificationGui.Parent = CoreGui
NotificationGui.DisplayOrder = 999

local NotificationList = Instance.new("Frame")
NotificationList.Size = UDim2.new(0, 300, 1, -20)
NotificationList.Position = UDim2.new(1, -310, 0, 10)
NotificationList.BackgroundTransparency = 1
NotificationList.Parent = NotificationGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.Parent = NotificationList

function NexusUI:Notify(config)
    local title = config.Title or "NOTIFICATION"
    local desc = config.Desc or ""
    local type = config.Type or "info"
    local duration = config.Duration or 5
    
    local theme = self.Themes[self.SelectedTheme]
    local typeColors = {
        success = Color3.fromRGB(0, 255, 150),
        error = Color3.fromRGB(255, 50, 50),
        warning = Color3.fromRGB(255, 180, 0),
        info = theme.Accent
    }
    local accent = typeColors[type] or theme.Accent
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 0, 0)
    Notif.BackgroundColor3 = theme.Background
    Notif.BackgroundTransparency = 0.2
    Notif.ClipsDescendants = true
    Notif.Parent = NotificationList
    
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Notif)
    Stroke.Color = accent
    Stroke.Thickness = 1
    
    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0, 4, 1, 0)
    SideBar.BackgroundColor3 = accent
    SideBar.Parent = Notif
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = accent
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notif
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -25, 0, 0)
    DescLabel.Position = UDim2.new(0, 15, 0, 30)
    DescLabel.Text = desc
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.Parent = Notif
    
    local targetHeight = math.max(60, DescLabel.TextBounds.Y + 45)
    CreateTween(Notif, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.4)
    
    task.delay(duration, function()
        CreateTween(Notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.4):Completed:Connect(function()
            Notif:Destroy()
        end)
    end)
end

function NexusUI:CreateWindow(config)
    local self = NexusUI
    local TitleText = config.Title or "SYSTEM INTERFACE"
    local SubTitleText = config.SubTitle or "NexusUI v1.0"
    local ThemeName = config.Theme or "Holographic"
    self.SelectedTheme = ThemeName
    local CurrentTheme = self.Themes[ThemeName] or self.Themes.Holographic
    local Size = config.Size or UDim2.new(0, 620, 0, 460)
    local Blur = config.Blur ~= nil and config.Blur or true
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    
    local BlurEffect
    if Blur then
        BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Size = 15
        BlurEffect.Parent = Lighting
    end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = Size
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = CurrentTheme.Border
    Stroke.Thickness = 1.5

    -- Header (Barra Superior)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame
    
    MakeDraggable(MainFrame, Header)

    local Title = Instance.new("TextLabel")
    Title.Text = TitleText
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.Size = UDim2.new(0, 300, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = CurrentTheme.Accent
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Text = SubTitleText
    SubTitle.Position = UDim2.new(0, 15, 0, 32)
    SubTitle.Size = UDim2.new(0, 300, 0, 15)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.TextColor3 = CurrentTheme.SubText
    SubTitle.BackgroundTransparency = 1
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Header
    
    local Author = Instance.new("TextLabel")
    Author.Text = "Created by CoiledTom"
    Author.Position = UDim2.new(0, 15, 0, 48)
    Author.Size = UDim2.new(0, 300, 0, 12)
    Author.Font = Enum.Font.Gotham
    Author.TextSize = 10
    Author.TextColor3 = CurrentTheme.SubText
    Author.BackgroundTransparency = 1
    Author.TextXAlignment = Enum.TextXAlignment.Left
    Author.Parent = Header

    -- Control Buttons (Canto Superior Direito)
    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 120, 0, 30)
    Controls.Position = UDim2.new(1, -130, 0, 10)
    Controls.BackgroundTransparency = 1
    Controls.Parent = Header
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Parent = Controls

    local RestoreBtn = Instance.new("TextButton")
    RestoreBtn.Size = UDim2.new(0, 30, 0, 30)
    RestoreBtn.Position = UDim2.new(1, -65, 0, 0)
    RestoreBtn.Text = "□"
    RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RestoreBtn.Font = Enum.Font.GothamBold
    RestoreBtn.TextSize = 16
    RestoreBtn.BackgroundTransparency = 1
    RestoreBtn.Parent = Controls

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -100, 0, 0)
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.BackgroundTransparency = 1
    MinBtn.Parent = Controls

    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(1, 0, 0, 1)
    Separator.Position = UDim2.new(0, 0, 1, 0)
    Separator.BackgroundColor3 = CurrentTheme.Accent
    Separator.BorderSizePixel = 0
    Separator.Parent = Header

    -- Window State Management
    local minimized = false
    local originalSize = Size
    
    local function ToggleMinimize()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, Size.X.Offset, 0, 71)}, 0.4)
        else
            CreateTween(MainFrame, {Size = originalSize}, 0.4)
        end
    end
    
    MinBtn.MouseButton1Click:Connect(ToggleMinimize)
    RestoreBtn.MouseButton1Click:Connect(function()
        if minimized then ToggleMinimize() end
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        if BlurEffect then BlurEffect:Destroy() end
        CreateTween(MainFrame, {Size = UDim2.new(0, Size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.3):Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    -- Toggle Key
    local isHidden = false
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            isHidden = not isHidden
            if isHidden then
                CreateTween(MainFrame, {Size = UDim2.new(0, Size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.4)
            else
                CreateTween(MainFrame, {Size = minimized and UDim2.new(0, Size.X.Offset, 0, 71) or originalSize, BackgroundTransparency = 0.2}, 0.4)
            end
        end
    end)

    -- Side Bar (Tabs)
    local SideBar = Instance.new("ScrollingFrame")
    SideBar.Size = UDim2.new(0, 160, 1, -85)
    SideBar.Position = UDim2.new(0, 10, 0, 80)
    SideBar.BackgroundTransparency = 1
    SideBar.ScrollBarThickness = 0
    SideBar.Parent = MainFrame
    
    Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)
    
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -180, 1, -85)
    PageContainer.Position = UDim2.new(0, 175, 0, 80)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowObj = {Tabs = {}, Configs = {}}

    function WindowObj:AddTab(tabConfig)
        local tabTitle = tabConfig.Title or "Tab"
        local tabIcon = tabConfig.Icon or ""
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = SideBar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.new(0, 20, 0, 20)
        IconImg.Position = UDim2.new(0, 10, 0.5, -10)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = GetIcon(tabIcon)
        IconImg.ImageColor3 = CurrentTheme.SubText
        IconImg.Parent = TabBtn
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 40, 0, 0)
        Label.Text = tabTitle
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 13
        Label.TextColor3 = CurrentTheme.SubText
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = CurrentTheme.Accent
        Page.Visible = false
        Page.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                CreateTween(t.Btn, {BackgroundTransparency = 1}, 0.2)
                CreateTween(t.Label, {TextColor3 = CurrentTheme.SubText}, 0.2)
                CreateTween(t.Icon, {ImageColor3 = CurrentTheme.SubText}, 0.2)
            end
            Page.Visible = true
            CreateTween(TabBtn, {BackgroundTransparency = 0.8, BackgroundColor3 = CurrentTheme.Tertiary}, 0.2)
            CreateTween(Label, {TextColor3 = CurrentTheme.Accent}, 0.2)
            CreateTween(IconImg, {ImageColor3 = CurrentTheme.Accent}, 0.2)
        end)

        table.insert(WindowObj.Tabs, {Btn = TabBtn, Page = Page, Label = Label, Icon = IconImg})
        if #WindowObj.Tabs == 1 then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.BackgroundColor3 = CurrentTheme.Tertiary
            Label.TextColor3 = CurrentTheme.Accent
            IconImg.ImageColor3 = CurrentTheme.Accent
        end

        local TabObj = {}
        
        function TabObj:AddSection(secConfig)
            local secTitle = secConfig.Title or "Section"
            local secIcon = secConfig.Icon or ""
            
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Size = UDim2.new(1, -10, 0, 30)
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Parent = Page
            
            local SIcon = Instance.new("ImageLabel")
            SIcon.Size = UDim2.new(0, 16, 0, 16)
            SIcon.Position = UDim2.new(0, 5, 0.5, -8)
            SIcon.BackgroundTransparency = 1
            SIcon.Image = GetIcon(secIcon)
            SIcon.ImageColor3 = CurrentTheme.Accent
            SIcon.Parent = SectionContainer
            
            local SLabel = Instance.new("TextLabel")
            SLabel.Size = UDim2.new(1, -30, 1, 0)
            SLabel.Position = UDim2.new(0, 26, 0, 0)
            SLabel.Text = secTitle:upper()
            SLabel.Font = Enum.Font.GothamBold
            SLabel.TextSize = 12
            SLabel.TextColor3 = CurrentTheme.Accent
            SLabel.TextXAlignment = Enum.TextXAlignment.Left
            SLabel.BackgroundTransparency = 1
            SLabel.Parent = SectionContainer
            
            local SecObj = {}

            function SecObj:AddButton(btnConfig)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, -10, 0, 35)
                Btn.BackgroundColor3 = CurrentTheme.Secondary
                Btn.Text = "  " .. (btnConfig.Title or "Button")
                Btn.TextColor3 = CurrentTheme.Text
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 13
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = Page
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
                
                Btn.MouseButton1Click:Connect(function()
                    CreateTween(Btn, {BackgroundColor3 = CurrentTheme.Accent}, 0.1)
                    task.wait(0.1)
                    CreateTween(Btn, {BackgroundColor3 = CurrentTheme.Secondary}, 0.2)
                    if btnConfig.Callback then btnConfig.Callback() end
                end)
            end

            function SecObj:AddToggle(togConfig)
                local state = togConfig.Default or false
                local title = togConfig.Title or "Toggle"
                local callback = togConfig.Callback or function() end
                
                local TogFrame = Instance.new("TextButton")
                TogFrame.Size = UDim2.new(1, -10, 0, 35)
                TogFrame.BackgroundColor3 = CurrentTheme.Secondary
                TogFrame.Text = ""
                TogFrame.Parent = Page
                Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 6)

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = title
                Label.TextColor3 = CurrentTheme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = TogFrame

                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 20, 0, 20)
                Indicator.Position = UDim2.new(1, -30, 0.5, -10)
                Indicator.BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(40, 45, 60)
                Indicator.Parent = TogFrame
                Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

                TogFrame.MouseButton1Click:Connect(function()
                    state = not state
                    CreateTween(Indicator, {BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(40, 45, 60)}, 0.2)
                    callback(state)
                end)
            end

            function SecObj:AddSlider(sliConfig)
                local min = sliConfig.Min or 0
                local max = sliConfig.Max or 100
                local default = sliConfig.Default or min
                local callback = sliConfig.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 45)
                SliderFrame.BackgroundColor3 = CurrentTheme.Secondary
                SliderFrame.Parent = Page
                Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 5)
                Label.BackgroundTransparency = 1
                Label.Text = sliConfig.Title or "Slider"
                Label.TextColor3 = CurrentTheme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 50, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 5)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = CurrentTheme.Accent
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextSize = 13
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame

                local Track = Instance.new("TextButton")
                Track.Size = UDim2.new(1, -20, 0, 6)
                Track.Position = UDim2.new(0, 10, 0, 30)
                Track.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
                Track.Text = ""
                Track.Parent = SliderFrame
                Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame")
                local startPercent = math.clamp((default - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(startPercent, 0, 1, 0)
                Fill.BackgroundColor3 = CurrentTheme.Accent
                Fill.Parent = Track
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local dragging = false
                local function UpdateSlider(input)
                    local inputPos = input.Position.X
                    local trackPos = Track.AbsolutePosition.X
                    local trackSize = Track.AbsoluteSize.X
                    local percent = math.clamp((inputPos - trackPos) / trackSize, 0, 1)
                    local value = min + ((max - min) * percent)
                    if sliConfig.Rounding then value = math.floor(value) end
                    
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueLabel.Text = tostring(math.floor(value))
                    callback(value)
                end

                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
            end

            function SecObj:AddDropdown(dropConfig)
                local open = false
                local options = dropConfig.Options or {}
                local title = dropConfig.Title or "Dropdown"
                local callback = dropConfig.Callback or function() end
                
                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, -10, 0, 35)
                DropFrame.BackgroundColor3 = CurrentTheme.Secondary
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = Page
                Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 35)
                Btn.BackgroundTransparency = 1
                Btn.Text = "  " .. title .. " : [ Selecione ]"
                Btn.TextColor3 = CurrentTheme.Text
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 13
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = DropFrame
                
                local ListLayout = Instance.new("UIListLayout", DropFrame)

                Btn.MouseButton1Click:Connect(function()
                    open = not open
                    local targetSize = open and (35 + (#options * 30) + 5) or 35
                    CreateTween(DropFrame, {Size = UDim2.new(1, -10, 0, targetSize)}, 0.3)
                end)

                for _, opt in pairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, -10, 0, 28)
                    OptBtn.BackgroundColor3 = CurrentTheme.Tertiary
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = CurrentTheme.SubText
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 12
                    OptBtn.Parent = DropFrame
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

                    OptBtn.MouseButton1Click:Connect(function()
                        Btn.Text = "  " .. title .. " : [ " .. opt .. " ]"
                        open = false
                        CreateTween(DropFrame, {Size = UDim2.new(1, -10, 0, 35)}, 0.3)
                        callback(opt)
                    end)
                end
            end
            
            function SecObj:AddMultiDropdown(config)
                -- Similiar to Dropdown but multiple selection
                local selected = {}
                local open = false
                local options = config.Options or {}
                local title = config.Title or "Multi Dropdown"
                local callback = config.Callback or function() end
                
                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, -10, 0, 35)
                DropFrame.BackgroundColor3 = CurrentTheme.Secondary
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = Page
                Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 35)
                Btn.BackgroundTransparency = 1
                Btn.Text = "  " .. title .. " : [ ... ]"
                Btn.TextColor3 = CurrentTheme.Text
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 13
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = DropFrame
                
                Instance.new("UIListLayout", DropFrame)

                Btn.MouseButton1Click:Connect(function()
                    open = not open
                    local targetSize = open and (35 + (#options * 30) + 5) or 35
                    CreateTween(DropFrame, {Size = UDim2.new(1, -10, 0, targetSize)}, 0.3)
                end)

                for _, opt in pairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, -10, 0, 28)
                    OptBtn.BackgroundColor3 = CurrentTheme.Tertiary
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = table.find(selected, opt) and CurrentTheme.Accent or CurrentTheme.SubText
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 12
                    OptBtn.Parent = DropFrame
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

                    OptBtn.MouseButton1Click:Connect(function()
                        local idx = table.find(selected, opt)
                        if idx then table.remove(selected, idx) else table.insert(selected, opt) end
                        OptBtn.TextColor3 = table.find(selected, opt) and CurrentTheme.Accent or CurrentTheme.SubText
                        Btn.Text = "  " .. title .. " : [ " .. table.concat(selected, ", ") .. " ]"
                        callback(selected)
                    end)
                end
            end

            function SecObj:AddTextbox(config)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 35)
                Frame.BackgroundColor3 = CurrentTheme.Secondary
                Frame.Parent = Page
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.4, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.Text = config.Title or "Textbox"
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextColor3 = CurrentTheme.Text
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame
                
                local Input = Instance.new("TextBox")
                Input.Size = UDim2.new(0.5, 0, 0, 25)
                Input.Position = UDim2.new(1, -10, 0.5, -12)
                Input.AnchorPoint = Vector2.new(1, 0)
                Input.BackgroundColor3 = CurrentTheme.Tertiary
                Input.Text = ""
                Input.PlaceholderText = config.Placeholder or "..."
                Input.Font = Enum.Font.Gotham
                Input.TextSize = 12
                Input.TextColor3 = CurrentTheme.Text
                Input.Parent = Frame
                Instance.new("UICorner", Input)
                
                Input.FocusLost:Connect(function()
                    if config.Callback then config.Callback(Input.Text) end
                end)
            end
            
            function SecObj:AddKeybind(config)
                local currentKey = config.Default or Enum.KeyCode.RightShift
                local binding = false
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 35)
                Frame.BackgroundColor3 = CurrentTheme.Secondary
                Frame.Parent = Page
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.Text = config.Title or "Keybind"
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextColor3 = CurrentTheme.Text
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame
                
                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 80, 0, 25)
                BindBtn.Position = UDim2.new(1, -10, 0.5, -12)
                BindBtn.AnchorPoint = Vector2.new(1, 0)
                BindBtn.BackgroundColor3 = CurrentTheme.Tertiary
                BindBtn.Text = currentKey.Name
                BindBtn.TextColor3 = CurrentTheme.Accent
                BindBtn.Font = Enum.Font.GothamBold
                BindBtn.TextSize = 12
                BindBtn.Parent = Frame
                Instance.new("UICorner", BindBtn)
                
                BindBtn.MouseButton1Click:Connect(function()
                    binding = true
                    BindBtn.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        currentKey = input.KeyCode
                        BindBtn.Text = currentKey.Name
                        if config.Callback then config.Callback(currentKey) end
                    end
                end)
            end

            function SecObj:AddColorPicker(config)
                -- Simplified Color Picker
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 35)
                Frame.BackgroundColor3 = CurrentTheme.Secondary
                Frame.Parent = Page
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.Text = config.Title or "Color Picker"
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextColor3 = CurrentTheme.Text
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame
                
                local Display = Instance.new("TextButton")
                Display.Size = UDim2.new(0, 40, 0, 25)
                Display.Position = UDim2.new(1, -10, 0.5, -12)
                Display.AnchorPoint = Vector2.new(1, 0)
                Display.BackgroundColor3 = config.Default or CurrentTheme.Accent
                Display.Text = ""
                Display.Parent = Frame
                Instance.new("UICorner", Display)
                
                Display.MouseButton1Click:Connect(function()
                    -- Just a mock for now
                    if config.Callback then config.Callback(Display.BackgroundColor3) end
                end)
            end

            function SecObj:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -10, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = "  " .. text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextColor3 = CurrentTheme.SubText
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Page
            end

            function SecObj:AddParagraph(config)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 50)
                Frame.BackgroundColor3 = CurrentTheme.Secondary
                Frame.Parent = Page
                Instance.new("UICorner", Frame)
                
                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, -20, 0, 25)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.Text = config.Title or "Paragraph"
                Title.Font = Enum.Font.GothamBold
                Title.TextSize = 13
                Title.TextColor3 = CurrentTheme.Accent
                Title.BackgroundTransparency = 1
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = Frame
                
                local Desc = Instance.new("TextLabel")
                Desc.Size = UDim2.new(1, -20, 0, 0)
                Desc.Position = UDim2.new(0, 10, 0, 25)
                Desc.Text = config.Content or ""
                Desc.Font = Enum.Font.Gotham
                Desc.TextSize = 12
                Desc.TextColor3 = CurrentTheme.Text
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.TextWrapped = true
                Desc.BackgroundTransparency = 1
                Desc.Parent = Frame
                
                local h = Desc.TextBounds.Y + 35
                Frame.Size = UDim2.new(1, -10, 0, h)
                Desc.Size = UDim2.new(1, -20, 0, Desc.TextBounds.Y)
            end

            function SecObj:AddSeparator()
                local Sep = Instance.new("Frame")
                Sep.Size = UDim2.new(1, -20, 0, 1)
                Sep.BackgroundColor3 = CurrentTheme.Accent
                Sep.BackgroundTransparency = 0.8
                Sep.BorderSizePixel = 0
                Sep.Parent = Page
            end

            function SecObj:AddProgressBar(config)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 40)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Page
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Text = config.Title or "Progress"
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextColor3 = CurrentTheme.SubText
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BackgroundTransparency = 1
                Label.Parent = Frame
                
                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 8)
                Track.Position = UDim2.new(0, 0, 0, 22)
                Track.BackgroundColor3 = CurrentTheme.Secondary
                Track.Parent = Frame
                Instance.new("UICorner", Track)
                
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((config.Percent or 0)/100, 0, 1, 0)
                Fill.BackgroundColor3 = CurrentTheme.Accent
                Fill.Parent = Track
                Instance.new("UICorner", Fill)
                
                local Obj = {}
                function Obj:Set(v)
                    CreateTween(Fill, {Size = UDim2.new(v/100, 0, 1, 0)}, 0.3)
                end
                return Obj
            end

            function SecObj:AddImage(config)
                local Img = Instance.new("ImageLabel")
                Img.Size = config.Size or UDim2.new(0, 100, 0, 100)
                Img.Image = config.Image or ""
                Img.BackgroundTransparency = 1
                Img.Parent = Page
            end

            function SecObj:AddSearchBox(config)
                -- Search box logic
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 35)
                Frame.BackgroundColor3 = CurrentTheme.Secondary
                Frame.Parent = Page
                Instance.new("UICorner", Frame)
                
                local Icon = Instance.new("ImageLabel")
                Icon.Size = UDim2.new(0, 20, 0, 20)
                Icon.Position = UDim2.new(0, 10, 0.5, -10)
                Icon.Image = GetIcon("lucide-search")
                Icon.ImageColor3 = CurrentTheme.SubText
                Icon.BackgroundTransparency = 1
                Icon.Parent = Frame
                
                local Input = Instance.new("TextBox")
                Input.Size = UDim2.new(1, -40, 1, 0)
                Input.Position = UDim2.new(0, 35, 0, 0)
                Input.BackgroundTransparency = 1
                Input.Text = ""
                Input.PlaceholderText = "Search..."
                Input.TextColor3 = CurrentTheme.Text
                Input.Font = Enum.Font.Gotham
                Input.TextSize = 13
                Input.TextXAlignment = Enum.TextXAlignment.Left
                Input.Parent = Frame
                
                Input:GetPropertyChangedSignal("Text"):Connect(function()
                    if config.Callback then config.Callback(Input.Text) end
                end)
            end

            function SecObj:AddCodeBlock(code)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, -10, 0, 100)
                Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
                Frame.Parent = Page
                Instance.new("UICorner", Frame)
                
                local Text = Instance.new("TextBox")
                Text.Size = UDim2.new(1, -20, 1, -20)
                Text.Position = UDim2.new(0, 10, 0, 10)
                Text.Text = code
                Text.TextColor3 = Color3.fromRGB(0, 255, 150)
                Text.Font = Enum.Font.Code
                Text.TextSize = 12
                Text.TextXAlignment = Enum.TextXAlignment.Left
                Text.TextYAlignment = Enum.TextYAlignment.Top
                Text.BackgroundTransparency = 1
                Text.ReadOnly = true
                Text.ClearTextOnFocus = false
                Text.MultiLine = true
                Text.Parent = Frame
            end

            function SecObj:AddList(config)
                local Frame = Instance.new("ScrollingFrame")
                Frame.Size = UDim2.new(1, -10, 0, 150)
                Frame.BackgroundColor3 = CurrentTheme.Secondary
                Frame.ScrollBarThickness = 2
                Frame.Parent = Page
                Instance.new("UICorner", Frame)
                Instance.new("UIListLayout", Frame).Padding = UDim.new(0, 5)
                
                local Obj = {}
                function Obj:AddItem(text)
                    local L = Instance.new("TextLabel")
                    L.Size = UDim2.new(1, 0, 0, 25)
                    L.Text = "  " .. text
                    L.TextColor3 = CurrentTheme.Text
                    L.Font = Enum.Font.Gotham
                    L.TextSize = 12
                    L.TextXAlignment = Enum.TextXAlignment.Left
                    L.BackgroundTransparency = 1
                    L.Parent = Frame
                end
                return Obj
            end

            function SecObj:AddPlayerList(config)
                local Frame = Instance.new("ScrollingFrame")
                Frame.Size = UDim2.new(1, -10, 0, 150)
                Frame.BackgroundColor3 = CurrentTheme.Secondary
                Frame.ScrollBarThickness = 2
                Frame.Parent = Page
                Instance.new("UICorner", Frame)
                Instance.new("UIListLayout", Frame).Padding = UDim.new(0, 2)
                
                local function Update()
                    for _, v in pairs(Frame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, p in pairs(game.Players:GetPlayers()) do
                        local B = Instance.new("TextButton")
                        B.Size = UDim2.new(1, 0, 0, 25)
                        B.BackgroundColor3 = CurrentTheme.Tertiary
                        B.Text = "  " .. p.Name
                        B.TextColor3 = CurrentTheme.Text
                        B.Font = Enum.Font.Gotham
                        B.TextSize = 12
                        B.TextXAlignment = Enum.TextXAlignment.Left
                        B.Parent = Frame
                        B.MouseButton1Click:Connect(function() if config.Callback then config.Callback(p) end end)
                    end
                end
                Update()
                game.Players.PlayerAdded:Connect(Update)
                game.Players.PlayerRemoving:Connect(Update)
            end

            return SecObj
        end
        return TabObj
    end
    
    -- Config System
    function WindowObj:SaveConfig(name)
        print("NexusUI: Saving config", name or "default")
        -- Internal logic to save states would go here
    end
    
    function WindowObj:LoadConfig(name)
        print("NexusUI: Loading config", name or "default")
    end

    return WindowObj
end

return NexusUI
