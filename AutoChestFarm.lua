-[[
                                                               ,---.           ,---.
                                                              / /"`.\.--"""--./,'"\ \
                                                              \ \    _       _    / /
                                                               `./  / __   __ \  \,'
                                                                /    /_0)_(_0\    \
                                                                |  .-'  ___  `-.  |
                                                             .--|       \_/       |--.
                                                           ,'    \   \   |   /   /    `.
                                                          /       `.  `--^--'  ,'       \
                                                       .-"""""-.    `--.___.--'     .-"""""-.
                                          .-----------/         \------------------/         \---------.
                                          | .---------\         /----------------- \         /-------. |
                                          | |          `-`--`--'                    `--'--'-'        | |
                                          | |                     CRAZY HUB - V2                     | |
                                          | |                                                        | |
                                          | |~~~~~~~~~~~~--BLOX FRUITS - AUTO FARM CHEST--~~~~~~~~~~~| |
                                          | |                                                        | |
                                          | |                   MADE BY LASPARD ;>                   | |
                                          | |                                                        | |
                                          | |________________________________________________________| |
                                          |____________________________________________________________|
                                                             )__________|__|__________(
                                                            |            ||            |
                                                            |____________||____________|
                                                              ),-----.(      ),-----.(
                                                            ,'   ==.   \    /  .==    `.
                                                           /            )  (            \
                                                           `==========='    `==========='  
]]--                                                        

getgenv().BloxFruits = {
    Team = "Pirates",
    TweenSpeed = 350,
    Fruit = {
        AutoRandom = true,
        FruitNotifier = false,
        FruitSniper = {
            Enabled = false,
            TargetFruits = {"Dragon-Dragon", "Yeti-Yeti"}
        }
    },
    Farm = {
        Enabled = true,
        AutoHop = true,
        ItemHop = true,
        BlatantMethod = false
    },
    Webhook = {
        Enabled = true,
        URL = game:GetService("HttpService"):Base64Decode("REPLACE_WITH_BASE64_WEBHOOK"),
        UserId = "123456789012345678"
    },
    AntiIdle = true,
    FpsBoost = true
}

local correctKey = "CRAZYHUB_rOB4u3DYObkWNZH3KQmpwCwIf7I"
local keyURL = "https://direct-link.net/1292294/crazy-hub-key-system"
local keyFile = "CrazyHubKey.txt"

pcall(function()
    if isfile and readfile and isfile(keyFile) then
        getgenv().CrazyHub_Key = readfile(keyFile)
    end
end)

getgenv().CrazyHub_Key = getgenv().CrazyHub_Key or ""
getgenv().Webhook = getgenv().Webhook or getgenv().BloxFruits.Webhook.URL

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local isRunning = false
local guiLabel = nil
local totalMoney = 0

if getgenv().BloxFruits.AntiIdle then
    plr.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
        VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
    end)
end

if getgenv().BloxFruits.FpsBoost then
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
    end
    settings().Rendering.QualityLevel = 1
end

local function sendWebhook(title, description)
    if getgenv().BloxFruits.Webhook.Enabled and getgenv().Webhook ~= "" then
        local payload = {
            content = "<@" .. (getgenv().BloxFruits.Webhook.UserId or "") .. ">",
            embeds = {{title = title, description = description, color = 65280}}
        }
        pcall(function()
            HttpService:PostAsync(getgenv().Webhook, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
        end)
    end
end

local function hopToLowServer()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local req = (syn and syn.request) or request or http_request
    local body = req and req({Url = url, Method = "GET"})
    if body and body.Body then
        local servers = HttpService:JSONDecode(body.Body)
        for _, srv in pairs(servers.data) do
            if srv.playing < 20 and srv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, plr)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId, plr)
end

local function createMoneyGUI()
    if guiLabel then guiLabel:Destroy() end
    local g = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
    local l = Instance.new("TextLabel", g)
    l.Size = UDim2.new(0, 250, 0, 30)
    l.Position = UDim2.new(0, 10, 0, 10)
    l.BackgroundTransparency = 0.3
    l.BackgroundColor3 = Color3.new(0, 0, 0)
    l.TextColor3 = Color3.new(1, 1, 0)
    l.TextScaled = true
    l.Text = "Money Earned: $0"
    guiLabel = l
end

local function updateMoney(amount)
    totalMoney += amount
    if guiLabel then guiLabel.Text = "Money Earned: $" .. totalMoney end
end

