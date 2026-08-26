--[[
    EONZIEY HUB - STANDALONE EDITION
    Created by: Eonziey
    Version: 3.0 (All-in-One)
    Supported Game: Blox Fruits
    This script contains EVERYTHING in one file.
    No external dependencies required.
]]

-- ============================================
-- CONFIGURATION / SETTINGS
-- ============================================
local Settings = {
    JoinTeam = "Pirates",      -- "Pirates" or "Marines"
    Translator = true,         -- true/false
    AutoFarm = false,          -- true/false (starts disabled)
    FarmSpeed = 1.0,           -- seconds between attacks
    PreferredFruit = "Dragon", -- for fruit sniping
    AntiAFK = true,            -- true/false
    WebhookURL = "https://discord.com/api/webhooks/1459982301449552015/kjAvqXuGsjwL4WeH8vujJ3tN1AqLFWoB3718qtQhA6HvvuHJ3TmSIlogV-HIMfsfYlK"            -- Discord webhook URL (optional)
}

-- ============================================
-- UI LIBRARY (EONZIEY LIB V5 - BUILT-IN)
-- ============================================
local EonzieyLib = {}
EonzieyLib.__index = EonzieyLib

function EonzieyLib:MakeWindow(config)
    local Window = {}
    Window.Name = config.Name or "Eonziey Hub"
    Window.Title = config.Title or "Eonziey Hub"
    Window.SubTitle = config.SubTitle or "By Eonziey"
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EonzieyHubUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 620)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -310)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Drop Shadow (for style)
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 6, 1, 6)
    Shadow.Position = UDim2.new(0, -3, 0, -3)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.5
    Shadow.BorderSizePixel = 0
    Shadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -10, 1, 0)
    TitleText.Position = UDim2.new(0, 5, 0, 0)
    TitleText.Text = config.Title .. " - " .. config.SubTitle
    TitleText.TextColor3 = Color3.fromRGB(255, 215, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Parent = TitleBar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 7)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 7)
    MinBtn.Text = "_"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    MinBtn.BorderSizePixel = 0
    MinBtn.TextSize = 20
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame.Size = minimized and UDim2.new(0, 520, 0, 45) or UDim2.new(0, 520, 0, 620)
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 0, 35)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -80)
    ContentFrame.Position = UDim2.new(0, 0, 0, 80)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    -- Tab management
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.TabButtons = {}
    
    function Window:MakeTab(tabConfig)
        local Tab = {}
        Tab.Name = tabConfig.Name
        Tab.Elements = {}
        
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Text = tabConfig.Name
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.BorderSizePixel = 0
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Parent = TabContainer
        table.insert(Window.TabButtons, TabButton)
        
        -- Tab content frame (hidden by default)
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.ScrollBarThickness = 6
        TabFrame.Parent = ContentFrame
        
        local CanvasSize = 0
        
        -- Click handler to switch tabs
        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Frame.Visible = false
            end
            for _, btn in pairs(Window.TabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            end
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
            Window.CurrentTab = Tab
        end)
        
        Tab.Frame = TabFrame
        
        -- UI Element Functions
        function Tab:AddButton(btnConfig)
            local yPos = CanvasSize
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 200, 0, 40)
            Button.Position = UDim2.new(0.5, -100, 0, yPos + 10)
            Button.Text = btnConfig.Name
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.BorderSizePixel = 0
            Button.TextSize = 15
            Button.Font = Enum.Font.GothamSemibold
            Button.Parent = TabFrame
            
            Button.MouseButton1Click:Connect(function()
                if btnConfig.Callback then
                    pcall(btnConfig.Callback)
                end
            end)
            
            CanvasSize = CanvasSize + 55
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize + 20)
            table.insert(Tab.Elements, Button)
        end
        
        function Tab:AddToggle(toggleConfig)
            local yPos = CanvasSize
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(0, 220, 0, 35)
            ToggleFrame.Position = UDim2.new(0.5, -110, 0, yPos + 10)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = TabFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0, 160, 1, 0)
            ToggleLabel.Text = toggleConfig.Name
            ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 1, -4)
            ToggleButton.Position = UDim2.new(1, -55, 0, 2)
            ToggleButton.Text = toggleConfig.Default and "ON" or "OFF"
            ToggleButton.BackgroundColor3 = toggleConfig.Default and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.TextSize = 13
            ToggleButton.Font = Enum.Font.GothamBold
            ToggleButton.Parent = ToggleFrame
            
            local state = toggleConfig.Default or false
            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                ToggleButton.Text = state and "ON" or "OFF"
                ToggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
                if toggleConfig.Callback then
                    pcall(toggleConfig.Callback, state)
                end
            end)
            
            CanvasSize = CanvasSize + 50
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize + 20)
            table.insert(Tab.Elements, ToggleFrame)
        end
        
        function Tab:AddDropdown(dropdownConfig)
            local yPos = CanvasSize
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(0, 220, 0, 45)
            DropdownFrame.Position = UDim2.new(0.5, -110, 0, yPos + 10)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
            DropdownLabel.Text = dropdownConfig.Name
            DropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.TextSize = 13
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 22)
            DropdownButton.Position = UDim2.new(0, 0, 0, 22)
            DropdownButton.Text = dropdownConfig.Default or "Select"
            DropdownButton.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
            DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownButton.BorderSizePixel = 0
            DropdownButton.TextSize = 13
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Parent = DropdownFrame
            
            local currentIndex = 1
            for i, opt in ipairs(dropdownConfig.Options) do
                if opt == dropdownConfig.Default then
                    currentIndex = i
                    break
                end
            end
            DropdownButton.Text = dropdownConfig.Options[currentIndex] or dropdownConfig.Default
            
            DropdownButton.MouseButton1Click:Connect(function()
                currentIndex = currentIndex % #dropdownConfig.Options + 1
                local selected = dropdownConfig.Options[currentIndex]
                DropdownButton.Text = selected
                if dropdownConfig.Callback then
                    pcall(dropdownConfig.Callback, selected)
                end
            end)
            
            CanvasSize = CanvasSize + 60
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize + 20)
            table.insert(Tab.Elements, DropdownFrame)
        end
        
        function Tab:AddLabel(labelConfig)
            local yPos = CanvasSize
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0, 220, 0, 30)
            Label.Position = UDim2.new(0.5, -110, 0, yPos + 10)
            Label.Text = labelConfig.Text
            Label.TextColor3 = Color3.fromRGB(180, 180, 200)
            Label.BackgroundTransparency = 1
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextWrapped = true
            Label.Parent = TabFrame
            
            CanvasSize = CanvasSize + 45
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize + 20)
            table.insert(Tab.Elements, Label)
        end
        
        function Tab:AddTextbox(textboxConfig)
            local yPos = CanvasSize
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(0, 220, 0, 35)
            TextboxFrame.Position = UDim2.new(0.5, -110, 0, yPos + 10)
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.Parent = TabFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(0, 80, 1, 0)
            TextboxLabel.Text = textboxConfig.Name
            TextboxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.TextSize = 13
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(0, 130, 1, 0)
            Textbox.Position = UDim2.new(0, 90, 0, 0)
            Textbox.Text = textboxConfig.Default or ""
            Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Textbox.BorderSizePixel = 0
            Textbox.TextSize = 13
            Textbox.Font = Enum.Font.Gotham
            Textbox.Parent = TextboxFrame
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed and textboxConfig.Callback then
                    pcall(textboxConfig.Callback, Textbox.Text)
                end
            end)
            
            CanvasSize = CanvasSize + 50
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, CanvasSize + 20)
            table.insert(Tab.Elements, TextboxFrame)
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Make first tab visible by default
    if #Window.Tabs > 0 then
        Window.Tabs[1].Frame.Visible = true
        if Window.TabButtons[1] then
            Window.TabButtons[1].BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        end
    end
    
    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return Window
