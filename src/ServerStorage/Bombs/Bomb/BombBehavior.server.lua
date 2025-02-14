-- constantes
local EXPLOSION_TIME = 2

-- Members
local bomb = script.Parent
local owner = bomb:GetAttribute("Owner")
local power = bomb:GetAttribute("Power")
local bombExplosionSound = game:GetService("SoundService").BombExplosion

task.delay(EXPLOSION_TIME, function()
	local explosion = Instance.new("Explosion")
	local explosionPlacement = script.Parent.CFrame.Position
	local count = 1

	explosion.BlastRadius = 2000
	explosion.BlastPressure = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.Position = explosionPlacement
	bomb.Collider.Position = explosionPlacement
	
	local bombExplosionSoundClone = Instance.new("Sound", bomb)
	bombExplosionSoundClone.SoundId = "rbxassetid://7586248486"
	bombExplosionSoundClone:Play()

	local collider= bomb.Collider
	collider.Touched:Connect(function(hit) end)
	local part = collider:GetTouchingParts()

	local humanoids = {}

	for _, part in part do
		local success, message = pcall(function()
			local character = part.Parent
			if character  then
				local humanoid = character:FindFirstChild("Humanoid")
				if humanoid then
					if not humanoids[humanoid] then
						humanoids[humanoid] = true
						humanoid.Health -= power
						
						humanoid:SetAttribute("LastDamageBy", owner)
					end
				end
			end
		end)
	end
	-- do it here
	explosion.Parent = workspace
	bomb:Destroy()
end)