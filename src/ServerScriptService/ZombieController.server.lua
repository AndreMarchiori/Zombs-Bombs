-- Services
local ServerStorage = game:GetService("ServerStorage")

-- Members
local enemies:Folder = ServerStorage.Enemies
local zombie:Model = enemies:FindFirstChild("Zombie")
local spawnedEnemies = workspace.spawnedEnemies
local partLocation = {
	workspace.MobSpawner1.CFrame * CFrame.new(0, 10, 0),
	workspace.MobSpawner2.CFrame * CFrame.new(0, 10, 0),
	workspace.MobSpawner3.CFrame * CFrame.new(0, 10, 0)
}
local debouncing = {}

-- Contantes
local ENEMY_POPULATION = 15
local SPAWN_DELAY = 1.5

-- Clona o zombie
local function spawnZombie()
	local newZombie = zombie:Clone()
	-- move para a workspace
	newZombie.Parent = spawnedEnemies
	-- move o newZombie para em cima da partLocation
	newZombie.HumanoidRootPart.CFrame = partLocation[math.random(1, 3)] * CFrame.new(math.random(-15, 15), 5, math.random(-15, 15))

	local humanoid = newZombie:FindFirstChildOfClass("Humanoid")

	local head:Part = newZombie:FindFirstChild("Head")
	if head then
		head.Touched:Connect(function(hit)
			local CharacterFoots = hit.Name == "RightFoot" or hit.Name == "LeftFoot"
			if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and CharacterFoots then
				
				if hit.Parent:IsA("Model") and hit.Parent.Name == "Zombie" then
					return
				end
				
				if debouncing[hit.Parent] then
					return
				end
				
				
				local dano = 55
				
				debouncing[hit.Parent] = true
				humanoid.Health -= dano
				print(hit.Parent)
				print("Zumbi tomou dano! Vida restante:", humanoid.Health)
				
				task.delay(0.8, function()
					if not(debouncing[hit.Parent] == nil)  then
					debouncing[hit.Parent] = false
					end
				end)
				
				--[[if humanoid.Health <= 0  then
					newZombie:Destroy()
				end]]
			end
		end)
	end
end

for count=1, ENEMY_POPULATION do
	spawnZombie()
end

while true do
	local population = #spawnedEnemies:GetChildren()
	if population < ENEMY_POPULATION then
		spawnZombie()
	end
	wait(SPAWN_DELAY)
end
