local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local PlayerData ={}

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData")

function PlayerData.Load(player)

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
    print(PlayerData)
    return PlayerData
end

function PlayerData.Save(player, data)
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

return PlayerData