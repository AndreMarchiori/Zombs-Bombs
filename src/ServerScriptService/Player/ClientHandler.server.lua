local SS = game:GetService("ServerStorage")
local ProductPurchased:BindableEvent = SS.Network.ProductPurchased
local UpgradeRequested:BindableEvent = SS.Network.UpgradeRequested
local EnemyDefeated:BindableEvent = SS.Network.EnemyDefeated
local RP = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent:RemoteEvent = RP.PlayerLoaded
local PlayerGoldUpdated:BindableEvent = SS.Network.PlayerGoldUpdated

local PlayerController = require(SS.Modules.PlayerController)
local playersData = PlayerController.GetPlayers()

local function updatePlayerUi(player)
    PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
end

ProductPurchased.Event:Connect(updatePlayerUi)
UpgradeRequested.Event:Connect(updatePlayerUi)
EnemyDefeated.Event:Connect(updatePlayerUi)
PlayerGoldUpdated.Event:Connect(updatePlayerUi)