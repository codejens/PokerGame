local _old_print = print
local table_concat = table.concat
module(...,package.seeall)
local log = nil
local _log_msg = ''
local new_print = function(...)
    local out = {}

    local n = select('#', ...)

    for i=1, n, 1 do
        local v = select(i,...)
        out[#out+1] = tostring(v)
    end
    local msg = table_concat(out,' ')
    _old_print(msg)
    _log_msg = _log_msg .. '\n' .. msg
    log:setString(_log_msg)
end


function startTest(root)
	print = new_print
	log = ccui.Text:create()
  	root:addChild(log)
  	log:setPosition(960/2,640/2)

	local t = timer:create()
	t:start(0.5, function() print('0.5秒一跳的timer, 2秒后用callback取消',os.clock()) end)
	local c = callback:create()
	c:start(2,function() t:stop() print('timer 取消', os.clock()) end)
end

function endTest()
	print = _old_print
	_log_msg = ''
end