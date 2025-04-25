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

print([[
                                                               ,---.           ,---.
                                                              / /".\.--"""--./,'"\ \
                                                              \ \    _       _    / /
                                                               ./  / __   __ \  \,'
                                                                /    /_0)_(_0\    \
                                                                |  .-'  ___  -.  |
                                                             .--|       \_/       |--.
                                                           ,'    \   \   |   /   /    .
                                                          /       .  --^--'  ,'       \
                                                       .-"""""-.    --.___.--'     .-"""""-.
                                          .-----------/         \------------------/         \---------.
                                          | .---------\         /----------------- \         /-------. |
                                          | |          -----'                    --'--'-'        | |
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
                                                            ,'   ==.   \    /  .==    .
                                                           /            )  (            \
                                                           ==========='    ==========='  
]])

local correctKey = "CRAZYHUB_rOB4u3DYObkWNZH3KQmpwCwIf7I"
local keyURL = "https://direct-link.net/1292294/crazy-hub-key-system"
local keyFile = "CrazyHubKey.txt"

pcall(function()
    if isfile and readfile and isfile(keyFile) then
        getgenv().CrazyHub_Key = readfile(keyFile)
    end
end)

getgenv().CrazyHub_Key = getgenv().CrazyHub_Key or ""
getgenv().Webhook = getgenv().Webhook or ""
getgenv().EnableWebhook = true
getgenv().EnableServerHop = true
getgenv().SelectedTeam = "Pirates"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local isRunning, tweenSpeed, totalMoney = false, 250, 0
local guiLabel = nil

plr.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local function sendWebhook(title, content)
    if getgenv().Webhook == "" or getgenv().EnableWebhook == false then return end
    local data = {
        content = "@everyone",
        embeds = {{
            title = title,
            description = content,
            color = 65280,
            footer = {text = "Crazy Hub AutoFarm"}
        }}
    }
    pcall(function()
        HttpService:PostAsync(getgenv().Webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

local function hopToLowServer()
    if not getgenv().EnableServerHop then return end
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
    local t = dist / tweenSpeed
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
    if getgenv().SelectedTeam == "Pirates" or getgenv().SelectedTeam == "Marines" then
        local r = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("CommF_")
        if r then pcall(function() r:InvokeServer("SetTeam", getgenv().SelectedTeam) end) end
    end

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
        for _, v in pairs(workspace:GetDescendants()) do
            if not isRunning then return end
            if v:IsA("Model") and v.Name:lower():find("chest") and v:FindFirstChildWhichIsA("MeshPart") then
                found = true
                safeMoveTo(v:FindFirstChildWhichIsA("MeshPart"))
                updateMoney(1000)
                task.wait(0.2)
            end
        end

        for _, tool in pairs(workspace:GetDescendants()) do
            if not isRunning then return end
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                safeMoveTo(tool.Handle)
                local name = tool.Name:lower()
                if name:find("fruit") or name:find("chalice") or name:find("darkness") or name:find("fist") then
                    sendWebhook("Item Collected", "**"..tool.Name.."** collected")
                    task.wait(1)
                    storeFruit(tool.Name)
                end
                task.wait(0.3)
            end
        end

        if not found then emptyCycles += 1 else emptyCycles = 0 end

        if emptyCycles >= 2 then
            sendWebhook("Server Finished", "No chests found.\nMoney: $"..totalMoney)
            totalMoney = 0
            isRunning = false
            task.wait(1)
            hopToLowServer()
            return
        end

        task.wait(0.5)
    end
end

local function loadMainUI()
    local MainWindow = OrionLib:MakeWindow({ Name = "CrazyHub | AutoFarm", HidePremium = false, SaveConfig = false })
    local MainTab = MainWindow:MakeTab({ Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false })
    MainTab:AddSlider({ Name = "Tween Speed", Min = 100, Max = 600, Default = tweenSpeed, Increment = 25, Callback = function(val) tweenSpeed = val end })
    MainTab:AddButton({ Name = "Start Farming", Callback = function() if not isRunning then isRunning = true task.spawn(runAllFarms) end end })
    MainTab:AddButton({ Name = "Stop Farming", Callback = function() isRunning = false end })

    local SettingsTab = MainWindow:MakeTab({ Name = "Settings", Icon = "rbxassetid://4483345998", PremiumOnly = false })
    SettingsTab:AddDropdown({ Name = "Select Team", Default = "Pirates", Options = {"Pirates", "Marines"}, Callback = function(val) getgenv().SelectedTeam = val end })
    SettingsTab:AddToggle({ Name = "Enable Server Hop", Default = true, Callback = function(val) getgenv().EnableServerHop = val end })
    SettingsTab:AddToggle({ Name = "Enable Webhook", Default = true, Callback = function(val) getgenv().EnableWebhook = val end })
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
                pcall(function() if writefile then writefile(keyFile, userKey) end end)
                OrionLib:MakeNotification({Name="Access Granted", Content="Welcome!", Time=4})
                task.delay(1, function()
                    OrionLib:Destroy()
                    OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
                    loadMainUI()
                    OrionLib:Init()
                end)
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
