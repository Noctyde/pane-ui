--[[
    PaneUI - macOS-style UI library for Roblox scripts.

    Written in plain Lua 5.1 syntax (no compound assignment, continue,
    string interpolation or type annotations) and without obfuscator
    macros, so any obfuscator, whatever its version, accepts the file as is.
]]

local cloneref = cloneref or function(instance)
    return instance
end
local setclipboard = setclipboard or toclipboard

local function GetService(name)
    return cloneref(game:GetService(name))
end

local Players = GetService("Players")
local UserInputService = GetService("UserInputService")
local TweenService = GetService("TweenService")
local HttpService = GetService("HttpService")
local TextService = GetService("TextService")
local GuiService = GetService("GuiService")
local RunService = GetService("RunService")
local Lighting = GetService("Lighting")
local CoreGui = GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local function rgb(r, g, b)
    return Color3.fromRGB(r, g, b)
end

local function CopyTable(source)
    local copy = {}
    for key, value in pairs(source) do
        copy[key] = value
    end
    return copy
end

--==============================================================
-- Library table
--==============================================================

local Library = {
    Version = "1.5.0",
    Options = {},
    Windows = {},
    Unloaded = false,
    ThemeName = "Dark",
    Accent = rgb(10, 132, 255),
    ToggleKey = Enum.KeyCode.RightShift,
    Language = "en",
    ScaleSetting = "Auto",
    UIScale = 1,
    ShowWatermark = false,
    ShowKeybinds = false,
    HideToDock = true,
    BlurBackground = false,
    NotificationHistory = {},
    Folder = nil,
}

Library.Languages = {
    en = {
        Settings = "Settings",
        Appearance = "Appearance",
        Theme = "Theme",
        Light = "Light",
        Dark = "Dark",
        AccentColor = "Accent color",
        InterfaceSize = "Interface size",
        InterfaceSizeDescription = "Auto picks a size from the screen resolution",
        Auto = "Auto",
        Language = "Language",
        ToggleKey = "Toggle key",
        ToggleKeyDescription = "Shows and hides the window",
        Overlays = "Overlays",
        Watermark = "Watermark",
        WatermarkDescription = "Script name, FPS, ping and time in the top bar",
        KeybindList = "Keybind list",
        KeybindListDescription = "Floating list of keybinds and their state",
        DockTile = "Dock tile when hidden",
        DockTileDescription = "The toggle key leaves a tile at the bottom of the screen; turn off to hide the window completely",
        Keybinds = "Keybinds",
        Configs = "Configs",
        ConfigName = "Config name",
        ConfigNamePlaceholder = "my-config",
        ConfigList = "Saved configs",
        ConfigActions = "Selected config",
        ConfigActionsDescription = "Save creates a config from the name above",
        Autoload = "Autoload",
        AutoloadCurrent = "Loaded on start: %s",
        ShareConfig = "Share config",
        ShareConfigDescription = "Copies the current settings as text",
        ImportConfig = "Import config",
        ImportConfigPlaceholder = "Paste config text",
        Save = "Save",
        Load = "Load",
        Delete = "Delete",
        Set = "Set",
        Clear = "Clear",
        Copy = "Copy",
        Reset = "Reset",
        None = "None",
        NotSet = "not set",
        Script = "Script",
        ResetAll = "Reset all settings",
        ResetAllDescription = "Puts every option back to its default value",
        ResetAllTitle = "Reset all settings?",
        ResetAllContent = "Every option goes back to its default value. Saved configs are kept.",
        Unload = "Unload",
        UnloadDescription = "Closes the window and stops the script",
        Cancel = "Cancel",
        CloseTitle = "Close %s?",
        CloseContent = "The script will be unloaded. To only hide the window, press %s.",
        PressKey = "Press a key...",
        Search = "Search",
        SearchResults = "Search",
        NoResults = "Nothing found for \"%s\"",
        Now = "now",
        ResetToDefault = "Reset to default",
        CopyValue = "Copy value",
        Rainbow = "Rainbow",
        Copied = "Copied to the clipboard",
        ConfigSaved = "Config \"%s\" saved",
        ConfigLoaded = "Config \"%s\" loaded",
        ConfigDeleted = "Config \"%s\" deleted",
        ConfigLoadFailed = "Could not load \"%s\"",
        ConfigImported = "Config imported",
        ConfigImportFailed = "That text is not a valid config",
        EnterConfigName = "Enter a config name first",
        PickConfig = "Pick a config first",
        NoFileApi = "This executor has no file functions",
        NoClipboard = "This executor cannot copy to the clipboard",
        HiddenHint = "Press %s to show the window",
        UpdateAvailable = "Update available",
        UpdateContent = "Version %s is out, you have %s.",
        CopyLink = "Copy link",
        Blur = "Blur the game",
        BlurDescription = "Blurs the world behind the window while it is open",
        Notifications = "Notifications",
        ClearAll = "Clear all",
        NoNotifications = "No notifications yet",
        MinutesAgo = "%d min ago",
        HoursAgo = "%d h ago",
        CommandPlaceholder = "Type a command or a setting",
        NoCommands = "Nothing matches",
        On = "On",
        Off = "Off",
        Run = "Run",
        Show = "Show",
        Tab = "Tab",
    },
    ru = {
        Settings = "Настройки",
        Appearance = "Оформление",
        Theme = "Тема",
        Light = "Светлая",
        Dark = "Тёмная",
        AccentColor = "Цвет акцента",
        InterfaceSize = "Размер интерфейса",
        InterfaceSizeDescription = "«Авто» подбирает размер под разрешение экрана",
        Auto = "Авто",
        Language = "Язык",
        ToggleKey = "Клавиша окна",
        ToggleKeyDescription = "Показывает и прячет окно",
        Overlays = "Оверлеи",
        Watermark = "Водяной знак",
        WatermarkDescription = "Название скрипта, FPS, пинг и время сверху",
        KeybindList = "Список кейбиндов",
        KeybindListDescription = "Плавающий список кейбиндов и их состояние",
        DockTile = "Плашка при скрытии",
        DockTileDescription = "Клавиша окна оставляет плашку внизу экрана; выключите, чтобы прятать окно полностью",
        Keybinds = "Кейбинды",
        Configs = "Конфиги",
        ConfigName = "Имя конфига",
        ConfigNamePlaceholder = "my-config",
        ConfigList = "Сохранённые конфиги",
        ConfigActions = "Выбранный конфиг",
        ConfigActionsDescription = "«Сохранить» создаёт конфиг с именем выше",
        Autoload = "Автозагрузка",
        AutoloadCurrent = "При запуске: %s",
        ShareConfig = "Поделиться конфигом",
        ShareConfigDescription = "Копирует текущие настройки текстом",
        ImportConfig = "Импорт конфига",
        ImportConfigPlaceholder = "Вставьте текст конфига",
        Save = "Сохранить",
        Load = "Загрузить",
        Delete = "Удалить",
        Set = "Назначить",
        Clear = "Убрать",
        Copy = "Копировать",
        Reset = "Сбросить",
        None = "Нет",
        NotSet = "не задан",
        Script = "Скрипт",
        ResetAll = "Сбросить все настройки",
        ResetAllDescription = "Возвращает все опции к значениям по умолчанию",
        ResetAllTitle = "Сбросить все настройки?",
        ResetAllContent = "Все опции вернутся к значениям по умолчанию. Сохранённые конфиги останутся.",
        Unload = "Выгрузить",
        UnloadDescription = "Закрывает окно и останавливает скрипт",
        Cancel = "Отмена",
        CloseTitle = "Закрыть %s?",
        CloseContent = "Скрипт будет выгружен. Чтобы просто спрятать окно, нажмите %s.",
        PressKey = "Нажмите клавишу...",
        Search = "Поиск",
        SearchResults = "Поиск",
        NoResults = "Ничего не найдено по запросу «%s»",
        Now = "сейчас",
        ResetToDefault = "Сбросить к умолчанию",
        CopyValue = "Копировать значение",
        Rainbow = "Радуга",
        Copied = "Скопировано в буфер обмена",
        ConfigSaved = "Конфиг «%s» сохранён",
        ConfigLoaded = "Конфиг «%s» загружен",
        ConfigDeleted = "Конфиг «%s» удалён",
        ConfigLoadFailed = "Не удалось загрузить «%s»",
        ConfigImported = "Конфиг импортирован",
        ConfigImportFailed = "Этот текст не похож на конфиг",
        EnterConfigName = "Сначала введите имя конфига",
        PickConfig = "Сначала выберите конфиг",
        NoFileApi = "У этого экзекутора нет функций для работы с файлами",
        NoClipboard = "Этот экзекутор не умеет копировать в буфер обмена",
        HiddenHint = "Нажмите %s, чтобы показать окно",
        UpdateAvailable = "Доступно обновление",
        UpdateContent = "Вышла версия %s, у вас %s.",
        CopyLink = "Копировать ссылку",
        Blur = "Размытие игры",
        BlurDescription = "Размывает мир за окном, пока оно открыто",
        Notifications = "Уведомления",
        ClearAll = "Очистить",
        NoNotifications = "Уведомлений пока нет",
        MinutesAgo = "%d мин назад",
        HoursAgo = "%d ч назад",
        CommandPlaceholder = "Команда или настройка",
        NoCommands = "Ничего не найдено",
        On = "Вкл",
        Off = "Выкл",
        Run = "Выполнить",
        Show = "Показать",
        Tab = "Вкладка",
    },
}

Library.LanguageNames = {
    { Code = "en", Name = "English" },
    { Code = "ru", Name = "Русский" },
}

Library.Strings = CopyTable(Library.Languages.en)

Library.Themes = {
    Dark = {
        Background = rgb(30, 30, 32),
        Sidebar = rgb(40, 40, 43),
        SidebarHover = rgb(52, 52, 56),
        SearchField = rgb(52, 52, 56),
        Group = rgb(43, 43, 46),
        GroupStroke = rgb(56, 56, 60),
        Separator = rgb(54, 54, 58),
        WindowStroke = rgb(74, 74, 79),
        Text = rgb(242, 242, 247),
        SubText = rgb(158, 158, 164),
        Tertiary = rgb(108, 108, 114),
        Control = rgb(72, 72, 76),
        ControlHover = rgb(84, 84, 89),
        ControlStroke = rgb(84, 84, 89),
        Field = rgb(36, 36, 39),
        FieldStroke = rgb(68, 68, 72),
        SwitchOff = rgb(68, 68, 72),
        Knob = rgb(255, 255, 255),
        KnobStroke = rgb(0, 0, 0),
        KnobStrokeTransparency = 0.8,
        Track = rgb(68, 68, 72),
        SegmentBg = rgb(36, 36, 39),
        SegmentSelected = rgb(94, 94, 99),
        Popup = rgb(44, 44, 47),
        PopupStroke = rgb(72, 72, 77),
        RowHover = rgb(54, 54, 58),
        Overlay = rgb(0, 0, 0),
        OverlayTransparency = 0.45,
        ShadowOpacity = 0.3,
        Scrollbar = rgb(110, 110, 116),
        AccentText = rgb(255, 255, 255),
    },
    Light = {
        Background = rgb(246, 246, 248),
        Sidebar = rgb(234, 234, 238),
        SidebarHover = rgb(222, 222, 227),
        SearchField = rgb(222, 222, 227),
        Group = rgb(255, 255, 255),
        GroupStroke = rgb(225, 225, 230),
        Separator = rgb(232, 232, 236),
        WindowStroke = rgb(200, 200, 206),
        Text = rgb(29, 29, 31),
        SubText = rgb(110, 110, 115),
        Tertiary = rgb(160, 160, 166),
        Control = rgb(255, 255, 255),
        ControlHover = rgb(243, 243, 246),
        ControlStroke = rgb(205, 205, 211),
        Field = rgb(255, 255, 255),
        FieldStroke = rgb(205, 205, 211),
        SwitchOff = rgb(222, 222, 227),
        Knob = rgb(255, 255, 255),
        KnobStroke = rgb(0, 0, 0),
        KnobStrokeTransparency = 0.82,
        Track = rgb(220, 220, 225),
        SegmentBg = rgb(229, 229, 234),
        SegmentSelected = rgb(255, 255, 255),
        Popup = rgb(250, 250, 252),
        PopupStroke = rgb(208, 208, 214),
        RowHover = rgb(240, 240, 244),
        Overlay = rgb(0, 0, 0),
        OverlayTransparency = 0.7,
        ShadowOpacity = 0.14,
        Scrollbar = rgb(170, 170, 176),
        AccentText = rgb(255, 255, 255),
    },
}

Library.Accents = {
    { Name = "Blue", Color = rgb(10, 132, 255) },
    { Name = "Purple", Color = rgb(191, 90, 242) },
    { Name = "Pink", Color = rgb(255, 55, 95) },
    { Name = "Red", Color = rgb(255, 69, 58) },
    { Name = "Orange", Color = rgb(255, 159, 10) },
    { Name = "Yellow", Color = rgb(255, 204, 0) },
    { Name = "Green", Color = rgb(48, 209, 88) },
    { Name = "Graphite", Color = rgb(142, 142, 147) },
}

-- Lucide icons as uploaded to Roblox. Use them by name, for example
-- Icon = "settings". Icons: Lucide, ISC license, (c) Lucide Icons and
-- Contributors; asset ids taken from Fluent by dawid, MIT license.
Library.Icons = {
    ["activity"] = "rbxassetid://10709752035",
    ["alert-circle"] = "rbxassetid://10709752996",
    ["alert-triangle"] = "rbxassetid://10709753149",
    ["axe"] = "rbxassetid://10709769508",
    ["bar-chart"] = "rbxassetid://10709773755",
    ["bell"] = "rbxassetid://10709775704",
    ["bot"] = "rbxassetid://10709782230",
    ["box"] = "rbxassetid://10709782497",
    ["bug"] = "rbxassetid://10709782845",
    ["camera"] = "rbxassetid://10709789686",
    ["car"] = "rbxassetid://10709789810",
    ["check"] = "rbxassetid://10709790644",
    ["clock"] = "rbxassetid://10709805144",
    ["cloud"] = "rbxassetid://10709806740",
    ["code"] = "rbxassetid://10709810463",
    ["coins"] = "rbxassetid://10709811110",
    ["command"] = "rbxassetid://10709811365",
    ["compass"] = "rbxassetid://10709811445",
    ["copy"] = "rbxassetid://10709812159",
    ["crosshair"] = "rbxassetid://10709818534",
    ["crown"] = "rbxassetid://10709818626",
    ["download"] = "rbxassetid://10723344270",
    ["eye"] = "rbxassetid://10723346959",
    ["eye-off"] = "rbxassetid://10723346871",
    ["file"] = "rbxassetid://10723374641",
    ["flag"] = "rbxassetid://10723375890",
    ["flame"] = "rbxassetid://10723376114",
    ["folder"] = "rbxassetid://10723387563",
    ["gamepad-2"] = "rbxassetid://10723395215",
    ["gem"] = "rbxassetid://10723396000",
    ["ghost"] = "rbxassetid://10723396107",
    ["gift"] = "rbxassetid://10723396402",
    ["globe"] = "rbxassetid://10723404337",
    ["heart"] = "rbxassetid://10723406885",
    ["home"] = "rbxassetid://10723407389",
    ["image"] = "rbxassetid://10723415040",
    ["info"] = "rbxassetid://10723415903",
    ["key"] = "rbxassetid://10723416652",
    ["keyboard"] = "rbxassetid://10723416765",
    ["layers"] = "rbxassetid://10723424505",
    ["layout-grid"] = "rbxassetid://10723424838",
    ["list"] = "rbxassetid://10723433811",
    ["lock"] = "rbxassetid://10723434711",
    ["map"] = "rbxassetid://10734886202",
    ["map-pin"] = "rbxassetid://10734886004",
    ["message-circle"] = "rbxassetid://10734888000",
    ["monitor"] = "rbxassetid://10734896881",
    ["moon"] = "rbxassetid://10734897102",
    ["mouse-pointer"] = "rbxassetid://10734898476",
    ["move"] = "rbxassetid://10734900011",
    ["music"] = "rbxassetid://10734905958",
    ["package"] = "rbxassetid://10734909540",
    ["paintbrush"] = "rbxassetid://10734910187",
    ["palette"] = "rbxassetid://10734910430",
    ["pause"] = "rbxassetid://10734919336",
    ["pencil"] = "rbxassetid://10734919691",
    ["play"] = "rbxassetid://10734923549",
    ["power"] = "rbxassetid://10734930466",
    ["refresh-cw"] = "rbxassetid://10734933222",
    ["rocket"] = "rbxassetid://10734934585",
    ["rotate-ccw"] = "rbxassetid://10734940376",
    ["save"] = "rbxassetid://10734941499",
    ["search"] = "rbxassetid://10734943674",
    ["settings"] = "rbxassetid://10734950309",
    ["shield"] = "rbxassetid://10734951847",
    ["shopping-cart"] = "rbxassetid://10734952479",
    ["skull"] = "rbxassetid://10734962068",
    ["sliders"] = "rbxassetid://10734963400",
    ["star"] = "rbxassetid://10734966248",
    ["sun"] = "rbxassetid://10734974297",
    ["sword"] = "rbxassetid://10734975486",
    ["swords"] = "rbxassetid://10734975692",
    ["target"] = "rbxassetid://10734977012",
    ["terminal"] = "rbxassetid://10734982144",
    ["trash"] = "rbxassetid://10747362393",
    ["trash-2"] = "rbxassetid://10747362241",
    ["trophy"] = "rbxassetid://10747363809",
    ["unlock"] = "rbxassetid://10747366027",
    ["upload"] = "rbxassetid://10747366434",
    ["user"] = "rbxassetid://10747373176",
    ["users"] = "rbxassetid://10747373426",
    ["wand-2"] = "rbxassetid://10747376349",
    ["wifi"] = "rbxassetid://10747382504",
    ["wrench"] = "rbxassetid://10747383470",
    ["x"] = "rbxassetid://10747384394",
}

local TrafficColors = {
    Close = rgb(255, 95, 87),
    Minimize = rgb(254, 188, 46),
    Zoom = rgb(40, 200, 64),
}

local IconPalette = {
    rgb(10, 132, 255),
    rgb(191, 90, 242),
    rgb(255, 55, 95),
    rgb(255, 159, 10),
    rgb(48, 209, 88),
    rgb(100, 210, 255),
    rgb(255, 69, 58),
    rgb(142, 142, 147),
}

local StatusStyles = {
    Info = { Color = rgb(10, 132, 255), Icon = "info" },
    Success = { Color = rgb(48, 209, 88), Icon = "check" },
    Warning = { Color = rgb(255, 159, 10), Icon = "alert-triangle" },
    Error = { Color = rgb(255, 69, 58), Icon = "x" },
}

local FONT_ID = "rbxassetid://12187365364" -- Inter, published by Roblox
local Fonts = {
    Regular = Font.new(FONT_ID, Enum.FontWeight.Regular),
    Medium = Font.new(FONT_ID, Enum.FontWeight.Medium),
    SemiBold = Font.new(FONT_ID, Enum.FontWeight.SemiBold),
    Bold = Font.new(FONT_ID, Enum.FontWeight.Bold),
}

local Tweens = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Theme = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

--==============================================================
-- Internal state
--==============================================================

-- Strong keys on purpose: Roblox recreates the Lua wrapper of an Instance
-- that nothing references, so a weak-keyed table silently loses entries
-- for live instances. Entries are removed on Destroying instead.
local Bindings = {}
local Connections = {}
local UnloadCallbacks = {}
local Keybinds = {}
local LanguageListeners = {}
local LanguageCallbacks = {}
local ScaleTargets = {}
local RainbowPickers = {}
local ScreenGui
local NotifyHolder
local NotifyCount = 0
local Watermark
local KeybindPanel
local RefreshKeybindList -- assigned with the keybind list overlay

--==============================================================
-- Helpers
--==============================================================

local ClassDefaults = {
    Frame = { BorderSizePixel = 0 },
    CanvasGroup = { BorderSizePixel = 0 },
    ScrollingFrame = {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageTransparency = 0.3,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarInset = Enum.ScrollBarInset.None,
    },
    TextLabel = {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        FontFace = Fonts.Regular,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    },
    TextButton = {
        BorderSizePixel = 0,
        AutoButtonColor = false,
        FontFace = Fonts.Regular,
        TextSize = 14,
        Text = "",
    },
    TextBox = {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        FontFace = Fonts.Regular,
        TextSize = 14,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    },
    ImageLabel = { BorderSizePixel = 0, BackgroundTransparency = 1 },
    ImageButton = { BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false },
    -- Contextual mode would outline the text of buttons instead of the box.
    UIStroke = { ApplyStrokeMode = Enum.ApplyStrokeMode.Border },
}

local function New(class, props, children)
    local instance = Instance.new(class)
    local defaults = ClassDefaults[class]
    if defaults then
        for key, value in pairs(defaults) do
            instance[key] = value
        end
    end
    local parent
    if props then
        for key, value in pairs(props) do
            if key == "Parent" then
                parent = value
            else
                instance[key] = value
            end
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = instance
        end
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function Corner(radius, parent)
    return New("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end

local function Pad(parent, top, right, bottom, left)
    return New("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        Parent = parent,
    })
end

local function List(parent, padding, direction, props)
    local layout = New("UIListLayout", {
        Padding = UDim.new(0, padding or 0),
        FillDirection = direction or Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = parent,
    })
    if props then
        for key, value in pairs(props) do
            layout[key] = value
        end
    end
    return layout
end

-- Product of every UIScale between `object` and the ScreenGui, used to turn
-- on-screen sizes back into layout pixels.
local function EffectiveScale(object)
    local scale = 1
    local current = object
    while current and current ~= ScreenGui do
        local uiScale = current:FindFirstChildOfClass("UIScale")
        if uiScale then
            scale = scale * uiScale.Scale
        end
        current = current.Parent
    end
    if scale <= 0 then
        return 1
    end
    return scale
end

-- Sizes a wrapped label to its text height in whole pixels. AutomaticSize
-- gives fractional heights (16.94px for 14px Inter), which pushes every
-- row below off the pixel grid; TextBounds cannot be used either because
-- it is clipped to the label's current height.
local function FitText(label)
    local lastKey
    local queued = false
    local function fit()
        queued = false
        if not label.Parent then
            return
        end
        local width = math.floor(label.AbsoluteSize.X / EffectiveScale(label) + 0.5)
        if width <= 0 then
            return
        end
        local key = label.Text .. "|" .. label.TextSize .. "|" .. width
        if key == lastKey then
            return
        end
        lastKey = key
        local params = Instance.new("GetTextBoundsParams")
        params.Text = label.Text
        params.Font = label.FontFace
        params.Size = label.TextSize
        params.Width = width
        local ok, bounds = pcall(function()
            return TextService:GetTextBoundsAsync(params)
        end)
        if ok and bounds and label.Parent then
            local size = label.Size
            label.Size = UDim2.new(size.X.Scale, size.X.Offset, 0, math.ceil(bounds.Y))
        end
    end
    local function queue()
        if not queued then
            queued = true
            task.defer(fit)
        end
    end
    label:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue)
    label:GetPropertyChangedSignal("Text"):Connect(queue)
    label:GetPropertyChangedSignal("TextSize"):Connect(queue)
    label:GetPropertyChangedSignal("FontFace"):Connect(queue)
    queue()
    return label
end

local function Tween(instance, info, goal)
    local tween = TweenService:Create(instance, info, goal)
    tween:Play()
    return tween
end

local function SafeCall(callback, ...)
    if type(callback) ~= "function" then
        return
    end
    local ok, err = pcall(callback, ...)
    if not ok then
        warn("[PaneUI] callback error: " .. tostring(err))
    end
end

local function Spawn(callback, ...)
    if type(callback) == "function" then
        task.spawn(SafeCall, callback, ...)
    end
end

local function Connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Connections, connection)
    return connection
end

--==============================================================
-- Motion: springs and frame-driven animations
--
-- Spring(instance, goals, frequency, damping) moves properties toward
-- their goals like a physical spring, so they overshoot a little and
-- settle the way macOS controls do. Retargeting mid-flight keeps the
-- velocity, so quick repeated clicks feel continuous instead of jerky.
-- A property driven by a spring must not be tweened at the same time.
--==============================================================

local SpringStates = {}
local SpringConnection
local Animations = {}
local AnimationConnection

local function ToArray(value)
    local kind = typeof(value)
    if kind == "number" then
        return { value }
    elseif kind == "UDim2" then
        return { value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset }
    elseif kind == "Vector2" then
        return { value.X, value.Y }
    elseif kind == "UDim" then
        return { value.Scale, value.Offset }
    end
    return nil
end

local function FromArray(kind, a)
    if kind == "number" then
        return a[1]
    elseif kind == "UDim2" then
        return UDim2.new(a[1], a[2], a[3], a[4])
    elseif kind == "Vector2" then
        return Vector2.new(a[1], a[2])
    end
    return UDim.new(a[1], a[2])
end

local StepSprings = function(dt)
    dt = math.min(dt, 0.05)
    local steps = math.max(1, math.ceil(dt * 240))
    local h = dt / steps
    for instance, props in pairs(SpringStates) do
        if instance.Parent == nil then
            SpringStates[instance] = nil
        else
            for property, state in pairs(props) do
                local x, v, t, k, c = state.x, state.v, state.t, state.k, state.c
                for _ = 1, steps do
                    for i = 1, state.n do
                        v[i] = v[i] + (-k * (x[i] - t[i]) - c * v[i]) * h
                        x[i] = x[i] + v[i] * h
                    end
                end
                local settled = true
                for i = 1, state.n do
                    if math.abs(x[i] - t[i]) > 0.001 or math.abs(v[i]) > 0.01 then
                        settled = false
                        break
                    end
                end
                if settled then
                    instance[property] = FromArray(state.kind, t)
                    props[property] = nil
                else
                    instance[property] = FromArray(state.kind, x)
                end
            end
            if next(props) == nil then
                SpringStates[instance] = nil
            end
        end
    end
    if next(SpringStates) == nil and SpringConnection then
        SpringConnection:Disconnect()
        SpringConnection = nil
    end
end

local function StartSprings()
    if not SpringConnection then
        SpringConnection = Connect(RunService.RenderStepped, StepSprings)
    end
end

