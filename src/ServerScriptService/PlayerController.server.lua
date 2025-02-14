--Services
local ReplicatedStore = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local AdminPowerEditor = ReplicatedStore.AdminPowerEditor
local AdminSpeedEditor = ReplicatedStore.AdminSpeedEditor
local AdminGoldEditor = ReplicatedStore.AdminGoldEditor
local redAdminPowerEditor = ReplicatedStore.redAdminPowerEditor
local redAdminSpeedEditor = ReplicatedStore.redAdminSpeedEditor
local redAdminGoldEditor = ReplicatedStore.redAdminGoldEditor

local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local RequestPowerUpgradeRemoteEvent = ReplicatedStore.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = ReplicatedStore.RequestSpeedUpgrade
local PlayerDeathNotifier = ReplicatedStore:WaitForChild("PlayerDeathNotifier")

-- Members
local ds = DataStoreService:GetDataStore("Zombies.02.1")
local playersData = {}

-- Contraints
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10
local UPGRADE_COST = 10
local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 8;
	power = 25;
}

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

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(character)
		local data = ds:GetAsync(player.UserId)
		if not data then
			data = PLAYER_DEFAULT_DATA
		end

		local leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"

		local Power = Instance.new("NumberValue", leaderstats)
		Power.Name = "Power"
		Power.Value = data.power

		local Speed = Instance.new("NumberValue", leaderstats)
		Speed.Name = "Speed"
		Speed.Value = data.speed

		local Gold = Instance.new("NumberValue", leaderstats)
		Gold.Name = "Gold"	
		Gold.Value = data.gold

		task.delay(1, function()
			while wait(1) do
				Speed.Value = data.speed
				Power.Value = data.power
				Gold.Value = data.gold
			end
		end)

		playersData[player.UserId] = data
		player:SetAttribute("Power", data.power)



		-- Wait for character to be fully loaded (Extremamente comum esse bug)
		--while not player.Character do wait(1) end

			if character then
				local humanoid:Humanoid = character:WaitForChild("Humanoid")
				if humanoid  then
					--set stats
					humanoid.WalkSpeed = data.speed
					humanoid.MaxHealth = data.power*2
					humanoid.Health = humanoid.MaxHealth
					--ragdoll
					humanoid.BreakJointsOnDeath = false
					--regen
					task.delay(1, function()
						while wait(1) do
							humanoid.MaxHealth = data.power*2
							if humanoid.Health < humanoid.MaxHealth then
								humanoid.Health += humanoid.MaxHealth/32
							end
						end
					end)
				end
			end


		-- Fire player loaded event
		PlayerLoadedRemoteEvent:FireClient(player, data)
	end)
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
	data.gold -= 100
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

local function onPlayerRemoving(player: Player)
	ds:SetAsync(player.UserId, playersData[player.UserId])
	playersData[player.UserId] = nil
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

ProximityPromptService.PromptTriggered:Connect(function(promptObject, Player)
	MarketplaceService:PromptProductPurchase(Player, 2840318647)
end)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = receiptInfo.PlayerId

	if receiptInfo.ProductId == 2840318647  then
		playersData[player].gold += 1000
		wait(2)
		PlayerLoadedRemoteEvent:FireClient(player, playersData[player])
	end
end