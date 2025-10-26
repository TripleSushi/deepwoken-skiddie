local Main = {}

local playersService = game:GetService("Players")
local LocalPlayer = playersService.LocalPlayer

if game.PlaceId == 4111023553 then
    LocalPlayer:Kick("Only run in main-game")
    return Main
end


return Main