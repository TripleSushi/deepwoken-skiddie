-- Credits to blast, dont touch anything from this 7.
local Hooking = {}
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local oldFireServer = nil
local oldNameCall = nil
local banRemotes = {}

local onNameCall = function(...)
    if not checkcaller() then
        return oldNameCall(...)
    end

    local args = {...}
    local self = args[1]

    if banRemotes[self] then
        return warn("AC Ban Remote blocked")
    end

    return oldNameCall(...)
end

local onFireServer = function(...)
    if checkcaller() then
        return oldFireServer(...)
    end

    local args = {...}
    local self = args[1]

    if banRemotes[self] then
        return warn("AC Ban Remote blocked")
    end

    return oldFireServer(...)
end

function Hooking.init()
    local localPlayer = playersService.LocalPlayer
    local playerScripts = localPlayer:WaitForChild("PlayerScripts")
    local clientActor = playerScripts:WaitForChild("ClientActor")
    local clientManager = clientActor:WaitForChild("ClientManager")
    local requests = replicatedStorage:WaitForChild("Requests")

    clientManager.Enabled = false

    local banRemoteCount = 0
    for _, request in pairs(requests:GetChildren()) do
        local hasChangedConnection = #getconnections(request.Changed)
        if hasChangedConnection <= 0 then
            continue
        end
        banRemoteCount = banRemoteCount + 1
        banRemotes[request] = true
    end

    if banRemoteCount ~= 2 then
        return warn("Anticheat has less or more than two ban remotes.")
    end

    oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, onFireServer)
    oldNameCall = hookfunction(getrawmetatable(game).__namecall, onNameCall)

    warn("Client-side anticheat has been penetrated.")
    return true
end

function Hooking.isActive()
    return oldFireServer ~= nil and oldNameCall ~= nil
end

return Hooking
-- Credits to blast, dont touch anything from this 7.