end

-- ============================================
-- HELPER FUNCTIONS (UTILITIES)
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Anti-AFK Loop
local function StartAntiAFK()
    if not Settings.AntiAFK then return end
    spawn(function()
        while Settings.AntiAFK do
            VirtualInput:SendKeyEvent(true, "W", false, game)
            wait(0.1)
            VirtualInput:SendKeyEvent(false, "W", false, game)
            VirtualInput:SendMouseButtonEvent(1, 0, 0, true, game, 0)
            wait(0.1)
            VirtualInput:SendMouseButtonEvent(1, 0, 0, false, game, 0)
            wait(30)
        end
    end)
end

-- Get Nearest Enemy
local function GetNearestEnemy()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local nearest = nil
    local shortestDist = math.huge
    local origin = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj.Name ~= LocalPlayer.Name then
                local dist = (origin - obj.HumanoidRootPart.Position).Magnitude
                if dist < shortestDist and obj.Humanoid.Health > 0 then
                    shortestDist = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

-- Teleport to Position
local function TeleportTo(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Send Webhook (if URL provided)
local function SendWebhook(message)
    if Settings.WebhookURL and Settings.WebhookURL ~= "" then
        local data = {
            content = message
        }
        local encoded = HttpService:JSONEncode(data)
        local headers = {
            ["Content-Type"] = "application/json"
        }
        pcall(function()
            HttpService:PostAsync(Settings.WebhookURL, encoded, Enum.HttpContentType.ApplicationJson, false, headers)
        end)
    end
end

-- ============================================
-- BLOX FRUITS GAME MODULE (BUILT-IN)
-- ============================================
local BloxFruits = {}

BloxFruits.Config = {
    AutoFarmEnabled = false,
    FarmSpeed = Settings.FarmSpeed or 1.0,
    UseBuddha = true,
    SpecificFruit = Settings.PreferredFruit or "Dragon"
}

function BloxFruits:StartAutoFarm()
    if not BloxFruits.Config.AutoFarmEnabled then return end
    spawn(function()
        while BloxFruits.Config.AutoFarmEnabled and LocalPlayer.Character do
            local target = GetNearestEnemy()
            if target then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    wait(0.1)
                    -- Attack (press Q)
                    VirtualInput:SendKeyEvent(true, "Q", false, game)
                    wait(0.2)
                    VirtualInput:SendKeyEvent(false, "Q", false, game)
                end
            end
            wait(BloxFruits.Config.FarmSpeed)
        end
    end)
end

function BloxFruits:SnipeFruit(fruitName)
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name and obj.Name:lower():find(fruitName:lower()) then
            if obj:FindFirstChild("ClickDetector") then
                TeleportTo(obj.PrimaryPart.Position + Vector3.new(0, 5, 0))
                wait(0.3)
                fireclickdetector(obj:FindFirstChild("ClickDetector"))
                SendWebhook("**Eonziey Hub** - Sniped " .. fruitName)
                return true
            end
        end
    end
    return false
end

function BloxFruits:TeleportToIsland(islandName)
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name and obj.Name:lower():find(islandName:lower()) then
            if obj:FindFirstChild("PrimaryPart") then
                TeleportTo(obj.PrimaryPart.Position + Vector3.new(0, 10, 0))
                print("Eonziey Hub: Teleported to " .. islandName)
                return true
            end
        end
    end
    print("Eonziey Hub: " .. islandName .. " not found")
    return false
end

-- ============================================
-- MAIN UI & APPLICATION
-- ============================================
local function Main()
    -- Create UI
    local Window = EonzieyLib:MakeWindow({
        Name = "Eonziey Hub",
        Title = "Eonziey Hub v3.0",
        SubTitle = "By Eonziey | Blox Fruits"
    })
    
    -- ===== AUTO FARM TAB =====
    local FarmTab = Window:MakeTab({ Name = "Auto Farm" })
    
    local farmState = false
    FarmTab:AddToggle({
        Name = "Enable AutoFarm",
        Default = false,
        Callback = function(state)
            farmState = state
            BloxFruits.Config.AutoFarmEnabled = state
            if state then
                print("Eonziey Hub: AutoFarm started")
                BloxFruits:StartAutoFarm()
                SendWebhook("**Eonziey Hub** - AutoFarm started")
            else
                print("Eonziey Hub: AutoFarm stopped")
            end
        end
    })
    
    FarmTab:AddDropdown({
        Name = "Farm Speed",
        Options = {"0.5", "1.0", "1.5", "2.0", "3.0"},
        Default = "1.0",
        Callback = function(option)
            BloxFruits.Config.FarmSpeed = tonumber(option) or 1.0
            print("Eonziey Hub: Farm speed set to " .. option)
        end
    })
    
    FarmTab:AddButton({
        Name = "Snipe Preferred Fruit",
        Callback = function()
            local fruit = Settings.PreferredFruit or "Dragon"
            local success = BloxFruits:SnipeFruit(fruit)
            if success then
                print("Eonziey Hub: Sniped " .. fruit)
            else
                print("Eonziey Hub: " .. fruit .. " not found")
            end
        end
    })
    
    FarmTab:AddTextbox({
        Name = "Set Target Fruit",
        Default = "Dragon",
        Callback = function(text)
            Settings.PreferredFruit = text
            print("Eonziey Hub: Target fruit set to " .. text)
        end
    })
    
    -- ===== TELEPORTS TAB =====
    local TeleportTab = Window:MakeTab({ Name = "Teleports" })
    
    local islands = {"Jungle", "Ice", "Sky", "Desert", "Volcano", "Prison", "Cafe", "Mansion"}
    for _, island in ipairs(islands) do
        TeleportTab:AddButton({
            Name = "Teleport to " .. island,
            Callback = function()
                BloxFruits:TeleportToIsland(island)
            end
        })
    end
    
    -- ===== SETTINGS TAB =====
    local SettingsTab = Window:MakeTab({ Name = "Settings" })
    
    SettingsTab:AddDropdown({
        Name = "Select Team",
        Options = {"Pirates", "Marines"},
        Default = Settings.JoinTeam or "Pirates",
        Callback = function(option)
            Settings.JoinTeam = option
            print("Eonziey Hub: Team set to " .. option)
        end
    })
    
    SettingsTab:AddToggle({
        Name = "Translator (Beta)",
        Default = Settings.Translator or true,
        Callback = function(state)
            Settings.Translator = state
            print("Eonziey Hub: Translator " .. (state and "ON" or "OFF"))
        end
    })
    
    SettingsTab:AddToggle({
        Name = "Anti-AFK",
        Default = Settings.AntiAFK or true,
        Callback = function(state)
            Settings.AntiAFK = state
            if state then
                StartAntiAFK()
            end
            print("Eonziey Hub: Anti-AFK " .. (state and "ON" or "OFF"))
        end
    })
    
    SettingsTab:AddTextbox({
        Name = "Discord Webhook URL",
        Default = Settings.WebhookURL or "",
        Callback = function(text)
            Settings.WebhookURL = text
            print("Eonziey Hub: Webhook set")
        end
    })
    
    -- ===== ABOUT TAB =====
    local AboutTab = Window:MakeTab({ Name = "About" })
    
    AboutTab:AddLabel({ Text = "═══════════════════════" })
    AboutTab:AddLabel({ Text = "   EONZIEY HUB v3.0" })
    AboutTab:AddLabel({ Text = "   Standalone Edition" })
    AboutTab:AddLabel({ Text = "═══════════════════════" })
    AboutTab:AddLabel({ Text = "   Created by: Eonziey" })
    AboutTab:AddLabel({ Text = "   Discord: discord.gg/eonziey" })
    AboutTab:AddLabel({ Text = "   Game: Blox Fruits" })
    AboutTab:AddLabel({ Text = "   Status: ✅ Working" })
    AboutTab:AddLabel({ Text = "═══════════════════════" })
    AboutTab:AddLabel({ Text = "   Features:" })
    AboutTab:AddLabel({ Text = "   • Auto Farm" })
    AboutTab:AddLabel({ Text = "   • Fruit Sniper" })
    AboutTab:AddLabel({ Text = "   • Teleports" })
    AboutTab:AddLabel({ Text = "   • Anti-AFK" })
    AboutTab:AddLabel({ Text = "   • Discord Webhooks" })
    AboutTab:AddLabel({ Text = "═══════════════════════" })
    AboutTab:AddLabel({ Text = "   Thanks for using!" })
    AboutTab:AddLabel({ Text = "═══════════════════════" })
    
    -- Start Anti-AFK if enabled
    if Settings.AntiAFK then
        StartAntiAFK()
    end
    
    print("Eonziey Hub loaded successfully!")
    SendWebhook("**Eonziey Hub** - Script loaded by " .. LocalPlayer.Name)
end

-- ============================================
-- SCRIPT ENTRY POINT
-- ============================================
pcall(Main)
