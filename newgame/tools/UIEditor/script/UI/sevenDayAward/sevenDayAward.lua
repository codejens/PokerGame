----sevenDayAward.lua
----HJH
----2013-9-15
------
super_class.sevenDayAward(Window)
----------------------
local _cur_panel = nil
local _refresh_time = 10
----------------------
local function reset_remain_time()
	_cur_panel.remain_time:setString("")
end
----------------------
local function create_panel(self, width, height)
	-------底图颜色
	local hole_bg = CCBasePanel:panelWithFile( 33, 20, 852, 532, UIPIC_GRID_nine_grid_bg3, 500, 500 )
	self:addChild( hole_bg )

	local panel_bg = CCBasePanel:panelWithFile( 10, 11, 832, 510, "", 500, 500 )
    hole_bg:addChild(panel_bg)

    self.view:addChild(CCZXImage:imageWithFile(165, 530, -1, -1, UI_SclbWin_001), 1000)
    self.view:addChild(CCZXImage:imageWithFile(357, 555, -1, -1, UIResourcePath.FileLocate.sevenDayAward .. "win_title.png"), 1000)

	-------妹子(appstore审核版暂时改掉 )
	-- local is_ckeck_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
	-- if is_ckeck_version then
	-- 	panel_bg:addChild( CCZXImage:imageWithFile( 10, 50, -1, -1, 'nopack/body/41.png', 500, 500 ) )
	-- else
		local girl_img = Image:create( nil, -23, 0, -1, -1, UIResourcePath.FileLocate.sevenDayAward.."beauty.png")
		panel_bg:addChild( girl_img.view )
	-- end
	
    -- 活动背景
    local act_bg = CCBasePanel:panelWithFile(255, 35, 276*2, 456, nil, 500, 500)
    panel_bg:addChild(act_bg)
    -- 左边
    local act_left_bg = CCZXImage:imageWithFile(0, 0, 276, 456, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(3).png", 500, 500)
    act_bg:addChild(act_left_bg)
    -- 右边
    local act_right_bg = CCZXImage:imageWithFile(275.5, 0, 276, 456, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(3).png", 500, 500)
    act_right_bg:setFlipX(true)
    act_bg:addChild(act_right_bg)


	-----文字图片标题
	local title_bg = CCZXImage:imageWithFile(54, 407, 441, 49, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(9).png")
	act_bg:addChild(title_bg)
	local top_title_text = CCZXImage:imageWithFile( 54, 10, -1, -1, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(10).png" )
	title_bg:addChild( top_title_text )

	-- 活动剩余时间
	local left_time_text = CCZXImage:imageWithFile(87, 335, -1, -1, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(8).png")
	act_bg:addChild(left_time_text)

	self.remain_time = TimerLabel:create_label( left_time_text, 134, 37, 16, 0, "#c00ff00", reset_remain_time)
	
	self.log_time = Label:create( nil, 121, 4, "#cffff000", 16 ) -- [1896]="你已累计登录0天"
	left_time_text:addChild( self.log_time.view )

	-- 时间进度条
	local day_progress_panel = CCBasePanel:panelWithFile(36, 262, 483, 31, nil, 500, 500)
	act_bg:addChild(day_progress_panel)

	-- local day_progress_bg = CCBasePanel:panelWithFile(0, 0, 483, 31, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(5).png", 500, 500)
	-- day_progress_panel:addChild(day_progress_bg, 1)

	-- local day_progress = CCBasePanel:panelWithFile(0, 0, 67, 31, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(6).png", 500, 500)
	-- day_progress_panel:addChild(day_progress, 2)
	self.process = ZProgress:create(day_progress_panel, 
		1, 7, 0, 0, 483, 31, false, 
		UIResourcePath.FileLocate.sevenDayAward .. "7d_award(5).png", 
		UIResourcePath.FileLocate.sevenDayAward .. "7d_award(6).png")

	local day_progress_split = CCZXImage:imageWithFile(0, 1, 483, 29, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(4).png")
	day_progress_panel:addChild(day_progress_split, 3)

	-- 天数数字
	local days_panel = CCBasePanel:panelWithFile(50, 215, 462, 49, nil, 500, 500)
	act_bg:addChild(days_panel)
	self.day_radio_button = ZRadioButtonGroup:create( days_panel, 0, 0, 462, 49 )
	local tmp_offset = {0, 0, 1, 2, 3-2, 3-3, 3-3}
	for i=1,7 do
		local function day_btn_fun()
			local temp_index = i
			sevenDayAwardModel:set_cur_select_index(temp_index)
			_cur_panel:update_fun(3)
			self:update_btn()
		end 

		local day_btn = ZButton:create( nil, {
				UIResourcePath.FileLocate.sevenDayAward .. "7d_award(2).png", 
				UIResourcePath.FileLocate.sevenDayAward .. "7d_award(2).png"
			}, day_btn_fun)
		self.day_radio_button:addItem(day_btn, 23+tmp_offset[i])
	end
	local days_num_img = CCZXImage:imageWithFile(16, 11, 426, 20, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(7).png")
	days_panel:addChild(days_num_img, 2)
	
	----领取进度箭头
	-- self.cur_time_pos = Image:create( nil, 0, 0, -1, -1, UIResourcePath.FileLocate.sevenDayAward .. "pos.png" )
	-- panel_bg:addChild( self.cur_time_pos.view )
	-- self.cur_time_pos.view:setAnchorPoint( 0.5, 0 )
	
	------奖品列表
	local award_panel = CCBasePanel:panelWithFile(54, 84, 450, 100, nil, 500, 500)
	act_bg:addChild(award_panel)

	self.slot_item_info = {}
	local slot_w, slot_h = 64, 64
	for i = 1, 5 do
		self.slot_item_info[i] = SlotItem( slot_w, slot_h )
		self.slot_item_info[i]:set_icon_bg_texture( UIPIC_ITEMSLOT, -4, -4, 72, 72 )
		self.slot_item_info[i]:set_color_frame(nil, -2, -2, 68, 68)
		award_panel:addChild( self.slot_item_info[i].view )
		self.slot_item_info[i]:setPosition( 28 + ( i - 1 ) * 80, 16 )
		local spr = LuaEffectManager:play_view_effect( 11007, 0, 0, self.slot_item_info[i].icon ,true);
		spr:setPosition(CCPointMake(24, 24))
		local function item_tips_fun(...)
			local temp_item_index = i
			local award_index = sevenDayAwardModel:get_cur_select_index()
			local award_item_info = sevenDayAwardConfig:get_index_award(award_index)

			local a, b, arg = ...
			local click_pos = Utils:Split(arg, ":")

			local world_pos = self.slot_item_info[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
			if award_item_info[temp_item_index].id ~= 0 then

				TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, award_item_info[temp_item_index].id )
			else
				local temp_data = { item_id = award_item_info[temp_item_index].type, item_count = award_item_info[temp_item_index].count }

				TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
			end
		end
		self.slot_item_info[i]:set_click_event(item_tips_fun)
	end

	------领取按钮
	-- 领奖按钮
	local function btn_event( eventType )
		if eventType == TOUCH_CLICK then
			sevenDayAwardModel:get_item_info()
			self:update_btn()
		end
		return true
	end
	self.get_btn = MUtils:create_btn(act_bg,
		UIResourcePath.FileLocate.common .. "btn_other.png", 
		UIResourcePath.FileLocate.common .. "btn_other.png", 
		btn_event,
		160, 11, 220, 57);
	self.get_btn:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "btn_other_d.png")
	self.get_btn_lab = MUtils:create_zximg(self.get_btn, 
		UIResourcePath.FileLocate.sevenDayAward .. "lingqu.png", 
		30, 15, 
		102, 29);
	self.get_btn_lab:setAnchorPoint(0.5, 0.5)
	self.get_btn_lab:setPosition(220/2, 57/2)
	self:update_btn()

	-- self.get_btn = ImageButton:create( nil, 160, 11, 220, 57, UIResourcePath.FileLocate.common .. "btn_other.png", UIResourcePath.FileLocate.sevenDayAward .. "lingqu.png" )
	-- self.get_btn:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "btn_other_d.png")
	-- act_bg:addChild( self.get_btn.view )
	-- self.get_btn:setTouchClickFun( sevenDayAwardModel.get_item_info )

	local temp_bg = CCBasePanel:panelWithFile(231, 1, 600, 36, UIResourcePath.FileLocate.sevenDayAward .. "13.png", 500, 500)
	panel_bg:addChild(temp_bg)

	local temp_txt = UILabel:create_lable_2("#cffffff累计登陆天数满足条件可以获取丰厚礼包!最高可获取价值", 0, 10, 14)
	temp_bg:addChild(temp_txt)
	local size = temp_txt:getSize()

	------提示领取888QB
	local temp_img = CCZXImage:imageWithFile(size.width+2, 5, -1, -1, UIResourcePath.FileLocate.sevenDayAward .. "7d_award(1).png" )
	temp_bg:addChild( temp_img )
	local size2 = temp_img:getSize()

	local temp_txt2 = UILabel:create_lable_2("#cffffff的礼包", size.width+2+size2.width+2, 10, 14)
	temp_bg:addChild(temp_txt2)
	
end
----------------------


function sevenDayAward:__init(window_name, texture_name )

	create_panel( self, 500, 500 )

    _cur_panel = self

   	local function panel_function(eventType, arg, msgId, selfItem)
		if eventType == nil or arg == nil or msgId == nil or selfItem == nil then
			return
		end
		if eventType == TIMER then
			sevenDayAwardModel:sum_time_request()
		end
		return true
	end
	self.view:setTimer(_refresh_time)
	self.view:registerScriptHandler(panel_function)
end
-----进度箭头日期坐标
local function update_process(self)
	local temp_info = sevenDayAwardModel:get_can_get_index()
	self.process:setProgressValue( temp_info, 7 )
	local begin_x = 326
	local gap = 395 / 7
	-- self.cur_time_pos:setPosition( begin_x + temp_info * gap, 425 - 175)
	-- self.radio_btn:selectItem( sevenDayAwardModel:get_cur_select_index() - 1 )
	self.day_radio_button:selectItem( sevenDayAwardModel:get_cur_select_index() - 1 )
end
----------------------
local function update_award_info(self, index)
	local temp_info = sevenDayAwardConfig:get_index_award(index)
	for i = 1, #temp_info do
		if temp_info[i].id ~= 0 then
			--print("update_award_info(index,temp_info[i].id)",index,temp_info[i].id)
			self.slot_item_info[i]:set_icon_ex( temp_info[i].id )
			self.slot_item_info[i]:set_color_frame( temp_info[i].id, -2, -2, 68, 68 )
			self.slot_item_info[i]:set_item_count( temp_info[i].count )
			self.slot_item_info[i]:set_gem_level( temp_info[i].id )
		else
			if temp_info[i].type == 3 then 
				self.slot_item_info[i]:set_icon_texture( UIResourcePath.FileLocate.normal .. "yb_32.png" )
			elseif temp_info[i].type == 1 then
				self.slot_item_info[i]:set_icon_texture( UIResourcePath.FileLocate.normal .. "yl_32.png" )
			elseif temp_info[i].type == 2 then
				self.slot_item_info[i]:set_icon_texture( "icon/money/2.pd" )
			elseif temp_info[i].type == 0 then
				self.slot_item_info[i]:set_icon_texture( "icon/money/0.pd" )
			end
			if i == 1 then
				self.slot_item_info[i]:set_item_count( 0 )
			else
				self.slot_item_info[i]:set_item_count( temp_info[i].count )
			end
		end
	end
end

local function update_remain_time(self)
	local temp_info = sevenDayAwardModel:get_remain_time()
	local cur_time = os.time()
	self.remain_time:setText( temp_info - os.time() )
end

local function update_login_day(self)
	local temp_info = sevenDayAwardModel:get_sum_login_day()
	local log_info = "#cffff00" .. temp_info
	self.log_time.view:setText( log_info )
end

function sevenDayAward:update_fun(index)
	if index == 1 then
		update_process( self )
		self:update_btn()
		local cur_select = sevenDayAwardModel:get_cur_select_index()
		update_award_info( self, cur_select )
		update_remain_time( self )
		update_login_day( self )
	elseif index == 2 then
		update_process( self )
		self:update_btn()
	elseif index == 3 then
		local cur_select = sevenDayAwardModel:get_cur_select_index()
		update_award_info( self, cur_select )
	elseif index == 4 then
		update_remain_time( self )
	elseif index == 5 then
		update_login_day( self )
	end
end

function sevenDayAward:update_btn(  )
	local index = sevenDayAwardModel:get_cur_select_index()
	local state = sevenDayAwardModel:get_award_state(index)
	if state == 1 then
		self.get_btn:setCurState(CLICK_STATE_UP)
		self.get_btn_lab:setTexture(UIResourcePath.FileLocate.sevenDayAward .. "lingqu.png")
		self.get_btn_lab:setSize(102, 29)
	elseif state == 2 then
		self.get_btn:setCurState(CLICK_STATE_DISABLE)
		self.get_btn_lab:setTexture(UIResourcePath.FileLocate.normal .. "text_4.png")
		self.get_btn_lab:setSize(77, 29)
	elseif state == 0 then
		self.get_btn:setCurState(CLICK_STATE_DISABLE)
		self.get_btn_lab:setTexture(UIResourcePath.FileLocate.sevenDayAward .. "lingqu.png")
		self.get_btn_lab:setSize(102, 29)
	end
end

----------------------
function sevenDayAward:active(show)
	if show == true then
		if sevenDayAwardModel:get_reinit() == true then
			sevenDayAwardModel:reinit_panel()	
		end	
		self:update_fun(1)
		--update_remain_time(self)
		sevenDayAwardModel:set_first_show(true)
		for i = 1, #self.slot_item_info do
			self.slot_item_info[i].icon:removeChildByTag(11007,true);
			local spr = LuaEffectManager:play_view_effect( 11007, 0, 0, self.slot_item_info[i].icon, true);
			spr:setPosition(CCPointMake(24, 24))
		end
		self.view:setTimer(_refresh_time)
	else
		self.view:setTimer(0)
	end
end
----------------------
function sevenDayAward:destroy()
	self.remain_time:destroy()
	Window.destroy(self)
end
