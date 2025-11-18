local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ShopSystem = {}

local Network = require(ReplicatedStorage.Shared.Network)
local PlayerDataHandler = require(script.Parent.PlayerDataHandler)

local ShopItmes = ServerStorage:FindFirstChild("ShopItems")
local Sword = ShopItmes:FindFirstChild("Sword")
local Pistol = ShopItmes:FindFirstAncestor("Pistol")

local function GiveItemToPlayer(player: Player, itemName: string)
	if itemName == "Sword" then
		local clone = Sword:Clone()
		clone.Parent = player.Backpack
	elseif itemName == "Pistol" then
		local clone = Pistol:Clone()
		clone.Parent = player.Backpack
	end
end

function ShopSystem.init()
    Network.connectEvent(Network.RemoteEvents.StoreEvent, function(player: Player, item: string)

        if item == "Sword" then
            local coins = PlayerDataHandler.GetData(player, "Coins")
            if coins>=10 then
                PlayerDataHandler.DeleteData(player, "Coins", 10)
                GiveItemToPlayer(player, "Sword")
            end
        elseif item == "Pistol" then
            local coins = PlayerDataHandler.GetData(player, "Coins")
            if coins>=20 then
                PlayerDataHandler.DeleteData(player, "Coins", 20)
                GiveItemToPlayer(player, "Pistol")
            end            
        end
    end, Network.t.instanceOf("Player"), Network.t.string)
end

return ShopSystem

