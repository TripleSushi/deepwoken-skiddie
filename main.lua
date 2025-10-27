local Main = {}

--Line 6: defines the variable to use the "Players" service
--Line 7: defines the variable to get the localplayer (the one that executes the script)

local playersService = game:GetService("Players")
local LocalPlayer = playersService.LocalPlayer
local Enmity = loadstring(game:HttpGet('https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main/features/enmity.lua'))()

--Prevent execution in unwanted places
--Prevents execution in Deepwoken Menu by checking the PlaceId
if game.PlaceId == 4111023553 then
    LocalPlayer:Kick("Only run in main-game")
end

Enmity.listener()

return Main