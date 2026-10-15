# PaneUI

UI-библиотека для скриптов в стиле macOS. Окно со «светофором», боковая панель с поиском как в System Settings, сгруппированные формы, светлая и тёмная тема, акцентный цвет, английский и русский интерфейс, масштаб под любое разрешение. Есть конфиги, уведомления-баннеры с центром уведомлений, палитра команд, диалоги, контекстное меню, подсказки, водяной знак и список кейбиндов. Всё двигается на пружинной физике, как в macOS.

```
src/PaneUI.lua          библиотека, один файл: его и хостить
examples/demo.lua       все элементы в одном окне
types/PaneUI.luau       типы для автодополнения в редакторе
tools/build-dev.sh      склеивает библиотеку со скриптом для теста без хостинга
tools/obfuscate.py      обфускация через Luraph одной командой
```

## Подключение

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Noctyde/pane-ui/main/src/PaneUI.lua"))()

local Window = Library:CreateWindow({ Title = "My Script", Icon = "sword" })
local Main = Window:AddTab({ Title = "Main", Icon = "home" })
local Combat = Main:AddSection("Combat")

Combat:AddToggle({ Title = "Auto farm", Flag = "AutoFarm", Callback = function(on) end })

Window:AddSettingsTab()          -- тема, акцент, размер, язык, оверлеи, конфиги, выгрузка
Library:LoadAutoloadConfig()     -- в конце, когда все элементы с Flag уже созданы
```

## Что умеет окно

- **Поиск.** Поле вверху боковой панели или Ctrl+F. Ищет по названиям, описаниям, секциям и вкладкам. Клик по результату открывает нужную вкладку, прокручивает к элементу и подсвечивает его.
- **Правый клик по строке.** «Сбросить к умолчанию» и «Копировать значение».
- **Подсказки.** `Tooltip = "..."` у любого элемента, появляются через полсекунды наведения.
- **Палитра команд, Ctrl+K.** Работает даже при скрытом окне. Набираешь часть названия: тоггл переключается, кнопка срабатывает, остальное открывается в окне. Стрелки выбирают, Enter запускает, Esc закрывает.
- **Центр уведомлений.** Колокольчик в заголовке окна показывает прошлые баннеры; красный счётчик — сколько пришло с последнего открытия.
- **Светофор.** Красная кнопка спрашивает, выгрузить ли скрипт; жёлтая сворачивает окно в плашку внизу экрана; зелёная разворачивает на весь экран.
- **Перетаскивание** за заголовок и **ресайз** за любой край или угол.
- **Размытие игры** за открытым окном, включается в Settings. Roblox размывает весь 3D-мир, а не только область за окном; интерфейс остаётся чётким.

### Анимации
Свитчи, ползунки, сегменты, радиокнопки и меню двигаются на пружинах: слегка перелетают и упруго встают на место. Подсветка в боковой панели переезжает между вкладками. Новая страница въезжает снизу или сверху в зависимости от того, куда переключился, а её строки появляются каскадом. Числа у слайдеров, степперов и прогресса докручиваются до нового значения. Окно при перетаскивании «приподнимается»: тень становится глубже. Свёрнутое окно улетает по дуге в плашку внизу экрана, плашка подпрыгивает. Это эффект «Масштаб» из macOS: настоящий Genie требует изгибать окно, а GUI в Roblox так не умеет. Диалоги выезжают из-под заголовка, как sheet. Баннеры можно смахнуть вправо, при наведении их таймер замирает, полоска внизу показывает оставшееся время.

## API

### Library
| | |
|---|---|
| `CreateWindow(opts)` | `Title`, `Subtitle`, `Icon`, `IconColor`, `Size` (UDim2 в пикселях), `MinSize`, `SidebarWidth`, `Theme` (`"Dark"`/`"Light"`), `Accent`, `Language` (`"en"`/`"ru"`), `Scale` (`"Auto"` или число, например `1.25`), `ToggleKey`, `ConfigFolder` (`false` отключает файлы), `Watermark`, `KeybindList`, `HideToDock` (клавиша окна сворачивает в плашку внизу, по умолчанию `true`; `false` прячет полностью), `Blur` (размытие игры за окном), `CloseBehavior` (`"Unload"` или `"Hide"`) |
| `Notify(opts)` | `Title`, `Content`, `Type` (`"Info"`, `"Success"`, `"Warning"`, `"Error"`), `Duration`, `Buttons = { { Text, Style, Callback } }`, `Callback` при клике. Каждый баннер попадает в `NotificationHistory` и центр уведомлений |
| `ClearNotifications()` | очищает историю уведомлений |
| `SetTheme`, `SetAccent`, `SetScale`, `SetLanguage`, `SetToggleKey`, `SetWatermark`, `SetKeybindList`, `SetHideToDock`, `SetBlur` | меняют настройку, сохраняют её в `<ConfigFolder>/settings.json` и обновляют вкладку Settings. Сохранённый выбор пользователя перекрывает значения из `CreateWindow` |
| `Options[flag]` | элемент по его `Flag` |
| `SaveConfig`, `LoadConfig`, `DeleteConfig`, `ListConfigs` | конфиги в `<ConfigFolder>/configs/*.json` |
| `ExportConfig()`, `ImportConfig(text)` | конфиг текстом, чтобы делиться без файлов |
| `ResetAll()` | все элементы с `Flag` к значениям по умолчанию |
| `SetAutoload`, `GetAutoload`, `LoadAutoloadConfig` | конфиг, который грузится при старте |
| `CheckForUpdates({ Url, Current, Link, OnUpdate })` | читает `Url` (просто `1.2.0` или JSON `{"version":"1.2.0"}`) и показывает баннер, если версия новее `Current` |
| `OnLanguageChanged(fn)` | `fn(code)` после каждой смены языка, чтобы скрипт переводил свои тексты. Текущий язык в `Library.Language` |
| `OnUnload(fn)`, `Unload()` | остановить свои циклы при выгрузке. Повторный запуск скрипта с тем же `Title` сам выгружает прошлую копию |
| `Icons`, `Languages`, `Themes`, `Accents` | набор иконок, переводы, палитры тем, пресеты акцента |

### Иконки
`Icon` у окна и вкладок принимает имя из `Library.Icons`, ID картинки или короткий символ. Без иконки рисуется первая буква названия. В наборе 85 иконок Lucide: `home`, `settings`, `user`, `users`, `eye`, `eye-off`, `sword`, `swords`, `crosshair`, `target`, `shield`, `flame`, `star`, `heart`, `map`, `map-pin`, `compass`, `globe`, `search`, `info`, `alert-triangle`, `alert-circle`, `check`, `x`, `bell`, `clock`, `folder`, `file`, `save`, `download`, `upload`, `copy`, `trash`, `trash-2`, `pencil`, `refresh-cw`, `rotate-ccw`, `play`, `pause`, `power`, `lock`, `unlock`, `key`, `keyboard`, `mouse-pointer`, `gamepad-2`, `monitor`, `palette`, `paintbrush`, `sun`, `moon`, `wand-2`, `bot`, `box`, `package`, `gift`, `coins`, `gem`, `shopping-cart`, `trophy`, `crown`, `flag`, `rocket`, `car`, `move`, `activity`, `bar-chart`, `code`, `terminal`, `bug`, `wrench`, `sliders`, `layers`, `list`, `layout-grid`, `command`, `axe`, `skull`, `ghost`, `wifi`, `cloud`, `message-circle`, `music`, `camera`, `image`.

### Window
`AddTab({ Title, Icon, IconColor })` · `AddSidebarHeader(text)` (возвращает TextLabel) · `SetSubtitle(text)` · `AddSettingsTab()` · `SelectTab(tab | index)` · `Reveal(element)` · `Dialog({ Title, Content, Buttons = { { Title, Style, Callback } } })` · `SetVisible(bool)` · `Toggle()` · `Minimize()` · `Restore()` · `Zoom()` · `Close()` · `OpenPalette()` · `ClosePalette()` · `OpenNotificationCenter()` · `CloseNotificationCenter()` · `ToggleNotificationCenter()`

Страница вкладки подключается к окну только при первом открытии, поэтому вкладки, которые пользователь не открывал, ничего не стоят при запуске. На 6 вкладках по 50 элементов создание окна вышло 64 мс против 114 мс без этого.

### Tab и Section
`Tab:AddSection("Title")` или `Tab:AddSection({ Title, Collapsible = true, Collapsed = true })` для сворачиваемой секции. `Tab:SetTitle(text)` и `Section:SetTitle(text)` меняют заголовок; у секции без заголовка его нет. Элементы можно добавлять и прямо во вкладку, они попадут в группу без заголовка.

У всех элементов есть общие параметры `Title`, `Description`, `Tooltip`, `Flag`, `Disabled`, `Callback`.

| Элемент | Свои параметры |
|---|---|
| `AddButton` | без кнопок кликается вся строка; `ButtonText` + `Style` дают одну кнопку справа; `Buttons = { { Text, Style, Callback } }` несколько. `Style`: `"Primary"`, `"Destructive"` |
| `AddToggle` | `Default` |
| `AddCheckbox` | `Default` |
| `AddRadio` | `Values`, `Default` |
| `AddSlider` | `Min`, `Max`, `Default`, `Step`, `Suffix` |
| `AddStepper` | `Min`, `Max`, `Default`, `Step`, `Suffix`, `Width`; кнопки − и +, удержание повторяет шаг |
| `AddDropdown` | `Values`, `Default`, `Multi`, `AllowNone`, `Searchable` (по умолчанию при 9+ значениях), `Width`, `ItemText(value)`, `ItemIcon(value)` |
| `AddPlayerDropdown` | `Multi`, `AllowNone`, `ExcludeLocalPlayer`; список игроков с аватарками, сам обновляется. `:GetPlayer()` возвращает Player |
| `AddInput` | `Default`, `Placeholder`, `Numeric`, `MaxLength`, `Width`, `Finished` (`false`: колбэк на каждый символ) |
| `AddTextArea` | `Default`, `Placeholder`, `Height`, `Finished` |
| `AddKeybind` | `Default` (`Enum.KeyCode.F`, `MouseButton2`, `"F"` или `"Ctrl+F"`), `Mode` (`"Toggle"`, `"Hold"`, `"Always"`), `AllowModifiers`, `ChangedCallback(key, modifiers)` |
| `AddColorPicker` | `Default`, `Transparency` (включает ползунок прозрачности), `Rainbow`, `RainbowSpeed`; колбэк получает `(color, transparency)` |
| `AddSegmented` | `Values`, `Default` |
| `AddProgress` | `Value` (0..1 или 0..`Max`), `Max`, `Indeterminate`; `:SetValue(v)`, `:SetIndeterminate(bool)` |
| `AddSpinner` | `Spinning`; `:SetSpinning(bool)` |
| `AddLabel(text)` | `:SetText` |
| `AddParagraph({ Title, Content })` | `:SetContent` |

Общие методы элементов: `Value`, `SetValue(value, silent)`, `OnChanged(fn)`, `SetTitle`, `SetDescription`, `SetTooltip`, `SetVisible`, `SetDisabled`, `Reset`, `Destroy`. Плюс `Dropdown:SetValues(list)`, `Slider:SetRange(min, max)`, `Keybind:GetState()`, `ColorPicker:SetTransparency(t)` и `:SetRainbow(bool)`.

Колбэки не вызываются при создании элемента, только при изменении, в том числе при загрузке конфига. Начальное значение читай из `.Value`.

### Свой язык
Добавь таблицу с теми же ключами, что в `Library.Languages.en`, и пункт в `LanguageNames`. Язык должен быть добавлен до создания окна:

```lua
Library.Languages.de = { Settings = "Einstellungen", ... }
table.insert(Library.LanguageNames, { Code = "de", Name = "Deutsch" })
```

### Перевод своего скрипта
Библиотека переводит только свои строки. Тексты скрипта меняй в `Library:OnLanguageChanged`: у элементов есть `SetTitle`, `SetDescription` и `SetTooltip`, у вкладок и секций `SetTitle`, у окна `SetSubtitle`.

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

## Автодополнение
Скопируй содержимое `types/PaneUI.luau` в начало скрипта и укажи тип:

```lua
local Library: PaneUI = loadstring(game:HttpGet(URL))()
```

Типы нужны только редактору. Если обфускатор не примет аннотации типов, удали этот блок перед обфускацией, скрипт работает так же.

## Обфускация

Библиотека написана на синтаксисе Lua 5.1 (без `+=`, `continue`, строковой интерполяции и аннотаций типов) и не содержит макросов обфускаторов. Поэтому её примет любой обфускатор любой версии: Luraph v14 и v15, Luarmor и другие.

Обфусцировать саму библиотеку не обязательно: это интерфейс без секретов. Проще держать её открытой на GitHub, подключать через `loadstring`, а защищать только свой скрипт. Публичные методы — это строковые ключи таблиц, обфускатор их не меняет, поэтому скрипт работает одинаково и с обфусцированной, и с обычной библиотекой.

Если в своих скриптах используешь макросы Luraph, учти: в v15 старые `LPH_NO_VIRTUALIZE`, `LPH_JIT`, `LPH_NO_UPVALUES` и `LPH_ENCFUNC` удалены, их заменили атрибуты вроде `LPH_ATTRIBUTES(VM(NONE))`. И v14, и v15 падают при обфускации на любом незнакомом макросе с префиксом `LPH`, поэтому синтаксис должен совпадать с версией, которой обфусцируешь. Luarmor обфусцирует через Luraph, а в его документации пока описан только `LPH_NO_VIRTUALIZE` из v14.

### Luraph одной командой
Если у тебя есть доступ к API Luraph (он есть не на всех тарифах), `tools/obfuscate.py` отправит файл в Luraph, дождётся результата и положит его в `dist/`. Нужен Python 3 без дополнительных пакетов.

```bash
python tools/obfuscate.py --list-options
```

Покажет опции твоего узла Luraph и допустимые значения. Нужные запиши в `tools/luraph.json` по образцу `tools/luraph.example.json` или передавай как `--option ИМЯ=ЗНАЧЕНИЕ`.

```bash
python tools/obfuscate.py
```

Обфусцирует `src/PaneUI.lua` в `dist/PaneUI.lua`.

```bash
python tools/obfuscate.py --bundle scripts/my-script.lua
```

Вклеит библиотеку прямо в скрипт (без `loadstring`) и обфусцирует всё одним файлом в `dist/my-script.lua`. Без `--bundle` обфусцируется только сам скрипт.

Ключ берётся из `--key`, из переменной окружения `LURAPH_API_KEY` или из поля `"key"` в `tools/luraph.json`. Удобнее всего один раз сохранить переменную в Windows: `setx LURAPH_API_KEY "ключ"` (работает в PowerShell, cmd и Git Bash), после этого открыть терминал заново. Если ключ лежит в `tools/luraph.json`, не публикуй этот файл. `--dry-run` показывает, что уйдёт в API, ничего не отправляя.

## Тест в игре без хостинга

```bash
tools/build-dev.sh examples/demo.lua
```

Скрипт склеит библиотеку и демо в `build/dev.lua`, строка с `loadstring` вырезается. Этот файл можно сразу запускать в экзекуторе.

## Лицензия

[MIT](LICENSE): библиотеку можно использовать где угодно, в том числе в закрытых и обфусцированных скриптах, если сохранять строку с авторством из `LICENSE`.

## Благодарности

- Иконки — [Lucide](https://lucide.dev), лицензия ISC, © Lucide Icons and Contributors.
- Таблица ID этих иконок, загруженных в Roblox, взята из [Fluent](https://github.com/dawid-scripts/Fluent), лицензия MIT, © 2023 dawid.
- Шрифт — Inter, его раздаёт сам Roblox.
