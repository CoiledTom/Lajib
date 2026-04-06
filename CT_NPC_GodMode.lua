-- CoiledTom Hub | NPC GodMode v1.1 (Fixed)
-- Compativel com: Delta, KRNL, Fluxus, Synapse, Arceus X, Hydrogen

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")

-- Estado
local Active = false
local Conns = {}
local RespawnConn = nil

-- Util
local function getChar() return LP.Character end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ══════════════════════════════════
--  METODOS DE PROTECAO
-- ══════════════════════════════════

local function M1_GodMode(hum)
    if not hum then return end
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    local c = hum.HealthChanged:Connect(function(h)
        if Active and h < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)
    table.insert(Conns, c)
end

local function M2_AntiTakeDamage(hum)
    if not hum or not hookfunction then return end
    pcall(function()
        hookfunction(hum.TakeDamage, function() end)
    end)
end

local function M3_HumCamouflage(hum)
    if not hum then return end
    pcall(function()
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        hum.NameDisplayDistance = 0
        hum.HealthDisplayDistance = 0
    end)
end

local function M4_NoCollision(char)
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = false
        end
    end
    local c = char.DescendantAdded:Connect(function(d)
        if Active and d:IsA("BasePart") then
            d.CanCollide = false
        end
    end)
    table.insert(Conns, c)
end

local function M5_Transparency(char, val)
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            pcall(function() p.Transparency = val end)
        end
    end
end

local function M6_FakeHitbox(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local fp = Instance.new("Part")
    fp.Name = "CT_FakeHitbox"
    fp.Anchored = true
    fp.CanCollide = false
    fp.Transparency = 1
    fp.Size = Vector3.new(4, 6, 4)
    fp.Position = Vector3.new(0, 9999, 0)
    fp.Parent = workspace
    local c = RunService.RenderStepped:Connect(function()
        if not Active then fp:Destroy() return end
        if hrp and hrp.Parent then
            fp.Position = hrp.Position + Vector3.new(0, 999, 0)
        end
    end)
    table.insert(Conns, c)
    table.insert(Conns, {Disconnect = function() pcall(function() fp:Destroy() end) end})
end

local function M7_AntiState(hum)
    if not hum then return end
    local blocked = {
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.PlatformStanding] = true,
        [Enum.HumanoidStateType.Seated] = true,
    }
    local c1 = hum.StateChanged:Connect(function(_, new)
        if Active and blocked[new] then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end)
    local c2 = hum:GetPropertyChangedSignal("Sit"):Connect(function()
        if Active and hum.Sit then hum.Sit = false end
    end)
    local c3 = hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if Active and hum.PlatformStand then hum.PlatformStand = false end
    end)
    table.insert(Conns, c1)
    table.insert(Conns, c2)
    table.insert(Conns, c3)
end

local function M8_AntiKnockback()
    local c = RunService.RenderStepped:Connect(function()
        if not Active then return end
        local hrp = getHRP()
        if hrp then
            pcall(function()
                if hrp.AssemblyAngularVelocity.Magnitude > 5 then
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
                local lv = hrp.AssemblyLinearVelocity
                if lv.Y < -50 then
                    hrp.AssemblyLinearVelocity = Vector3.new(lv.X, 0, lv.Z)
                end
            end)
        end
    end)
    table.insert(Conns, c)
end

local function M9_SpeedLock(hum)
    if not hum then return end
    local ws, jp = hum.WalkSpeed, hum.JumpPower
    local c = RunService.RenderStepped:Connect(function()
        if not Active or not hum.Parent then return end
        if hum.WalkSpeed < ws * 0.5 then hum.WalkSpeed = ws end
        if hum.JumpPower < jp * 0.5 then hum.JumpPower = jp end
    end)
    table.insert(Conns, c)
end

local function applyAll()
    local char = getChar()
    local hum = getHum()
    M1_GodMode(hum)
    M2_AntiTakeDamage(hum)
    M3_HumCamouflage(hum)
    M4_NoCollision(char)
    M5_Transparency(char, 0.15)
    M6_FakeHitbox(char)
    M7_AntiState(hum)
    M8_AntiKnockback()
    M9_SpeedLock(hum)
end

local function removeAll()
    for _, c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
    Conns = {}
    local char = getChar()
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                pcall(function() p.CanCollide = true end)
            end
        end
        M5_Transparency(char, 0)
        local hum = getHum()
        if hum then
            hum.MaxHealth = 100
            hum.Health = 100
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Automatic
            hum.NameDisplayDistance = 100
            hum.HealthDisplayDistance = 100
        end
    end
end

-- Protecao ao respawnar
if RespawnConn then RespawnConn:Disconnect() end
RespawnConn = LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 5)
    task.wait(0.5)
    if Active then applyAll() end
