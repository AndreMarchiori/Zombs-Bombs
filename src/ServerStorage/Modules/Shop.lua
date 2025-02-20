local Shop = {}

local MarketplaceService = game:GetService("MarketplaceService")

function Shop.BuyGold(player)
    MarketplaceService:PromptProductPurchase(player, 2840318647)    
end

return Shop