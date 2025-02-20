local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local PlayerController = require(ServerStorage.Modules.PlayerController)
local ReplicatedStore = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded

local playersData = PlayerController.GetPlayers()

local Shop = require(ServerStorage.Modules.Shop)

MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)

	local product = Shop.products[tostring(receiptInfo.ProductId)]
	if product then
		playersData[receiptInfo.PlayerId].gold += product.reward

		PlayerLoadedRemoteEvent:FireClient(player, playersData[receiptInfo.PlayerId])
	end
end