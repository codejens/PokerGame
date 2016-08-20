--七日狂欢页面  为了以前的七日狂欢页面以后能重用 这里新建一个
--created by xiehande on 2015.1.15
--AwardWin
super_class.sevenDayAwardNew()
----------------------
local _cur_panel = nil
local _refresh_time = 10
----------------------

--窗体大小
local window_width =880
local window_height = 520

--tab标签页集合
local tab_day = {
	tab_day_1,
	tab_day_2,
	tab_day_3,
	tab_day_4,
	tab_day_5,
	tab_day_6,
	tab_day_7,
}

--title 资源
local title_day = {
	txt_day_1,
	txt_day_2,
	txt_day_3,
	txt_day_4,
	txt_day_5,
	txt_day_6,
	txt_day_7,

}

--解释文字
local explian_day = {
	explain_day_1,
	explain_day_2,
	explain_day_3,
	explain_day_4,
	explain_day_5,
	explain_day_6,
	explain_day_7,
}

-- 标题信息
local title_info = {
	text1 = {
			[1] = UILH_AWARD.day1, [2] = UILH_AWARD.day2, [3] = UILH_AWARD.day3, 
			[4] = UILH_AWARD.day4, [5] = UILH_AWARD.day5, [6] = UILH_AWARD.day6, [7] = UILH_AWARD.day7,
			},

	text2 = {
			[1] = UILH_AWARD.login_day1, [2] = UILH_AWARD.login_day2, [3] = UILH_AWARD.login_day3, 
			[4] = UILH_AWARD.login_day4, [5] = UILH_AWARD.login_day5, [6] = UILH_AWARD.login_day6, 
			[7] = UILH_AWARD.login_day7,
		}
}

local function reset_remain_time()
	_cur_panel.remain_time:setString("")
end

-- function sevenDayAwardNew:create(  )
--     return sevenDayAwardNew( "sevenDayAwardNew", "", false, window_width,window_height )
-- end

----------------------
local function create_panel(self, width, height)

	self.view = ZBasePanel.new("", window_width, window_height).view

	local title_text_info = { 309, 396}	--开服提示信息

	-------底图颜色
	local hole_bg = CCBasePanel:panelWithFile( 0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500 )
	self.view:addChild( hole_bg )

	local panel_bg = CCBasePanel:panelWithFile( 13, 14, 853, window_height - 26, "", 500, 500 )
    hole_bg:addChild(panel_bg)

    -- 活动背景
    local act_bg = CCBasePanel:panelWithFile(232, 35, 276*2, 456, nil, 500, 500)
    panel_bg:addChild(act_bg)


    --右边的背景
    local panel_right = CCBasePanel:panelWithFile( 0, -33, 620, 490, UILH_COMMON.bottom_bg, 500, 500 )
    act_bg:addChild(panel_right)


	-----文字图片标题
	local left_bg = CCZXImage:imageWithFile(69, 365, -1, -1, UILH_OPENSER.title_bg)
	local right_bg = CCZXImage:imageWithFile(312.5, 365, -1, -1, UILH_OPENSER.title_bg)
	right_bg:setFlipX(true)
	act_bg:addChild(left_bg)
	act_bg:addChild(right_bg)
	local left_dl = CCZXImage:imageWithFile(7, 214, -1, -1, UILH_AWARD.denglong)
	local right_dl = CCZXImage:imageWithFile(510, 214, -1, -1, UILH_AWARD.denglong)
	right_dl:setFlipX(true)
	act_bg:addChild(left_dl)
	act_bg:addChild(right_dl)

	self.top_title_text = CCZXImage:imageWithFile( title_text_info[1], title_text_info[2], -1, -1, UILH_AWARD.day1)
	self.top_title_text:setAnchorPoint(0.5, 0)
	act_bg:addChild( self.top_title_text )
	self.top_title_text2 = CCZXImage:imageWithFile( title_text_info[1], title_text_info[2]-46, -1, -1, UILH_AWARD.login_day1)
	self.top_title_text2:setAnchorPoint(0.5, 0)
	self.top_title_text2:setScale(1.2)
	act_bg:addChild( self.top_title_text2 )

	-- 天数数字
	local days_panel = CCBasePanel:panelWithFile(50, 215, 462, 49, nil, 500, 500)
	act_bg:addChild(days_panel)
	------奖品列表
	local award_panel = CCBasePanel:panelWithFile(40, 84, 560, 100, nil, 500, 500)
	act_bg:addChild(award_panel)

	self.slot_item_info = {}
	local slot_w, slot_h = 64, 64
	for i = 1, 4 do
		self.slot_item_info[i] = SlotItem( slot_w, slot_h )
		self.slot_item_info[i]:set_icon_bg_texture( UILH_COMMON.slot_bg, -7, -7, 79, 79 )
		self.slot_item_info[i]:set_color_frame(nil, -2, -2, 68, 68)
		award_panel:addChild( self.slot_item_info[i].view )
		self.slot_item_info[i]:setPosition( ( i - 1 ) * 95+90, 16 )
		local spr = LuaEffectManager:play_view_effect( 11007, 0, 0, self.slot_item_info[i].view ,true);
		spr:setPosition(CCPointMake(34, 34))
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


