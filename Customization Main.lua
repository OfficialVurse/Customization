local PaintEvent = game.ReplicatedStorage.CustomizationEvents.ColorPaint
local RimEvent = game.ReplicatedStorage.CustomizationEvents.RimPaint
local ReflectanceEvent = game.ReplicatedStorage.CustomizationEvents.WindowReflectance
local TeleportEvent = game.ReplicatedStorage.CustomizationEvents.TeleportEvent
local ExitEvent = game.ReplicatedStorage.CustomizationEvents.ExitGarage
---
local Garage1Occupant = false
local Garage2Occuapnt = false
---
local ServerStorage = game:GetService("ServerStorage")
---- Garage
local Teleport1 = game.Workspace.Garage.Teleport1
local Teleport2 = game.Workspace.Garage.Teleport2

local function anchor(object)
	local descendants = object:GetDescendants()

	for i, descendant in pairs(descendants) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
		end
	end
end

local function unanchor(object)
	local descendants = object:GetDescendants()

	for i, descendant in pairs(descendants) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = false
		end
	end
end

PaintEvent.OnServerEvent:Connect(function(player,PaintCost)
	local PlayersCar = game.Workspace:FindFirstChild(player.Name.."sCar")
	if PlayersCar then
		local leaderstats = player:WaitForChild("leaderstats")
		local OwnedColorsFolder = player:WaitForChild("OwnedColors")
		local OwnedColor = OwnedColorsFolder:FindFirstChild(PlayersCar.CarName.Value)
		local Color = player.PlayerGui.PaintGUI.Frame.ColorPaint.ColorValue.Value

		local function Paint(PlayersCar)
			local Body = PlayersCar:WaitForChild("Body")
			local PaintModel = Body:WaitForChild("Paint")

			if PaintModel then -- Found paint model
				for i,v in pairs(PaintModel:GetChildren()) do
					v.BrickColor = Color
					OwnedColor.Value = v.BrickColor.Name
				end
			end
		end

		if PlayersCar then -- Player has spawned car
			if OwnedColor then -- Found car in the folder
				if leaderstats.Money.Value > PaintCost then--- if player has enough money to paint and pay
					Paint(PlayersCar)
					leaderstats.Money.Value = leaderstats.Money.Value - PaintCost
				end
			end
		elseif not PlayersCar then
			print(player.." has no spawned car,event canceled")
		end
	elseif not PlayersCar then
		print(player.." has no spawned car,event canceled")
	end

end)


RimEvent.OnServerEvent:Connect(function(player,PaintCost)
	local PlayersCar = game.Workspace:FindFirstChild(player.Name.."sCar")
	if PlayersCar then
		local leaderstats = player:WaitForChild("leaderstats")
		local OwnedColorsFolder = player:WaitForChild("OwnedRimColor")
		local OwnedColor = OwnedColorsFolder:FindFirstChild(PlayersCar.CarName.Value)
		local Color = player.PlayerGui.PaintGUI.Frame.RimPaint.ColorValue.Value

		local function Paint(PlayersCar)
			local Body = PlayersCar:WaitForChild("Wheels")
			for index, descendant in pairs(Body:GetDescendants()) do
				if descendant.Name == "Rim" then 
					descendant.BrickColor = Color
					OwnedColor.Value = descendant.BrickColor.Name
				end
			end
		end

		local leaderstats = player:WaitForChild("leaderstats")
		if leaderstats.Money.Value > PaintCost then--- if player has enough money to paint and pay
			Paint(PlayersCar)
			leaderstats.Money.Value = leaderstats.Money.Value - PaintCost
		end
	end
end)


ReflectanceEvent.OnServerEvent:Connect(function(player,Reflectance,ReflectanceCost)
	local Car = game.Workspace:FindFirstChild(player.Name.."sCar")
	if Car then --- we found players car
		local WindowModel = Car:WaitForChild("Body"):WaitForChild("Windows")
		if WindowModel then
			for i,v in pairs(WindowModel:GetChildren()) do
				if player.leaderstats.Money.Value > ReflectanceCost then
					v.Reflectance = Reflectance
					player.leaderstats.Money.Value = player.leaderstats.Money.Value - ReflectanceCost
					player.OwnedReflectance:FindFirstChild(Car.CarName.Value).Value = Reflectance				
				end
			end
		end
	end
end)

TeleportEvent.OnServerEvent:Connect(function(player,Garage)
	local Car = game.Workspace:FindFirstChild(player.Name.."sCar")

	if Car then
		if Garage == 1 and Garage1Occupant == false then
			game.Workspace:FindFirstChild(player.Name).Humanoid.Sit = false
			wait(.1)
			Car:SetPrimaryPartCFrame(Teleport1.CFrame + Teleport1.CFrame.LookVector)
			game.Workspace:FindFirstChild(player.Name):MoveTo(game.Workspace.Garage.Enter1.Position)
			player.PlayerGui.PaintGUI.Frame.Garage1.Value = true
			game.Workspace.Garage.Enter1.ProximityPrompt.Enabled = false
			Garage1Occupant = true
			wait(1)
			anchor(Car)
		elseif Garage == 2 and Garage2Occuapnt == false then
			game.Workspace:FindFirstChild(player.Name).Humanoid.Sit = false
			wait(.1)
			Car:SetPrimaryPartCFrame(Teleport2.CFrame + Teleport2.CFrame.LookVector)
			game.Workspace:FindFirstChild(player.Name):MoveTo(game.Workspace.Garage.Enter2.Position)
			player.PlayerGui.PaintGUI.Frame.Garage2.Value = true
			game.Workspace.Garage.Enter2.ProximityPrompt.Enabled = false
			Garage2Occuapnt = true
			wait(1)
			anchor(Car)
		end
	end
end)

ExitEvent.OnServerEvent:Connect(function(player,Exit)
	local Car = game.Workspace:FindFirstChild(player.Name.."sCar")

	if Car then
		if Exit == 1 and Garage1Occupant == true then
			Car:SetPrimaryPartCFrame(game.Workspace.Garage.Enter1.CFrame)
			local Humanoid = player.Character:WaitForChild("Humanoid")
			game.Workspace.Garage.Enter1.ProximityPrompt.Enabled = true
			Garage1Occupant = false
			player.PlayerGui.PaintGUI.Frame.Garage1.Value = false
			unanchor(Car)
			wait(1)
			Car.DriveSeat:Sit(Humanoid)
		elseif Exit == 2 and Garage2Occuapnt == true then
			Car:SetPrimaryPartCFrame(game.Workspace.Garage.Enter2.CFrame)
			local Humanoid = player.Character:WaitForChild("Humanoid")
			game.Workspace.Garage.Enter2.ProximityPrompt.Enabled = true
			Garage2Occuapnt = false
			player.PlayerGui.PaintGUI.Frame.Garage2.Value = false
			unanchor(Car)
			wait(1)
			Car.DriveSeat:Sit(Humanoid)
		end
	end
end)