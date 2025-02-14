local ReplicatedStore = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local AdminPowerEditor = ReplicatedStore.AdminPowerEditor
local AdminSpeedEditor = ReplicatedStore.AdminSpeedEditor
local AdminGoldEditor = ReplicatedStore.AdminGoldEditor
local redAdminPowerEditor = ReplicatedStore.redAdminPowerEditor
local redAdminSpeedEditor = ReplicatedStore.redAdminSpeedEditor
local redAdminGoldEditor = ReplicatedStore.redAdminGoldEditor

local players = game:GetService("Players")
local PlayerGui = players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("AdminGui")
local localPlayer = players.LocalPlayer
local AdminGui = localPlayer.PlayerGui:WaitForChild("AdminGui")

local addPowerButton:TextButton = hud:WaitForChild("AddPower")
local addSpeedButton:TextButton = hud:WaitForChild("AddSpeed")
local addGoldButton:TextButton = hud:WaitForChild("AddGold")
local lessPowerButton:TextButton = hud:WaitForChild("LessPower")
local lessSpeedButton:TextButton = hud:WaitForChild("LessSpeed")
local lessGoldButton:TextButton = hud:WaitForChild("LessGold")

addPowerButton.MouseButton1Click:Connect(function()
	AdminPowerEditor:InvokeServer()
end)

addSpeedButton.MouseButton1Click:Connect(function()
	AdminSpeedEditor:InvokeServer()
end)

addGoldButton.MouseButton1Click:Connect(function()
	AdminGoldEditor:InvokeServer()
end)

lessPowerButton.MouseButton1Click:Connect(function()
	redAdminPowerEditor:InvokeServer()
end)
lessSpeedButton.MouseButton1Click:Connect(function()
	redAdminSpeedEditor:InvokeServer()
end)
lessGoldButton.MouseButton1Click:Connect(function()
	redAdminGoldEditor:InvokeServer()
end)