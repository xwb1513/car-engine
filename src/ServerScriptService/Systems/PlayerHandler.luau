local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local PlayerHandler = {}

local Network = require(ReplicatedStorage.Shared.Network)
local PlayerData = require(ServerStorage.Systems.PlayerData)


PlayerHandler.PlayerData = {}

function PlayerHandler.init()
    local function PlayerAdded(player)
        local data = PlayerData.Load(player) or {}

        data.Coins = data.Coins or 0

        PlayerHandler.PlayerData[player.UserId] = data
        --print(PlayerHandler.PlayerData)
        if data.Coins>0 then
            Network.fireClient(Network.RemoteEvents.PlayerGUISync, player, tonumber(data.Coins))
        end
    end

    local function PlayerLeaving(player)
        local data = PlayerHandler.PlayerData[player.UserId]
        if data then
            PlayerData.Save(player, data)
            PlayerHandler.PlayerData[player.UserId] = nil
        end
    end

    Players.PlayerAdded:Connect(PlayerAdded)
    Players.PlayerRemoving:Connect(PlayerLeaving)
end

function PlayerHandler.AddData(player, key, amount)
    local data = PlayerHandler.PlayerData[player.UserId]
    if data then
        data[key] = (data[key]or 0) + amount
    end
    --print(data)
    if key == "Coins" then
        --print(PlayerHandler.PlayerData)
        Network.fireClient(Network.RemoteEvents.PlayerGUISync, player, tonumber(data.Coins))
    end
end

return PlayerHandler

