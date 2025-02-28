local Shop = {}

local MarketplaceService = game:GetService("MarketplaceService")

Shop.products = {
	["2840318647"] = {
        productId = 2840318647,
		productName = "Gold Pack 1000",
		reward = 1000,
	},
}

function Shop.BuyGold(player)
	local product = Shop.products["2840318647"].productId
	MarketplaceService:PromptProductPurchase(player, product)
end

return Shop
