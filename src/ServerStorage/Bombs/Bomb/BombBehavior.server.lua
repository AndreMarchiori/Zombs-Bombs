-- constantes
local EXPLOSION_TIME = 2

-- Members
local bomb = script.Parent
local owner = bomb:GetAttribute("Owner")
local power = bomb:GetAttribute("Power")

task.delay(EXPLOSION_TIME, function()
	local explosion = Instance.new("Explosion")
	local explosionPlacement = script.Parent.CFrame.Position
	local collider = bomb:WaitForChild("Collider")
	if collider and collider:IsA("BasePart") then
		if power*0.3 < 23 then
			collider.Size = Vector3.new(22.5, 22.5, 22.5)
		else
			collider.Size = Vector3.new(power * 0.3, power * 0.3, power * 0.3)
		end

		collider.Position = explosionPlacement
	end

	explosion.BlastRadius = power * 8
	explosion.BlastPressure = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.Position = explosionPlacement

	local bombExplosionSoundClone = Instance.new("Sound", bomb)
	bombExplosionSoundClone.SoundId = "rbxassetid://7586248486"
	bombExplosionSoundClone:Play()

	collider.Touched:Connect(function(hit) end)
	local part = collider:GetTouchingParts()

	local humanoids = {}

	for _, part in part do
		local success, message = pcall(function()
			local character = part.Parent
			if character then
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
