-- src/main.lua
local Executor = require(script.Parent:FindFirstChild("executor"))
local Console = require(script.Parent:FindFirstChild("console"))
local Logger = require(script.Parent:FindFirstChild("logger"))

-- Initialize
Logger.info("Velocity Executor initialized.")

-- Example: Execute some starter code
Executor.exec([[
    print("Hello from Velocity!")
    print("Server: " .. game.JobId)
]])

-- Start interactive console
Console.start()
