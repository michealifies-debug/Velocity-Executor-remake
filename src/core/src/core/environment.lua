-- src/core/environment.lua
local Environment = {}

local game = game
local workspace = workspace
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Get current game info
function Environment.getGameInfo()
    return {
        JobId = game.JobId,
        PlaceId = game.PlaceId,
        ServerId = game.ServerId,
        IsServer = runService:IsServer(),
        IsClient = runService:IsClient(),
        TickCount = runService.HeartbeatCount
    }
end

-- Get player list
function Environment.getPlayers()
    local list = {}
    for _, plr in pairs(players:GetPlayers()) do
        table.insert(list, {
            Name = plr.Name,
            UserId = plr.UserId,
            Char = plr.Character and plr.Character.Name or "None"
        })
    end
    return list
end

-- Get workspace objects
function Environment.getWorkspaceObjects()
    local list = {}
    for _, obj in pairs(workspace:GetChildren()) do
        table.insert(list, obj:GetFullName())
    end
    return list
end

-- Get current player
function Environment.getCurrentPlayer()
    local localPlayer = players.LocalPlayer
    if not localPlayer then return nil end
    return {
        Name = localPlayer.Name,
        UserId = localPlayer.UserId,
        Health = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") and localPlayer.Character:FindFirstChild("Humanoid").Health or 0,
        Position = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("HumanoidRootPart").Position or Vector3.new()
    }
end

return Environment
