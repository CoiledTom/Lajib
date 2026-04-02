--[[
╔══════════════════════════════════════════════╗
║         COILEDTOM HUB  v2.3.0               ║
║         Script Roblox — Lua/Luau            ║
║         discord / github: @coiledtom       ║
╚══════════════════════════════════════════════╝
  PC      → RightControl  = abrir/fechar
  Mobile  → 3 dedos, 2× toque = abrir/fechar
--]]

-- ════════════════════════════════════════
--  SERVICES
-- ════════════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")

local LP  = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

-- ════════════════════════════════════════
--  TEMAS
-- ════════════════════════════════════════
local TEMAS = {
    { name = "🟣 Roxo",     main = Color3.fromRGB(139,0,255),  dark = Color3.fromRGB(80,0,160),   light = Color3.fromRGB(180,60,255)  },
    { name = "🔵 Azul",     main = Color3.fromRGB(0,110,255),   dark = Color3.fromRGB(0,55,170),   light = Color3.fromRGB(60,160,255)  },
    { name = "🩵 Ciano",    main = Color3.fromRGB(0,190,220),   dark = Color3.fromRGB(0,110,150),  light = Color3.fromRGB(0,220,255)   },
    { name = "🟢 Verde",    main = Color3.fromRGB(0,200,60),    dark = Color3.fromRGB(0,110,30),   light = Color3.fromRGB(50,240,90)   },
    { name = "🌿 Menta",    main = Color3.fromRGB(0,210,160),   dark = Color3.fromRGB(0,120,90),   light = Color3.fromRGB(0,255,200)   },
    { name = "🟡 Amarelo",  main = Color3.fromRGB(230,180,0),   dark = Color3.fromRGB(150,110,0),  light = Color3.fromRGB(255,215,0)   },
    { name = "🟠 Laranja",  main = Color3.fromRGB(255,100,0),   dark = Color3.fromRGB(170,50,0),   light = Color3.fromRGB(255,140,30)  },
    { name = "🔴 Vermelho", main = Color3.fromRGB(230,20,20),   dark = Color3.fromRGB(140,0,0),    light = Color3.fromRGB(255,60,60)   },
    { name = "🩷 Rosa",     main = Color3.fromRGB(230,0,130),   dark = Color3.fromRGB(130,0,75),   light = Color3.fromRGB(255,60,180)  },
    { name = "⬜ Branco",   main = Color3.fromRGB(180,180,180), dark = Color3.fromRGB(90,90,90),   light = Color3.fromRGB(220,220,220) },
}

local function getTema(name)
    for _, t in ipairs(TEMAS) do if t.name==name then return t end end
    return TEMAS[1]
end

-- ════════════════════════════════════════
--  CONFIG PADRÃO
-- ════════════════════════════════════════
local Cfg = {
    Tema          = TEMAS[1].name,
    -- ESP
    ESP_On=true, ESP_Caixa=true, ESP_Nome=true, ESP_Vida=true,
    ESP_Tracer=false, ESP_Distancia=false, ESP_Esqueleto=false, ESP_Linha=false,
    -- Aim
    Aim_On=true, Aim_Silent=true, Aim_Part="Head",
    Aim_FOV=120, Aim_Smooth=40, Aim_FOVCircle=false, Aim_Step=false,
    -- Player
    Speed_On=true, Speed_Val=50, Jump_On=false, Jump_Val=100,
    Noclip=false, Fly_On=false, Fly_Val=60,
    Hitbox=false, Hitbox_Val=5, AntiKnock=false, InfJump=false,
    -- Misc
    AdminDet=false, Spectate_On=false, Spectate_Alvo="",
    FreeCam=false, FullBright=false, AntiAFK=false, RejoinAuto=false,
}

-- ════════════════════════════════════════
--  SAVE / LOAD
-- ════════════════════════════════════════
local SAVE_FILE = "CoiledTomHub.json"

local function SaveCfg()
    pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(Cfg)) end)
end

local function LoadCfg()
    pcall(function()
        local t = HttpService:JSONDecode(readfile(SAVE_FILE))
        for k,v in pairs(t) do if Cfg[k]~=nil then Cfg[k]=v end end
    end)
end

LoadCfg()

-- ════════════════════════════════════════
--  HELPERS
-- ════════════════════════════════════════
local function Char()  return LP.Character end
local function Root()  local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum()   local c=Char(); return c and c:FindFirstChildOfClass("Humanoid") end

local function Enemies()
    local list={}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list,p)
        end
    end
    return list
end

local function W2S(pos)
    local sp,vis=Cam:WorldToViewportPoint(pos)
    return Vector2.new(sp.X,sp.Y),vis,sp.Z
end

local function ClosestEnemy()
    local best,bd=nil,math.huge
    local mid=Vector2.new(Cam.ViewportSize.X/2,Cam.ViewportSize.Y/2)
    for _,p in ipairs(Enemies()) do
        local part=p.Character:FindFirstChild(Cfg.Aim_Part) or p.Character:FindFirstChild("Head")
        if part then
            local sp,vis=W2S(part.Position)
            if vis then
                local d=(sp-mid).Magnitude
                if d<Cfg.Aim_FOV and d<bd then bd=d; best=p end
            end
        end
    end
    return best
end

-- ════════════════════════════════════════
--  ESP
-- ════════════════════════════════════════
local espObj={}

local function RemESP(p)
    if espObj[p] then
        for _,d in ipairs(espObj[p]) do pcall(function() d:Remove() end) end
        espObj[p]=nil
    end
