--[[
    Script: Planting Simulator Helper
    Description: A comprehensive GUI for a planting game, featuring auto-farming, teleports, and more.
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

local seedList = {
    "Grass", "Sunflower", "Carrot", "Blueberry", "Strawberry", "Corn",
    "Apple", "Bamboo", "Eggplant", "Pineapple", "Tomato", "Pumpkin",
    "Banana", "Coconut", "Peach", "Grape", "Nasturtium", "Papaya"
}
local selectedSeed = seedList[1] -- Default to Grass
local autoBuyActive = false
local autoCollectActive = false

-- Dropdown to select a seed for auto-buying
farmingFolder:AddList({
    text = "Select Seed",
    values = seedList,
    callback = function(value)
        selectedSeed = value
        print("Selected seed for auto-buy:", selectedSeed)
    end,
    flag = "seed_selector"
})

-- Toggle to automatically buy the selected seed
farmingFolder:AddToggle({
    text = "Auto Buy Selected Seed",
    flag = "autobuy_toggle",
    callback = function(v)
        autoBuyActive = v
        if not v then return end -- Stop if toggled off
        
        -- Start the loop in a new thread to prevent freezing
        task.spawn(function()
            while autoBuyActive do
                local args = { [1] = selectedSeed }
                game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RE.Purchase:FireServer(unpack(args))
                task.wait(0.5) -- Wait before buying again to avoid spam
            end
        end)
    end
})

-- Toggle to automatically collect all plants
farmingFolder:AddToggle({
    text = "Auto Collect All",
    flag = "autocollect_toggle",
    callback = function(v)
        autoCollectActive = v
        if not v then return end -- Stop if toggled off

        -- Start the loop in a new thread
        task.spawn(function()
            while autoCollectActive do
                if workspace:FindFirstChild("Plant") then
                    for i, plant in ipairs(workspace.Plant:GetChildren()) do
                        if not autoCollectActive then break end -- Check if toggle was disabled during loop
                        
                        -- Fire the remote event to collect the plant
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.PlantService.RE.TakePlant:FireServer(plant)
                        task.wait() -- Small delay between each plant
                    end
                end
                task.wait(1) -- Wait 1 second before scanning for new plants
            end
        end)
    end
})

-- Button to sell all items at once
farmingFolder:AddButton({
    text = "Sell All Items",
    flag = "sellall_button",
    callback = function()
        -- InvokeServer is used for functions that return a value, but can be used like FireServer here
        game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RF.Sell:InvokeServer()
        print("Sell All command sent to server.")
    end
})

-- =================================================================
-- Teleports Tab
-- =================================================================
local teleportFolder = window:AddFolder("Teleports")

local teleportLocations = { "Garden", "Seeds", "Sell", "Items", "Quests" }

-- Create a button for each teleport location
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
