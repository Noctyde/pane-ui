-- PaneUI demo: every element in one window.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Noctyde/pane-ui/main/src/PaneUI.lua"))()

local Window = Library:CreateWindow({
    Title = "PaneUI Demo",
    Subtitle = "v" .. Library.Version,
    Icon = "command", -- any name from Library.Icons, an image id or a short glyph
    Size = UDim2.fromOffset(780, 520),
    Theme = "Dark", -- "Dark" | "Light"
    Language = "en", -- "en" | "ru"
    Scale = "Auto", -- "Auto" or a number such as 1.25
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigFolder = "PaneUIDemo",
    Blur = true, -- blur the game behind the window while it is open
    -- The Settings tab remembers the user's choices; these are only the defaults.
})

Window:AddSidebarHeader("Features")

--==============================================================
-- General
--==============================================================

local General = Window:AddTab({ Title = "General", Icon = "home" })

local Actions = General:AddSection("Actions")
Actions:AddButton({
    Title = "Open details",
    Description = "A whole row can act as a button",
    Tooltip = "Rows show a tooltip when you hover them",
    Callback = function()
        Library:Notify({ Title = "Details", Content = "Row button clicked", Duration = 3 })
    end,
})
Actions:AddButton({
    Title = "Teleport to spawn",
    Description = "Or use push buttons on the right",
    Buttons = {
        { Text = "Cancel" },
        {
            Text = "Teleport",
            Style = "Primary",
            Callback = function()
                print("teleport")
            end,
        },
    },
})

local Toggles = General:AddSection("Toggles")
local AutoFarm = Toggles:AddToggle({
    Title = "Auto farm",
    Description = "Collects coins automatically",
    Tooltip = "Right-click any option to reset it or copy its value",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        print("Auto farm:", value)
    end,
})
Toggles:AddToggle({ Title = "Show ESP", Default = true, Flag = "ESP" })
Toggles:AddCheckbox({
    Title = "Notify on rare drops",
    Description = "Checkboxes sit left of their text",
    Default = true,
    Flag = "RareDrops",
})
Toggles:AddToggle({
    Title = "Server hop",
    Description = "Disabled options are greyed out",
    Tooltip = "Not available in this game",
    Disabled = true,
})

local Movement = General:AddSection("Movement")
Movement:AddSlider({
    Title = "Walk speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Step = 1,
    Suffix = " studs/s",
    Flag = "WalkSpeed",
    Callback = function(value)
        print("Walk speed:", value)
    end,
})
Movement:AddSlider({
    Title = "Field of view",
    Description = "Steps of 0.5",
    Min = 50,
    Max = 120,
    Default = 70,
    Step = 0.5,
    Flag = "FOV",
})
Movement:AddStepper({
    Title = "Jump power",
    Description = "Hold a button to keep stepping",
    Min = 0,
    Max = 200,
    Default = 50,
    Step = 5,
    Flag = "JumpPower",
})

--==============================================================
-- Combat
--==============================================================

local Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" })

local Targeting = Combat:AddSection("Targeting")
local TargetPlayer = Targeting:AddPlayerDropdown({
    Title = "Target player",
    Description = "Updates when players join or leave",
    Callback = function(name)
        print("Target:", name, TargetPlayer:GetPlayer())
    end,
})
Targeting:AddDropdown({
    Title = "Target part",
    Values = { "Head", "HumanoidRootPart", "Torso" },
    Default = "Head",
    Flag = "TargetPart",
})
Targeting:AddDropdown({
    Title = "Ignore teams",
    Description = "Multi select",
    Values = { "Red", "Blue", "Green", "Yellow", "Neutral" },
    Multi = true,
    Default = { "Neutral" },
    Flag = "IgnoreTeams",
})
Targeting:AddSegmented({
    Title = "Aim mode",
    Values = { "Legit", "Rage", "Off" },
    Default = "Legit",
    Flag = "AimMode",
})
Targeting:AddRadio({
    Title = "Priority",
    Description = "Which target to pick first",
    Values = { "Closest", "Lowest health", "Random" },
    Default = "Closest",
    Flag = "Priority",
})

local Visuals = Combat:AddSection("Visuals")
Visuals:AddColorPicker({
    Title = "ESP color",
    Description = "With an opacity slider",
    Default = Color3.fromRGB(255, 69, 58),
    Transparency = 0.2,
    Flag = "ESPColor",
    Callback = function(color, transparency)
        print("ESP color:", color, transparency)
    end,
})
Visuals:AddColorPicker({
    Title = "Chams",
    Description = "Rainbow mode is in the picker",
    Default = Color3.fromRGB(10, 132, 255),
    Rainbow = true,
    Flag = "Chams",
})

