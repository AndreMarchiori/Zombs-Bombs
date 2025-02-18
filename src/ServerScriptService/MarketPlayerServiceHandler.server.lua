local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerController = require(ServerStorage.Modules.PlayerController)

local playersData = PlayerController.GetPlayers()
local PlayerLoadedRemoteEvent = ReplicatedStorage.PlayerLoaded

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerID)

	if receiptInfo.ProductId == 2840318647  then
		playersData[player].gold += 1000
		wait(2)
		PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
	end
end