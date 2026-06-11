# SystemUI v2.0 — Roblox UI Library

> Manhwa / Holographic UI Library · 11 Temas · Key System · Component Lock · Live Theme Switch

---

## Instalação

```lua
local SystemUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/SystemUI.lua"
))()
```

---

## Quick Start

```lua
local Win = SystemUI:CreateWindow({
    Title      = "MEU HUB",
    SubTitle   = "v1.0",
    Theme      = "Holographic",
    Size       = UDim2.new(0, 560, 0, 400),  -- ideal para mobile
    ToggleKey  = Enum.KeyCode.RightShift,
    BubbleText = "M.H",   -- texto na bolinha ao minimizar com ◎
    BubbleSize = 52,
})

local Tab = Win:AddTab({ Title = "Main", Icon = "zap" })
local Sec = Tab:AddSection({ Title = "Ações" })
Sec:AddButton({ Title = "Teleport", Callback = function() print("tp!") end })
```

---

## CreateWindow — Parâmetros

| Parâmetro    | Tipo         | Padrão           | Descrição                               |
|-------------|--------------|------------------|-----------------------------------------|
| Title        | string       | "SYSTEM INTERFACE" | Título da janela                      |
| SubTitle     | string       | "SystemUI v2.0"  | Subtítulo                               |
| Theme        | string       | "Holographic"    | Tema visual (ver lista abaixo)          |
| Size         | UDim2        | (0,580,0,440)    | Tamanho inicial                         |
| ToggleKey    | Enum.KeyCode | RightShift       | Tecla para ocultar/mostrar              |
| BubbleText   | string       | "S.M"            | Texto na bolinha (botão ◎)              |
| BubbleImage  | string       | nil              | rbxassetid:// para imagem na bolinha    |
| BubbleSize   | number       | 52               | Tamanho em px da bolinha                |

### Botões da janela
| Botão | Função |
|-------|--------|
| `−`   | Minimiza para pílula (mantém funcionalidades) |
| `◎`   | Encolhe para bolinha flutuante arrastável |
| `✕`   | Fecha e destroys a GUI |

---

## Temas (11)

| Nome          | Accent         | Estilo              |
|---------------|----------------|---------------------|
| `Holographic` | Cyan           | Frio, tecnológico   |
| `Crimson`     | Vermelho       | Agressivo, escuro   |
| `Void`        | Roxo           | Místico, profundo   |
| `Volcano`     | Laranja/Lava   | Quente, ígneo       |
| `Love`        | Rosa           | Suave, romântico    |
| `Forest`      | Verde          | Natural, orgânico   |
| `Ocean`       | Azul profundo  | Calmo, marítimo     |
| `Gold`        | Dourado        | Premium, luxuoso    |
| `Black`       | Branco/Cinza   | Minimalista puro    |
| `White`       | Azul escuro    | Claro, limpo        |
| `Brown`       | Âmbar          | Terroso, quente     |

### Troca de tema ao vivo (sem recriar a janela)
```lua
Win:SetTheme("Volcano")
```

---

## Componentes

### AddButton
```lua
Sec:AddButton({
    Title    = "Teleport",
    Icon     = "zap",
    Locked   = false,      -- opcional: bloqueia o componente
    LockKey  = "SECRET",   -- Key para desbloquear
    Callback = function() end,
})
```

### AddToggle
```lua
local ctrl = Sec:AddToggle({
    Title    = "Speed Hack",
    Icon     = "shield",
    Default  = false,
    Flag     = "speedhack",
    Locked   = false,
    LockKey  = "SECRET",
    Callback = function(v) print(v) end,
})
ctrl:Get()   -- boolean
ctrl:Set(true)
```

### AddSlider
```lua
local ctrl = Sec:AddSlider({
    Title    = "WalkSpeed",
    Min      = 1, Max = 100, Default = 16, Round = 1,
    Flag     = "speed",
    Locked   = false,
    LockKey  = "SECRET",
    Callback = function(v) end,
})
```

### AddTextbox / AddInput
```lua
local ctrl = Sec:AddTextbox({
    Title       = "Alvo",
    Placeholder = "Nome...",
    Default     = "",
    Flag        = "alvo",
    Callback    = function(text, enter) end,
})
```

### AddDropdown
```lua
local ctrl = Sec:AddDropdown({
    Title    = "Modo",
    Options  = {"Normal","Hard","Expert"},
    Default  = "Normal",
    Flag     = "modo",
    Callback = function(sel) end,
})
```

### AddMultiDropdown
```lua
local ctrl = Sec:AddMultiDropdown({
    Title    = "Buffs",
    Options  = {"Speed","Damage","Defense"},
    Default  = {"Speed"},
    Callback = function(sel) end,
})
```

### AddKeybind
```lua
local ctrl = Sec:AddKeybind({
    Title    = "Ativar",
    Default  = Enum.KeyCode.F,
    Flag     = "activateKey",
    Callback = function(key) end,
})
```