end

local function MkESP(p)
    RemESP(p)
    local col=getTema(Cfg.Tema).light
    local o={}
    local box=Drawing.new("Square"); box.Visible=false; box.Color=col; box.Thickness=1.5; box.Filled=false; table.insert(o,box)
    local nm=Drawing.new("Text"); nm.Visible=false; nm.Color=col; nm.Size=14; nm.Center=true; nm.Outline=true; nm.Text=p.Name; table.insert(o,nm)
    local hbg=Drawing.new("Square"); hbg.Visible=false; hbg.Color=Color3.new(0,0,0); hbg.Filled=true; table.insert(o,hbg)
    local hbar=Drawing.new("Square"); hbar.Visible=false; hbar.Filled=true; table.insert(o,hbar)
    local tr=Drawing.new("Line"); tr.Visible=false; tr.Color=col; tr.Thickness=1; table.insert(o,tr)
    local dt=Drawing.new("Text"); dt.Visible=false; dt.Color=col; dt.Size=12; dt.Center=true; table.insert(o,dt)
    espObj[p]=o
end

local function UpdESP()
    local col=getTema(Cfg.Tema).light
    local VP=Cam.ViewportSize
    local myR=Root()
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        local ch=p.Character
        if not ch then RemESP(p); continue end
        local root=ch:FindFirstChild("HumanoidRootPart")
        local head=ch:FindFirstChild("Head")
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if not root or not head or not hum then continue end
        if not espObj[p] then MkESP(p) end
        local o=espObj[p]
        local box,nm,hbg,hbar,tr,dt=o[1],o[2],o[3],o[4],o[5],o[6]
        local rsp,vis,dep=W2S(root.Position)
        local hsp=W2S(head.Position)
        local show=Cfg.ESP_On and vis
        local sc=1/dep*400

        if Cfg.ESP_Caixa and show then
            local w=sc*2.2; local h=math.abs(hsp.Y-rsp.Y)+4
            box.Visible=true; box.Color=col
            box.Position=Vector2.new(rsp.X-w/2,hsp.Y-2)
            box.Size=Vector2.new(w,h)
        else box.Visible=false end

        if Cfg.ESP_Nome and show then
            nm.Visible=true; nm.Color=col
            nm.Position=Vector2.new(rsp.X,hsp.Y-18)
        else nm.Visible=false end

        if Cfg.ESP_Vida and show then
            local hp=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
            local bh=math.abs(hsp.Y-rsp.Y)+4
            local bx=rsp.X-sc*2.2/2-5; local by=hsp.Y-2
            hbg.Visible=true; hbg.Position=Vector2.new(bx-1,by-1); hbg.Size=Vector2.new(4,bh+2)
            hbar.Visible=true; hbar.Position=Vector2.new(bx,by+bh*(1-hp)); hbar.Size=Vector2.new(2,bh*hp)
            hbar.Color=Color3.fromRGB(math.floor((1-hp)*255),math.floor(hp*200),50)
        else hbg.Visible=false; hbar.Visible=false end

        if Cfg.ESP_Tracer and show then
            tr.Visible=true; tr.Color=col
            tr.From=Vector2.new(VP.X/2,VP.Y); tr.To=rsp
        else tr.Visible=false end

        if Cfg.ESP_Distancia and show and myR then
            local d=math.floor((root.Position-myR.Position).Magnitude)
            dt.Visible=true; dt.Color=col
            dt.Position=Vector2.new(rsp.X,rsp.Y+6); dt.Text=d.."m"
        else dt.Visible=false end
    end
    for p in pairs(espObj) do if not p.Parent then RemESP(p) end end
end

-- ════════════════════════════════════════
--  FOV CIRCLE
-- ════════════════════════════════════════
local fovC=Drawing.new("Circle")
fovC.Visible=false; fovC.Thickness=1; fovC.Filled=false; fovC.NumSides=64

local function UpdFOV()
    local VP=Cam.ViewportSize
    fovC.Position=Vector2.new(VP.X/2,VP.Y/2)
    fovC.Radius=Cfg.Aim_FOV
    fovC.Visible=Cfg.Aim_On and Cfg.Aim_FOVCircle
    fovC.Color=getTema(Cfg.Tema).light
end

-- ════════════════════════════════════════
--  AIMBOT
-- ════════════════════════════════════════
local function DoAim(dt)
    if not Cfg.Aim_On then return end
    local target=ClosestEnemy(); if not target then return end
    local part=target.Character:FindFirstChild(Cfg.Aim_Part) or target.Character:FindFirstChild("Head")
    if not part then return end
    local s=math.clamp(dt*(1-Cfg.Aim_Smooth/100)*10,0,1)
    Cam.CFrame=Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position,part.Position),s)
end

-- ════════════════════════════════════════
--  HACKS
-- ════════════════════════════════════════
local flyConn,noclipConn,antiKnockConn,afkConn,infJumpConn

local function ApplySpeed() local h=Hum(); if h then h.WalkSpeed=Cfg.Speed_On and Cfg.Speed_Val or 16 end end
local function ApplyJump()  local h=Hum(); if h then h.JumpPower=Cfg.Jump_On and Cfg.Jump_Val or 50 end end

