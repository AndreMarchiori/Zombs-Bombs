local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBomb

local ACTION_KEY = Enum.KeyCode.F
local GAMEPAD_ACTION_KEY = Enum.KeyCode.ButtonR1
local CONTEXT = "DropBomb"

local function dropBomb()
	dropBombRemoteEvent:FireServer()
end

local function handleDropBombInput(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject)
	if inputState == Enum.UserInputState.Begin then
		dropBomb()
	end
end

ContextActionService:BindAction(CONTEXT, handleDropBombInput, true, ACTION_KEY, GAMEPAD_ACTION_KEY)
ContextActionService:SetPosition(CONTEXT, UDim2.new(1, 170, 0, 60))
ContextActionService:SetTitle(CONTEXT, "Bomb!")