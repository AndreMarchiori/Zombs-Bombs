local ReplicatedStore = game:GetService("ReplicatedStorage")

local RequestPowerUpgradeRemoteEvent = ReplicatedStore.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = ReplicatedStore.RequestSpeedUpgrade
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local ServerStorage = game:GetService("ServerStorage")
local PlayerController = require(ServerStorage.Modules.PlayerController)
local shop = require(ServerStorage.Modules.Shop)
local UpgradeRequested:BindableEvent = ServerStorage.Network.UpgradeRequested

local UPGRADE_COST = 20

local playersData = PlayerController.GetPlayers()

local function canPurchaseUpgrade(player: Player)
    local data = playersData[player.UserId]
    if data.gold < UPGRADE_COST then
		shop.BuyGold(player)

		return false
	end
    return true
end

local function onRequestPowerUpgrade(player:Player)
	if not canPurchaseUpgrade(player) then
        return
    end

	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].power += 1
	
	player:SetAttribute("Power", playersData[player.UserId].power)
	UpgradeRequested:Fire(player)
end

local function onRequestSpeedUpgrade(player:Player)
	if not canPurchaseUpgrade(player) then
        return
    end

	playersData[player.UserId].gold -= UPGRADE_COST
	playersData[player.UserId].speed += 1

	local character = player.Character
	if character  then
		local humanoid:Humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = playersData[player.UserId].speed
	end

	UpgradeRequested:Fire(player)
end

RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)