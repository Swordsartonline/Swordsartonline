--[[
    Script: Farming Game Hub (Revised)
    Description: A streamlined and functional script focusing on working exploits and features.
    The non-functional item spawner has been removed to prevent errors.
    UI Library: Tora-Library by liebertsx
]]

-- Load the Tora UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local window = library:CreateWindow("Farming Game Hub")

--================================================================
-- Main Farming Tab
--================================================================
local mainTab = window:AddFolder("Main")

local autoCollectEnabled = false
mainTab:AddToggle({
    text = "Auto Collect All Plants",
    flag = "autoCollectToggle",
    callback = function(value)
        autoCollectEnabled = value
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if autoCollectEnabled and workspace:FindFirstChild("Plant") then
            for _, plantInstance in pairs(workspace.Plant:GetChildren()) do
                pcall(function()
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.PlantService.RE.TakePlant:FireServer(plantInstance)
                end)
                task.wait()
            end
        end
    end
end)

mainTab:AddButton({
    text = "Sell All (Legit)",
    flag = "sellAllButton",
    callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RF.Sell:InvokeServer()
        end)
    end
})

local seedTypes = {
    "Grass", "Sunflower", "Carrot", "Blueberry", "Strawberry", "Corn", "Apple", "Bamboo", "Eggplant",
    "Pineapple", "Tomato", "Pumpkin", "Banana", "Coconut", "Peach", "Grape", "Nasturtium", "Papaya"
}
mainTab:AddList({
    text = "Buy Seed",
    values = seedTypes,
    flag = "buySeedList",
    callback = function(seedName)
        pcall(function()
            game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RE.Purchase:FireServer(seedName)
        end)
    end
})

--================================================================
-- Exploits Tab
--================================================================
local exploitsTab = window:AddFolder("Exploits")

exploitsTab:AddLabel({
    text = "Sell a fake plant for massive profit."
})

exploitsTab:AddButton({
    text = "Sell 'God' Plant (Instant Cash)",
    flag = "sellGodPlant",
    callback = function()
        print("Crafting fake plant payload...")
        
        -- From the game's code, we know plant data is "Weight_MutationID".
        -- Mutation IDs: 1=None, 2=Gold(x15), 3=Rainbow(x30).
        -- We will create a fake Papaya (highest base sell price) with 500% weight and a Rainbow mutation.
        local fakePlantID = "500_3"

        -- The server likely expects a table like: { [PlantName] = { list of plant IDs } }
        local fakeInventoryPayload = {
            ["Papaya"] = {fakePlantID}
        }

        print("Attempting to invoke Sell remote with fake inventory...")
        local sellRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RF.Sell
        
        local success, result = pcall(function()
            return sellRemote:InvokeServer(fakeInventoryPayload)
        end)

        if success then
            print("Sell command successfully sent! Money gained:", result or "Unknown amount")
        else
            print("Sell command failed. The server is likely protected against this. Error:", result)
        end
    end
})

--================================================================
-- Teleports Tab
--================================================================
local teleportsTab = window:AddFolder("Teleports")
local teleportLocations = {"Garden", "Seeds", "Sell", "Items", "Quests"}
for _, location in ipairs(teleportLocations) do
    teleportsTab:AddButton({
        text = "Teleport to " .. location,
        flag = "teleportBtn_" .. location,
        callback = function()
            pcall(function()
                game:GetService("ReplicatedStorage").Packages.Knit.Services.PlantService.RE.Teleport:FireServer(location)
            end)
        end
    })
end

--================================================================
-- Player Settings Tab
--================================================================
local playerTab = window:AddFolder("Player")
local localPlayer = game:GetService("Players").LocalPlayer
playerTab:AddSlider({
    text = "WalkSpeed", min = 16, max = 250, value = 16,
    flag = "walkspeedSlider",
    callback = function(speed)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
})
playerTab:AddSlider({
    text = "JumpPower", min = 50, max = 300, value = 50,
    flag = "jumppowerSlider",
    callback = function(power)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.JumpPower = power
            localPlayer.Character.Humanoid.JumpHeight = power / 2
        end
    end
})

--================================================================
-- Initialize the UI
--================================================================
library:Init()
print("Farming Game Hub REVISED Loaded! Item Spawner removed to prevent errors.")
