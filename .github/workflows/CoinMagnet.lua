local discord = loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/main/Discord%20UI%20Lib/Discord%20Lib%20Source.lua"))()

local player = game:GetService("Players").LocalPlayer
local replication = game:GetService("ReplicatedStorage").Remotes.Replication
local coins = player:WaitForChild("Stats").Coins
local gems = player:WaitForChild("Stats").Gems

local function updateUI()
    replication:InvokeServer("UpdateUI")
end

local function addCurrency(coinAmount, gemAmount)
    coins.Value = coins.Value + coinAmount
    gems.Value = gems.Value + gemAmount
    updateUI()
end

local window = discord.Window:new({
    Title = "Coin Magnet Simulator Cheats";
    Size = {300, 300};
    Resizable = false;
    MinSize = {300, 300};
    Maximizable = false;
    TransparentFromDock = true;
})

local coinInput = discord.Input:new({
    Parent = window.Content;
    PlaceholderText = "Coin Amount";
    Size = UDim2.new(1, -20, 0, 25);
    Position = UDim2.new(0, 10, 0, 10);
})

local gemInput = discord.Input:new({
    Parent = window.Content;
    PlaceholderText = "Gem Amount";
    Size = UDim2.new(1, -20, 0, 25);
    Position = UDim2.new(0, 10, 0, 40);
})

local addButton = discord.Button:new({
    Parent = window.Content;
    Text = "Add Currency";
    Size = UDim2.new(1, -20, 0, 25);
    Position = UDim2.new(0, 10, 0, 70);
    OnClick = function()
        local coinAmount = tonumber(coinInput.Text) or 0
        local gemAmount = tonumber(gemInput.Text) or 0
        addCurrency(coinAmount, gemAmount)
    end;
})

local function toggleUI()
    if window:IsVisible() then
        window:Hide()
    else
        window:Show()
    end
end

game:GetService("UserInputService").Keyboard.KeyDown:Connect(function(key)
    if key:ToLower() == "insert" then
        toggleUI()
    end
end)

addCurrency(1000000, 1000000)
