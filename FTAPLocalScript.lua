--// Services --
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

--// Variables --
local flingEnabled = false

print("Running Fling Script >:)")

--// Toggle fling with R key --
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
		flingEnabled = not flingEnabled
		print("Fling Enabled:", flingEnabled)
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
