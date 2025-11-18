local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local CoinSystem = {}

local PlayerHandler = require(script.Parent.PlayerDataHandler)

--Config 
local MaxCoins = 20
local CoinsSpawned = 0
local SpawnInterval = 5

function CoinSystem.init()
    local CoinFolder = ServerStorage:FindFirstChild("CoinSystem")
    local SpawnedCoins = Workspace:FindFirstChild("SpawnedCoins")

    local Coin = CoinFolder:FindFirstChild("Coin")
    if not Coin then
        warn("No Coin Found")
        return
    end

    if not Coin.PrimaryPart then
        warn("Coin has no PrimaryPart")
        return
    end

    local SpawnArea = CoinFolder:FindFirstChild("SpawnArea")
    if not SpawnArea then
        warn("No SpawnArea Found")
        return
    end

    local CenterX = SpawnArea.Position.X
    local CenterZ = SpawnArea.Position.Z
    local x = SpawnArea.Size.X * 0.5
    local z = SpawnArea.Size.Z * 0.5

    local function SpawnCoin()
        local Clone = Coin:Clone()
        Clone.Parent = SpawnedCoins
        Clone.Name = "Coin"

        local randX = math.random(CenterX - x, CenterX + x)
        local randZ = math.random(CenterZ - z, CenterZ + z)
        Clone:SetPrimaryPartCFrame(CFrame.new(randX, 5, randZ))

        if not CollectionService:HasTag(Clone, "Coin") then 
            Clone:AddTag("Coin") 
        end

        CoinsSpawned += 1
        print("CoinsSpawned: " .. CoinsSpawned)
    end
    
    local function PrepCoin(part)
        local Prox = part:FindFirstChild("Prox")
        local primary = part.PrimaryPart

        if Prox then
            Prox.Triggered:Connect(function(player)
                part:Destroy()
                CoinsSpawned -= 1
                print("CoinsSpawned: " .. CoinsSpawned)
                PlayerHandler.AddData(player, "Coins", 1)
            end)
        end

        local StartPosition = primary.Position
        local WaveH = 0.7
        local Speed = 2
        local RotationSpeed = 45

        local t = 0
        local ballerina
        ballerina = RunService.Heartbeat:Connect(function(deltaTime)
            t += deltaTime * Speed
            
            local newY = StartPosition.Y + math.sin(t) * WaveH
            primary.Position = Vector3.new(StartPosition.X, newY, StartPosition.Z)

            primary.CFrame = primary.CFrame * CFrame.Angles(0, math.rad(RotationSpeed * deltaTime), 0)
            
            if not part.Parent then
                ballerina:Disconnect()
            end
        end)
    end

    CollectionService:GetInstanceAddedSignal("Coin"):Connect(PrepCoin)

    task.spawn(function()
        while true do
            if CoinsSpawned < MaxCoins then
                SpawnCoin()
            end
            task.wait(SpawnInterval)
        end
    end)
end

return CoinSystem
