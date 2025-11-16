local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local CoinSystem = {}

--Config 

local MaxCoins = 20

local CoinsSpawned = 0

local SpawnInterval = 5


function CoinSystem.init()
    local CoinFolder = ServerStorage:FindFirstChild("CoinSystem")
    local SpawnedCoins = Workspace:FindFirstChild("SpawnedCoins")

    local Coin = CoinFolder:FindFirstChild("TempCoin")
    if not Coin then
        warn("No Coin Found")
    end

    local SpawnArea = CoinFolder:FindFirstChild("SpawnArea")
    if not SpawnArea then
        warn("No SpawnArea Found")
    end

    local CenterX = SpawnArea.Position.X
    local CenterZ = SpawnArea.Position.Z

    local x = SpawnArea.Size.X * 0.5
    local z = SpawnArea.Size.Z * 0.5

    local function PrepCoin(part)
        local Prox = part:FindFirstChild("Prox")
        Prox.Triggered:Connect(function(player)
            part:Destroy()
            CoinsSpawned -= 1
            print("Coin has been collected by " .. player.Name .. " | CoinsSpawned: " .. CoinsSpawned)
        end)
    end

    for _, TaggedCoin in pairs(CollectionService:GetTagged("Coin")) do
        PrepCoin(TaggedCoin)
    end

    CollectionService:GetInstanceAddedSignal("Coin"):Connect(PrepCoin)
    
    while CoinsSpawned<MaxCoins do
        local Clone = Coin:Clone()

        Clone.Parent = SpawnedCoins
        Clone.Name = "Coin"
        Clone.Position = Vector3.new(math.random(CenterX - x, CenterX + x), 5, math.random(CenterZ - z, CenterZ + z))

        if not CollectionService:HasTag(Clone, "Coin") then
            Clone:AddTag("Coin")
        end

        CoinsSpawned += 1

        print(CoinsSpawned)
        task.wait(SpawnInterval)
    end
end

return CoinSystem