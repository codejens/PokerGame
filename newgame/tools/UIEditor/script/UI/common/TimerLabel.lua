-- TimerLabel.lua
-- created by fjh on 2013-2-22
-- 用于计时相关的label


local running = {}



super_class.TimerLabel()

-- local _end_call = nil;

function TimerLabel:tick_fun(  )
	--获取经过时间
	if self.multiple then
		self.multiple_add = (self.multiple_add + self.multiple-1)
	end
	local passTime = os.time() - self._start_time + self.multiple_add
	--如果正时间，就累计
	if self.reverse then
		local remainTime = passTime + self.total_time
		local show_text = self.color..Utils:formatTime(remainTime, self.brief)
		if self.text ~= nil then
				show_text = self.color..self.text..Utils:formatTime(remainTime, self.brief)
		end
		self.timer_label:setText(show_text);
	else
		--如果是倒计时就计算剩下时间
		local remainTime = self.total_time - passTime
		if remainTime >= 0 then
			local show_text = self.color..Utils:formatTime(remainTime, self.brief)
			if self.text ~= nil then
				 show_text = self.color..self.text..Utils:formatTime(remainTime, self.brief)
			end
			self.timer_label:setText(show_text);
		else
			-- self.panel:setTimer(0);
			self.timer:stop();
			self.timer = nil;
			self.timer_label:setText("")
			-- 如果有回调函数
			if self.end_call then
				self.end_call();
			end
		end
	end
	
end

function TimerLabel:__init(x, y, fontSize, times, color, brief, alignment, end_call,reverse,text, multiple)
	--记录总计时间
	self.total_time = times;
	self.color = color;
	self.brief = brief;
	self.reverse = reverse;
	self.text = text 
	self.panel = BasePanel:create(nil, x, y, 10, 10);
	-- 倍数倒计时，几秒几秒的倒
	self.multiple = multiple 
	self.multiple_add = 0

--@debug_begin
	self.trace = {}
	self.trace[1] = debug.getinfo(4,'Sl')
	self.trace[2] = debug.getinfo(5,'Sl')
	self.trace[3] = debug.getinfo(6,'Sl')
--@debug_end
	running[self] = true

	-- 倒计时结束的回调
	self.end_call = end_call;

	if self.color == nil then
		self.color = "#cffffff";
	end
	if self.brief == nil then
		self.brief = false;
	end
	--计时lab
	local time_str;
	if self.total_time ~= nil then
		time_str = self.color..Utils:formatTime(self.total_time, self.brief);
	else 
		time_str = "";
	end
	
	if alignment == nil then
		alignment = ALIGN_LEFT;
	end
	if self.text ~= nil then 
		time_str = self.text..time_str
	end 
	self.timer_label = UILabel:create_lable_2( time_str, 0, 0, fontSize, alignment );
	self.panel.view:addChild(self.timer_label);


	local function timer_tick(  )
--@debug_begin
		local s, e = pcall(
		function()
--@debug_end
			self:tick_fun();
--@debug_begin
		end)
		if not s then
			print('timelabel_trace')
			for i,v in ipairs(self.trace) do
				print(v.source, v.currentline)
			end
			error(e)
		end
--@debug_end
	end
	-- self.panel:setTouchTimerFun(timer_tick);
	self.timer = timer();
	--记录开始时间
	self._start_time = os.time()
	self.timer:start(1,timer_tick);
	-- self.panel:setTimer(1);

	--对外调用的销毁变量
	self.destroy_timer = function ( )
		self:stop_timer();
	end
end

--================================
-- 创建一个倒计时的label
-- parent：  父节点
-- time:     时间，单位为秒
-- color：   字体颜色 ，如 "#cffffff"
-- end_call: 倒计时结束的回调
-- brief:    简约格式化的参数，如果brief==true，则只显示最大的俩个时间单位，
--			 如完全格式化后的时间为: 1小时40分30秒，简约化：1小时40分。 
-- alignment:文本layout , ALIGN_LEFT, ALIGN_CENTER, ALIGN_RIGHT
-- reverse:	 计时相反
-- text	:附加参数，放在倒计时前面，如："CD:"+10秒
--================================

function TimerLabel:create_label(parent, x, y, fontSize, time, color, end_call, brief, alignment, reverse,text, multiple)
	if time ~= nil then 
		local lab = TimerLabel(x,y,fontSize,time,color,brief, alignment,end_call,reverse,text, multiple);
		parent:addChild(lab.panel.view);
		return lab;
	end
	return ;
end

-- setText
-- 用于设置倒计时
function TimerLabel:setText( time )
	time = tonumber(time);
	if time > 0 then
		if self.timer_label ~= nil then
			self.total_time = time;
			local show_text = self.color..Utils:formatTime(self.total_time, self.brief)
			if self.text ~= nil then
				show_text = self.color..self.text..Utils:formatTime(self.total_time, self.brief)
			end 
			self.timer_label:setText(show_text);
			--记录起始时间
			self._start_time = os.time()
			if self.timer == nil  then
				local function timer_tick(  )
					self:tick_fun();
				end
				self.timer = timer();
				self.timer:start(1,timer_tick);
			end
		end
	else
	end
end

function TimerLabel:set_end_call( fn )
	self.end_call = fn;
end

-- setString
-- 用于设置文字，有时候会需要显示一段lab而不是倒计时
function TimerLabel:setString( string )
	if self.timer then
		self.timer:stop();
		self.timer = nil;
	end
	self.timer_label:setText(self.color..string);
end

function TimerLabel:getPositionY(  )
	return self.panel.view:getPositionY();
end

function TimerLabel:setIsVisible( bool )
	self.panel.view:setIsVisible(bool);
end

function TimerLabel:stop_timer(  )
	if self.timer then
		-- print("--------------------TimerLabel 停止函数--------------");
		self.timer:stop();
		self.timer = nil;
	end
end

function TimerLabel:destroy(  )
	-- print("--------------------TimerLabel 销毁函数--------------");
	self:stop_timer();
	if self.panel then
		self.panel.view:removeFromParentAndCleanup(true);	
	end
	self.panel = nil;
	self.timer_label = nil
	running[self] = nil
end

function TimerLabel_SceneLeave()
	for k,v in pairs(running) do
--@debug_begin
		print('TimerLabel_SceneLeave')
		for i,vv in ipairs(k.trace) do
			print(vv.source, vv.currentline)
		end
--@debug_end
		k:stop_timer()
	end
end

function TimerLabel_DebugRunning()
	for k,v in pairs(running) do
		print('TimerLabel_SceneLeave',k)
--@debug_begin
		for i,vv in ipairs(k.trace) do
			print(vv.source, vv.currentline)
		end
--@debug_end
	end
end

function TimerLabel:getRemainTime()
	if self.timer then
		--获取经过时间
		local passTime = os.time() - self._start_time
	    --如果正时间，就累计
		if self.reverse then
			return passTime
		else
			return (self.total_time - passTime)
		end
	else
		-- timer被销毁时,返回0
		return 0
	end
end