----JiShouShangJiaMoney.lua
----HJH
----2013-7-25
----寄售货币
local time_select_panel = nil
local label_two_item = nil
super_class.JiShouShangJiaMoney(Window)
-----------------------------------------
-----------------------------------------
local function create_panel( self, width, height )
	-- 添加一层背景图层
	-- local bg = ZBasePanel:create( nil, UI_JISHOUWIN_026, 0, 60+10, width, height-70, 600, 600 )
	-- self:addChild( bg.view )
	-- 背景
	local bg = ZImage:create(self.view, UILH_COMMON.normal_bg_v2, 10, 15, 415, 503, 0, 500, 500)
	local frame_bg = ZImage:create(self.view, UILH_COMMON.bottom_bg, 25, 355, 383, 135, 0, 500, 500)
	local frame_bg2 = ZImage:create(self.view, UILH_COMMON.bottom_bg, 25, 90, 383, 260, 0, 500, 500)
	local notice_bg = ZImage:create(self.view, UILH_NORMAL.title_bg3, 40, 460, -1, -1, 0, 500, 500)
	local notic 	= ZImage:create(notice_bg.view, UILH_JISHOU.notice1, 70, 10, -1, -1)
	-- frame_bg2.view:setOpacity(230)
	-- local frame_bg1 = ZImage:create(self.view, UILH_JISHOU.frame_bg1, 130, 483, -1, -1)
	-- local lace1 = ZImage:create(self.view, UILH_JISHOU.frame_lace, 21, 320, -1, -1)
	-- local lace2 = ZImage:create(self.view, UILH_JISHOU.frame_lace, 363, 320, -1, -1)
	-- lace2.view:setFlipX(true)
	------------------------------
	-- local dis_y = 50
	-- local notic = ZLabel:create( nil, Lang.jiShouShangJia.page_two.notic, 0, 0, nil, ALIGN_CENTER )
	-- self:addChild( notic.view )
	-- local notic_size = notic:getSize()
	-- notic:setPosition( width / 2 + 10, 465 )
	----寄售数目
	-- local sell_price_edit_box_bg = Image:create( nil, 100, height - 156, 158, 30, UIResourcePath.FileLocate.common .. "nine_grid_bg.png", 600, 600 )
	-- self:addChild( sell_price_edit_box_bg.view )
	self.sell_price_edit_box = MUtils:create_num_edit( 158, 415, 215, 40, 99999999, JiShouShangJiaModel.set_page_two_sell_ji_shou_sell_num, UILH_COMMON.bg_02 )
	self.sell_price_edit_box.label:setIsVisible(false)
	self.sell_price_edit_box.is_active_zero = true
	--EditBox:create( nil, 110, height - 156, 158 - 20, 30, 600 )
	self:addChild( self.sell_price_edit_box )

	local sell_price_edit_box_size = self.sell_price_edit_box.view:getSize()
	local sell_price_edit_box_pos = self.sell_price_edit_box.view:getPositionS()

	local sell_price_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_two.lab_one, 0, 0 )
	self:addChild( sell_price_lab.view )
	local sell_price_lab_size = sell_price_lab:getSize()
	sell_price_lab:setPosition( 64, 425 )

	------------------------------
	self.sell_price_num = ZLabel:create( nil, "0", 170, 425 )
	self:addChild(self.sell_price_num)
	------------------------------
	self.radio_button = ZRadioButtonGroup:create( nil, 165, 355 , 180, 46, 0 )
	self:addChild( self.radio_button.view )
	local _radio_info = { image = { UILH_COMMON.fy_bg, UILH_COMMON.fy_select }, 
						 text = { Lang.normal[4], Lang.normal[1] }  } -- [414]="元宝" -- [412]="银两"
	for i = 1, #_radio_info.text do
		local temp =  TextCheckBox:create( nil, 0, 0, -1, -1, _radio_info.image, _radio_info.text[i], 10, 16 )
		self.radio_button:addItem( temp, 40 )
		if temp and temp.text then
			temp.text:setPosition(33,8);
		end
		local function btn_select()
			local index = 0
			if _radio_info.text[i] == Lang.normal[4] then -- "元宝"
				index = 3 
				label_two_item:setText( Lang.jiShouShangJia.tips6 )
			else
				index = 1
				label_two_item:setText( Lang.jiShouShangJia.tips7 )
			end
			JiShouShangJiaModel:set_page_two_radio_button_select_fun(index)
		end
		temp:setTouchClickFun(btn_select)
	end
	------------------------------
	-- local all_price_edit_box_bg = Image:create( nil, 100, height - 262, 158, 30, UIResourcePath.FileLocate.common .. "nine_grid_bg.png", 600, 600 )
	-- self:addChild( all_price_edit_box_bg.view )
	self.all_price_edit_box = MUtils:create_num_edit( 158, 290, 160, 40, 99999999, JiShouShangJiaModel.set_page_two_sell_all_price, UILH_COMMON.bg_02 )
	self.all_price_edit_box.label:setIsVisible(false)
	self.all_price_edit_box.is_active_zero = true
	--EditBox:create( nil, 110, height - 262, 158, 30, 600 )
	self:addChild( self.all_price_edit_box )

	local all_price_edit_box_size = self.all_price_edit_box.view:getSize()
	local all_price_edit_box_pos = self.all_price_edit_box.view:getPositionS()
	local all_price_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_two.lab_two_yb, 0, 0 )
	self:addChild( all_price_lab.view )
	all_price_lab:setPosition( 67, 303 )
	local cost1 = ZLabel:create( self, Lang.jiShouShangJia.tips6 , 325, 300)

	label_two_item = cost1
	local all_price_lab_size = all_price_lab:getSize()
	
	self.all_price_num = ZLabel:create( nil, "0", 170, 303 )
	self:addChild(self.all_price_num)

	-------保管费
	local baoguan_test_bg =	ZImage:create(self, UILH_COMMON.bg_02, 158, 235, 160, 40, 0, 500, 500)
	local bao_guan_fei_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_one.lab_two , 67, 245)
	self:addChild( bao_guan_fei_lab.view )
	self.bao_guan_fei_num = Label:create( nil, 170, 247, 0 )
	self:addChild( self.bao_guan_fei_num.view )
	local cost2 = ZLabel:create( self, Lang.jiShouShangJia.tips6 , 325, 247)
	-- -----------------------
	-- 提示
	-- local tips = ZDialog:create(nil, LangGameString[2373], 24, 115, 290, 45, 15, 30) -- [2373]="#cfff000注意：寄售所得的元宝将自动转化为礼券"
	-- tips.view:setAnchorPoint( 0, 1 )
	-- self:addChild(tips.view)

	-----------------------------
	local sell_time_bg = ZBasePanel:create( nil, UILH_COMMON.bg_02, 158, 175, 160, 40, 600, 600 )
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
	----------------------------
	local sell_time_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_one.lab_three, 0, 0 )
	self:addChild( sell_time_lab.view )
	sell_time_lab:setPosition( 64, 190 )

	local sell_time_show_btn = ZImage:create( nil, UILH_JISHOU.arrow, 275, 174, -1, -1 )
	self:addChild( sell_time_show_btn.view )
	local sell_time_lab_size = sell_time_lab:getSize()
	
	self.cur_select_time_lab = ZLabel:create( nil, Lang.jiShouShangJia.page_one.time1, 181, 186 ) -- [1293]="12小时"
	self:addChild(self.cur_select_time_lab.view)
	------下拉区域
	self.sell_time_select = ZRadioButtonGroup:create( nil, 158, 97, 160, 75, 1, UILH_COMMON.bg_10, 600, 600)
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
			JiShouShangJiaModel:set_page_two_time(time_info[temp_index])
			time_select_panel:setIsVisible(false)
		end
		temp:setTouchClickFun(time_btn_fun)
	end
	------------------------
	--xiehande UI_JISHOUWIN_019->UIPIC_COMMOM_001
	self.reset_btn = ZTextButton:create( nil, Lang.jiShou.reset, -- "重置"
										{ UILH_COMMON.lh_button2, UILH_COMMON.lh_button2 },
										 nil, 55, 35, -1, -1, nil, 600, 600 )
	self:addChild( self.reset_btn.view )
	self.reset_btn:setTouchClickFun(JiShouShangJiaModel.page_two_reset_btn_fun)
	------------------------
	--xiehande UI_JISHOUWIN_018
	self.ji_shou_btn = ZTextButton:create( nil, Lang.jiShou.sell, -- "寄售"
										{ UILH_COMMON.lh_button2, UILH_COMMON.lh_button2 },
										 nil, 276, 35, -1, -1, nil, 600, 600 )
	self:addChild( self.ji_shou_btn.view )
	self.ji_shou_btn:setTouchClickFun(JiShouShangJiaModel.page_two_ji_shou_btn_fun)
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:__init(window_name, texture_name, is_grid, width, height)
	create_panel(self, width, height)
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:get_sell_num()
	if self.sell_price_edit_box ~= nil then
		return self.sell_price_edit_box:get_num()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:set_sell_num(num)
	if self.sell_price_num  ~= nil then
		self.sell_price_num:setText(tostring(num))
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:get_sell_price_num()
	if self.all_price_edit_box ~= nil then
		return self.all_price_edit_box:get_num()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:set_sell_price_num(num)
	if self.all_price_num  ~= nil then
		self.all_price_num:setText(tostring(num))
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:set_bao_guan_fei_num(num)
	if self.bao_guan_fei_num ~= nil then
		self.bao_guan_fei_num:setText(tostring(num))
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:set_time_info(index)
	--local temp_info = { "12小时", "24小时", "48小时" }
	if self.cur_select_time_lab ~= nil then
		self.cur_select_time_lab:setText( string.format(Lang.jiShouShangJia.time_sel,index) ) -- [1298]="%d小时"
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaMoney:clear_info()
	self.sell_price_num:setText(0)
	self.all_price_num:setText(0)
	self.radio_button:selectItem(0)
	self.bao_guan_fei_num:setText(0)
	self.cur_select_time_lab:setText( string.format(Lang.jiShouShangJia.time_sel,12) ) -- [1298]="%d小时"
	label_two_item.view:setText( Lang.jiShouShangJia.tips6 )
end
