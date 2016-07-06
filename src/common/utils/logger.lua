--[[ rewrite see function.lua ]]
local _sys_helper = helpers.SystemHelpers
local LOG_GREEN = 0x000A
local LOG_RED   = 0x000C
local LOG_YELLOW   = 0x000E
local _trace = debug.traceback
local _t_concat = table.concat
local _s_upper = string.upper
local _s_format = string.format
local _huge = math.huge

print_stack = print

local function _log(tag, fmt, ...)
    local t = {
        "[",
        string.upper(tostring(tag)),
        "] ",
        string.format(tostring(fmt), ...)
    }
    print(table.concat(t))
end

function logErr(fmt, ...)
    _log("ERR", fmt, ...)
end

function logInfo(fmt, ...)
    _log("INFO", fmt, ...)
end

function logWarn(fmt, ...)
    _log("WARN", fmt, ...)
end



--@debug_begin
local function _log(tag, color, fmt, ...)
    local t = {
        "[",
        _s_upper(tostring(tag)),
        "] ",
        _s_format(tostring(fmt), ...)
    }
    _sys_helper:log(_t_concat(t),color)
end

function logErr(fmt, ...)
    _log("ERR",LOG_RED, fmt, ...)
    _sys_helper:log(_trace("", 2),LOG_RED)
end

function logInfo(fmt, ...)
    if type(DEBUG) ~= "number" or DEBUG < 2 then return end
    _log("INFO",LOG_GREEN, fmt, ...)
end

function logWarn(fmt, ...)
    if type(DEBUG) ~= "number" or DEBUG < 2 then return end
    _log("WARN",LOG_YELLOW, fmt, ...)
end

local _print = function(...)
    local out = {}

    local n = select('#', ...)

    for i=1, n, 1 do
        local v = select(i,...)
        out[#out+1] = tostring(v)
    end
    logInfo(_t_concat(out,' '))
end


print_stack = function(...)
    _print(...)
    _sys_helper:log(_trace("", 2),LOG_YELLOW)
end

print = _print

--@debug_end




__G__TRACKBACK__ = function(msg)
    local msg = _trace(msg, 3)
    _sys_helper:log(msg,LOG_RED)
    return msg
end