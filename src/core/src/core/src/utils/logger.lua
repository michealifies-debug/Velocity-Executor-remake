-- src/utils/logger.lua
local Logger = {}

local colors = {
    INFO = "\x1b[92m",    -- Green
    WARN = "\x1b[93m",    -- Yellow
    ERROR = "\x1b[91m",   -- Red
    DEBUG = "\x1b[95m",   -- Magenta
    RESET = "\x1b[0m"
}

function Logger.log(level, message)
    local time = os.date("[%H:%M:%S]")
    local color = colors[level] or colors.RESET
    print(string.format("%s %s [%s] %s", time, color, level, message))
    print(colors.RESET)
end

function Logger.info(msg) Logger.log("INFO", msg) end
function Logger.warn(msg) Logger.log("WARN", msg) end
function Logger.error(msg) Logger.log("ERROR", msg) end
function Logger.debug(msg) Logger.log("DEBUG", msg) end

return Logger
