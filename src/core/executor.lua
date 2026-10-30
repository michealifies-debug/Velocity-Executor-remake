-- src/core/executor.lua
local Executor = {}

local _G = _G
local script = script

-- Configuration
local config = {
    max_depth = 100, -- Max recursion depth for pretty printing
    verbose = false,
    theme = "dark"
}

-- Utility to get a timestamp
local function timestamp()
    return os.date("%H:%M:%S")
end

-- Pretty print for tables
function Executor.pprint(data, indent, max_depth)
    indent = indent or 0
    max_depth = max_depth or config.max_depth
    local space = string.rep("  ", indent)
    
    if type(data) ~= "table" then
        print(space .. tostring(data))
        return
    end

    print(space .. "{")
    for k, v in pairs(data) do
        local key = type(k) == "string" and string.format("%q", k) or tostring(k)
        print(string.format("%s%s = ", space, key), end = "")
        
        if type(v) == "table" and indent < max_depth then
            print(end = "")
            Executor.pprint(v, indent + 1, max_depth)
        else
            print(tostring(v))
        end
    end
    print(space .. "}")
end

-- Core Execute function
function Executor.exec(code, label)
    label = label or "inline"
    
    if type(code) ~= "string" then
        error("Executor.exec: code must be a string", 2)
    end

    local chunk, err = loadstring(code, label)
    if not chunk then
        Executor.logger("ERROR", "Compilation failed: " .. err)
        return nil, err
    end

    local success, result = pcall(chunk)
    if not success then
        Executor.logger("RUNTIME", "Execution error: " .. result)
        return nil, result
    end
    
    Executor.logger("INFO", string.format("[%s] Execution successful", label))
    return result
end

-- Execute a file
function Executor.execFile(path)
    local file = io.open(path, "r")
    if not file then
        error("Cannot open file: " .. path, 2)
    end
    local content = file:read("*a")
    file:close()
    return Executor.exec(content, path)
end

-- Safe execution with a custom environment
function Executor.execSafe(code, env)
    env = env or _G
    local chunk = loadstring(code, "safe")
    if not chunk then return nil end
    setfenv(chunk, env)
    return pcall(chunk)
end

return Executor