local function Spring(instance, goals, frequency, damping)
    local omega = 2 * math.pi * (frequency or 4)
    local zeta = damping or 0.8
    local props = SpringStates[instance]
    if not props then
        props = {}
        SpringStates[instance] = props
    end
    for property, goal in pairs(goals) do
        local target = ToArray(goal)
        local state = props[property]
        if not state then
            local velocity = {}
            for i = 1, #target do
                velocity[i] = 0
            end
            state = { kind = typeof(goal), x = ToArray(instance[property]), v = velocity, n = #target }
            props[property] = state
        end
        state.t = target
        state.k = omega * omega
        state.c = 2 * zeta * omega
    end
    StartSprings()
end

-- Gives a property a push without changing where it settles, e.g. a bounce.
local function SpringKick(instance, property, impulse, frequency, damping)
    local props = SpringStates[instance]
    if not (props and props[property]) then
        Spring(instance, { [property] = instance[property] }, frequency, damping)
        props = SpringStates[instance]
    end
    local state = props[property]
    local push = ToArray(impulse)
    for i = 1, state.n do
        state.v[i] = state.v[i] + push[i]
    end
    StartSprings()
end

local function StopSpring(instance, property)
    local props = SpringStates[instance]
    if props then
        props[property] = nil
    end
end

local StepAnimations = function()
    local now = os.clock()
    for animation in pairs(Animations) do
        local alpha = math.min((now - animation.start) / animation.duration, 1)
        local ok = pcall(animation.step, alpha)
        if not ok or alpha >= 1 then
            Animations[animation] = nil
            if ok and animation.done then
                task.spawn(animation.done)
            end
        end
    end
    if next(Animations) == nil and AnimationConnection then
        AnimationConnection:Disconnect()
        AnimationConnection = nil
    end
end

-- Calls step(alpha) every frame for `duration` seconds, alpha going 0..1.
local function Animate(duration, step, done)
    local animation = { start = os.clock(), duration = math.max(duration, 0.001), step = step, done = done }
    Animations[animation] = true
    if not AnimationConnection then
        AnimationConnection = Connect(RunService.RenderStepped, StepAnimations)
    end
    pcall(step, 0)
    return {
        Cancel = function()
            Animations[animation] = nil
        end,
    }
end

local function EaseOutCubic(t)
    return 1 - (1 - t) ^ 3
end

local function EaseInCubic(t)
    return t * t * t
end

local function EaseInOutCubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    end
    return 1 - (-2 * t + 2) ^ 3 / 2
end

-- Rolls a label's number from `from` to `to`, formatted by `format`.
local Counters = {}
local function CountTo(label, from, to, format, duration)
    local previous = Counters[label]
    if previous then
        previous.Cancel()
        Counters[label] = nil
    end
    if from == nil or from == to then
        label.Text = format(to)
        return
    end
    Counters[label] = Animate(duration or 0.35, function(alpha)
        label.Text = format(from + (to - from) * EaseOutCubic(alpha))
    end, function()
        Counters[label] = nil
    end)
end

local function TextWidth(text, size)
    return TextService:GetTextSize(tostring(text), size, Enum.Font.GothamMedium, Vector2.new(10000, 100)).X
end

local function Trim(text)
    return string.match(tostring(text), "^%s*(.-)%s*$")
end

local function Round(value, step)
    if not step or step <= 0 then
        return value
    end
    return math.floor(value / step + 0.5) * step
end

local function StepDecimals(step)
    local text = tostring(step)
    local dot = string.find(text, ".", 1, true)
    if not dot then
        return 0
    end
    return #text - dot
end

local function FormatNumber(value, decimals)
    if decimals <= 0 then
        return tostring(math.floor(value + 0.5))
    end
    return string.format("%." .. decimals .. "f", value)
end

local function ColorToHex(color)
    return string.format("#%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
end

local function HexToColor(hex)
    hex = string.gsub(tostring(hex), "#", "")
    if #hex ~= 6 then
        return nil
    end
    local r = tonumber(string.sub(hex, 1, 2), 16)
    local g = tonumber(string.sub(hex, 3, 4), 16)
    local b = tonumber(string.sub(hex, 5, 6), 16)
    if not (r and g and b) then
        return nil
    end
    return rgb(r, g, b)
end

-- AbsolutePosition inside an IgnoreGuiInset ScreenGui is still measured
-- from below the top bar. This converts it to the ScreenGui's own space,
-- the one Position offsets and GetMouseLocation use.
local function GuiPosition(object)
    local origin = ScreenGui and ScreenGui.AbsolutePosition or Vector2.zero
    return object.AbsolutePosition - origin
end

local function IsClick(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function PointerPosition(input)
    if input and input.UserInputType == Enum.UserInputType.Touch then
        local inset = GuiService:GetGuiInset()
        return Vector2.new(input.Position.X + inset.X, input.Position.Y + inset.Y)
    end
    return UserInputService:GetMouseLocation()
end

-- Calls onMove for every pointer move between press and release on `handle`.
-- onBegin may return false to ignore the press.
local function TrackDrag(handle, onBegin, onMove, onEnd)
    handle.InputBegan:Connect(function(input)
        if not IsClick(input) then
            return
        end
        if onBegin and onBegin(PointerPosition(input), input) == false then
            return
        end
        local isTouch = input.UserInputType == Enum.UserInputType.Touch
        local moveConnection, endConnection
        moveConnection = UserInputService.InputChanged:Connect(function(changed)
            if (isTouch and changed == input) or (not isTouch and changed.UserInputType == Enum.UserInputType.MouseMovement) then
                onMove(PointerPosition(changed))
            end
        end)
        endConnection = UserInputService.InputEnded:Connect(function(ended)
            if ended == input or (not isTouch and ended.UserInputType == Enum.UserInputType.MouseButton1) then
                moveConnection:Disconnect()
                endConnection:Disconnect()
                if onEnd then
                    onEnd()
                end
            end
        end)
    end)
end

local function GetGuiParent()
    if gethui then
        local ok, result = pcall(gethui)
        if ok and result then
            return result
        end
    end
    if pcall(function()
        return CoreGui:GetChildren()
    end) then
        return CoreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function RandomName()
    local guid = string.gsub(HttpService:GenerateGUID(false), "-", "")
    return string.sub(guid, 1, 16)
end

local function GetScreenGui()
    if ScreenGui and ScreenGui.Parent then
        return ScreenGui
    end
    ScreenGui = New("ScreenGui", {
        Name = RandomName(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 10000,
        Parent = GetGuiParent(),
    })
    return ScreenGui
end

local function ResolveIcon(icon)
    if type(icon) ~= "string" or icon == "" then
        return nil
    end
    if Library.Icons[icon] then
        return Library.Icons[icon]
    end
    if string.find(icon, "^rbxasset") or string.find(icon, "^rbxthumb") or string.find(icon, "^http") then
        return icon
    end
    return nil
end

--==============================================================
-- Keys and modifiers
--==============================================================

local KeyNames = {
    LeftShift = "LShift",
    RightShift = "RShift",
    LeftControl = "LCtrl",
    RightControl = "RCtrl",
    LeftAlt = "LAlt",
    RightAlt = "RAlt",
    LeftSuper = "LCmd",
    RightSuper = "RCmd",
    Return = "Enter",
    Backspace = "Bksp",
    CapsLock = "Caps",
    PageUp = "PgUp",
    PageDown = "PgDn",
    Insert = "Ins",
    Delete = "Del",
    Zero = "0",
    One = "1",
    Two = "2",
    Three = "3",
    Four = "4",
    Five = "5",
    Six = "6",
    Seven = "7",
    Eight = "8",
    Nine = "9",
    MouseButton1 = "MB1",
    MouseButton2 = "MB2",
    MouseButton3 = "MB3",
}

local ModifierKeys = {
    [Enum.KeyCode.LeftControl] = "Ctrl",
    [Enum.KeyCode.RightControl] = "Ctrl",
    [Enum.KeyCode.LeftShift] = "Shift",
    [Enum.KeyCode.RightShift] = "Shift",
    [Enum.KeyCode.LeftAlt] = "Alt",
    [Enum.KeyCode.RightAlt] = "Alt",
}

local ModifierOrder = { "Ctrl", "Shift", "Alt" }

local function KeyName(key)
    if not key then
        return Library.Strings.None
    end
    return KeyNames[key.Name] or key.Name
end

local function KeyFromName(name)
    if type(name) ~= "string" then
        return nil
    end
    local ok, key = pcall(function()
        return Enum.KeyCode[name]
    end)
    if ok and key then
        return key
    end
    ok, key = pcall(function()
        return Enum.UserInputType[name]
    end)
    if ok and key then
        return key
    end
    return nil
end

-- Accepts { "Ctrl", "Shift" } or { Ctrl = true } and returns the set form.
local function ModifierSet(value)
    local set = {}
    if type(value) == "table" then
        for key, flag in pairs(value) do
            if type(key) == "number" then
                set[flag] = true
            elseif flag then
                set[key] = true
            end
        end
    end
    return set
end

local function ModifierList(set)
    local list = {}
    for _, name in ipairs(ModifierOrder) do
        if set and set[name] then
            table.insert(list, name)
        end
    end
    return list
end

-- "Ctrl+Shift+F" -> Enum.KeyCode.F, { Ctrl = true, Shift = true }
local function ParseBind(text)
    local modifiers = {}
    local key
    for part in string.gmatch(text, "[^%+]+") do
        part = Trim(part)
        if part == "Ctrl" or part == "Shift" or part == "Alt" then
            modifiers[part] = true
        else
            key = KeyFromName(part)
        end
    end
    return key, modifiers
end

local function BindText(key, modifiers)
    if not key then
        return Library.Strings.None
    end
    local parts = ModifierList(modifiers)
    table.insert(parts, KeyName(key))
    return table.concat(parts, "+")
end

local function HeldModifiers()
    local held = {}
    for key, name in pairs(ModifierKeys) do
        if UserInputService:IsKeyDown(key) then
            held[name] = true
        end
    end
    return held
end

-- A bind without modifiers fires whatever else is held (so sprinting with
-- Shift does not block it); a bind with modifiers needs all of them held.
local function InputMatches(input, key, modifiers)
    if not key then
        return false
    end
    local matched
    if key.EnumType == Enum.KeyCode then
        matched = input.KeyCode == key
    else
        matched = input.UserInputType == key
    end
    if not matched or not modifiers then
        return matched
    end
    local held = HeldModifiers()
    for name, needed in pairs(modifiers) do
        if needed and not held[name] then
            return false
        end
    end
    return true
end

--==============================================================
-- Theme engine
--
-- Bind(instance, { Property = "ThemeKey" | function(theme) }) keeps a
-- property in sync with the active theme. Refresh(instance) re-applies
-- the binding with a tween, which is how stateful controls animate
-- between their states.
--==============================================================

local function BuildTheme()
    local palette = Library.Themes[Library.ThemeName] or Library.Themes.Dark
    local theme = CopyTable(palette)
    theme.Accent = Library.Accent
    Library.Theme = theme
end

BuildTheme()

local function Resolve(value)
    if type(value) == "function" then
        return value(Library.Theme)
    end
    return Library.Theme[value]
end

local function Apply(instance, props, info)
    local goal = {}
    for property, value in pairs(props) do
        goal[property] = Resolve(value)
    end
    if info then
        Tween(instance, info, goal)
    else
        for property, value in pairs(goal) do
            instance[property] = value
        end
    end
end

local function Bind(instance, props)
    local existing = Bindings[instance]
    if existing then
        for property, value in pairs(props) do
            existing[property] = value
        end
    else
        Bindings[instance] = props
        instance.Destroying:Connect(function()
            Bindings[instance] = nil
        end)
    end
    Apply(instance, props)
    return instance
end

local function Refresh(instance, info)
    local props = Bindings[instance]
    if props then
        Apply(instance, props, info or Tweens.Fast)
    end
end

-- Instances outside the game (pages of tabs not opened yet) are updated
-- without a tween; destroyed ones leave Bindings through Destroying.
local function ApplyThemeEverywhere()
    for instance, props in pairs(Bindings) do
        if instance:IsDescendantOf(game) then
            Apply(instance, props, Tweens.Theme)
        else
            Apply(instance, props)
        end
    end
end

--==============================================================
-- Interface scale and language
--==============================================================

-- 1080p and close to it stays at 100%, larger and smaller screens scale.
local function GetAutoScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    local scale = math.min(viewport.X / 1920, viewport.Y / 1080)
    scale = math.floor(scale * 20 + 0.5) / 20
    if scale > 0.9 and scale < 1.1 then
        scale = 1
    end
    return math.clamp(scale, 0.8, 2)
end

local function CurrentScale()
    if type(Library.ScaleSetting) == "number" then
        return Library.ScaleSetting
    end
    return GetAutoScale()
end

-- Registers a UIScale that always follows the interface scale.
local function ScaleTarget(uiScale)
    table.insert(ScaleTargets, uiScale)
    uiScale.Scale = Library.UIScale
    return uiScale
end

local function ApplyScale()
    Library.UIScale = CurrentScale()
    for index = #ScaleTargets, 1, -1 do
        local target = ScaleTargets[index]
        if target.Parent then
            target.Scale = Library.UIScale
        else
            table.remove(ScaleTargets, index)
        end
    end
    for _, window in ipairs(Library.Windows) do
        window:_applyScale()
    end
end

-- Runs `callback` again whenever the language changes, while `object` lives.
local function OnLanguage(object, callback)
    table.insert(LanguageListeners, { Object = object, Callback = callback })
end

--==============================================================
-- Shared visual pieces
--==============================================================

local SHADOW_LAYERS = 8

-- Soft shadow made of stacked rounded frames, each a little larger than the
-- one inside it. Unlike a 9-slice image it follows the corner radius of the
-- thing it sits under, so it is even on every side and at the corners.
-- Layers are packed tighter near the edge, which makes the falloff soft.
-- `boost`, when given, returns a multiplier for the opacity; a window being
-- dragged uses it to look lifted. Call RefreshShadow after it changes.
local function Shadow(parent, spread, radius, zindex, boost)
    local holder = New("Frame", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = zindex or 0,
        Parent = parent,
    })
    for i = 1, SHADOW_LAYERS do
        local grow = math.floor(spread * (i / SHADOW_LAYERS) ^ 1.5 + 0.5)
        local layer = Bind(New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, grow * 2, 1, grow * 2),
            BackgroundColor3 = rgb(0, 0, 0),
            ZIndex = zindex or 0,
            Parent = holder,
        }), {
            -- Per-layer transparency such that all layers together reach ShadowOpacity.
            BackgroundTransparency = function(theme)
                local opacity = theme.ShadowOpacity * (boost and boost() or 1)
                return (1 - math.min(opacity, 0.9)) ^ (1 / SHADOW_LAYERS)
            end,
        })
        Corner(radius + grow, layer)
    end
    return holder
end

local function RefreshShadow(holder, info)
    for _, layer in ipairs(holder:GetChildren()) do
        Refresh(layer, info)
    end
end

local function Bar(parent, props)
    local frame = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = rgb(255, 255, 255),
        Parent = parent,
    })
    for key, value in pairs(props) do
        frame[key] = value
    end
    Corner(2, frame)
    return frame
end

-- Two rotated bars forming a chevron pointing `direction` ("Down", "Up", "Right").
-- `size` is the chevron width; `center` is where the middle of both bars sits.
local function Chevron(parent, center, size, thickness, direction)
    local length = size / 2 * 1.414 + thickness / 2
    local offset = size / 4
    local bars = {}
    local rotations, dx, dy
    if direction == "Up" then
        rotations, dx, dy = { 45, -45 }, offset, 0
    elseif direction == "Right" then
        rotations, dx, dy = { -45, 45 }, 0, offset
    else
        rotations, dx, dy = { -45, 45 }, offset, 0
    end
    for i = 1, 2 do
        local sign = i == 1 and -1 or 1
        bars[i] = Bar(parent, {
            Size = UDim2.fromOffset(thickness, length),
            Position = UDim2.new(center.X.Scale, center.X.Offset + dx * sign, center.Y.Scale, center.Y.Offset + dy * sign),
            Rotation = rotations[i],
        })
    end
    return bars
end

local function Checkmark(parent, position, color)
    local holder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(12, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = position,
        Parent = parent,
    })
    local short = Bar(holder, { Size = UDim2.fromOffset(2, 6), Position = UDim2.fromOffset(3.2, 7), Rotation = -45 })
    local long = Bar(holder, { Size = UDim2.fromOffset(2, 11), Position = UDim2.fromOffset(8.1, 5.2), Rotation = 40 })
    short.BackgroundColor3 = color
    long.BackgroundColor3 = color
    return holder, { short, long }
end

-- Light and dark squares behind colors that can be transparent.
local function Checker(parent, cell, width, height)
    local holder = New("Frame", {
        Name = "Checker",
        BackgroundColor3 = rgb(255, 255, 255),
        Size = UDim2.fromScale(1, 1),
        Parent = parent,
    })
    for x = 0, math.ceil(width / cell) - 1 do
        for y = 0, math.ceil(height / cell) - 1 do
            if (x + y) % 2 == 1 then
                New("Frame", {
                    BackgroundColor3 = rgb(200, 200, 200),
                    Position = UDim2.fromOffset(x * cell, y * cell),
                    Size = UDim2.fromOffset(cell, cell),
                    Parent = holder,
                })
            end
        end
    end
    return holder
end

-- Rounded square app icon: a Lucide icon name, an image id, a one or two
-- character glyph, or else the first letter of `title`.
local function AppIcon(parent, size, icon, color, title, radius)
    local square = New("Frame", {
        Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = color or IconPalette[1],
        Parent = parent,
    })
    Corner(radius or math.floor(size * 0.26), square)
    New("UIGradient", {
        Color = ColorSequence.new(rgb(255, 255, 255), rgb(215, 215, 215)),
        Rotation = 90,
        Parent = square,
    })
    local image = ResolveIcon(icon)
    if image then
        New("ImageLabel", {
            Image = image,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.62, 0.62),
            ImageColor3 = rgb(255, 255, 255),
            Parent = square,
        })
    else
        local glyph = icon
        if type(glyph) ~= "string" or glyph == "" or (utf8.len(glyph) or 99) > 2 then
            glyph = string.upper(string.match(tostring(title or "?"), utf8.charpattern) or "?")
        end
        New("TextLabel", {
            Text = glyph,
            FontFace = Fonts.Bold,
            TextSize = math.floor(size * 0.55),
            TextColor3 = rgb(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.fromScale(1, 1),
            Parent = square,
        })
    end
    return square
end

--==============================================================
-- Global input: keybinds, the window toggle key, Ctrl+F and right-click
--==============================================================

local function TextBoxFocused()
    return UserInputService:GetFocusedTextBox() ~= nil
end

local InputStarted = false
local CameraConnection

local function WatchCamera()
    if CameraConnection then
        CameraConnection:Disconnect()
    end
    local camera = workspace.CurrentCamera
    if camera then
        CameraConnection = Connect(camera:GetPropertyChangedSignal("ViewportSize"), function()
            if Library.ScaleSetting == "Auto" then
                ApplyScale()
            end
        end)
    end
end

local function StartInput()
    if InputStarted then
        return
    end
    InputStarted = true

    Connect(UserInputService.InputBegan, function(input, processed)
        if Library.Unloaded or Library._listening then
            return
        end
        local typing = TextBoxFocused()

        -- Right-click on a row opens its context menu; MB2 keybinds still fire below.
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            local point = UserInputService:GetMouseLocation()
            for _, window in ipairs(Library.Windows) do
                if window.Visible and not window.Minimized then
                    window:_contextAt(point)
                end
            end
        end

        if input.KeyCode == Enum.KeyCode.F and not typing and HeldModifiers().Ctrl then
            for _, window in ipairs(Library.Windows) do
                if window.Visible and not window.Minimized then
                    -- Focus after the key press, or the "f" lands in the field.
                    task.delay(0.05, function()
                        window.SearchBox:CaptureFocus()
                    end)
                    return
                end
            end
        end

        -- Ctrl+K opens the command palette, even while the window is hidden.
        if input.KeyCode == Enum.KeyCode.K and not typing and HeldModifiers().Ctrl then
            local window = Library.Windows[1]
            if window then
                task.delay(0.05, function()
                    window:OpenPalette()
                end)
            end
            return
        end

        if typing then
            return
        end
        if InputMatches(input, Library.ToggleKey) and not processed then
            for _, window in ipairs(Library.Windows) do
                window:Toggle()
            end
            return
        end
        for _, keybind in ipairs(Keybinds) do
            if not keybind.Listening and not keybind.Disabled and InputMatches(input, keybind.Value, keybind.Modifiers) then
                keybind:_press()
            end
        end
    end)

    Connect(UserInputService.InputEnded, function(input)
        if Library.Unloaded then
            return
        end
        for _, keybind in ipairs(Keybinds) do
            if InputMatches(input, keybind.Value) then
                keybind:_release()
            end
        end
    end)

    WatchCamera()
    Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), WatchCamera)
end

--==============================================================
-- Rainbow color pickers
--==============================================================

local RainbowConnection

local function StartRainbow()
    if RainbowConnection then
        return
    end
    RainbowConnection = Connect(RunService.Heartbeat, function()
        local now = os.clock()
        local any = false
        for picker in pairs(RainbowPickers) do
            if picker.Row and picker.Row.Parent then
                any = true
                picker:_rainbowStep(now)
            else
                RainbowPickers[picker] = nil
            end
        end
        if not any then
            RainbowConnection:Disconnect()
            RainbowConnection = nil
        end
    end)
end

--==============================================================
-- Elements
--==============================================================

local Element = {}
Element.__index = Element

local function Extend(base)
    local class = setmetatable({}, { __index = base })
    class.__index = class
    return class
end

function Element:OnChanged(callback)
    table.insert(self.ChangedCallbacks, callback)
    return self
end

function Element:_fire(...)
    Spawn(self.Callback, ...)
    for _, callback in ipairs(self.ChangedCallbacks) do
        Spawn(callback, ...)
    end
end

function Element:SetTitle(text)
    self.Title = text
    if self.TitleLabel then
        self.TitleLabel.Text = text
    end
    if self.Type == "Keybind" then
        RefreshKeybindList()
    end
end

function Element:SetDescription(text)
    self.Description = text
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = text or ""
        self.DescriptionLabel.Visible = text ~= nil and text ~= ""
    end
end

function Element:SetTooltip(text)
    self.Tooltip = text
end

function Element:SetVisible(visible)
    self.Row.Visible = visible
    self.Section:_updateSeparators()
end

-- Greys the row out and blocks clicks on it. Keybinds stop firing too.
function Element:SetDisabled(disabled)
    disabled = disabled == true
    self.Disabled = disabled
    if disabled and not self.Blocker then
        self.Blocker = Bind(New("TextButton", {
            Name = "Disabled",
            BackgroundTransparency = 0.35,
            Size = UDim2.new(1, 20, 1, 14),
            Position = UDim2.fromOffset(-10, -7),
            ZIndex = 30,
            Parent = self.Row,
        }), { BackgroundColor3 = "Group" })
        Corner(7, self.Blocker)
    end
    if self.Blocker then
        self.Blocker.Visible = disabled
    end
end

function Element:Reset()
    if self.DefaultSave ~= nil then
        self:_load(self.DefaultSave)
    end
end

function Element:_unregister()
    if self.Flag and Library.Options[self.Flag] == self then
        Library.Options[self.Flag] = nil
    end
    local index = table.find(Keybinds, self)
    if index then
        table.remove(Keybinds, index)
        RefreshKeybindList()
    end
    if self.Window then
        index = table.find(self.Window.SearchIndex, self)
        if index then
            table.remove(self.Window.SearchIndex, index)
        end
    end
    RainbowPickers[self] = nil
end

function Element:Destroy()
    self:_unregister()
    local index = table.find(self.Section.Elements, self)
    if index then
        table.remove(self.Section.Elements, index)
    end
    self.Row:Destroy()
    self.Section:_updateSeparators()
end

-- Config hooks, overridden by stateful elements.
function Element:_save()
    return self.Value
end

function Element:_load(value)
    if value ~= nil and self.SetValue then
        self:SetValue(value)
    end
end

-- Text that "Copy value" puts on the clipboard.
function Element:_display()
    if self.Value == nil then
        return nil
    end
    return tostring(self.Value)
end

--==============================================================
-- Section
--==============================================================

local Section = {}
Section.__index = Section

local RowOrder = 0

-- Builds a form row: title + description on the left, `controlWidth` px
-- reserved on the right for the control.
function Section:_row(opts, controlWidth, element)
    RowOrder = RowOrder + 1
    local row = New("Frame", {
        Name = "Row",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = RowOrder,
        Parent = self.Group,
    })
    -- Kept so rows can slide in when a tab opens (see Window:_staggerRows).
    element.Padding = Pad(row, 11, 14, 11, 14)

    local separator = Bind(New("Frame", {
        Name = "Separator",
        Size = UDim2.new(1, 14, 0, 1),
        Position = UDim2.fromOffset(0, -11),
        Parent = row,
    }), { BackgroundColor3 = "Separator" })

    local textBlock = New("Frame", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -(controlWidth or 0) - (controlWidth and controlWidth > 0 and 12 or 0), 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = row,
    })
    List(textBlock, 2)

    local title = FitText(Bind(New("TextLabel", {
        Name = "Title",
        Text = opts.Title or "",
        TextSize = 14,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 17),
        LayoutOrder = 1,
        Parent = textBlock,
    }), { TextColor3 = "Text" }))

    local description = FitText(Bind(New("TextLabel", {
        Name = "Description",
        Text = opts.Description or "",
        TextSize = 12,
        TextWrapped = true,
        Visible = opts.Description ~= nil and opts.Description ~= "",
        Size = UDim2.new(1, 0, 0, 15),
        LayoutOrder = 2,
        Parent = textBlock,
    }), { TextColor3 = "SubText" }))

    element.Row = row
    element.Separator = separator
    element.TitleLabel = title
    element.DescriptionLabel = description
    element.TextBlock = textBlock
    element.Section = self
    element.Window = self.Window
    element.Title = opts.Title
    element.Description = opts.Description
    element.Tooltip = opts.Tooltip
    element.Callback = opts.Callback
    element.ChangedCallbacks = {}

    self.Window:_attachTooltip(row, function()
        return element.Tooltip
    end)
    table.insert(self.Window.SearchIndex, element)
    table.insert(self.Elements, element)
    self:_updateSeparators()
    return row
end

function Section:_register(element, opts, kind)
    element.Type = kind
    if opts.Flag then
        element.Flag = opts.Flag
        Library.Options[opts.Flag] = element
    end
    if element.Resettable then
        element.DefaultSave = element:_save()
    end
    if opts.Disabled then
        element:SetDisabled(true)
    end
    return element
end

function Section:_updateSeparators()
    local first = true
    for _, element in ipairs(self.Elements) do
        if element.Row and element.Row.Parent then
            element.Separator.Visible = not first
            if element.Row.Visible then
                first = false
            end
        end
    end
end

function Section:SetVisible(visible)
    self.Holder.Visible = visible
end

function Section:SetCollapsed(collapsed)
    self.Collapsed = collapsed == true
    self.Group.Visible = not self.Collapsed
    if self.ChevronHolder then
        Tween(self.ChevronHolder, Tweens.Normal, { Rotation = self.Collapsed and 0 or 90 })
    end
end

-- Only a section created with a title has a header to rename.
function Section:SetTitle(text)
    self.Title = text
    if self.Header then
        self.Header.Text = text
    end
end

-- Hover highlight inset inside a row, like a macOS list selection.
local function RowHighlight(row)
    local highlight = Bind(New("Frame", {
        Name = "Highlight",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 14),
        Position = UDim2.fromOffset(-10, -7),
        ZIndex = 0,
        Parent = row,
    }), { BackgroundColor3 = "RowHover" })
    Corner(7, highlight)
    return highlight
end

-- Invisible button over the whole row, for rows that act on a click.
local function RowHit(row)
    return New("TextButton", {
        Name = "Hit",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 28, 1, 22),
        Position = UDim2.fromOffset(-14, -11),
        ZIndex = 5,
        Parent = row,
    })
end

