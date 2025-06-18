--[[
    Script: Farming Game Hub
    Description: A feature-rich script for the farming game, providing autofarming,
    teleports, and player modifications.
    UI Library: Tora-Library by liebertsx
]]

-- Load the Tora UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()

-- Create the main window for the script
local window = library:CreateWindow("Farming Game Hub")

--================================================================
-- Main Farming Tab
--================================================================
local mainTab = window:AddFolder("Main")

-- Toggle for Auto Collecting Plants
local autoCollectEnabled = false
mainTab:AddToggle({
    text = "Auto Collect All Plants",
    flag = "autoCollectToggle",
    callback = function(value)
        autoCollectEnabled = value
        if value then
            print("Auto Collect Enabled")
        else
            print("Auto Collect Disabled")
        end
    end
})

-- Continuously check and collect plants if the toggle is enabled
task.spawn(function()
    while task.wait(0.5) do
        if autoCollectEnabled and workspace:FindFirstChild("Plant") then
            -- Loop through every plant in the "Plant" folder in the workspace
            for _, plantInstance in pairs(workspace.Plant:GetChildren()) do
                pcall(function()
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.PlantService.RE.TakePlant:FireServer(plantInstance)
                end)
                task.wait() -- Small delay to prevent spamming the server
            end
        end
    end
end)

-- Button to Sell All items in your inventory
mainTab:AddButton({
    text = "Sell All Items",
    flag = "sellAllButton",
    callback = function()
        print("Attempting to sell all items...")
        pcall(function()
            game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RF.Sell:InvokeServer()
        end)
        print("Sell command sent.")
    end
})

-- Dropdown list for buying seeds
local seedTypes = {
    "Grass", "Sunflower", "Carrot", "Blueberry", "Strawberry", "Corn",
    "Apple", "Bamboo", "Eggplant", "Pineapple", "Tomato", "Pumpkin",
    "Banana", "Coconut", "Peach", "Grape", "Nasturtium", "Papaya"
}

mainTab:AddList({
    text = "Buy Seed",
    values = seedTypes,
    flag = "buySeedList",
    callback = function(seedName)
        print("Attempting to purchase seed:", seedName)
        pcall(function()
            game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RE.Purchase:FireServer(seedName)
        end)
        print("Purchase command sent for:", seedName)
    end
})

--================================================================
-- Teleports Tab
--================================================================
local teleportsTab = window:AddFolder("Teleports")

-- List of available teleport locations
local teleportLocations = {"Garden", "Seeds", "Sell", "Items", "Quests"}

-- Create a button for each teleport location
for _, location in ipairs(teleportLocations) do
    teleportsTab:AddButton({
        text = "Teleport to " .. location,
        flag = "teleportBtn_" .. location,
        callback = function()
            print("Teleporting to:", location)
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

playerTab:AddLabel({text = "Modify local player stats."})

-- Slider to control WalkSpeed
playerTab:AddSlider({
    text = "WalkSpeed",
    min = 16,  -- Default WalkSpeed
    max = 250,
    value = 16,
    flag = "walkspeedSlider",
    callback = function(speed)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
})

-- Slider to control JumpPower
playerTab:AddSlider({
    text = "JumpPower",
    min = 50,  -- Default JumpPower
    max = 300,
    value = 50,
    flag = "jumppowerSlider",
    callback = function(power)
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            -- Roblox now uses JumpHeight, but some games might still use JumpPower.
            -- We will set both for compatibility.
            localPlayer.Character.Humanoid.JumpPower = power
            localPlayer.Character.Humanoid.JumpHeight = power / 2 -- A rough conversion
        end
    end
})


--================================================================
-- Initialize the UI
--================================================================
library:Init()
print("Farming Game Hub Loaded!")
