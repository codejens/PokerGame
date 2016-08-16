--luaPerformance.lua
--lua帧性能检测

luaPerformance = {}

local start = 0
local last = 0

local _performance_list = {}

function luaPerformance:start(   )
--@debug_begin
	local time = timer()
	local function tick( dt )
		luaPerformance:print_performance( dt )
	end
	time:start(0,tick)
--@debug_end
end

--解包检查
function luaPerformance:add_performance(name,time  )
--@debug_begin
	_performance_list[#_performance_list+1] = {name,time}
--@debug_end
end

function luaPerformance:print_performance( dt )
	local alltime = 0
	for i=1,#_performance_list do
		alltime = alltime +_performance_list[i][2]
	end
	
	if alltime > 30 then
		-- printc("#cff0000lua帧性能检测开始----------",dt,5)
		for i=1,#_performance_list do
			if _performance_list[i][2] > 0 then
				-- print(_performance_list[i][1].._performance_list[i][2])
			end
		end
		-- printc("lua帧性能检测结束----------",alltime,5)
	end
	_performance_list = {}
end
-- --回调检查
-- function luaPerformance:add_call_back(  )
-- 	-- body
-- end

-- --定时器检查
-- function luaPerformance:add_timer(  )
-- 	-- body
-- end