local ProximityPromptService = game:GetService("ProximityPromptService")
local MarketplaceService = game:GetService("MarketplaceService")
local SS = game:GetService("ServerStorage")

local PlayerController = require(SS.Modules.PlayerController)

ProximityPromptService.PromptTriggered:Connect(function(promptObject, Player)
	MarketplaceService:PromptProductPurchase(Player, 2840318647)
end)