local function StartNoclip()
    if noclipConn then noclipConn:Disconnect() end
    if not Cfg.Noclip then return end
    noclipConn=RunService.Stepped:Connect(function()
        local ch=Char(); if not ch then return end
        for _,p in ipairs(ch:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end)
end

local function StartFly()
    if flyConn then flyConn:Disconnect() end
    local r=Root(); if not r then return end
    for _,v in ipairs(r:GetChildren()) do if v.Name=="CTFlyBV" then v:Destroy() end end
    if not Cfg.Fly_On then
        local h=Hum(); if h then h:ChangeState(Enum.HumanoidStateType.GettingUp) end; return
    end
    local bp=Instance.new("BodyVelocity",r)
    bp.Name="CTFlyBV"; bp.MaxForce=Vector3.new(1e9,1e9,1e9); bp.Velocity=Vector3.zero
    flyConn=RunService.RenderStepped:Connect(function()
        if not Cfg.Fly_On then bp:Destroy(); flyConn:Disconnect(); return end
        local rt=Root(); if not rt then return end
        local h=Hum(); if h then h:ChangeState(Enum.HumanoidStateType.Physics) end
        local v=Vector3.zero
        local UIS=UserInputService
        if UIS:IsKeyDown(Enum.KeyCode.W) then v=v+Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then v=v-Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then v=v-Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then v=v+Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)       then v=v+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl)  then v=v-Vector3.new(0,1,0) end
        bp.Velocity=v*Cfg.Fly_Val
    end)
end

local origHB={}
local function ApplyHitbox()
    for _,p in ipairs(Enemies()) do
        local ch=p.Character; if not ch then continue end
        local head=ch:FindFirstChild("Head"); if not head then continue end
        if Cfg.Hitbox then
            if not origHB[p] then origHB[p]=head.Size end
            head.Size=Vector3.new(Cfg.Hitbox_Val,Cfg.Hitbox_Val,Cfg.Hitbox_Val)
        else
            if origHB[p] then head.Size=origHB[p]; origHB[p]=nil end
        end
    end
end

local function StartAntiKnock()
    if antiKnockConn then antiKnockConn:Disconnect() end
    if not Cfg.AntiKnock then return end
    antiKnockConn=RunService.Stepped:Connect(function()
        local r=Root(); if not r then return end
        for _,v in ipairs(r:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyForce") then v:Destroy() end
        end
    end)
end

local function StartInfJump()
    if infJumpConn then infJumpConn:Disconnect() end
    if not Cfg.InfJump then return end
    infJumpConn=UserInputService.JumpRequest:Connect(function()
        local h=Hum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function ApplyFullBright()
    local L=game:GetService("Lighting")
    if Cfg.FullBright then
        L.Brightness=2; L.ClockTime=14; L.FogEnd=1e9
        L.GlobalShadows=false; L.Ambient=Color3.new(1,1,1)
    else
        L.Brightness=1; L.ClockTime=14
        L.GlobalShadows=true; L.Ambient=Color3.fromRGB(127,127,127)
    end
end

local function StartAntiAFK()
    if afkConn then afkConn:Disconnect() end
    if not Cfg.AntiAFK then return end
    local vu=LP:FindFirstChildOfClass("VirtualUser") or Instance.new("VirtualUser",LP)
    afkConn=LP.Idled:Connect(function() vu:CaptureController(); vu:ClickButton2(Vector2.zero) end)
end

local function DoSpectate()
    if not Cfg.Spectate_On or Cfg.Spectate_Alvo=="" then
        local h=Hum(); if h then Cam.CameraSubject=h end; return
    end
    local tp=Players:FindFirstChild(Cfg.Spectate_Alvo)
    if tp and tp.Character then
        local th=tp.Character:FindFirstChildOfClass("Humanoid")
        if th then Cam.CameraSubject=th end
    end
end

-- ════════════════════════════════════════
--  GUI
-- ════════════════════════════════════════
if LP.PlayerGui:FindFirstChild("CoiledTomHub") then
    LP.PlayerGui.CoiledTomHub:Destroy()
end

local SG=Instance.new("ScreenGui",LP.PlayerGui)
SG.Name="CoiledTomHub"; SG.ResetOnSpawn=false
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset=true; SG.DisplayOrder=999

local function TC() return getTema(Cfg.Tema) end

-- ══════════════════════════
-- JANELA
-- ══════════════════════════
local Win=Instance.new("Frame",SG)
Win.Name="Win"; Win.Size=UDim2.new(0,460,0,360)
Win.Position=UDim2.new(0.5,-230,0.5,-180)
Win.BackgroundColor3=Color3.fromRGB(12,12,20)
Win.BorderSizePixel=0; Win.ClipsDescendants=false
Instance.new("UICorner",Win).CornerRadius=UDim.new(0,10)
local WinStroke=Instance.new("UIStroke",Win); WinStroke.Thickness=1.5; WinStroke.Color=TC().dark

-- Sombra (usa asset público do Roblox)
local Shdw=Instance.new("ImageLabel",Win)
Shdw.Size=UDim2.new(1,40,1,40); Shdw.Position=UDim2.new(0,-20,0,-20)
Shdw.BackgroundTransparency=1; Shdw.Image="rbxassetid://6014261993"
Shdw.ImageColor3=Color3.new(0,0,0); Shdw.ImageTransparency=0.5
Shdw.ZIndex=Win.ZIndex-1; Shdw.ScaleType=Enum.ScaleType.Slice
Shdw.SliceCenter=Rect.new(49,49,450,450)

-- ══════════════════════════
-- HEADER
-- ══════════════════════════
local Hdr=Instance.new("Frame",Win)
Hdr.Name="Hdr"; Hdr.Size=UDim2.new(1,0,0,42)
Hdr.BackgroundColor3=TC().dark; Hdr.BorderSizePixel=0
Instance.new("UICorner",Hdr).CornerRadius=UDim.new(0,10)
local HdrFix=Instance.new("Frame",Hdr)
HdrFix.Size=UDim2.new(1,0,0.5,0); HdrFix.Position=UDim2.new(0,0,0.5,0)
HdrFix.BackgroundColor3=TC().dark; HdrFix.BorderSizePixel=0
local HdrGrad=Instance.new("UIGradient",Hdr)
HdrGrad.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,TC().dark),
    ColorSequenceKeypoint.new(0.5,TC().main),
    ColorSequenceKeypoint.new(1,TC().dark),
}