-- Push button. style: "Default" | "Primary" | "Destructive"
local function PushButton(parent, text, style, callback)
    local button = New("TextButton", {
        Name = "PushButton",
        Text = text,
        FontFace = Fonts.Medium,
        TextSize = 13,
        Size = UDim2.fromOffset(math.max(56, TextWidth(text, 13) + 22), 24),
        Parent = parent,
    })
    Corner(6, button)
    local stroke = New("UIStroke", { Thickness = 1, Parent = button })
    local hovered = false
    local pressed = false

    local function fill(theme)
        local base
        if style == "Primary" then
            base = theme.Accent
        else
            base = hovered and theme.ControlHover or theme.Control
        end
        if pressed then
            base = base:Lerp(rgb(0, 0, 0), 0.15)
        elseif hovered and style == "Primary" then
            base = base:Lerp(rgb(255, 255, 255), 0.1)
        end
        return base
    end

    Bind(button, {
        BackgroundColor3 = fill,
        TextColor3 = function(theme)
            if style == "Primary" then
                return theme.AccentText
            elseif style == "Destructive" then
                return rgb(255, 69, 58)
            end
            return theme.Text
        end,
    })
    Bind(stroke, {
        Color = function(theme)
            return style == "Primary" and theme.Accent or theme.ControlStroke
        end,
        Transparency = function()
            return style == "Primary" and 1 or 0
        end,
    })

    button.MouseEnter:Connect(function()
        hovered = true
        Refresh(button)
    end)
    button.MouseLeave:Connect(function()
        hovered = false
        pressed = false
        Refresh(button)
    end)
    button.MouseButton1Down:Connect(function()
        pressed = true
        Refresh(button, TweenInfo.new(0.05))
    end)
    button.MouseButton1Up:Connect(function()
        pressed = false
        Refresh(button)
    end)
    button.Activated:Connect(function()
        Spawn(callback)
    end)
    return button
end

-- Field frame with a macOS focus ring, shared by text inputs.
local function FocusRing(parent, props)
    local ring = Bind(New("Frame", {
        Name = "FocusRing",
        BackgroundTransparency = 1,
        Parent = parent,
    }), { BackgroundColor3 = "Accent" })
    for key, value in pairs(props) do
        ring[key] = value
    end
    Corner(9, ring)
    return ring
end

local function WatchFocus(box, ring, stroke)
    box.Focused:Connect(function()
        Tween(ring, Tweens.Fast, { BackgroundTransparency = 0.55 })
        Tween(stroke, Tweens.Fast, { Transparency = 1 })
    end)
    box.FocusLost:Connect(function()
        Tween(ring, Tweens.Fast, { BackgroundTransparency = 1 })
        Tween(stroke, Tweens.Fast, { Transparency = 0 })
    end)
end

--==============================================================
-- Button
--==============================================================

local Button = Extend(Element)

function Section:AddButton(opts)
    opts = opts or {}
    local element = setmetatable({}, Button)
    local buttons = opts.Buttons
    if not buttons and opts.ButtonText then
        buttons = { { Text = opts.ButtonText, Style = opts.Style, Callback = opts.Callback } }
    end

    if buttons then
        -- Row with push buttons on the right.
        local width = 0
        for _, info in ipairs(buttons) do
            width = width + math.max(56, TextWidth(info.Text, 13) + 22) + 8
        end
        local row = self:_row(opts, width - 8, element)
        local holder = New("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(width - 8, 24),
            Parent = row,
        })
        List(holder, 8, Enum.FillDirection.Horizontal, { HorizontalAlignment = Enum.HorizontalAlignment.Right })
        element.Buttons = {}
        -- Kept for the command palette, which lists each action on its own.
        element.Actions = buttons
        for index, info in ipairs(buttons) do
            local push = PushButton(holder, info.Text, info.Style, info.Callback)
            push.LayoutOrder = index
            element.Buttons[index] = push
        end
    else
        -- Whole row is clickable with a chevron on the right.
        local row = self:_row(opts, 16, element)
        local highlight = RowHighlight(row)
        local chevronHolder = New("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Parent = row,
        })
        for _, bar in ipairs(Chevron(chevronHolder, UDim2.fromScale(0.5, 0.5), 9, 2, "Right")) do
            Bind(bar, { BackgroundColor3 = "Tertiary" })
        end
        local hit = RowHit(row)
        hit.MouseEnter:Connect(function()
            Tween(highlight, Tweens.Fast, { BackgroundTransparency = 0 })
        end)
        hit.MouseLeave:Connect(function()
            Tween(highlight, Tweens.Fast, { BackgroundTransparency = 1 })
        end)
        hit.MouseButton1Down:Connect(function()
            Tween(highlight, TweenInfo.new(0.05), { BackgroundTransparency = 0.4 })
        end)
        hit.MouseButton1Up:Connect(function()
            Tween(highlight, Tweens.Fast, { BackgroundTransparency = 0 })
        end)
        hit.Activated:Connect(function()
            element:_fire()
        end)
    end
    self:_register(element, opts, "Button")
    return element
end

--==============================================================
-- Toggle (macOS switch)
--==============================================================

local Toggle = Extend(Element)
local SWITCH_W, SWITCH_H, KNOB = 38, 22, 18

function Section:AddToggle(opts)
    opts = opts or {}
    local element = setmetatable({}, Toggle)
    element.Value = opts.Default == true
    element.Resettable = true
    local row = self:_row(opts, SWITCH_W, element)

    local track = New("Frame", {
        Name = "Switch",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(SWITCH_W, SWITCH_H),
        Parent = row,
    })
    Corner(SWITCH_H, track)
    local knob = New("Frame", {
        Name = "Knob",
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(KNOB, KNOB),
        Parent = track,
    })
    Corner(KNOB, knob)
    local knobStroke = New("UIStroke", { Thickness = 1, Parent = knob })
    Bind(knob, { BackgroundColor3 = "Knob" })
    Bind(knobStroke, { Color = "KnobStroke", Transparency = "KnobStrokeTransparency" })
    Bind(track, {
        BackgroundColor3 = function(theme)
            return element.Value and theme.Accent or theme.SwitchOff
        end,
    })

    -- The knob rides a spring: it overshoots a hair and settles, and it
    -- stretches while pressed, like the macOS switch.
    local pressed = false
    local function layoutKnob(animate)
        local width = pressed and KNOB + 4 or KNOB
        local x = element.Value and (SWITCH_W - 2 - width) or 2
        local goal = { Size = UDim2.fromOffset(width, KNOB), Position = UDim2.new(0, x, 0.5, 0) }
        if animate then
            Spring(knob, goal, 4.5, 0.62)
        else
            knob.Size = goal.Size
            knob.Position = goal.Position
        end
    end
    layoutKnob(false)

    function element:SetValue(value, silent)
        value = value == true
        local changed = value ~= self.Value
        self.Value = value
        layoutKnob(true)
        Refresh(track, Tweens.Normal)
        if changed and not silent then
            self:_fire(value)
        end
    end

    local hit = RowHit(row)
    hit.MouseButton1Down:Connect(function()
        pressed = true
        layoutKnob(true)
    end)
    hit.MouseLeave:Connect(function()
        if pressed then
            pressed = false
            layoutKnob(true)
        end
    end)
    hit.Activated:Connect(function()
        pressed = false
        element:SetValue(not element.Value)
    end)

    self:_register(element, opts, "Toggle")
    return element
end

--==============================================================
-- Checkbox
--==============================================================

local Checkbox = Extend(Element)

function Section:AddCheckbox(opts)
    opts = opts or {}
    local element = setmetatable({}, Checkbox)
    element.Value = opts.Default == true
    element.Resettable = true
    local row = self:_row(opts, 0, element)
    -- The box sits left of the text, as in macOS forms.
    element.TextBlock.Position = UDim2.fromOffset(26, 0)
    element.TextBlock.Size = UDim2.new(1, -26, 0, 0)

    local box = New("Frame", {
        Name = "Checkbox",
        Position = UDim2.fromOffset(0, -1),
        Size = UDim2.fromOffset(16, 16),
        Parent = row,
    })
    Corner(4, box)
    local stroke = New("UIStroke", { Parent = box })
    Bind(box, {
        BackgroundColor3 = function(theme)
            return element.Value and theme.Accent or theme.Field
        end,
    })
    Bind(stroke, {
        Color = function(theme)
            return element.Value and theme.Accent or theme.FieldStroke
        end,
    })
    local check = Checkmark(box, UDim2.fromScale(0.5, 0.5), rgb(255, 255, 255))
    local checkScale = New("UIScale", { Parent = check })
    check.Visible = element.Value

    function element:SetValue(value, silent)
        value = value == true
        local changed = value ~= self.Value
        self.Value = value
        check.Visible = value
        if value then
            checkScale.Scale = 0.4
            Spring(checkScale, { Scale = 1 }, 5, 0.45)
        end
        Refresh(box)
        Refresh(stroke)
        if changed and not silent then
            self:_fire(value)
        end
    end

    RowHit(row).Activated:Connect(function()
        element:SetValue(not element.Value)
    end)

    self:_register(element, opts, "Checkbox")
    return element
end

--==============================================================
-- Radio group
--==============================================================

local Radio = Extend(Element)

function Section:AddRadio(opts)
    opts = opts or {}
    local element = setmetatable({}, Radio)
    element.Values = opts.Values or {}
    element.Value = opts.Default or element.Values[1]
    element.Resettable = true
    self:_row(opts, 0, element)

    local list = New("Frame", {
        Name = "Options",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 3,
        Parent = element.TextBlock,
    })
    Pad(list, 6, 0, 0, 0)
    List(list, 6)

    local circles = {}
    for index, value in ipairs(element.Values) do
        local option = New("TextButton", {
            Name = tostring(value),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            LayoutOrder = index,
            Parent = list,
        })
        local circle = New("Frame", { Position = UDim2.fromOffset(0, 1), Size = UDim2.fromOffset(16, 16), Parent = option })
        Corner(8, circle)
        local stroke = New("UIStroke", { Parent = circle })
        Bind(circle, {
            BackgroundColor3 = function(theme)
                return element.Value == value and theme.Accent or theme.Field
            end,
        })
        Bind(stroke, {
            Color = function(theme)
                return element.Value == value and theme.Accent or theme.FieldStroke
            end,
        })
        local dot = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(6, 6),
            BackgroundColor3 = rgb(255, 255, 255),
            Visible = element.Value == value,
            Parent = circle,
        })
        Corner(3, dot)
        Bind(New("TextLabel", {
            Text = tostring(value),
            TextSize = 13,
            Position = UDim2.fromOffset(24, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Parent = option,
        }), { TextColor3 = "Text" })
        circles[value] = { Circle = circle, Stroke = stroke, Dot = dot }
        option.Activated:Connect(function()
            element:SetValue(value)
        end)
    end

    function element:SetValue(value, silent)
        local changed = value ~= self.Value
        self.Value = value
        for key, parts in pairs(circles) do
            parts.Dot.Visible = key == value
            if key == value and changed then
                -- The dot pops in from nothing.
                parts.Dot.Size = UDim2.fromOffset(0, 0)
                Spring(parts.Dot, { Size = UDim2.fromOffset(6, 6) }, 5, 0.45)
            end
            Refresh(parts.Circle)
            Refresh(parts.Stroke)
        end
        if changed and not silent then
            self:_fire(value)
        end
    end

    self:_register(element, opts, "Radio")
    return element
end

--==============================================================
-- Slider
--==============================================================

local Slider = Extend(Element)

function Section:AddSlider(opts)
    opts = opts or {}
    local element = setmetatable({}, Slider)
    element.Min = opts.Min or 0
    element.Max = opts.Max or 100
    element.Step = opts.Step or 1
    element.Suffix = opts.Suffix or ""
    element.Decimals = StepDecimals(element.Step)
    element.Value = math.clamp(opts.Default or element.Min, element.Min, element.Max)
    element.Resettable = true

    local row = self:_row(opts, 90, element)
    local valueBox = Bind(New("TextBox", {
        Name = "Value",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(90, 18),
        TextSize = 13,
        FontFace = Fonts.Medium,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    }), { TextColor3 = "SubText" })

    local bar = New("Frame", {
        Name = "Slider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        LayoutOrder = 3,
        Parent = element.TextBlock,
    })
    -- The slider spans the whole row, not just the text column.
    element.TextBlock.Size = UDim2.new(1, 0, 0, 0)
    element.TitleLabel.Size = UDim2.new(1, -96, 0, element.TitleLabel.Size.Y.Offset)

    local track = Bind(New("Frame", {
        Name = "Track",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 2),
        Size = UDim2.new(1, 0, 0, 4),
        Parent = bar,
    }), { BackgroundColor3 = "Track" })
    Corner(2, track)
    local fill = Bind(New("Frame", { Name = "Fill", Size = UDim2.fromScale(0, 1), Parent = track }), { BackgroundColor3 = "Accent" })
    Corner(2, fill)
    local knob = Bind(New("Frame", {
        Name = "Knob",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(18, 18),
        ZIndex = 2,
        Parent = track,
    }), { BackgroundColor3 = "Knob" })
    Corner(9, knob)
    Bind(New("UIStroke", { Thickness = 1, Parent = knob }), { Color = "KnobStroke", Transparency = "KnobStrokeTransparency" })

    local dragging = false
    local function format(value)
        return FormatNumber(Round(value, element.Step), element.Decimals) .. element.Suffix
    end

    -- The knob center travels from 9px to width - 9px so it never leaves the track.
    -- Clicks and code move it on a soft spring and roll the number; while
    -- dragging, a stiff spring keeps it glued to the pointer.
    local function render(animate, from)
        local alpha = 0
        if element.Max > element.Min then
            alpha = (element.Value - element.Min) / (element.Max - element.Min)
        end
        local offset = 9 - 18 * alpha
        local fillSize = UDim2.new(alpha, offset, 1, 0)
        local knobPosition = UDim2.new(alpha, offset, 0.5, 0)
        if animate then
            local frequency = dragging and 14 or 6
            Spring(fill, { Size = fillSize }, frequency, 1)
            Spring(knob, { Position = knobPosition }, frequency, dragging and 1 or 0.75)
        else
            StopSpring(fill, "Size")
            StopSpring(knob, "Position")
            fill.Size = fillSize
            knob.Position = knobPosition
        end
        if valueBox:IsFocused() then
            return
        end
        if animate and not dragging then
            CountTo(valueBox, from, element.Value, format)
        else
            CountTo(valueBox, nil, element.Value, format)
        end
    end

    function element:SetValue(value, silent)
        value = tonumber(value)
        if not value then
            render(false)
            return
        end
        value = math.clamp(Round(value, self.Step), self.Min, self.Max)
        local previous = self.Value
        local changed = value ~= previous
        self.Value = value
        render(true, previous)
        if changed and not silent then
            self:_fire(value)
        end
    end

    function element:SetRange(min, max)
        self.Min = min
        self.Max = max
        self:SetValue(math.clamp(self.Value, min, max))
        render(false)
    end

    function element:_display()
        return FormatNumber(self.Value, self.Decimals) .. self.Suffix
    end

    local setFromPointer = function(position)
        local scale = EffectiveScale(track)
        local alpha = math.clamp((position.X - GuiPosition(track).X - 9 * scale) / math.max(track.AbsoluteSize.X - 18 * scale, 1), 0, 1)
        element:SetValue(element.Min + (element.Max - element.Min) * alpha)
    end

    local hit = New("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 16, 1, 8),
        Position = UDim2.fromOffset(-8, -4),
        ZIndex = 5,
        Parent = bar,
    })
    TrackDrag(hit, function(position)
        dragging = true
        Spring(knob, { Size = UDim2.fromOffset(21, 21) }, 6, 0.55)
        setFromPointer(position)
    end, setFromPointer, function()
        dragging = false
        Spring(knob, { Size = UDim2.fromOffset(18, 18) }, 6, 0.55)
    end)

    valueBox.Focused:Connect(function()
        CountTo(valueBox, nil, element.Value, format)
        valueBox.Text = FormatNumber(element.Value, element.Decimals)
    end)
    valueBox.FocusLost:Connect(function()
        element:SetValue(valueBox.Text)
        render(false)
    end)

    render(false)
    self:_register(element, opts, "Slider")
    return element
end

--==============================================================
-- Stepper (- value +)
--==============================================================

local Stepper = Extend(Element)

function Section:AddStepper(opts)
    opts = opts or {}
    local element = setmetatable({}, Stepper)
    element.Min = opts.Min or 0
    element.Max = opts.Max or 100
    element.Step = opts.Step or 1
    element.Suffix = opts.Suffix or ""
    element.Decimals = StepDecimals(element.Step)
    element.Value = math.clamp(opts.Default or element.Min, element.Min, element.Max)
    element.Resettable = true
    local width = opts.Width or 112
    local row = self:_row(opts, width, element)

    local box = Bind(New("Frame", {
        Name = "Stepper",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(width, 24),
        Parent = row,
    }), { BackgroundColor3 = "Control" })
    Corner(6, box)
    Bind(New("UIStroke", { Parent = box }), { Color = "ControlStroke" })
    local valueBox = Bind(New("TextBox", {
        Position = UDim2.fromOffset(26, 0),
        Size = UDim2.new(1, -52, 1, 0),
        TextSize = 13,
        FontFace = Fonts.Medium,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = box,
    }), { TextColor3 = "Text" })
    Bind(New("Frame", { Position = UDim2.fromOffset(26, 4), Size = UDim2.fromOffset(1, 16), Parent = box }), { BackgroundColor3 = "ControlStroke" })
    Bind(New("Frame", { Position = UDim2.new(1, -27, 0, 4), Size = UDim2.fromOffset(1, 16), Parent = box }), { BackgroundColor3 = "ControlStroke" })

    local function format(value)
        return FormatNumber(Round(value, element.Step), element.Decimals) .. element.Suffix
    end

    -- The number rolls to its new value unless the field is being edited.
    local function render(from)
        if valueBox:IsFocused() then
            return
        end
        CountTo(valueBox, from, element.Value, format, 0.2)
    end

    function element:SetValue(value, silent)
        value = tonumber(value)
        if not value then
            render()
            return
        end
        value = math.clamp(Round(value, self.Step), self.Min, self.Max)
        local previous = self.Value
        local changed = value ~= previous
        self.Value = value
        render(previous)
        if changed and not silent then
            self:_fire(value)
        end
    end

    function element:_display()
        return FormatNumber(self.Value, self.Decimals) .. self.Suffix
    end

    -- Press steps once; holding keeps stepping, like macOS steppers.
    local function makeButton(direction)
        local button = New("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(26, 24),
            Position = direction < 0 and UDim2.fromOffset(0, 0) or UDim2.new(1, -26, 0, 0),
            Parent = box,
        })
        Corner(6, button)
        Bind(button, { BackgroundColor3 = "ControlHover" })
        Bind(Bar(button, { Size = UDim2.fromOffset(8, 2), Position = UDim2.fromScale(0.5, 0.5) }), { BackgroundColor3 = "Text" })
        if direction > 0 then
            Bind(Bar(button, { Size = UDim2.fromOffset(2, 8), Position = UDim2.fromScale(0.5, 0.5) }), { BackgroundColor3 = "Text" })
        end
        local holding = 0
        button.MouseEnter:Connect(function()
            button.BackgroundTransparency = 0
        end)
        button.MouseLeave:Connect(function()
            button.BackgroundTransparency = 1
            holding = holding + 1
        end)
        button.MouseButton1Down:Connect(function()
            if element.Disabled then
                return
            end
            holding = holding + 1
            local token = holding
            element:SetValue(element.Value + direction * element.Step)
            task.delay(0.35, function()
                while token == holding and button.Parent and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    element:SetValue(element.Value + direction * element.Step)
                    task.wait(0.06)
                end
            end)
        end)
        button.MouseButton1Up:Connect(function()
            holding = holding + 1
        end)
    end
    makeButton(-1)
    makeButton(1)

    valueBox.Focused:Connect(function()
        CountTo(valueBox, nil, element.Value, format)
        valueBox.Text = FormatNumber(element.Value, element.Decimals)
    end)
    valueBox.FocusLost:Connect(function()
        element:SetValue(valueBox.Text)
        render()
    end)

    render()
    self:_register(element, opts, "Stepper")
    return element
end

--==============================================================
-- Dropdown (macOS pop-up button + menu)
--==============================================================

local Dropdown = Extend(Element)

function Section:AddDropdown(opts)
    opts = opts or {}
    local element = setmetatable({}, Dropdown)
    local window = self.Window
    element.Values = opts.Values or {}
    element.Multi = opts.Multi == true
    element.AllowNone = opts.AllowNone == true or element.Multi
    element.Resettable = true
    local itemText = opts.ItemText or tostring
    local itemIcon = opts.ItemIcon

    if element.Multi then
        element.Value = {}
        if type(opts.Default) == "table" then
            for _, value in ipairs(opts.Default) do
                element.Value[value] = true
            end
        end
    else
        element.Value = opts.Default
        if element.Value == nil and not element.AllowNone then
            element.Value = element.Values[1]
        end
    end

    local maxWidth = opts.Width or 200
    local row = self:_row(opts, maxWidth, element)
    local button = Bind(New("TextButton", {
        Name = "PopUp",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(120, 24),
        Parent = row,
    }), { BackgroundColor3 = "Control" })
    Corner(6, button)
    Bind(New("UIStroke", { Parent = button }), { Color = "ControlStroke" })
    local label = Bind(New("TextLabel", {
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(9, 0),
        Size = UDim2.new(1, -36, 1, 0),
        Parent = button,
    }), { TextColor3 = "Text" })
    local arrows = Bind(New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -4, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        Parent = button,
    }), { BackgroundColor3 = "Accent" })
    Corner(4, arrows)
    Chevron(arrows, UDim2.new(0.5, 0, 0.5, -2.5), 5, 1.5, "Up")
    Chevron(arrows, UDim2.new(0.5, 0, 0.5, 2.5), 5, 1.5, "Down")

    local function displayText()
        if element.Multi then
            local selected = {}
            for _, value in ipairs(element.Values) do
                if element.Value[value] then
                    table.insert(selected, itemText(value))
                end
            end
            if #selected == 0 then
                return Library.Strings.None
            end
            return table.concat(selected, ", ")
        end
        if element.Value == nil then
            return Library.Strings.None
        end
        return itemText(element.Value)
    end

    local function render()
        local text = displayText()
        label.Text = text
        local width = math.clamp(TextWidth(text, 13) + 40, 90, maxWidth)
        Tween(button, Tweens.Fast, { Size = UDim2.fromOffset(width, 24) })
    end
    OnLanguage(row, render)

    function element:SetValue(value, silent)
        if self.Multi then
            local set = {}
            if type(value) == "table" then
                for key, flag in pairs(value) do
                    if type(key) == "number" then
                        set[flag] = true
                    elseif flag then
                        set[key] = true
                    end
                end
            end
            self.Value = set
        else
            self.Value = value
        end
        render()
        if not silent then
            self:_fire(self.Value)
        end
    end

    function element:SetValues(values)
        self.Values = values or {}
        if self.Multi then
            local valid = {}
            for _, value in ipairs(self.Values) do
                if self.Value[value] then
                    valid[value] = true
                end
            end
            self.Value = valid
        elseif self.Value ~= nil and not table.find(self.Values, self.Value) then
            self.Value = (not self.AllowNone) and self.Values[1] or nil
        end
        render()
    end

    function element:_save()
        if self.Multi then
            local list = {}
            for value, flag in pairs(self.Value) do
                if flag then
                    table.insert(list, value)
                end
            end
            return list
        end
        return self.Value
    end

    function element:_load(value)
        self:SetValue(value)
    end

    function element:_display()
        if self.Multi or self.Value ~= nil then
            return displayText()
        end
        return nil
    end

    local function openMenu()
        if element.Disabled then
            return
        end
        local items = {}
        local search
        local count = #element.Values
        local itemHeight = 24
        local searchable = opts.Searchable or count > 8
        local visible = math.max(math.min(count, 10), 1)
        local height = visible * itemHeight + 10 + (searchable and 32 or 0)
        local width = math.max(button.AbsoluteSize.X / EffectiveScale(button) + 16, itemIcon and 220 or 170)
        local textX = itemIcon and 48 or 24

        local menu = window:_popup(button, width, height)
        if searchable then
            local field = Bind(New("Frame", {
                Size = UDim2.new(1, -10, 0, 24),
                Position = UDim2.fromOffset(5, 5),
                Parent = menu,
            }), { BackgroundColor3 = "Field" })
            Corner(6, field)
            Bind(New("UIStroke", { Parent = field }), { Color = "FieldStroke" })
            search = Bind(New("TextBox", {
                PlaceholderText = Library.Strings.Search,
                Text = "",
                TextSize = 13,
                Position = UDim2.fromOffset(8, 0),
                Size = UDim2.new(1, -16, 1, 0),
                Parent = field,
            }), { TextColor3 = "Text", PlaceholderColor3 = "Tertiary" })
        end
        local content = Bind(New("ScrollingFrame", {
            Position = UDim2.fromOffset(5, searchable and 34 or 5),
            Size = UDim2.new(1, -10, 1, searchable and -39 or -10),
            ScrollBarThickness = 2,
            Parent = menu,
        }), { ScrollBarImageColor3 = "Scrollbar" })
        List(content, 0)

        local function isSelected(value)
            if element.Multi then
                return element.Value[value] == true
            end
            return element.Value == value
        end

        for index, value in ipairs(element.Values) do
            local item = New("TextButton", {
                Name = tostring(value),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, itemHeight),
                LayoutOrder = index,
                Parent = content,
            })
            Corner(5, item)
            Bind(item, { BackgroundColor3 = "Accent" })
            if itemIcon then
                local image = New("ImageLabel", {
                    Image = itemIcon(value) or "",
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Library.Theme.SidebarHover,
                    Position = UDim2.new(0, 22, 0.5, -9),
                    Size = UDim2.fromOffset(18, 18),
                    Parent = item,
                })
                Corner(9, image)
            end
            local text = New("TextLabel", {
                Text = itemText(value),
                TextSize = 13,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.fromOffset(textX, 0),
                Size = UDim2.new(1, -textX - 6, 1, 0),
                Parent = item,
            })
            local check, checkBars = Checkmark(item, UDim2.new(0, 12, 0.5, 0), rgb(255, 255, 255))
            local function paint(hover)
                check.Visible = isSelected(value)
                for _, piece in ipairs(checkBars) do
                    piece.BackgroundColor3 = hover and Library.Theme.AccentText or Library.Theme.Text
                end
                text.TextColor3 = hover and Library.Theme.AccentText or Library.Theme.Text
                item.BackgroundTransparency = hover and 0 or 1
            end
            paint(false)
            item.MouseEnter:Connect(function()
                paint(true)
            end)
            item.MouseLeave:Connect(function()
                paint(false)
            end)
            item.Activated:Connect(function()
                if element.Multi then
                    local set = CopyTable(element.Value)
                    if set[value] then
                        set[value] = nil
                    else
                        set[value] = true
                    end
                    element:SetValue(set)
                    for _, entry in ipairs(items) do
                        entry.paint(entry.button == item)
                    end
                else
                    if element.Value == value and element.AllowNone then
                        element:SetValue(nil)
                    else
                        element:SetValue(value)
                    end
                    window:_closePopup()
                end
            end)
            table.insert(items, { button = item, value = value, paint = paint })
        end

        if search then
            search:GetPropertyChangedSignal("Text"):Connect(function()
                local query = string.lower(search.Text)
                for _, entry in ipairs(items) do
                    local haystack = string.lower(tostring(entry.value) .. " " .. itemText(entry.value))
                    entry.button.Visible = query == "" or string.find(haystack, query, 1, true) ~= nil
                end
            end)
            task.defer(function()
                if search.Parent then
                    search:CaptureFocus()
                end
            end)
        end
    end

    button.Activated:Connect(openMenu)
    render()
    self:_register(element, opts, "Dropdown")
    return element
end

