-- =========================================================================
--  K E Y S Y S T E M  —  PANDAUTH  (V2 API Oficial)
--  Author : CoiledTom  |  Repo: github.com/CoiledTom/Lajib
-- =========================================================================
--  Use este arquivo para validar keys pelo PandAuth (pandadevelopments.net)
--  Documentação oficial: https://dash.pandauth.com/dashboard/documentation
--
--  API usada: GET https://pandadevelopment.net/v2_validation
--    Parâmetros: ?service={SERVICE_ID}&hwid={HWID}&key={KEY}
--    Resposta  : { "V2_Authentication": true/false }
--
--  Como usar no seu script (copie e cole o loadstring abaixo):
--    loadstring(game:HttpGet(
--        "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/KeySystem_Panda.lua"
--    ))()
-- =========================================================================

-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║                   CONFIGURAÇÃO  —  EDITE AQUI                        ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local SERVICE_ID  = "SEU-SERVICE-ID-AQUI"
--  ↑ Service ID do seu projeto no PandAuth
--    Encontre em: https://dash.pandauth.com → seu projeto → Settings

local TITLE       = "Meu Script"
--  ↑ Nome exibido no topo do painel de key

local THEME       = "Holographic"
--  ↑ Tema visual. Opções:
--    "Holographic" | "Crimson" | "Void" | "Volcano" | "Love"
--    "Forest" | "Ocean" | "Gold" | "Black" | "White" | "Brown"

local GET_KEY_URL = ""
--  ↑ Link para o usuário pegar a key (Lootlabs, Linkvertise etc.)
--    Deixe "" se não quiser exibir o botão "Onde pegar a Key?"

-- Chamado quando a key for VÁLIDA — coloque aqui o carregamento do script
local ON_SUCCESS = function(input)
    print("[KeySystem Panda] Key válida:", input, "— Carregando script...")
    -- Exemplo:
    -- loadstring(game:HttpGet(
    --     "https://raw.githubusercontent.com/SeuUser/SeuRepo/main/SeuScript.lua"
    -- ))()
end

-- Chamado quando a key for INVÁLIDA (opcional)
local ON_FAIL = function(input)
    print("[KeySystem Panda] Key inválida:", input)
end

-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║             NÃO EDITE ABAIXO DESTA LINHA                             ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local TweenService  = game:GetService("TweenService")
local CoreGui       = game:GetService("CoreGui")
local HttpService   = game:GetService("HttpService")
local Players       = game:GetService("Players")