--中间的奖励item(比较特殊 拿出来单独写)
	    self.slot_item_center  = nil
		self.slot_item_center = SlotItem( 70, 70 )
		self.slot_item_center:set_icon_bg_texture( UILH_COMMON.slot_bg, -10, -10, 90, 90 )
		self.slot_item_center:set_color_frame(nil, -2, -2, 74, 74)
		act_bg:addChild( self.slot_item_center.view )
		self.slot_item_center:setPosition( 270,250 )
		local spr_center = LuaEffectManager:play_view_effect( 11007, 0, 0, self.slot_item_center.view ,true);
		spr_center:setPosition(CCPointMake(34, 34))

		--点击事件
		local function center_item_tip_fun(...)
			--固定配置为第五个
			local temp_item_index = 5
			local award_index = sevenDayAwardModel:get_cur_select_index()
			local award_item_info = sevenDayAwardConfig:get_index_award(award_index)

			local a, b, arg = ...
			local click_pos = Utils:Split(arg, ":")

			local world_pos = self.slot_item_center.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
			if award_item_info[temp_item_index].id ~= 0 then

				TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, award_item_info[temp_item_index].id )
			else
				local temp_data = { item_id = award_item_info[temp_item_index].type, item_count = award_item_info[temp_item_index].count }

				TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
			end
		end


		self.slot_item_center:set_click_event(center_item_tip_fun)



	------领取按钮
	-- 领奖按钮
	local function btn_event( eventType )
		if eventType == TOUCH_CLICK then
			Instruction:handleUIComponentClick(instruct_comps.AWARD_WIN_SEVEN_GET)
			sevenDayAwardModel:get_item_info()
			self:update_btn()
		end
		return true
	end

	self.get_btn = MUtils:create_btn(act_bg,
		UILH_NORMAL.special_btn, 
		UILH_NORMAL.special_btn, 
		btn_event,
		230, 0, -1, -1);
	self.get_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
	self.get_btn_lab = MUtils:create_zximg(self.get_btn, 
		UILH_BENEFIT.lingqujiangli, 
		30, 15, 
		-1, -1);
	self.get_btn_lab:setAnchorPoint(0.5, 0.5)
	self.get_btn_lab:setPosition(81, 27)
	self:update_btn()

end
----------------------


function sevenDayAwardNew:__init(window_name, texture_name )

	create_panel( self, 500, 500 )
    


    _cur_panel = self

        --创建左边
    self:create_left_buttons(self.view)


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


	--创建右边上方显示
	-- self:create_up_panel(self.view,400,300,200,200,UILH_COMMON.bottom_bg)

end

