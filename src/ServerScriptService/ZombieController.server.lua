-- Services
local ServerStorage = game:GetService("ServerStorage")

-- Members
local enemies:Folder = ServerStorage.Enemies
local zombie:Model = enemies:FindFirstChild("Zombie")
local monster:Model = enemies:FindFirstChild("Monster")
local spawnedEnemies = workspace.spawnedEnemies
local spawnedBosses = workspace.spawnedBosses
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
end

local function spawnMonster()
	local newMonster = monster:Clone()
	newMonster.Parent = spawnedBosses
	newMonster.HumanoidRootPart.CFrame = partLocation[math.random(1, 3)] * CFrame.new(math.random(-15, 15), 5, math.random(-15, 15))
end

for count=1, ENEMY_POPULATION do
	spawnZombie()
end

local monsterDelay = false
while true do
	local population = #spawnedEnemies:GetChildren()
	local monstersCount = #spawnedBosses:GetChildren()
	if monstersCount < 1 then
		task.delay(SPAWN_DELAY*30, function()
			if monsterDelay then return end
			monsterDelay = true
			spawnMonster()
		end)
		monsterDelay = false
	end
	if population < ENEMY_POPULATION then
		spawnZombie()
	end
	wait(SPAWN_DELAY)
end
