-- =========================================================================
--  K E Y S Y S T E M  —  PANDAUTH  (API Oficial V2)
--  Author : CoiledTom  |  Repo: github.com/CoiledTom/Lajib
-- =========================================================================
--  API: POST https://new.pandadevelopment.net/api/v1/keys/validate
--  Body: { ServiceID, HWID, Key }
--  Resposta: { Authenticated_Status = "Success" }
--  Get Key: https://new.pandadevelopment.net/getkey/{ServiceID}
--
--  Documentação: https://dash.pandauth.com/dashboard/documentation
--
--  loadstring(game:HttpGet(
--      "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/KeySystem_Panda.lua"
--  ))()
-- =========================================================================

-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║                   CONFIGURAÇÃO  —  EDITE AQUI                        ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local SERVICE_ID  = "SEU-SERVICE-ID-AQUI"
--  ↑ Service ID do seu projeto PandAuth
--    Encontre em: https://dash.pandauth.com → seu projeto → Settings

local TITLE       = "Meu Script"
--  ↑ Nome exibido no painel de key

local THEME       = "Holographic"
--  ↑ Tema visual. Opções disponíveis:
--    "Holographic" | "Crimson" | "Void" | "Volcano" | "Love"
--    "Forest"      | "Ocean"   | "Gold" | "Black"   | "White" | "Brown"

local SAVE_FILE   = "CoiledTomHub_Panda.key"
--  ↑ Nome do arquivo onde a key válida será salva
--    Na próxima execução, se a key salva ainda for válida, pula o painel

-- Chamado quando a key for VÁLIDA — carregue seu script aqui
local ON_SUCCESS = function(key)
    print("[KeySystem Panda] ✓ Key válida. Carregando script...")
    -- Exemplo:
    -- loadstring(game:HttpGet(
    --     "https://raw.githubusercontent.com/SeuUser/SeuRepo/main/SeuScript.lua"
    -- ))()
end

-- Chamado quando a key for INVÁLIDA (opcional)
local ON_FAIL = function(key)
    print("[KeySystem Panda] ✕ Key inválida:", key)
end

-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║             NÃO EDITE ABAIXO DESTA LINHA                             ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local HttpService  = game:GetService("HttpService")
local Players      = game:GetService("Players")

