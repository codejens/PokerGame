--在线奖励
--created by chj on 2015.1.15
--AwardWin
super_class.onlineAwardPage()
----------------------
local _cur_panel = nil
local _refresh_time = 10
----------------------

--窗体大小
local window_width =880
local window_height = 520

-- add in tjxs
local item_w = 100
local item_h = 200
local item_ix = 110
local item_align = 55

local minute_words = { UILH_AWARD.minute_1, UILH_AWARD.minute_10, UILH_AWARD.minute_20, UILH_AWARD.minute_30, 
						UILH_AWARD.minute_40, UILH_AWARD.minute_50, UILH_AWARD.minute_60 }
local item_config = { 48222, 48222, 48222, 48222, 48222, 48222, 48222, 48222, 48222 }
local award_state = { LH_COLOR[6] .. "可领取", LH_COLOR[1] .. "已领取" }

-- function onlineAwardPage:create(  )
--     return onlineAwardPage( "onlineAwardPage", "", false, window_width,window_height )
-- end

----------------------
local function create_panel(self, width, height)

	-- for i = 1, 5 do
	-- 	self.slot_item_info[i] = SlotItem( slot_w, slot_h )
	-- 	self.slot_item_info[i]:set_icon_bg_texture( UIPIC_ITEMSLOT, -4, -4, 72, 72 )
	-- 	self.slot_item_info[i]:set_color_frame(nil, -2, -2, 68, 68)
	-- 	award_panel:addChild( self.slot_item_info[i].view )
	-- 	self.slot_item_info[i]:setPosition( 28 + ( i - 1 ) * 80, 16 )
	-- 	local spr = LuaEffectManager:play_view_effect( 11007, 0, 0, self.slot_item_info[i].icon ,true);
	-- 	spr:setPosition(CCPointMake(24, 24))
	-- 	local function item_tips_fun(...)
	-- 		local temp_item_index = i
	-- 		local award_index = sevenDayAwardModel:get_cur_select_index()
	-- 		local award_item_info = sevenDayAwardConfig:get_index_award(award_index)

	-- 		local a, b, arg = ...
	-- 		local click_pos = Utils:Split(arg, ":")

	-- 		local world_pos = self.slot_item_info[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
	-- 		if award_item_info[temp_item_index].id ~= 0 then

	-- 			TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, award_item_info[temp_item_index].id )
	-- 		else
	-- 			local temp_data = { item_id = award_item_info[temp_item_index].type, item_count = award_item_info[temp_item_index].count }

	-- 			TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
	-- 		end
	-- 	end
	-- 	self.slot_item_info[i]:set_click_event(item_tips_fun)
	-- end
	
end

----------------------
function onlineAwardPage:__init(window_name, texture_name )

	self.view = ZBasePanel.new("", window_width, window_height).view
	
	-- data
	self.award_index = nil
	self.count_time = nil 
	self.remain_num = nil

	-- 选中index
	self.select_index = nil

	self.award_config = OnlineAwardConfig:get_index_award()

	-------底图颜色
	local hole_bg = CCBasePanel:panelWithFile( 0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2, 500, 500 )
	self.view:addChild( hole_bg )
	local panel_bg = CCBasePanel:panelWithFile( 13, 14, 853, window_height - 26, UILH_COMMON.bottom_bg, 500, 500 )
    hole_bg:addChild( panel_bg )

    -- 领取奖励
    self.slot_item_info = {}
    -- 特效
    self.slot_item_effects = {}
    -- 领取状态
	self.award_states = {}
	-- 选中框
	self.select_frames = {}
    for i=1, #minute_words do
    	local a_item = self:create_one_award_item(i,item_align+item_ix*(i-1), 250)
    	self.view:addChild( a_item )
    end

    -- 宝箱图片
    ZImage:create(self.view, UILH_AWARD.baoxiang, 57, 38, -1, -1)

    -- 时间提示, 剩余时间
    -- ZLabel:create( self.view, "距离下次奖励：", 287, 121, 16 )
    ZImage:create(self.view, UILH_AWARD.next_time, 287, 121, -1, -1)
 --    local function reset_remain_time()
	-- 	self.remain_time:setString("")
	-- 	OnlineAwardModel:set_award_state(true)
	-- 	if self.select_index == self.award_index then
	-- 		self.btn_award:setCurState( CLICK_STATE_UP )
	-- 	end
	-- 	self.award_states[self.award_index]:setText( award_state[1] )
	-- 	self.award_states[self.award_index].view:setIsVisible(true)
	-- end
    -- self.remain_time =  TimerLabel:create_label( self.view, 425, 130, 16, 60, LH_COLOR[15], reset_remain_time )
    -- self.view:addChild( self.remain_time )
    -- self.remain_time:setText( 1000 )

    -- 提示
    -- ZLabel:create( self.view, "每天在线一定时间, 可以领取奖励", 287, 74, 16 )
    ZImage:create(self.view, UILH_AWARD.every_day_tip, 288, 78, -1, -1)

    -- 领取奖励按钮
    -- self.btn_award = ZImageButton:create( self.view, LH_COLOR[1] .. "领取奖励", UILH_NORMAL.special_btn, right_btn_role_fun, 670, 87, -1, -1 )
    local function get_award_func()
    	Instruction:handleUIComponentClick(instruct_comps.AWARD_WIN_LOGIN_GET)
    	OnlineAwardCC:request_get_award_oneday()
    end
    self.btn_award = ZImageButton:create(self.view, UILH_NORMAL.special_btn, 
                                        UILH_BENEFIT.lingqujiangli, get_award_func, 670, 87, -1, -1 )
    self.btn_award.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d) 

end

