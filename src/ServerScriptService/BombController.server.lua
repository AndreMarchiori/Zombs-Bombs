local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb

local bombFolder = game:GetService("ServerStorage").Bombs
local bombTemplate = bombFolder.Bomb
local debouncing = {}
--[[
local function isDropBombAllowed()
	local bombsQuantity = #workspace.spawnedBombs:GetChildren()
	if bombsQuantity > 4 then
		return false
	end
	
	return true
end]]

dropBombRemoteEvent.OnServerEvent:Connect(function(player)
	if debouncing[player.UserId] then
		return
	end
	
	debouncing[player.UserId] = true
	task.delay(1, function()
		debouncing[player.UserId] = false
	end)
	--[[if not isDropBombAllowed() then
		return
	end]]
	
	local character = player.Character
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local forwardPosition = humanoidRootPart.CFrame.Position + humanoidRootPart.CFrame.LookVector * 10
	local bomb = bombTemplate:Clone()
	local Collider = bomb.Collider
	
	-- Set the bomb's mass to be lighter
	if bomb:IsA("BasePart") then
		bomb.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0.0005) -- Adjust density, friction, elasticity
	end
	
	if Collider:IsA("BasePart") then
		Collider.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0.0005) -- Adjust density, friction, elasticity
	end
	
	bomb:SetAttribute("Owner", player.UserId)
	bomb:SetAttribute("Power", player:GetAttribute("Power"))
	bomb.Parent = game.Workspace.spawnedBombs
	bomb:PivotTo(CFrame.new(forwardPosition))
	bomb.Collider.CFrame = bomb.CFrame * CFrame.new(0,-1,0)
end)

