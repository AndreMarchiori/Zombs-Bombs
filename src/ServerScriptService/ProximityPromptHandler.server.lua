local ProximityPromptService = game:GetService("ProximityPromptService")
local MarketplaceService = game:GetService("MarketplaceService")

ProximityPromptService.PromptTriggered:Connect(function(promptObject, Player)
	MarketplaceService:PromptProductPurchase(Player, 2840318647)
end)