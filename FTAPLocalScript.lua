-- Go ahead and customize this however you want!

--// Services --
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera



StarterGui:SetCore("SendNotification", {Title = "Script has loaded", Text = "Have Fun!"})
StarterGui:SetCore("SendNotification", {Title = "Fling", Text = "Press (R) for fling (Set to false on default)."})
StarterGui:SetCore("SendNotification", {Title = "Aimbot", Text = "Press (Q) for aimbot."})

--// Variables --
local flingEnabled = false

local Settings = {
    BindKey = "Q" -- Custom Key
}

local isClicking = false

--// Toggle fling with R key --
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
		flingEnabled = not flingEnabled
		StarterGui:SetCore("SendNotification", {Title = "Fling Toggle", Text = "Toggle: "..tostring(flingEnabled)})
	end
end)

--// Fling Function --
Workspace.ChildAdded:Connect(function(NewModel)
	if NewModel.Name == "GrabParts" then
		local PartToImpulse = NewModel:FindFirstChild("GrabPart") and NewModel.GrabPart:FindFirstChild("WeldConstraint") and NewModel.GrabPart.WeldConstraint.Part1
		if PartToImpulse then
			local VelocityObject = Instance.new("BodyVelocity")
			VelocityObject.Parent = PartToImpulse

			NewModel:GetPropertyChangedSignal("Parent"):Connect(function()
				if not NewModel.Parent then
					if flingEnabled then
						if UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton2 then
                            local StrenghtMultiplier = math.random(100, 500)
							VelocityObject.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
							VelocityObject.Velocity = Workspace.CurrentCamera.CFrame.lookVector * StrenghtMultiplier
							Debris:AddItem(VelocityObject, 1)

                            print("Power: "..StrenghtMultiplier)
						elseif UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton1 then
							VelocityObject:Destroy()
						else
							VelocityObject:Destroy()
						end
					else
						VelocityObject:Destroy()
					end
				end
			end)
		end
	end
end)

--// Aimbot Function --

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.Character.HumanoidRootPart.Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
        
        if not isClicking then
            isClicking = true
            mouse1click()
            isClicking = false
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode[Settings.BindKey:upper()] and not gameProcessed then
        local closestPlayer = getClosestPlayer()
        aimAt(closestPlayer)
    end
end)
