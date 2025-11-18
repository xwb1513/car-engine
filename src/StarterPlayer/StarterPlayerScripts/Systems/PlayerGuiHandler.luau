local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local PlayerGuiHandler = {}

local LocalPlayer = Players.LocalPlayer

local Network = require(ReplicatedStorage.Shared.Network)

local function StoreEvent(item)
    Network.fireServer(Network.RemoteEvents.StoreEvent, item)
end

function PlayerGuiHandler.init()
    local MainGui = LocalPlayer:WaitForChild("PlayerGui", 5):WaitForChild("ScreenGui", 5)

    local ShopGui = MainGui:FindFirstChild("Shop")
    local ShopGuiClose = ShopGui:FindFirstChild("TextButton")
    local ShopGuiList = ShopGui:FindFirstChild("List")
    local BuySword = ShopGuiList:FindFirstChild("1Sword"):FindFirstChild("ImageButton")
    local BuyPistol = ShopGuiList:FindFirstChild("2Pistol"):FindFirstChild("ImageButton")

    local ShopProx = Workspace:WaitForChild("oil tanker", 5):FindFirstChild("Pirate"):FindFirstChild("Prox")

    Network.connectEvent(Network.RemoteEvents.PlayerGUISync, function(response: number)
        MainGui.Coins.TextLabel.Text = string.format("Coins:  %i", response)
    end, Network.t.number)

    ShopProx.Triggered:Connect(function()
        ShopGui.Visible = true
    end)
    ShopGuiClose.Activated:Connect(function()
        ShopGui.Visible = false
    end)

    BuySword.Activated:Connect(function()
        StoreEvent("Sword")
    end)
    
    BuyPistol.Activated:Connect(function()
        StoreEvent("Pistol")
    end)
end

return PlayerGuiHandler