-- Themes (subconjunto idêntico ao SystemUI)
local Themes = {
    Holographic={Bg=Color3.fromRGB(10,15,25), Header=Color3.fromRGB(8,12,22),  Card=Color3.fromRGB(15,22,38),   Accent=Color3.fromRGB(0,220,255),  Dim=Color3.fromRGB(100,130,170),Text=Color3.fromRGB(230,240,255),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,80),  Input=Color3.fromRGB(20,28,48)},
    Crimson    ={Bg=Color3.fromRGB(18,8,10),  Header=Color3.fromRGB(12,5,7),   Card=Color3.fromRGB(28,12,15),   Accent=Color3.fromRGB(255,50,80),  Dim=Color3.fromRGB(155,95,110), Text=Color3.fromRGB(255,228,232),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,80,80),  Input=Color3.fromRGB(36,16,20)},
    Void       ={Bg=Color3.fromRGB(8,6,18),   Header=Color3.fromRGB(5,4,14),   Card=Color3.fromRGB(14,10,30),   Accent=Color3.fromRGB(160,80,255), Dim=Color3.fromRGB(110,90,155), Text=Color3.fromRGB(232,222,255),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,80),  Input=Color3.fromRGB(20,14,40)},
    Volcano    ={Bg=Color3.fromRGB(18,7,4),   Header=Color3.fromRGB(12,5,3),   Card=Color3.fromRGB(30,13,6),    Accent=Color3.fromRGB(255,110,20), Dim=Color3.fromRGB(160,105,70), Text=Color3.fromRGB(255,235,215),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,30),  Input=Color3.fromRGB(38,18,8)},
    Love       ={Bg=Color3.fromRGB(18,6,14),  Header=Color3.fromRGB(12,4,10),  Card=Color3.fromRGB(30,10,24),   Accent=Color3.fromRGB(255,90,155), Dim=Color3.fromRGB(160,95,135), Text=Color3.fromRGB(255,228,242),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,80),  Input=Color3.fromRGB(40,14,32)},
    Forest     ={Bg=Color3.fromRGB(6,14,8),   Header=Color3.fromRGB(4,10,6),   Card=Color3.fromRGB(10,24,14),   Accent=Color3.fromRGB(50,220,100), Dim=Color3.fromRGB(95,155,110), Text=Color3.fromRGB(218,255,228),Ok=Color3.fromRGB(80,255,120),Err=Color3.fromRGB(255,80,80),  Input=Color3.fromRGB(14,32,18)},
    Ocean      ={Bg=Color3.fromRGB(4,12,26),  Header=Color3.fromRGB(3,8,18),   Card=Color3.fromRGB(8,20,44),    Accent=Color3.fromRGB(0,185,255),  Dim=Color3.fromRGB(95,145,185), Text=Color3.fromRGB(215,238,255),Ok=Color3.fromRGB(0,255,190), Err=Color3.fromRGB(255,80,80),  Input=Color3.fromRGB(12,26,55)},
    Gold       ={Bg=Color3.fromRGB(14,11,4),  Header=Color3.fromRGB(10,8,3),   Card=Color3.fromRGB(24,18,6),    Accent=Color3.fromRGB(255,195,45), Dim=Color3.fromRGB(160,138,78), Text=Color3.fromRGB(255,248,225),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,80,80),  Input=Color3.fromRGB(32,24,8)},
    Black      ={Bg=Color3.fromRGB(5,5,6),    Header=Color3.fromRGB(3,3,4),    Card=Color3.fromRGB(12,12,14),   Accent=Color3.fromRGB(220,220,240),Dim=Color3.fromRGB(110,110,130),Text=Color3.fromRGB(230,230,240),Ok=Color3.fromRGB(0,210,130), Err=Color3.fromRGB(230,60,60),  Input=Color3.fromRGB(16,16,20)},
    White      ={Bg=Color3.fromRGB(240,242,248),Header=Color3.fromRGB(228,232,244),Card=Color3.fromRGB(220,226,240),Accent=Color3.fromRGB(60,90,200),Dim=Color3.fromRGB(100,110,150),Text=Color3.fromRGB(30,35,55),Ok=Color3.fromRGB(0,160,90),  Err=Color3.fromRGB(200,40,50),  Input=Color3.fromRGB(210,216,232)},
    Brown      ={Bg=Color3.fromRGB(20,13,8),  Header=Color3.fromRGB(14,9,5),   Card=Color3.fromRGB(34,21,13),   Accent=Color3.fromRGB(200,140,70), Dim=Color3.fromRGB(160,125,90), Text=Color3.fromRGB(255,240,220),Ok=Color3.fromRGB(0,220,140), Err=Color3.fromRGB(220,70,60),  Input=Color3.fromRGB(44,27,16)},
}
local T = Themes[THEME] or Themes.Holographic

-- =========================================================================
--  UTILIDADES INTERNAS
-- =========================================================================
local function Tw(i,p,t,s,d)
    TweenService:Create(i, TweenInfo.new(t or 0.22, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out), p):Play()
end
local function Cr(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 6);c.Parent=p end
local function Sk(p,c,th,tr) local s=Instance.new("UIStroke");s.Color=c;s.Thickness=th or 1;s.Transparency=tr or 0;s.Parent=p;return s end

local function MakeLbl(par, txt, x, y, w, h, sz, bold, clr, xa)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = txt; l.TextColor3 = clr or T.Text
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = sz or 12
    l.Position = UDim2.new(0, x, 0, y)
    l.Size = UDim2.new(0, w, 0, h)
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.Parent = par; return l
end

-- =========================================================================
--  OBTER HWID  (tenta RbxAnalyticsService, cai de volta para UserId)
-- =========================================================================
local function GetHWID()
    local ok, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and hwid and hwid ~= "" then return hwid end
    return tostring(Players.LocalPlayer.UserId)
end

-- =========================================================================
--  VALIDAÇÃO  (PandAuth V2 API)
-- =========================================================================
local function ValidatePanda(key)
    local hwid = GetHWID()
    local url  = string.format(
        "https://pandadevelopment.net/v2_validation?service=%s&hwid=%s&key=%s",
        SERVICE_ID, hwid, key
    )
    local ok, raw = pcall(function() return game:HttpGet(url, true) end)
    if not ok then return false, "✕ Erro de rede. Tente novamente." end

    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and type(data) == "table" then
        local valid = data.V2_Authentication == true
        if valid then
            return true, "✓ Key válida! Carregando..."
        else
            return false, "✕ Key inválida ou expirada."
        end
    end
    return false, "✕ Resposta inesperada da API."
