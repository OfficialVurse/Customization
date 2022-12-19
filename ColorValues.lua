local players = game:GetService("Players")
local dataStore = game:GetService("DataStoreService")

local NismoDS = dataStore:GetDataStore("Nismo")
local NismoRimDS = dataStore:GetDataStore("NismoRim")
local NismorelfectanceDS = dataStore:GetDataStore("Nismorelfactance")

players.PlayerAdded:Connect(function(player)
	
	local folder = Instance.new("Folder")
	folder.Name = "OwnedColors"
	folder.Parent = player
	
	local Nismo = Instance.new("StringValue")
	Nismo.Name = "Nismo"
	Nismo.Parent = player:WaitForChild("OwnedColors")	
	
	local folder2 = Instance.new("Folder", player)
	folder2.Name = "OwnedRimColor"
	
	local NismoRim = Instance.new("StringValue")
	NismoRim.Name = "Nismo"
	NismoRim.Parent = player:WaitForChild("OwnedRimColor")
	
	local folder3 = Instance.new("Folder")
	folder3.Name = "OwnedReflectance"
	folder3.Parent = player
	
	local Nismorelfectance = Instance.new("NumberValue")
	Nismorelfectance.Name = "Nismo"
	Nismorelfectance.Parent = player:WaitForChild("OwnedReflectance")
	
	local data
	local success, ret = pcall(function()
		data = NismoDS:GetAsync(player.UserId)
	end)
	
	local data2 
	local suc, err = pcall(function()
		data2 = NismoRimDS:GetAsync(player.UserId)
	end)
	
	local data3
	local s, e = pcall(function()
		data3 = NismorelfectanceDS:GetAsync(player.UserId)
	end)
	
	if success then 
		Nismo.Value = data
	else 
		warn(ret)
	end
	
	if suc then 
		NismoRim.Value = data2
	else 
		warn(err)
	end
	
	if s then 
		Nismorelfectance.Value = data3
	else 
		warn(e)
	end
end)


players.PlayerRemoving:Connect(function(player)
	local success, ret = pcall(function()
		NismoDS:SetAsync(player.UserId, player.OwnedColors.Nismo.Value)
	end)
	
	local suc, err = pcall(function()
		NismoRimDS:SetAsync(player.UserId, player.OwnedRimColor.Nismo.Value)
	end)
	
	local s, e = pcall(function()
		NismorelfectanceDS:SetAsync(player.UserId, player.OwnedReflectance.Nismo.Value)
	end)
	
	if success then 
		print("Success")
	else 
		warn(ret)
	end

	if suc then 
		print("Success")
	else 
		warn(err)
	end

	if s then 
		print("Success")
	else 
		warn(e)
	end
end)



