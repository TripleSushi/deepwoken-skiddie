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

    while wait(0.5) do
        if getgenv().Toggles.AutoBank.Value == false then
            break
        end

        if tonumber(knowledge.Text) == 0 then
            break
        end

        local item = player.Backpack:FindFirstChild(itemName)
        if not item then break end

        event:FireServer("deposit", item)
        local prompt = gui:WaitForChild("ChoicePrompt", 2)
        if prompt then
            local choice = prompt:FindFirstChild("Choice")
            if choice then
                choice:FireServer(true)
            end
        end
    end
    getgenv().Toggles.AutoBank:SetValue(false)
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