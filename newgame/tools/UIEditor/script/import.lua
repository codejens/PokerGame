
-------------------------------------------------
-- 重载require
require_timetable = {}
require_stack = {}
require_trace = {}
local _require = require
local t_insert = table.insert
local t_remove = table.remove


local function myrequire(szName)
	if package.loaded[szName]==nil then
		local c = os.clock()
		_require(szName)
		c = os.clock() - c
		require_timetable[#require_timetable+1] = { c, szName }
		require_trace[#require_trace+1] = szName
	end
end

function requirelog()
	f = io.open('require.log','w+')
	table.sort(require_timetable,function (a,b) return a[1] > b[1] end)
	for i,v in ipairs(require_timetable) do
		f:write(v[1],' : ', v[2],'\n')
	end
	f:close()


	f = io.open('require_queue.log','w+')
	for k,v in pairs(require_trace) do
		f:write(k, ':', v ,'\n')
	end
	f:close()
end

require = myrequire