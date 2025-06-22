--================================================================================================--
--[[
    Script:         Candy Farm - Multi-Exploit Tool (v4)
    Description:    Combines two major exploits into one script.
                    1. 'Forever' Pass Exploit: Claims all rewards from all three 'Forever' tracks.
                    2. 'Sign-in' Exploit: Claims all daily login rewards.
                    Both exploits leverage the developer's predictable remote event patterns.
    Author:         [Your Name]
]]
--================================================================================================--

-- Load the UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/library", true))()

-- Create the main window
local tab = library:CreateWindow("Candy Farm Exploits")

-- Create the "Vulnerability" section
local vulnerabilityFolder = tab:AddFolder("Vulnerability")

--================================================================================================--
-- Exploit #1: Forever Rewards
--================================================================================================--
vulnerabilityFolder:AddButton({
    text = "Claim All 'Forever' Rewards",
    flag = "claimForeverRewards",
    callback = function()
        local remote
        local success, result = pcall(function()
            remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Forever")
        end)

        if not success or not remote then
            print("[Forever Exploit] FAILED: Could not find remote at 'ReplicatedStorage.Remotes.Forever'. Use Dex to find the correct path.")
            return
        end

        print("[Forever Exploit] Remote found! Attempting to claim all rewards...")

        for track = 1, 3 do
            for level = 1, 25 do
                pcall(function()
                    -- Command is likely "get" or "claim". Arguments are track and level.
                    remote:InvokeServer("get", track, level)
                    print("[Forever Exploit] Attempted: Track " .. track .. ", Level " .. level)
                end)
                task.wait(0.1)
            end
        end

        print("[Forever Exploit] Finished. Check your inventory and currency!")
    end
})

--================================================================================================--
-- Exploit #2: Daily Sign-in Rewards
--================================================================================================--
vulnerabilityFolder:AddButton({
    text = "Claim All Sign-in Rewards",
    flag = "claimSignInRewards",
    callback = function()
        local remote
        local success, result = pcall(function()
            -- Based on the module name, the remote is likely named 'Sign'.
            remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sign")
        end)

        if not success or not remote then
            print("[Sign-in Exploit] FAILED: Could not find remote at 'ReplicatedStorage.Remotes.Sign'. Use Dex to find the correct path.")
            return
        end

        print("[Sign-in Exploit] Remote found! Attempting to claim all daily rewards...")

        -- The SIGN.DATA and SIGN.DATA_LOOP tables both have 7 days.
        -- We will try to claim both sets. A common pattern is that the second set is for a "deluxe" pass.
        -- The arguments are likely a command string and the day number.
        for day = 1, 7 do
            pcall(function()
                -- First, try claiming the standard reward for the day.
                remote:InvokeServer("get", day)
                print("[Sign-in Exploit] Attempted: Standard Day " .. day)
                
                -- It's possible a second argument is used for deluxe/loop rewards. Let's try sending a '2'.
                task.wait(0.1)
                remote:InvokeServer("get", day, 2) -- Common pattern for claiming a "deluxe" version
                print("[Sign-in Exploit] Attempted: Loop/Deluxe Day " .. day)

            end)
            task.wait(0.1)
        end

        print("[Sign-in Exploit] Finished. Check your inventory and currency!")
        print("If this didn't work, use a Remote Spy when claiming a daily reward to find the correct command and arguments.")
    end
})

-- Initialize the library to make the UI visible
library:Init()
