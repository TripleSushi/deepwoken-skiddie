local autobank = {}

local playersService = game:GetService("Players")
local player = playersService.LocalPlayer
local event = player.PlayerGui.BankGui.Choice
local knowledge = player.PlayerGui.CurrencyGui.CurrencyFrame.ShrinePoints.Amount

if tonumber(knowledge.Text) == 0 then
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
    if not event then
        return
    end
    
    local count = itemCount(itemName)
    for i = 1, count do
        local item = player.Backpack:FindFirstChild(itemName)
        if not item then break end
        event:FireServer("deposit", item)
    end
    wait(0.2)
    local gui = player:WaitForChild("PlayerGui")
    local prompt = gui:FindFirstChild("ChoicePrompt")

    if prompt and prompt.Enabled == true then
        local choice = prompt:FindFirstChild("Choice")
        choice:FireServer(true)
    end
end

function autobank.custom()
    local customItem = getgenv().Options.CustomItem.Value
    depositItem(customItem)
end

function autobank.relic()
    local relics = getgenv().Options.Relics.Value
    depositItem(relics)
end

return autobank