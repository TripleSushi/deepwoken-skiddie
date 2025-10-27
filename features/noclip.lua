local noclip = {}

local RunService = game:GetService("RunService")
local connection = nil

function noclip.enabled(character)
    connection = RunService.Stepped:Connect(function()
        for _, v in pairs(character:GetDescendants()) do
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

    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
        end
    end
end

return noclip