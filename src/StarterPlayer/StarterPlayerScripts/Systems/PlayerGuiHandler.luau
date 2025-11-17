local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGuiHandler = {}

local LocalPlayer = Players.LocalPlayer

local Network = require(ReplicatedStorage.Shared.Network)


function PlayerGuiHandler.init()
    local MainGui = LocalPlayer:WaitForChild("PlayerGui", 5):WaitForChild("ScreenGui", 5)

    Network.connectEvent(Network.RemoteEvents.PlayerGUISync, function(response: number)
        MainGui.Coins.TextLabel.Text = string.format("Coins:  %i", response)
    end, Network.t.number)
end

return PlayerGuiHandler
