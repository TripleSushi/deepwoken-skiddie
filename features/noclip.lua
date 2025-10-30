local noclip = {}

local RunService = game:GetService("RunService")
local ogCollisions = {}
local connection = nil

function noclip.enabled(character)
    for _, v in character:GetDescendants() then
        if not v:IsA("BasePart") then
            ogCollisions[v] = v.CanCollide
        end
    end

    connection = RunService.Stepped:Connect(function()
        for _, v in character:GetDescendants() do
            if not v:IsA("BasePart") then
                continue
            end
            v.CanCollide = false
        end
    end)
end

function noclip.disabled(character)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    for _, v in character:GetDescendants() do
        if v:IsA("BasePart") then
            v.CanCollide = ogCollisions[v]
        end
    end
    ogCollisions = {}
end

return noclip