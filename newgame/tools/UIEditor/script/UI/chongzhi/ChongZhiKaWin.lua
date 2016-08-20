-----------------------------------------------
-----------------------------------------------
super_class.ChongZhiKaWin(Window)
--local temp_page_info = 
-----------------------------------------------
function ChongZhiKaWin:__init( window_name, window_info, arg )
	--local base_panel = ChongZhiPage( nil, "", 0, 0, 520, 320 + 15)
	local scroll = Scroll:create( nil, 0, 50 + 15, 520, 255, 1, TYPE_HORIZONTAL )
	scroll:setScrollCreatFunction( ChongZhiKaWin.scroll_create_fun )
	--local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	scroll:setScrollCreateInfo( arg )
	--scroll:refresh()
	local button = TextButton:create( nil, 0, 0, 115, 38, arg.button_text, UIResourcePath.FileLocate.chongZhi .. "button_s.png" )
	local button_size = button:getSize()
	button.page_index = arg.page_index
	self.page_index = arg.page_index
	self.temp_page_info = nil
	print("arg.page_index", arg.page_index)
	button:setPosition( 520 - button_size.width - 10, 10 )
	button:setTouchClickFun( arg.chong_zhi_button_fun )
	self.scroll = scroll
	self.button = button
	self.view:addChild( scroll.view )
	self.view:addChild( button.view )
	--return base_panel
