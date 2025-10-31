local autobank = {}

local playersService = game:GetService("Players")
local player = playersService.LocalPlayer
local event = player.PlayerGui.BankGui.Choice
local customItem, relics = getgenv().Options.CustomItem.Value, getgenv().Options.Relics.Value
local knowledge = player.PlayerGui.CurrencyGui.CurrencyFrame.ShrinePoints.Amount

if tonumber(knowledge.Text == 0) then
    return
end

if not event then
    return
end

local function itemCount(itemName)
    local backpack = player:FindFirstChild("Backpack")
    local count = 0
    for _, item in backpack:GetChildren() do
        if item.Name == itemName then
            count = count + 1
        end
    end
    return count
end

local function depositItem(itemName)
    local count = itemCount(itemName)
    for _ = 1, count do
        local item = player.Backpack:FindFirstChild(itemName)
        if not item then break end
        event:FireServer("deposit", item)
    end

    local gui = player:WaitForChild("PlayerGui")
    local prompt = gui:FindFirstChild("ChoicePrompt")

    if prompt and prompt.Enabled == true then
        local choice = prompt:FindFirstChild("Choice")
        choice:FireServer(true)
    end
end

function autobank.custom()
    depositItem(customItem)
end

function autobank.relic()
    depositItem(relics)
end

return autobank