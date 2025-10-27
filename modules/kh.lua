-- Credits to the thread author
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer 

local hashMap = { }
local sha256KTable, remoteNode; do
    for _, v in getgc(true) do
        if typeof(v) == "table" and not getrawmetatable(v) then
            local idx, vl = next(v)
            if(typeof(idx) == "number" and typeof(vl) == "number" and vl >= 100000 and vl <= 100000000 and #v == 68) then
                sha256KTable = v
            end
            if(typeof(idx) == "string" and typeof(vl) == "Instance" and vl:IsA("BaseRemoteEvent") and #v == 0) then
                remoteNode = v
            end
        end
        if sha256KTable and remoteNode then
            break
        end
    end
    if not sha256KTable and not remoteNode then 
        return LocalPlayer:Kick("Failed to grab sha256 K Table, and remote node")
    end 
end

local sha256; do 
    local bit = bit32 or bit 
    local bxor = bit32["bxor"]
    local band = bit32["band"]
    local bor = bit32["bor"]
    local bnot = bit32["bnot"]
    local rshift = bit32["rshift"]
    local lshift = bit32["lshift"]
    
    local function init()
        local function rrotate(x, disp)
            disp = disp % 32
            local low = band(x, 2 ^ disp - 1)
            return rshift(x, disp) + lshift(low, 32 - disp)
        end
        local number2String = coroutine.wrap(function(l, n)
            while true do
                local s = ""
                for i = 1, n do
                    local rem = l % 256
                    s = string.char(rem) .. s
                    l = (l - rem) / 256
                end
                l, n = coroutine.yield(s)
            end
        end)
        local string2Number = coroutine.wrap(function(s, i)
            while true do
                local n = 0
                for i = i, i + 3 do 
                    n = n * 256 + string.byte(s, i) 
                end
                s, i = coroutine.yield(n)
            end
        end)
        local preProcess = coroutine.wrap(function(msg, len)
            while true do
                local extra = 64 - ((len + 9) % 64)
                len = number2String(8 * len, 8)
                
                msg = msg .. string.char(128) .. string.rep(string.char(0), extra) .. len
                msg, len = coroutine.yield(msg)
            end
        end)
        local function digestBlock(msg, i, H)
            local w = {}
            
            for j = 1, 16 do w[j] = string2Number(msg, i + (j - 1)*4) end
            for j = 17, 64 do
                local v = w[j - 15]
                local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
                v = w[j - 2]
                w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
            end
            local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
            for i = 1, 64 do
                local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
                local maj = bxor(band(a, b), band(a, c), band(b, c))
                local t2 = s0 + maj
                local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
                local ch = bxor (band(e, f), band(bnot(e), g))
                local t1 = h + s1 + ch + sha256KTable[i] + w[i]
                h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
            end
            H[1] = band(H[1] + a)
            H[2] = band(H[2] + b)
            H[3] = band(H[3] + c)
            H[4] = band(H[4] + d)
            H[5] = band(H[5] + e)
            H[6] = band(H[6] + f)
            H[7] = band(H[7] + g)
            H[8] = band(H[8] + h)
        end
        sha256 = coroutine.wrap(function(msg)
            while true do
                local H = {
                    1779033703,
                    3144134277,
                    1013904242,
                    2773480762,
                    1359893119,
                    2600822924,
                    528734635,
                    1541459225
                }
                msg = preProcess(msg, #msg)
                for i = 1, #msg, 64 do 
                    digestBlock(msg, i, H) 
                end
                msg = coroutine.yield(number2String(H[1], 4) .. number2String(H[2], 4) .. number2String(H[3], 4) .. number2String(H[4], 4) .. number2String(H[5], 4) .. number2String(H[6], 4) .. number2String(H[7], 4) .. number2String(H[8], 4))
            end
        end)
    end
    init() 
    init = nil
end

local function getKey(name)
    local hashedName = hashMap[name] or sha256(name)
    if not hashMap[name] then
        hashMap[name] = hashedName
    end
    return remoteNode[hashedName]
end

-- Credits to the thread author