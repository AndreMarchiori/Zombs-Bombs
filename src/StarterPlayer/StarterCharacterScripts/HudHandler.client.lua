local ReplicatedStore = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local RequestPowerUpgradeRemoteEvent = ReplicatedStore.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = ReplicatedStore.RequestSpeedUpgrade

local players = game:GetService("Players")
local PlayerGui = players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")

local addPowerButton:TextButton = hud:WaitForChild("AddPower")
local addSpeedButton:TextButton = hud:WaitForChild("AddSpeed")

local goldTag:TextLabel = hud:WaitForChild("Gold")
local powerTag:TextLabel = hud:WaitForChild("Power")
local speedTag:TextLabel = hud:WaitForChild("Speed")
local humanoid:Humanoid = script.Parent:WaitForChild("Humanoid")

PlayerLoadedRemoteEvent.OnClientEvent:Connect(function(data)
	goldTag.Text = data.gold
	powerTag.Text = data.power
	speedTag.Text = data.speed
end)

addPowerButton.MouseButton1Click:Connect(function()
	RequestPowerUpgradeRemoteEvent:FireServer()
end)

addSpeedButton.MouseButton1Click:Connect(function()
	RequestSpeedUpgradeRemoteEvent:FireServer()
end)