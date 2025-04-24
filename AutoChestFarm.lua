local Webhook = getgenv().Webhook or ""
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local plr = Players.LocalPlayer

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local isRunning = false
local tweenSpeed = 200
local totalMoney = 0
local guiLabel = nil
local lastRollTime = 0

-- OPTIONAL: Hide player name from others (for advanced stealth)
pcall(function() plr.Name = "Unknown" end)

-- Anti-AFK
plr.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Webhook sender
local function sendWebhook(title, content)
    if Webhook == "" then return end
    local data = {
        content = "@everyone",
        embeds = {{
            title = title,
            description = content,
            color = 65280,
            footer = {text = "Crazy Hub AutoFarm"}
        }}
    }
    local json = HttpService:JSONEncode(data)
    pcall(function()
        HttpService:PostAsync(Webhook, json, Enum.HttpContentType.ApplicationJson)
    end)
end

-- GUI Money Counter (in PlayerGui)
local function createMoneyGUI()
    if guiLabel then guiLabel:Destroy() end
    local screenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
    screenGui.Name = "CrazyHubMoneyCounter"
    local textLabel = Instance.new("TextLabel", screenGui)
    textLabel.Size = UDim2.new(0, 250, 0, 30)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 0.3
    textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    textLabel.TextColor3 = Color3.new(1, 1, 0)
    textLabel.TextScaled = true
    textLabel.Text = "Money Earned: $0"
    guiLabel = textLabel
end

local function updateMoney(amount)
    totalMoney += amount
    if guiLabel then
        guiLabel.Text = "Money Earned: $" .. tostring(totalMoney)
    end
end

-- PvP check (enemy detected = stop farm)
local function isInCombat()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Team ~= plr.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 150 then return true end
        end
    end
    return false
end

-- Safe movement method
local function safeMoveTo(part)
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum or not part then return end
    hum:MoveTo(part.Position)

    local reached = false
    local timeout = 10
    local conn
    conn = hum.MoveToFinished:Connect(function(r)
        reached = r
        conn:Disconnect()
    end)

    while not reached and timeout > 0 do
        timeout -= task.wait(0.2)
        if hum.SeatPart then
            hum.Sit = false
            hum.Jump = true
        end
    end

    if reached then
        firetouchinterest(plr.Character.HumanoidRootPart, part, 0)
        task.wait(0.1 + math.random())
        firetouchinterest(plr.Character.HumanoidRootPart, part, 1)
    end
end

-- Main loop
local function runAllFarms()
    createMoneyGUI()
    local hrp = plr.Character and plr.Character:WaitForChild("HumanoidRootPart")
    local emptyCycles = 0

    while isRunning do
        if isInCombat() then
            OrionLib:MakeNotification({
                Name = "Combat Detected",
                Content = "Pausing farm during PvP...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            task.wait(5)
            continue
        end

        local foundChest = false

        for _, v in pairs(workspace:GetDescendants()) do
            if not isRunning then return end
            if v:IsA("Model") and v.Name:lower():find("chest") and v:FindFirstChildWhichIsA("MeshPart") then
                foundChest = true
                safeMoveTo(v:FindFirstChildWhichIsA("MeshPart"))
                updateMoney(1000)
                task.wait(0.4 + math.random() * 0.2)
            end
        end

        for _, tool in pairs(workspace:GetDescendants()) do
            if not isRunning then return end
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                safeMoveTo(tool.Handle)
                local name = tool.Name:lower()
                if name:find("chalice") or name:find("fist") or name:find("darkness") or name:find("fruit") then
                    sendWebhook("Item Collected", "**" .. tool.Name .. "** was collected.")
                end
                task.wait(0.8)
            end
        end

        local now = tick()
        if now - lastRollTime >= 7200 then
            local dealer = workspace:FindFirstChild("Blox Fruits Dealer") or workspace:FindFirstChild("Blox Fruit Dealer")
            if dealer and dealer:FindFirstChild("Head") then
                safeMoveTo(dealer.Head)
                firetouchinterest(hrp, dealer.Head, 0)
                task.wait(0.1)
                firetouchinterest(hrp, dealer.Head, 1)
                lastRollTime = now
                sendWebhook("Fruit Rolled", "You rolled a random fruit.")
            end
        end

        if not foundChest then
            emptyCycles += 1
        else
            emptyCycles = 0
        end

        if emptyCycles >= 2 then
            sendWebhook("Server Finished", "No more chests found.\nTotal Money Earned: **$" .. tostring(totalMoney) .. "**")
            isRunning = false
            task.wait(2)
            TeleportService:Teleport(game.PlaceId, plr)
            return
        end

        task.wait(1)
    end
end

-- GUI
local function loadMainUI()
    local MainWindow = OrionLib:MakeWindow({
        Name = "Crazy Hub | Auto Farm",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "CrazyHub"
    })

    local MainTab = MainWindow:MakeTab({
        Name = "Main",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    MainTab:AddSlider({
        Name = "Tween Speed",
        Min = 100,
        Max = 300,
        Default = tweenSpeed,
        Increment = 25,
        Callback = function(val)
            tweenSpeed = math.min(val, 300)
        end
    })

    MainTab:AddButton({
        Name = "Start Safe Farming",
        Callback = function()
            if not isRunning then
                isRunning = true
                task.spawn(runAllFarms)
            end
        end
    })

    MainTab:AddButton({
        Name = "Stop Farming",
        Callback = function()
            isRunning = false
        end
    })
end

loadMainUI()
OrionLib:Init()