-- ── Temas ─────────────────────────────────────────────────────────────────
local Themes = {
    Holographic={Bg=Color3.fromRGB(10,15,25), Hdr=Color3.fromRGB(8,12,22),  Card=Color3.fromRGB(15,22,38),   Acc=Color3.fromRGB(0,220,255),  Dim=Color3.fromRGB(100,130,170),Txt=Color3.fromRGB(230,240,255),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,80),  Inp=Color3.fromRGB(20,28,48)},
    Crimson    ={Bg=Color3.fromRGB(18,8,10),  Hdr=Color3.fromRGB(12,5,7),   Card=Color3.fromRGB(28,12,15),   Acc=Color3.fromRGB(255,50,80),  Dim=Color3.fromRGB(155,95,110), Txt=Color3.fromRGB(255,228,232),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,80,80),  Inp=Color3.fromRGB(36,16,20)},
    Void       ={Bg=Color3.fromRGB(8,6,18),   Hdr=Color3.fromRGB(5,4,14),   Card=Color3.fromRGB(14,10,30),   Acc=Color3.fromRGB(160,80,255), Dim=Color3.fromRGB(110,90,155), Txt=Color3.fromRGB(232,222,255),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,80),  Inp=Color3.fromRGB(20,14,40)},
    Volcano    ={Bg=Color3.fromRGB(18,7,4),   Hdr=Color3.fromRGB(12,5,3),   Card=Color3.fromRGB(30,13,6),    Acc=Color3.fromRGB(255,110,20), Dim=Color3.fromRGB(160,105,70), Txt=Color3.fromRGB(255,235,215),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,30),  Inp=Color3.fromRGB(38,18,8)},
    Love       ={Bg=Color3.fromRGB(18,6,14),  Hdr=Color3.fromRGB(12,4,10),  Card=Color3.fromRGB(30,10,24),   Acc=Color3.fromRGB(255,90,155), Dim=Color3.fromRGB(160,95,135), Txt=Color3.fromRGB(255,228,242),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,60,80),  Inp=Color3.fromRGB(40,14,32)},
    Forest     ={Bg=Color3.fromRGB(6,14,8),   Hdr=Color3.fromRGB(4,10,6),   Card=Color3.fromRGB(10,24,14),   Acc=Color3.fromRGB(50,220,100), Dim=Color3.fromRGB(95,155,110), Txt=Color3.fromRGB(218,255,228),Ok=Color3.fromRGB(80,255,120),Err=Color3.fromRGB(255,80,80),  Inp=Color3.fromRGB(14,32,18)},
    Ocean      ={Bg=Color3.fromRGB(4,12,26),  Hdr=Color3.fromRGB(3,8,18),   Card=Color3.fromRGB(8,20,44),    Acc=Color3.fromRGB(0,185,255),  Dim=Color3.fromRGB(95,145,185), Txt=Color3.fromRGB(215,238,255),Ok=Color3.fromRGB(0,255,190), Err=Color3.fromRGB(255,80,80),  Inp=Color3.fromRGB(12,26,55)},
    Gold       ={Bg=Color3.fromRGB(14,11,4),  Hdr=Color3.fromRGB(10,8,3),   Card=Color3.fromRGB(24,18,6),    Acc=Color3.fromRGB(255,195,45), Dim=Color3.fromRGB(160,138,78), Txt=Color3.fromRGB(255,248,225),Ok=Color3.fromRGB(0,255,160), Err=Color3.fromRGB(255,80,80),  Inp=Color3.fromRGB(32,24,8)},
    Black      ={Bg=Color3.fromRGB(5,5,6),    Hdr=Color3.fromRGB(3,3,4),    Card=Color3.fromRGB(12,12,14),   Acc=Color3.fromRGB(220,220,240),Dim=Color3.fromRGB(110,110,130),Txt=Color3.fromRGB(230,230,240),Ok=Color3.fromRGB(0,210,130), Err=Color3.fromRGB(230,60,60),  Inp=Color3.fromRGB(16,16,20)},
    White      ={Bg=Color3.fromRGB(240,242,248),Hdr=Color3.fromRGB(228,232,244),Card=Color3.fromRGB(220,226,240),Acc=Color3.fromRGB(60,90,200),Dim=Color3.fromRGB(100,110,150),Txt=Color3.fromRGB(30,35,55),Ok=Color3.fromRGB(0,160,90),  Err=Color3.fromRGB(200,40,50),  Inp=Color3.fromRGB(210,216,232)},
    Brown      ={Bg=Color3.fromRGB(20,13,8),  Hdr=Color3.fromRGB(14,9,5),   Card=Color3.fromRGB(34,21,13),   Acc=Color3.fromRGB(200,140,70), Dim=Color3.fromRGB(160,125,90), Txt=Color3.fromRGB(255,240,220),Ok=Color3.fromRGB(0,220,140), Err=Color3.fromRGB(220,70,60),  Inp=Color3.fromRGB(44,27,16)},
}
local T = Themes[THEME] or Themes.Holographic

-- ── Utilidades ─────────────────────────────────────────────────────────────
local function Tw(i,p,t,s,d) TweenService:Create(i,TweenInfo.new(t or 0.22,s or Enum.EasingStyle.Quart,d or Enum.EasingDirection.Out),p):Play() end
local function Cr(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 6);c.Parent=p end
local function Sk(p,c,th,tr) local s=Instance.new("UIStroke");s.Color=c;s.Thickness=th or 1;s.Transparency=tr or 0;s.Parent=p;return s end
local function Lbl(par,txt,x,y,w,h,sz,bold,clr,xa)
    local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Text=txt;l.TextColor3=clr or T.Txt
    l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;l.TextSize=sz or 12
    l.Position=UDim2.new(0,x,0,y);l.Size=UDim2.new(0,w,0,h)
    l.TextXAlignment=xa or Enum.TextXAlignment.Left;l.Parent=par;return l
