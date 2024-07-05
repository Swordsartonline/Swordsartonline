local DiscordUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/main/Discord%20UI%20Lib/Discord%20Lib%20Source.lua"))()


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()


local function GetPlayerValue(name)
    return player:WaitForChild(name, 3)
end

local function GetValues(parent, type)
    local values = {}
    for _, v in pairs(parent:GetChildren()) do
        if v:IsA(type) then
            table.insert(values, v)
        end
    end
    return values
end

local function FindNearestPart(position, distance)
    local nearestPart, nearestDistance = nil, distance
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Position then
            local dist = (v.Position - position).Magnitude
            if dist < nearestDistance then
                nearestPart = v
                nearestDistance = dist
            end
        end
    end
    return nearestPart
end


local ui = DiscordUI:Create("Example UI")
local tab = ui:Tab("Sword Legends Simulator")


local getGiftsButton = tab:Button("Get All Gifts")
getGiftsButton.MouseButton1Click:Connect(function()
    for _, v in pairs(GetValues(workspace, "Model")) do
        if v.Name == "Gift" and v:FindFirstChild("CanObtain") then
            v.CanObtain.Value = true
        end
    end
end)


local strength = GetPlayerValue("Strength")
local strengthValueLabel = tab:Label("Strength Value: " .. strength.Value)
local strengthInfiniteToggle = tab:Toggle("Infinite Strength")
strengthInfiniteToggle.Changed:Connect(function(infinite)
    if infinite then
        strength.Changed:Connect(function()
            strength.Value = 9e9
        end)
    else
        strength.Changed:Disconnect()
    end
end)


local gems = GetPlayerValue("Gems")
local gemsValueLabel = tab:Label("Gems Value: " .. gems.Value)
local gemsInfiniteToggle = tab:Toggle("Infinite Gems")
gemsInfiniteToggle.Changed:Connect(function(infinite)
    if infinite then
        gems.Changed:Connect(function()
            gems.Value = 9e9
        end)
    else
        gems.Changed:Disconnect()
    end
end)


local gamepassesTab = ui:Tab("Gamepasses")
local vipToggle = gamepassesTab:Toggle("VIP")
local tripleEggsToggle = gamepassesTab:Toggle("Triple Eggs")
local autoHatchToggle = gamepassesTab:Toggle("Auto Hatch")
local autoRebirthToggle = gamepassesTab:Toggle("Auto Rebirth")
local octupleEggsToggle = gamepassesTab:Toggle("Octuple Eggs")
local ultraLuckyToggle = gamepassesTab:Toggle("Ultra Lucky")

vipToggle.Changed:Connect(function(enabled)
    player.PlayerStatistics:FindFirstChild("VIP").Value = enabled and 1 or 0
end)

tripleEggsToggle.Changed:Connect(function(enabled)
    player.PlayerStatistics:FindFirstChild("TripleEggs").Value = enabled and 1 or 0
end)

autoHatchToggle.Changed:Connect(function(enabled)
    player.PlayerStatistics:FindFirstChild("AutoHatch").Value = enabled and 1 or 0
end)

autoRebirthToggle.Changed:Connect(function(enabled)
    player.PlayerStatistics:FindFirstChild("AutoRebirth").Value = enabled and 1 or 0
end)

octupleEggsToggle.Changed:Connect(function(enabled)
    player.PlayerStatistics:FindFirstChild("OctupleEggs").Value = enabled and 1 or 0
end)

ultraLuckyToggle.Changed:Connect(function(enabled)
    player.PlayerStatistics:FindFirstChild("UltraLucky").Value = enabled and 1 or 0
end)


local gemPackButton = gamepassesTab:Button("+10B Gems")
gemPackButton.MouseButton1Click:Connect(function()
    gems.Value = gems.Value + 10000000000
end)


local spin = GetPlayerValue("Spin")
local spinInfiniteToggle = tab:Toggle("Infinite Spins")
spinInfiniteToggle.Changed:Connect(function(infinite)
    if infinite then
        spin.Changed:Connect(function()
            spin.Value = 9e9
        end)
    else
        spin.Changed:Disconnect()
    end
end)


local noEggHatchingToggle = tab:Toggle("No Egg Hatching Animation")
noEggHatchingToggle.Changed:Connect(function(enabled)
    local eggHatchingAnim = character:WaitForChild("EggHatchingAnim", 3)
    if eggHatchingAnim then
        eggHatchingAnim.Disabled = enabled
    end
end)


local collectAllDailyButton = tab:Button("Collect All Daily")
collectAllDailyButton.MouseButton1Click:Connect(function()
    for _, v in pairs(GetValues(workspace, "Model")) do
        if v.Name == "DailyReward" and v:FindFirstChild("CanCollect") then
            v.CanCollect.Value = true
        end
    end
end)


local autoFarmToggle = tab:Toggle("Auto Farm")
local target, targetDistance = nil, 10

autoFarmToggle.Changed:Connect(function(enabled)
    if enabled then
        mouse.Button1Down:Connect(function()
            local ray = Ray.new(mouse.Hit.p, (mouse.Hit.p - mouse.Hit.Position).unit * targetDistance)
            local part = workspace:FindPartOnRay(ray, character)
            if part then
                target = part
            end
        end)

        game:GetService("RunService").RenderStepped:Connect(function()
            if target then
                local direction = (target.Position - character.PrimaryPart.Position).unit
                local right = direction:Cross(Vector3.new(0, 1, 0)).unit
                local velocity = direction * 50 + right * 20
                character.PrimaryPart.Velocity = velocity
            end
        end)
    else
        mouse.Button1Down:Disconnect()
        game:GetService("RunService").RenderStepped:Disconnect()
    end
end