-- Dropdown of the players in the server, with avatars, kept up to date.
function Section:AddPlayerDropdown(opts)
    opts = opts or {}
    local excludeSelf = opts.ExcludeLocalPlayer ~= false
    local function names()
        local list = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if not (excludeSelf and player == LocalPlayer) then
                table.insert(list, player.Name)
            end
        end
        table.sort(list, function(a, b)
            return string.lower(a) < string.lower(b)
        end)
        return list
    end

    local config = CopyTable(opts)
    config.Values = names()
    if config.AllowNone == nil then
        config.AllowNone = true
    end
    config.ItemText = function(name)
        local player = Players:FindFirstChild(name)
        if player and player.DisplayName ~= player.Name then
            return player.DisplayName .. " (@" .. name .. ")"
        end
        return tostring(name)
    end
    config.ItemIcon = function(name)
        local player = Players:FindFirstChild(name)
        if player then
            return "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=48&h=48"
        end
        return nil
    end

    local element = self:AddDropdown(config)
    element.Type = "PlayerDropdown"
    -- Player lists depend on the server, so they are not reset or saved by default.
    element.Resettable = false
    element.DefaultSave = nil

    local function refresh()
        if element.Row.Parent then
            element:SetValues(names())
        end
    end
    Connect(Players.PlayerAdded, refresh)
    Connect(Players.PlayerRemoving, function()
        task.defer(refresh)
    end)

    function element:GetPlayer()
        if self.Multi then
            local list = {}
            for name, flag in pairs(self.Value) do
                local player = flag and Players:FindFirstChild(name)
                if player then
                    table.insert(list, player)
                end
            end
            return list
        end
        return self.Value and Players:FindFirstChild(self.Value) or nil
    end

    return element
end

--==============================================================
-- Input (text field) and text area
--==============================================================

local Input = Extend(Element)

function Section:AddInput(opts)
    opts = opts or {}
    local element = setmetatable({}, Input)
    element.Value = tostring(opts.Default or "")
    element.Numeric = opts.Numeric == true
    element.Resettable = true
    local width = opts.Width or 170
    local row = self:_row(opts, width, element)

    local ring = FocusRing(row, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 3, 0.5, 0),
        Size = UDim2.fromOffset(width + 6, 30),
    })
    local field = Bind(New("Frame", {
        Name = "Field",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(width, 24),
        Parent = row,
    }), { BackgroundColor3 = "Field" })
    Corner(6, field)
    local stroke = Bind(New("UIStroke", { Parent = field }), { Color = "FieldStroke" })
    local box = Bind(New("TextBox", {
        Text = element.Value,
        PlaceholderText = opts.Placeholder or "",
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(8, 0),
        Size = UDim2.new(1, -16, 1, 0),
        Parent = field,
    }), { TextColor3 = "Text", PlaceholderColor3 = "Tertiary" })
    element.Box = box

    local function commit()
        local text = box.Text
        if element.Numeric then
            local number = tonumber(text)
            if not number and text ~= "" then
                box.Text = element.Value
                return
            end
        end
        if opts.MaxLength and #text > opts.MaxLength then
            text = string.sub(text, 1, opts.MaxLength)
            box.Text = text
        end
        if text ~= element.Value then
            element.Value = text
            element:_fire(text)
        end
    end

    WatchFocus(box, ring, stroke)
    box.FocusLost:Connect(function(enterPressed)
        if opts.Finished ~= false or enterPressed then
            commit()
        end
    end)
    if opts.Finished == false then
        box:GetPropertyChangedSignal("Text"):Connect(commit)
    end

    function element:SetValue(value, silent)
        value = tostring(value or "")
        box.Text = value
        local changed = value ~= self.Value
        self.Value = value
        if changed and not silent then
            self:_fire(value)
        end
    end

    self:_register(element, opts, "Input")
    return element
end

local TextArea = Extend(Element)

function Section:AddTextArea(opts)
    opts = opts or {}
    local element = setmetatable({}, TextArea)
    element.Value = tostring(opts.Default or "")
    element.Resettable = true
    local height = opts.Height or 80
    self:_row(opts, 0, element)

    local holder = New("Frame", {
        Name = "Area",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, height + 8),
        LayoutOrder = 3,
        Parent = element.TextBlock,
    })
    local ring = FocusRing(holder, {
        Position = UDim2.fromOffset(-3, 5),
        Size = UDim2.new(1, 6, 0, height + 6),
    })
    local field = Bind(New("Frame", {
        Position = UDim2.fromOffset(0, 8),
        Size = UDim2.new(1, 0, 0, height),
        ClipsDescendants = true,
        Parent = holder,
    }), { BackgroundColor3 = "Field" })
    Corner(6, field)
    local stroke = Bind(New("UIStroke", { Parent = field }), { Color = "FieldStroke" })
    local box = Bind(New("TextBox", {
        Text = element.Value,
        PlaceholderText = opts.Placeholder or "",
        TextSize = 13,
        MultiLine = true,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        Position = UDim2.fromOffset(8, 6),
        Size = UDim2.new(1, -16, 1, -12),
        Parent = field,
    }), { TextColor3 = "Text", PlaceholderColor3 = "Tertiary" })
    element.Box = box

    local function commit()
        if box.Text ~= element.Value then
            element.Value = box.Text
            element:_fire(element.Value)
        end
    end
    WatchFocus(box, ring, stroke)
    -- Enter adds a line here, so the value is committed when focus leaves.
    box.FocusLost:Connect(commit)
    if opts.Finished == false then
        box:GetPropertyChangedSignal("Text"):Connect(commit)
    end

    function element:SetValue(value, silent)
        value = tostring(value or "")
        box.Text = value
        local changed = value ~= self.Value
        self.Value = value
        if changed and not silent then
            self:_fire(value)
        end
    end

    self:_register(element, opts, "TextArea")
    return element
end

--==============================================================
-- Keybind
--==============================================================

local Keybind = Extend(Element)

local function ReadBind(value, modifiers)
    if type(value) == "string" then
        if string.find(value, "+", 1, true) then
            return ParseBind(value)
        end
        return KeyFromName(value), ModifierSet(modifiers)
    end
    return value, ModifierSet(modifiers)
end

function Section:AddKeybind(opts)
    opts = opts or {}
    local element = setmetatable({}, Keybind)
    element.Value, element.Modifiers = ReadBind(opts.Default, opts.Modifiers)
    element.Mode = opts.Mode or "Toggle" -- "Toggle" | "Hold" | "Always"
    element.State = element.Mode == "Always"
    element.Listening = false
    element.AllowModifiers = opts.AllowModifiers ~= false
    element.Internal = opts._internal == true
    element.ChangedKeyCallback = opts.ChangedCallback
    element.Resettable = true

    local row = self:_row(opts, 120, element)
    local cap = Bind(New("TextButton", {
        Name = "KeyCap",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(56, 24),
        FontFace = Fonts.Medium,
        TextSize = 12,
        Parent = row,
    }), {
        BackgroundColor3 = "Control",
        TextColor3 = function(theme)
            return element.Listening and theme.Accent or theme.Text
        end,
    })
    Corner(6, cap)
    local capStroke = Bind(New("UIStroke", { Parent = cap }), {
        Color = function(theme)
            return element.Listening and theme.Accent or theme.ControlStroke
        end,
    })

    local function render(held)
        local text
        if element.Listening then
            local parts = ModifierList(held)
            if #parts > 0 then
                text = table.concat(parts, "+") .. "+..."
            else
                text = Library.Strings.PressKey
            end
        else
            text = BindText(element.Value, element.Modifiers)
        end
        cap.Text = text
        Tween(cap, Tweens.Fast, { Size = UDim2.fromOffset(math.max(56, TextWidth(text, 12) + 20), 24) })
        Refresh(cap)
        Refresh(capStroke)
    end
    OnLanguage(row, function()
        render()
    end)

    -- SetValue(key [, modifiers] [, silent]); key may be an Enum, "F" or "Ctrl+F".
    function element:SetValue(key, modifiers, silent)
        if type(modifiers) == "boolean" then
            silent = modifiers
            modifiers = nil
        end
        self.Value, self.Modifiers = ReadBind(key, modifiers)
        render()
        RefreshKeybindList()
        if not silent then
            Spawn(self.ChangedKeyCallback, self.Value, self.Modifiers)
        end
    end

    function element:GetState()
        return self.State
    end

    function element:_press()
        if self.Mode == "Toggle" then
            self.State = not self.State
            self:_fire(self.State)
        elseif self.Mode == "Hold" then
            self.State = true
            self:_fire(true)
        else
            self:_fire(true)
        end
        RefreshKeybindList()
    end

    function element:_release()
        if self.Mode == "Hold" and self.State then
            self.State = false
            self:_fire(false)
            RefreshKeybindList()
        end
    end

    function element:_save()
        return {
            Key = self.Value and self.Value.Name or nil,
            Mode = self.Mode,
            Modifiers = ModifierList(self.Modifiers),
        }
    end

    function element:_load(data)
        if type(data) == "table" then
            if data.Mode then
                self.Mode = data.Mode
                self.State = self.Mode == "Always"
            end
            self:SetValue(data.Key and KeyFromName(data.Key) or nil, data.Modifiers)
        end
    end

    function element:_display()
        return BindText(self.Value, self.Modifiers)
    end

    -- Binding: modifiers held before the key become part of the bind; a
    -- modifier pressed and released alone becomes the bind itself.
    -- Escape keeps the old bind, Backspace clears it, a left click cancels.
    cap.Activated:Connect(function()
        if element.Listening or element.Disabled then
            return
        end
        element.Listening = true
        Library._listening = true
        local held = {}
        local done = false
        local began, ended
        render(held)

        local function finish(key, modifiers)
            if done then
                return
            end
            done = true
            began:Disconnect()
            ended:Disconnect()
            -- Let this key press finish before the bind can fire.
            task.wait()
            element.Listening = false
            Library._listening = false
            element:SetValue(key, modifiers)
        end

        task.defer(function()
            began = UserInputService.InputBegan:Connect(function(input)
                local inputType = input.UserInputType
                if inputType == Enum.UserInputType.Keyboard then
                    local code = input.KeyCode
                    if element.AllowModifiers and ModifierKeys[code] then
                        held[ModifierKeys[code]] = true
                        render(held)
                    elseif code == Enum.KeyCode.Escape then
                        finish(element.Value, element.Modifiers)
                    elseif code == Enum.KeyCode.Backspace then
                        finish(nil, {})
                    else
                        finish(code, held)
                    end
                elseif inputType == Enum.UserInputType.MouseButton2 or inputType == Enum.UserInputType.MouseButton3 then
                    finish(inputType, held)
                elseif inputType == Enum.UserInputType.MouseButton1 then
                    finish(element.Value, element.Modifiers)
                end
            end)
            ended = UserInputService.InputEnded:Connect(function(input)
                local name = ModifierKeys[input.KeyCode]
                if name and held[name] then
                    finish(input.KeyCode, {})
                end
            end)
        end)
    end)

    render()
    table.insert(Keybinds, element)
    StartInput()
    self:_register(element, opts, "Keybind")
    RefreshKeybindList()
    return element
end

--==============================================================
-- Color picker
--==============================================================

local ColorPicker = Extend(Element)

function Section:AddColorPicker(opts)
    opts = opts or {}
    local element = setmetatable({}, ColorPicker)
    local window = self.Window
    element.Value = opts.Default or rgb(255, 255, 255)
    element.Transparency = opts.Transparency
    element.RainbowSpeed = opts.RainbowSpeed or 0.25
    element.Rainbow = false
    element.Resettable = true
    local hasAlpha = element.Transparency ~= nil
    local row = self:_row(opts, 44, element)

    local swatch = Bind(New("TextButton", {
        Name = "Swatch",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(44, 24),
        Parent = row,
    }), { BackgroundColor3 = "Control" })
    Corner(6, swatch)
    Bind(New("UIStroke", { Parent = swatch }), { Color = "ControlStroke" })
    -- A CanvasGroup clips the checkerboard to the rounded corners.
    local inner = New("CanvasGroup", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -8, 1, -8),
        BackgroundTransparency = 1,
        Parent = swatch,
    })
    Corner(3, inner)
    if hasAlpha then
        Checker(inner, 4, 36, 16)
    end
    local swatchColor = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = element.Value,
        BackgroundTransparency = element.Transparency or 0,
        Parent = inner,
    })

    local listeners = {}
    local function notify()
        swatchColor.BackgroundColor3 = element.Value
        swatchColor.BackgroundTransparency = element.Transparency or 0
        for _, listener in ipairs(listeners) do
            listener()
        end
    end

    function element:SetValue(color, silent)
        if type(color) == "string" then
            color = HexToColor(color)
        end
        if typeof(color) ~= "Color3" then
            return
        end
        self.Value = color
        notify()
        if not silent then
            self:_fire(color, self.Transparency)
        end
    end

    function element:SetTransparency(value, silent)
        if not hasAlpha then
            return
        end
        self.Transparency = math.clamp(tonumber(value) or 0, 0, 1)
        notify()
        if not silent then
            self:_fire(self.Value, self.Transparency)
        end
    end

    function element:SetRainbow(enabled)
        self.Rainbow = enabled == true
        if self.Rainbow then
            local _, sat, val = self.Value:ToHSV()
            self.RainbowSat = sat < 0.1 and 0.8 or sat
            self.RainbowVal = val < 0.1 and 1 or val
            RainbowPickers[self] = true
            StartRainbow()
        else
            RainbowPickers[self] = nil
        end
        notify()
    end

    function element:_rainbowStep(now)
        self:SetValue(Color3.fromHSV((now * self.RainbowSpeed) % 1, self.RainbowSat, self.RainbowVal))
    end

    function element:_save()
        return { Color = ColorToHex(self.Value), Transparency = self.Transparency, Rainbow = self.Rainbow }
    end

    -- Older configs stored only the hex string.
    function element:_load(value)
        if type(value) == "string" then
            local color = HexToColor(value)
            if color then
                self:SetValue(color)
            end
        elseif type(value) == "table" then
            if value.Transparency ~= nil then
                self:SetTransparency(value.Transparency, true)
            end
            local color = HexToColor(value.Color)
            if color then
                self:SetValue(color)
            end
            self:SetRainbow(value.Rainbow == true)
        end
    end

    function element:_display()
        local text = ColorToHex(self.Value)
        if hasAlpha then
            text = text .. " " .. math.floor((1 - self.Transparency) * 100 + 0.5) .. "%"
        end
        return text
    end

    swatch.Activated:Connect(function()
        if element.Disabled then
            return
        end
        local hue, sat, val = element.Value:ToHSV()
        local height = 268 + (hasAlpha and 22 or 0)
        local popup = window:_popup(swatch, 236, height, function()
            listeners = {}
        end)
        Pad(popup, 10, 10, 10, 10)
        local y = 0

        local svBox = New("Frame", {
            Name = "SV",
            Size = UDim2.new(1, 0, 0, 140),
            BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
            Parent = popup,
        })
        Corner(6, svBox)
        local white = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(255, 255, 255), Parent = svBox })
        Corner(6, white)
        New("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = white })
        local black = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(0, 0, 0), Parent = svBox })
        Corner(6, black)
        New("UIGradient", { Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = black })
        local svCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(12, 12),
            BackgroundTransparency = 1,
            ZIndex = 3,
            Parent = svBox,
        })
        Corner(6, svCursor)
        New("UIStroke", { Color = rgb(255, 255, 255), Thickness = 2, Parent = svCursor })
        y = 150

        local hueBar = New("Frame", {
            Name = "Hue",
            Position = UDim2.fromOffset(0, y),
            Size = UDim2.new(1, 0, 0, 12),
            BackgroundColor3 = rgb(255, 255, 255),
            Parent = popup,
        })
        Corner(6, hueBar)
        local keypoints = {}
        for i = 0, 6 do
            table.insert(keypoints, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 % 1, 1, 1)))
        end
        New("UIGradient", { Color = ColorSequence.new(keypoints), Parent = hueBar })
        local hueCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(14, 14),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(hue, 0.5),
            Parent = hueBar,
        })
        Corner(7, hueCursor)
        New("UIStroke", { Color = rgb(255, 255, 255), Thickness = 2, Parent = hueCursor })
        y = y + 22

        local alphaBar, alphaFill, alphaCursor
        if hasAlpha then
            alphaBar = New("CanvasGroup", {
                Name = "Alpha",
                Position = UDim2.fromOffset(0, y),
                Size = UDim2.new(1, 0, 0, 12),
                BackgroundTransparency = 1,
                Parent = popup,
            })
            Corner(6, alphaBar)
            Checker(alphaBar, 6, 216, 12)
            alphaFill = New("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = element.Value, Parent = alphaBar })
            New("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = alphaFill })
            -- The cursor lives outside the CanvasGroup so its ring is not clipped.
            alphaCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(14, 14),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, y + 6),
                ZIndex = 3,
                Parent = popup,
            })
            Corner(7, alphaCursor)
            New("UIStroke", { Color = rgb(255, 255, 255), Thickness = 2, Parent = alphaCursor })
            y = y + 22
        end

        local footer = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, y),
            Size = UDim2.new(1, 0, 0, 24),
            Parent = popup,
        })
        local preview = New("Frame", { Size = UDim2.fromOffset(40, 24), BackgroundColor3 = element.Value, Parent = footer })
        Corner(6, preview)
        local hexField = Bind(New("Frame", {
            Position = UDim2.fromOffset(48, 0),
            Size = UDim2.new(1, -48, 1, 0),
            Parent = footer,
        }), { BackgroundColor3 = "Field" })
        Corner(6, hexField)
        Bind(New("UIStroke", { Parent = hexField }), { Color = "FieldStroke" })
        local hexBox = Bind(New("TextBox", {
            Text = ColorToHex(element.Value),
            FontFace = Fonts.Medium,
            TextSize = 13,
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -16, 1, 0),
            Parent = hexField,
        }), { TextColor3 = "Text" })
        y = y + 34

        local swatches = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, y),
            Size = UDim2.new(1, 0, 0, 20),
            Parent = popup,
        })
        List(swatches, 0, Enum.FillDirection.Horizontal, {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
        })
        y = y + 30

        -- Rainbow switch.
        local rainbowRow = New("TextButton", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, y),
            Size = UDim2.new(1, 0, 0, 22),
            Parent = popup,
        })
        Bind(New("TextLabel", {
            Text = Library.Strings.Rainbow,
            TextSize = 13,
            Size = UDim2.new(1, -40, 1, 0),
            Parent = rainbowRow,
        }), { TextColor3 = "Text" })
        local miniTrack = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(30, 18),
            Parent = rainbowRow,
        })
        Corner(9, miniTrack)
        Bind(miniTrack, {
            BackgroundColor3 = function(theme)
                return element.Rainbow and theme.Accent or theme.SwitchOff
            end,
        })
        local miniKnob = New("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = rgb(255, 255, 255),
            Parent = miniTrack,
        })
        Corner(7, miniKnob)

        local function push()
            if element.Rainbow then
                element:SetRainbow(false)
            end
            element:SetValue(Color3.fromHSV(hue, sat, val))
        end

        local function paint()
            local color = element.Value
            local h, s, v = color:ToHSV()
            -- Keep the hue when the color is grey, ToHSV reports 0 there.
            if s > 0 then
                hue = h
            end
            sat, val = s, v
            svBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            svCursor.Position = UDim2.fromScale(sat, 1 - val)
            hueCursor.Position = UDim2.fromScale(hue, 0.5)
            preview.BackgroundColor3 = color
            if alphaFill then
                alphaFill.BackgroundColor3 = color
                alphaCursor.Position = UDim2.new(element.Transparency, 0, 0, alphaBar.Position.Y.Offset + 6)
            end
            if not hexBox:IsFocused() then
                hexBox.Text = ColorToHex(color)
            end
            miniKnob.Position = UDim2.new(0, element.Rainbow and 14 or 2, 0.5, 0)
            Refresh(miniTrack)
        end
        table.insert(listeners, paint)
        paint()

        for index, accent in ipairs(Library.Accents) do
            local dot = New("TextButton", {
                Size = UDim2.fromOffset(20, 20),
                BackgroundColor3 = accent.Color,
                LayoutOrder = index,
                Parent = swatches,
            })
            Corner(10, dot)
            dot.Activated:Connect(function()
                if element.Rainbow then
                    element:SetRainbow(false)
                end
                element:SetValue(accent.Color)
            end)
        end

        rainbowRow.Activated:Connect(function()
            element:SetRainbow(not element.Rainbow)
        end)

        local svHit = New("TextButton", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 4, Parent = svBox })
        local function svMove(position)
            local origin = GuiPosition(svBox)
            sat = math.clamp((position.X - origin.X) / svBox.AbsoluteSize.X, 0, 1)
            val = 1 - math.clamp((position.Y - origin.Y) / svBox.AbsoluteSize.Y, 0, 1)
            push()
        end
        TrackDrag(svHit, svMove, svMove)

        local hueHit = New("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 8),
            Position = UDim2.fromOffset(0, -4),
            ZIndex = 4,
            Parent = hueBar,
        })
        local function hueMove(position)
            hue = math.clamp((position.X - GuiPosition(hueBar).X) / hueBar.AbsoluteSize.X, 0, 0.999)
            push()
        end
        TrackDrag(hueHit, hueMove, hueMove)

        if alphaBar then
            local alphaHit = New("TextButton", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, alphaBar.Position.Y.Offset - 4),
                Size = UDim2.new(1, 0, 0, 20),
                ZIndex = 4,
                Parent = popup,
            })
            local function alphaMove(position)
                local alpha = math.clamp((position.X - GuiPosition(alphaBar).X) / alphaBar.AbsoluteSize.X, 0, 1)
                element:SetTransparency(alpha)
            end
            TrackDrag(alphaHit, alphaMove, alphaMove)
        end

        hexBox.FocusLost:Connect(function()
            local color = HexToColor(hexBox.Text)
            if color then
                if element.Rainbow then
                    element:SetRainbow(false)
                end
                element:SetValue(color)
            else
                hexBox.Text = ColorToHex(element.Value)
            end
        end)
    end)

    if opts.Rainbow then
        element:SetRainbow(true)
    end
    self:_register(element, opts, "ColorPicker")
    return element
end

--==============================================================
-- Segmented control
--==============================================================

local Segmented = Extend(Element)

function Section:AddSegmented(opts)
    opts = opts or {}
    local element = setmetatable({}, Segmented)
    element.Values = opts.Values or {}
    element.Value = opts.Default or element.Values[1]
    element.Resettable = true

    local segment = 0
    for _, value in ipairs(element.Values) do
        segment = math.max(segment, TextWidth(value, 12) + 22)
    end
    local width = segment * #element.Values + 4
    local row = self:_row(opts, width, element)

    local container = Bind(New("Frame", {
        Name = "Segmented",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(width, 24),
        Parent = row,
    }), { BackgroundColor3 = "SegmentBg" })
    Corner(7, container)
    local indicator = Bind(New("Frame", {
        Name = "Indicator",
        Size = UDim2.fromOffset(segment, 20),
        Position = UDim2.fromOffset(2, 2),
        Parent = container,
    }), { BackgroundColor3 = "SegmentSelected" })
    Corner(5, indicator)
    Bind(New("UIStroke", { Thickness = 1, Parent = indicator }), { Color = "KnobStroke", Transparency = "KnobStrokeTransparency" })

    local labels = {}
    local function render(animate)
        local index = table.find(element.Values, element.Value)
        indicator.Visible = index ~= nil
        if index then
            local goal = { Position = UDim2.fromOffset(2 + (index - 1) * segment, 2) }
            if animate then
                Spring(indicator, goal, 4.5, 0.7)
            else
                indicator.Position = goal.Position
            end
        end
        for value, label in pairs(labels) do
            label.FontFace = value == element.Value and Fonts.SemiBold or Fonts.Medium
        end
    end

    for index, value in ipairs(element.Values) do
        local button = Bind(New("TextButton", {
            BackgroundTransparency = 1,
            Text = tostring(value),
            FontFace = Fonts.Medium,
            TextSize = 12,
            Position = UDim2.fromOffset(2 + (index - 1) * segment, 2),
            Size = UDim2.fromOffset(segment, 20),
            ZIndex = 2,
            Parent = container,
        }), { TextColor3 = "Text" })
        labels[value] = button
        button.Activated:Connect(function()
            element:SetValue(value)
        end)
    end

    function element:SetValue(value, silent)
        local changed = value ~= self.Value
        self.Value = value
        render(true)
        if changed and not silent then
            self:_fire(value)
        end
    end

    render(false)
    self:_register(element, opts, "Segmented")
    return element
end

--==============================================================
-- Progress bar and spinner
--==============================================================

local Progress = Extend(Element)

function Section:AddProgress(opts)
    opts = opts or {}
    local element = setmetatable({}, Progress)
    element.Max = opts.Max or 1
    element.Value = math.clamp(opts.Value or opts.Default or 0, 0, element.Max)
    element.Indeterminate = opts.Indeterminate == true
    local row = self:_row(opts, 60, element)
    element.TextBlock.Size = UDim2.new(1, 0, 0, 0)
    element.TitleLabel.Size = UDim2.new(1, -66, 0, element.TitleLabel.Size.Y.Offset)

    local percent = Bind(New("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(60, 17),
        TextSize = 13,
        FontFace = Fonts.Medium,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    }), { TextColor3 = "SubText" })
    local bar = New("Frame", {
        Name = "Progress",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        LayoutOrder = 3,
        Parent = element.TextBlock,
    })
    -- CanvasGroup so the moving indeterminate segment is clipped to the rounded track.
    local track = Bind(New("CanvasGroup", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 2),
        Size = UDim2.new(1, 0, 0, 6),
        Parent = bar,
    }), { BackgroundColor3 = "Track" })
    Corner(3, track)
    local fill = Bind(New("Frame", { Size = UDim2.fromScale(0, 1), Parent = track }), { BackgroundColor3 = "Accent" })
    Corner(3, fill)

    local function format(value)
        return math.floor(value + 0.5) .. "%"
    end

    local loop
    local function render(animate, from)
        if loop then
            loop:Cancel()
            loop = nil
        end
        if element.Indeterminate then
            if Counters[percent] then
                Counters[percent].Cancel()
                Counters[percent] = nil
            end
            percent.Text = ""
            StopSpring(fill, "Size")
            fill.Size = UDim2.fromScale(0.3, 1)
            fill.Position = UDim2.fromScale(-0.3, 0)
            loop = TweenService:Create(fill, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), { Position = UDim2.fromScale(1, 0) })
            loop:Play()
            return
        end
        local alpha = element.Max > 0 and element.Value / element.Max or 0
        fill.Position = UDim2.fromScale(0, 0)
        local goal = { Size = UDim2.fromScale(alpha, 1) }
        if animate then
            Spring(fill, goal, 3, 1)
            CountTo(percent, from and from * 100 or nil, alpha * 100, format)
        else
            StopSpring(fill, "Size")
            fill.Size = goal.Size
            CountTo(percent, nil, alpha * 100, format)
        end
    end

    function element:SetValue(value)
        local previous
        if not self.Indeterminate and self.Max > 0 then
            previous = self.Value / self.Max
        end
        self.Value = math.clamp(tonumber(value) or 0, 0, self.Max)
        self.Indeterminate = false
        render(true, previous)
    end

    function element:SetIndeterminate(enabled)
        self.Indeterminate = enabled == true
        render(false)
    end

    function element:_display()
        return percent.Text
    end

    render(false)
    self:_register(element, opts, "Progress")
    return element
end

local Spinner = Extend(Element)