end

-- ── HWID ───────────────────────────────────────────────────────────────────
local function GetHWID()
    -- tenta gethwid() do executor
    local ok, h = pcall(gethwid)
    if ok and h then return h end
    -- fallback: RbxAnalyticsService (sem traços)
    local ok2, h2 = pcall(function()
        return tostring(game:GetService("RbxAnalyticsService"):GetClientId()):gsub("-","")
    end)
    if ok2 and h2 and h2 ~= "" then return h2 end
    -- último fallback: UserId
    return tostring(Players.LocalPlayer.UserId)
end

-- ── HTTP (compatível com todos os executors) ───────────────────────────────
local function HttpReq(opts)
    if syn  and syn.request       then return syn.request(opts)
    elseif http and http.request  then return http.request(opts)
    elseif http_request           then return http_request(opts)
    elseif request                then return request(opts) end
    error("Executor não suporta requisições HTTP customizadas.")
end

-- ── Salvar / Carregar key ──────────────────────────────────────────────────
local function SaveKey(key)
    pcall(writefile, SAVE_FILE, key)
end

local function LoadKey()
    local ok, v = pcall(readfile, SAVE_FILE)
    return (ok and v and v ~= "") and v or nil
end

-- ── Validação PandAuth ─────────────────────────────────────────────────────
local function ValidatePanda(key)
    local ok, res = pcall(HttpReq, {
        Url    = "https://new.pandadevelopment.net/api/v1/keys/validate",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({
            ServiceID = SERVICE_ID,
            HWID      = GetHWID(),
            Key       = key,
        }),
    })
    if not ok or not res then
        return false, "✕ Erro de rede. Tente novamente."
    end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body)
    if ok2 and type(data) == "table" then
        local valid = data.Authenticated_Status == "Success"
        return valid, valid and "✓ Key válida! Carregando..." or "✕ Key inválida ou expirada."
    end
    return false, "✕ Resposta inesperada da API."
end

-- ── Verificar key salva (sessão anterior) ─────────────────────────────────
local function TrySavedKey()
    local saved = LoadKey()
    if not saved then return false end
    -- Re-valida com a API (HWID pode ter mudado)
    local valid = ValidatePanda(saved)
    return valid
end

-- =========================================================================
--  GUI
-- =========================================================================
if CoreGui:FindFirstChild("KS_Panda") then CoreGui.KS_Panda:Destroy() end
local Gui = Instance.new("ScreenGui")
Gui.Name="KS_Panda"; Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true; Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.Parent = CoreGui

-- Tentar key salva ANTES de mostrar a GUI
task.spawn(function()
    local saved = LoadKey()
    if saved then
        local valid, msg = ValidatePanda(saved)
        if valid then
            Gui:Destroy()
            task.spawn(ON_SUCCESS, saved)
            return
        end
        -- Salva inválida — deleta e mostra GUI
        pcall(function() if delfile then delfile(SAVE_FILE) end end)
    end
end)

-- Overlay
local Ov = Instance.new("Frame")
Ov.Size=UDim2.new(1,0,1,0); Ov.BackgroundColor3=Color3.new(0,0,0)
Ov.BackgroundTransparency=0.5; Ov.BorderSizePixel=0; Ov.Parent=Gui

-- Card
local Card = Instance.new("Frame")
Card.Size=UDim2.new(0,0,0,0); Card.AnchorPoint=Vector2.new(0.5,0.5)
Card.Position=UDim2.new(0.5,0,0.5,0); Card.BackgroundColor3=T.Bg
Card.BackgroundTransparency=0.04; Card.BorderSizePixel=0; Card.Parent=Gui
Cr(Card,12); local csk=Sk(Card,T.Acc,1.5,0.25)
Tw(Card,{Size=UDim2.new(0,360,0,296)},0.5,Enum.EasingStyle.Back)

