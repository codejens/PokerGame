--回调！
local CSS = CCScheduler:sharedScheduler()
local scheduleScriptFunc = CSS.scheduleScriptFunc
local unscheduleScriptEntry = CSS.unscheduleScriptEntry
local reserve = {}
--timer是很有可能会被派生的
--super_class.timer()

_timer = { running = {} }

--new函数
function _timer:new( ... )
    local i = {}
    setmetatable(i, self)
    self.__index = self
	i:__init( ... )
    return i
end

function timer(...)
	return _timer:new(...)
end

--打印所有存活的timer
function _timer.print_running()
	print('running timers:')
	for k,v in pairs(_timer.running) do
		print(' ','id',k.scheduler_id,v.source, v.currentline)
	end
	print('---------------')
end

--构造函数，构造就立刻开始
function _timer:__init()
	self.scheduler_id = nil			--计划id
end

function _timer:start(_time, _function)
	local t = reserve
--@debug_begin
	t = debug.getinfo(2,'Sl')
--@debug_end
	self:stop()
	_timer.running[self] = t
	self.scheduler_id = scheduleScriptFunc(CSS,_function,_time,false)
end

function _timer:start_global(_time, _function)
	local t = reserve
--@debug_begin
	t = debug.getinfo(2,'Sl')
--@debug_end
	self:stop()
	self.scheduler_id = scheduleScriptFunc(CSS,_function,_time,false)
end


--取消
function _timer:stop()
	if self.scheduler_id then
		unscheduleScriptEntry(CSS,self.scheduler_id)
		self.scheduler_id = nil
		_timer.running[self] = nil
	end
end

function _timer.stop_all()
--@debug_begin
	_timer.print_running()
--@debug_end
	print('timer stop_all:')
	for k,v in pairs(_timer.running) do
		k:stop()
	end
	print('---------------')
end

--是否空闲，如果空闲可以被start
function _timer:isIdle()
	return self.scheduler_id == nil
end

function _timer.scene_leave()
	print('scene_leave _timer')
	_timer.stop_all()
end



function testtimer()
	require 'base'
	require 'utils/callback'
	--两个timer
	local function fd(dt) print('timer:' .. dt) end
	local t0 = timer()
		  t0:start(1,fd)

	local function fd2(dt) print('timer:' .. dt) end
	local t1 = timer()
		  t1:start(2,fd)

	--存活的timer
	local function runningcb(dt) print('cb1:' .. dt); _timer.print_running()  end
	local cb1 = callback:new()
		  cb1:start(2,runningcb)

	--取消timer
	local function byebyetimer0(dt) t0:stop(); print('bye bye timer0');_timer.print_running() end
	local cb2 = callback:new()
		  cb2:start(10,byebyetimer0)
end
