# SystemUI v2.0 — Roblox UI Library

> Biblioteca UI Manhwa/Holographic para Roblox Luau  
> 11 Temas · Key System · Component Lock · Live Theme Switch · Notifications Y/N

---

## Índice

1. [Instalação](#instalação)
2. [Quick Start](#quick-start)
3. [CreateWindow — Parâmetros completos](#createwindow)
4. [Botões da Janela](#botões-da-janela)
5. [Temas](#temas)
6. [AddTab & AddSection](#addtab--addsection)
7. [Componentes](#componentes)
8. [Notificações](#notificações)
9. [Component Lock](#component-lock)
10. [Key System — Key Fixa](#key-system--key-fixa)
11. [Key System — PandAuth](#key-system--pandauth)
12. [Scripts de Teste](#scripts-de-teste)
13. [Compatibilidade](#compatibilidade)

---

## Instalação

Carregue a biblioteca com um único `loadstring`:

```lua
local SystemUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/SystemUI.lua"
))()
```

---

## Quick Start

```lua
local SystemUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/SystemUI.lua"
))()

local Win = SystemUI:CreateWindow({
    Title      = "MEU HUB",
    SubTitle   = "v1.0",
    Theme      = "Holographic",
    Size       = UDim2.new(0, 560, 0, 400),
    ToggleKey  = Enum.KeyCode.RightShift,
    BubbleText = "MH",
})

local Tab = Win:AddTab({ Title = "Main", Icon = "zap" })
local Sec = Tab:AddSection({ Title = "Ações", Icon = "shield" })

Sec:AddButton({
    Title    = "Teleport",
    Icon     = "compass",
    Callback = function()
        -- sua função aqui
    end,
})
```

---

## CreateWindow

```lua
local Win = SystemUI:CreateWindow({
    Title      = "NOME DO SEU HUB",      -- obrigatório
    SubTitle   = "v1.0",                 -- linha secundária no header
    Theme      = "Holographic",          -- tema visual (ver seção Temas)
    Size       = UDim2.new(0,560,0,400), -- tamanho inicial da janela
    ToggleKey  = Enum.KeyCode.RightShift,-- tecla para mostrar/ocultar
    BubbleText = "MH",                   -- texto na bolinha (◎)
    BubbleImage = nil,                   -- imagem na bolinha (opcional, ver abaixo)
    BubbleSize = 52,                     -- diâmetro da bolinha em px
})
```

### Imagem na Bolinha (BubbleImage)

Ao invés de texto, você pode colocar uma imagem na bolinha:

```lua
local Win = SystemUI:CreateWindow({
    ...
    BubbleImage = "rbxassetid://120655184332759",  -- ID da imagem
    BubbleSize  = 60,
})
```

> **Atalho:** se você passar o asset ID em `BubbleText`, o sistema detecta automaticamente e trata como imagem:
> ```lua
> BubbleText = "rbxassetid://120655184332759"  -- funciona igual ao BubbleImage
> ```
> `BubbleImage` sempre tem prioridade sobre `BubbleText`.

---

## Botões da Janela

| Botão | Símbolo | Comportamento |
|-------|---------|---------------|
| Minimizar | `−` | Encolhe para uma pílula estreita (260×44 px). Texto subtítulo e author ficam ocultos. Clicar de novo restaura. |
| Bolinha | `◎` | Encolhe a GUI para uma bolinha flutuante arrastável. Clique na bolinha para restaurar. RightShift também restaura. |
| Fechar | ícone ✕ | Exibe confirmação Y/N antes de fechar. Clicar "Sim" destrói a GUI. |

---

## Temas

11 temas disponíveis. Passe como string em `Theme = "..."` no `CreateWindow` ou troque ao vivo com `Win:SetTheme("...")`.

| Nome | Cor de Acento | Estilo |
|------|---------------|--------|
| `Holographic` | Cyan `#00DCFF` | Frio, tecnológico, padrão |
| `Crimson` | Vermelho `#FF3250` | Agressivo, escuro |
| `Void` | Roxo `#A050FF` | Místico, espacial |
| `Volcano` | Laranja `#FF6E14` | Lava, quente |
| `Love` | Rosa `#FF5A9B` | Suave, romântico |
| `Forest` | Verde `#32DC64` | Natural, orgânico |
| `Ocean` | Azul `#00B9FF` | Marítimo, profundo |
| `Gold` | Dourado `#FFC32D` | Premium, luxuoso |
| `Black` | Branco-acinzentado | Minimalista puro |
| `White` | Azul escuro | Claro, limpo |
| `Brown` | Âmbar `#C88C46` | Terroso, quente |

### Trocar tema ao vivo (sem recriar a janela)

```lua
Win:SetTheme("Volcano")
-- Todos os componentes atualizam as cores com tween de 0.3s
```

---

## AddTab & AddSection

### AddTab

```lua
local Tab = Win:AddTab({
    Title = "Combat",   -- texto no botão da sidebar
    Icon  = "swords",   -- ícone (nome Lucide sem "lucide-")
})
```

### AddSection

```lua
local Sec = Tab:AddSection({
    Title = "Auto Farm",   -- título em maiúsculas no topo da seção
    Icon  = "shield",      -- ícone ao lado do título (opcional)
})
```

> Componentes são adicionados ao objeto `Sec` retornado.

---

## Componentes

### AddButton

```lua
Sec:AddButton({
    Title    = "Texto do botão",
    Icon     = "zap",               -- opcional
    Locked   = false,               -- bloqueia o componente (ver Component Lock)
    LockKey  = "SUAKEY",            -- key para desbloquear (se Locked=true)
    LockType = "fixed",             -- "fixed" ou "panda" (padrão: "fixed")
    LockServiceID = "",             -- Service ID PandAuth (se LockType="panda")
    Callback = function()
        -- ação ao clicar
    end,
})
```

### AddToggle

```lua
local ctrl = Sec:AddToggle({
    Title    = "Speed Hack",
    Icon     = "zap",
    Default  = false,               -- estado inicial (true/false)
    Flag     = "speedhack",         -- chave para salvar no config
    Locked   = false,
    LockKey  = "SUAKEY",
    LockType = "fixed",
    Callback = function(value)
        -- value = true/false
        print("Toggle:", value)
    end,
})

-- Métodos do controlador:
ctrl:Set(true)   -- define o estado programaticamente
ctrl:Get()       -- retorna boolean com estado atual
```

### AddSlider

```lua
local ctrl = Sec:AddSlider({
    Title    = "Walk Speed",
    Min      = 1,
    Max      = 100,
    Default  = 16,
    Round    = 1,                   -- arredondamento (1 = inteiros, 0.5 = meio passo)
    Flag     = "walkspeed",
    Locked   = false,
    LockKey  = "SUAKEY",
    LockType = "fixed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})

ctrl:Set(50)   -- define valor programaticamente
ctrl:Get()     -- retorna número atual
```

### AddTextbox / AddInput

Ambos são idênticos — escolha o nome que preferir.

```lua
local ctrl = Sec:AddTextbox({
    Title       = "Nome do alvo",
    Icon        = "user",
    Placeholder = "Digite aqui...",
    Default     = "",
    Flag        = "targetname",
    ClearOnFocus = false,
    Callback    = function(text, enterPressed)
        -- enterPressed = true se o usuário pressionou Enter
        print(text, enterPressed)
    end,
})

ctrl:Get()          -- retorna string atual
ctrl:Set("Novo")    -- define o texto
```

### AddDropdown

```lua
local ctrl = Sec:AddDropdown({
    Title    = "Modo de Jogo",
    Icon     = "layers",
    Options  = {"Normal", "Hard", "Expert", "Hell"},
    Default  = "Normal",
    Flag     = "gamemode",
    Callback = function(selected)
        print("Selecionado:", selected)
    end,
})

ctrl:Get()         -- retorna string selecionada
ctrl:Set("Hard")   -- define seleção programaticamente
```

### AddMultiDropdown

```lua
local ctrl = Sec:AddMultiDropdown({
    Title    = "Buffs Ativos",
    Options  = {"Speed", "Damage", "Defense", "Luck"},
    Default  = {"Speed"},           -- itens selecionados por padrão
    Flag     = "buffs",
    Callback = function(selected)
        -- selected é uma tabela: { Speed=true, Damage=false, ... }
        for k, v in pairs(selected) do
            if v then print("Ativo:", k) end
        end
    end,
})

ctrl:Get()  -- retorna tabela dos selecionados (e.g. {"Speed","Luck"})
```

### AddKeybind

```lua
local ctrl = Sec:AddKeybind({
    Title    = "Tecla de Ativar",
    Icon     = "keyboard",
    Default  = Enum.KeyCode.F,
    Flag     = "activateKey",
    Callback = function(keyCode)
        -- disparado ao pressionar a tecla configurada
        print("Tecla:", keyCode.Name)
    end,
})

ctrl:Get()  -- retorna Enum.KeyCode atual
```

> Clique no botão de keybind → entra em modo escuta → pressione qualquer tecla.

### AddColorPicker

Abre um popup HSV com sliders de Hue, Saturation e Value, e campo de input hexadecimal.

```lua
local ctrl = Sec:AddColorPicker({
    Title    = "Cor do Aura",
    Icon     = "palette",
    Default  = Color3.fromRGB(0, 220, 255),
    Flag     = "auracolor",
    Callback = function(color)
        -- color = Color3
    end,
})

ctrl:Get()                             -- retorna Color3
ctrl:Set(Color3.fromRGB(255, 100, 0))  -- define cor
```

### AddLabel

```lua
local ctrl = Sec:AddLabel({
    Text = "Status: Inativo",
})

ctrl:Set("Status: Ativo")  -- atualiza o texto
ctrl:Get()                 -- retorna string atual
```

### AddParagraph

```lua
Sec:AddParagraph({
    Title   = "Sobre",           -- título em negrito (opcional)
    Content = "Texto descritivo que pode ser mais longo e dará wrap automático.",
    Height  = 70,                -- altura do bloco em px (ajuste conforme o texto)
})
```

### AddSeparator

```lua
Sec:AddSeparator()
-- Linha fina com a cor de acento entre componentes
```

### AddProgressBar

```lua
local ctrl = Sec:AddProgressBar({
    Title   = "Carregando",
    Default = 0,            -- valor inicial (0 a 100)
})

ctrl:Set(75)   -- atualiza com tween suave
ctrl:Get()     -- retorna número (0–100)
```

### AddSearchBox

```lua
local ctrl = Sec:AddSearchBox({
    Placeholder = "Buscar jogador...",
    Callback    = function(text)
        -- chamado a cada caractere digitado
        print("Buscando:", text)
    end,
})

ctrl:Get()  -- retorna texto atual
```

### AddCodeBlock

```lua
Sec:AddCodeBlock({
    Code   = 'local x = workspace:FindFirstChild("Alvo")',
    Height = 50,  -- altura em px
})
```

### AddList

```lua
Sec:AddList({
    Items = {
        "Item um",
        "Item dois",
        "Item três",
    },
})
```

### AddImage

```lua
Sec:AddImage({
    Image     = "rbxassetid://123456789",
    Height    = 120,
    ScaleType = Enum.ScaleType.Fit,  -- Fit | Crop | Stretch
})
```

### AddPlayerList

```lua
Sec:AddPlayerList({
    IncludeSelf = false,   -- true para incluir o próprio jogador
    Callback    = function(player)
        print("Selecionado:", player.Name, player.UserId)
    end,
})
```

> Exibe avatar, nome e UserId. Botão Refresh para recarregar.  
> Auto-atualiza quando jogadores entram/saem.

### AddConfigSystem

```lua
Sec:AddConfigSystem({
    SaveTitle = "Salvar Config",    -- texto do botão salvar
    LoadTitle = "Carregar Config",  -- texto do botão carregar
    ShowReset = true,               -- mostra botão "Resetar Config"
    OnLoad    = function(data)
        -- chamado após carregar, recebe tabela com os dados
        print("Config carregada:", data)
    end,
})
```

> O sistema salva automaticamente todos os componentes com `Flag` após 1.5s de inatividade.  
> Arquivos salvos via `writefile`/`readfile` do executor.

---

## Notificações

### Simples

```lua
Win:Notify({
    Title    = "Título",
    Desc     = "Descrição da notificação.",
    Type     = "success",   -- "success" | "error" | "warning" | "info"
    Duration = 3,           -- segundos antes de desaparecer
})
```

| Tipo | Cor | Ícone |
|------|-----|-------|
| `success` | Verde | check-circle |
| `error`   | Vermelho | x-circle |
| `warning` | Amarelo | triangle-alert |
| `info`    | Azul | info |

> Cada notificação exibe um contador regressivo (`3.0 → 0.0`) no canto inferior direito.

### Confirmação Y/N

Aparece automaticamente ao clicar no botão ✕ (fechar GUI).  
Você também pode chamar manualmente para qualquer ação de risco:

```lua
Win:Confirm({
    Title    = "Fechar GUI?",
    Desc     = "Tem certeza que quer fechar?",
    Duration = 10,           -- auto-dismiss após 10s sem resposta
    OnYes    = function()
        Win:Destroy()        -- ou qualquer ação confirmada
    end,
    OnNo     = function()
        -- cancelado
    end,
})
```

---

## Component Lock

Bloqueie qualquer componente com `Locked = true`. O usuário precisa inserir uma key para desbloquear.

### Comportamento

- O componente exibe um overlay escuro com ícone de cadeado e texto "Bloqueado"
- Ao clicar, abre um popup **centralizado na tela** pedindo a key
- **Desbloqueando um componente, TODOS com o mesmo `LockKey` são desbloqueados automaticamente**
- A key validada é **salva** — o usuário não precisa redigitar em execuções futuras

### Key Fixa

```lua
Sec:AddButton({
    Title    = "Ação Premium",
    Locked   = true,
    LockKey  = "MINHA-KEY-2025",   -- key que o usuário digita
    LockType = "fixed",            -- comparação direta de string
    Callback = function()
        print("Desbloqueado!")
    end,
})

-- Múltiplos componentes com o mesmo LockKey → 1 desbloqueio libera todos:
Sec:AddToggle({
    Title    = "Speed Hack",
    Locked   = true,
    LockKey  = "MINHA-KEY-2025",   -- mesmo grupo
    LockType = "fixed",
    Callback = function(v) end,
})
```

### PandAuth

```lua
Sec:AddButton({
    Title         = "Função VIP",
    Locked        = true,
    LockKey       = "grupo-vip",             -- nome interno do grupo (qualquer string)
    LockType      = "panda",                 -- valida via PandAuth POST API
    LockServiceID = "SEU-SERVICE-ID",        -- Service ID do seu projeto PandAuth
    LockGetKeyURL = "https://new.pandadevelopment.net/getkey/SEU-SERVICE-ID",  -- opcional
    Callback = function()
        print("VIP desbloqueado!")
    end,
})

-- Mesmo grupo → validar um libera todos do grupo:
Sec:AddToggle({
    Title         = "Toggle VIP",
    Locked        = true,
    LockKey       = "grupo-vip",
    LockType      = "panda",
    LockServiceID = "SEU-SERVICE-ID",
    Callback      = function(v) end,
})
```

**API usada internamente:**
```
POST https://new.pandadevelopment.net/api/v1/keys/validate
Body: { ServiceID, HWID, Key }
Resposta: { "Authenticated_Status": "Success" }
```

> **Nota:** `LockGetKeyURL` exibe um botão **Get Key** no popup de desbloqueio que copia o link.  
> A key validada é salva em disco — o usuário não precisa redigitar em sessões futuras.

---

## Key System — Key Fixa

Exibe um painel de autenticação antes de carregar seu script. Use quando a key é uma string hardcoded.

### Como usar

```lua
-- Cole no início do seu script (antes de carregar o SystemUI):
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/KeySystem_Fixed.lua"
))()
```

### Configuração (edite no arquivo)

Abra `KeySystem_Fixed.lua` e edite a seção **CONFIGURAÇÃO**:

```lua
local KEY         = "MINHA-KEY-SUPER-SECRETA"  -- key que o usuário precisa digitar
local TITLE       = "Meu Script"               -- nome exibido no painel
local THEME       = "Holographic"              -- tema visual
local GET_KEY_URL = "https://linkvertise.com/..." -- link para pegar key (opcional, "" para ocultar)

local ON_SUCCESS = function(input)
    -- Coloque aqui o carregamento do seu script principal:
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/SeuUser/SeuRepo/main/SeuScript.lua"
    ))()
end
```

### Temas disponíveis

Todos os 11 temas do SystemUI funcionam:
`"Holographic"`, `"Crimson"`, `"Void"`, `"Volcano"`, `"Love"`, `"Forest"`, `"Ocean"`, `"Gold"`, `"Black"`, `"White"`, `"Brown"`

---

## Key System — PandAuth

Valida a key via **PandAuth V2 API oficial** usando requisição POST.

### Como usar

```lua
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/KeySystem_Panda.lua"
))()
```

### Configuração (edite no arquivo)

```lua
local SERVICE_ID  = "SEU-SERVICE-ID-AQUI"  -- ← obrigatório (ver abaixo como obter)
local TITLE       = "Meu Script"
local THEME       = "Holographic"
local SAVE_FILE   = "MeuHub_Panda.key"     -- nome do arquivo onde a key válida fica salva

local ON_SUCCESS = function(key)
    -- key válida — carregue seu script aqui:
    loadstring(game:HttpGet("URL_DO_SEU_SCRIPT"))()
end

local ON_FAIL = function(key)
    print("Key inválida:", key)
end
```

### Como obter o Service ID

1. Acesse https://dash.pandauth.com e faça login
2. Crie ou abra seu projeto
3. Vá em **Settings** → copie o **Service ID**
4. Cole no campo `SERVICE_ID` do arquivo

### Como a validação funciona (API oficial)

```
POST https://new.pandadevelopment.net/api/v1/keys/validate
Content-Type: application/json

Body:
{
  "ServiceID": "seu-service-id",
  "HWID": "hwid-do-jogador",
  "Key": "key-digitada"
}

Resposta de sucesso:
{ "Authenticated_Status": "Success" }
```

O script usa `request()` / `syn.request()` / `http_request()` — compatível com todos os executors.  
O HWID é obtido via `gethwid()` com fallback para `RbxAnalyticsService` e `UserId`.

### Save / Load automático

A key válida é salva no arquivo definido em `SAVE_FILE`.  
Na próxima execução, o script re-valida automaticamente a key salva.  
Se ainda válida, pula o painel de autenticação sem precisar redigitar.

### Botão Get Key

O painel exibe automaticamente um botão **Get Key** que copia o link:
```
https://new.pandadevelopment.net/getkey/{SERVICE_ID}
```
Direciona o usuário para obter uma key válida para o seu serviço.

---

## Scripts de Teste

| Arquivo | O que demonstra |
|---------|-----------------|
| `Test_Normal.lua` | SystemUI completo com todos os temas e componentes básicos |
| `Test_KeyComponents.lua` | Componentes bloqueados (key fixa + PandAuth) com grupo-unlock |
| `Test_KeySystem.lua` | Key System completo (Fixed por padrão, trocar para Panda conforme necessário) |

---

## Window Object — API Completa

```lua
Win:AddTab(cfg)          -- cria e retorna Tab object
Win:Notify(cfg)          -- notificação simples (4 tipos)
Win:Confirm(cfg)         -- notificação com botões Sim/Não
Win:SetTheme(name)       -- troca de tema ao vivo com tween
Win:SaveConfig()         -- salva config manualmente
Win:LoadConfig()         -- retorna tabela com config salva
Win:Destroy()            -- destrói a GUI e desconecta listeners
```

### Tab Object

```lua
Tab:AddSection(cfg)      -- cria e retorna Section object
Tab:AddButton(cfg)       -- atalho: seção + botão
Tab:AddToggle(cfg)       -- atalho: seção + toggle
Tab:AddSlider(cfg)       -- atalho: seção + slider
```

### Section Object

```lua
Sec:AddButton(cfg)
Sec:AddToggle(cfg)
Sec:AddSlider(cfg)
Sec:AddTextbox(cfg)      -- alias: Sec:AddInput(cfg)
Sec:AddDropdown(cfg)
Sec:AddMultiDropdown(cfg)
Sec:AddKeybind(cfg)
Sec:AddColorPicker(cfg)
Sec:AddLabel(cfg)
Sec:AddParagraph(cfg)
Sec:AddSeparator()
Sec:AddProgressBar(cfg)
Sec:AddImage(cfg)
Sec:AddSearchBox(cfg)
Sec:AddCodeBlock(cfg)
Sec:AddList(cfg)
Sec:AddPlayerList(cfg)
Sec:AddConfigSystem(cfg)
```

---

## Compatibilidade de Executors

Delta · KRNL · Synapse X · Arceus X · Hydrogen · Fluxus

> Config e Lock Keys salvos via `writefile`/`readfile`. Em executors sem suporte, o estado é mantido em memória durante a sessão.

---

*SystemUI v2.0 — Created by CoiledTom · github.com/CoiledTom/Lajib*
