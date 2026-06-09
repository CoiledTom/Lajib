# SystemUI — Roblox UI Library

> Manhwa / Holographic UI Library for Roblox Luau  
> Glassmorphism · Neon Glow · Smooth Animations · Fully Featured

---

## Credits

Icons library by Footagesus:  
https://github.com/Footagesus/Icons

---

## Installation

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
    Title     = "SYSTEM INTERFACE",
    SubTitle  = "SystemUI v1.0",
    Theme     = "Holographic",
    Size      = UDim2.new(0, 620, 0, 460),
    Blur      = true,
    Sounds    = true,
    ToggleKey = Enum.KeyCode.RightShift,
})

local Tab = Win:AddTab({
    Title = "Combat",
    Icon  = "lucide-swords",
})

local Section = Tab:AddSection({
    Title = "Auto Farm",
    Icon  = "lucide-shield",
})

Section:AddToggle({
    Title    = "Auto Attack",
    Default  = false,
    Callback = function(v)
        print("Auto Attack:", v)
    end,
})

Section:AddButton({
    Title    = "Start",
    Icon     = "lucide-zap",
    Callback = function()
        Win:Notify({
            Title    = "ACTIVE",
            Desc     = "System engaged.",
            Type     = "success",
            Duration = 3,
        })
    end,
})
```

---

## CreateWindow — Options

| Parameter  | Type            | Default                  | Description                        |
|------------|-----------------|--------------------------|------------------------------------|
| Title      | string          | `"SYSTEM INTERFACE"`     | Main window title                  |
| SubTitle   | string          | `"SystemUI v1.0"`        | Subtitle below title               |
| Theme      | string          | `"Holographic"`          | Color theme (see Themes section)   |
| Size       | UDim2           | `UDim2.new(0,620,0,460)` | Initial window size                |
| Blur       | boolean         | `true`                   | Background blur effect             |
| Sounds     | boolean         | `true`                   | UI sound effects                   |
| ToggleKey  | Enum.KeyCode    | `RightShift`             | Key to show/hide the window        |

---

## Themes

Three built-in themes. Pass `Theme = "..."` in `CreateWindow`.

| Theme         | Accent Color      | Style               |
|---------------|-------------------|---------------------|
| `Holographic` | Cyan `#00DCFF`    | Cold, techy, default|
| `Crimson`     | Red `#FF3250`     | Aggressive, dark    |
| `Void`        | Purple `#A050FF`  | Mystical, deep      |

> Themes only change **colors** — never layout, fonts, or sizes.

---

## Window Buttons

| Button | Symbol | Action                                  |
|--------|--------|-----------------------------------------|
| Minimize | `−`  | Collapses to title bar (smooth tween)   |
| Restore  | `□`  | Restores full size / re-centers window  |
| Close    | `✕`  | Destroys GUI, removes blur, cleans connections |

---

## Toggle Key

```lua
ToggleKey = Enum.KeyCode.RightShift
```

Press the key at any time to **hide** or **show** the window with a smooth animation. Does not destroy the GUI — all state is preserved.

---

## Draggable & Resizable

- Drag: click and hold the **title bar** to move the window anywhere.
- Resize: drag the **resize grip** (bottom-right corner ⋱) to resize freely.
- Minimum size enforced: 420×320 px.

---

## AddTab

```lua
local Tab = Win:AddTab({
    Title = "Combat",
    Icon  = "lucide-swords",   -- optional
})
```

---

## AddSection

```lua
local Section = Tab:AddSection({
    Title = "Auto Farm",
    Icon  = "lucide-shield",   -- optional
})
```

---

## Components

All components are added to a **Section** object.

---

### AddButton

```lua
Section:AddButton({
    Title    = "Teleport",
    Icon     = "lucide-zap",
    Callback = function()
        -- action
    end,
})
```

---

### AddToggle

```lua
local toggle = Section:AddToggle({
    Title    = "God Mode",
    Icon     = "lucide-shield",
    Default  = false,
    Flag     = "godmode",       -- optional key for config save
    Callback = function(value)
        print("State:", value)
    end,
})

-- Controller methods:
toggle:Set(true)
toggle:Get()  --> boolean
```

