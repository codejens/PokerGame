--回调！
local cc_director = cc.Director:getInstance()
local _scheduler = cc_director:getScheduler()

local reserve = {}
--timer是很有可能会被派生的
--super_class.timer()

timer = { running = {} }

--new函数
function timer:create( ... )
    local i = {}
    setmetatable(i, self)
    self.__index = self
	i:__init( ... )
    return i
end

--打印所有存活的timer
function timer.print_running()
	print('running timers:')
	for k,v in pairs(timer.running) do
		print(' ','id',k.scheduler_id,v.source, v.currentline)
	end
	print('---------------')
end

--构造函数，构造就立刻开始
function timer:__init()
	self.scheduler_id = nil			--计划id
end

function timer:start(_time, _function)
	local t = reserve
--@debug_begin
	t = debug.getinfo(2,'Sl')
--@debug_end
	self:stop()
	timer.running[self] = t
	self.scheduler_id = _scheduler:scheduleScriptFunc(_function,_time,false)
end

function timer:start_global(_time, _function)
	local t = reserve
--@debug_begin
	t = debug.getinfo(2,'Sl')
--@debug_end
	self:stop()
	self.scheduler_id = _scheduler:scheduleScriptFunc(_function,_time,false)
end


--取消
function timer:stop()
	if self.scheduler_id then
		_scheduler:unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
		timer.running[self] = nil
	end
end

function timer.stop_all()
--@debug_begin
	timer.print_running()
--@debug_end
	print('timer stop_all:')
	for k,v in pairs(timer.running) do
		k:stop()
	end
	print('---------------')
end

--是否空闲，如果空闲可以被start
function timer:isIdle()
	return self.scheduler_id == nil
end

function timer.onAppQuit()
	print('timer.onAppQuit')
	timer.stop_all()
end

function test_timer()
	--两个timer
	local function fd(dt) print('timer:' .. dt) end
	local t0 = timer:create()
		  t0:start(1,fd)

	local function fd2(dt) print('timer:' .. dt) end
	local t1 = timer:create()
		  t1:start(2,fd)

	--存活的timer
	local function runningcb(dt) print('cb1:' .. dt); timer.print_running()  end
	local cb1 = callback:create()
		  cb1:start(2,runningcb)

	--取消timer
	local function byebyetimer0(dt) t0:stop(); print('bye bye timer0');timer.print_running() end
	local cb2 = callback:create()
		  cb2:start(10,byebyetimer0)
end
