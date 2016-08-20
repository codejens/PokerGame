---------HJH
---------2013-5-24  
--------- modified by xiehande 2015-1-6
---------投資返利界面
super_class.TZFLWin(NormalStyleWindow)

local window_width =880
local window_height = 555
local money_img = {[1] = UILH_TZFL.item_info_one, [3] = UILH_TZFL.item_info_seven, [4] = UILH_TZFL.item_info_four, 
		[6] = UILH_TZFL.item_info_five, [9] = UILH_TZFL.item_info_six}
local function create_tzfl_panel(self, width, height)

	self.item_grid_bg = ZImage:create( nil, UILH_COMMON.normal_bg_v2, 10, 12, window_width, window_height ,nil,500,500)
	--第二层背景
	local panel_bg = ZImage:create( nil, UILH_COMMON.bottom_bg, 15, 17, window_width-30, window_height-80 ,nil,500,500)	
	self.item_grid_bg:addChild(panel_bg.view)
	local item_size = 68
	local vertical_num = 5
	local horizontal_num = 2
	local gap_x =16
	local gap_y = 14+2-9
	local begin_pos_x = 45

	self.notic = ZImage:create( nil, UILH_TZFL.notic_info, 0, 0, -1, -1 )
	local notic_size = self.notic:getSize()
	self.notic:setPosition( (width - notic_size.width) * 0.5 , height - 120 )
	local notic_pos = self.notic:getPosition()

	local begin_pos_y = height - 335
	self.reward_item_info = {}
	local reward_item_time_notic_size = 15
	local reward_item_notic_size = 12
	local cur_pos_x = begin_pos_x
	local button_height = 36
	local tzfl_item_info = TZFLConfig:get_tzfl_info()
	require "config/StaticAttriType"


	for i = 1, #tzfl_item_info.awards do
		--整个内容框
		self.reward_item_info[i] = ZBasePanel:create( nil, "" , cur_pos_x, begin_pos_y, 150, 200)
		local panel_size = self.reward_item_info[i]:getSize()
        
        --物品背景
		self.reward_item_info[i].bg = ZImage:create( nil, UILH_COMMON.slot_bg, 32, 60, -1, -1)
        --上面的图片
        local lh_introduce_up = ZImage:create( nil, "ui2/role/lh_introduce_up.png",10, panel_size.height - reward_item_time_notic_size - 5, 130, -1)
        self.reward_item_info[i]:addChild(lh_introduce_up)

        --下面闭合图标
        local lh_introduce_bttm = ZImage:create( nil, "ui2/role/lh_introduce_bttm.png", 10, panel_size.height - reward_item_time_notic_size - 143, 130, -1)
        self.reward_item_info[i]:addChild(lh_introduce_bttm)


		-----------------------------------------------
		self.reward_item_info[i].time_notic = ZLabel:create( nil, string.format(Lang.tzfl_info.time_notic_info, tzfl_item_info.awards[i].days), 0, 0, reward_item_time_notic_size )
		local time_notic_size = self.reward_item_info[i].time_notic:getSize()
		self.reward_item_info[i].time_notic:setPosition( (panel_size.width - time_notic_size.width) * 0.5, panel_size.height - reward_item_time_notic_size - 30 )

		local time_notic_pos = self.reward_item_info[i].time_notic:getPosition()
		-----------------------------------------------
		self.reward_item_info[i].grid_item = SlotItem( item_size, item_size )
		-- self.reward_item_info[i].grid_item:set_icon_bg_texture( UIPIC_ITEMSLOT, 1, 1, 68,68 )
		self.reward_item_info[i].grid_item.view:setPosition( (panel_size.width - item_size) * 0.5-1 , time_notic_pos.y - item_size - 20)
		-----------------------------------------------
		local item_grid_pos = self.reward_item_info[i].grid_item.view:getPositionS()
		if tzfl_item_info.awards[i].money ~= nil then
			if tzfl_item_info.awards[i].money.type == 3 then
				self.reward_item_info[i].grid_item:set_icon_texture(UILH_OTHER.yuanbao)
			elseif tzfl_item_info.awards[i].money.type == 1 then
				self.reward_item_info[i].grid_item:set_icon_texture("icon/money/1.pd")
			else
				self.reward_item_info[i].grid_item:set_icon_texture(UILH_OTHER.tongbi)
			end
			-- local name_info = string.format( "%d%s", tzfl_item_info.awards[i].money.count, _static_money_type[tzfl_item_info.awards[i].money.type])
			-- self.reward_item_info[i].item_notic = Label:create( nil, 0, 0, name_info, reward_item_notic_size )
			-- local item_notic_size = self.reward_item_info[i].item_notic:getSize()
			-- self.reward_item_info[i].item_notic:setPosition( (panel_size.width - item_notic_size.width) * 0.5, item_grid_pos.y - item_notic_size.height )
		else
			self.reward_item_info[i].grid_item:set_icon(tzfl_item_info.awards[i].item.id)
			self.reward_item_info[i].grid_item:set_item_count(tzfl_item_info.awards[i].item.count)
			-- self.reward_item_info[i].item_notic = Label:create( nil, 0, 0, ItemConfig:get_item_name_by_item_id(tzfl_item_info.awards[i].item.id), reward_item_notic_size )
			-- local item_notic_size = self.reward_item_info[i].item_notic:getSize()
			-- self.reward_item_info[i].item_notic:setPosition( (panel_size.width - item_notic_size.width) * 0.5, item_grid_pos.y - item_notic_size.height )
			local function touch_click_function(...)
				local index = i
				local a, b, arg = ...
				local click_pos = Utils:Split(arg, ":")
				local world_pos = self.reward_item_info[index].grid_item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
				local tzfl_item_info = TZFLConfig:get_tzfl_info()
				TipsModel:show_shop_tip(world_pos.x, world_pos.y, tzfl_item_info.awards[index].item.id)		
			end
			self.reward_item_info[i].grid_item:set_click_event(touch_click_function)
		end

		-----------------------------------------------

		-- self.reward_item_info[i].item_notic = ZImage:create( nil, tzfl_item_info.awards[i].image, 0, 0, -1, -1 )
		if money_img[i] then
			self.reward_item_info[i].item_notic = ZImage:create( self.reward_item_info[i].view,money_img[i], 0, 0, -1, -1, 1 )
			local item_notic_size = self.reward_item_info[i].item_notic:getSize()
			self.reward_item_info[i].item_notic:setPosition( (panel_size.width - item_notic_size.width) * 0.5, (panel_size.height - item_notic_size.height) * 0.5)
		end

		-----------------------------------------------
		--modified
		--self.reward_item_info[i].button = ZButton:create( nil, UIResourcePath.FileLocate.common .. "button2.png", 0, 0, -1, -1 )
		--领取按钮
		self.reward_item_info[i].button = ZTextButton:create( nil, Lang.benefit.welfare[8], {UILH_COMMON.button4, UILH_COMMON.button4_dis}, nil, 0,0, -1, -1, nil, 600, 600 ) 
        self.reward_item_info[i].button.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button4_dis)

		local button_info = self.reward_item_info[i].button:getSize()
		self.reward_item_info[i].button:setPosition( (panel_size.width - button_info.width) * 0.5, 3 )
		-----------------------------------------------
		self.reward_item_info[i].view:addChild( self.reward_item_info[i].bg.view )
		self.reward_item_info[i].view:addChild( self.reward_item_info[i].time_notic.view )
		self.reward_item_info[i].view:addChild( self.reward_item_info[i].grid_item.view )
		-- self.reward_item_info[i].view:addChild( self.reward_item_info[i].item_notic.view )
		self.reward_item_info[i].view:addChild( self.reward_item_info[i].button.view )
		-----------------------------------------------
		TZFLModel:data_update_index_icon_button_info(i, nil)
		self.reward_item_info[i].button.view:setCurState(CLICK_STATE_DISABLE)

		local function get_award()
			local index = i
			if self.reward_item_info[i].button.view:getCurState() ~= CLICK_STATE_DISABLE then
				MiscCC:send_tzfl_get_reward(index)
			end
		end
		self.reward_item_info[i].button:setTouchClickFun(get_award)
		cur_pos_x = cur_pos_x + gap_x + panel_size.width
		if i == vertical_num then
			cur_pos_x = begin_pos_x
			begin_pos_y = begin_pos_y - gap_y - panel_size.height
		end
	end
	-----------------------------------------------
	local get_it_right_now_width = 131
	local get_it_right_now_height = 42
	self.get_it_right_now = ZImageButton:create( nil, {UILH_NORMAL.special_btn, UILH_NORMAL.special_btn } ,
		UILH_TZFL.lijiqianggou, TZFLModel.get_it_right_now_function, 370, 36, -1, -1)	
	--self.get_it_right_now:setTouchClickFun()
	-- self.exit_btn = ZButton:create( nil, {UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png"}, 
	-- 	TZFLModel.exit_function, 0, 0, -1, -1 )
	-- --self.exit_btn:setTouchClickFun()
	-- local exit_size = self.exit_btn:getSize()
	-- self.exit_btn:setPosition( width - exit_size.width, height - exit_size.height )
	-----------------------------------------------
	-- self.view:addChild( self.title_bg.view )
	-- self.view:addChild( self.title.view )
	self.view:addChild( self.item_grid_bg.view )
	-- self.view:addChild(red_bg.view)
	self.view:addChild( self.notic.view )
	
	for i = 1, #self.reward_item_info do
		self.view:addChild( self.reward_item_info[i].view )
	end
	self.view:addChild( self.get_it_right_now.view )
	--self.view:addChild( self.exit_btn.view )
end
-----------------------------------------------
-----------------------------------------------
function TZFLWin:__init( window_name,texture,grid,width,height,title_text)--texture_name, pos_x, pos_y, width, height)
	create_tzfl_panel(self, width, height)
end
-----------------------------------------------
-----------------------------------------------
-- function TZFLWin:active(show)
-- 	if show == true then
-- 		if TZFLModel:get_reinit() == true then
-- 			self:reinit_panel()
-- 		end
-- 	end
-- end
