local Cache = loadstring(game:HttpGet("https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main/modules/cache.lua"))()

local Client = Cache.load("/modules/client.lua")
local KeyHandling = Cache.load("/modules/kh.lua")

local _client = false
local success1, err1 = pcall(function()
    _client = Client.init()
end)

if not success1 or _client == false then
    warn("Client failed:", err1)
    return
end

local success2, err2 = pcall(function()
    KeyHandling.init()
end)

if not success2 then
    warn("KeyHandler failed:", err2)
    return
end

local function getKey(name)
    return KeyHandling.getKey(name)
end

local Main = Cache.load("/main.lua")
local Gui = Cache.load("/gui.lua")

return {
    Client = Client,
    KeyHandler = KeyHandling,
    GetKey = getKey,
    Gui = Gui,
    Main = Main
}