local TitleL=Instance.new("TextLabel",Hdr)
TitleL.Size=UDim2.new(1,-44,1,0); TitleL.Position=UDim2.new(0,14,0,0)
TitleL.BackgroundTransparency=1; TitleL.TextColor3=Color3.new(1,1,1)
TitleL.Font=Enum.Font.GothamBold; TitleL.TextSize=13
TitleL.TextXAlignment=Enum.TextXAlignment.Left
TitleL.Text="⚡ COILEDTOM HUB  •  @coiledtom"

local CloseBtn=Instance.new("TextButton",Hdr)
CloseBtn.Size=UDim2.new(0,26,0,26); CloseBtn.Position=UDim2.new(1,-32,0.5,-13)
CloseBtn.BackgroundColor3=Color3.fromRGB(40,10,60); CloseBtn.TextColor3=Color3.new(1,1,1)
CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.TextSize=14; CloseBtn.Text="✕"
CloseBtn.BorderSizePixel=0; CloseBtn.AutoButtonColor=false
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,5)
Instance.new("UIStroke",CloseBtn).Color=Color3.fromRGB(100,50,150)

-- ══════════════════════════
-- SIDEBAR
-- ══════════════════════════
local Side=Instance.new("Frame",Win)
Side.Size=UDim2.new(0,52,1,-42); Side.Position=UDim2.new(0,0,0,42)
Side.BackgroundColor3=Color3.fromRGB(8,8,18); Side.BorderSizePixel=0
local SLn=Instance.new("Frame",Side)
SLn.Size=UDim2.new(0,1,1,0); SLn.Position=UDim2.new(1,-1,0,0)
SLn.BackgroundColor3=Color3.fromRGB(42,26,74); SLn.BorderSizePixel=0
local SLay=Instance.new("UIListLayout",Side)
SLay.Padding=UDim.new(0,4); SLay.HorizontalAlignment=Enum.HorizontalAlignment.Center
Instance.new("UIPadding",Side).PaddingTop=UDim.new(0,8)

-- ══════════════════════════
-- SCROLL
-- ══════════════════════════
local Scroll=Instance.new("ScrollingFrame",Win)
Scroll.Size=UDim2.new(1,-52,1,-42); Scroll.Position=UDim2.new(0,52,0,42)
Scroll.BackgroundTransparency=1; Scroll.BorderSizePixel=0
Scroll.ScrollBarThickness=3; Scroll.ScrollBarImageColor3=TC().dark
Scroll.CanvasSize=UDim2.new(0,0,0,0); Scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
local SPad=Instance.new("UIPadding",Scroll)
SPad.PaddingLeft=UDim.new(0,12); SPad.PaddingRight=UDim.new(0,12)
SPad.PaddingTop=UDim.new(0,8); SPad.PaddingBottom=UDim.new(0,12)
local SLout=Instance.new("UIListLayout",Scroll)
SLout.Padding=UDim.new(0,2); SLout.SortOrder=Enum.SortOrder.LayoutOrder

-- ══════════════════════════
-- SISTEMA DE ABAS
-- ══════════════════════════
local Tabs={}; local TabBtns={}; local CurrentTab=nil
local allToggles={}

local function RefreshTheme()
    local t=TC()
    WinStroke.Color=t.dark
    HdrGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,t.dark),ColorSequenceKeypoint.new(0.5,t.main),ColorSequenceKeypoint.new(1,t.dark)}
    Hdr.BackgroundColor3=t.dark; HdrFix.BackgroundColor3=t.dark
    Scroll.ScrollBarImageColor3=t.dark
    for nm,obj in pairs(TabBtns) do
        local act=nm==CurrentTab
        obj.btn.BackgroundColor3=act and t.dark or Color3.fromRGB(20,10,36)
        obj.stroke.Color=act and t.main or Color3.fromRGB(42,26,74)
    end
    for _,tg in ipairs(allToggles) do
        if tg.on then tg.bg.BackgroundColor3=t.main end
    end
    UpdFOV()
end

local function MkTabBtn(icon, name)
    local btn=Instance.new("TextButton",Side)
    btn.Size=UDim2.new(0,40,0,40); btn.BackgroundColor3=Color3.fromRGB(20,10,36)
    btn.TextColor3=Color3.new(1,1,1); btn.Text=icon
    btn.Font=Enum.Font.GothamBold; btn.TextSize=18
    btn.BorderSizePixel=0; btn.AutoButtonColor=false
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
    local stroke=Instance.new("UIStroke",btn); stroke.Color=Color3.fromRGB(42,26,74); stroke.Thickness=1.5
    TabBtns[name]={btn=btn,stroke=stroke}
    btn.MouseButton1Click:Connect(function()
        for nm,fr in pairs(Tabs) do fr.Visible=(nm==name) end
        CurrentTab=name; RefreshTheme()
    end)