end

-- =========================================================================
--  INTERFACE
-- =========================================================================
if CoreGui:FindFirstChild("KS_Panda") then CoreGui.KS_Panda:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "KS_Panda"; Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true; Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = CoreGui

-- Dark overlay
local Ov = Instance.new("Frame")
Ov.Size = UDim2.new(1,0,1,0); Ov.BackgroundColor3 = Color3.new(0,0,0)
Ov.BackgroundTransparency = 0.5; Ov.BorderSizePixel = 0; Ov.Parent = Gui

-- Card principal
local Card = Instance.new("Frame")
Card.Size = UDim2.new(0,0,0,0)
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.BackgroundColor3 = T.Bg
Card.BackgroundTransparency = 0.04
Card.BorderSizePixel = 0
Card.Parent = Gui
Cr(Card, 12)
local csk = Sk(Card, T.Accent, 1.5, 0.25)
Tw(Card, {Size = UDim2.new(0, 360, 0, 280)}, 0.5, Enum.EasingStyle.Back)

-- Header
local Hdr = Instance.new("Frame")
Hdr.Size = UDim2.new(1,0,0,58); Hdr.BackgroundColor3 = T.Header
Hdr.BackgroundTransparency = 0.05; Hdr.BorderSizePixel = 0; Hdr.Parent = Card; Cr(Hdr, 12)
-- Quadrar cantos inferiores do header
local HB = Instance.new("Frame"); HB.Size = UDim2.new(1,0,0,12); HB.Position = UDim2.new(0,0,1,-12)
HB.BackgroundColor3 = T.Header; HB.BackgroundTransparency = 0.05; HB.BorderSizePixel = 0; HB.Parent = Hdr
-- Linha de acento
local HL = Instance.new("Frame"); HL.Size = UDim2.new(1,0,0,1); HL.Position = UDim2.new(0,0,1,0)
HL.BackgroundColor3 = T.Accent; HL.BackgroundTransparency = 0.45; HL.BorderSizePixel = 0; HL.Parent = Hdr

MakeLbl(Hdr, TITLE,               12, 8,  300, 22, 16, true,  T.Accent)
MakeLbl(Hdr, "PandAuth — Digite sua key para continuar", 12, 32, 300, 14, 11, false, T.Dim)

-- Corpo
local Body = Instance.new("Frame")
Body.Size = UDim2.new(1,0,1,-58); Body.Position = UDim2.new(0,0,0,58)
Body.BackgroundTransparency = 1; Body.Parent = Card

-- Badge tipo
local badge = Instance.new("TextLabel")
badge.Size = UDim2.new(0,130,0,20); badge.Position = UDim2.new(0,14,0,10)
badge.BackgroundColor3 = T.Card; badge.BackgroundTransparency = 0.2
badge.Text = "TIPO: PANDAUTH V2"; badge.TextColor3 = T.Accent
badge.Font = Enum.Font.GothamBold; badge.TextSize = 10; badge.Parent = Body
Cr(badge, 4); Sk(badge, T.Accent, 1, 0.55)

-- Service ID (exibe truncado)
local sidShort = SERVICE_ID:sub(1, 28) .. (#SERVICE_ID > 28 and "..." or "")
MakeLbl(Body, "Service ID: " .. sidShort, 14, 36, 330, 14, 10, false, T.Dim)

-- Input de key
local ibg = Instance.new("Frame")
ibg.Size = UDim2.new(1,-28,0,40); ibg.Position = UDim2.new(0,14,0,56)
ibg.BackgroundColor3 = T.Input; ibg.BackgroundTransparency = 0.15
ibg.BorderSizePixel = 0; ibg.Parent = Body; Cr(ibg, 8)
local isk = Sk(ibg, T.Accent, 1, 0.6)

local tb = Instance.new("TextBox")
tb.Size = UDim2.new(1,-12,1,0); tb.Position = UDim2.new(0,6,0,0)
tb.BackgroundTransparency = 1; tb.Text = ""
tb.PlaceholderText = "Cole sua key PandAuth aqui..."
tb.PlaceholderColor3 = T.Dim; tb.TextColor3 = T.Text
tb.Font = Enum.Font.GothamMedium; tb.TextSize = 13
tb.ClearTextOnFocus = false; tb.Parent = ibg
-- Padding interno
local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0,5); pad.PaddingRight = UDim.new(0,5); pad.Parent = tb
tb.Focused:Connect(function() Tw(ibg,{BackgroundTransparency=0.04},0.14); Tw(isk,{Transparency=0.15},0.14) end)
tb.FocusLost:Connect(function() Tw(ibg,{BackgroundTransparency=0.15},0.14); Tw(isk,{Transparency=0.6},0.14) end)

