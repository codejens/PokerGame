TimeLerpSin = simple_class()

local _math_sin = math.sin
local _PI = 3.14159265

function _TimeLerpSinTick(obj,dt)
	obj.t_pass = obj.t_pass + dt
	local t = obj.t_pass / obj.t_dur
	if t > 1.0 then
		obj.timer:stop()
		obj.cb(0)
		return
	end
	local h = math.sin(3.14159 * t)
	obj.cb(h)
end

function TimeLerpSin:__init()
	self.timer = timer()
	self.cb = nil
	self.time_pass = 0
end

function TimeLerpSin:start(tick, dur, cb)
	self.t_pass = 0
	self.t_dur = dur
	self.cb = cb
	self.timer:stop()
	self.timer:start(tick,bind(_TimeLerpSinTick,self))
end

function TimeLerpSin:stop()
	self.timer:stop()
end

------------------------
--
------------------------
TimeLerp = simple_class()

function _TimeLerpTick(obj,dt)
	obj.t_pass = obj.t_pass + dt
	local t = obj.t_pass / obj.t_dur
	if t > 1.0 then
		obj.timer:stop()
		obj.cb(1.0)
		return
	end
	obj.cb(t)
end

function TimeLerp:__init()
	self.timer = timer()
	self.cb = nil
	self.time_pass = 0
end

function TimeLerp:start(tick, dur, cb)
	self.t_pass = 0
	self.t_dur = dur
	self.cb = cb
	self.timer:stop()
	self.timer:start(tick,bind(_TimeLerpTick,self))
end

function TimeLerp:stop()
	self.timer:stop()
end