-- Services
local SS = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local PlayerController = require(SS.Modules.PlayerController)

--members
local playersData = PlayerController.GetPlayers()
local EnemyDefeated:BindableEvent = SS.Network.EnemyDefeated
local PlayerGoldUpdated:BindableEvent = SS.Network.PlayerGoldUpdated

-- Contraints
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10

local function onEnemyDefeated(playerId:number, entity:string)
	local goldEarned = GOLD_EARNED_ON_ENEMY_DEFEAT
	local player = Players:GetPlayerByUserId(playerId)
	if entity == "Monster" then
		goldEarned *= 300
	end
	playersData[player.UserId].gold += goldEarned
	PlayerGoldUpdated:Fire(player)
end

EnemyDefeated.Event:Connect(onEnemyDefeated)