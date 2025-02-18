local PlayerController = {}

--region Services
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
--endregion

--#region MEMBERS
local ds = DataStoreService:GetDataStore("Zombies.02.1")
local ReplicatedStore = game:GetService("ReplicatedStorage")
local PlayerLoadedRemoteEvent = ReplicatedStore.PlayerLoaded
local ServerStorage = game:GetService("ServerStorage")
local ProductPurchased: BindableEvent = ServerStorage.Network.ProductPurchased

--#endregion

--#region CONSTANTS
local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 8;
	power = 25;
}
--#endregion

local playersData = {}

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(character)
		local data = ds:GetAsync(player.UserId)
		if not data then
			data = PLAYER_DEFAULT_DATA
		end

		local leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"

		local Power = Instance.new("NumberValue", leaderstats)
		Power.Name = "Power"
		Power.Value = data.power

		local Speed = Instance.new("NumberValue", leaderstats)
		Speed.Name = "Speed"
		Speed.Value = data.speed

		local Gold = Instance.new("NumberValue", leaderstats)
		Gold.Name = "Gold"	
		Gold.Value = data.gold

		task.delay(1, function()
			while wait(1) do
				Speed.Value = data.speed
				Power.Value = data.power
				Gold.Value = data.gold
			end
		end)

		playersData[player.UserId] = data
		player:SetAttribute("Power", data.power)



		-- Wait for character to be fully loaded (Extremamente comum esse bug)
		--while not player.Character do wait(1) end

			if character then
				local humanoid:Humanoid = character:WaitForChild("Humanoid")
				if humanoid  then
					--set stats
					humanoid.WalkSpeed = data.speed
					humanoid.MaxHealth = data.power*2
					humanoid.Health = humanoid.MaxHealth
					--ragdoll
					humanoid.BreakJointsOnDeath = false
					--regen
					task.delay(1, function()
						while wait(1) do
							humanoid.MaxHealth = data.power*2
							if humanoid.Health < humanoid.MaxHealth then
								humanoid.Health += humanoid.MaxHealth/32
							end
						end
					end)
				end
			end


		-- Fire player loaded event
		PlayerLoadedRemoteEvent:FireClient(player, data)
	end)
end

local function onPlayerRemoving(player: Player)
	ds:SetAsync(player.UserId, playersData[player.UserId])
	playersData[player.UserId] = nil
end

function PlayerController.GetPlayers()
    return playersData
end

local function onProductPurchased(player :Player)
    PlayerLoadedRemoteEvent:FireClient(player, playersData[player.UserId])
end

--region LISTENERS

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
ProductPurchased.Event:Connect(onProductPurchased)
--endregion

return PlayerController