function Section:AddSpinner(opts)
    opts = opts or {}
    local element = setmetatable({}, Spinner)
    local row = self:_row(opts, 20, element)
    local holder = New("Frame", {
        Name = "Spinner",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -1, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        Parent = row,
    })
    -- Eight bars with a fading tail, the classic macOS spinner.
    for i = 0, 7 do
        local angle = i * 45
        local radians = math.rad(angle)
        local bar = Bind(New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, math.sin(radians) * 5.5, 0.5, -math.cos(radians) * 5.5),
            Size = UDim2.fromOffset(2, 5),
            Rotation = angle,
            BackgroundTransparency = (7 - i) / 7 * 0.8,
            Parent = holder,
        }), { BackgroundColor3 = "SubText" })
        Corner(1, bar)
    end

    local spin
    function element:SetSpinning(enabled)
        self.Spinning = enabled == true
        if spin then
            spin:Cancel()
            spin = nil
        end
        holder.Visible = self.Spinning
        if self.Spinning then
            holder.Rotation = 0
            spin = TweenService:Create(holder, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = 360 })
            spin:Play()
        end
    end

    element:SetSpinning(opts.Spinning ~= false)
    self:_register(element, opts, "Spinner")
    return element
end

--==============================================================
-- Label and paragraph
--==============================================================

local Label = Extend(Element)

function Section:AddLabel(text)
    local opts = type(text) == "table" and text or { Title = text }
    local element = setmetatable({}, Label)
    self:_row(opts, 0, element)
    Bind(element.TitleLabel, { TextColor3 = "SubText" })
    element.TitleLabel.TextSize = 13
    element.SetText = element.SetTitle
    self:_register(element, opts, "Label")
    return element
end

function Section:AddParagraph(opts)
    opts = opts or {}
    local element = setmetatable({}, Label)
    self:_row({ Title = opts.Title, Description = opts.Content, Tooltip = opts.Tooltip }, 0, element)
    element.TitleLabel.FontFace = Fonts.SemiBold
    element.DescriptionLabel.TextSize = 13
    element.SetContent = element.SetDescription
    self:_register(element, opts, "Paragraph")
    return element
end

-- Accent swatches row (the one in macOS Appearance settings).
function Section:_addAccentRow(title)
    local element = setmetatable({}, Element)
    local count = #Library.Accents
    local width = count * 18 + (count - 1) * 8
    local row = self:_row({ Title = title }, width, element)
    local holder = New("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromOffset(width, 18),
        Parent = row,
    })
    List(holder, 8, Enum.FillDirection.Horizontal, { VerticalAlignment = Enum.VerticalAlignment.Center })
    for index, accent in ipairs(Library.Accents) do
        local dot = New("TextButton", {
            Size = UDim2.fromOffset(18, 18),
            BackgroundColor3 = accent.Color,
            LayoutOrder = index,
            Parent = holder,
        })
        Corner(9, dot)
        local inner = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(6, 6),
            BackgroundColor3 = rgb(255, 255, 255),
            Parent = dot,
        })
        Corner(3, inner)
        Bind(inner, {
            BackgroundTransparency = function(theme)
                return theme.Accent == accent.Color and 0 or 1
            end,
        })
        dot.Activated:Connect(function()
            Library:SetAccent(accent.Color)
        end)
    end
    element.Type = "AccentRow"
    return element
end

--==============================================================
-- Tab
--==============================================================

local Tab = {}
Tab.__index = Tab

local SectionOrder = 0

-- AddSection("Title") or AddSection({ Title, Collapsible, Collapsed }).
function Tab:AddSection(title, opts)
    if type(title) == "table" then
        opts = title
        title = opts.Title
    end
    opts = opts or {}
    SectionOrder = SectionOrder + 1
    local section = setmetatable({ Elements = {}, Tab = self, Window = self.Window, Title = title }, Section)
    local holder = New("Frame", {
        Name = "Section",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = SectionOrder,
        Parent = self.Page,
    })
    List(holder, 6)
    if title and title ~= "" then
        local header = New(opts.Collapsible and "TextButton" or "Frame", {
            Name = "Header",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            LayoutOrder = 1,
            Parent = holder,
        })
        section.Header = Bind(New("TextLabel", {
            Text = title,
            FontFace = Fonts.SemiBold,
            TextSize = 13,
            Position = UDim2.fromOffset(6, 0),
            Size = UDim2.new(1, -30, 1, 0),
            Parent = header,
        }), { TextColor3 = "Text" })
        if opts.Collapsible then
            -- Disclosure chevron: points right when collapsed, down when open.
            local chevronHolder = New("Frame", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -6, 0.5, 0),
                Size = UDim2.fromOffset(12, 12),
                Rotation = opts.Collapsed and 0 or 90,
                Parent = header,
            })
            for _, bar in ipairs(Chevron(chevronHolder, UDim2.fromScale(0.5, 0.5), 7, 1.5, "Right")) do
                Bind(bar, { BackgroundColor3 = "SubText" })
            end
            section.ChevronHolder = chevronHolder
            header.Activated:Connect(function()
                section:SetCollapsed(not section.Collapsed)
            end)
        end
    end
    local group = Bind(New("Frame", {
        Name = "Group",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        Parent = holder,
    }), { BackgroundColor3 = "Group" })
    Corner(10, group)
    Bind(New("UIStroke", { Parent = group }), { Color = "GroupStroke" })
    List(group, 0)
    section.Holder = holder
    section.Group = group
    section.Collapsed = false
    if opts.Collapsible and opts.Collapsed then
        section.Collapsed = true
        group.Visible = false
    end
    table.insert(self.Sections, section)
    return section
end

-- Elements added straight to a tab land in an untitled section.
local SectionMethods = {
    "AddButton",
    "AddToggle",
    "AddCheckbox",
    "AddRadio",
    "AddSlider",
    "AddStepper",
    "AddDropdown",
    "AddPlayerDropdown",
    "AddInput",
    "AddTextArea",
    "AddKeybind",
    "AddColorPicker",
    "AddSegmented",
    "AddProgress",
    "AddSpinner",
    "AddLabel",
    "AddParagraph",
}
for _, name in ipairs(SectionMethods) do
    Tab[name] = function(self, ...)
        local last = self.Sections[#self.Sections]
        if not last or not last.Implicit then
            last = self:AddSection()
            last.Implicit = true
        end
        return last[name](last, ...)
    end
end

function Tab:Select()
    self.Window:SelectTab(self)
end

function Tab:SetTitle(text)
    self.Title = text
    self.Label.Text = text
    local window = self.Window
    if window.ActiveTab == self and not window.SearchPage.Visible then
        window.HeaderTitle.Text = text
    end
end

function Tab:Destroy()
    local window = self.Window
    for _, section in ipairs(self.Sections) do
        for i = #section.Elements, 1, -1 do
            section.Elements[i]:_unregister()
        end
    end
    local index = table.find(window.Tabs, self)
    if index then
        table.remove(window.Tabs, index)
    end
    self.Button:Destroy()
    self.Page:Destroy()
    if window.ActiveTab == self then
        window.ActiveTab = nil
        if window.Tabs[1] then
            window:SelectTab(window.Tabs[1])
        end
    end
end

--==============================================================
-- Window
--==============================================================

local Window = {}
Window.__index = Window

local function Bezier(a, b, c, t)
    local u = 1 - t
    return a * (u * u) + b * (2 * u * t) + c * (t * t)
end

-- Blurs the 3D world while any window is open, when the user wants it.
-- Roblox can only blur the whole scene, not just the area behind the
-- window; the interface itself stays sharp.
local BlurInstance
local function UpdateBlur()
    local wanted = false
    if Library.BlurBackground and not Library.Unloaded then
        for _, window in ipairs(Library.Windows) do
            if window.Visible and not window.Minimized then
                wanted = true
            end
        end
    end
    if wanted and not (BlurInstance and BlurInstance.Parent) then
        BlurInstance = New("BlurEffect", { Name = RandomName(), Size = 0, Parent = Lighting })
    end
    if BlurInstance then
        Tween(BlurInstance, Tweens.Slow, { Size = wanted and 14 or 0 })
    end
end

-- Small colored circle with a symbol on an app icon, marking a banner's type.
local function StatusBadge(icon, kind)
    local status = StatusStyles[kind or ""]
    if not status then
        return
    end
    local size = icon.Size.X.Offset
    local badge = New("Frame", {
        Position = UDim2.fromOffset(size - 12, size - 12),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = status.Color,
        Parent = icon,
    })
    Corner(8, badge)
    Bind(New("UIStroke", { Thickness = 2, Parent = badge }), { Color = "Popup" })
    New("ImageLabel", {
        Image = Library.Icons[status.Icon],
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(10, 10),
        ImageColor3 = rgb(255, 255, 255),
        Parent = badge,
    })
end

-- Unread banners since the notification center was last opened.
local UnreadCount = 0
local function UpdateBellBadges()
    for _, window in ipairs(Library.Windows) do
        local badge = window.BellBadge
        if badge then
            badge.Visible = UnreadCount > 0
            badge.Text = UnreadCount > 9 and "9+" or tostring(UnreadCount)
        end
    end
end

local TITLEBAR = 52
local SHADOW_MARGIN = 24
local TabOrder = 0

function Library:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "PaneUI"

    -- Re-running the same script replaces its previous window.
    local env = (getgenv and getgenv()) or _G
    env.__PaneUIRegistry = env.__PaneUIRegistry or {}
    local previous = env.__PaneUIRegistry[title]
    if previous and previous ~= self and not previous.Unloaded then
        pcall(function()
            previous:Unload()
        end)
    end
    env.__PaneUIRegistry[title] = self

    -- Saved user choices win over the script's defaults.
    self._saved = self._saved or {}
    if opts.ConfigFolder ~= false then
        self.Folder = opts.ConfigFolder or string.gsub(title, "[^%w%-_ ]", "")
        self:_loadSettings()
    end
    local saved = self._saved
    if opts.Theme and self.Themes[opts.Theme] and not saved.Theme then
        self.ThemeName = opts.Theme
    end
    if opts.Accent and not saved.Accent then
        self.Accent = opts.Accent
    end
    if opts.ToggleKey and not saved.ToggleKey then
        self.ToggleKey = opts.ToggleKey
    end
    if opts.Language and self.Languages[opts.Language] and not saved.Language then
        self.Language = opts.Language
        self.Strings = CopyTable(self.Languages[opts.Language])
    end
    if opts.Scale and not saved.Scale then
        self.ScaleSetting = opts.Scale
    end
    if opts.Watermark ~= nil and not saved.Watermark then
        self.ShowWatermark = opts.Watermark == true
    end
    if opts.KeybindList ~= nil and not saved.KeybindList then
        self.ShowKeybinds = opts.KeybindList == true
    end
    if opts.HideToDock ~= nil and not saved.HideToDock then
        self.HideToDock = opts.HideToDock == true
    end
    if opts.Blur ~= nil and not saved.Blur then
        self.BlurBackground = opts.Blur == true
    end
    BuildTheme()
    self.UIScale = CurrentScale()
    local uiScale = self.UIScale

    local gui = GetScreenGui()
    local viewport = gui.AbsoluteSize
    local size = opts.Size or UDim2.fromOffset(720, 480)
    -- Even sizes and whole-pixel centers keep the CanvasGroup texture
    -- aligned to screen pixels; half-pixel offsets blur thin glyphs.
    local width = math.floor(math.min(size.X.Offset, viewport.X / uiScale - 40) / 2) * 2
    local height = math.floor(math.min(size.Y.Offset, viewport.Y / uiScale - 40) / 2) * 2

    local window = setmetatable({
        Title = title,
        Subtitle = opts.Subtitle,
        Icon = opts.Icon,
        IconColor = opts.IconColor or IconPalette[1],
        Tabs = {},
        SearchIndex = {},
        Visible = true,
        Minimized = false,
        Zoomed = false,
        MinSize = opts.MinSize or Vector2.new(560, 360),
        SidebarWidth = opts.SidebarWidth or 200,
        CloseBehavior = opts.CloseBehavior or "Unload",
    }, Window)

    -- Root is a CanvasGroup so the whole window, shadow included, can fade.
    local root = New("CanvasGroup", {
        Name = "Window",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(math.floor(viewport.X / 2), math.floor(viewport.Y / 2)),
        Size = UDim2.fromOffset(width + SHADOW_MARGIN * 2, height + SHADOW_MARGIN * 2),
        GroupTransparency = 1,
        ZIndex = 1,
        Parent = gui,
    })
    local scale = New("UIScale", { Scale = uiScale * 0.96, Parent = root })
    -- The shadow deepens while the window is dragged, so it looks lifted.
    local shadow = Shadow(root, 14, 12, 0, function()
        return window.Lifted and 1.8 or 1
    end)
    shadow.Position = UDim2.fromOffset(SHADOW_MARGIN, SHADOW_MARGIN)
    shadow.Size = UDim2.new(1, -SHADOW_MARGIN * 2, 1, -SHADOW_MARGIN * 2)

    local frame = Bind(New("Frame", {
        Name = "Body",
        Position = UDim2.fromOffset(SHADOW_MARGIN, SHADOW_MARGIN),
        Size = UDim2.new(1, -SHADOW_MARGIN * 2, 1, -SHADOW_MARGIN * 2),
        ZIndex = 1,
        Parent = root,
    }), { BackgroundColor3 = "Background" })
    Corner(12, frame)
    Bind(New("UIStroke", { Parent = frame }), { Color = "WindowStroke" })

    -- Sidebar: rounded on the left, square on the right.
    local sidebar = Bind(New("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, window.SidebarWidth, 1, 0),
        Parent = frame,
    }), { BackgroundColor3 = "Sidebar" })
    Corner(12, sidebar)
    Bind(New("Frame", {
        Name = "Square",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 14, 1, 0),
        Parent = sidebar,
    }), { BackgroundColor3 = "Sidebar" })
    Bind(New("Frame", {
        Name = "Divider",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 1, 1, 0),
        ZIndex = 2,
        Parent = sidebar,
    }), { BackgroundColor3 = "Separator" })

    -- Traffic lights.
    local lights = New("Frame", {
        Name = "TrafficLights",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 20),
        Size = UDim2.fromOffset(12 * 3 + 8 * 2, 12),
        ZIndex = 10,
        Parent = frame,
    })
    List(lights, 8, Enum.FillDirection.Horizontal)
    local glyphs = {}
    local lightsHovered = false
    local function light(name, order, color, callback)
        local dot = New("TextButton", {
            Name = name,
            Size = UDim2.fromOffset(12, 12),
            BackgroundColor3 = color,
            LayoutOrder = order,
            ZIndex = 10,
            Parent = lights,
        })
        Corner(6, dot)
        New("UIStroke", { Color = rgb(0, 0, 0), Transparency = 0.85, Parent = dot })
        local glyph = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            ZIndex = 11,
            Parent = dot,
        })
        local ink = rgb(80, 30, 20)
        if name == "Close" then
            Bar(glyph, { Size = UDim2.fromOffset(1.5, 7), Position = UDim2.fromScale(0.5, 0.5), Rotation = 45, BackgroundColor3 = ink, ZIndex = 11 })
            Bar(glyph, { Size = UDim2.fromOffset(1.5, 7), Position = UDim2.fromScale(0.5, 0.5), Rotation = -45, BackgroundColor3 = ink, ZIndex = 11 })
        elseif name == "Minimize" then
            Bar(glyph, { Size = UDim2.fromOffset(7, 1.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = rgb(110, 60, 0), ZIndex = 11 })
        else
            Bar(glyph, { Size = UDim2.fromOffset(7, 1.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = rgb(10, 80, 20), ZIndex = 11 })
            Bar(glyph, { Size = UDim2.fromOffset(1.5, 7), Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = rgb(10, 80, 20), ZIndex = 11 })
        end
        table.insert(glyphs, glyph)
        dot.MouseEnter:Connect(function()
            lightsHovered = true
            for _, g in ipairs(glyphs) do
                g.Visible = true
            end
        end)
        dot.MouseLeave:Connect(function()
            lightsHovered = false
            for _, g in ipairs(glyphs) do
                g.Visible = false
            end
        end)
        dot.Activated:Connect(callback)
    end
    light("Close", 1, TrafficColors.Close, function()
        window:Close()
    end)
    light("Minimize", 2, TrafficColors.Minimize, function()
        window:Minimize()
    end)
    light("Zoom", 3, TrafficColors.Zoom, function()
        window:Zoom()
    end)

    -- Search field at the top of the sidebar, as in System Settings.
    local searchField = Bind(New("Frame", {
        Name = "Search",
        Position = UDim2.fromOffset(10, TITLEBAR),
        Size = UDim2.new(1, -20, 0, 28),
        Parent = sidebar,
    }), { BackgroundColor3 = "SearchField" })
    Corner(7, searchField)
    Bind(New("ImageLabel", {
        Image = Library.Icons.search,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 8, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        Parent = searchField,
    }), { ImageColor3 = "Tertiary" })
    local searchBox = Bind(New("TextBox", {
        Text = "",
        PlaceholderText = Library.Strings.Search,
        TextSize = 13,
        Position = UDim2.fromOffset(28, 0),
        Size = UDim2.new(1, -52, 1, 0),
        Parent = searchField,
    }), { TextColor3 = "Text", PlaceholderColor3 = "Tertiary" })
    local clearSearch = Bind(New("ImageButton", {
        Image = Library.Icons.x,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.fromOffset(13, 13),
        Visible = false,
        Parent = searchField,
    }), { ImageColor3 = "Tertiary" })
    clearSearch.Activated:Connect(function()
        searchBox.Text = ""
    end)

    -- Sidebar tab list. The buttons live in their own laid-out frame so the
    -- selection pill, a sibling of that frame, can move freely beneath them.
    local tabList = Bind(New("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(0, TITLEBAR + 38),
        Size = UDim2.new(1, 0, 1, -TITLEBAR - 38 - 58),
        ScrollBarThickness = 2,
        Parent = sidebar,
    }), { ScrollBarImageColor3 = "Scrollbar" })
    local tabContent = New("Frame", {
        Name = "TabButtons",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 2,
        Parent = tabList,
    })
    Pad(tabContent, 0, 10, 8, 10)
    List(tabContent, 2)
    local selection = Bind(New("Frame", {
        Name = "Selection",
        Size = UDim2.fromOffset(0, 32),
        Visible = false,
        ZIndex = 1,
        Parent = tabList,
    }), { BackgroundColor3 = "Accent" })
    Corner(7, selection)
    tabContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        task.defer(function()
            window:_moveSelection(false)
        end)
    end)

    -- Profile card at the bottom of the sidebar.
    local profile = New("Frame", {
        Name = "Profile",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 10, 1, -10),
        Size = UDim2.new(1, -20, 0, 40),
        Parent = sidebar,
    })
    Bind(New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.fromOffset(0, -8),
        Parent = profile,
    }), { BackgroundColor3 = "Separator" })
    local avatar = Bind(New("ImageLabel", {
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150",
        BackgroundTransparency = 0,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(32, 32),
        Parent = profile,
    }), { BackgroundColor3 = "SidebarHover" })
    Corner(16, avatar)
    Bind(New("TextLabel", {
        Text = LocalPlayer.DisplayName,
        FontFace = Fonts.SemiBold,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(42, 3),
        Size = UDim2.new(1, -42, 0, 17),
        Parent = profile,
    }), { TextColor3 = "Text" })
    Bind(New("TextLabel", {
        Text = "@" .. LocalPlayer.Name,
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(42, 20),
        Size = UDim2.new(1, -42, 0, 15),
        Parent = profile,
    }), { TextColor3 = "SubText" })

    -- Content area.
    local content = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(window.SidebarWidth, 0),
        Size = UDim2.new(1, -window.SidebarWidth, 1, 0),
        Parent = frame,
    })
    local header = New("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, TITLEBAR),
        Parent = content,
    })
    local headerTitle = Bind(New("TextLabel", {
        Text = "",
        FontFace = Fonts.Bold,
        TextSize = 15,
        Position = UDim2.fromOffset(20, 9),
        Size = UDim2.new(1, -76, 0, 18),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    }), { TextColor3 = "Text" })

    -- Bell in the header: opens the notification center, a red badge counts
    -- banners the user has not seen there yet.
    local bell = Bind(New("ImageButton", {
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        BackgroundTransparency = 1,
        ZIndex = 12,
        Parent = header,
    }), { BackgroundColor3 = "RowHover" })
    Corner(7, bell)
    Bind(New("ImageLabel", {
        Image = Library.Icons.bell,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16),
        ZIndex = 12,
        Parent = bell,
    }), { ImageColor3 = "SubText" })
    local bellBadge = New("TextLabel", {
        Name = "Badge",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(21, 7),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 0,
        BackgroundColor3 = rgb(255, 69, 58),
        TextColor3 = rgb(255, 255, 255),
        FontFace = Fonts.Bold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
        ZIndex = 13,
        Parent = bell,
    })
    Corner(8, bellBadge)
    local bellHovered = false
    bell.MouseEnter:Connect(function()
        bellHovered = true
        Tween(bell, Tweens.Fast, { BackgroundTransparency = 0 })
    end)
    bell.MouseLeave:Connect(function()
        bellHovered = false
        Tween(bell, Tweens.Fast, { BackgroundTransparency = 1 })
    end)
    bell.Activated:Connect(function()
        window:ToggleNotificationCenter()
    end)
    local subtitleText = title
    if window.Subtitle then
        subtitleText = title .. " - " .. window.Subtitle
    end
    window.SubtitleLabel = Bind(New("TextLabel", {
        Text = subtitleText,
        TextSize = 12,
        Position = UDim2.fromOffset(20, 28),
        Size = UDim2.new(1, -40, 0, 15),
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header,
    }), { TextColor3 = "SubText" })
    Bind(New("Frame", {
        Name = "Separator",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(1, 0, 0, 1),
        Parent = header,
    }), { BackgroundColor3 = "Separator" })
    local pages = New("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, TITLEBAR),
        Size = UDim2.new(1, 0, 1, -TITLEBAR - 12),
        ClipsDescendants = true,
        Parent = content,
    })
    local searchPage = Bind(New("ScrollingFrame", {
        Name = "SearchResults",
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Parent = pages,
    }), { ScrollBarImageColor3 = "Scrollbar" })
    Pad(searchPage, 18, 20, 18, 20)
    List(searchPage, 12)

    -- Dragging by the title bar strip.
    local dragHandle = New("Frame", {
        Name = "DragHandle",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, TITLEBAR),
        ZIndex = 9,
        Parent = frame,
    })
    -- While dragged, the window lifts: the shadow deepens and it grows a hair.
    local function lift(lifted)
        window.Lifted = lifted
        RefreshShadow(shadow, Tweens.Fast)
        Spring(scale, { Scale = Library.UIScale * (lifted and 1.012 or 1) }, 5, 0.7)
    end
    local dragStart, startPosition
    TrackDrag(dragHandle, function(position)
        if lightsHovered or bellHovered or window.Zoomed then
            return false
        end
        window:_closePopup()
        dragStart = position
        startPosition = GuiPosition(root) + root.AbsoluteSize / 2
        lift(true)
    end, function(position)
        local delta = position - dragStart
        local screen = gui.AbsoluteSize
        local x = math.clamp(startPosition.X + delta.X, 60, screen.X - 60)
        local y = math.clamp(startPosition.Y + delta.Y, 60, screen.Y - 60)
        root.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
    end, function()
        lift(false)
    end)

    -- Resize from any edge or corner. Handles straddle the window border,
    -- half outside it in the shadow margin. Sizes are in layout pixels and
    -- the pointer moves in screen pixels, so deltas are divided by the scale;
    -- the edge opposite the one being dragged stays where it is.
    local resizeStart, startSize, startCenter
    local function resizeHandle(name, position, size, dirX, dirY)
        local handle = New("TextButton", {
            Name = name,
            BackgroundTransparency = 1,
            Position = position,
            Size = size,
            ZIndex = 20,
            Parent = root,
        })
        TrackDrag(handle, function(pointer)
            if window.Zoomed or window.Minimized then
                return false
            end
            window:_closePopup()
            resizeStart = pointer
            startSize = Vector2.new(root.Size.X.Offset, root.Size.Y.Offset)
            startCenter = GuiPosition(root) + root.AbsoluteSize / 2
        end, function(pointer)
            local s = Library.UIScale
            local delta = (pointer - resizeStart) / s
            local screen = gui.AbsoluteSize / s
            local newWidth, newHeight = startSize.X, startSize.Y
            if dirX ~= 0 then
                newWidth = math.clamp(startSize.X + delta.X * dirX, window.MinSize.X + SHADOW_MARGIN * 2, screen.X)
                newWidth = math.floor(newWidth / 2) * 2
            end
            if dirY ~= 0 then
                newHeight = math.clamp(startSize.Y + delta.Y * dirY, window.MinSize.Y + SHADOW_MARGIN * 2, screen.Y)
                newHeight = math.floor(newHeight / 2) * 2
            end
            root.Size = UDim2.fromOffset(newWidth, newHeight)
            root.Position = UDim2.fromOffset(
                math.floor(startCenter.X + (newWidth - startSize.X) * s / 2 * dirX),
                math.floor(startCenter.Y + (newHeight - startSize.Y) * s / 2 * dirY)
            )
        end)
    end
    local m, t, c = SHADOW_MARGIN, 8, 14 -- margin, edge thickness, corner size
    resizeHandle("ResizeLeft", UDim2.fromOffset(m - t / 2, m + c), UDim2.new(0, t, 1, -2 * (m + c)), -1, 0)
    resizeHandle("ResizeRight", UDim2.new(1, -m - t / 2, 0, m + c), UDim2.new(0, t, 1, -2 * (m + c)), 1, 0)
    resizeHandle("ResizeTop", UDim2.fromOffset(m + c, m - t / 2), UDim2.new(1, -2 * (m + c), 0, t), 0, -1)
    resizeHandle("ResizeBottom", UDim2.new(0, m + c, 1, -m - t / 2), UDim2.new(1, -2 * (m + c), 0, t), 0, 1)
    resizeHandle("ResizeTopLeft", UDim2.fromOffset(m - c / 2, m - c / 2), UDim2.fromOffset(c, c), -1, -1)
    resizeHandle("ResizeTopRight", UDim2.new(1, -m - c / 2, 0, m - c / 2), UDim2.fromOffset(c, c), 1, -1)
    resizeHandle("ResizeBottomLeft", UDim2.new(0, m - c / 2, 1, -m - c / 2), UDim2.fromOffset(c, c), -1, 1)
    resizeHandle("ResizeBottomRight", UDim2.new(1, -m - c / 2, 1, -m - c / 2), UDim2.fromOffset(c, c), 1, 1)

    -- A full-screen catcher closes popups on an outside click. It is not
    -- scaled; the popup layer above it is.
    local catcher = New("TextButton", {
        Name = "Catcher",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 50,
        Parent = gui,
    })
    catcher.MouseButton1Down:Connect(function()
        window:_closePopup()
    end)
    catcher.MouseButton2Down:Connect(function()
        window:_closePopup()
    end)
    local overlay = New("Frame", {
        Name = "Overlay",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 51,
        Parent = gui,
    })
    ScaleTarget(New("UIScale", { Parent = overlay }))

    window.Root = root
    window.Scale = scale
    window.Shadow = shadow
    window.Frame = frame
    window.Sidebar = sidebar
    window.TabList = tabList
    window.TabContent = tabContent
    window.Selection = selection
    window.BellBadge = bellBadge
    window.Pages = pages
    window.SearchPage = searchPage
    window.SearchBox = searchBox
    window.HeaderTitle = headerTitle
    window.Overlay = overlay
    window.Catcher = catcher
    window.Gui = gui

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        clearSearch.Visible = searchBox.Text ~= ""
        window:_search(string.lower(Trim(searchBox.Text)))
    end)
    OnLanguage(searchBox, function()
        searchBox.PlaceholderText = Library.Strings.Search
        if searchPage.Visible then
            window:_search(string.lower(Trim(searchBox.Text)))
        end
    end)

    table.insert(self.Windows, window)
    StartInput()
    window:_show(true)
    UpdateBellBadges()
    if self.ShowWatermark then
        self:SetWatermark(true)
    end
    if self.ShowKeybinds then
        self:SetKeybindList(true)
    end
    return window
