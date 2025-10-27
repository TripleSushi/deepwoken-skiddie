local Repo = "https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main"

local Client = loadstring(game:HttpGet(Repo .. "/modules/client.lua"))()
local KeyHandler = loadstring(game:HttpGet(Repo .. "/modules/kh.lua"))()
local Main = loadstring(game:HttpGet(Repo .. "/main.lua"))()
local Gui = loadstring(game:HttpGet(Repo .. "/gui.lua"))()

local _client = false
local success1, err1 = pcall(function()
    _client = Client.init()
end)

if not success1 then
    warn("Client failed:", err1)
    return
end

local kh = false
local success2, err2 = pcall(function()
    kh = KeyHandler.init()
end)

if not success2 then
    warn("KeyHandler failed:", err2)
    return
end

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