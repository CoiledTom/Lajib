local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local NexusUI = {}

local function CreateTween(instance, properties, time)
    local tween = TweenService:Create(instance, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

function NexusUI:CreateWindow(config)
    local TitleText = config.Title or "SYSTEM INTERFACE"
    local SubTitleText = config.SubTitle or "by Author"
    local Size = config.Size or UDim2.new(0, 620, 0, 460)
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexusUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = Size
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(0, 220, 255)
    Stroke.Thickness = 1.5

    -- Header (Barra Superior)
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Text = TitleText
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.Size = UDim2.new(0, 300, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(0, 220, 255)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Text = SubTitleText
    SubTitle.Position = UDim2.new(0, 15, 0, 25)
    SubTitle.Size = UDim2.new(0, 300, 0, 15)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.TextColor3 = Color3.fromRGB(150, 160, 180)
    SubTitle.BackgroundTransparency = 1
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Header

    -- Botões de Controle
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Parent = Header

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -75, 0, 10)
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.BackgroundTransparency = 1
    MinBtn.Parent = Header

    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(1, 0, 0, 1)
    Separator.Position = UDim2.new(0, 0, 1, 0)
    Separator.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
    Separator.BorderSizePixel = 0
    Separator.Parent = Header

    -- Modal de Confirmação (Fechamento)
    local ConfirmModal = Instance.new("Frame")
    ConfirmModal.Size = UDim2.new(1, 0, 1, 0)
    ConfirmModal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ConfirmModal.BackgroundTransparency = 0.5
    ConfirmModal.Visible = false
    ConfirmModal.Parent = MainFrame

    local ModalBox = Instance.new("Frame")
    ModalBox.Size = UDim2.new(0, 300, 0, 120)
    ModalBox.Position = UDim2.new(0.5, -150, 0.5, -60)
    ModalBox.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
    ModalBox.Parent = ConfirmModal
    Instance.new("UICorner", ModalBox).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", ModalBox).Color = Color3.fromRGB(255, 50, 50)

    local ModalText = Instance.new("TextLabel")
    ModalText.Size = UDim2.new(1, 0, 0, 60)
    ModalText.Text = "Atenção!\nTem certeza que quer fechar o Gui?"
    ModalText.Font = Enum.Font.GothamMedium
    ModalText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ModalText.BackgroundTransparency = 1
    ModalText.Parent = ModalBox

    local BtnSim = Instance.new("TextButton")
    BtnSim.Size = UDim2.new(0, 100, 0, 30)
    BtnSim.Position = UDim2.new(0, 30, 0, 70)
    BtnSim.Text = "Sim"
    BtnSim.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    BtnSim.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnSim.Parent = ModalBox
    Instance.new("UICorner", BtnSim)

    local BtnNao = Instance.new("TextButton")
    BtnNao.Size = UDim2.new(0, 100, 0, 30)
    BtnNao.Position = UDim2.new(1, -130, 0, 70)
    BtnNao.Text = "Não"
    BtnNao.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    BtnNao.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnNao.Parent = ModalBox
    Instance.new("UICorner", BtnNao)

    -- Lógica dos Botões de Janela
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, Size.X.Offset, 0, 50)}, 0.4)
        else
            CreateTween(MainFrame, {Size = Size}, 0.4)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ConfirmModal.Visible = true
        ModalBox.Size = UDim2.new(0, 0, 0, 0)
        CreateTween(ModalBox, {Size = UDim2.new(0, 300, 0, 120)}, 0.3)
    end)

    BtnSim.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    BtnNao.MouseButton1Click:Connect(function() ConfirmModal.Visible = false end)

    -- Toggle da GUI pelo teclado
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == ToggleKey then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Containers
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 140, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = MainFrame
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -160, 1, -60)
    PageContainer.Position = UDim2.new(0, 150, 0, 60)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowObj = {Tabs = {}}

    function WindowObj:AddTab(tabConfig)
        local tabTitle = tabConfig.Title or "Tab"
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = tabTitle
        TabBtn.TextColor3 = Color3.fromRGB(150, 160, 180)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = PageContainer
        
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 8)
        Layout.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                CreateTween(t.Btn, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 160, 180)}, 0.2)
            end
            Page.Visible = true
            CreateTween(TabBtn, {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(0, 220, 255)}, 0.2)
        end)

        table.insert(WindowObj.Tabs, {Btn = TabBtn, Page = Page})
        if #WindowObj.Tabs == 1 then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0.8
            TabBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
        end

        local TabObj = {}
        
        function TabObj:AddSection(secConfig)
            local SecTitle = Instance.new("TextLabel")
            SecTitle.Size = UDim2.new(1, 0, 0, 25)
            SecTitle.Text = "  " .. (secConfig.Title or "Section")
            SecTitle.Font = Enum.Font.GothamBold
            SecTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
            SecTitle.TextXAlignment = Enum.TextXAlignment.Left
            SecTitle.BackgroundTransparency = 1
            SecTitle.Parent = Page
            
            local SecObj = {}

            function SecObj:AddButton(btnConfig)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, -10, 0, 35)
                Btn.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
                Btn.Text = "  " .. (btnConfig.Title or "Button")
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = Page
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                
                Btn.MouseButton1Click:Connect(function()
                    CreateTween(Btn, {BackgroundColor3 = Color3.fromRGB(0, 220, 255)}, 0.1)
                    task.wait(0.1)
                    CreateTween(Btn, {BackgroundColor3 = Color3.fromRGB(20, 25, 40)}, 0.2)
                    if btnConfig.Callback then btnConfig.Callback() end
                end)
            end

            function SecObj:AddToggle(togConfig)
                local state = togConfig.Default or false
                local TogFrame = Instance.new("TextButton")
                TogFrame.Size = UDim2.new(1, -10, 0, 35)
                TogFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
                TogFrame.Text = ""
                TogFrame.Parent = Page
                Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 4)

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = togConfig.Title or "Toggle"
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = TogFrame

                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 20, 0, 20)
                Indicator.Position = UDim2.new(1, -30, 0.5, -10)
                Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(40, 45, 60)
                Indicator.Parent = TogFrame
                Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

                TogFrame.MouseButton1Click:Connect(function()
                    state = not state
                    CreateTween(Indicator, {BackgroundColor3 = state and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(40, 45, 60)}, 0.2)
                    if togConfig.Callback then togConfig.Callback(state) end
                end)
            end

            function SecObj:AddSlider(sliConfig)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 45)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
                SliderFrame.Parent = Page
                Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 5)
                Label.BackgroundTransparency = 1
                Label.Text = sliConfig.Title or "Slider"
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 50, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 5)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(sliConfig.Default or sliConfig.Min)
                ValueLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
                ValueLabel.Font = Enum.Font.GothamBold
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
                local startPercent = ((sliConfig.Default or sliConfig.Min) - sliConfig.Min) / (sliConfig.Max - sliConfig.Min)
                Fill.Size = UDim2.new(startPercent, 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
                Fill.Parent = Track
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local dragging = false
                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation().X
                        local trackPos = Track.AbsolutePosition.X
                        local trackSize = Track.AbsoluteSize.X
                        local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                        local value = math.floor(sliConfig.Min + ((sliConfig.Max - sliConfig.Min) * percent))
                        
                        CreateTween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                        ValueLabel.Text = tostring(value)
                        if sliConfig.Callback then sliConfig.Callback(value) end
                    end
                end)
            end

            function SecObj:AddDropdown(dropConfig)
                local dropOpen = false
                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, -10, 0, 35)
                DropFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = Page
                Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 4)

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 35)
                Btn.BackgroundTransparency = 1
                Btn.Text = "  " .. (dropConfig.Title or "Dropdown") .. " : [ Selecione ]"
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = DropFrame

                local List = Instance.new("UIListLayout")
                List.Padding = UDim.new(0, 2)
                List.Parent = DropFrame

                Btn.MouseButton1Click:Connect(function()
                    dropOpen = not dropOpen
                    local totalSize = 35 + (#dropConfig.Options * 27)
                    CreateTween(DropFrame, {Size = UDim2.new(1, -10, 0, dropOpen and totalSize or 35)}, 0.3)
                end)

                for _, option in pairs(dropConfig.Options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, -20, 0, 25)
                    OptBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
                    OptBtn.Text = option
                    OptBtn.TextColor3 = Color3.fromRGB(150, 160, 180)
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.Parent = DropFrame
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

                    OptBtn.MouseButton1Click:Connect(function()
                        Btn.Text = "  " .. (dropConfig.Title) .. " : [ " .. option .. " ]"
                        CreateTween(DropFrame, {Size = UDim2.new(1, -10, 0, 35)}, 0.3)
                        dropOpen = false
                        if dropConfig.Callback then dropConfig.Callback(option) end
                    end)
                end
            end

            return SecObj
        end
        return TabObj
    end

    function WindowObj:Notify(config)
        -- (A lógica de notificação ficaria aqui usando o mesmo padrão do script anterior)
        print("NOTIFICAÇÃO:", config.Title, "-", config.Desc)
    end

    return WindowObj
end

return NexusUI