---

### AddSlider

```lua
local slider = Section:AddSlider({
    Title    = "Walk Speed",
    Min      = 1,
    Max      = 100,
    Default  = 16,
    Round    = 1,              -- optional step size
    Flag     = "walkspeed",    -- optional key for config save
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})

-- Controller methods:
slider:Set(32)
slider:Get()  --> number
```

> Sliders support both **mouse** and **touch** input. Real-time callback with no lag or flickering.

---

### AddTextbox / AddInput

Both are identical — use whichever name you prefer.

```lua
local input = Section:AddTextbox({
    Title       = "Target Name",
    Placeholder = "Enter name...",
    Default     = "",
    Icon        = "lucide-user",
    Callback    = function(text, enterPressed)
        print(text, enterPressed)
    end,
})

-- Controller methods:
input:Get()    --> string
input:Set("NewValue")
```

---

### AddDropdown

```lua
local dropdown = Section:AddDropdown({
    Title    = "Game Mode",
    Options  = {"Normal", "Hard", "Expert"},
    Default  = "Normal",
    Flag     = "gamemode",
    Icon     = "lucide-layers",
    Callback = function(selected)
        print("Selected:", selected)
    end,
})

-- Controller methods:
dropdown:Get()        --> string
dropdown:Set("Hard")
```

---

### AddMultiDropdown

```lua
local multi = Section:AddMultiDropdown({
    Title    = "Active Buffs",
    Options  = {"Speed", "Damage", "Defense", "Luck"},
    Default  = {"Speed"},
    Flag     = "buffs",
    Callback = function(selected)
        -- selected is a table: { Speed = true, Damage = false, ... }
        for k, v in pairs(selected) do
            if v then print("Active:", k) end
        end
    end,
})

-- Controller methods:
multi:Get()  --> table of selected values
```

---

### AddKeybind

```lua
local keybind = Section:AddKeybind({
    Title    = "Activate",
    Default  = Enum.KeyCode.F,
    Flag     = "activatekey",
    Icon     = "lucide-keyboard",
    Callback = function(keyCode)
        -- fires every time the bound key is pressed
        print("Key pressed:", keyCode)
    end,
})

-- Controller methods:
keybind:Get()  --> Enum.KeyCode
```

> Click the keybind button to enter **listening mode** — next key pressed is bound automatically.

---

### AddColorPicker

```lua
local colorPicker = Section:AddColorPicker({
    Title    = "Aura Color",
    Default  = Color3.fromRGB(0, 220, 255),
    Flag     = "auracolor",
    Callback = function(color)
        print("New color:", color)
    end,
})

-- Controller methods:
colorPicker:Get()  --> Color3
```

> Opens an HSV picker popup with Hue, Saturation, and Value sliders.

---

### AddLabel

```lua
local label = Section:AddLabel({
    Text = "Status: Ready",
})

-- Controller methods:
label:Set("Status: Active")
label:Get()  --> string
```

---

### AddParagraph

```lua
Section:AddParagraph({
    Title   = "About",
    Content = "This module handles automatic farming and resource collection.",
    Height  = 70,
})
```

---

### AddSeparator

```lua
Section:AddSeparator()
```

Adds a thin neon line between components.

---

### AddProgressBar

```lua
local bar = Section:AddProgressBar({
    Title   = "Loading...",
    Default = 0,
})

-- Controller methods:
bar:Set(75)   -- 0 to 100
bar:Get()     --> number
```

---

### AddImage

```lua
Section:AddImage({
    Image     = "rbxassetid://12345678",
    Height    = 120,
    ScaleType = Enum.ScaleType.Fit,
})
```

---

### AddSearchBox

```lua
local search = Section:AddSearchBox({
    Placeholder = "Search players...",
    Callback    = function(text)
        print("Searching:", text)
    end,
})

-- Controller methods:
search:Get()  --> string
```

---

### AddCodeBlock

