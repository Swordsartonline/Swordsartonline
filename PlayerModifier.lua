--[[
    Script:         Player Modifier GUI
    Author:         (Your Name) - Based on a template
    Description:    A simple GUI for modifying player WalkSpeed and JumpPower.
    Library:        Ionic by OpposedDev
    How to Use:     Execute this script in a Roblox client executor.
                    The GUI can be opened/closed with the Right-Shift key.
]]

-- A "pcall" (protected call) is used to safely load the library.
-- If the HttpGet fails (e.g., GitHub is down), it won't error the whole script.
local success, library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/OpposedDev/Ionic/refs/heads/main/source/ioniclibrary.lua"))()
end)

-- If the library failed to load, print an error and stop the script.
if not success or not library then
    warn("Could not load the Ionic library. The script will not run.")
    warn("Error details:", library) -- This will print the error message from pcall
    return
end

--================================================================
--=[                      SERVICE & PLAYER SETUP                ]=
--================================================================

-- Get essential Roblox services
local Players = game:GetService("Players")

-- Get the local player and wait for their character and humanoid to exist.
-- This is crucial because a script can run before the player has fully spawned.
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- If for any reason the humanoid couldn't be found, stop the script.
if not humanoid then
    warn("Humanoid not found. Script terminated.")
    return
end

-- Store the player's original stats before we modify them.
-- This allows us to properly reset them later.
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower


--================================================================
--=[                          GUI CREATION                      ]=
--================================================================

-- Create the main window for the GUI
local window = library:createWindow({
	Title = "Player Modifier",
	Version = "v1.1",
	RestoreKeybind = Enum.KeyCode.RightShift, -- Key to open/close the GUI
	UseCore = true, -- Places the GUI in CoreGui to protect it
})

-- Create a section within the window to organize our controls
local playerSection = window:createSection({
	Name = "Player Mods"
})

-- Create a visual divider to separate groups of options
playerSection:createDivider({
	Text = "Movement"
})

-- Create a toggle switch to enable/disable the WalkSpeed modification
playerSection:createToggle({
	Name = "Enable WalkSpeed",
	Flag = "speedEnabled", -- A unique ID to reference this toggle later
	Default = false,
	Callback = function(value)
		if value == true then
			-- When toggled ON, set the WalkSpeed to the slider's current value.
            -- We access the slider's value using window.Flags.
			humanoid.WalkSpeed = window.Flags.speedSlider.Value
		else
			-- When toggled OFF, reset the WalkSpeed to the original value.
			humanoid.WalkSpeed = originalWalkSpeed
		end
	end,
})

-- Create a slider to choose the desired WalkSpeed
playerSection:createSlider({
	Name = "Speed",
	Flag = "speedSlider", -- A unique ID to reference this slider
	Default = originalWalkSpeed, -- The slider starts at the player's normal speed
	Range = {originalWalkSpeed, 200}, -- Min speed is default, max is 200
	Increment = 1,
	Suffix = " studs/s", -- Text that appears after the number
	Callback = function(value)
		-- This function runs every time the slider is moved.
		-- We only change the speed if the main toggle is already ON.
		if window.Flags.speedEnabled.Value == true then
			humanoid.WalkSpeed = value
		end
	end,
})

-- Create a toggle switch to enable/disable the JumpPower modification
playerSection:createToggle({
	Name = "Enable JumpPower",
	Flag = "jumpEnabled", -- Unique ID for this toggle
	Default = false,
	Callback = function(value)
		if value == true then
			humanoid.JumpPower = window.Flags.jumpSlider.Value
		else
			humanoid.JumpPower = originalJumpPower
		end
	end,
})

-- Create a slider to choose the desired JumpPower
playerSection:createSlider({
	Name = "Jump",
	Flag = "jumpSlider", -- Unique ID for this slider
	Default = originalJumpPower,
	Range = {originalJumpPower, 250},
	Increment = 1,
	Suffix = " power",
	Callback = function(value)
		if window.Flags.jumpEnabled.Value == true then
			humanoid.JumpPower = value
		end
	end,
})

-- Create another divider for utility buttons
playerSection:createDivider({
	Text = "Utility"
})

-- Create a button to reset all settings and stats
playerSection:createButton({
	Name = "Reset All Stats",
	Callback = function()
		-- Reset player stats to their original values
		humanoid.WalkSpeed = originalWalkSpeed
		humanoid.JumpPower = originalJumpPower

		-- Reset the GUI controls to their default state
        -- The library's :setFlag method is used to programmatically change a control's value.
		window:setFlag("speedEnabled", false)
		window:setFlag("jumpEnabled", false)
		window:setFlag("speedSlider", originalWalkSpeed)
		window:setFlag("jumpSlider", originalJumpPower)
	end,
})

-- A final print statement to let the user know the script has loaded successfully.
print("Player Modifier GUI loaded successfully. Press Right-Shift to open.")