local function isInCombat()
    local char = plr.Character
    local tag = char and (char:FindFirstChild("InCombat") or char:FindFirstChild("Combat"))
    return tag and tag:IsA("BoolValue") and tag.Value
end

local function storeFruit(fruit)
    local remote = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("CommF_")
    if remote then
        pcall(function() remote:InvokeServer("StoreFruit", fruit) end)
        sendWebhook("Fruit Stored", "Stored **"..fruit.."**")
    end
end

local function safeMoveTo(part)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not part or not hum then return end
    local dist = (hrp.Position - part.Position).Magnitude
    local t = dist / (getgenv().BloxFruits.TweenSpeed or 300)
    local tween = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
    })
    tween:Play()
    local monitor = task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if hum.Sit then hum.Sit = false hum.Jump = true end
            task.wait(0.25)
        end
    end)
    tween.Completed:Wait()
    task.cancel(monitor)
    firetouchinterest(hrp, part, 0)
    task.wait(0.1)
    firetouchinterest(hrp, part, 1)
end

local function runAllFarms()
    createMoneyGUI()
    local hrp = plr.Character:WaitForChild("HumanoidRootPart")
    local emptyCycles = 0
    while isRunning do
        if isInCombat() then
            OrionLib:MakeNotification({Name="Combat Detected", Content="Paused due to PvP!", Time=4})
            task.wait(5)
            continue
        end
        local found = false
        for _, tool in pairs(workspace:GetDescendants()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local name = tool.Name:lower()
                if name:find("fruit") or name:find("chalice") or name:find("fist") then
                    found = true
                    safeMoveTo(tool.Handle)
                    sendWebhook("Item Collected", "**"..tool.Name.."** collected")
                    storeFruit(tool.Name)
                    if getgenv().BloxFruits.Farm.ItemHop then
                        TeleportService:Teleport(game.PlaceId)
                        return
                    end
                end
            end
        end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find("chest") and v:FindFirstChildWhichIsA("MeshPart") then
                found = true
                safeMoveTo(v:FindFirstChildWhichIsA("MeshPart"))
                updateMoney(1000)
            end
        end
        if not found then
            emptyCycles += 1
        else
            emptyCycles = 0
        end
        if emptyCycles >= 2 and getgenv().BloxFruits.Farm.AutoHop then
            sendWebhook("Server Hop", "No more chests. Hopping server...")
            TeleportService:Teleport(game.PlaceId)
            return
        end
        task.wait(0.5)
    end
end

local function loadMainUI()
    local MainWindow = OrionLib:MakeWindow({ Name = "CrazyHub | Chest Auto Farm", HidePremium = false, SaveConfig = false })
    local MainTab = MainWindow:MakeTab({ Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false })
    MainTab:AddSlider({ Name = "Tween Speed", Min = 100, Max = 600, Default = getgenv().BloxFruits.TweenSpeed, Increment = 25, Callback = function(val) getgenv().BloxFruits.TweenSpeed = val end })
    MainTab:AddButton({ Name = "Start Farming", Callback = function() if not isRunning then isRunning = true task.spawn(runAllFarms) end end })
    MainTab:AddButton({ Name = "Stop Farming", Callback = function() isRunning = false end })
end

if getgenv().CrazyHub_Key == correctKey then
    loadMainUI()
    OrionLib:Init()
else
    local KeyWindow = OrionLib:MakeWindow({ Name = "Crazy Hub | Keysystem", IntroText = "Loading CrazyHub", SaveConfig = false })
    local KeyTab = KeyWindow:MakeTab({ Name = "Enter Key", Icon = "rbxassetid://4483345998", PremiumOnly = false })
    local userKey = ""
    KeyTab:AddTextbox({ Name = "Enter Key", Default = "", Callback = function(v) userKey = v end })
    KeyTab:AddButton({
        Name = "Submit Key",
        Callback = function()
            if userKey == correctKey then
                getgenv().CrazyHub_Key = userKey
                pcall(function()
                    if writefile then writefile(keyFile, userKey) end
                end)
                OrionLib:Destroy()
                OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
                loadMainUI()
                OrionLib:Init()
            else
                OrionLib:MakeNotification({ Name = "Invalid Key", Content = "Incorrect key!", Time = 4 })
            end
        end
    })
    KeyTab:AddButton({
        Name = "Get Key",
        Callback = function()
            setclipboard(keyURL)
            OrionLib:MakeNotification({ Name = "Key Copied", Content = "Copied key link to clipboard", Time = 5 })
        end
    })
    OrionLib:Init()
end
