--[[
    Script:         Farming Game Helper
    Author:         Swordsartonline (Built with AI assistance)
    Description:    A GUI for a farming game with auto-collect, selling,
                    and purchasing features, plus player mods.
    Library:        Ionic by OpposedDev
    How to Use:     Execute this script in a Roblox client executor.
                    Click the icon on the screen to open/close the GUI.
]]

-- A "pcall" (protected call) is used to safely load the library.
local success, library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/OpposedDev/Ionic/refs/heads/main/source/ioniclibrary.lua"))()
end)

if not success or not library then
    warn("Could not load the Ionic library. The script will not run. Error: " .. tostring(library))
    return
end

--================================================================
--=[                      SERVICE & PLAYER SETUP                ]=
--================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

if not humanoid then
    warn("Humanoid not found. Script terminated.")
    return
end

-- Store original stats for resetting later
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower

-- Define paths to the game's remote events/functions for easy access
local KnitPackage = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit")
local PlantService = KnitPackage.Services.PlantService.RE
local StoreService = KnitPackage.Services.StoreService

--================================================================
--=[                    GUI CREATION & TOGGLE ICON              ]=
--================================================================

-- Create the main window, but we won't show it yet.
local window = library:createWindow({
	Title = "Farming Helper",
	Version = "v2.0",
    -- No RestoreKeybind, we are making our own button for mobile
	UseCore = true,
})

-- Start with the window hidden. The user will click the icon to open it.
-- We access the main GUI frame through 'window.Container'.
window.Container.Visible = false

-- Create a separate ScreenGui for our toggle button so it's always visible.
local toggleGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local toggleButton = Instance.new("ImageButton", toggleGui)
toggleButton.Image = "rbxassetid://6032117424" -- A simple gear/settings icon
toggleButton.Size = UDim2.fromOffset(48, 48)
toggleButton.Position = UDim2.new(1, -58, 0, 10) -- Top-right corner
toggleButton.BackgroundTransparency = 1

-- This function runs when the icon is clicked
toggleButton.MouseButton1Click:Connect(function()
    -- Toggle the visibility of the main window
	window.Container.Visible = not window.Container.Visible
end)


--================================================================
--=[                    FARMING & UTILITY SECTION               ]=
--================================================================

local farmingSection = window:createSection({
	Name = "Farming"
})

-- A toggle for automatically collecting ripe plants
farmingSection:createToggle({
	Name = "Auto Collect Plants",
	Flag = "autoCollect",
	Default = false,
	RBXConnection = "Heartbeat", -- Runs the callback every frame when active
	Callback = function()
        -- The game stores plants in a "Plant" folder in the workspace.
        -- We loop through everything in that folder to collect them all.
        if Workspace:FindFirstChild("Plant") then
            for _, plant in ipairs(Workspace.Plant:GetChildren()) do
                -- We check if the plant has a "Fruit" part, which means it's ready.
                if plant:FindFirstChild("Fruit") then
                    -- Use a pcall to prevent one bad plant from erroring the whole script
                    pcall(function()
                        PlantService.TakePlant:FireServer(plant.Fruit)
                    end)
                end
            end
        end
	end,
})

-- A simple button to sell everything in the inventory
farmingSection:createButton({
	Name = "Sell All Inventory",
	Callback = function()
		pcall(function()
            StoreService.RF.Sell:InvokeServer()
        end)
	end,
})


--================================================================
--=[                       SHOP / BUY SECTION                   ]=
--================================================================

local shopSection = window:createSection({
	Name = "Shop"
})

shopSection:createDivider({ Text = "Buy Seeds" })

-- A list of all available seeds to buy.
-- Using a table like this makes it easy to add more seeds later!
local seedsToBuy = {
    "Grass", "Sunflower", "Carrot", "Blueberry", "Strawberry", "Corn",
    "Apple", "Bamboo", "Eggplant", "Pineapple", "Tomato", "Pumpkin",
    "Banana", "Coconut", "Peach", "Grape", "Nasturtium", "Papaya"
}

-- Loop through the table and create a button for each seed
for _, seedName in ipairs(seedsToBuy) do
    shopSection:createButton({
        Name = "Buy " .. seedName,
        Callback = function()
            pcall(function()
                StoreService.RE.Purchase:FireServer(seedName)
            end)
        end,
    })
end


--================================================================
--=[                    PLAYER MODS SECTION                     ]=
--================================================================

local playerSection = window:createSection({
	Name = "Player Mods"
})

playerSection:createToggle({
	Name = "Enable WalkSpeed",
	Flag = "speedEnabled",
	Default = false,
	Callback = function(value)
		humanoid.WalkSpeed = value and window.Flags.speedSlider.Value or originalWalkSpeed
	end,
})

playerSection:createSlider({
	Name = "Speed",
	Flag = "speedSlider",
	Default = originalWalkSpeed,
	Range = {originalWalkSpeed, 200},
	Increment = 1,
	Suffix = " studs/s",
	Callback = function(value)
		if window.Flags.speedEnabled.Value then
			humanoid.WalkSpeed = value
		end
	end,
})

playerSection:createToggle({
	Name = "Enable JumpPower",
	Flag = "jumpEnabled",
	Default = false,
	Callback = function(value)
		humanoid.JumpPower = value and window.Flags.jumpSlider.Value or originalJumpPower
	end,
})

playerSection:createSlider({
	Name = "Jump",
	Flag = "jumpSlider",
	Default = originalJumpPower,
	Range = {originalJumpPower, 250},
	Increment = 1,
	Suffix = " power",
	Callback = function(value)
		if window.Flags.jumpEnabled.Value then
			humanoid.JumpPower = value
		end
	end,
})

-- A button to reset only the player stats
playerSection:createButton({
	Name = "Reset Player Stats",
	Callback = function()
		humanoid.WalkSpeed = originalWalkSpeed
		humanoid.JumpPower = originalJumpPower
		window:setFlag("speedEnabled", false)
		window:setFlag("jumpEnabled", false)
		window:setFlag("speedSlider", originalWalkSpeed)
		window:setFlag("jumpSlider", originalJumpPower)
	end,
})

-- Final confirmation message in the console
print("Farming Helper GUI loaded. Click the icon in the top-right to open.")
