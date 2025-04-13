--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "Crazy Hub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

--// Sound
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9118823102"
clickSound.Volume = 1
clickSound.Parent = gui

--// Loader Screen
local loader = Instance.new("Frame")
loader.Size = UDim2.new(1, 0, 1, 0)
loader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
loader.ZIndex = 10
loader.Parent = gui

local loaderLabel = Instance.new("TextLabel")
loaderLabel.Size = UDim2.new(0, 200, 0, 50)
loaderLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
loaderLabel.BackgroundTransparency = 1
loaderLabel.Text = "Loading Crazy Hub..."
loaderLabel.TextColor3 = Color3.fromRGB(255, 125, 0)
loaderLabel.TextSize = 24
loaderLabel.Font = Enum.Font.GothamBold
loaderLabel.ZIndex = 11
loaderLabel.Parent = loader

--// Main UI
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 230)
main.Position = UDim2.new(0.5, -150, 0.5, -115)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

--// Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = main

--// Reopen Button
local reopenBtn = Instance.new("ImageButton")
reopenBtn.Size = UDim2.new(0, 60, 0, 60)
reopenBtn.Position = UDim2.new(0, 10, 0.5, -30)
reopenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
reopenBtn.Image = "rbxassetid://131964967489032"
reopenBtn.Visible = false
reopenBtn.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170, 0, 255)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = reopenBtn
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(1, 0)

--// Reopen Drag
local dragging = false
local dragInput, dragStart, startPos

reopenBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = reopenBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		reopenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--// Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundTransparency = 1
header.Text = "CRAZY HUB V4"
header.TextColor3 = Color3.fromRGB(255, 125, 0)
header.TextSize = 20
header.Font = Enum.Font.GothamBold
header.Parent = main

local beta = Instance.new("TextLabel")
beta.Size = UDim2.new(1, 0, 0, 20)
beta.Position = UDim2.new(0, 0, 0, 25)
beta.BackgroundTransparency = 1
beta.Text = "BETA"
beta.TextColor3 = Color3.fromRGB(255, 255, 0)
beta.TextSize = 14
beta.Font = Enum.Font.GothamBold
beta.Parent = main

--// Tabs
local tabMain = Instance.new("TextButton")
tabMain.Size = UDim2.new(0.5, 0, 0, 30)
tabMain.Position = UDim2.new(0, 0, 0, 50)
tabMain.Text = "Main"
tabMain.Font = Enum.Font.GothamBold
tabMain.TextSize = 14
tabMain.TextColor3 = Color3.fromRGB(255, 255, 255)
tabMain.BackgroundColor3 = Color3.fromRGB(255, 125, 0)
tabMain.BorderSizePixel = 0
tabMain.Parent = main

local tabInfo = tabMain:Clone()
tabInfo.Text = "Info"
tabInfo.Position = UDim2.new(0.5, 0, 0, 50)
tabInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
tabInfo.Parent = main

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 1, -20)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = ""
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
infoLabel.TextSize = 14
infoLabel.Font = Enum.Font.Gotham
infoLabel.Visible = false
infoLabel.Parent = main

--// Toggle Function
local function makeToggle(text, yPos)
	local base = Instance.new("Frame")
	base.Size = UDim2.new(0.9, 0, 0, 30)
	base.Position = UDim2.new(0.5, 0, 0, yPos)
	base.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	base.BorderSizePixel = 0
	base.AnchorPoint = Vector2.new(0.5, 0)
	base.Parent = main
	Instance.new("UICorner", base).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = base

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 40, 0, 20)
	btn.Position = UDim2.new(1, -45, 0.5, -10)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.Parent = base
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 16, 0, 16)
	dot.Position = UDim2.new(0, 2, 0.5, -8)
	dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dot.BorderSizePixel = 0
	dot.Parent = btn
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local on = false
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		on = not on
		local goals = {
			[btn] = {BackgroundColor3 = on and Color3.fromRGB(255, 125, 0) or Color3.fromRGB(60, 60, 65)},
			[dot] = {Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}
		}
		for obj, goal in pairs(goals) do
			TS:Create(obj, TweenInfo.new(0.2), goal):Play()
		end
		if text == "Force Accept" then
			infoLabel.Text = "Force Accept Enabled"
			infoLabel.Visible = on
		end
	end)
end

--// Toggles
makeToggle("Freeze Trade", 90)
makeToggle("Force Accept", 130)
makeToggle("Force Add Items", 170)

--// Drag Main
local drag = {enabled = false, start = nil, startPos = nil}
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		drag.enabled = true
		drag.start = input.Position
		drag.startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				drag.enabled = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if drag.enabled and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - drag.start
		main.Position = UDim2.new(
			drag.startPos.X.Scale, drag.startPos.X.Offset + delta.X,
			drag.startPos.Y.Scale, drag.startPos.Y.Offset + delta.Y
		)
	end
end)

--// Show Main After Loader
task.delay(3, function()
	loader:Destroy()
	main.Visible = true
end)

--// Close & Reopen
closeBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	main.Visible = false
	reopenBtn.Visible = true
end)

reopenBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	main.Visible = true
	reopenBtn.Visible = false
end)

--// Tabs

tabMain.MouseButton1Click:Connect(function()
	clickSound:Play()
	infoLabel.Visible = false
	tabMain.BackgroundColor3 = Color3.fromRGB(255, 125, 0)
	tabInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
end)

tabInfo.MouseButton1Click:Connect(function()
	clickSound:Play()
	infoLabel.Text = "Made With Love ❤️"
	infoLabel.Visible = true
	tabInfo.BackgroundColor3 = Color3.fromRGB(255, 125, 0)
	tabMain.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
end)
