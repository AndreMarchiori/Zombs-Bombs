local ReplicatedStore = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local admins = {}
local playersData = {} -- Initialize the playersData table

-- Load the AdminGui from ReplicatedStorage
local AdminGuiTemplate = ServerStorage:WaitForChild("AdminGui")

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(char)
		playersData[player.UserId] = {} -- Initialize the player's data table
		for _, admin in admins do
			if admin == player.UserId then
				local adminGui = AdminGuiTemplate:Clone()
				adminGui.Parent = player.PlayerGui
			end
		end
	end)
end

Players.PlayerRemoving:Connect(function(player)
	if playersData[player.UserId] then
		playersData[player.UserId] = nil -- Clean up the data for the leaving player
	end
end)

for _, admin:IntValue in game.ServerStorage.Admins:GetChildren() do
	if admin:IsA("IntValue") then
		table.insert(admins, admin.Value)
	end
end


Players.PlayerAdded:Connect(onPlayerAdded)