-- 创建一个item
function onlineAwardPage:create_one_award_item( index, posx, posy)
	-- basepanel
	local function selected_func( eventType )
    	if eventType == TOUCH_CLICK then
            self:select_one_award_item( index )
        end
        return true
    end
	local award_item = CCBasePanel:panelWithFile( posx, posy, item_w, item_h, "")
	award_item:registerScriptHandler( selected_func )

	local item_bg = CCBasePanel:panelWithFile( 0, item_h, item_h, item_w, UILH_NORMAL.title_bg4, 500, 500 )
	item_bg:setRotation(90)
	award_item:addChild(item_bg)

	-- 分钟
	-- ZLabel:create( award_item, minute_words[index], 16, 156, 16 )
	ZImage:create(award_item, minute_words[index], 16, 156, -1, -1)

	-- slotitem
	local slot_w, slot_h = 64, 64
	self.slot_item_info[index] = SlotItem( slot_w, slot_h )
	self.slot_item_info[index]:setPosition( 17, 65 )
	self.slot_item_info[index]:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, 83, 83 )
	self.slot_item_info[index]:set_color_frame(nil, -2, -2, slot_w, slot_h)
	self.slot_item_info[index]:set_icon( self.award_config[index].id )
	self.slot_item_info[index]:set_item_count(  self.award_config[index].count )
	self.slot_item_effects[index] = LuaEffectManager:play_view_effect( 11007, 0, 0, self.slot_item_info[index].view ,true);
	self.slot_item_effects[index]:setPosition(CCPointMake(34, 34))
	award_item:addChild( self.slot_item_info[index].view )

	local function item_tips_fun(...)
		local temp_item_index = index
		local award_item_info = self.award_config
		local a, b, arg = ...
		local click_pos = Utils:Split(arg, ":")
		local world_pos = self.slot_item_info[index].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		if award_item_info[temp_item_index].id ~= 0 then
			TipsModel:show_shop_tip( world_pos.x/2+50, world_pos.y+60, award_item_info[temp_item_index].id )
		else
			local temp_data = { item_id = award_item_info[temp_item_index].type, item_count = award_item_info[temp_item_index].count }
			TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
		end
	end
	self.slot_item_info[index]:set_click_event(item_tips_fun)

	-- 领取状态
	self.award_states[index] = ZLabel:create( award_item, award_state[1], 16, 16, 16 )
	-- 选中框
	self.select_frames[index] = ZImage:create( award_item, UILH_COMMON.slot_focus, 0, 0, item_w, item_h, 1, 500, 500 )
	self.select_frames[index].view:setIsVisible(false)

	return award_item
end

-- 选定一个奖励
function onlineAwardPage:select_one_award_item( index )
	self.select_index = index
	-- 选中框
	for i=1, #self.select_frames do
		self.select_frames[i].view:setIsVisible(false)
	end
	self.select_frames[index].view:setIsVisible(true)

	if index == self.award_index then
		if OnlineAwardModel:get_award_state( ) then 
			self.btn_award:setCurState( CLICK_STATE_UP )
		else
			self.btn_award:setCurState( CLICK_STATE_DISABLE )
		end
	else
		self.btn_award:setCurState( CLICK_STATE_DISABLE )
	end
end

-- ==================================
--         更新方法
-- ==================================
-- update_func
function onlineAwardPage:update_data()
	local award_index, count_time, remain_num = OnlineAwardModel:get_data()

	self.award_index = award_index
	self.count_time = count_time 
	self.remain_num = remain_num

	-- 设置领取状态
	for i=1, 7 do
		if i< award_index then
			self.award_states[i]:setText( award_state[2] )
			self.slot_item_effects[i]:setIsVisible(false)
		end
		if i == award_index then
			if OnlineAwardModel:get_award_state( ) then
				self.award_states[award_index]:setText( award_state[1] )
			else
				self.award_states[award_index].view:setIsVisible(false)
			end
			self.select_index = award_index
		end
		if i>award_index then
			self.award_states[i].view:setIsVisible(false)
		end
	end

	-- 倒计时
	-- print("-----self.count_time:", self.count_time)
	if self.remain_num > 0 then
		local function reset_remain_time()
			self.remain_time:setString("")
			OnlineAwardModel:set_award_state(true)
			-- if self.select_index == self.award_index then
			-- 	self.btn_award:setCurState( CLICK_STATE_UP )
			-- end
			-- -- if not self.award_states[self.award_index] then return end
			if self.award_states[self.award_index] then
				self.award_states[self.award_index]:setText( award_state[1] )
				self.award_states[self.award_index].view:setIsVisible(true)
				self:select_one_award_item( self.award_index )
			end
		end

		local win = UIManager:find_visible_window( "right_top_panel" )
		if self.count_time == 0 then
			-- self.remain_time:setText( 1 )
		else
			if self.remain_time then
				self.remain_time:destroy()
				self.remain_time = nil
			end
			self.remain_time =  TimerLabel:create_label( self.view, 425, 130, 16, 60, LH_COLOR[15], reset_remain_time )
			self.remain_time:setText( self.count_time )
		end
	end

	if not self.select_index then
		-- 默认选择1
		self:select_one_award_item(1)
	else
		self:select_one_award_item(self.select_index)
	end
end

-- update
function onlineAwardPage:update( update_type )
	if update_type == "all" then
        -- self:update_fun(1)
        self:update_data()

		
	end
end

----------------------
function onlineAwardPage:active(show)
	if show == true then

	else

	end
end
----------------------
function onlineAwardPage:destroy()
	if self.remain_time then
		self.remain_time:destroy()
		self.remain_time = nil
	end
	for i = 1, #minute_words do
		LuaEffectManager:stop_view_effect( 11007,self.slot_item_info[i].view )
	end
end
