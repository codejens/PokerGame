----JiShouShangJiaItem.lua
----HJH
----2013-7-25
----寄售物品
super_class.JiShouShangJiaItem(Window)
local time_select_panel = nil
local slot_item = nil
-----------------------------------------
-----------------------------------------
local function create_panel(self, width, height)
	-- 添加一层背景图层
	-- local bg = ZBasePanel:create( nil, UI_JISHOUWIN_026, 0, 60+10, width, height-70, 600, 600 )
	-- self:addChild( bg.view )
	-- 背景
	local bg = ZImage:create(self.view, UILH_COMMON.normal_bg_v2, 10, 15, 415, 503, 0, 500, 500)
	local frame_bg = ZImage:create(self.view, UILH_COMMON.bottom_bg, 25, 270, 383, 220, 0, 500, 500)
	local frame_bg2 = ZImage:create(self.view, UILH_COMMON.bottom_bg, 25, 90, 383, 180, 0, 500, 500)
	-- frame_bg2.view:setOpacity(230)
	local notice_bg = ZImage:create(self.view, UILH_NORMAL.title_bg3, 40, 460, -1, -1, 0, 500, 500)
	local notic 	= ZImage:create(notice_bg.view, UILH_JISHOU.notice2, 60, 10, -1, -1)
	-- local frame_bg1 = ZImage:create(self.view, UILH_JISHOU.frame_bg1, 130, 483, -1, -1)
	-- local lace1 = ZImage:create(self.view, UILH_JISHOU.frame_lace, 18, 260, -1, -1)
	-- local lace2 = ZImage:create(self.view, UILH_JISHOU.frame_lace, 363, 260, -1, -1)
	-- lace2.view:setFlipX(true)
	-------------------------
	-- local dis_y = 50
	-- local notic = ZLabel:create( nil, Lang.jiShouShangJia.page_one.notic, 0, 0 )
	-- self.view:addChild( notic.view )
	-- local notic_size = notic:getSize()
	-- notic:setPosition( 100, 465 )
	-------------------------
	local slot_item_size = 64, 64
	self.slot_item = SlotItem( slot_item_size, slot_item_size )
	self.slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -10, -10, 82, 82 )
	self:addChild( self.slot_item.view )
	self.slot_item.view:setPosition( 184, 376 )
	local function slot_click_fun(slot_obj,eventType, arg, msgid)
		local click_pos = Utils:Split(arg, ":")
		local world_pos = self.slot_item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		local item_info = JiShouShangJiaModel:get_page_one_item_info()
		if item_info ~= nil then
			TipsModel:show_tip( world_pos.x, world_pos.y, item_info, nil, nil, nil, nil, nil, nil)
		end
	end
	self.slot_item:set_click_event(slot_click_fun)
	local function slot_double_click_fun()
		local item_info = JiShouShangJiaModel:get_page_one_item_info()
		if item_info ~= nil then
			BagModel:hide_item_color_cover( item_info.series )
			JiShouShangJiaModel:clear_page_one_item_info()
		end
		self.slot_item:set_icon_ex(nil)
		self.slot_item:set_item_count(0)
		--self.slot_item:set_lock(false)
	end
	self.slot_item:set_double_click_event(slot_double_click_fun)
	local function slot_drag_in_fun(item)
		local item_info = JiShouShangJiaModel:get_page_one_item_info()
		if item_info ~= nil then
			BagModel:hide_item_color_cover( item_info.series )
			JiShouShangJiaModel:clear_page_one_item_info()
		end
		print("item.obj_data.item_id,item.obj_data.series",item.obj_data.item_id,item.obj_data.series)
		self.slot_item:set_icon_ex( item.obj_data.item_id )
		self.slot_item:set_color_frame( item.obj_data.item_id )
		self.slot_item:set_item_count( item.obj_data.count )
		JiShouShangJiaModel:set_page_one_item_info( item.obj_data )
		BagModel:set_item_color_cover(item.obj_data.series)
	end
	self.slot_item:set_drag_in_event( slot_drag_in_fun )

	-- 添加一条线
	-- local tmp_line = CCZXImage:imageWithFile( 20, 350, 275, 2, UI_JISHOUWIN_028 )
	-- self:addChild( tmp_line )

	-------------------------
	self.sell_price_edit_box = MUtils:create_num_edit( 158, 322, 215, 40, 99999999, JiShouShangJiaModel.set_page_one_sell_all_price, UILH_COMMON.bg_02 )
	self.sell_price_edit_box.label:setIsVisible(false)
	self.sell_price_edit_box.is_active_zero = true
	self:addChild( self.sell_price_edit_box )
	
	local sell_price_edit_box_size = self.sell_price_edit_box.view:getSize()
	local sell_price_edit_box_pos = self.sell_price_edit_box.view:getPositionS()

	--------寄售总价
	local sell_price_label = ZLabel:create( nil, Lang.jiShouShangJia.page_one.lab_one, 2, 0 )
	self:addChild( sell_price_label.view )
	local sell_price_label_size = sell_price_label:getSize()
	sell_price_label:setPosition( 64, 335 )

	-------------------------
	self.sell_price_num = ZLabel:create( nil, "0", 185, 335 )
	self:addChild(self.sell_price_num.view)
	------货币选择
	self.radio_button = ZRadioButtonGroup:create( nil, 150, 265 , 180, 46, 0 )
	self:addChild( self.radio_button.view )
	local _radio_info = { image = { UILH_COMMON.fy_bg, UILH_COMMON.fy_select }, 
						 text = { Lang.normal[4], Lang.normal[1] }  } -- [4]="元宝" -- [1]="银两"
	for i = 1, #_radio_info.text do
		local temp =  TextCheckBox:create( nil, 0, 0, -1, -1, _radio_info.image, _radio_info.text[i], 0, 16 )
		if temp and temp.text then
			temp.text:setPosition(33,8);
		end
		self.radio_button:addItem( temp, 40 )
		local function btn_select()
			local index = 0
			if _radio_info.text[i] == Lang.normal[4] then -- [4]="元宝"
				index = 3
			else
				index = 1
			end
			JiShouShangJiaModel:set_page_one_radio_button_select_fun(index)
		end
		temp:setTouchClickFun(btn_select)
	end
	-----保管费
	local baoguan_test_bg =	ZImage:create(self, UILH_COMMON.bg_02, 158, 215, 160, 40, 0, 500, 500)
	local bao_guan_fei_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_one.lab_two , 67, 228)
	self:addChild( bao_guan_fei_lab.view )
	local cost = ZLabel:create( self, Lang.jiShouShangJia.tips6 , 325, 228)
	self.bao_guan_fei_num = Label:create( nil, 185, 228 , 0 )
	self:addChild( self.bao_guan_fei_num.view )

	-- -----------------------
	-- 提示
	-- local tips = ZDialog:create(nil, LangGameString[2373], 24, 115, 290, 45, 15, 30) -- [2373]="#cfff000注意：寄售所得的元宝将自动转化为礼券"
	-- tips.view:setAnchorPoint( 0, 1 )
	-- self:addChild(tips.view)

	-------------------------
	-- 寄售时间数字框
	local sell_time_bg = ZBasePanel:create( nil, UILH_COMMON.bg_02, 158, 160, 160, 40, 600, 600 )
	self:addChild( sell_time_bg.view )
	local function time_bg_fun()
		if time_select_panel ~= nil then
			local result = time_select_panel:getIsVisible()
			time_select_panel:setIsVisible(not result)
		end
	end
	sell_time_bg:setTouchClickFun(time_bg_fun)
	local sell_time_bg_size = sell_time_bg.view:getSize()
	local sell_time_bg_pos = sell_time_bg.view:getPositionS()
	
	-- 寄售时间文字标签
	local sell_time_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_one.lab_three, 0, 0 )
	self:addChild( sell_time_lab.view )
	sell_time_lab:setPosition( 64, 174 )

	local sell_time_show_btn = ZImage:create( nil, UILH_JISHOU.arrow, 275, 159, -1, -1 )
	self:addChild( sell_time_show_btn.view )
	local sell_time_lab_size = sell_time_lab:getSize()
	
	self.cur_select_time_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_one.time1, 181, 171 ) -- [1293]="12小时"
	self:addChild(self.cur_select_time_lab.view)

	------------------------
	self.sell_time_select = ZRadioButtonGroup:create( nil, 158, 87, 160, 75, 1, UILH_COMMON.bg_10, 600, 600)
	-- self.sell_time_select.view:setOpacity(175)
	time_select_panel = self.sell_time_select.view
	self:addChild(self.sell_time_select.view)
	self.sell_time_select.view:setIsVisible(false)
	local time_info = { Lang.jiShouShangJia.page_one.time1, Lang.jiShouShangJia.page_one.time2, Lang.jiShouShangJia.page_one.time3 } -- [1]="12小时" -- [2]="24小时" -- [3]="48小时"
	for i = 1, #time_info do
		-- local temp = ZTextButton:create( nil, time_info[i], UIResourcePath.FileLocate.normal .. "empyt_tex.png", nil, 0, 0, 88 + 30, 25, nil, 600, 600 )
		local temp = ZButton:create(nil, "", nil, 0, 0, 160, 25)
		local lab = ZLabel:create(temp.view, time_info[i], 25, 8)
		if #time_info ~= i then
			local line = ZImage:create(temp.view, UILH_COMMON.split_line, 10, 0, 140, 2)
		end
		self.sell_time_select:addItem( temp, 0, 1 )
		local function time_btn_fun()
			local temp_index = i
			local time_info = { 12, 24, 48 }
			JiShouShangJiaModel:set_page_one_time(time_info[temp_index])
			time_select_panel:setIsVisible(false)
		end
		temp:setTouchClickFun(time_btn_fun)
	end

	------------------------
	--xiehande UI_JISHOUWIN_019 ->UIPIC_COMMOM_001
	self.reset_btn = ZTextButton:create( nil, Lang.jiShou.reset, -- "重置"
										{ UIPIC_COMMOM_001, UIPIC_COMMOM_001 },
										 nil, 55, 35, -1, -1, nil, 600, 600 )
	self:addChild( self.reset_btn.view )
	self.reset_btn:setTouchClickFun(JiShouShangJiaModel.page_one_reset_btn_fun)
	------------------------
	--xiehande 通用按钮  UI_JISHOUWIN_018 ->UIPIC_COMMOM_001
	self.ji_shou_btn = ZTextButton:create( nil, Lang.jiShou.sell, -- "寄售"
										{ UIPIC_COMMOM_001, UIPIC_COMMOM_001 },
										 nil, 276, 35, -1, -1, nil, 600, 600 )
	self:addChild( self.ji_shou_btn.view )
	self.ji_shou_btn:setTouchClickFun(JiShouShangJiaModel.page_one_ji_shou_btn_fun)
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaItem:__init(window_name, texture_name, is_grid, width, height)
	---------------------------
	create_panel( self, width, height )
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaItem:get_sell_price_num()
	if self.sell_price_edit_box ~= nil then
		return self.sell_price_edit_box:get_num()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaItem:set_sell_price_num(num)
	if self.sell_price_num ~= nil then
		self.sell_price_num:setText(tostring(num))
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaItem:set_bao_guan_fei_num(num)
	if self.bao_guan_fei_num ~= nil then
		self.bao_guan_fei_num:setText(tostring(num))
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaItem:set_time_info(index)
	--local temp_info = { "12小时", "24小时", "48小时" }
	if self.cur_select_time_lab ~= nil then
		self.cur_select_time_lab:setText( string.format(Lang.jiShouShangJia.time_sel,index) ) -- [1298]="%d小时"
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaItem:update_item_info(info)
	if self.slot_item ~= nil then
		self.slot_item:set_icon_ex(info.item_id)
		self.slot_item:set_color_frame( info.item_id )
		self.slot_item:set_item_count(info.count )
		--self.slot_item:set_lock(is_lock)
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaItem:clear_info()
	self.slot_item:set_icon_ex(nil)
	self.slot_item:set_item_count(0)
	--self.slot_item:set_lock(false)
	self.sell_price_num:setText("0")
	self.radio_button:selectItem(0)
	self.bao_guan_fei_num:setText(0)
	self.cur_select_time_lab:setText(string.format(Lang.jiShouShangJia.time_sel, 12)) -- "12小时"
end
-----------------------------------------
-----------------------------------------