end

local function MkTab(name)
    local f=Instance.new("Frame",Scroll)
    f.Name=name; f.Size=UDim2.new(1,0,0,0); f.AutomaticSize=Enum.AutomaticSize.Y
    f.BackgroundTransparency=1; f.BorderSizePixel=0; f.Visible=false
    Instance.new("UIListLayout",f).Padding=UDim.new(0,2)
    Tabs[name]=f; return f
end

-- ══════════════════════════
-- COMPONENTES
-- ══════════════════════════
local function MkSep(p)
    local s=Instance.new("Frame",p)
    s.Size=UDim2.new(1,0,0,1); s.BackgroundColor3=Color3.fromRGB(42,26,74); s.BorderSizePixel=0
end

local function MkTitle(p,txt)
    local l=Instance.new("TextLabel",p)
    l.Size=UDim2.new(1,0,0,22); l.BackgroundTransparency=1
    l.TextColor3=Color3.fromRGB(110,90,150); l.Font=Enum.Font.GothamBold
    l.TextSize=10; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=txt:upper()
end

-- Toggle
local function MkToggle(p,label,cfgKey,cb)
    local row=Instance.new("Frame",p)
    row.Size=UDim2.new(1,0,0,36); row.BackgroundTransparency=1; row.BorderSizePixel=0

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-50,1,0); lbl.BackgroundTransparency=1
    lbl.TextColor3=Color3.fromRGB(220,210,255); lbl.Font=Enum.Font.Gotham
    lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label

    local bg=Instance.new("TextButton",row)
    bg.Size=UDim2.new(0,36,0,20); bg.Position=UDim2.new(1,-38,0.5,-10)
    bg.BorderSizePixel=0; bg.AutoButtonColor=false; bg.Text=""
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",bg)
    knob.Size=UDim2.new(0,14,0,14); knob.AnchorPoint=Vector2.new(0,0.5)
    knob.Position=UDim2.new(0,2,0.5,0); knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local ref={bg=bg,knob=knob,on=Cfg[cfgKey]}
    table.insert(allToggles,ref)

    local function Refresh()
        local on=Cfg[cfgKey]; ref.on=on; local t=TC()
        TweenService:Create(bg,TweenInfo.new(.2),{BackgroundColor3=on and t.main or Color3.fromRGB(30,20,50)}):Play()
        TweenService:Create(knob,TweenInfo.new(.2),{
            BackgroundColor3=on and Color3.new(1,1,1) or Color3.fromRGB(100,90,130),
            Position=UDim2.new(on and 1 or 0,on and -16 or 2,0.5,0)
        }):Play()
    end
    Refresh()
    bg.MouseButton1Click:Connect(function()
        Cfg[cfgKey]=not Cfg[cfgKey]; Refresh()
        if cb then cb(Cfg[cfgKey]) end; SaveCfg()
    end)
end

