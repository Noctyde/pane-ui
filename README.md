# PaneUI

A macOS-style UI library for Roblox scripts. Windows with traffic-light buttons, a sidebar with search like System Settings, grouped forms, light and dark themes, an accent color, English and Russian interface, and scaling for any resolution. It comes with configs, notification banners with a notification center, a command palette, dialogs, a context menu, tooltips, a watermark and a keybind list. Everything moves on spring physics, like macOS.

```
src/PaneUI.lua          the library, a single file: this is what you host
examples/demo.lua       every element in one window
types/PaneUI.luau       types for editor autocomplete
tools/build-dev.sh      bundles the library with a script for testing without hosting
tools/obfuscate.py      one-command Luraph obfuscation
```

## Getting started

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Noctyde/pane-ui/main/src/PaneUI.lua"))()

local Window = Library:CreateWindow({ Title = "My Script", Icon = "sword" })
local Main = Window:AddTab({ Title = "Main", Icon = "home" })
local Combat = Main:AddSection("Combat")

Combat:AddToggle({ Title = "Auto farm", Flag = "AutoFarm", Callback = function(on) end })

Window:AddSettingsTab()          -- theme, accent, size, language, overlays, configs, unload
Library:LoadAutoloadConfig()     -- last, once every element with a Flag exists
```

## What the window can do

- **Search.** The field at the top of the sidebar, or Ctrl+F. Searches titles, descriptions, sections and tabs. Clicking a result opens its tab, scrolls to the element and highlights it.
- **Right-click a row** to reset it to its default or copy its value.
- **Tooltips.** `Tooltip = "..."` on any element; it shows after half a second of hovering.
- **Command palette, Ctrl+K.** Works even while the window is hidden. Type part of a name: toggles flip, buttons run, everything else opens in the window. Arrow keys select, Enter runs, Esc closes.
- **Notification center.** The bell in the title bar shows past banners; the red badge counts the ones that arrived since you last opened it.
- **Traffic lights.** Red asks whether to unload the script, yellow minimizes the window to a tile at the bottom of the screen, green zooms it to fill the screen.
- **Drag** by the title bar and **resize** from any edge or corner.
- **Blur the game** behind the open window, turned on in Settings. Roblox blurs the whole 3D world, not just the area behind the window; the interface stays sharp.

### Animations
Switches, sliders, segmented controls, radio buttons and menus move on springs: they overshoot slightly and settle into place. The sidebar highlight slides between tabs. A new page slides in from below or above depending on which way you switched, and its rows appear in a cascade. Numbers on sliders, steppers and progress bars count up to their new value. The window "lifts" while you drag it and its shadow deepens. A minimized window flies along an arc into the tile at the bottom of the screen, and the tile bounces. This is macOS's Scale effect: a real Genie effect needs to bend the window, which Roblox GUIs cannot do. Dialogs slide out from under the title bar like a sheet. Banners can be swiped away to the right, their timer pauses on hover, and a bar along the bottom shows the time left.

## API

### Library
| | |
|---|---|
| `CreateWindow(opts)` | `Title`, `Subtitle`, `Icon`, `IconColor`, `Size` (UDim2 in pixels), `MinSize`, `SidebarWidth`, `Theme` (`"Dark"`/`"Light"`), `Accent`, `Language` (`"en"`/`"ru"`), `Scale` (`"Auto"` or a number such as `1.25`), `ToggleKey`, `ConfigFolder` (`false` disables files), `Watermark`, `KeybindList`, `HideToDock` (the window key minimizes to a tile at the bottom, `true` by default; `false` hides it completely), `Blur` (blur the game behind the window), `CloseBehavior` (`"Unload"` or `"Hide"`) |
| `Notify(opts)` | `Title`, `Content`, `Type` (`"Info"`, `"Success"`, `"Warning"`, `"Error"`), `Duration`, `Buttons = { { Text, Style, Callback } }`, `Callback` on click. Every banner goes into `NotificationHistory` and the notification center |
| `ClearNotifications()` | clears the notification history |
| `SetTheme`, `SetAccent`, `SetScale`, `SetLanguage`, `SetToggleKey`, `SetWatermark`, `SetKeybindList`, `SetHideToDock`, `SetBlur` | change a setting, save it to `<ConfigFolder>/settings.json` and update the Settings tab. The user's saved choice overrides the values passed to `CreateWindow` |
| `Options[flag]` | an element by its `Flag` |
| `SaveConfig`, `LoadConfig`, `DeleteConfig`, `ListConfigs` | configs in `<ConfigFolder>/configs/*.json` |
| `ExportConfig()`, `ImportConfig(text)` | a config as text, for sharing without files |
| `ResetAll()` | resets every element with a `Flag` to its default |
| `SetAutoload`, `GetAutoload`, `LoadAutoloadConfig` | the config that loads on startup |
| `CheckForUpdates({ Url, Current, Link, OnUpdate })` | reads `Url` (plain `1.2.0` or JSON `{"version":"1.2.0"}`) and shows a banner if it is newer than `Current` |
| `OnLanguageChanged(fn)` | `fn(code)` after every language change, so the script can translate its own text. The current language is in `Library.Language` |
| `OnUnload(fn)`, `Unload()` | stop your own loops on unload. Running the script again with the same `Title` unloads the previous copy by itself |
| `Icons`, `Languages`, `Themes`, `Accents` | the icon set, translations, theme palettes, accent presets |

### Icons
`Icon` on the window and tabs takes a name from `Library.Icons`, an image ID or a short glyph. Without an icon, the first letter of the title is drawn. The set has 85 Lucide icons: `home`, `settings`, `user`, `users`, `eye`, `eye-off`, `sword`, `swords`, `crosshair`, `target`, `shield`, `flame`, `star`, `heart`, `map`, `map-pin`, `compass`, `globe`, `search`, `info`, `alert-triangle`, `alert-circle`, `check`, `x`, `bell`, `clock`, `folder`, `file`, `save`, `download`, `upload`, `copy`, `trash`, `trash-2`, `pencil`, `refresh-cw`, `rotate-ccw`, `play`, `pause`, `power`, `lock`, `unlock`, `key`, `keyboard`, `mouse-pointer`, `gamepad-2`, `monitor`, `palette`, `paintbrush`, `sun`, `moon`, `wand-2`, `bot`, `box`, `package`, `gift`, `coins`, `gem`, `shopping-cart`, `trophy`, `crown`, `flag`, `rocket`, `car`, `move`, `activity`, `bar-chart`, `code`, `terminal`, `bug`, `wrench`, `sliders`, `layers`, `list`, `layout-grid`, `command`, `axe`, `skull`, `ghost`, `wifi`, `cloud`, `message-circle`, `music`, `camera`, `image`.

### Window
`AddTab({ Title, Icon, IconColor })` · `AddSidebarHeader(text)` (returns a TextLabel) · `SetSubtitle(text)` · `AddSettingsTab()` · `SelectTab(tab | index)` · `Reveal(element)` · `Dialog({ Title, Content, Buttons = { { Title, Style, Callback } } })` · `SetVisible(bool)` · `Toggle()` · `Minimize()` · `Restore()` · `Zoom()` · `Close()` · `OpenPalette()` · `ClosePalette()` · `OpenNotificationCenter()` · `CloseNotificationCenter()` · `ToggleNotificationCenter()`

A tab's page is attached to the window only when it is first opened, so tabs the user never opens cost nothing at startup. With 6 tabs of 50 elements each, building the window took 64 ms instead of 114 ms.

### Tab and Section
`Tab:AddSection("Title")`, or `Tab:AddSection({ Title, Collapsible = true, Collapsed = true })` for a collapsible section. `Tab:SetTitle(text)` and `Section:SetTitle(text)` change the title; a section created without a title has none. Elements can also be added straight to a tab, where they go into a group without a title.

Every element takes `Title`, `Description`, `Tooltip`, `Flag`, `Disabled` and `Callback`.

| Element | Its own options |
|---|---|
| `AddButton` | with no buttons the whole row is clickable; `ButtonText` + `Style` give one button on the right; `Buttons = { { Text, Style, Callback } }` gives several. `Style`: `"Primary"`, `"Destructive"` |
| `AddToggle` | `Default` |
| `AddCheckbox` | `Default` |
| `AddRadio` | `Values`, `Default` |
| `AddSlider` | `Min`, `Max`, `Default`, `Step`, `Suffix` |
| `AddStepper` | `Min`, `Max`, `Default`, `Step`, `Suffix`, `Width`; − and + buttons, holding one keeps stepping |
| `AddDropdown` | `Values`, `Default`, `Multi`, `AllowNone`, `Searchable` (on by default with 9+ values), `Width`, `ItemText(value)`, `ItemIcon(value)` |
| `AddPlayerDropdown` | `Multi`, `AllowNone`, `ExcludeLocalPlayer`; a player list with avatars that updates itself. `:GetPlayer()` returns the Player |
| `AddInput` | `Default`, `Placeholder`, `Numeric`, `MaxLength`, `Width`, `Finished` (`false`: callback on every character) |
| `AddTextArea` | `Default`, `Placeholder`, `Height`, `Finished` |
| `AddKeybind` | `Default` (`Enum.KeyCode.F`, `MouseButton2`, `"F"` or `"Ctrl+F"`), `Mode` (`"Toggle"`, `"Hold"`, `"Always"`), `AllowModifiers`, `ChangedCallback(key, modifiers)` |
| `AddColorPicker` | `Default`, `Transparency` (adds an opacity slider), `Rainbow`, `RainbowSpeed`; the callback gets `(color, transparency)` |
| `AddSegmented` | `Values`, `Default` |
| `AddProgress` | `Value` (0..1 or 0..`Max`), `Max`, `Indeterminate`; `:SetValue(v)`, `:SetIndeterminate(bool)` |
| `AddSpinner` | `Spinning`; `:SetSpinning(bool)` |
| `AddLabel(text)` | `:SetText` |
| `AddParagraph({ Title, Content })` | `:SetContent` |

Methods every element has: `Value`, `SetValue(value, silent)`, `OnChanged(fn)`, `SetTitle`, `SetDescription`, `SetTooltip`, `SetVisible`, `SetDisabled`, `Reset`, `Destroy`. Plus `Dropdown:SetValues(list)`, `Slider:SetRange(min, max)`, `Keybind:GetState()`, `ColorPicker:SetTransparency(t)` and `:SetRainbow(bool)`.

Callbacks do not fire when an element is created, only when its value changes, including when a config loads. Read the initial value from `.Value`.

### Adding a language
Add a table with the same keys as `Library.Languages.en` and an entry in `LanguageNames`. Do this before creating the window:

```lua
Library.Languages.de = { Settings = "Einstellungen", ... }
table.insert(Library.LanguageNames, { Code = "de", Name = "Deutsch" })
```

### Translating your script
The library translates only its own strings. Change your script's text in `Library:OnLanguageChanged`: elements have `SetTitle`, `SetDescription` and `SetTooltip`, tabs and sections have `SetTitle`, and the window has `SetSubtitle`.

```lua
local Texts = {
    en = { Main = "Main", AutoFarm = "Auto farm" },
    ru = { Main = "Главная", AutoFarm = "Автофарм" },
}
local function T(key)
    return (Texts[Library.Language] or Texts.en)[key]
end

local Main = Window:AddTab({ Title = T("Main"), Icon = "home" })
local AutoFarm = Main:AddToggle({ Title = T("AutoFarm"), Flag = "AutoFarm" })

Library:OnLanguageChanged(function()
    Main:SetTitle(T("Main"))
    AutoFarm:SetTitle(T("AutoFarm"))
end)
```

## Autocomplete
Copy the contents of `types/PaneUI.luau` to the top of your script and annotate the type:

```lua
local Library: PaneUI = loadstring(game:HttpGet(URL))()
```

The types are only for the editor. If your obfuscator rejects type annotations, remove that block before obfuscating; the script works the same.

## Obfuscation

The library uses Lua 5.1 syntax (no `+=`, `continue`, string interpolation or type annotations) and contains no obfuscator macros, so any obfuscator of any version accepts it: Luraph v14 and v15, Luarmor and others.

You don't need to obfuscate the library itself: it is an interface with no secrets. It is simpler to keep it public on GitHub, load it with `loadstring` and protect only your own script. Public methods are string table keys, which obfuscators leave alone, so your script works the same with an obfuscated or a plain library.

If your own scripts use Luraph macros, note that v15 removed the old `LPH_NO_VIRTUALIZE`, `LPH_JIT`, `LPH_NO_UPVALUES` and `LPH_ENCFUNC` in favor of attributes such as `LPH_ATTRIBUTES(VM(NONE))`. Both v14 and v15 fail on any unknown macro starting with `LPH`, so the syntax has to match the version you obfuscate with. Luarmor obfuscates through Luraph, and its documentation currently describes only `LPH_NO_VIRTUALIZE` from v14.

### Luraph in one command
If you have Luraph API access (not every plan includes it), `tools/obfuscate.py` sends a file to Luraph, waits for the result and saves it to `dist/`. It needs Python 3 and no extra packages.

```bash
python tools/obfuscate.py --list-options
```

Lists the options your Luraph node accepts and their allowed values. Put the ones you want in `tools/luraph.json`, following `tools/luraph.example.json`, or pass them as `--option NAME=VALUE`.

```bash
python tools/obfuscate.py
```

Obfuscates `src/PaneUI.lua` into `dist/PaneUI.lua`.

```bash
python tools/obfuscate.py --bundle scripts/my-script.lua
```

Inlines the library into the script (no `loadstring`) and obfuscates everything as one file into `dist/my-script.lua`. Without `--bundle`, only the script itself is obfuscated.

The key comes from `--key`, the `LURAPH_API_KEY` environment variable, or the `"key"` field in `tools/luraph.json`. The easiest way on Windows is to save the variable once with `setx LURAPH_API_KEY "your-key"` (works from PowerShell, cmd and Git Bash) and then reopen the terminal. If you keep the key in `tools/luraph.json`, don't publish that file. `--dry-run` shows what would be sent to the API without sending anything.

## Testing in game without hosting

```bash
tools/build-dev.sh examples/demo.lua
```

Bundles the library and the demo into `build/dev.lua` with the `loadstring` line cut out. You can run that file in your executor right away.

## License

[MIT](LICENSE): use the library anywhere, including closed-source and obfuscated scripts, as long as you keep the copyright line from `LICENSE`.

## Credits

- Icons: [Lucide](https://lucide.dev), ISC license, © Lucide Icons and Contributors.
- The table of Roblox asset IDs for these icons comes from [Fluent](https://github.com/dawid-scripts/Fluent), MIT license, © 2023 dawid.
- Font: Inter, served by Roblox itself.
