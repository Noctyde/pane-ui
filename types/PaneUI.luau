--[[
    Type definitions for PaneUI 1.4, for autocomplete in the editor.

    Paste this block at the top of a script and annotate the library:

        local Library: PaneUI = loadstring(game:HttpGet(URL))()

    The types only help the editor. If an obfuscator rejects type syntax,
    delete this block before obfuscating; the script works the same.
]]

type Theme = "Dark" | "Light"
type Style = "Default" | "Primary" | "Destructive"
type NotifyType = "Info" | "Success" | "Warning" | "Error"
type KeyMode = "Toggle" | "Hold" | "Always"
type Key = Enum.KeyCode | Enum.UserInputType

type Common = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
}

type Element = {
    Title: string?,
    Description: string?,
    Flag: string?,
    Disabled: boolean?,
    SetTitle: (self: any, text: string) -> (),
    SetDescription: (self: any, text: string?) -> (),
    SetTooltip: (self: any, text: string?) -> (),
    SetVisible: (self: any, visible: boolean) -> (),
    SetDisabled: (self: any, disabled: boolean) -> (),
    Reset: (self: any) -> (),
    Destroy: (self: any) -> (),
    OnChanged: (self: any, callback: (...any) -> ()) -> any,
}

type ButtonInfo = { Text: string, Style: Style?, Callback: (() -> ())? }

type PaletteItem = {
    Title: string,
    Path: string?,
    Icon: string?,
    IconColor: Color3?,
    Hint: string?,
    Keywords: string?,
    Run: () -> (),
}

type ButtonOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Disabled: boolean?,
    ButtonText: string?,
    Style: Style?,
    Buttons: { ButtonInfo }?,
    Callback: (() -> ())?,
}

type ToggleOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Default: boolean?,
    Callback: ((value: boolean) -> ())?,
}
type Toggle = Element & {
    Value: boolean,
    SetValue: (self: any, value: boolean, silent: boolean?) -> (),
}

type RadioOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Values: { any },
    Default: any?,
    Callback: ((value: any) -> ())?,
}
type Radio = Element & {
    Value: any,
    SetValue: (self: any, value: any, silent: boolean?) -> (),
}

type SliderOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Min: number?,
    Max: number?,
    Default: number?,
    Step: number?,
    Suffix: string?,
    Width: number?,
    Callback: ((value: number) -> ())?,
}
type Slider = Element & {
    Value: number,
    Min: number,
    Max: number,
    SetValue: (self: any, value: number, silent: boolean?) -> (),
    SetRange: (self: any, min: number, max: number) -> (),
}

type DropdownOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Values: { any }?,
    Default: any?,
    Multi: boolean?,
    AllowNone: boolean?,
    Searchable: boolean?,
    Width: number?,
    ItemText: ((value: any) -> string)?,
    ItemIcon: ((value: any) -> string?)?,
    Callback: ((value: any) -> ())?,
}
type Dropdown = Element & {
    Value: any,
    Values: { any },
    SetValue: (self: any, value: any, silent: boolean?) -> (),
    SetValues: (self: any, values: { any }) -> (),
}

type PlayerDropdownOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Multi: boolean?,
    AllowNone: boolean?,
    ExcludeLocalPlayer: boolean?,
    Width: number?,
    Callback: ((value: any) -> ())?,
}
type PlayerDropdown = Dropdown & {
    GetPlayer: (self: any) -> any,
}

type InputOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Default: string?,
    Placeholder: string?,
    Numeric: boolean?,
    MaxLength: number?,
    Width: number?,
    Finished: boolean?,
    Callback: ((text: string) -> ())?,
}
type Input = Element & {
    Value: string,
    SetValue: (self: any, value: string, silent: boolean?) -> (),
}

type TextAreaOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Default: string?,
    Placeholder: string?,
    Height: number?,
    Finished: boolean?,
    Callback: ((text: string) -> ())?,
}

type KeybindOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Default: (Key | string)?,
    Modifiers: { string }?,
    Mode: KeyMode?,
    AllowModifiers: boolean?,
    Callback: ((state: boolean) -> ())?,
    ChangedCallback: ((key: Key?, modifiers: { [string]: boolean }) -> ())?,
}
type Keybind = Element & {
    Value: Key?,
    Modifiers: { [string]: boolean },
    Mode: KeyMode,
    State: boolean,
    SetValue: (self: any, key: (Key | string)?, modifiers: any?, silent: boolean?) -> (),
    GetState: (self: any) -> boolean,
}

type ColorPickerOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Default: Color3?,
    Transparency: number?,
    Rainbow: boolean?,
    RainbowSpeed: number?,
    Callback: ((color: Color3, transparency: number?) -> ())?,
}
type ColorPicker = Element & {
    Value: Color3,
    Transparency: number?,
    Rainbow: boolean,
    SetValue: (self: any, color: Color3 | string, silent: boolean?) -> (),
    SetTransparency: (self: any, value: number, silent: boolean?) -> (),
    SetRainbow: (self: any, enabled: boolean) -> (),
}

type SegmentedOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Flag: string?,
    Disabled: boolean?,
    Values: { any },
    Default: any?,
    Callback: ((value: any) -> ())?,
}

type ProgressOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Value: number?,
    Max: number?,
    Indeterminate: boolean?,
}
type Progress = Element & {
    Value: number,
    SetValue: (self: any, value: number) -> (),
    SetIndeterminate: (self: any, enabled: boolean) -> (),
}

type SpinnerOptions = {
    Title: string?,
    Description: string?,
    Tooltip: string?,
    Spinning: boolean?,
}
type Spinner = Element & {
    Spinning: boolean,
    SetSpinning: (self: any, enabled: boolean) -> (),
}

type Label = Element & {
    SetText: (self: any, text: string) -> (),
    SetContent: (self: any, text: string) -> (),
}

type Section = {
    Title: string?,
    Collapsed: boolean,
    SetVisible: (self: Section, visible: boolean) -> (),
    SetCollapsed: (self: Section, collapsed: boolean) -> (),
    SetTitle: (self: Section, text: string) -> (),
    AddButton: (self: Section, opts: ButtonOptions) -> Element,
    AddToggle: (self: Section, opts: ToggleOptions) -> Toggle,
    AddCheckbox: (self: Section, opts: ToggleOptions) -> Toggle,
    AddRadio: (self: Section, opts: RadioOptions) -> Radio,
    AddSlider: (self: Section, opts: SliderOptions) -> Slider,
    AddStepper: (self: Section, opts: SliderOptions) -> Slider,
    AddDropdown: (self: Section, opts: DropdownOptions) -> Dropdown,
    AddPlayerDropdown: (self: Section, opts: PlayerDropdownOptions) -> PlayerDropdown,
    AddInput: (self: Section, opts: InputOptions) -> Input,
    AddTextArea: (self: Section, opts: TextAreaOptions) -> Input,
    AddKeybind: (self: Section, opts: KeybindOptions) -> Keybind,
    AddColorPicker: (self: Section, opts: ColorPickerOptions) -> ColorPicker,
    AddSegmented: (self: Section, opts: SegmentedOptions) -> Radio,
    AddProgress: (self: Section, opts: ProgressOptions) -> Progress,
    AddSpinner: (self: Section, opts: SpinnerOptions) -> Spinner,
    AddLabel: (self: Section, text: string) -> Label,
    AddParagraph: (self: Section, opts: { Title: string?, Content: string?, Tooltip: string? }) -> Label,
}

type SectionOptions = { Title: string?, Collapsible: boolean?, Collapsed: boolean? }

-- A tab has every Add* method of a section too; they go to an untitled section.
type Tab = Section & {
    Title: string,
    AddSection: (self: any, title: (string | SectionOptions)?, opts: SectionOptions?) -> Section,
    Select: (self: any) -> (),
    Destroy: (self: any) -> (),
}

type DialogButton = { Title: string, Style: Style?, Callback: (() -> ())? }