-- Slider
local function MkSlider(p,label,cfgKey,mn,mx,cb)
    local row=Instance.new("Frame",p)
    row.Size=UDim2.new(1,0,0,46); row.BackgroundTransparency=1; row.BorderSizePixel=0

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(0.6,0,0,18); lbl.BackgroundTransparency=1
    lbl.TextColor3=Color3.fromRGB(220,210,255); lbl.Font=Enum.Font.Gotham
    lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label

    local vl=Instance.new("TextLabel",row)
    vl.Size=UDim2.new(0.4,0,0,18); vl.Position=UDim2.new(0.6,0,0,0)
    vl.BackgroundTransparency=1; vl.TextColor3=TC().light
    vl.Font=Enum.Font.GothamBold; vl.TextSize=12
    vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Text=tostring(Cfg[cfgKey])

    local track=Instance.new("Frame",row)
    track.Size=UDim2.new(1,0,0,4); track.Position=UDim2.new(0,0,0,28)
    track.BackgroundColor3=Color3.fromRGB(25,15,45); track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame",track)
    fill.Size=UDim2.new((Cfg[cfgKey]-mn)/(mx-mn),0,1,0)
    fill.BackgroundColor3=TC().main; fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("TextButton",track)
    knob.Size=UDim2.new(0,14,0,14); knob.AnchorPoint=Vector2.new(0.5,0.5)
    knob.Position=UDim2.new((Cfg[cfgKey]-mn)/(mx-mn),0,0.5,0)
    knob.BackgroundColor3=TC().light; knob.Text=""; knob.BorderSizePixel=0; knob.AutoButtonColor=false
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    Instance.new("UIStroke",knob).Color=Color3.new(1,1,1)

    local drag=false
    knob.MouseButton1Down:Connect(function() drag=true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    RunService.RenderStepped:Connect(function()
        if not drag then return end
        local pct=math.clamp((UserInputService:GetMouseLocation().X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        local val=math.floor(mn+pct*(mx-mn))
        Cfg[cfgKey]=val; vl.Text=tostring(val)
        fill.Size=UDim2.new(pct,0,1,0); knob.Position=UDim2.new(pct,0,0.5,0)
        if cb then cb(val) end
    end)
end

-- ════════════════════════════════════════
--  DROPDOWN (reutilizável)
-- ════════════════════════════════════════
local activeDrop=nil

local function MkDropdown(p, label, cfgKey, options, cb)
    local row=Instance.new("Frame",p)
    row.Size=UDim2.new(1,0,0,36); row.BackgroundTransparency=1; row.BorderSizePixel=0; row.ClipsDescendants=false

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(0.44,0,1,0); lbl.BackgroundTransparency=1
    lbl.TextColor3=Color3.fromRGB(220,210,255); lbl.Font=Enum.Font.Gotham
    lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label

    local dbtn=Instance.new("TextButton",row)
    dbtn.Size=UDim2.new(0.54,0,0,26); dbtn.Position=UDim2.new(0.46,0,0.5,-13)
    dbtn.BackgroundColor3=TC().dark; dbtn.BorderSizePixel=0
    dbtn.AutoButtonColor=false; dbtn.ClipsDescendants=false
    Instance.new("UICorner",dbtn).CornerRadius=UDim.new(0,5)
    local dStroke=Instance.new("UIStroke",dbtn); dStroke.Color=TC().main

    local dLbl=Instance.new("TextLabel",dbtn)
    dLbl.Size=UDim2.new(1,-22,1,0); dLbl.Position=UDim2.new(0,8,0,0)
    dLbl.BackgroundTransparency=1; dLbl.TextColor3=Color3.new(1,1,1)
    dLbl.Font=Enum.Font.Gotham; dLbl.TextSize=12
    dLbl.TextXAlignment=Enum.TextXAlignment.Left; dLbl.Text=tostring(Cfg[cfgKey])

    local arrow=Instance.new("TextLabel",dbtn)
    arrow.Size=UDim2.new(0,20,1,0); arrow.Position=UDim2.new(1,-22,0,0)
    arrow.BackgroundTransparency=1; arrow.TextColor3=Color3.new(1,1,1)
    arrow.Font=Enum.Font.GothamBold; arrow.TextSize=12; arrow.Text="▼"

    local menu=Instance.new("Frame",dbtn)
    menu.Size=UDim2.new(1,0,0,#options*28+4)
    menu.Position=UDim2.new(0,0,1,3)
    menu.BackgroundColor3=Color3.fromRGB(16,8,28)
    menu.BorderSizePixel=0; menu.Visible=false; menu.ZIndex=30; menu.ClipsDescendants=false
    Instance.new("UICorner",menu).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",menu).Color=TC().dark
    local mlay=Instance.new("UIListLayout",menu); mlay.Padding=UDim.new(0,0)
    Instance.new("UIPadding",menu).PaddingTop=UDim.new(0,2)

    for _,opt in ipairs(options) do
        local item=Instance.new("TextButton",menu)
        item.Size=UDim2.new(1,0,0,26); item.BackgroundTransparency=1
        item.TextColor3=(tostring(Cfg[cfgKey])==tostring(opt)) and TC().light or Color3.fromRGB(200,190,230)
        item.Font=Enum.Font.Gotham; item.TextSize=12
        item.Text="  "..tostring(opt)
        item.TextXAlignment=Enum.TextXAlignment.Left
        item.BorderSizePixel=0; item.AutoButtonColor=false; item.ZIndex=31

        item.MouseEnter:Connect(function() item.BackgroundTransparency=0; item.BackgroundColor3=TC().dark end)
        item.MouseLeave:Connect(function() item.BackgroundTransparency=1 end)

        item.MouseButton1Click:Connect(function()
            Cfg[cfgKey]=opt; dLbl.Text=tostring(opt)
            menu.Visible=false; activeDrop=nil; arrow.Text="▼"
            for _,c in ipairs(menu:GetChildren()) do
                if c:IsA("TextButton") then
                    local clean=c.Text:match("^%s*(.-)%s*$")
                    c.TextColor3=(clean==tostring(opt)) and TC().light or Color3.fromRGB(200,190,230)
                end
            end
            if cb then cb(opt) end
            SaveCfg()
        end)
    end

    dbtn.MouseButton1Click:Connect(function()
        if activeDrop and activeDrop~=menu then activeDrop.Visible=false end
        menu.Visible=not menu.Visible
        arrow.Text=menu.Visible and "▲" or "▼"
        activeDrop=menu.Visible and menu or nil
    end)
end

-- ════════════════════════════════════════
--  MONTAR ABAS
-- ════════════════════════════════════════
MkTabBtn("👁","ESP")
MkTabBtn("🎯","Aim")
MkTabBtn("⚡","Player")
MkTabBtn("🔧","Misc")
MkTabBtn("⚙️","Config")

-- ─── TAB ESP ───
local tESP=MkTab("ESP")
MkToggle(tESP,"👁  Ativar ESP",       "ESP_On",nil)
MkSep(tESP)
MkToggle(tESP,"📦  ESP Caixa",        "ESP_Caixa",nil)
MkToggle(tESP,"🏷️  ESP Nome",          "ESP_Nome",nil)
MkToggle(tESP,"❤️  ESP Vida",           "ESP_Vida",nil)
MkToggle(tESP,"📏  ESP Distância",     "ESP_Distancia",nil)
MkToggle(tESP,"➡️  ESP Tracer",         "ESP_Tracer",nil)
MkToggle(tESP,"🦴  ESP Esqueleto",     "ESP_Esqueleto",nil)
MkToggle(tESP,"📍  ESP Linha",         "ESP_Linha",nil)

-- ─── TAB AIM ───
local tAim=MkTab("Aim")
MkToggle(tAim,"🎯  Ativar Aimbot",    "Aim_On",nil)
MkToggle(tAim,"👻  Silent Aim",        "Aim_Silent",nil)
MkToggle(tAim,"⭕  FOV Circle",        "Aim_FOVCircle",function() UpdFOV() end)
MkToggle(tAim,"🪜  Aim Step",          "Aim_Step",nil)
MkSep(tAim)
MkDropdown(tAim,"🎯  Aim Part","Aim_Part",{"Head","HumanoidRootPart","Torso"},nil)
MkSep(tAim)
MkSlider(tAim,"📐  FOV",              "Aim_FOV",10,500,function() UpdFOV() end)
MkSlider(tAim,"🌊  Smoothness",       "Aim_Smooth",1,100,nil)

-- ─── TAB PLAYER ───
local tPly=MkTab("Player")
MkToggle(tPly,"💨  Speed Hack",       "Speed_On",function() ApplySpeed() end)
MkSlider(tPly,"🏃  Velocidade",       "Speed_Val",16,200,function() ApplySpeed() end)
MkSep(tPly)
MkToggle(tPly,"🦘  Jump Hack",        "Jump_On",function() ApplyJump() end)
MkSlider(tPly,"⬆️  Jump Power",        "Jump_Val",50,500,function() ApplyJump() end)
MkSep(tPly)
MkToggle(tPly,"👻  Noclip",            "Noclip",function() StartNoclip() end)
MkToggle(tPly,"🦅  Fly",               "Fly_On",function() StartFly() end)
MkSlider(tPly,"🌬️  Vel. Fly",           "Fly_Val",10,300,nil)
MkSep(tPly)
MkToggle(tPly,"📦  Hitbox Expander",  "Hitbox",function() ApplyHitbox() end)
MkSlider(tPly,"📏  Hitbox Size",       "Hitbox_Val",1,20,function() ApplyHitbox() end)
MkSep(tPly)
MkToggle(tPly,"🛡️  Anti-Knockback",    "AntiKnock",function() StartAntiKnock() end)
MkToggle(tPly,"🔁  Infinite Jump",     "InfJump",function() StartInfJump() end)

-- ─── TAB MISC ───
local tMisc=MkTab("Misc")
MkToggle(tMisc,"🕵️  Admin Detector",   "AdminDet",nil)
MkToggle(tMisc,"💡  Full Bright",       "FullBright",function() ApplyFullBright() end)
MkToggle(tMisc,"🔒  Anti-AFK",          "AntiAFK",function() StartAntiAFK() end)
MkToggle(tMisc,"🔄  Rejoin Auto",       "RejoinAuto",nil)
MkToggle(tMisc,"🎥  Free Câmera",       "FreeCam",nil)
MkSep(tMisc)
MkTitle(tMisc,"👀  spectate — selecionar player")

-- Lista dinâmica de players
local SpecCont=Instance.new("Frame",tMisc)
SpecCont.Size=UDim2.new(1,0,0,0); SpecCont.AutomaticSize=Enum.AutomaticSize.Y
SpecCont.BackgroundTransparency=1; SpecCont.BorderSizePixel=0
Instance.new("UIListLayout",SpecCont).Padding=UDim.new(0,3)

local function RefreshSpec()
    for _,c in ipairs(SpecCont:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
    local list=Players:GetPlayers(); local found=false
    for _,p in ipairs(list) do
        if p==LP then continue end; found=true
        local hum=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        local hp=hum and math.floor(hum.Health).."hp" or "?"
        local dist="?m"
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and Root() then
            dist=math.floor((p.Character.HumanoidRootPart.Position-Root().Position).Magnitude).."m"
        end
        local btn=Instance.new("TextButton",SpecCont)
        btn.Size=UDim2.new(1,0,0,34); btn.BorderSizePixel=0
        btn.AutoButtonColor=false; btn.Font=Enum.Font.Gotham; btn.TextSize=12
        btn.TextColor3=Color3.fromRGB(220,210,255); btn.TextXAlignment=Enum.TextXAlignment.Left
        btn.Text="  👤 "..p.Name.."   "..dist.."  •  "..hp
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        local stk=Instance.new("UIStroke",btn); stk.Thickness=1.2
        local sel=Cfg.Spectate_Alvo==p.Name
        btn.BackgroundColor3=sel and TC().dark or Color3.fromRGB(14,8,26)
        stk.Color=sel and TC().main or Color3.fromRGB(42,26,74)
        btn.MouseButton1Click:Connect(function()
            Cfg.Spectate_Alvo=p.Name; DoSpectate(); RefreshSpec(); SaveCfg()
        end)
    end
    if not found then
        local note=Instance.new("TextLabel",SpecCont)
        note.Size=UDim2.new(1,0,0,28); note.BackgroundTransparency=1
        note.TextColor3=Color3.fromRGB(110,90,150); note.Font=Enum.Font.Gotham
        note.TextSize=11; note.Text="  Nenhum player no servidor"
    end
end

RefreshSpec()
Players.PlayerAdded:Connect(RefreshSpec)
Players.PlayerRemoving:Connect(function() task.wait(0.1); RefreshSpec() end)
MkSep(tMisc)
MkToggle(tMisc,"📺  Ativar Spectate",  "Spectate_On",function() DoSpectate() end)

-- ─── TAB CONFIG ───
local tCfg=MkTab("Config")
MkTitle(tCfg,"🎨  tema de cor")

-- DROPDOWN DE CORES
local temaOpts={}
for _,t in ipairs(TEMAS) do table.insert(temaOpts,t.name) end
MkDropdown(tCfg,"🎨  Cor do Hub","Tema",temaOpts,function(val)
    Cfg.Tema=val; RefreshTheme(); SaveCfg()
end)

MkSep(tCfg)
MkTitle(tCfg,"💾  salvar / resetar")

local saveBtn=Instance.new("TextButton",tCfg)
saveBtn.Size=UDim2.new(1,0,0,36); saveBtn.BackgroundColor3=TC().dark
saveBtn.TextColor3=Color3.new(1,1,1); saveBtn.Font=Enum.Font.GothamBold
saveBtn.TextSize=13; saveBtn.Text="💾  SALVAR CONFIGURAÇÕES"
saveBtn.BorderSizePixel=0; saveBtn.AutoButtonColor=false
Instance.new("UICorner",saveBtn).CornerRadius=UDim.new(0,7)
local saveBtnStroke=Instance.new("UIStroke",saveBtn); saveBtnStroke.Color=TC().main

saveBtn.MouseButton1Click:Connect(function()
    SaveCfg()
    saveBtn.Text="✅  SALVO!"
    task.delay(1.5,function() saveBtn.Text="💾  SALVAR CONFIGURAÇÕES" end)
end)

local resetBtn=Instance.new("TextButton",tCfg)
resetBtn.Size=UDim2.new(1,0,0,36); resetBtn.BackgroundColor3=Color3.fromRGB(80,0,0)
resetBtn.TextColor3=Color3.new(1,1,1); resetBtn.Font=Enum.Font.GothamBold
resetBtn.TextSize=13; resetBtn.Text="🗑️  RESETAR CONFIGURAÇÕES"
resetBtn.BorderSizePixel=0; resetBtn.AutoButtonColor=false
Instance.new("UICorner",resetBtn).CornerRadius=UDim.new(0,7)
Instance.new("UIStroke",resetBtn).Color=Color3.fromRGB(180,0,0)
resetBtn.MouseButton1Click:Connect(function()
    pcall(function() delfile(SAVE_FILE) end)
    SG:Destroy()
end)

MkSep(tCfg)
local verLbl=Instance.new("TextLabel",tCfg)
verLbl.Size=UDim2.new(1,0,0,22); verLbl.BackgroundTransparency=1
verLbl.TextColor3=Color3.fromRGB(100,80,140); verLbl.Font=Enum.Font.Gotham
verLbl.TextSize=11; verLbl.TextXAlignment=Enum.TextXAlignment.Left
verLbl.Text="  CoiledTom Hub v2.3.0  •  RightCtrl = toggle GUI"

-- ════════════════════════════════════════
--  DRAG
-- ════════════════════════════════════════
do
    local drag,dinput,dstart,dpos
    Hdr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; dstart=i.Position; dpos=Win.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    Hdr.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            dinput=i
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i==dinput and drag then
            local d=i.Position-dstart
            Win.Position=UDim2.new(dpos.X.Scale,dpos.X.Offset+d.X,dpos.Y.Scale,dpos.Y.Offset+d.Y)
        end
    end)
end

-- ════════════════════════════════════════
--  TOGGLE GUI
-- ════════════════════════════════════════
local visible=true
local lastTriple=0

local function ToggleGui()
    visible=not visible; Win.Visible=visible
end

CloseBtn.MouseButton1Click:Connect(function() visible=false; Win.Visible=false end)

UserInputService.InputBegan:Connect(function(i,gpe)
    if gpe then return end
    if i.KeyCode==Enum.KeyCode.RightControl then ToggleGui(); return end
    if i.UserInputType==Enum.UserInputType.Touch then
        local touches=UserInputService:GetTouchPositions()
        if #touches>=3 then
            local now=tick()
            if now-lastTriple<0.5 and now-lastTriple>0.05 then
                ToggleGui(); lastTriple=0
            else
                lastTriple=now
            end
        end
    end
end)

-- ════════════════════════════════════════
--  ATIVAR ABA INICIAL
-- ════════════════════════════════════════
local function ActivateTab(name)
    for nm,fr in pairs(Tabs) do fr.Visible=(nm==name) end
    CurrentTab=name; RefreshTheme()
end
ActivateTab("ESP")

-- ════════════════════════════════════════
--  LOOP PRINCIPAL
-- ════════════════════════════════════════
RunService.RenderStepped:Connect(function(dt)
    if Cfg.ESP_On then UpdESP()
    else for p in pairs(espObj) do RemESP(p) end end
    UpdFOV()
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then DoAim(dt) end
    ApplyHitbox()
end)

task.spawn(function()
    while task.wait(0.5) do
        ApplySpeed(); ApplyJump()
        if Cfg.FullBright  then ApplyFullBright() end
        if Cfg.Spectate_On then DoSpectate() end
        if Cfg.AdminDet then
            for _,p in ipairs(Players:GetPlayers()) do
                if p.UserId==game.CreatorId then
                    warn("⚠️ [CoiledTom] ADMIN: "..p.Name)
                end
            end
        end
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(1)
    ApplySpeed(); ApplyJump()
    StartNoclip(); StartFly()
    StartAntiKnock(); StartAntiAFK(); StartInfJump()
end)

print("✅ CoiledTom Hub v2.3.0 carregado!")
print("   PC     → RightControl = toggle GUI")
print("   Mobile → 3 dedos 2× = toggle GUI")
