--[[
    Script: Planting Simulator Helper (v2)
    Description: A comprehensive GUI for a planting game, with corrected and new features.
    Credits to the Tora Library creator.
]]

-- Load the UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()

-- Create the main window
local window = library:CreateWindow("Planting Sim Helper")

-- =================================================================
-- Farming Tab
-- =================================================================
local farmingFolder = window:AddFolder("Farming")

-- State variables to control the loops
local autoBuyActive = false
local autoCollectActive = false
local autoPlantActive = false

-- ### Auto Plant (New) ###
-- This will repeatedly plant at the specific coordinates you found.
farmingFolder:AddToggle({
    text = "Auto Plant (At Fixed Spot)",
    flag = "autoplant_toggle",
    callback = function(v)
        autoPlantActive = v
        if not v then return end

        task.spawn(function()
            while autoPlantActive do
                -- Arguments for the specific planting location
                local args = {
                    [1] = Vector3.new(34.431583404541016, 4.777867794036865, -89.13500213623047),
                    [2] = Vector3.new(-0.7385618686676025, -0.6741790771484375, -0.0030036750249564648)
                }
                game:GetService("ReplicatedStorage").Packages.Knit.Services.PlantService.RE.Item:FireServer(unpack(args))
                task.wait(0.5) -- Delay to prevent server overload
            end
        end)
    end
})

-- ### Auto Collect (Fixed) ###
-- This now correctly iterates through each plant instance.
farmingFolder:AddToggle({
    text = "Auto Collect All",
    flag = "autocollect_toggle",
    callback = function(v)
        autoCollectActive = v
        if not v then return end

        task.spawn(function()
            while autoCollectActive do
                if workspace:FindFirstChild("Plant") then
                    -- Loop through every plant model in the 'Plant' folder
                    for _, plant in ipairs(workspace.Plant:GetChildren()) do
                        if not autoCollectActive then break end -- Stop if toggle is turned off
                        
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.PlantService.RE.TakePlant:FireServer(plant)
                        task.wait() -- Small delay between each collection
                    end
                end
                task.wait(1) -- Wait 1 second before checking for new plants again
            end
        end)
    end
})

-- ### Sell All ###
farmingFolder:AddButton({
    text = "Sell All Items",
    flag = "sellall_button",
    callback = function()
        game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RF.Sell:InvokeServer()
        print("Sell All command sent to server.")
    end
})


-- =================================================================
-- Store Tab
-- =================================================================
local storeFolder = window:AddFolder("Store")

local seedList = {
    "Grass", "Sunflower", "Carrot", "Blueberry", "Strawberry", "Corn",
    "Apple", "Bamboo", "Eggplant", "Pineapple", "Tomato", "Pumpkin",
    "Banana", "Coconut", "Peach", "Grape", "Nasturtium", "Papaya"
}
local selectedSeed = seedList[1] -- Default to Grass

-- ### Buy All Seeds (New Suggestion) ###
-- This button will loop through the list and buy one of each seed.
storeFolder:AddButton({
    text = "Buy All Seeds (1 of each)",
    flag = "buyall_button",
    callback = function()
        task.spawn(function()
            print("Starting to buy all seeds...")
            for _, seedName in ipairs(seedList) do
                local args = { [1] = seedName }
                game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RE.Purchase:FireServer(unpack(args))
                print("Attempted to purchase: " .. seedName)
                task.wait(0.2) -- Small delay between purchases
            end
            print("Finished buying all seeds.")
        end)
    end
})

-- Dropdown to select a seed for auto-buying
storeFolder:AddList({
    text = "Select Seed for Auto-Buy",
    values = seedList,
    callback = function(value)
        selectedSeed = value
        print("Selected seed for auto-buy:", selectedSeed)
    end,
    flag = "seed_selector"
})

-- Toggle to automatically buy the selected seed
storeFolder:AddToggle({
    text = "Auto Buy Selected Seed",
    flag = "autobuy_toggle",
    callback = function(v)
        autoBuyActive = v
        if not v then return end
        
        task.spawn(function()
            while autoBuyActive do
                local args = { [1] = selectedSeed }
                game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RE.Purchase:FireServer(unpack(args))
                task.wait(0.5)
            end
        end)
    end
})

-- =================================================================
-- Teleports Tab
-- =================================================================
local teleportFolder = window:AddFolder("Teleports")

local teleportLocations = { "Garden", "Seeds", "Sell", "Items", "Quests" }

for _, locationName in ipairs(teleportLocations) do
    teleportFolder:AddButton({
        text = "Teleport to " .. locationName,
        flag = "teleport_" .. locationName,
        callback = function()
            local args = { [1] = locationName }
            game:GetService("ReplicatedStorage").Packages.Knit.Services.PlantService.RE.Teleport:FireServer(unpack(args))
            print("Teleporting to " .. locationName)
        end
    })
end

-- =================================================================
-- Misc Tab
-- =================================================================
local miscFolder = window:AddFolder("Misc")

miscFolder:AddButton({
    text = "Destroy GUI",
    flag = "destroy_gui_button",
    callback = function()
        library:Close()
    end
})

-- Initialize the library to make the GUI visible
library:Init()