function sevenDayAwardNew:create_left_buttons(panel_bg)
	-- self.slot_focus_array = {}
    --tab 背景
    local tab_bg = CCZXImage:imageWithFile(13, 16, 230, 490, UILH_COMMON.bottom_bg, 500, 500 );
    panel_bg:addChild( tab_bg)

    -- tab按钮
    local but_beg_x = 20                     --按钮起始x坐标
    local but_int_y = 56                     --按钮x坐标间隔
    local but_beg_y = but_int_y * 8 + 28     --按钮起始y坐标

    local temp_button_item = {}
    local button_image_info = {
     { image = UILH_AWARD.kaifu_award1, index = 1 },
     { image = UILH_AWARD.kaifu_award2, index = 2},
     { image = UILH_AWARD.kaifu_award3, index = 3 },
     { image = UILH_AWARD.kaifu_award4, index = 4},
     { image = UILH_AWARD.kaifu_award5, index = 5 },
     { image = UILH_AWARD.kaifu_award6, index = 6 },
     { image = UILH_AWARD.kaifu_award7, index = 7 },
    }

    local btn_height = 80
    local btn_width = 205
    local btn_gap_y = 0
    for i = 1, #button_image_info do
    	--按钮触发
        local function btn_fun()
            local temp_index = button_image_info[i].index
			sevenDayAwardModel:set_cur_select_index(temp_index)
			_cur_panel:update_fun(3)
			self:update_btn()
        end

    local temp  =ZButton:create(nil, {UILH_JISHOU.left_btn_nor, UILH_JISHOU.left_btn_sel} , btn_fun, 0, 0, btn_width, btn_height,nil,500,500)
    -- self.slot_focus_array[i] = MUtils:create_zximg(temp.view,UILH_COMMON.slot_focus,0,0,btn_width+2,btn_height+2)
    local text_img = MUtils:create_zximg(temp.view,button_image_info[i].image,btn_width/2,btn_height/2,-1,-1)
    text_img:setAnchorPoint(0.5, 0.5)
    table.insert( temp_button_item, temp )
    end

    local radiobutton = RadioButton:create( nil, 5, 0, btn_width, btn_height * #temp_button_item + btn_gap_y * #temp_button_item, 1)
    for i = 1, #temp_button_item do
        radiobutton:addItem( temp_button_item[i], btn_gap_y, 1 )
    end
    self.day_radio_button = radiobutton

    local function create_scroll_item_func(  )
        return self.day_radio_button.view
    end

    self.tab_scroll = MUtils:create_one_scroll( 17, 22, 215, 476, 1, "", TYPE_HORIZONTAL, create_scroll_item_func )

    local lump_pox_x = 205
    --设置滚动条
    self.tab_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 11, 30, 208 )
    self.tab_scroll:setScrollLumpPos( lump_pox_x )
    local arrow_up = CCZXImage:imageWithFile(lump_pox_x , 465, 11, -1 , UILH_COMMON.scrollbar_up)
    local arrow_down = CCZXImage:imageWithFile(lump_pox_x, 1, 11, -1, UILH_COMMON.scrollbar_down)

    self.tab_scroll:addChild(arrow_up)
    self.tab_scroll:addChild(arrow_down)
    panel_bg:addChild( self.tab_scroll )
end

-----进度箭头日期坐标
local function update_process(self)
	local temp_info = sevenDayAwardModel:get_can_get_index()
	-- self.process:setProgressValue( temp_info, 7 )
	-- local begin_x = 326
	-- local gap = 395 / 7
	-- self.cur_time_pos:setPosition( begin_x + temp_info * gap, 425 - 175)
	-- self.radio_btn:selectItem( sevenDayAwardModel:get_cur_select_index() - 1 )
	self.day_radio_button:selectItem( sevenDayAwardModel:get_cur_select_index() - 1 )
end
----------------------
local function update_award_info(self, index)

	self.top_title_text:setTexture(title_info.text1[index])
	self.top_title_text2:setTexture(title_info.text2[index])
	local temp_info = sevenDayAwardConfig:get_index_award(index)
	for i = 1, 4 do
		if temp_info[i].id ~= 0 then
			--print("update_award_info(index,temp_info[i].id)",index,temp_info[i].id)
			self.slot_item_info[i]:set_icon_ex( temp_info[i].id )
			self.slot_item_info[i]:set_color_frame( temp_info[i].id, -2, -2, 68, 68 )
			self.slot_item_info[i]:set_item_count( temp_info[i].count )
			self.slot_item_info[i]:set_gem_level( temp_info[i].id )
		else
			if temp_info[i].type == 3 then 
				self.slot_item_info[i]:set_icon_texture( "icon/money/3.pd" )
			elseif temp_info[i].type == 1 then
				self.slot_item_info[i]:set_icon_texture( "icon/money/1.pd" )
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

	self:clear_animation()
    --更新中间特殊item
    local special_index = 5
    -- if temp_info[special_index] then    --如果存在item的话
    	if index == 2 then
    		local mount_file = "frame/mount/101"
			local action = {0,4,4,0.2};
    		self.slot_item_center.view:setIsVisible(false)
    		self.show_avatar = MUtils:create_animation(520,250,mount_file,action );
    		self.show_avatar:setScale(0.9)
    		self.view:addChild(self.show_avatar, 0)
    	elseif index == 7 then
    		local mount_file = "scene/monster/1331"
			local action = {0,0,9,0.2};
			self.show_avatar = MUtils:create_animation(520,250,mount_file,action );
			-- self.show_avatar:setScale(0.9)
    		self.slot_item_center.view:setIsVisible(false)
    		self.view:addChild(self.show_avatar, 0)
    	else
			self.slot_item_center.view:setIsVisible(true)
		 	self.slot_item_center:set_icon_ex( temp_info[special_index].id )
			self.slot_item_center:set_color_frame( temp_info[special_index].id, -2, -2, 74, 74 )
			self.slot_item_center:set_item_count( temp_info[special_index].count )
			self.slot_item_center:set_gem_level( temp_info[special_index].id )
    	end
    -- end
	
