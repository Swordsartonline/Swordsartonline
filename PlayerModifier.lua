--================================================================================================--
--[[
    Script:         Candy Farm - 'Forever' Reward Exploit
    Description:    This script exploits a likely vulnerability in the 'Forever' reward system.
                    It iterates through all possible rewards defined in the game's configuration
                    and attempts to claim each one by firing a remote event. If the server-side
                    checks are weak, this can grant a large amount of currency and items.
    Author:         [Your Name]
]]
--================================================================================================--

-- Load the UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/library", true))()

-- Create the main window
local tab = library:CreateWindow("Candy Farm Exploits")

-- Create the "Vulnerability" section
local vulnerabilityFolder = tab:AddFolder("Vulnerability")

-- Create the exploit button
vulnerabilityFolder:AddButton({
    text = "Claim All 'Forever' Rewards",
    flag = "claimForeverRewards",
    callback = function()
        -- The remote is likely located in ReplicatedStorage. We use WaitForChild to ensure it has loaded.
        local remote
        local success, result = pcall(function()
            -- Based on the module names, the remote is likely named 'Forever'.
            remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Forever")
        end)

        if not success or not remote then
            print("Exploit Failed: Could not find the 'Forever' remote. The game might have updated, or the remote is named differently.")
            -- If you use a remote spy tool, you can find the correct name and path and update the line above.
            return
        end

        print("Found 'Forever' remote. Attempting to claim all rewards...")

        -- The 'FOREVER' table has 3 tracks, each with 25 levels. We will loop through all of them.
        for track = 1, 3 do
            for level = 1, 25 do
                -- We wrap the remote call in a pcall. This prevents the script from stopping if one
                -- of the calls fails (e.g., for an invalid reward level).
                pcall(function()
                    -- Common remote function calls are "get" or "claim". We are guessing it's "get".
                    -- The arguments are the track number and the level number.
                    remote:InvokeServer("get", track, level)
                    print("Attempted to claim reward: Track " .. track .. ", Level " .. level)
                end)
                -- Add a small delay to prevent the server from kicking you for spamming.
                task.wait(0.1)
            end
        end

        print("Finished attempting to claim all 'Forever' rewards. Check your inventory and currency!")
    end
})

-- Initialize the library to make the UI visible
library:Init()
