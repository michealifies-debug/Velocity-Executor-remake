-- src/ui/console.lua
local Console = {}
local Executor = require(script.Parent.Parent:FindFirstChild("executor"))
local Logger = require(script.Parent.Parent:FindFirstChild("logger"))

local history = {}
local historyIndex = 0

local function printPrompt()
    print("\x1b[94mVelocity\x1b[0m > ", end = "")
end

local function processCommand(cmd)
    -- Built-in commands
    if cmd:lower() == "help" then
        print([[
Available Commands:
  exec <code>    : Execute Lua code
  info           : Show game info
  players        : List players
  clear          : Clear console
  quit           : Exit console
]])
    elseif cmd:lower() == "info" then
        local env = require(script.Parent.Parent:FindFirstChild("environment"))
        local info = env.getGameInfo()
        for k, v in pairs(info) do
            print(string.format("%s: %s", k, tostring(v)))
        end
    elseif cmd:lower() == "players" then
        local env = require(script.Parent.Parent:FindFirstChild("environment"))
        local players = env.getPlayers()
        for _, p in ipairs(players) do
            print(string.format("%s (%d) - %s", p.Name, p.UserId, p.Char))
        end
    elseif cmd:lower() == "clear" then
        os.execute("clear")
    elseif cmd:lower() == "quit" then
        print("Exiting Velocity Console...")
        return false
    elseif cmd:sub(1, 5) == "exec " then
        local code = cmd:sub(6)
        Executor.exec(code, "console")
    else
        -- Default to exec if not a known command
        Executor.exec(cmd, "console")
    end
    return true
end

function Console.start()
    print("\n\x1b[94mVelocity\x1b[0m v1.0 - Interactive Console")
    print("Type 'help' for available commands.\n")
    
    while true do
        printPrompt()
        local input = io.read("*l")
        if not input then break end
        
        if input ~= "" then
            table.insert(history, input)
            historyIndex = #history
            
            local continue = processCommand(input)
            if not continue then break end
        end
    end
end

return Console
