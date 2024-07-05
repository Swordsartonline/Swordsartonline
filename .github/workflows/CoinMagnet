-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/main/Discord%20UI%20Lib/Discord%20Lib%20Source.lua"))()

-- Game variables
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local magnet = game:GetService("ReplicatedStorage").Magnet

-- UI variables
local ui = Library.new("Magnet Simulator")
local settings = ui:AddPage("Settings")
local toggle = settings:AddToggle("Magnet Toggle", false)

-- Function to get all coins in range
local function getCoins()
    local coins = workspace:GetChildren()
    local coinsInRange = {}

    for i, coin in pairs(coins) do
        if coin:FindFirstChild("CoinValue") and coin.Position - character.Torso.Position.Magnitude < 20 then
            table.insert(coinsInRange, coin)
        end
    end

    return coinsInRange
end

-- Event for when the magnet toggle is changed
toggle.Changed:Connect(function(value)
    if value then
        humanoid.WalkSpeed = 0
        local coins = getCoins()

        for i, coin in pairs(coins) do
            magnet:FireServer(coin)
        end

        wait(1)
        humanoid.WalkSpeed = 16
    end
end)

-- Event for when the player clicks the left mouse button
mouse.Button1Down:Connect(function()
    local coins = getCoins()

    for i, coin in pairs(coins) do
        magnet:FireServer(coin)
    end
end)