end

local function update_remain_time(self)
	local temp_info = sevenDayAwardModel:get_remain_time()
	local cur_time = os.time()
	-- self.remain_time:setText( temp_info - os.time() )
end

local function update_login_day(self)
	local temp_info = sevenDayAwardModel:get_sum_login_day()
	local log_info = "#cffff00" .. temp_info
	-- self.log_time.view:setText( log_info )
end

--更新方法
function  sevenDayAwardNew:update( update_type )
	if update_type == "all" then
        self:update_fun(1)
	end
end
function sevenDayAwardNew:update_fun(index)
	if index == 1 then
		local cur_select = sevenDayAwardModel:get_can_get_index()
		--刚进入时跳到用当前可领取的奖励
		self.day_radio_button:selectItem( cur_select )
		sevenDayAwardModel:set_cur_select_index(cur_select + 1)
		self:update_btn( )
		-- local cur_select = sevenDayAwardModel:get_can_get_index()
		update_award_info( self, cur_select + 1)
		update_remain_time( self )
		-- update_login_day( self )
	elseif index == 2 then
		update_process( self )
		self:update_btn()
	elseif index == 3 then
		local cur_select = sevenDayAwardModel:get_cur_select_index()
		update_award_info( self, cur_select )
	elseif index == 4 then
		update_remain_time( self )
	elseif index == 5 then
		-- update_login_day( self )
	end
end

function sevenDayAwardNew:update_btn( can_get )
	local index = sevenDayAwardModel:get_cur_select_index()
	local state = sevenDayAwardModel:get_award_state(index)
	if state == 1 then
		self.get_btn:setCurState(CLICK_STATE_UP)
		self.get_btn_lab:setTexture(UILH_BENEFIT.lingqujiangli)
		self.get_btn_lab:setSize(78,24)
	elseif state == 2 then
		self.get_btn:setCurState(CLICK_STATE_DISABLE)
		self.get_btn_lab:setTexture(UILH_BENEFIT.yilingqu)
		self.get_btn_lab:setSize(60,24)
	elseif state == 0 then
		self.get_btn:setCurState(CLICK_STATE_DISABLE)
		self.get_btn_lab:setTexture(UILH_BENEFIT.lingqujiangli)
		self.get_btn_lab:setSize(78,24)
	end
end

----------------------
function sevenDayAwardNew:active(show)
	if show == true then
		if sevenDayAwardModel:get_reinit() == true then
			sevenDayAwardModel:reinit_panel()	
		end	
		self:update_fun(1)
		--update_remain_time(self)
		sevenDayAwardModel:set_first_show(true)
		for i = 1, #self.slot_item_info do
			self.slot_item_info[i].view:removeChildByTag(11007,true);
			local spr = LuaEffectManager:play_view_effect( 11007, 0, 0, self.slot_item_info[i].view, true);
			spr:setPosition(CCPointMake(34, 34))
		end
		self.view:setTimer(_refresh_time)
	else
		self.view:setTimer(0)
	end
end

function sevenDayAwardNew:clear_animation()
	if self.show_avatar ~= nil then
		self.show_avatar:removeFromParentAndCleanup(true)
		self.show_avatar = nil
		--parent:removeChild(mounts_avatar,true);
	end
end

----------------------
function sevenDayAwardNew:destroy()
	
end
