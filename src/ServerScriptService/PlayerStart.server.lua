--Services
local ReplicatedStore = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated
local MarketplaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")

local AdminPowerEditor = ReplicatedStore.AdminPowerEditor
local AdminSpeedEditor = ReplicatedStore.AdminSpeedEditor
local AdminGoldEditor = ReplicatedStore.AdminGoldEditor
local redAdminPowerEditor = ReplicatedStore.redAdminPowerEditor
local redAdminSpeedEditor = ReplicatedStore.redAdminSpeedEditor
local redAdminGoldEditor = ReplicatedStore.redAdminGoldEditor

local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local RequestPowerUpgradeRemoteEvent = ReplicatedStore.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = ReplicatedStore.RequestSpeedUpgrade

-- Members
local PlayerController = require(ServerStorage.Modules.PlayerController)
local playersData = PlayerController.GetPlayers()

-- Contraints
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10
local UPGRADE_COST = 10

local function onRequestPowerUpgrade(player:Player)
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		-- TODO prompt bag purchase
		MarketplaceService:PromptProductPurchase(player, 2840318647)
		return
	end

	data.gold -= UPGRADE_COST
	data.power += 1
	
	player:SetAttribute("Power", data.power)
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

local function onRequestSpeedUpgrade(player:Player)
	local data = playersData[player.UserId]
	if data.gold < UPGRADE_COST then
		-- TODO prompt bag purchase
		MarketplaceService:PromptProductPurchase(player, 2840318647)
		return
	end

	data.gold -= UPGRADE_COST
	data.speed += 1

	local character = player.Character
	if character  then
		local humanoid:Humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = data.speed
	end

	PlayerLoadedRemoteEvent:FireClient(player, data)
end

local function onEnemyDefeated(playerId:number)
	local data = playersData[playerId]
	local player = Players:GetPlayerByUserId(playerId)
	playersData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT
	PlayerLoadedRemoteEvent:FireClient(player, data)
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


-- Listeners
EnemyDefeatedBindableEvent.Event:Connect(onEnemyDefeated)
RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)
AdminPowerEditor.OnServerInvoke = addPower
redAdminPowerEditor.OnServerInvoke = remPower
AdminSpeedEditor.OnServerInvoke = addSpeed
redAdminSpeedEditor.OnServerInvoke = remSpeed
AdminGoldEditor.OnServerInvoke = addGold
redAdminGoldEditor.OnServerInvoke = remGold