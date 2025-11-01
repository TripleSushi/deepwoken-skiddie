local autobank = {}

local playersService = game:GetService("Players")
local player = playersService.LocalPlayer
local httpService = game:GetService("HttpService")

local function deposit(itemName)
    local gui = player:WaitForChild("PlayerGui")
    local event = gui:WaitForChild("BankGui").Choice
    local knowledge = gui.CurrencyGui.CurrencyFrame.ShrinePoints.Amount

    if not event then
        return
    end

    while wait(0.45) do
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

function autobank.withdrawal()
    local bankGui = player:WaitForChild("PlayerGui"):WaitForChild("BankGui")
    local event = bankGui.Choice
    local item, quantity = getgenv().WithdrawRelics.Value, getgenv().WQuantity.Value
    local info = bankGui:GetAttribute("BankJSON")

    if not info then
        warn("No info was found")
        return
    end

    local data = httpService:JSONDecode(info)
    local counter = 0

    for _, relic in data do
        if getgenv().WithdrawRelics.Value == false then
            break
        end

        if counter >= quantity then
            break
        end

        if relic.Name == item then
            local stock = relic.qt or 1
            event:FireServer("withdraw", relic.id)
            counter = counter + stock

            while bankGui:GetAttribute("BankBusy") do
                task.wait(0.1)
            end
        end
    end
end

function autobank.custom()
    local customItem = getgenv().Options.CustomItem.Value
    deposit(customItem)
end

function autobank.relic()
    local relics = getgenv().Options.Relics.Value
    deposit(relics)
end
return autobank