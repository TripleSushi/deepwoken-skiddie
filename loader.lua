<<<<<<< HEAD
local Repo = "https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main"

local Client = loadstring(game:HttpGet(Repo .. "/modules/client.lua"))()
local KeyHandler = loadstring(game:HttpGet(Repo .. "/modules/kh.lua"))()
local Main = loadstring(game:HttpGet(Repo .. "/main.lua"))()
=======
local Repo = "https://github.com/TripleSushi/deepwoken-skiddie"

local Client = loadstring(game:HttpGet(Repo .. "/modules/client.lua"))()
local KeyHandler = loadstring(game:HttpGet(Repo .. "/modules/kh.lua"))()
>>>>>>> 7689d71e60f7eac7f79e7989a73e3199145eb8a6

Client.init()
KeyHandler.init()

local function getKey(name)
    return KeyHandler.getKey(name)
end

return {
    Client = Client,
    KeyHandler = KeyHandler,
<<<<<<< HEAD
    GetKey = getKey,
    Main = Main
=======
    GetKey = getKey
>>>>>>> 7689d71e60f7eac7f79e7989a73e3199145eb8a6
}