end

function Window:_show(first)
    self.Visible = true
    self.Root.Visible = true
    local s = Library.UIScale
    if first then
        self.Root.GroupTransparency = 1
        self.Scale.Scale = s * 0.94
    end
    if self.Animation then
        self.Animation.Cancel()
        self.Animation = nil
    end
    Tween(self.Root, Tweens.Normal, { GroupTransparency = 0 })
    Spring(self.Scale, { Scale = s }, 3.5, 0.62)
    UpdateBlur()
end

function Window:_hide(callback)
    self.Visible = false
    self:_closePopup()
    self:_hideTooltip()
    Spring(self.Scale, { Scale = Library.UIScale * 0.96 }, 6, 1)
    local tween = Tween(self.Root, Tweens.Fast, { GroupTransparency = 1 })
    tween.Completed:Connect(function()
        if not self.Visible then
            self.Root.Visible = false
        end
        if callback then
            callback()
        end
    end)
    UpdateBlur()
end

function Window:_applyScale()
    self:_closePopup()
    if self.Visible and not self.Minimized then
        Spring(self.Scale, { Scale = Library.UIScale }, 5, 0.9)
    end
end

function Window:SetVisible(visible)
    if self.Minimized then
        self:Restore()
        return
    end
    if visible == self.Visible then
        return
    end
    if visible then
        self:_show()
    else
        self:_hide()
    end
end

-- Hides the window the way the user expects: into the dock tile, like the
-- yellow button, unless the dock tile is turned off. Touch-only devices
-- always get the tile, since they have no key to bring the window back.
function Window:_hideByUser()
    local touchOnly = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    if Library.HideToDock or touchOnly then
        self:Minimize()
        return true
    end
    self:SetVisible(false)
    return false
end

function Window:Toggle()
    if self.Minimized then
        self:Restore()
        return
    end
    if self.Visible then
        self:_hideByUser()
    else
        self:SetVisible(true)
    end
end

function Window:Close()
    local strings = Library.Strings
    if self.CloseBehavior == "Hide" then
        if not self:_hideByUser() then
            Library:Notify({
                Title = self.Title,
                Content = string.format(strings.HiddenHint, KeyName(Library.ToggleKey)),
                Duration = 4,
            })
        end
        return
    end
    self:Dialog({
        Title = string.format(strings.CloseTitle, self.Title),
        Content = string.format(strings.CloseContent, KeyName(Library.ToggleKey)),
        Buttons = {
            {
                Title = strings.Unload,
                Style = "Destructive",
                Callback = function()
                    Library:Unload()
                end,
            },
            { Title = strings.Cancel, Style = "Primary" },
        },
    })
end

-- Minimize into a small dock tile at the bottom of the screen.
function Window:Minimize()
    if self.Minimized then
        return
    end
    self.Minimized = true
    self:_closePopup()
    self:_hideTooltip()
    local gui = self.Gui
    if not self.Dock then
        local dock = New("TextButton", {
            Name = "Dock",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, 80),
            Size = UDim2.fromOffset(0, 48),
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = 40,
            Parent = gui,
        })
        ScaleTarget(New("UIScale", { Parent = dock }))
        Bind(dock, { BackgroundColor3 = "Popup" })
        Corner(14, dock)
        Bind(New("UIStroke", { Parent = dock }), { Color = "PopupStroke" })
        Pad(dock, 8, 14, 8, 8)
        List(dock, 10, Enum.FillDirection.Horizontal, { VerticalAlignment = Enum.VerticalAlignment.Center })
        local icon = AppIcon(dock, 32, self.Icon, self.IconColor, self.Title, 8)
        icon.LayoutOrder = 1
        Bind(New("TextLabel", {
            Text = self.Title,
            FontFace = Fonts.SemiBold,
            TextSize = 13,
            Size = UDim2.fromOffset(0, 32),
            AutomaticSize = Enum.AutomaticSize.X,
            LayoutOrder = 2,
            ZIndex = 41,
            Parent = dock,
        }), { TextColor3 = "Text" })
        dock.Activated:Connect(function()
            self:Restore()
        end)
        self.Dock = dock
    end
    -- The tile rises first, then the window swoops into it along a curve
    -- (down first, then across), shrinking and fading as it lands. The tile
    -- bounces on impact. This is the macOS "scale" effect; a real Genie
    -- warp would need to bend the window, which Roblox GUI cannot do.
    local root, uiScale = self.Root, self.Scale
    local s = Library.UIScale
    local screen = self.Gui.AbsoluteSize
    local from = GuiPosition(root) + root.AbsoluteSize / 2
    local to = Vector2.new(screen.X / 2, screen.Y - 16 - 24 * s)
    self.RestoreState = { Position = UDim2.fromOffset(math.floor(from.X), math.floor(from.Y)) }
    self.Visible = false
    UpdateBlur()

    self.Dock.Visible = true
    Spring(self.Dock, { Position = UDim2.new(0.5, 0, 1, -16) }, 4, 0.8)

    if self.Animation then
        self.Animation.Cancel()
    end
    StopSpring(uiScale, "Scale")
    local control = Vector2.new(from.X, to.Y)
    self.Animation = Animate(0.45, function(alpha)
        local point = Bezier(from, control, to, EaseInOutCubic(alpha))
        root.Position = UDim2.fromOffset(point.X, point.Y)
        uiScale.Scale = s * (1 - 0.92 * EaseInCubic(alpha))
        root.GroupTransparency = math.clamp((alpha - 0.55) / 0.45, 0, 1)
    end, function()
        self.Animation = nil
        if self.Minimized then
            root.Visible = false
            SpringKick(self.Dock, "Position", UDim2.new(0, 0, 0, -260), 4, 0.35)
        end
    end)
end

function Window:Restore()
    if not self.Minimized then
        return
    end
    self.Minimized = false
    self.Visible = true
    local root, uiScale = self.Root, self.Scale
    root.Visible = true
    local s = Library.UIScale
    local screen = self.Gui.AbsoluteSize
    local from = Vector2.new(screen.X / 2, screen.Y - 16 - 24 * s)
    local target = self.RestoreState.Position
    local to = Vector2.new(target.X.Offset, target.Y.Offset)
    local control = Vector2.new(to.X, from.Y)

    -- The same curve backwards: out of the tile, growing to full size.
    if self.Animation then
        self.Animation.Cancel()
    end
    StopSpring(uiScale, "Scale")
    self.Animation = Animate(0.42, function(alpha)
        local point = Bezier(from, control, to, EaseOutCubic(alpha))
        root.Position = UDim2.fromOffset(point.X, point.Y)
        uiScale.Scale = s * (0.08 + 0.92 * EaseOutCubic(alpha))
        root.GroupTransparency = 1 - math.clamp(alpha / 0.35, 0, 1)
    end, function()
        self.Animation = nil
        root.Position = target
        SpringKick(uiScale, "Scale", 0.35, 4, 0.6)
    end)
    UpdateBlur()

    Spring(self.Dock, { Position = UDim2.new(0.5, 0, 1, 80) }, 4, 1)
    task.delay(0.6, function()
        if not self.Minimized and self.Dock then
            self.Dock.Visible = false
        end
    end)
end

-- Green button: fill most of the screen, press again to go back.
function Window:Zoom()
    self:_closePopup()
    if self.Zoomed then
        self.Zoomed = false
        Tween(self.Root, Tweens.Slow, { Size = self.ZoomState.Size, Position = self.ZoomState.Position })
        return
    end
    self.Zoomed = true
    self.ZoomState = { Size = self.Root.Size, Position = self.Root.Position }
    local s = Library.UIScale
    local screen = self.Gui.AbsoluteSize
    local inset = GuiService:GetGuiInset().Y
    local width = math.floor((screen.X - 40) / s / 2) * 2
    local height = math.floor((screen.Y - inset - 40) / s / 2) * 2
    Tween(self.Root, Tweens.Slow, {
        Size = UDim2.fromOffset(width + SHADOW_MARGIN * 2, height + SHADOW_MARGIN * 2),
        Position = UDim2.fromOffset(math.floor(screen.X / 2), math.floor(inset + (screen.Y - inset) / 2)),
    })
end

function Window:Destroy()
    Library:Unload()
end

--==============================================================
-- Popups, context menu and tooltips
--==============================================================

-- Opens a popup of `width` x `height` layout pixels under `anchor`.
function Window:_popup(anchor, width, height, onClose)
    local s = Library.UIScale
    local position = GuiPosition(anchor)
    local size = anchor.AbsoluteSize
    local x = position.X + size.X - width * s
    local y = position.Y + size.Y + 6 * s
    local above = false
    if y + height * s > self.Gui.AbsoluteSize.Y - 8 then
        y = position.Y - (height + 6) * s
        above = true
    end
    return self:_popupAt(x, y, width, height, onClose, above)
end

-- Opens a popup with its top-left at screen point (x, y).
function Window:_popupAt(x, y, width, height, onClose, above)
    self:_closePopup()
    self:_hideTooltip()
    local s = Library.UIScale
    local screen = self.Gui.AbsoluteSize
    x = math.clamp(x, 8, math.max(8, screen.X - width * s - 8))
    y = math.clamp(y, 8, math.max(8, screen.Y - height * s - 8))
    local px = math.floor(x / s + 0.5)
    local py = math.floor(y / s + 0.5)

    -- A button, so clicks on its empty areas do not fall through to the catcher.
    local popup = Bind(New("TextButton", {
        Name = "Popup",
        Position = UDim2.fromOffset(px, py + (above and 6 or -6)),
        Size = UDim2.fromOffset(width, height),
        ZIndex = 51,
        Parent = self.Overlay,
    }), { BackgroundColor3 = "Popup" })
    Corner(9, popup)
    Bind(New("UIStroke", { Parent = popup }), { Color = "PopupStroke" })
    -- The shadow sits in its own frame so the popup's UIPadding does not shift it.
    local shadowHolder = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(px, py),
        Size = UDim2.fromOffset(width, height),
        ZIndex = 50,
        Parent = self.Overlay,
    })
    Shadow(shadowHolder, 10, 9, 50)
    -- Drops into place with a small spring and grows from 96%.
    Spring(popup, { Position = UDim2.fromOffset(px, py) }, 5, 0.75)
    local pop = New("UIScale", { Scale = 0.96, Parent = popup })
    Spring(pop, { Scale = 1 }, 5, 0.65)

    self.Catcher.Visible = true
    self.Popup = { Frame = popup, Shadow = shadowHolder, OnClose = onClose }
    return popup
end

function Window:_closePopup()
    local current = self.Popup
    if not current then
        return
    end
    self.Popup = nil
    self.Catcher.Visible = false
    current.Frame:Destroy()
    current.Shadow:Destroy()
    if current.OnClose then
        SafeCall(current.OnClose)
    end
end

-- Small menu at a screen point: items = { { Text, Callback } }.
function Window:_menuAt(point, items)
    local width = 170
    for _, item in ipairs(items) do
        width = math.max(width, TextWidth(item.Text, 13) + 36)
    end
    local menu = self:_popupAt(point.X + 2, point.Y + 2, width, #items * 24 + 10)
    for index, item in ipairs(items) do
        local button = New("TextButton", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 5 + (index - 1) * 24),
            Size = UDim2.new(1, -10, 0, 24),
            Parent = menu,
        })
        Corner(5, button)
        Bind(button, { BackgroundColor3 = "Accent" })
        local label = New("TextLabel", {
            Text = item.Text,
            TextSize = 13,
            TextColor3 = Library.Theme.Text,
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.new(1, -20, 1, 0),
            Parent = button,
        })
        button.MouseEnter:Connect(function()
            button.BackgroundTransparency = 0
            label.TextColor3 = Library.Theme.AccentText
        end)
        button.MouseLeave:Connect(function()
            button.BackgroundTransparency = 1
            label.TextColor3 = Library.Theme.Text
        end)
        button.Activated:Connect(function()
            self:_closePopup()
            SafeCall(item.Callback)
        end)
    end
    return menu
end

-- Right-click on a row: reset it or copy its value.
function Window:_contextAt(point)
    if self.Popup or self.ActiveDialog or not self.ActiveTab or self.SearchPage.Visible then
        return
    end
    local pagesPosition = GuiPosition(self.Pages)
    local pagesSize = self.Pages.AbsoluteSize
    if point.X < pagesPosition.X or point.Y < pagesPosition.Y or point.X > pagesPosition.X + pagesSize.X or point.Y > pagesPosition.Y + pagesSize.Y then
        return
    end
    for _, element in ipairs(self.SearchIndex) do
        local row = element.Row
        if element.Section.Tab == self.ActiveTab and row and row.Parent and row.Visible and element.Section.Group.Visible then
            local position = GuiPosition(row)
            local size = row.AbsoluteSize
            if point.X >= position.X and point.X <= position.X + size.X and point.Y >= position.Y and point.Y <= position.Y + size.Y then
                self:_openContextMenu(element, point)
                return
            end
        end
    end
end

function Window:_openContextMenu(element, point)
    local strings = Library.Strings
    local items = {}
    if element.Resettable and not element.Disabled and element.DefaultSave ~= nil then
        table.insert(items, {
            Text = strings.ResetToDefault,
            Callback = function()
                element:Reset()
            end,
        })
    end
    local value = element:_display()
    if value ~= nil and value ~= "" then
        table.insert(items, {
            Text = strings.CopyValue,
            Callback = function()
                if setclipboard then
                    setclipboard(value)
                    Library:Notify({ Type = "Success", Title = self.Title, Content = strings.Copied, Duration = 2 })
                else
                    Library:Notify({ Type = "Error", Title = self.Title, Content = strings.NoClipboard })
                end
            end,
        })
    end
    if #items > 0 then
        self:_menuAt(point, items)
    end
end

-- Shows getText() near the pointer after it rests on `object` for a moment.
function Window:_attachTooltip(object, getText)
    local token = 0
    object.MouseEnter:Connect(function()
        token = token + 1
        local mine = token
        task.delay(0.5, function()
            if mine == token and object.Parent and self.Visible and not self.Popup then
                local text = getText()
                if text and text ~= "" then
                    self:_showTooltip(text)
                end
            end
        end)
    end)
    object.MouseLeave:Connect(function()
        token = token + 1
        self:_hideTooltip()
    end)
end

function Window:_showTooltip(text)
    if not self.Tooltip then
        local tip = Bind(New("Frame", {
            Name = "Tooltip",
            AutomaticSize = Enum.AutomaticSize.XY,
            Visible = false,
            ZIndex = 70,
            Parent = self.Overlay,
        }), { BackgroundColor3 = "Popup" })
        Corner(6, tip)
        Bind(New("UIStroke", { Parent = tip }), { Color = "PopupStroke" })
        Pad(tip, 5, 8, 5, 8)
        self.TooltipLabel = FitText(Bind(New("TextLabel", {
            TextSize = 12,
            TextWrapped = true,
            Size = UDim2.fromOffset(100, 15),
            ZIndex = 71,
            Parent = tip,
        }), { TextColor3 = "Text" }))
        self.Tooltip = tip
    end
    local width = math.min(TextWidth(text, 12) + 6, 260)
    self.TooltipLabel.Text = text
    self.TooltipLabel.Size = UDim2.fromOffset(width, self.TooltipLabel.Size.Y.Offset)
    local s = Library.UIScale
    local point = UserInputService:GetMouseLocation()
    local screen = self.Gui.AbsoluteSize
    local x = math.min(point.X + 12, screen.X - (width + 24) * s)
    local y = math.min(point.Y + 18, screen.Y - 40 * s)
    self.Tooltip.Position = UDim2.fromOffset(math.floor(x / s), math.floor(y / s))
    self.Tooltip.Visible = true
end

function Window:_hideTooltip()
    if self.Tooltip then
        self.Tooltip.Visible = false
    end
end

--==============================================================
-- Dialog (macOS alert)
--==============================================================

function Window:Dialog(opts)
    opts = opts or {}
    self:_closePopup()
    if self.ActiveDialog then
        self.ActiveDialog:Destroy()
    end

    local dim = Bind(New("TextButton", {
        Name = "Dialog",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 30,
        Parent = self.Frame,
    }), { BackgroundColor3 = "Overlay" })
    Corner(12, dim)
    Tween(dim, Tweens.Normal, { BackgroundTransparency = Library.Theme.OverlayTransparency })

    -- A macOS sheet: it slides down from under the title bar on a spring.
    -- The clip hides it while it is still above the content area.
    local clip = New("Frame", {
        Name = "SheetClip",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, TITLEBAR),
        Size = UDim2.new(1, 0, 1, -TITLEBAR),
        ClipsDescendants = true,
        ZIndex = 31,
        Parent = dim,
    })
    local hidden = UDim2.new(0.5, 0, 0, -360)
    local box = Bind(New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = hidden,
        Size = UDim2.fromOffset(280, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 31,
        Parent = clip,
    }), { BackgroundColor3 = "Popup" })
    Corner(12, box)
    Bind(New("UIStroke", { Parent = box }), { Color = "PopupStroke" })
    Pad(box, 18, 16, 16, 16)
    List(box, 8, Enum.FillDirection.Vertical, { HorizontalAlignment = Enum.HorizontalAlignment.Center })
    Spring(box, { Position = UDim2.new(0.5, 0, 0, 14) }, 3.6, 0.78)

    local icon = AppIcon(box, 48, opts.Icon or self.Icon, self.IconColor, self.Title, 12)
    icon.LayoutOrder = 1
    icon.ZIndex = 32
    FitText(Bind(New("TextLabel", {
        Text = opts.Title or "",
        FontFace = Fonts.Bold,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, 0, 0, 17),
        LayoutOrder = 2,
        ZIndex = 32,
        Parent = box,
    }), { TextColor3 = "Text" }))
    if opts.Content then
        FitText(Bind(New("TextLabel", {
            Text = opts.Content,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1, 0, 0, 15),
            LayoutOrder = 3,
            ZIndex = 32,
            Parent = box,
        }), { TextColor3 = "SubText" }))
    end

    local buttons = opts.Buttons or { { Title = "OK", Style = "Primary" } }
    local sideBySide = #buttons == 2
    local holder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 4,
        Parent = box,
    })
    Pad(holder, 6, 0, 0, 0)
    List(holder, 8, sideBySide and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical)

    local closed = false
    local function close()
        if closed then
            return
        end
        closed = true
        Spring(box, { Position = hidden }, 4, 1)
        Tween(dim, Tweens.Normal, { BackgroundTransparency = 1 })
        task.delay(0.35, function()
            dim:Destroy()
        end)
        if self.ActiveDialog == dim then
            self.ActiveDialog = nil
        end
    end

    for index, info in ipairs(buttons) do
        local button = PushButton(holder, info.Title or "OK", info.Style, function()
            close()
            SafeCall(info.Callback)
        end)
        button.LayoutOrder = index
        button.ZIndex = 32
        if sideBySide then
            button.Size = UDim2.new(0.5, -4, 0, 28)
        else
            button.Size = UDim2.new(1, 0, 0, 28)
        end
    end

    self.ActiveDialog = dim
    return { Close = close }
end

--==============================================================
-- Tabs and search
--==============================================================

function Window:SetSubtitle(text)
    self.Subtitle = text
    if text and text ~= "" then
        self.SubtitleLabel.Text = self.Title .. " - " .. text
    else
        self.SubtitleLabel.Text = self.Title
    end
end

function Window:AddSidebarHeader(text)
    TabOrder = TabOrder + 1
    local label = Bind(New("TextLabel", {
        Text = text,
        FontFace = Fonts.SemiBold,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 26),
        TextYAlignment = Enum.TextYAlignment.Bottom,
        LayoutOrder = TabOrder,
        Parent = self.TabContent,
    }), { TextColor3 = "Tertiary" })
    Pad(label, 0, 0, 4, 8)
    return label
end

function Window:AddTab(opts)
    if type(opts) == "string" then
        opts = { Title = opts }
    end
    opts = opts or {}
    local order = opts._order
    if not order then
        TabOrder = TabOrder + 1
        order = TabOrder
    end
    local tab = setmetatable({
        Title = opts.Title or "Tab",
        Icon = opts.Icon,
        Window = self,
        Sections = {},
        Order = order,
    }, Tab)
    tab.IconColor = opts.IconColor or IconPalette[(#self.Tabs % #IconPalette) + 1]

    -- The button only paints its hover; the active tab is marked by the
    -- window's sliding selection pill underneath.
    local button = New("TextButton", {
        Name = tab.Title,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        Parent = self.TabContent,
    })
    Corner(7, button)
    Bind(button, { BackgroundColor3 = "SidebarHover" })
    local icon = AppIcon(button, 22, opts.Icon, tab.IconColor, tab.Title, 6)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.Position = UDim2.new(0, 6, 0.5, 0)
    local label = Bind(New("TextLabel", {
        Text = tab.Title,
        FontFace = Fonts.Medium,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = UDim2.fromOffset(36, 0),
        Size = UDim2.new(1, -42, 1, 0),
        Parent = button,
    }), {
        TextColor3 = function(theme)
            return self.ActiveTab == tab and theme.AccentText or theme.Text
        end,
    })

    -- The page stays outside the window until the tab is first opened, so a
    -- script with many tabs does not lay out and measure text it never shows.
    local page = Bind(New("ScrollingFrame", {
        Name = tab.Title,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
    }), { ScrollBarImageColor3 = "Scrollbar" })
    Pad(page, 18, 20, 18, 20)
    List(page, 20)
    page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if self.Popup then
            self:_closePopup()
        end
        self:_hideTooltip()
    end)

    button.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(button, Tweens.Fast, { BackgroundTransparency = 0 })
        end
    end)
    button.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(button, Tweens.Fast, { BackgroundTransparency = 1 })
        end
    end)
    button.Activated:Connect(function()
        self:SelectTab(tab)
    end)

    tab.Button = button
    tab.Label = label
    tab.Page = page
    if opts._index then
        table.insert(self.Tabs, math.min(opts._index, #self.Tabs + 1), tab)
    else
        table.insert(self.Tabs, tab)
    end
    if not self.ActiveTab then
        self:SelectTab(tab)
    end
    return tab
end

function Window:SelectTab(tab)
    if type(tab) == "number" then
        tab = self.Tabs[tab]
    end
    if not tab then
        return
    end
    if self.SearchBox.Text ~= "" then
        self.SearchBox.Text = ""
        self:_search("")
    end
    if self.ActiveTab == tab then
        return
    end
    self:_closePopup()
    local previous = self.ActiveTab
    self.ActiveTab = tab
    if not tab.Page.Parent then
        tab.Page.Parent = self.Pages
    end
    local direction = 1
    if previous then
        previous.Page.Visible = false
        Refresh(previous.Label)
        Tween(previous.Button, Tweens.Fast, { BackgroundTransparency = 1 })
        local from, to = table.find(self.Tabs, previous), table.find(self.Tabs, tab)
        if from and to and to < from then
            direction = -1
        end
    end
    Refresh(tab.Label)
    tab.Button.BackgroundTransparency = 1
    self.HeaderTitle.Text = tab.Title
    self:_moveSelection(previous ~= nil)

    -- The page comes up from below when moving down the list and drops
    -- from above when moving up; its rows then fade in one by one.
    local page = tab.Page
    page.Visible = true
    page.Position = UDim2.fromOffset(0, 16 * direction)
    Spring(page, { Position = UDim2.fromOffset(0, 0) }, 4, 0.85)
    if previous then
        self:_staggerRows(tab)
    end
end

-- Moves the accent pill under the active tab's button.
function Window:_moveSelection(animate)
    local tab = self.ActiveTab
    local selection = self.Selection
    if not tab or not tab.Button.Parent then
        selection.Visible = false
        return
    end
    local list = self.TabList
    local scale = EffectiveScale(list)
    local offset = (tab.Button.AbsolutePosition - list.AbsolutePosition) / scale + list.CanvasPosition
    local size = tab.Button.AbsoluteSize / scale
    if size.X <= 0 then
        return
    end
    local goal = {
        Position = UDim2.fromOffset(math.floor(offset.X + 0.5), math.floor(offset.Y + 0.5)),
        Size = UDim2.fromOffset(math.floor(size.X + 0.5), math.floor(size.Y + 0.5)),
    }
    if animate and selection.Visible then
        Spring(selection, goal, 4.5, 0.78)
    else
        StopSpring(selection, "Position")
        StopSpring(selection, "Size")
        selection.Position = goal.Position
        selection.Size = goal.Size
    end
    selection.Visible = true
end

-- Rows of a freshly opened tab appear one after another: a cover in the
-- group's color fades away while the text slides in from the side.
function Window:_staggerRows(tab)
    local count = 0
    for _, section in ipairs(tab.Sections) do
        if section.Holder.Visible and section.Group.Visible then
            for _, element in ipairs(section.Elements) do
                local row = element.Row
                if count < 18 and row and row.Parent and row.Visible and element.TextBlock then
                    count = count + 1
                    local cover = Bind(New("Frame", {
                        Name = "Reveal",
                        Size = UDim2.new(1, 20, 1, 14),
                        Position = UDim2.fromOffset(-10, -7),
                        ZIndex = 40,
                        Parent = row,
                    }), { BackgroundColor3 = "Group" })
                    Corner(7, cover)
                    local block = element.TextBlock
                    element.TextOrigin = element.TextOrigin or block.Position
                    local origin = element.TextOrigin
                    block.Position = origin + UDim2.fromOffset(12, 0)
                    task.delay((count - 1) * 0.025, function()
                        Tween(cover, Tweens.Normal, { BackgroundTransparency = 1 })
                        Spring(block, { Position = origin }, 4, 0.9)
                        task.delay(0.3, function()
                            cover:Destroy()
                        end)
                    end)
                end
            end
        end
    end
end

-- Fills the results page with every element whose title, description,
-- section or tab contains `query`. An empty query goes back to the tab.
function Window:_search(query)
    local page = self.SearchPage
    for _, child in ipairs(page:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    if query == "" then
        if page.Visible then
            page.Visible = false
            if self.ActiveTab then
                self.ActiveTab.Page.Visible = true
                self.HeaderTitle.Text = self.ActiveTab.Title
            end
        end
        return
    end
    self:_closePopup()
    if self.ActiveTab then
        self.ActiveTab.Page.Visible = false
    end
    page.Visible = true
    page.CanvasPosition = Vector2.zero
    self.HeaderTitle.Text = Library.Strings.SearchResults

    local results = {}
    for _, element in ipairs(self.SearchIndex) do
        if element.Row and element.Row.Parent and element.Row.Visible and element.Title and element.Title ~= "" then
            local section = element.Section
            local haystack = string.lower(element.Title .. " " .. (element.Description or "") .. " " .. (section.Title or "") .. " " .. section.Tab.Title)
            if string.find(haystack, query, 1, true) then
                table.insert(results, element)
                if #results >= 60 then
                    break
                end
            end
        end
    end

    if #results == 0 then
        FitText(Bind(New("TextLabel", {
            Text = string.format(Library.Strings.NoResults, query),
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1, 0, 0, 16),
            Parent = page,
        }), { TextColor3 = "SubText" }))
        return
    end

    local group = Bind(New("Frame", {
        Name = "Results",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = page,
    }), { BackgroundColor3 = "Group" })
    Corner(10, group)
    Bind(New("UIStroke", { Parent = group }), { Color = "GroupStroke" })
    List(group, 0)

    for index, element in ipairs(results) do
        local section = element.Section
        local tab = section.Tab
        local row = New("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 46),
            LayoutOrder = index,
            Parent = group,
        })
        if index > 1 then
            Bind(New("Frame", { Size = UDim2.new(1, -46, 0, 1), Position = UDim2.fromOffset(46, 0), Parent = row }), { BackgroundColor3 = "Separator" })
        end
        local highlight = Bind(New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(4, 4),
            Size = UDim2.new(1, -8, 1, -8),
            ZIndex = 0,
            Parent = row,
        }), { BackgroundColor3 = "RowHover" })
        Corner(7, highlight)
        local icon = AppIcon(row, 22, tab.Icon, tab.IconColor, tab.Title, 6)
        icon.Position = UDim2.fromOffset(14, 12)
        Bind(New("TextLabel", {
            Text = element.Title,
            TextSize = 14,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.fromOffset(46, 7),
            Size = UDim2.new(1, -80, 0, 17),
            Parent = row,
        }), { TextColor3 = "Text" })
        local path = tab.Title
        if section.Title and section.Title ~= "" then
            path = path .. " › " .. section.Title
        end
        Bind(New("TextLabel", {
            Text = path,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.fromOffset(46, 25),
            Size = UDim2.new(1, -80, 0, 15),
            Parent = row,
        }), { TextColor3 = "SubText" })
        local chevronHolder = New("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            Parent = row,
        })
        for _, bar in ipairs(Chevron(chevronHolder, UDim2.fromScale(0.5, 0.5), 9, 2, "Right")) do
            Bind(bar, { BackgroundColor3 = "Tertiary" })
        end
        row.MouseEnter:Connect(function()
            highlight.BackgroundTransparency = 0
        end)
        row.MouseLeave:Connect(function()
            highlight.BackgroundTransparency = 1
        end)
        row.Activated:Connect(function()
            self:Reveal(element)
        end)
        if index <= 12 then
            -- Results fade in one after another, like the rows of a tab.
            local cover = Bind(New("Frame", {
                Position = UDim2.fromOffset(4, 4),
                Size = UDim2.new(1, -8, 1, -8),
                ZIndex = 40,
                Parent = row,
            }), { BackgroundColor3 = "Group" })
            Corner(7, cover)
            task.delay((index - 1) * 0.025, function()
                Tween(cover, Tweens.Normal, { BackgroundTransparency = 1 })
                task.delay(0.3, function()
                    cover:Destroy()
                end)
            end)
        end
    end
