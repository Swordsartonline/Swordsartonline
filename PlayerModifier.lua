--[[
    Script:         Farming Game Helper
    Author:         Swordsartonline (Built with AI assistance)
    Version:        2.1 (Mobile Fix)
    Description:    A GUI for a farming game with auto-collect, selling,
                    and purchasing features, plus player mods.
    Library:        Ionic by OpposedDev
    How to Use:     Execute this script in a Roblox client executor.
                    Click the gear icon on the right to open/close the GUI.
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
	Version = "v2.1",
	UseCore = true,
    -- [CHANGE 1] Set a specific, smaller size for the window to be mobile-friendly
    Size = UDim2.fromOffset(360, 450)
})

-- Start with the window hidden. The user will click the icon to open it.
window.Container.Visible = false

-- Create a separate ScreenGui for our toggle button so it's always visible.
local toggleGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local toggleButton = Instance.new("ImageButton", toggleGui)
toggleButton.Image = "rbxassetid://6032117424" -- A simple gear/settings icon
toggleButton.Size = UDim2.fromOffset(48, 48)
-- [CHANGE 2] Positioned on the right, but moved down to avoid core buttons
toggleButton.Position = UDim2.new(1, -58, 0, 70) 
toggleButton.BackgroundTransparency = 1

toggleButton.MouseButton1Click:Connect(function()
	window.Container.Visible = not window.Container.Visible
end)


--================================================================
--=[                    FARMING & UTILITY SECTION               ]=
--================================================================

local farmingSection = window:createSection({
	Name = "Farming"
})

farmingSection:createToggle({
	Name = "Auto Collect Plants",
	Flag = "autoCollect",
	Default = false,
	RBXConnection = "Heartbeat",
	Callback = function()
        if Workspace:FindFirstChild("Plant") then
            for _, plant in ipairs(Workspace.Plant:GetChildren()) do
                if plant:FindFirstChild("Fruit") then
                    pcall(function()
                        PlantService.TakePlant:FireServer(plant.Fruit)
                    end)
                end
            end
        end
	end,
})

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

local seedsToBuy = {
    "Grass", "Sunflower", "Carrot", "Blueberry", "Strawberry", "Corn",
    "Apple", "Bamboo", "Eggplant", "Pineapple", "Tomato", "Pumpkin",
    "Banana", "Coconut", "Peach", "Grape", "Nasturtium", "Papaya"
}

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

print("Farming Helper GUI v2.1 loaded. Click the gear icon on the right to open.")
