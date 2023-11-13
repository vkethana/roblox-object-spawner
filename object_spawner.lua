-- Function to move the object
local function updateMotion(movingObject, motionVector)
	if movingObject:IsA("Model") then
		print("Object is a model.")
		
		local cap = 50  -- change this to cause more motion
		local i = 0
		while i < cap do
			movingObject:TranslateBy(motionVector) -- Move the Model 10 units upwards
			wait(0.001)
			i += 1
		end
	else
		print("ERROR: Obj is not a model so location cannot be translated")
	end
end

-- Function to get the asset name by ID
local function getAssetNameById(assetId)
	local success, assetInfo = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(assetId)
	end)

	if success then
		print(assetInfo)
		return assetInfo["Name"] 
	else
		return "Unknown Asset"
	end
end

local myDictionary = {
	["dog"] = 257489726,
	["car"] = 3946650318,
	["table"] = 839550130,
	["cat"] = 1718821907
}

local function getPlayerLocation()
	return game.Players.JuicyBearHamm.Character.HumanoidRootPart.Position
end

local function spawnObject(assetId, verb)
	local success, modelOrPart = pcall(function()
		return game:GetService("InsertService"):LoadAsset(assetId)
	end)

	if success then
		if modelOrPart:IsA("Model") or modelOrPart:IsA("BasePart") then
			local modelName = getAssetNameById(assetId)
			local playerLocation = getPlayerLocation()
			playerLocation = Vector3.new(playerLocation.X + 3, playerLocation.Y, playerLocation.Z)
			modelOrPart.Parent = game.Workspace
			-- local part = modelOrPart:FindFirstChild(modelName)
			-- print("Object with name " .. modelName .. " spawned successfully!")
			-- print("Info about and Position of the part is: ")
			-- print(part)
			
			
			-- print(playerLocation)
			-- print(typeof(playerLocation))
			--print(part.Position)
			

			-- local Destination = CFrame.new(playerLocation)
			-- print(Destination)
			-- modelName:SetPrimaryPartCFrame(Destination)
		
			-- print("Location reassigned successfully")
			modelOrPart:MoveTo(playerLocation)
			wait(1)
			if verb == "runs" then
				updateMotion(modelOrPart, Vector3.new(-0.5, 0, 0))
			elseif verb == 'jumps' then
				updateMotion(modelOrPart, Vector3.new(0, 0.5, 0))
				wait(0.1)
				updateMotion(modelOrPart, Vector3.new(0, 0.5, 0))
			end

		else
			modelOrPart:Destroy()
			print("Invalid object type.")
		end
	else
		print("Failed to load object with Asset ID: " .. assetId)
	end
end

-- Function to handle chat messages
local function onPlayerChatted(player, message)
	-- Check if the key exists in the dictionary
	print("Player just said " .. message)
	local words = {}
	
	-- Iterate over the words in the input string
	for word in message:gmatch("%S+") do
		table.insert(words, word)
	end
	local noun = words[1]
	local verb = ""
	if #words >= 2 then
		verb = words[2]
	-- print()
	end
	if myDictionary[noun] ~= nil then
		print("Key exists! Will generate noun : " .. myDictionary[noun] .. " with verb " .. verb)
		spawnObject(myDictionary[noun], verb)
	else
		print("Key does not exist.")
	end
end

-- Connect the function to the Chatted event of each player
game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		onPlayerChatted(player, message)
	end)
end)

--[[

local HttpService = game:GetService("HttpService")

local URL_ASTROS = "http://api.open-notify.org/astros.json"

-- Make the request to our endpoint URL
local response = HttpService:GetAsync(URL_ASTROS)

-- Parse the JSON response
local data = HttpService:JSONDecode(response)


-- Information in the data table is dependent on the response JSON
if data.message == "success" then
	print("There are currently " .. data.number .. " astronauts in space:")
	for i, person in pairs(data.people) do
		print(i .. ": " .. person.name .. " is on " .. person.craft)
	end
end

local HttpService = game:GetService("HttpService")

local URL_ASTROS = "http://api.open-notify.org/astros.json"

-- Make the request to our endpoint URL
local response = HttpService:GetAsync(URL_ASTROS)

-- Parse the JSON response
local data = HttpService:JSONDecode(response)

-- Information in the data table is dependent on the response JSON
if data.message == "success" then
	print("There are currently " .. data.number .. " astronauts in space:")
	for i, person in pairs(data.people) do
		print(i .. ": " .. person.name .. " is on " .. person.craft)
	end
end
]]-- 