end

-- Switches to the element's tab, scrolls it into view and flashes its row.
function Window:Reveal(element)
    local section = element.Section
    if section.Collapsed then
        section:SetCollapsed(false)
    end
    self:SelectTab(section.Tab)
    task.spawn(function()
        task.wait()
        task.wait()
        local page = section.Tab.Page
        local row = element.Row
        if not row.Parent then
            return
        end
        local scale = EffectiveScale(page)
        local offset = (row.AbsolutePosition.Y - page.AbsolutePosition.Y) / scale + page.CanvasPosition.Y - 60
        Tween(page, Tweens.Normal, { CanvasPosition = Vector2.new(0, math.max(0, offset)) })
        local flash = Bind(New("Frame", {
            Name = "Flash",
            BackgroundTransparency = 0.75,
            Size = UDim2.new(1, 20, 1, 14),
            Position = UDim2.fromOffset(-10, -7),
            ZIndex = 0,
            Parent = row,
        }), { BackgroundColor3 = "Accent" })
        Corner(7, flash)
        task.wait(0.35)
        local fade = Tween(flash, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
        fade.Completed:Connect(function()
            flash:Destroy()
        end)
    end)
end

--==============================================================
-- Notification center
--
-- Every banner is kept in Library.NotificationHistory. The bell in the
-- window header slides this panel in from the right to show them again.
--==============================================================

local Center -- the open notification center, if any

local function RelativeTime(stamp)
    local seconds = os.time() - stamp
    local strings = Library.Strings
    if seconds < 60 then
        return strings.Now
    elseif seconds < 3600 then
        return string.format(strings.MinutesAgo, math.floor(seconds / 60))
    end
    return string.format(strings.HoursAgo, math.floor(seconds / 3600))
end

local function FillCenter()
    if not Center then
        return
    end
    local list = Center.List
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    local history = Library.NotificationHistory
    if #history == 0 then
        Bind(New("TextLabel", {
            Text = Library.Strings.NoNotifications,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1, 0, 0, 60),
            Parent = list,
        }), { TextColor3 = "SubText" })
        return
    end
    for index, entry in ipairs(history) do
        local card = Bind(New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = index,
            Parent = list,
        }), { BackgroundColor3 = "Group" })
        Corner(10, card)
        Bind(New("UIStroke", { Parent = card }), { Color = "GroupStroke" })
        Pad(card, 10, 12, 10, 10)
        local icon = AppIcon(card, 28, entry.Icon, entry.IconColor, entry.AppTitle, 7)
        StatusBadge(icon, entry.Type)
        local body = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(38, 0),
            Size = UDim2.new(1, -38, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = card,
        })
        List(body, 2)
        local titleRow = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1, Parent = body })
        Bind(New("TextLabel", {
            Text = entry.Title or "",
            FontFace = Fonts.SemiBold,
            TextSize = 13,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Size = UDim2.new(1, -80, 1, 0),
            Parent = titleRow,
        }), { TextColor3 = "Text" })
        Bind(New("TextLabel", {
            Text = RelativeTime(entry.Time),
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.new(0, 80, 1, 0),
            Parent = titleRow,
        }), { TextColor3 = "Tertiary" })
        if entry.Content and entry.Content ~= "" then
            FitText(Bind(New("TextLabel", {
                Text = entry.Content,
                TextSize = 12,
                TextWrapped = true,
                Size = UDim2.new(1, 0, 0, 15),
                LayoutOrder = 2,
                Parent = body,
            }), { TextColor3 = "SubText" }))
        end
    end
end

function Window:OpenNotificationCenter()
    if Center or Library.Unloaded then
        return
    end
    local gui = self.Gui
    local s = Library.UIScale
    local inset = GuiService:GetGuiInset().Y
    local screen = gui.AbsoluteSize
    local shown = UDim2.new(1, -14, 0, inset + 8)

    local catcher = New("TextButton", {
        Name = "CenterCatcher",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 64,
        Parent = gui,
    })
    local mover = New("Frame", {
        Name = "NotificationCenter",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = shown + UDim2.fromOffset(420 * s, 0),
        Size = UDim2.fromOffset(360, math.floor((screen.Y - inset - 24) / s)),
        ZIndex = 65,
        Parent = gui,
    })
    ScaleTarget(New("UIScale", { Parent = mover }))
    Shadow(mover, 14, 14, 65)
    local panel = Bind(New("Frame", {
        Size = UDim2.fromScale(1, 1),
        ZIndex = 66,
        Parent = mover,
    }), { BackgroundColor3 = "Popup" })
    Corner(14, panel)
    Bind(New("UIStroke", { Parent = panel }), { Color = "PopupStroke" })
    Bind(New("TextLabel", {
        Text = Library.Strings.Notifications,
        FontFace = Fonts.Bold,
        TextSize = 15,
        Position = UDim2.fromOffset(16, 16),
        Size = UDim2.new(1, -140, 0, 18),
        Parent = panel,
    }), { TextColor3 = "Text" })
    local clear = PushButton(panel, Library.Strings.ClearAll, nil, function()
        Library:ClearNotifications()
    end)
    clear.AnchorPoint = Vector2.new(1, 0)
    clear.Position = UDim2.new(1, -14, 0, 13)
    local list = Bind(New("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 1, -56),
        Parent = panel,
    }), { ScrollBarImageColor3 = "Scrollbar" })
    Pad(list, 0, 12, 12, 12)
    List(list, 8)

    Center = { Window = self, Mover = mover, Catcher = catcher, List = list, Shown = shown }
    catcher.MouseButton1Down:Connect(function()
        self:CloseNotificationCenter()
    end)
    Spring(mover, { Position = shown }, 3.8, 0.82)
    UnreadCount = 0
    UpdateBellBadges()
    FillCenter()
end

function Window:CloseNotificationCenter()
    local current = Center
    if not current then
        return
    end
    Center = nil
    current.Catcher:Destroy()
    Spring(current.Mover, { Position = current.Shown + UDim2.fromOffset(420 * Library.UIScale, 0) }, 4, 1)
    task.delay(0.45, function()
        current.Mover:Destroy()
    end)
end

function Window:ToggleNotificationCenter()
    if Center then
        self:CloseNotificationCenter()
    else
        self:OpenNotificationCenter()
    end
end

--==============================================================
-- Command palette (Ctrl+K)
--
-- A Spotlight-style field over the game: type part of a tab or option
-- name, pick with the arrows or the mouse, Enter runs it. Toggles flip,
-- buttons run, everything else is revealed in the window.
--==============================================================

local Palette -- the open palette, if any
local PALETTE_WIDTH, PALETTE_ROW, PALETTE_ROWS, PALETTE_MAX = 560, 44, 8, 60

-- Items a script adds beside the windows' own: each provider returns a
-- list of { Title, Path, Icon, IconColor, Hint, Keywords, Run }, asked
-- again on every keystroke, and the palette keeps the ones that match.
local PaletteProviders = {}

function Library:AddPaletteProvider(provider)
    table.insert(PaletteProviders, provider)
end

-- The tabs and options of one window. With several windows the path
-- starts with the window's title.
local function WindowItems(window, items, matches)
    local strings = Library.Strings
    local prefix = #Library.Windows > 1 and window.Title ~= "" and (window.Title .. " › ") or ""
    local function show(callback)
        return function()
            window:SetVisible(true)
            callback()
        end
    end

    for _, tab in ipairs(window.Tabs) do
        if matches(tab.Title .. " " .. prefix) then
            table.insert(items, {
                Title = tab.Title,
                Path = prefix .. strings.Tab,
                Tab = tab,
                Hint = strings.Show,
                Run = show(function()
                    window:SelectTab(tab)
                end),
            })
        end
    end

    for _, element in ipairs(window.SearchIndex) do
        local section = element.Section
        local tab = section.Tab
        if element.Row and element.Row.Visible and element.Title and element.Title ~= "" and not element.Disabled then
            local path = prefix .. tab.Title
            if section.Title and section.Title ~= "" then
                path = path .. " › " .. section.Title
            end
            if matches(element.Title .. " " .. (element.Description or "") .. " " .. path) then
                if element.Type == "Toggle" or element.Type == "Checkbox" then
                    table.insert(items, {
                        Title = element.Title,
                        Path = path,
                        Tab = tab,
                        Hint = element.Value and strings.On or strings.Off,
                        Run = function()
                            element:SetValue(not element.Value)
                        end,
                    })
                elseif element.Type == "Button" and element.Actions then
                    for _, action in ipairs(element.Actions) do
                        table.insert(items, {
                            Title = element.Title .. " · " .. action.Text,
                            Path = path,
                            Tab = tab,
                            Hint = strings.Run,
                            Run = function()
                                SafeCall(action.Callback)
                            end,
                        })
                    end
                elseif element.Type == "Button" then
                    table.insert(items, {
                        Title = element.Title,
                        Path = path,
                        Tab = tab,
                        Hint = strings.Run,
                        Run = function()
                            element:_fire()
                        end,
                    })
                else
                    table.insert(items, {
                        Title = element.Title,
                        Path = path,
                        Tab = tab,
                        Hint = strings.Show,
                        Run = show(function()
                            window:Reveal(element)
                        end),
                    })
                end
            end
        end
        if #items >= PALETTE_MAX then
            break
        end
    end
end

local function PaletteItems(query)
    local items = {}
    query = string.lower(Trim(query))
    local function matches(text)
        return query == "" or string.find(string.lower(text), query, 1, true) ~= nil
    end
    for _, provider in ipairs(PaletteProviders) do
        local ok, list = pcall(provider)
        if ok and type(list) == "table" then
            for _, item in ipairs(list) do
                if #items < PALETTE_MAX and matches(tostring(item.Title) .. " " .. (item.Path or "") .. " " .. (item.Keywords or "")) then
                    table.insert(items, item)
                end
            end
        end
    end
    for _, window in ipairs(Library.Windows) do
        if #items >= PALETTE_MAX then
            break
        end
        WindowItems(window, items, matches)
    end
    return items
end

function Window:ClosePalette()
    local current = Palette
    if not current then
        return
    end
    Palette = nil
    current.Connection:Disconnect()
    current.Mover:Destroy()
    Tween(current.Catcher, Tweens.Fast, { BackgroundTransparency = 1 })
    task.delay(0.2, function()
        current.Catcher:Destroy()
    end)
end

function Window:OpenPalette()
    if Library.Unloaded then
        return
    end
    if Palette then
        Palette.Box:CaptureFocus()
        return
    end
    local strings = Library.Strings
    local gui = self.Gui
    local screen = gui.AbsoluteSize

    local catcher = New("TextButton", {
        Name = "PaletteCatcher",
        BackgroundColor3 = rgb(0, 0, 0),
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 80,
        Parent = gui,
    })
    Tween(catcher, Tweens.Normal, { BackgroundTransparency = 0.8 })
    local top = math.floor(screen.Y * 0.2)
    local mover = New("Frame", {
        Name = "CommandPalette",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, top - 12),
        Size = UDim2.fromOffset(PALETTE_WIDTH, 52),
        ZIndex = 81,
        Parent = gui,
    })
    ScaleTarget(New("UIScale", { Parent = mover }))
    Spring(mover, { Position = UDim2.new(0.5, 0, 0, top) }, 4.5, 0.75)
    Shadow(mover, 18, 14, 81)
    local panel = Bind(New("Frame", {
        Size = UDim2.fromScale(1, 1),
        ZIndex = 82,
        Parent = mover,
    }), { BackgroundColor3 = "Popup" })
    Corner(14, panel)
    Bind(New("UIStroke", { Parent = panel }), { Color = "PopupStroke" })
    Bind(New("ImageLabel", {
        Image = Library.Icons.search,
        Position = UDim2.fromOffset(18, 16),
        Size = UDim2.fromOffset(20, 20),
        Parent = panel,
    }), { ImageColor3 = "SubText" })
    local box = Bind(New("TextBox", {
        Text = "",
        PlaceholderText = strings.CommandPlaceholder,
        TextSize = 18,
        Position = UDim2.fromOffset(50, 0),
        Size = UDim2.new(1, -66, 0, 52),
        Parent = panel,
    }), { TextColor3 = "Text", PlaceholderColor3 = "Tertiary" })
    local divider = Bind(New("Frame", {
        Position = UDim2.fromOffset(0, 52),
        Size = UDim2.new(1, 0, 0, 1),
        Parent = panel,
    }), { BackgroundColor3 = "Separator" })
    local results = Bind(New("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 58),
        Size = UDim2.new(1, 0, 1, -64),
        ScrollBarThickness = 2,
        Parent = panel,
    }), { ScrollBarImageColor3 = "Scrollbar" })
    Pad(results, 0, 8, 0, 8)
    List(results, 0)

    local state = { Window = self, Catcher = catcher, Mover = mover, Box = box, Selected = 1, Items = {}, Rows = {} }
    Palette = state

    local function run(item)
        self:ClosePalette()
        if item and item.Run then
            Spawn(item.Run)
        end
    end

    local function paint()
        local theme = Library.Theme
        for index, parts in ipairs(state.Rows) do
            local selected = index == state.Selected
            parts.Row.BackgroundTransparency = selected and 0 or 1
            parts.Title.TextColor3 = selected and theme.AccentText or theme.Text
            parts.Path.TextColor3 = selected and theme.AccentText or theme.SubText
            parts.Hint.TextColor3 = selected and theme.AccentText or theme.Tertiary
        end
    end

    local function scrollToSelected()
        local top = (state.Selected - 1) * PALETTE_ROW
        local view = results.AbsoluteSize.Y / EffectiveScale(results)
        local canvas = results.CanvasPosition.Y
        if top < canvas then
            results.CanvasPosition = Vector2.new(0, top)
        elseif top + PALETTE_ROW > canvas + view then
            results.CanvasPosition = Vector2.new(0, top + PALETTE_ROW - view)
        end
    end

    local function render()
        for _, child in ipairs(results:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        state.Rows = {}
        state.Items = PaletteItems(box.Text)
        state.Selected = math.clamp(state.Selected, 1, math.max(#state.Items, 1))
        local count = #state.Items
        divider.Visible = true
        if count == 0 then
            Bind(New("TextLabel", {
                Text = strings.NoCommands,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Center,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = results,
            }), { TextColor3 = "SubText" })
        end
        for index, item in ipairs(state.Items) do
            local row = New("TextButton", {
                Size = UDim2.new(1, 0, 0, PALETTE_ROW),
                BackgroundTransparency = 1,
                LayoutOrder = index,
                Parent = results,
            })
            Corner(8, row)
            Bind(row, { BackgroundColor3 = "Accent" })
            local tab = item.Tab or {}
            local icon = AppIcon(row, 26, item.Icon or tab.Icon, item.IconColor or tab.IconColor, tab.Title or item.Title, 7)
            icon.Position = UDim2.fromOffset(10, 9)
            local title = New("TextLabel", {
                Text = item.Title,
                TextSize = 14,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.fromOffset(46, 6),
                Size = UDim2.new(1, -150, 0, 17),
                Parent = row,
            })
            local path = New("TextLabel", {
                Text = item.Path,
                TextSize = 12,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.fromOffset(46, 23),
                Size = UDim2.new(1, -150, 0, 15),
                Parent = row,
            })
            local hint = New("TextLabel", {
                Text = item.Hint or "",
                FontFace = Fonts.Medium,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(90, 16),
                Parent = row,
            })
            row.MouseEnter:Connect(function()
                state.Selected = index
                paint()
            end)
            row.MouseButton1Down:Connect(function()
                run(item)
            end)
            state.Rows[index] = { Row = row, Title = title, Path = path, Hint = hint }
        end
        local visible = math.min(math.max(count, 1), PALETTE_ROWS)
        local height = 52 + (count > 0 and visible * PALETTE_ROW + 12 or 52)
        mover.Size = UDim2.fromOffset(PALETTE_WIDTH, height)
        paint()
    end

    box:GetPropertyChangedSignal("Text"):Connect(function()
        state.Selected = 1
        results.CanvasPosition = Vector2.zero
        render()
    end)
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            run(state.Items[state.Selected])
        else
            -- A click on a row also takes focus away; give it a moment to land.
            task.delay(0.15, function()
                if Palette == state then
                    self:ClosePalette()
                end
            end)
        end
    end)
    catcher.MouseButton1Down:Connect(function()
        self:ClosePalette()
    end)
    state.Connection = UserInputService.InputBegan:Connect(function(input)
        local count = #state.Items
        if count == 0 then
            return
        end
        if input.KeyCode == Enum.KeyCode.Down then
            state.Selected = state.Selected % count + 1
        elseif input.KeyCode == Enum.KeyCode.Up then
            state.Selected = (state.Selected - 2) % count + 1
        else
            return
        end
        paint()
        scrollToSelected()
    end)

    render()
    box:CaptureFocus()
end

--==============================================================
-- Settings tab (appearance, overlays, configs)
--==============================================================

local ScaleChoices = { 0.8, 0.9, 1, 1.1, 1.25, 1.5 }

function Window:AddSettingsTab(opts)
    self.SettingsOptions = opts or {}
    self.SettingsTab = self:_buildSettings(self.SettingsOptions)
    return self.SettingsTab
end

-- Rebuilt in place when the language changes, so every label follows it.
function Window:_rebuildSettings()
    local old = self.SettingsTab
    if not old or not old.Button.Parent then
        return
    end
    local wasActive = self.ActiveTab == old
    local scroll = old.Page.CanvasPosition
    local index = table.find(self.Tabs, old)
    if wasActive then
        -- Otherwise Destroy would jump to the first tab before the new one appears.
        self.ActiveTab = nil
    end
    old:Destroy()
    local tab = self:_buildSettings(self.SettingsOptions, old.Order, index)
    self.SettingsTab = tab
    if wasActive then
        self:SelectTab(tab)
        tab.Page.CanvasPosition = scroll
    end
end

local function ScaleLabel(setting)
    if type(setting) ~= "number" then
        return Library.Strings.Auto
    end
    return math.floor(setting * 100 + 0.5) .. "%"
end

-- Keeps the Settings tab in step when a setting changes from code.
local function SyncSettings(name, value)
    for _, window in ipairs(Library.Windows) do
        local controls = window.SettingsControls
        local control = controls and controls[name]
        if control and control.Row.Parent then
            control:SetValue(value, true)
        end
    end
end

function Window:_buildSettings(opts, order, index)
    local strings = Library.Strings
    local tab = self:AddTab({
        Title = opts.Title or strings.Settings,
        Icon = opts.Icon or "settings",
        IconColor = opts.IconColor or rgb(142, 142, 147),
        _order = order,
        _index = index,
    })

    local controls = {}
    self.SettingsControls = controls

    local appearance = tab:AddSection(strings.Appearance)
    controls.Theme = appearance:AddSegmented({
        Title = strings.Theme,
        Values = { strings.Light, strings.Dark },
        Default = Library.ThemeName == "Light" and strings.Light or strings.Dark,
        Callback = function(value)
            Library:SetTheme(value == strings.Light and "Light" or "Dark")
        end,
    })
    appearance:_addAccentRow(strings.AccentColor)

    local scaleValues = { strings.Auto }
    for _, choice in ipairs(ScaleChoices) do
        table.insert(scaleValues, ScaleLabel(choice))
    end
    controls.Scale = appearance:AddDropdown({
        Title = strings.InterfaceSize,
        Description = strings.InterfaceSizeDescription,
        Values = scaleValues,
        Default = ScaleLabel(Library.ScaleSetting),
        Width = 120,
        Callback = function(value)
            if value == strings.Auto then
                Library:SetScale("Auto")
            else
                Library:SetScale(tonumber(string.match(value, "%d+")) / 100)
            end
        end,
    })

    local languageValues = {}
    local currentLanguage
    for _, entry in ipairs(Library.LanguageNames) do
        table.insert(languageValues, entry.Name)
        if entry.Code == Library.Language then
            currentLanguage = entry.Name
        end
    end
    appearance:AddDropdown({
        Title = strings.Language,
        Values = languageValues,
        Default = currentLanguage,
        Width = 140,
        Callback = function(value)
            for _, entry in ipairs(Library.LanguageNames) do
                if entry.Name == value then
                    Library:SetLanguage(entry.Code)
                end
            end
        end,
    })
    controls.ToggleKey = appearance:AddKeybind({
        Title = strings.ToggleKey,
        Description = strings.ToggleKeyDescription,
        Default = Library.ToggleKey,
        Mode = "Always",
        AllowModifiers = false,
        _internal = true,
        ChangedCallback = function(key)
            Library:SetToggleKey(key)
        end,
    })

    local overlays = tab:AddSection(strings.Overlays)
    controls.Watermark = overlays:AddToggle({
        Title = strings.Watermark,
        Description = strings.WatermarkDescription,
        Default = Library.ShowWatermark,
        Callback = function(value)
            Library:SetWatermark(value)
        end,
    })
    controls.KeybindList = overlays:AddToggle({
        Title = strings.KeybindList,
        Description = strings.KeybindListDescription,
        Default = Library.ShowKeybinds,
        Callback = function(value)
            Library:SetKeybindList(value)
        end,
    })
    controls.HideToDock = overlays:AddToggle({
        Title = strings.DockTile,
        Description = strings.DockTileDescription,
        Default = Library.HideToDock,
        Callback = function(value)
            Library:SetHideToDock(value)
        end,
    })
    controls.Blur = overlays:AddToggle({
        Title = strings.Blur,
        Description = strings.BlurDescription,
        Default = Library.BlurBackground,
        Callback = function(value)
            Library:SetBlur(value)
        end,
    })

    local configs = tab:AddSection(strings.Configs)
    local nameInput = configs:AddInput({
        Title = strings.ConfigName,
        Placeholder = strings.ConfigNamePlaceholder,
    })
    local list = configs:AddDropdown({
        Title = strings.ConfigList,
        Values = Library:ListConfigs(),
        AllowNone = true,
    })

    local function refresh()
        list:SetValues(Library:ListConfigs())
    end

    local function notify(content, kind)
        Library:Notify({ Type = kind, Title = strings.Configs, Content = content })
    end

    configs:AddButton({
        Title = strings.ConfigActions,
        Description = strings.ConfigActionsDescription,
        Buttons = {
            {
                Text = strings.Save,
                Style = "Primary",
                Callback = function()
                    local name = Trim(nameInput.Value)
                    if name == "" then
                        name = list.Value
                    end
                    if not name or name == "" then
                        notify(strings.EnterConfigName, "Warning")
                        return
                    end
                    if Library:SaveConfig(name) then
                        refresh()
                        list:SetValue(name, true)
                        notify(string.format(strings.ConfigSaved, name), "Success")
                    end
                end,
            },
            {
                Text = strings.Load,
                Callback = function()
                    if not list.Value then
                        notify(strings.PickConfig, "Warning")
                        return
                    end
                    if Library:LoadConfig(list.Value) then
                        notify(string.format(strings.ConfigLoaded, list.Value), "Success")
                    else
                        notify(string.format(strings.ConfigLoadFailed, list.Value), "Error")
                    end
                end,
            },
            {
                Text = strings.Delete,
                Style = "Destructive",
                Callback = function()
                    local name = list.Value
                    if not name then
                        notify(strings.PickConfig, "Warning")
                        return
                    end
                    Library:DeleteConfig(name)
                    refresh()
                    notify(string.format(strings.ConfigDeleted, name), "Success")
                end,
            },
        },
    })

    local autoload
    local function autoloadText()
        return string.format(strings.AutoloadCurrent, Library:GetAutoload() or strings.NotSet)
    end
    autoload = configs:AddButton({
        Title = strings.Autoload,
        Description = autoloadText(),
        Buttons = {
            {
                Text = strings.Set,
                Callback = function()
                    if not list.Value then
                        notify(strings.PickConfig, "Warning")
                        return
                    end
                    Library:SetAutoload(list.Value)
                    autoload:SetDescription(autoloadText())
                end,
            },
            {
                Text = strings.Clear,
                Callback = function()
                    Library:SetAutoload(nil)
                    autoload:SetDescription(autoloadText())
                end,
            },
        },
    })

    configs:AddButton({
        Title = strings.ShareConfig,
        Description = strings.ShareConfigDescription,
        Buttons = {
            {
                Text = strings.Copy,
                Callback = function()
                    if not setclipboard then
                        notify(strings.NoClipboard, "Error")
                        return
                    end
                    setclipboard(Library:ExportConfig())
                    notify(strings.Copied, "Success")
                end,
            },
        },
    })
    local importInput
    importInput = configs:AddInput({
        Title = strings.ImportConfig,
        Placeholder = strings.ImportConfigPlaceholder,
        Callback = function(text)
            if Trim(text) == "" then
                return
            end
            if Library:ImportConfig(text) then
                notify(strings.ConfigImported, "Success")
            else
                notify(strings.ConfigImportFailed, "Error")
            end
            importInput:SetValue("", true)
        end,
    })

    local scriptSection = tab:AddSection(strings.Script)
    scriptSection:AddButton({
        Title = strings.ResetAll,
        Description = strings.ResetAllDescription,
        Buttons = {
            {
                Text = strings.Reset,
                Callback = function()
                    self:Dialog({
                        Title = strings.ResetAllTitle,
                        Content = strings.ResetAllContent,
                        Buttons = {
                            {
                                Title = strings.Reset,
                                Style = "Destructive",
                                Callback = function()
                                    Library:ResetAll()
                                end,
                            },
                            { Title = strings.Cancel, Style = "Primary" },
                        },
                    })
                end,
            },
        },
    })
    scriptSection:AddButton({
        Title = strings.Unload,
        Description = strings.UnloadDescription,
        Buttons = {
            {
                Text = strings.Unload,
                Style = "Destructive",
                Callback = function()
                    self:Close()
                end,
            },
        },
    })
    return tab
end

--==============================================================
-- Notifications (macOS banners)
--==============================================================

function Library:Notify(opts)
    if type(opts) == "string" then
        opts = { Content = opts }
    end
    opts = opts or {}
    local gui = GetScreenGui()
    if not NotifyHolder or not NotifyHolder.Parent then
        NotifyHolder = New("Frame", {
            Name = "Notifications",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -14, 0, GuiService:GetGuiInset().Y + 8),
            Size = UDim2.new(0, 340, 1, -80),
            ZIndex = 60,
            Parent = gui,
        })
        ScaleTarget(New("UIScale", { Parent = NotifyHolder }))
        List(NotifyHolder, 10)
    end

    local window = self.Windows[1]
    NotifyCount = NotifyCount + 1
    local slot = New("Frame", {
        Name = "Notification",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = -NotifyCount,
        Parent = NotifyHolder,
    })
    -- The mover slides in from the right; it carries the banner and its shadow.
    -- Its height is copied from the banner instead of AutomaticSize, which
    -- would measure the scale-sized shadow layers against the whole screen.
    local mover = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.fromOffset(380, 0),
        Parent = slot,
    })
    Shadow(mover, 10, 14, 0)
    local banner = Bind(New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 1,
        Parent = mover,
    }), { BackgroundColor3 = "Popup" })
    local function syncHeight()
        mover.Size = UDim2.new(1, 0, 0, banner.AbsoluteSize.Y / EffectiveScale(banner))
    end
    banner:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHeight)
    syncHeight()
    Corner(14, banner)
    Bind(New("UIStroke", { Parent = banner }), { Color = "PopupStroke" })
    Pad(banner, 12, 14, 12, 12)

    -- Like macOS, the banner shows the app's icon; a badge marks the type.
    local icon = AppIcon(banner, 34, opts.Icon or (window and window.Icon), opts.IconColor or (window and window.IconColor), (window and window.Title) or opts.Title or "!", 8)
    icon.ZIndex = 2
    StatusBadge(icon, opts.Type)

    -- Remember it for the notification center.
    table.insert(self.NotificationHistory, 1, {
        Title = opts.Title or (window and window.Title) or "",
        Content = opts.Content,
        Type = opts.Type,
        Icon = opts.Icon or (window and window.Icon),
        IconColor = opts.IconColor or (window and window.IconColor),
        AppTitle = (window and window.Title) or opts.Title or "!",
        Time = os.time(),
    })
    if #self.NotificationHistory > 50 then
        table.remove(self.NotificationHistory)
    end
    if Center then
        FillCenter()
    else
        UnreadCount = UnreadCount + 1
        UpdateBellBadges()
    end

    local body = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(46, 0),
        Size = UDim2.new(1, -46, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 2,
        Parent = banner,
    })
    List(body, 2)
    local titleRow = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 17), LayoutOrder = 1, Parent = body })
    Bind(New("TextLabel", {
        Text = opts.Title or (window and window.Title) or "",
        FontFace = Fonts.SemiBold,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Size = UDim2.new(1, -60, 1, 0),
        Parent = titleRow,
    }), { TextColor3 = "Text" })
    Bind(New("TextLabel", {
        Text = Library.Strings.Now,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 60, 1, 0),
        Parent = titleRow,
    }), { TextColor3 = "Tertiary" })
    if opts.Content then
        FitText(Bind(New("TextLabel", {
            Text = opts.Content,
            TextSize = 13,
            TextWrapped = true,
            Size = UDim2.new(1, 0, 0, 16),
            LayoutOrder = 2,
            Parent = body,
        }), { TextColor3 = "SubText" }))
    end

    -- A thin bar along the bottom shows the time left before it goes away.
    local timeline = Bind(New("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 8),
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundTransparency = 0.4,
        ZIndex = 2,
        Parent = banner,
    }), { BackgroundColor3 = "Accent" })
    Corner(1, timeline)

    local closed = false
    local timer
    local function close()
        if closed then
            return
        end
        closed = true
        if timer then
            timer:Disconnect()
        end
        Spring(mover, { Position = UDim2.fromOffset(400, 0) }, 4, 1)
        task.wait(0.25)
        if not slot.Parent then
            return
        end
        local height = slot.AbsoluteSize.Y / EffectiveScale(slot)
        slot.AutomaticSize = Enum.AutomaticSize.None
        slot.Size = UDim2.new(1, 0, 0, height)
        Tween(slot, Tweens.Normal, { Size = UDim2.new(1, 0, 0, 0) }).Completed:Wait()
        slot:Destroy()
    end

    if opts.Buttons then
        local actions = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            LayoutOrder = 3,
            Parent = body,
        })
        Pad(actions, 6, 0, 0, 0)
        List(actions, 6, Enum.FillDirection.Horizontal, { HorizontalAlignment = Enum.HorizontalAlignment.Right })
        for index, info in ipairs(opts.Buttons) do
            local push = PushButton(actions, info.Text or "OK", info.Style, function()
                task.spawn(close)
                SafeCall(info.Callback)
            end)
            push.LayoutOrder = index
        end
    end

    -- Below the body, so the action buttons stay clickable.
    local hit = New("TextButton", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 0, Parent = banner })

    -- Swipe right to dismiss; a short drag springs back. A drag is not a click.
    local dragStart, offset, dragged = nil, 0, false
    TrackDrag(hit, function(position)
        dragStart = position
        dragged = false
        StopSpring(mover, "Position")
    end, function(position)
        offset = (position.X - dragStart.X) / Library.UIScale
        if math.abs(offset) > 4 then
            dragged = true
        end
        -- Leftward drags meet resistance; there is nowhere to go that way.
        local x = offset > 0 and offset or offset * 0.25
        mover.Position = UDim2.fromOffset(x, 0)
    end, function()
        if offset > 90 then
            task.spawn(close)
        else
            Spring(mover, { Position = UDim2.fromOffset(0, 0) }, 4.5, 0.7)
        end
        offset = 0
    end)
    hit.Activated:Connect(function()
        if dragged then
            dragged = false
            return
        end
        task.spawn(close)
        Spawn(opts.Callback)
    end)

    -- The countdown pauses while the pointer rests on the banner or drags it.
    local hovered = false
    banner.MouseEnter:Connect(function()
        hovered = true
    end)
    banner.MouseLeave:Connect(function()
        hovered = false
    end)
    local duration = opts.Duration or (opts.Buttons and 8 or 5)
    local remaining = duration
    timer = RunService.Heartbeat:Connect(function(dt)
        if not slot.Parent then
            timer:Disconnect()
            return
        end
        if hovered or dragStart and offset ~= 0 then
            return
        end
        remaining = remaining - dt
        timeline.Size = UDim2.new(math.max(remaining / duration, 0), 0, 0, 2)
        if remaining <= 0 then
            task.spawn(close)
        end
    end)

    Spring(mover, { Position = UDim2.fromOffset(0, 0) }, 3.5, 0.8)
    return {
        Close = function()
            task.spawn(close)
        end,
    }
