-- Members
local zombie = script.Parent
local humanoid :Humanoid= zombie.Humanoid
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated

local conexao :RBXScriptConnection
conexao = humanoid.Died:Connect(function()
	local playerId = humanoid:GetAttribute("LastDamageBy")
	EnemyDefeatedBindableEvent:Fire(playerId, zombie.Name)
	conexao:Disconnect()
end)