```lua
Section:AddCodeBlock({
    Code   = 'local x = workspace:FindFirstChild("Target")',
    Height = 50,
})
```

Displays code with monospace font and green text on dark background.

---

### AddList

```lua
Section:AddList({
    Items = {"Item One", "Item Two", "Item Three"},
})
```

---

### AddPlayerList

```lua
Section:AddPlayerList({
    IncludeSelf = false,
    Callback    = function(player)
        print("Selected player:", player.Name)
    end,
})
```

Auto-refreshes when players join/leave. Includes a manual Refresh button. Shows avatar thumbnails.

---

### AddConfigSystem

Adds Save / Load (and optionally Reset) buttons that operate on the window's config data.

```lua
Section:AddConfigSystem({
    SaveTitle = "Save Config",
    LoadTitle = "Load Config",
    ShowReset = true,           -- optional reset button
    OnLoad    = function(data)
        print("Loaded config:", data)
    end,
})
```

---

## Notifications

```lua
Win:Notify({
    Title    = "ACTIVE",
    Desc     = "System engaged successfully.",
    Type     = "success",    -- "success" | "error" | "warning" | "info"
    Duration = 3,
})
```

| Type      | Color  | Icon            |
|-----------|--------|-----------------|
| `success` | Green  | check-circle    |
| `error`   | Red    | x-circle        |
| `warning` | Yellow | alert-triangle  |
| `info`    | Blue   | info            |

Notifications slide in from the right with a progress bar countdown, then slide out automatically.

---

## Config System

Config is saved and loaded **automatically** via executor's `writefile` / `readfile` when available.

### Manual API

```lua
Win:SaveConfig()   -- save current state
Win:LoadConfig()   -- returns saved config table
```

### Auto-Save

Every component change (toggle, slider, dropdown, keybind) triggers a debounced auto-save after **1.5 seconds** of inactivity.

### Flags

Use the `Flag` parameter on any component to give it a unique config key:

```lua
Section:AddToggle({
    Title = "Speed Hack",
    Flag  = "speedhack",     -- saved/loaded by this key
    ...
})
```

---

## Icons

Icons use the Lucide icon set provided by **Footagesus**.

Pass icon names with or without the `lucide-` prefix:

```lua
Icon = "lucide-swords"
Icon = "swords"        -- both work
```

### Common Icons

| Name             | Name             | Name           |
|------------------|------------------|----------------|
| `swords`         | `shield`         | `settings`     |
| `user`           | `home`           | `zap`          |
| `star`           | `heart`          | `terminal`     |
| `cpu`            | `layers`         | `globe`        |
| `lock`           | `eye`            | `crosshair`    |
| `target`         | `activity`       | `bell`         |
| `search`         | `list`           | `code`         |
| `users`          | `save`           | `trash`        |
| `edit`           | `sliders`        | `keyboard`     |
| `palette`        | `flame`          | `power`        |
| `refresh-cw`     | `database`       | `compass`      |

---

## Full Example