end)

-- ══════════════════════════════════
--  GUI
-- ══════════════════════════════════

if PGui:FindFirstChild("CT_Hub") then PGui:FindFirstChild("CT_Hub"):Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "CT_Hub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = PGui

-- Frame principal
local MF = Instance.new("Frame")
MF.Name = "Main"
MF.AnchorPoint = Vector2.new(0.5, 0.5)
MF.Position = UDim2.new(0.5, 0, 0.5, 0)
MF.Size = UDim2.new(0, 0, 0, 0)
MF.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
MF.BackgroundTransparency = 0.1
MF.BorderSizePixel = 0
MF.Parent = SG

local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, 10)
c.Parent = MF

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 180, 255)
stroke.Thickness = 1.2
stroke.Transparency = 0.3
stroke.Parent = MF

-- Header
local HF = Instance.new("Frame")
HF.Size = UDim2.new(1, 0, 0, 38)
HF.BackgroundColor3 = Color3.fromRGB(0, 130, 210)
HF.BackgroundTransparency = 0.45
HF.BorderSizePixel = 0
HF.Parent = MF
local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 10)
hc.Parent = HF
-- fix cantos inferiores header
local hfix = Instance.new("Frame")
hfix.Size = UDim2.new(1, 0, 0.5, 0)
hfix.Position = UDim2.new(0, 0, 0.5, 0)
hfix.BackgroundColor3 = HF.BackgroundColor3
hfix.BackgroundTransparency = HF.BackgroundTransparency
hfix.BorderSizePixel = 0
hfix.Parent = HF
-- linha separadora
local hline = Instance.new("Frame")
hline.Size = UDim2.new(1, 0, 0, 1)
hline.Position = UDim2.new(0, 0, 1, -1)
hline.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
hline.BorderSizePixel = 0
hline.Parent = HF

-- Dot pulsante
local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 8, 0, 8)
dot.Position = UDim2.new(0, 12, 0.5, -4)
dot.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
dot.BorderSizePixel = 0
dot.Parent = HF
local dc = Instance.new("UICorner")
dc.CornerRadius = UDim.new(1, 0)
dc.Parent = dot

-- Titulo
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 28, 0, 0)
title.BackgroundTransparency = 1
title.Text = "CoiledTom Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(220, 240, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = HF

-- Subtitulo
local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -60, 0, 14)
sub.Position = UDim2.new(0, 28, 0, 23)
sub.BackgroundTransparency = 1
sub.Text = "NPC PROTECTION SUITE"
sub.Font = Enum.Font.Gotham
sub.TextSize = 8
sub.TextColor3 = Color3.fromRGB(0, 180, 255)
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = HF

-- Botao fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 55)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = HF
local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 6)
cc.Parent = closeBtn

-- Conteudo
local CF = Instance.new("Frame")
CF.Size = UDim2.new(1, -24, 0, 75)
CF.Position = UDim2.new(0, 12, 0, 46)
CF.BackgroundTransparency = 1
CF.Parent = MF

-- Label nome
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(0.65, 0, 0, 26)
lbl.Position = UDim2.new(0, 0, 0, 8)
lbl.BackgroundTransparency = 1
lbl.Text = "NPC GODMODE"
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 13
lbl.TextColor3 = Color3.fromRGB(210, 230, 255)
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.Parent = CF

-- Status
local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(0.75, 0, 0, 16)
statusLbl.Position = UDim2.new(0, 0, 0, 34)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFFLINE  —  standby"
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 9
statusLbl.TextColor3 = Color3.fromRGB(190, 60, 80)
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = CF

-- Toggle button
local TB = Instance.new("TextButton")
TB.Size = UDim2.new(0, 58, 0, 30)
TB.Position = UDim2.new(1, -58, 0, 12)
TB.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
TB.BorderSizePixel = 0
TB.Text = ""
TB.Parent = CF
local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(1, 0)
tc.Parent = TB
local ts = Instance.new("UIStroke")
ts.Color = Color3.fromRGB(80, 80, 120)
ts.Thickness = 1
ts.Parent = TB

-- Knob
local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 22, 0, 22)
knob.Position = UDim2.new(0, 4, 0.5, -11)
knob.BackgroundColor3 = Color3.fromRGB(120, 120, 160)
knob.BorderSizePixel = 0
knob.Parent = TB
local kc = Instance.new("UICorner")
kc.CornerRadius = UDim.new(1, 0)
kc.Parent = knob

local knobTxt = Instance.new("TextLabel")
knobTxt.Size = UDim2.new(1, 0, 1, 0)
knobTxt.BackgroundTransparency = 1
knobTxt.Text = "OFF"
knobTxt.Font = Enum.Font.GothamBold
knobTxt.TextSize = 7
knobTxt.TextColor3 = Color3.fromRGB(200, 200, 220)
knobTxt.Parent = knob