end

function Library:ClearNotifications()
    self.NotificationHistory = {}
    UnreadCount = 0
    UpdateBellBadges()
    FillCenter()
end

--==============================================================
-- Overlays: watermark and keybind list
--==============================================================

local function OverlayFrame(name, props)
    local frame = Bind(New("Frame", {
        Name = name,
        ZIndex = 55,
        Parent = GetScreenGui(),
    }), { BackgroundColor3 = "Popup" })
    for key, value in pairs(props) do
        frame[key] = value
    end
    ScaleTarget(New("UIScale", { Parent = frame }))
    Bind(New("UIStroke", { Parent = frame }), { Color = "PopupStroke" })
    return frame
end

local function BuildWatermark()
    if Watermark and Watermark.Parent then
        return Watermark
    end
    local window = Library.Windows[1]
    local inset = GuiService:GetGuiInset().Y
    local pill = OverlayFrame("Watermark", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0, math.floor(math.max(inset, 40) / 2)),
        Size = UDim2.fromOffset(0, 28),
        AutomaticSize = Enum.AutomaticSize.X,
    })
    Corner(8, pill)
    Pad(pill, 0, 10, 0, 6)
    List(pill, 8, Enum.FillDirection.Horizontal, { VerticalAlignment = Enum.VerticalAlignment.Center })

    local order = 0
    local function add(instance)
        order = order + 1
        instance.LayoutOrder = order
        instance.Parent = pill
        return instance
    end
    local function text(value, font, key)
        return add(Bind(New("TextLabel", {
            Text = value,
            FontFace = font,
            TextSize = 12,
            Size = UDim2.fromOffset(0, 16),
            AutomaticSize = Enum.AutomaticSize.X,
        }), { TextColor3 = key }))
    end
    local function separator()
        add(Bind(New("Frame", { Size = UDim2.fromOffset(1, 12) }), { BackgroundColor3 = "Separator" }))
    end

    add(AppIcon(nil, 18, window and window.Icon, window and window.IconColor, window and window.Title or "R", 5))
    text(window and window.Title or "PaneUI", Fonts.SemiBold, "Text")
    separator()
    local fps = text("0 FPS", Fonts.Medium, "SubText")
    separator()
    local ping = text("0 ms", Fonts.Medium, "SubText")
    separator()
    local clock = text(os.date("%H:%M"), Fonts.Medium, "SubText")

    local frames = 0
    local last = os.clock()
    Connect(RunService.RenderStepped, function()
        frames = frames + 1
    end)
    task.spawn(function()
        while pill.Parent do
            task.wait(0.5)
            local now = os.clock()
            local rate = frames / math.max(now - last, 0.001)
            frames = 0
            last = now
            if pill.Visible then
                fps.Text = math.floor(rate + 0.5) .. " FPS"
                local ok, seconds = pcall(function()
                    return LocalPlayer:GetNetworkPing()
                end)
                ping.Text = math.floor((ok and seconds or 0) * 1000 + 0.5) .. " ms"
                clock.Text = os.date("%H:%M")
            end
        end
    end)
    Watermark = pill
    return pill
end

local function BuildKeybindPanel()
    if KeybindPanel and KeybindPanel.Frame.Parent then
        return KeybindPanel
    end
    local inset = GuiService:GetGuiInset().Y
    local frame = OverlayFrame("KeybindList", {
        Position = UDim2.fromOffset(16, inset + 70),
        Size = UDim2.fromOffset(200, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    Corner(10, frame)
    Pad(frame, 8, 10, 10, 10)
    List(frame, 6)
    local header = Bind(New("TextLabel", {
        Text = Library.Strings.Keybinds,
        FontFace = Fonts.SemiBold,
        TextSize = 12,
        Size = UDim2.new(1, 0, 0, 16),
        LayoutOrder = 1,
        Parent = frame,
    }), { TextColor3 = "SubText" })
    OnLanguage(header, function()
        header.Text = Library.Strings.Keybinds
        RefreshKeybindList()
    end)
    local list = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        Parent = frame,
    })
    List(list, 2)

    -- The panel can be dragged anywhere.
    local dragStart, origin
    TrackDrag(frame, function(position)
        dragStart = position
        origin = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
    end, function(position)
        local delta = position - dragStart
        frame.Position = UDim2.fromOffset(math.floor(origin.X + delta.X), math.floor(origin.Y + delta.Y))
    end)

    KeybindPanel = { Frame = frame, List = list }
    return KeybindPanel
end

local refreshQueued = false
RefreshKeybindList = function()
    if refreshQueued then
        return
    end
    refreshQueued = true
    task.defer(function()
        refreshQueued = false
        if not KeybindPanel or not KeybindPanel.Frame.Parent then
            return
        end
        local list = KeybindPanel.List
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        local count = 0
        for _, keybind in ipairs(Keybinds) do
            if not keybind.Internal and keybind.Value and keybind.Row and keybind.Row.Parent then
                count = count + 1
                local active = keybind.State == true
                local row = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    LayoutOrder = count,
                    Parent = list,
                })
                Bind(New("TextLabel", {
                    Text = keybind.Title or "",
                    FontFace = active and Fonts.SemiBold or Fonts.Regular,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Size = UDim2.new(1, -80, 1, 0),
                    Parent = row,
                }), {
                    TextColor3 = function(theme)
                        return active and theme.Accent or theme.Text
                    end,
                })
                Bind(New("TextLabel", {
                    Text = BindText(keybind.Value, keybind.Modifiers),
                    FontFace = Fonts.Medium,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.fromScale(1, 0),
                    Size = UDim2.new(0, 76, 1, 0),
                    Parent = row,
                }), { TextColor3 = "SubText" })
            end
        end
        if count == 0 then
            Bind(New("TextLabel", {
                Text = Library.Strings.None,
                TextSize = 12,
                Size = UDim2.new(1, 0, 0, 18),
                Parent = list,
            }), { TextColor3 = "Tertiary" })
        end
    end)
end

function Library:SetWatermark(visible)
    self.ShowWatermark = visible == true
    if self.ShowWatermark then
        BuildWatermark().Visible = true
    elseif Watermark then
        Watermark.Visible = false
    end
    SyncSettings("Watermark", self.ShowWatermark)
    self:_saveSettings()
end

function Library:SetKeybindList(visible)
    self.ShowKeybinds = visible == true
    if self.ShowKeybinds then
        BuildKeybindPanel().Frame.Visible = true
        RefreshKeybindList()
    elseif KeybindPanel then
        KeybindPanel.Frame.Visible = false
    end
    SyncSettings("KeybindList", self.ShowKeybinds)
    self:_saveSettings()
end

-- true: the toggle key minimizes into the dock tile; false: it hides fully.
function Library:SetHideToDock(enabled)
    self.HideToDock = enabled == true
    SyncSettings("HideToDock", self.HideToDock)
    self:_saveSettings()
end

-- Blurs the game world behind the window while it is open.
function Library:SetBlur(enabled)
    self.BlurBackground = enabled == true
    UpdateBlur()
    SyncSettings("Blur", self.BlurBackground)
    self:_saveSettings()
end

--==============================================================
-- Theme, accent, scale, language and toggle key
--==============================================================

function Library:SetTheme(name)
    if not self.Themes[name] then
        return
    end
    self.ThemeName = name
    BuildTheme()
    ApplyThemeEverywhere()
    SyncSettings("Theme", name == "Light" and self.Strings.Light or self.Strings.Dark)
    self:_saveSettings()
end

function Library:SetAccent(color)
    self.Accent = color
    BuildTheme()
    ApplyThemeEverywhere()
    self:_saveSettings()
end

-- "Auto" or a number such as 1.25.
function Library:SetScale(value)
    if value ~= "Auto" then
        value = tonumber(value)
        if not value then
            return
        end
        value = math.clamp(value, 0.5, 2.5)
    end
    self.ScaleSetting = value
    ApplyScale()
    SyncSettings("Scale", ScaleLabel(value))
    self:_saveSettings()
end

function Library:SetLanguage(code)
    local strings = self.Languages[code]
    if not strings then
        return
    end
    self.Language = code
    self.Strings = CopyTable(strings)
    for index = #LanguageListeners, 1, -1 do
        local listener = LanguageListeners[index]
        if listener.Object.Parent then
            SafeCall(listener.Callback)
        else
            table.remove(LanguageListeners, index)
        end
    end
    for _, window in ipairs(self.Windows) do
        window:_rebuildSettings()
    end
    for _, callback in ipairs(LanguageCallbacks) do
        SafeCall(callback, code)
    end
    self:_saveSettings()
end

-- For scripts that translate their own text: runs callback(code) after
-- every language change.
function Library:OnLanguageChanged(callback)
    table.insert(LanguageCallbacks, callback)
end

function Library:SetToggleKey(key)
    self.ToggleKey = key
    SyncSettings("ToggleKey", key)
    self:_saveSettings()
end

--==============================================================
-- Config files
--==============================================================

local function HasFileApi()
    return writefile ~= nil and readfile ~= nil and isfile ~= nil and makefolder ~= nil and isfolder ~= nil
end

local function EnsureFolder(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

function Library:_configFolder()
    return self.Folder .. "/configs"
end

function Library:_loadSettings()
    self._saved = self._saved or {}
    if not HasFileApi() then
        return
    end
    local path = self.Folder .. "/settings.json"
    if not isfile(path) then
        return
    end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok or type(data) ~= "table" then
        return
    end
    local saved = self._saved
    if data.Theme and self.Themes[data.Theme] then
        self.ThemeName = data.Theme
        saved.Theme = true
    end
    if data.Accent then
        local color = HexToColor(data.Accent)
        if color then
            self.Accent = color
            saved.Accent = true
        end
    end
    if data.ToggleKey then
        local key = KeyFromName(data.ToggleKey)
        if key then
            self.ToggleKey = key
            saved.ToggleKey = true
        end
    end
    if data.Language and self.Languages[data.Language] then
        self.Language = data.Language
        self.Strings = CopyTable(self.Languages[data.Language])
        saved.Language = true
    end
    if data.Scale == "Auto" or type(data.Scale) == "number" then
        self.ScaleSetting = data.Scale
        saved.Scale = true
    end
    if type(data.Watermark) == "boolean" then
        self.ShowWatermark = data.Watermark
        saved.Watermark = true
    end
    if type(data.KeybindList) == "boolean" then
        self.ShowKeybinds = data.KeybindList
        saved.KeybindList = true
    end
    if type(data.HideToDock) == "boolean" then
        self.HideToDock = data.HideToDock
        saved.HideToDock = true
    end
    if type(data.Blur) == "boolean" then
        self.BlurBackground = data.Blur
        saved.Blur = true
    end
    self.Autoload = data.Autoload
end

function Library:_saveSettings()
    if not self.Folder or not HasFileApi() then
        return
    end
    pcall(function()
        EnsureFolder(self.Folder)
        writefile(self.Folder .. "/settings.json", HttpService:JSONEncode({
            Theme = self.ThemeName,
            Accent = ColorToHex(self.Accent),
            ToggleKey = self.ToggleKey and self.ToggleKey.Name or nil,
            Language = self.Language,
            Scale = self.ScaleSetting,
            Watermark = self.ShowWatermark,
            KeybindList = self.ShowKeybinds,
            HideToDock = self.HideToDock,
            Blur = self.BlurBackground,
            Autoload = self.Autoload,
        }))
    end)
end

-- Every flagged element's value, keyed by flag.
function Library:_collect()
    local data = {}
    for flag, element in pairs(self.Options) do
        local ok, value = pcall(element._save, element)
        if ok and value ~= nil then
            data[flag] = value
        end
    end
    return data
end

function Library:_apply(data)
    for flag, value in pairs(data) do
        local element = self.Options[flag]
        if element then
            pcall(element._load, element, value)
        end
    end
end

function Library:ListConfigs()
    if not self.Folder or not HasFileApi() or not listfiles then
        return {}
    end
    local folder = self:_configFolder()
    if not isfolder(folder) then
        return {}
    end
    local names = {}
    for _, path in ipairs(listfiles(folder)) do
        local name = string.match(path, "([^/\\]+)%.json$")
        if name then
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end

function Library:SaveConfig(name)
    if not HasFileApi() then
        self:Notify({ Type = "Error", Content = self.Strings.NoFileApi })
        return false
    end
    local data = self:_collect()
    local ok = pcall(function()
        EnsureFolder(self.Folder)
        EnsureFolder(self:_configFolder())
        writefile(self:_configFolder() .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    return ok
end

function Library:LoadConfig(name)
    if not HasFileApi() then
        return false
    end
    local path = self:_configFolder() .. "/" .. name .. ".json"
    if not isfile(path) then
        return false
    end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok or type(data) ~= "table" then
        return false
    end
    self:_apply(data)
    return true
end

function Library:DeleteConfig(name)
    if not HasFileApi() or not delfile then
        return false
    end
    local path = self:_configFolder() .. "/" .. name .. ".json"
    if isfile(path) then
        delfile(path)
        if self.Autoload == name then
            self:SetAutoload(nil)
        end
        return true
    end
    return false
end

-- The current settings as text, for sharing without files.
function Library:ExportConfig()
    return HttpService:JSONEncode(self:_collect())
end

function Library:ImportConfig(text)
    local ok, data = pcall(function()
        return HttpService:JSONDecode(Trim(text))
    end)
    if not ok or type(data) ~= "table" then
        return false
    end
    self:_apply(data)
    return true
end

function Library:ResetAll()
    for _, element in pairs(self.Options) do
        element:Reset()
    end
end

function Library:SetAutoload(name)
    self.Autoload = name
    self:_saveSettings()
end

function Library:GetAutoload()
    return self.Autoload
end

-- Call once at the end of a script, after every flagged element exists.
function Library:LoadAutoloadConfig()
    if self.Autoload then
        return self:LoadConfig(self.Autoload)
    end
    return false
end

--==============================================================
-- Update check
--==============================================================

local function IsNewerVersion(remote, current)
    local a, b = {}, {}
    for number in string.gmatch(tostring(remote), "%d+") do
        table.insert(a, tonumber(number))
    end
    for number in string.gmatch(tostring(current), "%d+") do
        table.insert(b, tonumber(number))
    end
    for i = 1, math.max(#a, #b) do
        local x, y = a[i] or 0, b[i] or 0
        if x ~= y then
            return x > y
        end
    end
    return false
end

-- Fetches opts.Url (plain "1.2.0" or JSON { "version": "1.2.0" }) and shows
-- a banner when it is newer than opts.Current. opts.Link adds a copy button.
function Library:CheckForUpdates(opts)
    opts = opts or {}
    task.spawn(function()
        local ok, body = pcall(function()
            return game:HttpGet(opts.Url)
        end)
        if not ok or type(body) ~= "string" then
            return
        end
        local remote = body
        local decoded, data = pcall(function()
            return HttpService:JSONDecode(body)
        end)
        if decoded and type(data) == "table" then
            remote = data.version or data.Version or ""
        end
        remote = string.match(tostring(remote), "%d+[%d%.]*")
        if not remote or not IsNewerVersion(remote, opts.Current) then
            return
        end
        local strings = self.Strings
        local buttons
        if opts.Link and setclipboard then
            buttons = {
                {
                    Text = strings.CopyLink,
                    Style = "Primary",
                    Callback = function()
                        setclipboard(opts.Link)
                    end,
                },
            }
        end
        self:Notify({
            Type = "Info",
            Title = strings.UpdateAvailable,
            Content = string.format(strings.UpdateContent, remote, tostring(opts.Current)),
            Buttons = buttons,
            Duration = 10,
        })
        SafeCall(opts.OnUpdate, remote)
    end)
end

--==============================================================
-- Unload
--==============================================================

function Library:OnUnload(callback)
    table.insert(UnloadCallbacks, callback)
end

function Library:Unload()
    if self.Unloaded then
        return
    end
    self.Unloaded = true
    for _, callback in ipairs(UnloadCallbacks) do
        SafeCall(callback)
    end
    for _, window in ipairs(self.Windows) do
        window:ClosePalette()
        window:CloseNotificationCenter()
    end
    for _, connection in ipairs(Connections) do
        connection:Disconnect()
    end
    for _, keybind in ipairs(Keybinds) do
        keybind.Value = nil
    end
    Connections = {}
    Keybinds = {}
    RainbowPickers = {}
    RainbowConnection = nil
    SpringStates = {}
    SpringConnection = nil
    Animations = {}
    AnimationConnection = nil
    if BlurInstance then
        BlurInstance:Destroy()
        BlurInstance = nil
    end

    local gui = ScreenGui
    for _, window in ipairs(self.Windows) do
        window:_closePopup()
        window.Visible = false
        if window.Root then
            Tween(window.Root, Tweens.Fast, { GroupTransparency = 1 })
            Tween(window.Scale, Tweens.Fast, { Scale = self.UIScale * 0.96 })
        end
    end
    task.delay(0.2, function()
        if gui then
            gui:Destroy()
        end
        for instance in pairs(Bindings) do
            Bindings[instance] = nil
        end
    end)
    ScreenGui = nil
    NotifyHolder = nil
    Watermark = nil
    KeybindPanel = nil
    ScaleTargets = {}
    LanguageListeners = {}
    LanguageCallbacks = {}
end

Library.UIScale = CurrentScale()

--==============================================================
-- Kit: the building blocks the library itself is made of, for scripts
-- that draw their own pieces (a HUD, a splash screen) and want them to
-- look the same and follow the theme, accent, scale and language.
-- Instances made with Kit.New live in the library's ScreenGui when
-- parented to Kit.GetScreenGui(), and Library:Unload() removes them.
--==============================================================

Library.Kit = {
    -- Instances and layout
    New = New,
    Corner = Corner,
    Pad = Pad,
    List = List,
    FitText = FitText,
    TextWidth = TextWidth,
    GetScreenGui = GetScreenGui,
    RandomName = RandomName,
    -- Theme: Bind(instance, { Property = "ThemeKey" | function(theme) })
    Bind = Bind,
    Refresh = Refresh,
    -- Scale and language
    ScaleTarget = ScaleTarget,
    EffectiveScale = EffectiveScale,
    CurrentScale = CurrentScale,
    OnLanguage = OnLanguage,
    -- Motion
    Tween = Tween,
    Tweens = Tweens,
    Spring = Spring,
    SpringKick = SpringKick,
    StopSpring = StopSpring,
    Animate = Animate,
    Bezier = Bezier,
    EaseOutCubic = EaseOutCubic,
    EaseInCubic = EaseInCubic,
    EaseInOutCubic = EaseInOutCubic,
    CountTo = CountTo,
    -- Visual pieces
    Fonts = Fonts,
    IconPalette = IconPalette,
    StatusStyles = StatusStyles,
    TrafficColors = TrafficColors,
    Shadow = Shadow,
    RefreshShadow = RefreshShadow,
    Bar = Bar,
    Chevron = Chevron,
    Checkmark = Checkmark,
    AppIcon = AppIcon,
    ResolveIcon = ResolveIcon,
    PushButton = PushButton,
    UpdateBlur = UpdateBlur,
    -- Input and events; Connect's connections end on Unload
    Connect = Connect,
    TrackDrag = TrackDrag,
    GuiPosition = GuiPosition,
    PointerPosition = PointerPosition,
    IsClick = IsClick,
    KeyName = KeyName,
    InputMatches = InputMatches,
    SafeCall = SafeCall,
    Spawn = Spawn,
}

-- Reads <folder>/settings.json before any window exists, so pieces shown
-- first (a splash screen) already use the user's theme, accent and scale.
function Library.Kit.LoadSettings(folder)
    Library.Folder = folder
    Library:_loadSettings()
    BuildTheme()
    Library.UIScale = CurrentScale()
end

return Library
