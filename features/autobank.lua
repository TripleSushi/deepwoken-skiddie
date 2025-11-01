local autobank = {}

local playersService = game:GetService("Players")
local player = playersService.LocalPlayer

local function depositItem(itemName)
    local gui = player:WaitForChild("PlayerGui")
    local event = gui.BankGui.Choice
    local knowledge = gui.CurrencyGui.CurrencyFrame.ShrinePoints.Amount

    if not event then
        return
    end

    while true do
        if not getgenv().Toggles.AutoBank.Value then
            break
        end

        if tonumber(knowledge.Text) == 0 then
            break
        end

        local item = player.Backpack:FindFirstChild(itemName)
        if not item then break end

        event:FireServer("deposit", item)

        wait(0.8)

        local choice = gui:FindFirstChild("ChoicePrompt"):FindFirstChild("Choice")
        if choice then
            choice:FireServer(true)
        end
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