-- Info bar inferior
local infoBar = Instance.new("Frame")
infoBar.Size = UDim2.new(1, -24, 0, 20)
infoBar.Position = UDim2.new(0, 12, 1, -26)
infoBar.BackgroundColor3 = Color3.fromRGB(0, 110, 190)
infoBar.BackgroundTransparency = 0.75
infoBar.BorderSizePixel = 0
infoBar.Parent = MF
local ic = Instance.new("UICorner")
ic.CornerRadius = UDim.new(0, 5)
ic.Parent = infoBar
local infoTxt = Instance.new("TextLabel")
infoTxt.Size = UDim2.new(1, 0, 1, 0)
infoTxt.BackgroundTransparency = 1
infoTxt.Text = "9 METHODS  |  RESPAWN PERSIST  |  ANTI-DETECT"
infoTxt.Font = Enum.Font.Gotham
infoTxt.TextSize = 8
infoTxt.TextColor3 = Color3.fromRGB(100, 180, 255)
infoTxt.Parent = infoBar

-- ══════════════════════════════════
--  ANIMACOES
-- ══════════════════════════════════

task.spawn(function()
    task.wait(0.05)
    TweenService:Create(MF, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 158)
    }):Play()
end)

-- Pulso borda
task.spawn(function()
    while SG.Parent do
        TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7}):Play()
        task.wait(1.5)
        TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1}):Play()
        task.wait(1.5)
    end
end)

-- Pulso dot
task.spawn(function()
    while SG.Parent do
        TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.8}):Play()
        task.wait(1)
        TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.0}):Play()
        task.wait(1)
    end
end)

-- ══════════════════════════════════
--  TOGGLE LOGIC
-- ══════════════════════════════════

local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function setVisual(on)
    if on then
        TweenService:Create(knob, ti, {Position = UDim2.new(0, 32, 0.5, -11), BackgroundColor3 = Color3.fromRGB(0, 255, 140)}):Play()
        TweenService:Create(TB, ti, {BackgroundColor3 = Color3.fromRGB(0, 55, 38)}):Play()
        TweenService:Create(ts, ti, {Color = Color3.fromRGB(0, 200, 110)}):Play()
        TweenService:Create(stroke, ti, {Color = Color3.fromRGB(0, 220, 130)}):Play()
        TweenService:Create(statusLbl, ti, {TextColor3 = Color3.fromRGB(0, 225, 120)}):Play()
        statusLbl.Text = "ACTIVE  —  9 methods ON"
        knobTxt.Text = "ON"
        knobTxt.TextColor3 = Color3.fromRGB(0, 25, 15)
    else
        TweenService:Create(knob, ti, {Position = UDim2.new(0, 4, 0.5, -11), BackgroundColor3 = Color3.fromRGB(120, 120, 160)}):Play()
        TweenService:Create(TB, ti, {BackgroundColor3 = Color3.fromRGB(38, 38, 52)}):Play()
        TweenService:Create(ts, ti, {Color = Color3.fromRGB(80, 80, 120)}):Play()
        TweenService:Create(stroke, ti, {Color = Color3.fromRGB(0, 180, 255)}):Play()
        TweenService:Create(statusLbl, ti, {TextColor3 = Color3.fromRGB(190, 60, 80)}):Play()
        statusLbl.Text = "OFFLINE  —  standby"
        knobTxt.Text = "OFF"
        knobTxt.TextColor3 = Color3.fromRGB(200, 200, 220)
    end
end

TB.MouseButton1Click:Connect(function()
    Active = not Active
    setVisual(Active)
    -- Flash na borda
    TweenService:Create(stroke, TweenInfo.new(0.08), {Transparency = 0, Thickness = 2.5}):Play()
    task.wait(0.12)
    TweenService:Create(stroke, TweenInfo.new(0.25), {Thickness = 1.2}):Play()
    if Active then applyAll() else removeAll() end
end)

-- ══════════════════════════════════
--  DRAG
-- ══════════════════════════════════
local dragging, dragInput, dragStart, startPos

HF.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = MF.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

HF.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
        dragInput = inp
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local d = inp.Position - dragStart
        MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ══════════════════════════════════
--  FECHAR
-- ══════════════════════════════════
closeBtn.MouseButton1Click:Connect(function()
    local ct = TweenService:Create(MF, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    ct:Play()
    ct.Completed:Connect(function()
        if Active then Active = false; removeAll() end
        SG:Destroy()
        if RespawnConn then RespawnConn:Disconnect() end
    end)
end)

closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end)
closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play() end)

print("[CoiledTom Hub] Loaded OK")