### AddColorPicker
```lua
local ctrl = Sec:AddColorPicker({
    Title    = "Cor do Aura",
    Default  = Color3.fromRGB(0, 220, 255),
    Callback = function(color) end,
})
```

### AddProgressBar
```lua
local ctrl = Sec:AddProgressBar({ Title="Loading", Default=0 })
ctrl:Set(75)  -- 0-100
```

### AddLabel / AddParagraph / AddSeparator / AddList / AddCodeBlock / AddImage / AddSearchBox / AddPlayerList / AddConfigSystem
> Documentação idêntica à v1.0 — veja o código de teste.

---

## Notificações

### Simples
```lua
Win:Notify({
    Title    = "Título",
    Desc     = "Descrição",
    Type     = "success",  -- "success" | "error" | "warning" | "info"
    Duration = 3,
})
```

### Confirmação (Y/N)
```lua
Win:Confirm({
    Title    = "Fechar?",
    Desc     = "Tem certeza que quer fechar a GUI?",
    Duration = 10,            -- auto-dismiss após 10s
    OnYes    = function()
        Win:Destroy()
    end,
    OnNo     = function()
        Win:Notify({ Title="Cancelado", Type="info", Duration=2 })
    end,
})
```

---

## Component Lock (Bloqueio por Key)

Qualquer componente pode ser bloqueado com `Locked = true` e `LockKey = "SUAKEY"`.
Ao clicar no componente bloqueado, aparece um popup pedindo a key.

```lua
Sec:AddButton({
    Title   = "Ação Premium",
    Locked  = true,
    LockKey = "MINHA-KEY-2025",
    Callback = function()
        print("Desbloqueado!")
    end
})

Sec:AddToggle({
    Title   = "God Mode",
    Locked  = true,
    LockKey = "MINHA-KEY-2025",
    Callback = function(v) end
})

Sec:AddSlider({
    Title   = "Infinite Jump",
    Locked  = true,
    LockKey = "MINHA-KEY-2025",
    ...
})
```

---

## Key System (arquivo separado)

### Instalação
```lua
local KeySystem = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/KeySystem.lua"
))()
```

### Key Fixa (hardcoded)
```lua
local KS = KeySystem:New({
    Type  = "fixed",
    Key   = "MINHA-KEY-FIXA",
    Title = "Meu Script",
    Theme = "Holographic",
})
KS:Show(function(success, key)
    if success then
        -- carrega o script principal
    end
end)
```

### Luarmor
```lua
local KS = KeySystem:New({
    Type      = "luarmor",
    ProjectID = "seu_project_id",  -- do painel Luarmor
    Title     = "Meu Script",
    Theme     = "Void",
    GetKeyURL = "https://linkvertise.com/...",  -- link para pegar key
})
KS:Show(function(success, key)
    if success then
        -- script carregado
    end
end)
```

### Panda Developments
```lua
local KS = KeySystem:New({
    Type      = "panda",
    ServiceID = "tom",     -- seu service ID no Panda
    Title     = "Meu Script",
    Theme     = "Crimson",
    GetKeyURL = "https://lootlabs.gg/...",
})
KS:Show(function(success, key)
    if success then
        -- script carregado
    end
end)
```

### Parâmetros KeySystem:New()

| Parâmetro  | Tipo   | Descrição                                         |
|-----------|--------|---------------------------------------------------|
| Type       | string | "fixed" / "luarmor" / "panda"                     |
| Key        | string | Key hardcoded (para Type="fixed")                 |
| ServiceID  | string | Service ID no Panda Developments                  |
| ProjectID  | string | Project ID no Luarmor                             |
| Title      | string | Título exibido no painel de key                   |
| Theme      | string | Tema visual (mesmos 11 do SystemUI)               |
| Logo       | string | rbxassetid:// para logo no header                 |
| GetKeyURL  | string | URL copiada ao clicar "Pegar Key"                 |

---

## Scripts de Teste

| Arquivo                    | Descrição                              |
|---------------------------|----------------------------------------|
| `Test_Normal.lua`          | SystemUI completo sem Key              |
| `Test_KeyComponents.lua`   | Componentes com Locked/LockKey         |
| `Test_KeySystem.lua`       | Key System completo (fixed por padrão) |

---

## Window Object API

| Método              | Descrição                                      |
|--------------------|------------------------------------------------|
| `Win:AddTab(cfg)`   | Cria e retorna Tab                             |
| `Win:Notify(cfg)`   | Notificação simples                            |
| `Win:Confirm(cfg)`  | Notificação com botões Y/N                     |
| `Win:SetTheme(n)`   | Troca de tema ao vivo                          |
| `Win:SaveConfig()`  | Salva config manualmente                       |
| `Win:LoadConfig()`  | Retorna config salva                           |
| `Win:Destroy()`     | Destroys a GUI                                 |

---

## Compatibilidade de Executors

Delta · KRNL · Synapse X · Arceus X · Hydrogen · Fluxus

---

*SystemUI v2.0 — Created by CoiledTom*
