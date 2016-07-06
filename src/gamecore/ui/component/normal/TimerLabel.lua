-----------------------------------------------------------------------------
-- 计时控件
-- @author tjh
-- @release 1
-----------------------------------------------------------------------------

--!class TimerLabel

TimerLabel = simple_class(GUIText)



--================================
--- 创建函数
-- @param time  时间，单位为秒
-- @param end_call: 倒计时结束的回调
-- @param fontSize: 文本字体大小 默认正常字体
-- @param alignment:文本对齐方式 默认左对齐
-- @see GUIText
function TimerLabel:create( time, end_call, fontSize,alignment)
	if time ~= nil then 
		local lab = self(time,end_call,fontSize,alignment);
		return lab;
	end
	return ;
end

--- 设置time方向函数
-- @param reverse  bool  相反方向记时，该参数为true时，timer正向计时 默认是倒计时
function TimerLabel:set_reverse( reverse )
	self.reverse = reverse
end

---重新开始计时函数
-- @param time  时间，单位为秒
function TimerLabel:Restart( time )
	if self.timer then
		self.timer:stop();
		self.timer = nil;
	end
	self.times = time
	self:_start(  )
end


---销毁函数
function TimerLabel:destroy(  )
	self:_stop_timer()
end

--获取时间函数
-- @return time  时间，单位为秒
function TimerLabel:getTimes(  )
	if self.times then
		return self.times;
	end
	return 0;
end


function TimerLabel:__init( times,end_call,fontSize,alignment)
	self.times = times;
	self.brief = false;
	self.reverse = false;
	-- 倒计时结束的回调
	self.end_call = end_call;
	--计时lab
	local time_str;
	if self.times ~= nil then
		time_str = Utils:formatTime(self.times, self.brief);
	else 
		time_str = "";
	end
	
	self.view = GUIText:create(time_str,fontSize,alignment).view

	self:_start(  )

end

function TimerLabel:_start(  )
	local function timer_tick(  )
		self:_tick_fun();
	end
	self.timer = timer:create();
	self.timer:start(1,timer_tick);
end

function TimerLabel:_tick_fun(  )
	
	if self.reverse then

		self.times = self.times + 1;
		self:setString(Utils:formatTime(self.times, self.brief));
		
	else	
		self.times = self.times - 1;
		if self.times >= 0 then
			self:setString(Utils:formatTime(self.times, self.brief));
		else
			-- self.panel:setTimer(0);
			self.timer:stop();
			self.timer = nil;
			-- 如果有回调函数
			if self.end_call then
				self.end_call();
			end
		end
	end
	
end

function TimerLabel:_stop_timer(  )
	if self.timer then
		print("--------------------TimerLabel 停止函数--------------");
		self.timer:stop();
		self.timer = nil;
	end
	self:removeFromParent(true)
end
