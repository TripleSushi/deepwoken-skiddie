local Repo = "https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main"

local Client = loadstring(game:HttpGet(Repo .. "/modules/client.lua"))()
local KeyHandler = loadstring(game:HttpGet(Repo .. "/modules/kh.lua"))()
local Main = loadstring(game:HttpGet(Repo .. "/main.lua"))()
local Gui = loadstring(game:HttpGet(Repo .. "/gui.lua"))()

Client.init()
KeyHandler.init()

local function getKey(name)
    return KeyHandler.getKey(name)
end

return {
    Client = Client,
    KeyHandler = KeyHandler,
    GetKey = getKey,
    Main = Main,
    Gui = Gui
}