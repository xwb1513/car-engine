local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local PlayerDataHandler = {}

local Network = require(ReplicatedStorage.Shared.Network)

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData")

PlayerDataHandler.PlayerData = {}





function PlayerDataHandler.Load(player)

    local success = false
    local attempt
    local PlayerData = nil

    repeat
        success, PlayerData = pcall(function()
            return PlayerDataStore:GetAsync(player.UserId)
        end)
        
        if not success then
            warn("Failed to load data for: " .. player.Name .. " Attempt: " .. attempt)
            task.wait(3)
            attempt += 1
        end
    until success or attempt > 5

    if not success then
        player:Kick("Failed to load data, please try again.")
        warn("Failed to load data for: " .. player.Name)
    end

    HttpService:JSONEncode(PlayerData)
    --print(PlayerData)
    return PlayerData
end

function PlayerDataHandler.Save(player, data)
    HttpService:JSONEncode(data)
    print(data)

    local success = false
    local attempt

    repeat
        success = pcall(function()
            PlayerDataStore:SetAsync(player.UserId, data)
        end)
        if not success then
            warn("Failed to save data for: " .. player.Name .. " Attempt: " .. attempt)
            task.wait(3)
            attempt += 1
        end
    until success or attempt > 5

    if not success then
        warn("Failed to sava data for: " .. player.Name)
    end
end





function PlayerDataHandler.init()
    local function PlayerAdded(player)
        local data = PlayerDataHandler.Load(player) or {}

        data.Coins = data.Coins or 0

        PlayerDataHandler.PlayerData[player.UserId] = data
        --print(PlayerHandler.PlayerData)
        if data.Coins>0 then
            Network.fireClient(Network.RemoteEvents.PlayerGUISync, player, tonumber(data.Coins))
        end
    end

    local function PlayerLeaving(player)
        local data = PlayerDataHandler.PlayerData[player.UserId]
        if data then
            PlayerDataHandler.Save(player, data)
            PlayerDataHandler.PlayerData[player.UserId] = nil
        end
    end

    Players.PlayerAdded:Connect(PlayerAdded)
    Players.PlayerRemoving:Connect(PlayerLeaving)
end





function PlayerDataHandler.AddData(player, key, amount)
    local data = PlayerDataHandler.PlayerData[player.UserId]
    if data then
        data[key] = (data[key]or 0) + amount
    end
    --print(data)
    if key == "Coins" then
        --print(PlayerHandler.PlayerData)
        Network.fireClient(Network.RemoteEvents.PlayerGUISync, player, tonumber(data.Coins))
    end
end

function PlayerDataHandler.DeleteData(player, key, amount)
    local data = PlayerDataHandler.PlayerData[player.UserId]
        if data then
        data[key] = (data[key]or 0) - amount
    end

    if key == "Coins" then
        --print(PlayerHandler.PlayerData)
        Network.fireClient(Network.RemoteEvents.PlayerGUISync, player, tonumber(data.Coins))
    end
end

function PlayerDataHandler.GetData(player, key)
    local data = PlayerDataHandler.PlayerData[player.UserId]
    return data[key]
end

return PlayerDataHandler