```lua
local SystemUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/CoiledTom/Lajib/refs/heads/main/SystemUI.lua"
))()

local Win = SystemUI:CreateWindow({
    Title     = "SYSTEM INTERFACE",
    SubTitle  = "SystemUI v1.0",
    Theme     = "Holographic",
    Size      = UDim2.new(0, 620, 0, 460),
    Blur      = true,
    ToggleKey = Enum.KeyCode.RightShift,
})

-- ── COMBAT TAB ──────────────────────────────────────────────
local Combat = Win:AddTab({ Title = "Combat", Icon = "lucide-swords" })

local Farm = Combat:AddSection({ Title = "Auto Farm", Icon = "lucide-shield" })

Farm:AddToggle({
    Title    = "Auto Attack",
    Flag     = "autoattack",
    Default  = false,
    Callback = function(v) print("Auto Attack:", v) end,
})

Farm:AddSlider({
    Title    = "Speed",
    Min      = 1,
    Max      = 50,
    Default  = 16,
    Flag     = "speed",
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

Farm:AddButton({
    Title    = "Teleport to Boss",
    Icon     = "lucide-zap",
    Callback = function()
        Win:Notify({ Title = "Teleport", Desc = "Moving to boss area.", Type = "info", Duration = 2 })
    end,
})

-- ── PLAYERS TAB ─────────────────────────────────────────────
local PlayersTab = Win:AddTab({ Title = "Players", Icon = "lucide-users" })

local PlayerSec = PlayersTab:AddSection({ Title = "Player List" })

PlayerSec:AddPlayerList({
    IncludeSelf = false,
    Callback    = function(plr)
        Win:Notify({ Title = "Selected", Desc = plr.Name, Type = "success", Duration = 2 })
    end,
})

-- ── SETTINGS TAB ────────────────────────────────────────────
local Settings = Win:AddTab({ Title = "Settings", Icon = "lucide-settings" })

local CfgSec = Settings:AddSection({ Title = "Configuration", Icon = "lucide-save" })

CfgSec:AddConfigSystem({
    ShowReset = true,
    OnLoad    = function(data) print("Config loaded", data) end,
})

local ThemeSec = Settings:AddSection({ Title = "Appearance" })

ThemeSec:AddColorPicker({
    Title    = "Accent Override",
    Default  = Color3.fromRGB(0, 220, 255),
    Callback = function(c) print("Color:", c) end,
})

ThemeSec:AddKeybind({
    Title    = "Toggle Key",
    Default  = Enum.KeyCode.RightShift,
    Flag     = "togglekey",
    Callback = function(key) print("Key:", key) end,
})
```

---

## Window Object API

| Method                 | Description                                      |
|------------------------|--------------------------------------------------|
| `Win:AddTab(cfg)`      | Creates and returns a Tab object                 |
| `Win:Notify(cfg)`      | Sends a notification                             |
| `Win:SaveConfig()`     | Manually saves config to disk                    |
| `Win:LoadConfig()`     | Loads and returns config from disk               |
| `Win:Destroy()`        | Destroys the GUI and cleans all connections      |

## Tab Object API

| Method                    | Description                                   |
|---------------------------|-----------------------------------------------|
| `Tab:AddSection(cfg)`     | Creates and returns a Section object          |
| `Tab:AddButton(cfg)`      | Shorthand — creates a section with one button |
| `Tab:AddToggle(cfg)`      | Shorthand — creates a section with one toggle |
| `Tab:AddSlider(cfg)`      | Shorthand — creates a section with one slider |

## Section Object API

| Method                        | Returns       |
|-------------------------------|---------------|
| `Section:AddButton(cfg)`      | —             |
| `Section:AddToggle(cfg)`      | ctrl          |
| `Section:AddSlider(cfg)`      | ctrl          |
| `Section:AddTextbox(cfg)`     | ctrl          |
| `Section:AddInput(cfg)`       | ctrl          |
| `Section:AddDropdown(cfg)`    | ctrl          |
| `Section:AddMultiDropdown(cfg)` | ctrl        |
| `Section:AddKeybind(cfg)`     | ctrl          |
| `Section:AddColorPicker(cfg)` | ctrl          |
| `Section:AddLabel(cfg)`       | ctrl          |
| `Section:AddParagraph(cfg)`   | —             |
| `Section:AddSeparator()`      | —             |
| `Section:AddProgressBar(cfg)` | ctrl          |
| `Section:AddImage(cfg)`       | —             |
| `Section:AddSearchBox(cfg)`   | ctrl          |
| `Section:AddCodeBlock(cfg)`   | —             |
| `Section:AddList(cfg)`        | —             |
| `Section:AddPlayerList(cfg)`  | —             |
| `Section:AddConfigSystem(cfg)`| —             |

---

## Compatibility

Tested and compatible with:

- **Delta**
- **KRNL**
- **Synapse X**
- **Arceus X**
- **Hydrogen**
- **Fluxus**

Config save/load requires executor `writefile` / `readfile` support. Falls back to in-memory cache if unavailable.

---

*SystemUI — Created by CoiledTom*