-- Header
local Hdr = Instance.new("Frame")
Hdr.Size=UDim2.new(1,0,0,58); Hdr.BackgroundColor3=T.Hdr
Hdr.BackgroundTransparency=0.05; Hdr.BorderSizePixel=0; Hdr.Parent=Card; Cr(Hdr,12)
local HB=Instance.new("Frame"); HB.Size=UDim2.new(1,0,0,12); HB.Position=UDim2.new(0,0,1,-12)
HB.BackgroundColor3=T.Hdr; HB.BackgroundTransparency=0.05; HB.BorderSizePixel=0; HB.Parent=Hdr
local HL=Instance.new("Frame"); HL.Size=UDim2.new(1,0,0,1); HL.Position=UDim2.new(0,0,1,0)
HL.BackgroundColor3=T.Acc; HL.BackgroundTransparency=0.45; HL.BorderSizePixel=0; HL.Parent=Hdr
Lbl(Hdr, TITLE, 12, 8, 300, 22, 16, true, T.Acc)
Lbl(Hdr, "PandAuth — Digite sua key para continuar", 12, 32, 300, 14, 11, false, T.Dim)

-- Body
local Body=Instance.new("Frame"); Body.Size=UDim2.new(1,0,1,-58); Body.Position=UDim2.new(0,0,0,58)
Body.BackgroundTransparency=1; Body.Parent=Card

-- Badge
local badge=Instance.new("TextLabel"); badge.Size=UDim2.new(0,140,0,20); badge.Position=UDim2.new(0,14,0,10)
badge.BackgroundColor3=T.Card; badge.BackgroundTransparency=0.2; badge.Text="PANDAUTH V2 — POST API"
badge.TextColor3=T.Acc; badge.Font=Enum.Font.GothamBold; badge.TextSize=10; badge.Parent=Body; Cr(badge,4); Sk(badge,T.Acc,1,0.55)

-- Service ID (truncado)
local sidShort = (#SERVICE_ID > 26) and SERVICE_ID:sub(1,26).."..." or SERVICE_ID
Lbl(Body, "Service ID: "..sidShort, 14, 36, 332, 14, 10, false, T.Dim)

-- Input key
local ibg=Instance.new("Frame"); ibg.Size=UDim2.new(1,-28,0,42); ibg.Position=UDim2.new(0,14,0,56)
ibg.BackgroundColor3=T.Inp; ibg.BackgroundTransparency=0.15; ibg.BorderSizePixel=0; ibg.Parent=Body; Cr(ibg,8)
local isk=Sk(ibg,T.Acc,1,0.6)
local tb=Instance.new("TextBox"); tb.Size=UDim2.new(1,-12,1,0); tb.Position=UDim2.new(0,6,0,0)
tb.BackgroundTransparency=1; tb.Text=""; tb.PlaceholderText="Cole sua key PandAuth aqui..."
tb.PlaceholderColor3=T.Dim; tb.TextColor3=T.Txt; tb.Font=Enum.Font.GothamMedium; tb.TextSize=13
tb.ClearTextOnFocus=false; tb.Parent=ibg
local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,5); pad.PaddingRight=UDim.new(0,5); pad.Parent=tb
tb.Focused:Connect(function() Tw(ibg,{BackgroundTransparency=0.04},0.14); Tw(isk,{Transparency=0.15},0.14) end)
tb.FocusLost:Connect(function() Tw(ibg,{BackgroundTransparency=0.15},0.14); Tw(isk,{Transparency=0.6},0.14) end)

-- Status
local statusLbl = Lbl(Body,"",14,106,332,16,11,false,T.Dim)