end
-----------------------------------------------
function ChongZhiKaWin:scroll_create_fun(index, arg)
	-- local chong_zhi_win = UIManager:find_visible_window("chong_zhi_win")
	-- if chong_zhi_win == nil then
	-- 	returna
	-- end
	local scroll_info = { width = 520 , height = 255 }
	-----------------------------------------------
	local item_gap_y = 10
	local item_list = {}
	local title_info_font_size = 18
	local notic_info_font_size = 14
	local title_info = Label:create( nil, 0, 0, arg.notic_one_info, title_info_font_size )
	table.insert( item_list, title_info.view )
	-----------------------------------------------
	local notic_info_one = Label:create( nil, 0, 0, arg.notic_two_info, notic_info_font_size )
	table.insert( item_list, notic_info_one.view )
	-----------------------------------------------
	local gapX = 140
	local gapY = 40
	local curPosX = 0
	local beginPosY = 0
	local curPosY = beginPosY
	local select_item_info = {}
	local percent_rate = 10
	local first_select_num = 0
	local no_two_lab = nil
	for i = 1, #arg.select_info do
		local temp_sprite = TextCheckBox:create( nil, curPosX, curPosY, 22, 22, {UIResourcePath.FileLocate.common .. "common_toggle_n.png", UIResourcePath.FileLocate.common .. "common_toggle_s.png"}, 
			string.format( "%d%s",arg.select_info[i],LangGameString[747], 5 )) -- [747]="元"
		curPosX = curPosX + gapX
		if i == 1 then
			first_select_num = arg.select_info[i]
		end
		if i % 4 == 0 and i < #arg.select_info then
			curPosX = 0
			curPosY = curPosY - gapY
		end
		local function button_fun()
			local cur_num = arg.select_info[i]
			local lab_info = arg.notic_three_info
			if no_two_lab ~= nil then
				no_two_lab:setText( string.format( lab_info, cur_num, cur_num * percent_rate ) )
			end
		end
		temp_sprite:setTouchBeganFun(button_fun)
		select_item_info[i] = temp_sprite
	end
	local radio_button = CCRadioButtonGroup:buttonGroupWithFile( 0, 0, scroll_info.width, beginPosY - curPosY + 22, "", 600, 600 )
	table.insert( item_list, radio_button )
	for i = 1, #select_item_info do
		local item_pos = select_item_info[i].view:getPositionS()
		local item_size = select_item_info[i].view:getSize()
		select_item_info[i].view:setPosition( item_pos.x, item_pos.y + beginPosY - curPosY )
		radio_button:addGroup(select_item_info[i].view)
	end
	-----------------------------------------------
	local notic_info_two = Label:create( nil, 0, 0, string.format( arg.notic_three_info, first_select_num, first_select_num * percent_rate ), 16 )
	no_two_lab = notic_info_two
	table.insert( item_list, notic_info_two.view )
	-----------------------------------------------
	local notic_info_three = Dialog:create( nil, 0, 0, scroll_info.width, notic_info_font_size * 2, ADD_LIST_DIR_UP, 500)
	notic_info_three:setText(arg.notic_four_info)
	--local notic_info_three = Label:create( nil, 0, 0, arg.notic_four_info, 16 )
	table.insert( item_list, notic_info_three.view )
	-- local notic_info_two = Dialog:create( nil, 0, 0, scroll_info.width, notic_info_font_size * 2, ADD_LIST_DIR_UP, 500 )
	-- table.insert( item_list, notic_info_two.view )
	-- notic_info_two:setText( arg.notic_three_info )
	-----------------------------------------------
	local edit_box_info = { width = 430, height = 32 }
	local user_info_panel = BasePanel:create( nil, 0, 0, scroll_info.width, edit_box_info.height, "" )
	table.insert( item_list, user_info_panel.view )
	local user_info_label = Label:create( nil, 0, 0, LangGameString[748], notic_info_font_size ) -- [748]="卡号："
	local user_info_label_size = user_info_label.view:getSize()
	user_info_label:setPosition( 0, (edit_box_info.height - user_info_label_size.height) * 0.5 )
	local user_info_edit_bg = Image:create( nil, 50, 0, edit_box_info.width, edit_box_info.height, UIPIC_GRID_nine_grid_bg3, 600, 600 )
	local user_info_edit_box = EditBox:create( nil, 50, 0, edit_box_info.width, edit_box_info.height, 30 )
	user_info_panel.view:addChild( user_info_label.view )
	user_info_panel.view:addChild( user_info_edit_bg.view )
	user_info_panel.view:addChild( user_info_edit_box.view )
	-----------------------------------------------
	local psw_info_panel = BasePanel:create( nil, 0, 0, scroll_info.width, edit_box_info.height , "" )
	table.insert( item_list, psw_info_panel.view )
	local psw_info_label = Label:create( nil, 0, 0, LangGameString[749], notic_info_font_size) -- [749]="密码："
	local psw_info_label_size = psw_info_label.view:getSize()
	psw_info_label:setPosition( 0, (edit_box_info.height - psw_info_label_size.height) * 0.5 )
	local psw_info_edit_bg = Image:create( nil, 50, 0, edit_box_info.width, edit_box_info.height, UIPIC_GRID_nine_grid_bg3, 600, 600 )
	local psw_info_edit_box = EditBox:create( nil, 50, 0, edit_box_info.width, edit_box_info.height, 30 )
	psw_info_edit_box.view:setEditBoxType(EDITBOX_TYPE_PASSWORD)
	psw_info_panel.view:addChild( psw_info_label.view )
	psw_info_panel.view:addChild( psw_info_edit_bg.view )
	psw_info_panel.view:addChild( psw_info_edit_box.view )
	-----------------------------------------------
	local sumHeight = 0
	local item_size_list = {}
	for i = 1, #item_list do
		local temp_size = item_list[i]:getSize()
		item_size_list[i] = temp_size.height
		sumHeight = sumHeight + temp_size.height
	end
	local base_panel = ChongZhiPage( nil, "", 0, 0, scroll_info.width, sumHeight + item_gap_y * #item_list )
	-----------------------------------------------
	curPosY = sumHeight + item_gap_y * #item_list
	for i = 1, #item_list do
		curPosY = curPosY - item_size_list[i] - item_gap_y
		item_list[i]:setPosition( 0, curPosY )
		base_panel.view:addChild( item_list[i] )
	end
	-----------------------------------------------
	base_panel.radio_button = radio_button
	base_panel.user_info_edit_box = user_info_edit_box
	base_panel.psw_info_edit_box = psw_info_edit_box
	-----------------------------------------------
	self.temp_page_info = base_panel
	print("self",self)
	print("self.temp_page_info",self.temp_page_info)
	-- chong_zhi_scroll_page[arg.index] = base_panel 
	return base_panel
end
-----------------------------------------------
function ChongZhiKaWin:destroy()
	print("run chong zhi ka destroy")
	Window.destroy(self)
	if self.scroll.temp_page_info ~= nil then
		self.scroll.temp_page_info:destroy()
	end
end
-----------------------------------------------
function ChongZhiKaWin:get_page_info()
	print("self.temp_page_info",self.scroll.temp_page_info)
	if self.scroll.temp_page_info ~= nil then
		return { self.scroll.temp_page_info.radio_button:getCurSelect() + 1,
				 self.scroll.temp_page_info.user_info_edit_box.view:getText(),
				 self.scroll.temp_page_info.psw_info_edit_box.view:getText() 
				}
	else
		return { -1, "", "" }
	end
end
-----------------------------------------------
function ChongZhiKaWin:clear_insert_info()
	if self.scroll ~= nil and self.scroll.temp_page_info ~= nil then
		self.scroll.temp_page_info.radio_button:selectItem(0)
		self.scroll.temp_page_info.user_info_edit_box.view:setText("")
		self.scroll.temp_page_info.psw_info_edit_box.view:setText("")
	end
end
