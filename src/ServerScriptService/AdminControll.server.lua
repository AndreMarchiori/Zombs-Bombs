local ReplicatedStore = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local AdminPowerEditor = ReplicatedStore.AdminPowerEditor
local AdminSpeedEditor = ReplicatedStore.AdminSpeedEditor
local AdminGoldEditor = ReplicatedStore.AdminGoldEditor
local redAdminPowerEditor = ReplicatedStore.redAdminPowerEditor
local redAdminSpeedEditor = ReplicatedStore.redAdminSpeedEditor
local redAdminGoldEditor = ReplicatedStore.redAdminGoldEditor

local PlayerController = require(ServerStorage.Modules.PlayerController)
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local admins = {}
local playersData = PlayerController.GetPlayers

-- Load the AdminGui from ReplicatedStorage
local AdminGuiTemplate = ServerStorage:WaitForChild("AdminGui")

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(char)
		playersData[player.UserId] = {} -- Initialize the player's data table
		for _, admin in admins do
			if admin == player.UserId then
				local adminGui = AdminGuiTemplate:Clone()
				adminGui.Parent = player.PlayerGui
			end
		end
	end)
end

Players.PlayerRemoving:Connect(function(player)
	if playersData[player.UserId] then
		playersData[player.UserId] = nil -- Clean up the data for the leaving player
	end
end)

for _, admin:IntValue in game.ServerStorage.Admins:GetChildren() do
	if admin:IsA("IntValue") then
		table.insert(admins, admin.Value)
	end
end

function addPower(player: Player)
	local data = playersData[player.UserId]
	data.power += 10
	player:SetAttribute("Power", data.power)
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

function addSpeed(player: Player)
	local data = playersData[player.UserId]
	data.speed += 10
	PlayerLoadedRemoteEvent:FireClient(player, data)
	local character = player.Character
	if character  then
		local humanoid:Humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = data.speed
	end
end

function addGold(player: Player)
	local data = playersData[player.UserId]
	data.gold += 100
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

function remPower(player: Player)
	local data = playersData[player.UserId]
	data.power -= 10
	player:SetAttribute("Power", data.power)
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

function remSpeed(player: Player)
	local data = playersData[player.UserId]
	data.speed -= 10
	PlayerLoadedRemoteEvent:FireClient(player, data)
	local character = player.Character
	if character  then
		local humanoid:Humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = data.speed
	end
end

function remGold(player: Player)
	local data = playersData[player.UserId]
	data.gold -= 1000
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

AdminPowerEditor.OnServerInvoke = addPower
redAdminPowerEditor.OnServerInvoke = remPower
AdminSpeedEditor.OnServerInvoke = addSpeed
redAdminSpeedEditor.OnServerInvoke = remSpeed
AdminGoldEditor.OnServerInvoke = addGold
redAdminGoldEditor.OnServerInvoke = remGold

Players.PlayerAdded:Connect(onPlayerAdded)

