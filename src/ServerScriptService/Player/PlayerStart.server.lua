--Services
local ReplicatedStore = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated
local ServerStorage = game:GetService("ServerStorage")

-- Members
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local PlayerController = require(ServerStorage.Modules.PlayerController)
local playersData = PlayerController.GetPlayers()

-- Contraints
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10


local function onEnemyDefeated(playerId:number, entity:string)
	local goldEarned = GOLD_EARNED_ON_ENEMY_DEFEAT
	local data = playersData[playerId]
	local player = Players:GetPlayerByUserId(playerId)
	if entity == "Monster" then
		goldEarned *= 300
	end
	playersData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT
	PlayerLoadedRemoteEvent:FireClient(player, data)
end

-- Listeners
EnemyDefeatedBindableEvent.Event:Connect(onEnemyDefeated)