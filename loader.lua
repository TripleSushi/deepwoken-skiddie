local Repo = "https://github.com/TripleSushi/deepwoken-skiddie"

local Client = loadstring(game:HttpGet(Repo .. "/modules/client.lua"))()
local KeyHandler = loadstring(game:HttpGet(Repo .. "/modules/kh.lua"))()

Client.init()
KeyHandler.init()

local function getKey(name)
    return KeyHandler.getKey(name)
end

return {
    Client = Client,
    KeyHandler = KeyHandler,
    GetKey = getKey
}