type Window = {
    Title: string,
    Visible: boolean,
    AddTab: (self: Window, opts: string | { Title: string, Icon: string?, IconColor: Color3? }) -> Tab,
    AddSidebarHeader: (self: Window, text: string) -> TextLabel,
    SetSubtitle: (self: Window, text: string?) -> (),
    AddSettingsTab: (self: Window, opts: { Title: string?, Icon: string?, IconColor: Color3? }?) -> Tab,
    SelectTab: (self: Window, tab: Tab | number) -> (),
    Reveal: (self: Window, element: any) -> (),
    Dialog: (self: Window, opts: { Title: string?, Content: string?, Icon: string?, Buttons: { DialogButton }? }) -> { Close: () -> () },
    SetVisible: (self: Window, visible: boolean) -> (),
    Toggle: (self: Window) -> (),
    Minimize: (self: Window) -> (),
    Restore: (self: Window) -> (),
    Zoom: (self: Window) -> (),
    Close: (self: Window) -> (),
    Destroy: (self: Window) -> (),
    OpenPalette: (self: Window) -> (),
    ClosePalette: (self: Window) -> (),
    OpenNotificationCenter: (self: Window) -> (),
    CloseNotificationCenter: (self: Window) -> (),
    ToggleNotificationCenter: (self: Window) -> (),
}

type WindowOptions = {
    Title: string?,
    Subtitle: string?,
    Icon: string?,
    IconColor: Color3?,
    Size: UDim2?,
    MinSize: Vector2?,
    SidebarWidth: number?,
    Theme: Theme?,
    Style: string?,
    Accent: Color3?,
    Language: string?,
    Scale: ("Auto" | number)?,
    ToggleKey: Key?,
    ConfigFolder: (string | boolean)?,
    Watermark: boolean?,
    KeybindList: boolean?,
    HideToDock: boolean?,
    Blur: boolean?,
    CloseBehavior: ("Unload" | "Hide")?,
}

type NotifyOptions = {
    Title: string?,
    Content: string?,
    Type: NotifyType?,
    Duration: number?,
    Icon: string?,
    IconColor: Color3?,
    Buttons: { ButtonInfo }?,
    Callback: (() -> ())?,
}

type PaneUI = {
    Version: string,
    Options: { [string]: any },
    Strings: { [string]: string },
    Languages: { [string]: { [string]: string } },
    LanguageNames: { { Code: string, Name: string } },
    Themes: { [string]: { [string]: any } },
    Styles: { [string]: { Order: number?, Dark: { [string]: any }?, Light: { [string]: any }? } },
    StyleName: string,
    Accents: { { Name: string, Color: Color3 } },
    Icons: { [string]: string },
    Unloaded: boolean,
    Language: string,
    NotificationHistory: { { Title: string, Content: string?, Type: NotifyType?, Time: number } },
    CreateWindow: (self: PaneUI, opts: WindowOptions?) -> Window,
    Notify: (self: PaneUI, opts: NotifyOptions | string) -> { Close: () -> () },
    ClearNotifications: (self: PaneUI) -> (),
    SetTheme: (self: PaneUI, name: Theme) -> (),
    SetStyle: (self: PaneUI, name: string) -> (),
    SetAccent: (self: PaneUI, color: Color3) -> (),
    SetScale: (self: PaneUI, value: "Auto" | number) -> (),
    SetLanguage: (self: PaneUI, code: string) -> (),
    OnLanguageChanged: (self: PaneUI, callback: (code: string) -> ()) -> (),
    SetToggleKey: (self: PaneUI, key: Key) -> (),
    SetWatermark: (self: PaneUI, visible: boolean) -> (),
    SetKeybindList: (self: PaneUI, visible: boolean) -> (),
    SetHideToDock: (self: PaneUI, enabled: boolean) -> (),
    SetBlur: (self: PaneUI, enabled: boolean) -> (),
    SaveConfig: (self: PaneUI, name: string) -> boolean,
    LoadConfig: (self: PaneUI, name: string) -> boolean,
    DeleteConfig: (self: PaneUI, name: string) -> boolean,
    ListConfigs: (self: PaneUI) -> { string },
    ExportConfig: (self: PaneUI) -> string,
    ImportConfig: (self: PaneUI, text: string) -> boolean,
    ResetAll: (self: PaneUI) -> (),
    SetAutoload: (self: PaneUI, name: string?) -> (),
    GetAutoload: (self: PaneUI) -> string?,
    LoadAutoloadConfig: (self: PaneUI) -> boolean,
    CheckForUpdates: (self: PaneUI, opts: { Url: string, Current: string, Link: string?, OnUpdate: ((version: string) -> ())? }) -> (),
    AddPaletteProvider: (self: PaneUI, provider: () -> { PaletteItem }) -> (),
    OnUnload: (self: PaneUI, callback: () -> ()) -> (),
    Unload: (self: PaneUI) -> (),
    Kit: { [string]: any },
}
