getgenv().Cache = getgenv().Cache or {}
local Repo = "https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main"

local function load(path)
    local url = Repo .. path

    if not getgenv().Cache[url] then
        local success, func = pcall(function()
            return loadstring(game:HttpGet(url))
        end)

        if not success then
            warn("Failed to load: ", path, func)
            return nil
        end

        getgenv().Cache[url] = func
    end

    local success, module = pcall(getgenv().Cache[url])
    if not success then
        warn("Failed to execute: ", path, module)
        return nil
    end

    return module
end

return {
    load = load
}