local Binds = Combat:AddSection("Keybinds")
Binds:AddKeybind({
    Title = "Fly",
    Description = "Toggle mode",
    Default = Enum.KeyCode.F,
    Mode = "Toggle",
    Flag = "FlyKey",
    Callback = function(state)
        print("Fly:", state)
    end,
})
Binds:AddKeybind({
    Title = "Zoom",
    Description = "Hold mode",
    Default = Enum.UserInputType.MouseButton2,
    Mode = "Hold",
    Flag = "ZoomKey",
})
Binds:AddKeybind({
    Title = "Panic",
    Description = "Binds can use Ctrl, Shift and Alt",
    Default = "Ctrl+P",
    Mode = "Always",
    Flag = "PanicKey",
    Callback = function()
        print("Panic!")
    end,
})

--==============================================================
-- Misc
--==============================================================

local Misc = Window:AddTab({ Title = "Misc", Icon = "package" })

local Status = Misc:AddSection("Status")
local FarmProgress = Status:AddProgress({
    Title = "Farming progress",
    Description = "Goes from 0 to 100% and starts over",
    Value = 0,
})
Status:AddProgress({
    Title = "Loading assets",
    Description = "Indeterminate progress",
    Indeterminate = true,
})
local Waiting = Status:AddSpinner({
    Title = "Waiting for the server",
    Description = "Spinners can be turned on and off",
})

local Notes = Misc:AddSection("Notes")
Notes:AddTextArea({
    Title = "Notes",
    Placeholder = "Anything you want to remember...",
    Height = 70,
    Flag = "Notes",
})

local Advanced = Misc:AddSection({ Title = "Advanced", Collapsible = true, Collapsed = true })
Advanced:AddInput({
    Title = "Webhook name",
    Placeholder = "Enter a name",
    Flag = "WebhookName",
})
Advanced:AddInput({
    Title = "Max distance",
    Placeholder = "1000",
    Numeric = true,
    Width = 90,
    Flag = "MaxDistance",
})

--==============================================================
-- About
--==============================================================

Window:AddSidebarHeader("Other")
local About = Window:AddTab({ Title = "About", Icon = "info" })
About:AddParagraph({
    Title = "PaneUI",
    Content = "A macOS-style UI library. Ctrl+K opens the command palette, Ctrl+F searches, the bell keeps past notifications, right-click resets options, and Settings has the theme, language, interface size, overlays and configs.",
})
local StatusLabel = About:AddLabel("Auto farm is off")
AutoFarm:OnChanged(function(value)
    StatusLabel:SetText(value and "Auto farm is on" or "Auto farm is off")
end)

local Banners = About:AddSection("Notifications")
for _, kind in ipairs({ "Info", "Success", "Warning", "Error" }) do
    Banners:AddButton({
        Title = kind .. " banner",
        ButtonText = "Show",
        Callback = function()
            Library:Notify({ Type = kind, Title = kind, Content = "A " .. string.lower(kind) .. " notification." })
        end,
    })
end
Banners:AddButton({
    Title = "Banner with actions",
    ButtonText = "Show",
    Callback = function()
        Library:Notify({
            Type = "Info",
            Title = "Friend request",
            Content = "Builderman wants to be your friend.",
            Buttons = {
                { Text = "Decline" },
                {
                    Text = "Accept",
                    Style = "Primary",
                    Callback = function()
                        print("accepted")
                    end,
                },
            },
        })
    end,
})
Banners:AddButton({
    Title = "Show a dialog",
    ButtonText = "Open",
    Callback = function()
        Window:Dialog({
            Title = "Reset all settings?",
            Content = "Every toggle and slider goes back to its default value.",
            Buttons = {
                {
                    Title = "Reset",
                    Style = "Destructive",
                    Callback = function()
                        Library:ResetAll()
                    end,
                },
                { Title = "Cancel", Style = "Primary" },
            },
        })
    end,
})

Window:AddSettingsTab()

--==============================================================
-- Script logic
--==============================================================

-- Fake work to drive the progress bar and the spinner.
task.spawn(function()
    local value = 0
    while not Library.Unloaded do
        task.wait(0.1)
        value = value + 0.02
        if value > 1 then
            value = 0
            Waiting:SetSpinning(not Waiting.Spinning)
        end
        FarmProgress:SetValue(value)
    end
end)

-- Stop the script's own loops when the window is unloaded.
Library:OnUnload(function()
    print("Demo unloaded")
end)

-- To check for updates, host a file with the version number:
-- Library:CheckForUpdates({ Url = "https://example.com/version.txt", Current = "1.0.0", Link = "https://example.com" })

-- Load the config the user marked as autoload, after all flagged elements exist.
Library:LoadAutoloadConfig()

Library:Notify({ Type = "Info", Title = "PaneUI Demo", Content = "Press RightShift to hide the window. Ctrl+F searches." })
