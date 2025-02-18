local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local PlayerController = require(ServerStorage.Modules.PlayerController)
local ReplicatedStore = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded

local playersData = PlayerController.GetPlayers()

MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if receiptInfo.ProductId == 2840318647  then
		playersData[receiptInfo.PlayerId].gold += 1000

		PlayerLoadedRemoteEvent:FireClient(player, playersData[receiptInfo.PlayerId])
	end
end