-- Botão Verificar
local vBtn=Instance.new("TextButton"); vBtn.Size=UDim2.new(1,-28,0,40); vBtn.Position=UDim2.new(0,14,0,128)
vBtn.BackgroundColor3=T.Acc; vBtn.BackgroundTransparency=0.15; vBtn.Text="Verificar Key (PandAuth)"
vBtn.TextColor3=Color3.new(1,1,1); vBtn.Font=Enum.Font.GothamBold; vBtn.TextSize=14; vBtn.Parent=Body
Cr(vBtn,8); Sk(vBtn,T.Acc,1,0.4)
vBtn.MouseEnter:Connect(function() Tw(vBtn,{BackgroundTransparency=0},0.12) end)
vBtn.MouseLeave:Connect(function() Tw(vBtn,{BackgroundTransparency=0.15},0.12) end)

-- Botão Get Key
local GET_KEY_URL = "https://new.pandadevelopment.net/getkey/"..SERVICE_ID
local gkBtn=Instance.new("TextButton"); gkBtn.Size=UDim2.new(1,-28,0,32); gkBtn.Position=UDim2.new(0,14,0,180)
gkBtn.BackgroundColor3=T.Card; gkBtn.BackgroundTransparency=0.2
gkBtn.Text="📋  Get Key (copia link)"; gkBtn.TextColor3=T.Acc
gkBtn.Font=Enum.Font.GothamBold; gkBtn.TextSize=12; gkBtn.Parent=Body; Cr(gkBtn,7); Sk(gkBtn,T.Acc,1,0.55)
gkBtn.MouseEnter:Connect(function() Tw(gkBtn,{BackgroundTransparency=0},0.12) end)
gkBtn.MouseLeave:Connect(function() Tw(gkBtn,{BackgroundTransparency=0.2},0.12) end)
gkBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(GET_KEY_URL) end end)
    statusLbl.Text="Link copiado! Abra no navegador: "..GET_KEY_URL
    statusLbl.TextColor3=T.Acc
end)

-- HWID Info
local hwid = GetHWID()
local hwidShort = (#hwid > 24) and hwid:sub(1,24).."..." or hwid
Lbl(Body, "HWID: "..hwidShort, 14, 220, 332, 13, 9, false, T.Dim)

-- Footer
Lbl(Body,"Created by CoiledTom",0,252,360,14,10,false,T.Dim,Enum.TextXAlignment.Center)

-- =========================================================================
--  LÓGICA DE VALIDAÇÃO
-- =========================================================================
local function SuccessAnim(key)
    statusLbl.TextColor3=T.Ok; Tw(csk,{Color=T.Ok},0.3)
    task.wait(0.8)
    Tw(Ov,{BackgroundTransparency=1},0.4); Tw(Card,{Size=UDim2.new(0,0,0,0)},0.4,Enum.EasingStyle.Back)
    task.wait(0.45); Gui:Destroy()
    task.spawn(ON_SUCCESS, key)
end

vBtn.MouseButton1Click:Connect(function()
    local input = tb.Text:gsub("%s+","")
    if input == "" then
        statusLbl.Text="Por favor, insira a key."; statusLbl.TextColor3=T.Err; return
    end
    vBtn.Text="Consultando PandAuth..."; statusLbl.Text="Conectando à API..."; statusLbl.TextColor3=T.Dim
    Tw(vBtn,{BackgroundTransparency=0.4},0.12)

    task.spawn(function()
        local valid, msg = ValidatePanda(input)
        Tw(vBtn,{BackgroundTransparency=0.15},0.12)
        vBtn.Text="Verificar Key (PandAuth)"; statusLbl.Text=msg

        if valid then
            SaveKey(input)    -- salva key válida
            SuccessAnim(input)
        else
            statusLbl.TextColor3=T.Err; Tw(csk,{Color=T.Err},0.15); task.wait(0.55); Tw(csk,{Color=T.Acc},0.35)
            Tw(ibg,{BackgroundColor3=Color3.fromRGB(60,18,18)},0.12); task.wait(0.4); Tw(ibg,{BackgroundColor3=T.Inp},0.25)
            task.spawn(ON_FAIL, input)
        end
    end)
end)
