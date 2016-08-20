-- 变身预览窗口
super_class.TransformPreviewWin( Window )

function TransformPreviewWin:__init( window_name, texture_name, is_grid, width, height )
	-- create window title
	local winTitle = CCZXImage:imageWithFile( width/2, height - 58, -1, -1, UI_TransPreWin_002 );
	winTitle:setAnchorPoint( 0.5, 0 );
	self.view:addChild( winTitle );

	-- create close button
	local function on_exit_button_clicked()
		UIManager:hide_window( "transform_preview_win" );
		Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
	end

	-- @param ( fatherPanel, image, fun, x, y, width, height )
	self.exit_btn = ZButton:create( self.view, UI_TransPreWin_003, on_exit_button_clicked, width - 79, height - 63, -1, -1 );

	-- create count down timer
	self.timer = timer();
	self.timer_label = ZLabel:create( self.view, "",82,422,18);
	ZLabel:create( self.view, "#c0edc09后可获得", 210, 422, 18 );

	-- create skill name
	local skill_name = CCZXImage:imageWithFile( 118, 375, -1, -1, UI_TransPreWin_005 );
	self.view:addChild( skill_name );

	-- create animation
	local frame_str = "frame/human/0/10009"
    local action = UI_TRANSFORM_ACTION;
    self.animate = MUtils:create_animation( 218,265,frame_str,action );
    self.view:addChild( self.animate, 20 );

	-- create skill slot
	local slot_bg = CCZXImage:imageWithFile( 72+1, 99+10-1, -1, -1, UI_TransPreWin_004 );
	self.view:addChild( slot_bg );
	local skill_slot = SlotSkill(60, 60)
    skill_slot.view:setPosition(78, 105+10)
    self.view:addChild( skill_slot.view )
    skill_slot:set_icon( 284 )

  	ZImage:create(self.view, "ui/transform/skilltips.png", 145, 80, -1, -1)

    -- 创建领取变身按钮 fatherPanel, image, fun, x, y, width, height, z
    local function on_button_clicked()
    	TransformCC:request_begin_count_down( 2 )
    end
    self.get_transform_btn = ZButton:create( self.view, UI_TransPreWin_006, on_button_clicked, 82, 21, -1, -1 )
    self.get_transform_btn:addImage( CLICK_STATE_DOWN, UI_TransPreWin_006 );
    self.get_transform_btn:addImage( CLICK_STATE_DISABLE, UI_TransPreWin_007 );
    self.get_transform_btn.view:setCurState( CLICK_STATE_DISABLE );
end

function TransformPreviewWin:destroy()
	if self.timer then
		self.timer:stop();
		self.timer = nil;
		self.times = 0;
	end
	Window.destroy( self );
end

function TransformPreviewWin:active( show )
	if show then
		-- 与RightTopPanel中倒计时按钮显示的倒计时进行同步
		self:syncTimeWithRightTopPanel()

		-- LuaEffectManager:stop_view_effect( 15, self.view );
    	LuaEffectManager:stop_view_effect( 15, self.view );
    	local effect_1=LuaEffectManager:play_view_effect( 15, 0, 0, self.view, true, 0 );
    	effect_1:setPosition(190,250)
    	-- local effect_2=LuaEffectManager:play_view_effect( 15, 0, 0, self.view, true, 2 );
    	-- effect_2:setPosition(190,180)
    else
    	-- LuaEffectManager:stop_view_effect( 15, self.view );
    	LuaEffectManager:stop_view_effect( 15, self.view );
	end
end

local function formatTime( seconds )
	if seconds < 0 then
		return
	end

	local hour  = seconds/3600;
	local minute= (seconds%3600)/60;
	local second= (seconds%3600)%60;

	local timer_str = string.format("%d时%02d分%02d秒",hour,minute,second);
	return timer_str;
end

function TransformPreviewWin:time_tick()
	if not self.timer then
		return
	end
	-- 请求刷新倒计时时间
	local isNeedUpdateTime = TransformModel:GetTransformIsNeedUpdateState()
	if isNeedUpdateTime then
		TransformCC:request_transform_countdown()
	end

	if self.times >= 1 then
		self.times = self.times - 1;
		local time_str = formatTime( self.times );
		if self.timer_label then
			self.timer_label:setText( "#c0edc09" .. time_str )
		end
	else
		self.timer:stop();
		self.timer = nil;

		self.timer_label:setText( "#c0edc0900时00分00秒" )
		self.get_transform_btn.view:setCurState( CLICK_STATE_UP );
	end
end

function TransformPreviewWin:updateTime(times)
	if times >= 0 then
		if not self.timer then
			self.timer = timer()
		end

		local function time_tick()
			self:time_tick()
		end
		self.times = times
		self.timer:start(1, time_tick)
	end
end

function TransformPreviewWin:syncTimeWithRightTopPanel()
	local win = UIManager:find_window("right_top_panel")
	if win then
		local times = win:getTransformTime()
		if times then
			if times < 0 then
				times = 0
			end
			if not self.timer then
				self.timer = timer()
			end
			local function tick_func()
				self:time_tick()
			end
			self.times = times
			self.timer:start(1, tick_func)
		end
	end
end