--[[
    Script: Farming Game Hub
    Description: A feature-rich script for the farming game, providing autofarming,
    teleports, player modifications, and item exploits.
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

-- (Auto-collect, Sell All, Buy Seed code is the same as before)
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
    text = "Sell All Items",
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
-- Item Exploits Tab (NEW!)
--================================================================
local exploitsTab = window:AddFolder("Exploits")

exploitsTab:AddLabel({
	text = "WARNING: This is experimental."
})
exploitsTab:AddLabel({
	text = "You need a Remote Spy to find an event that gives items."
})

--[[
    !!!! IMPORTANT !!!!
    You MUST replace this with the real remote path you find with a remote spy.
    It will likely be in ReplicatedStorage.Packages.Knit.Services...
    Try looking for Remotes named: GiveItem, AddItem, AdminGive, Reward, etc.
]]
local placeholderRemotePath = game:GetService("ReplicatedStorage").Packages.Knit.Services.StoreService.RE.AdminGiveItem -- This is a GUESS.

exploitsTab:AddButton({
    text = "Attempt to Spawn God Sprinkler",
    flag = "spawnGodSprinkler",
    callback = function()
        -- We construct a fake item table based on the structure we found.
        local fakeGodSprinkler = {
            Key = "Sprinkler",
            Name = "God Sprinkler",
            Description = "Waters everything, forever.",
            Min = 1,
            Max = 1,
            Price = 1, -- Set to 1 just in case
            Odd = 100,
            Count = 1,
            Info = {
                Speed = 999,      -- Insanely fast plant growth
                FruitSize = 500,  -- Massive fruit
                Zone = 1000,      -- Covers almost the entire map
                Length = 9999999, -- Basically infinite duration
            }
        }

        print("Attempting to fire remote with custom item data...")
        pcall(function()
            -- We fire the remote with our fake item table as the argument.
            placeholderRemotePath:FireServer(fakeGodSprinkler)
        end)
        print("Command sent. Check your inventory.")
    end
})

exploitsTab:AddButton({
    text = "Attempt to Spawn God Watering Can",
    flag = "spawnGodWaterCan",
    callback = function()
        local fakeGodCan = {
            Key = "WateringCan",
            Name = "God Can",
            Description = "Infinite uses, instant growth.",
            Min = 1,
            Max = 1,
            Price = 1,
            Odd = 100,
            Count = 999999, -- Infinite uses
            Info = {
                Strength = 9999 -- Insane growth speed
            }
        }
        
        print("Attempting to fire remote with custom item data...")
        pcall(function()
            placeholderRemotePath:FireServer(fakeGodCan)
        end)
        print("Command sent. Check your inventory.")
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
print("Farming Game Hub Loaded! Check the new 'Exploits' tab.")
