local Repo = "https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main"

local Client = loadstring(game:HttpGet(Repo .. "/modules/client.lua"))()
local KeyHandler = loadstring(game:HttpGet(Repo .. "/modules/kh.lua"))()
local Main = loadstring(game:HttpGet(Repo .. "/main.lua"))()
local Gui = loadstring(game:HttpGet(Repo .. "/gui.lua"))()

local success1, err1 = pcall(function()
    Client.init()
end)

local success2, err2 = pcall(function()
    KeyHandler.init()
end)

if not success1 then
    warn("Client init failed:", err1)
end

if not success2 then
    warn("KeyHandler init failed:", err2)
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