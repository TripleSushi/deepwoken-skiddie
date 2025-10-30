local enmity = {}

local tweenService = game:GetService("TweenService")
local playersService = game:GetService("Players")
local event = game:GetService("ReplicatedStorage").Requests
local noclip = loadstring(game:HttpGet('https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main/features/noclip.lua'))()

--local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main/modules/library.lua'))()

local path = "orders.json"
local lastCommand = 0
local listener = false

-- Track unsafe confirmations for movement
local unsafeConfirm = false

--Command values
local commands = {
    afk = 0,
    hide = 1,
    elevator = 2,
    killerPos = 3,
    emote = 4,
    menu = 5,
    cathedral = 6
}

-- Gets the killer id
local function getKillerID()
    if not getgenv().Options or not getgenv().Options.KillerID then
        return nil
    else
        return tonumber(getgenv().Options.KillerID.Value)
    end
end

-- Coords 
local positions = {
    depths1 = Vector3.new(3039.7001953125, -2352.10009765625, 1589.76611328125),
    depths2 = Vector3.new(2968.79345703125, -2264.3369140625, 1574.746826171875),
    cathedral = Vector3.new(2979.63818359375, -996.689697265625, 1774.434814453125)
}

-- Function to make the tweens
local function mainTween(player, target)
    local character = player.Character
    local hrp = character.HumanoidRootPart
    noclip.enabled(character)

    hrp.CFrame = CFrame.new(hrp.Position.X, target.Y, hrp.Position.Z)

    local start = hrp.Position
    target = Vector3.new(target.X, hrp.Position.Y, target.Z)
    local distance = (target - start).Magnitude
    local duration = distance / 57

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local goal = {CFrame = CFrame.new(target)}
    local tween = tweenService:Create(hrp, tweenInfo, goal)
    tween:Play()

    tween.Completed:Wait()
    noclip.disabled(character)
end

local function circle(center)
    local alts = {}
    for _, p in playersService:GetPlayers() do
        if p.UserId ~= getKillerID() then
            table.insert(alts, p.UserId)
        end
    end
    table.sort(alts)

    local total = #alts
    local position = 0
    for i, p in alts do
        if p == playersService.LocalPlayer.UserId then
            position = i
            break
        end
    end

    local spacing = total * 10
    local r = spacing / (2 * math.pi)
    local angle = (position / total) * (2 * math.pi)
    
    local x = center.X + r * math.cos(angle)
    local z = center.Z + r * math.sin(angle)

    return Vector3.new(x, center.Y, z)
end

-- File related
function enmity.write(command)
    local KillerID = getKillerID()
    if not KillerID then warn("No killer ID was found") return false end

    local data = { command = command }
    local file = game:GetService("HttpService"):JSONEncode(data)
    writefile(path, file)
end

local function read()
    if not isfile(path) then
        writefile(path, game:GetService("HttpService"):JSONEncode({ command = 0 }))
        return nil
    else
        local content = readfile(path)
        if not content then return nil end
        return game:GetService("HttpService"):JSONDecode(content)
    end
end

-- Main logic
local function execute(file)
    if not file then return end

    local player = playersService.LocalPlayer
    local killerID = getKillerID()
    if not killerID then return end
    local killerHrp = playersService:GetPlayerByUserId(killerID).Character.HumanoidRootPart
    if not killerHrp then return end
    local command = file.command

    if killerID == player.UserId then return end
    if command == lastCommand then return end
    lastCommand = command

    -- Command execution
    if command == commands.hide then
        mainTween(player, positions.depths1)
    elseif command == commands.elevator then
        mainTween(player, positions.depths2)
    elseif command == commands.cathedral then
        mainTween(player, positions.cathedral)
        mainTween(player, positions.depths1)
    elseif command == commands.killerPos then
        mainTween(player, circle(killerHrp.Position))
    elseif command == commands.emote then
        event.Gesture:FireServer("Lean Back")
    elseif command == commands.menu then
        event.ReturnToMenu:FireServer()
    end
end

-- GUI shortcuts
function enmity.hide() enmity.write(commands.hide) end
function enmity.elevator() enmity.write(commands.elevator) end
function enmity.killerPos() enmity.write(commands.killerPos) end
function enmity.cathedral() enmity.write(commands.cathedral) end
function enmity.emote() enmity.write(commands.emote) end
function enmity.menu() enmity.write(commands.menu) end

-- Listener
function enmity.listener()
    if listener then return end
    listener = true
    task.spawn(function()
        while listener do
            task.wait(0.5)
            local data = read()
            if data then
                execute(data)
            end
        end
    end)
end

function enmity.stopListener()
    enmity.write(commands.afk)
    listener = false
end

return enmity