getgenv().Cache = getgenv().Cache or {}

local Repo = "https://raw.githubusercontent.com/TripleSushi/deepwoken-skiddie/main"

local function load(path)
    local url = Repo .. path

    if getgenv().Cache[url] then
        return getgenv().Cache[url]
    end

    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not success then
        warn("Failed to load: ", path, module)
        return nil
    end

    getgenv().Cache[url] = module

    return module
end

return {
    load = load
}