-- Status
local statusLbl = MakeLbl(Body, "", 14, 103, 330, 16, 11, false, T.Dim)

-- Botão Validar
local vBtn = Instance.new("TextButton")
vBtn.Size = UDim2.new(1,-28,0,42); vBtn.Position = UDim2.new(0,14,0,124)
vBtn.BackgroundColor3 = T.Accent; vBtn.BackgroundTransparency = 0.15
vBtn.Text = "Validar Key"; vBtn.TextColor3 = Color3.new(1,1,1)
vBtn.Font = Enum.Font.GothamBold; vBtn.TextSize = 14; vBtn.Parent = Body
Cr(vBtn, 8); Sk(vBtn, T.Accent, 1, 0.4)
vBtn.MouseEnter:Connect(function() Tw(vBtn,{BackgroundTransparency=0},0.12) end)
vBtn.MouseLeave:Connect(function() Tw(vBtn,{BackgroundTransparency=0.15},0.12) end)

-- Botão "Onde pegar a Key?" (opcional)
if GET_KEY_URL ~= "" then
    local gBtn = Instance.new("TextButton")
    gBtn.Size = UDim2.new(1,-28,0,30); gBtn.Position = UDim2.new(0,14,0,178)
    gBtn.BackgroundColor3 = T.Card; gBtn.BackgroundTransparency = 0.2
    gBtn.Text = "📋  Onde pegar a Key? (copia link)"
    gBtn.TextColor3 = T.Accent; gBtn.Font = Enum.Font.GothamBold
    gBtn.TextSize = 12; gBtn.Parent = Body; Cr(gBtn, 6); Sk(gBtn, T.Accent, 1, 0.55)
    gBtn.MouseButton1Click:Connect(function()
        pcall(function() if setclipboard then setclipboard(GET_KEY_URL) end end)
        statusLbl.Text = "Link copiado! Abra no navegador."
        statusLbl.TextColor3 = T.Accent
    end)
end

-- Footer
MakeLbl(Body, "Created by CoiledTom", 0, 250, 360, 14, 10, false, T.Dim, Enum.TextXAlignment.Center)

-- =========================================================================
--  LÓGICA DE VALIDAÇÃO
-- =========================================================================
vBtn.MouseButton1Click:Connect(function()
    local input = tb.Text:gsub("%s+", "")
    if input == "" then
        statusLbl.Text = "Por favor, insira a key."
        statusLbl.TextColor3 = T.Err; return
    end

    vBtn.Text = "Consultando PandAuth..."
    statusLbl.Text = "Conectando à API..."
    statusLbl.TextColor3 = T.Dim
    Tw(vBtn, {BackgroundTransparency = 0.4}, 0.12)

    task.spawn(function()
        local valid, msg = ValidatePanda(input)
        Tw(vBtn, {BackgroundTransparency = 0.15}, 0.12)
        vBtn.Text = "Validar Key"
        statusLbl.Text = msg

        if valid then
            statusLbl.TextColor3 = T.Ok
            Tw(csk, {Color = T.Ok}, 0.3)
            -- Animação de sucesso e fechamento
            task.wait(0.8)
            Tw(Ov,   {BackgroundTransparency = 1}, 0.4)
            Tw(Card, {Size = UDim2.new(0,0,0,0)}, 0.4, Enum.EasingStyle.Back)
            task.wait(0.45)
            Gui:Destroy()
            task.spawn(ON_SUCCESS, input)
        else
            statusLbl.TextColor3 = T.Err
            Tw(csk, {Color = T.Err}, 0.15)
            task.wait(0.55)
            Tw(csk, {Color = T.Accent}, 0.35)
            -- Pisca o input de vermelho
            Tw(ibg, {BackgroundColor3 = Color3.fromRGB(60, 18, 18)}, 0.12)
            task.wait(0.4)
            Tw(ibg, {BackgroundColor3 = T.Input}, 0.25)
            task.spawn(ON_FAIL, input)
        end
    end)
end)
