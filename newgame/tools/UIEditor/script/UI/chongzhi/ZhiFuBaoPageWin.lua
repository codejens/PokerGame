-----------------------------------------------
-----------------------------------------------
super_class.ZhiFuBaoPageWin(Window)
local temp_page_info = nil
-----------------------------------------------
function ZhiFuBaoPageWin:__init( window_name, window_info, arg )
	--local base_panel = ChongZhiPage( nil, "", 0, 0, 520, 320+15 )
	local scroll = Scroll:create( nil, 0, 50 + 15, 520, 255, 1, TYPE_HORIZONTAL )
	scroll:setScrollCreatFunction( ZhiFuBaoPageWin.scroll_create_function )
	--scroll:refresh()
	local button = TextButton:create( nil, 0, 0, 115, 38, arg.button_text, UIResourcePath.FileLocate.chongZhi .. "button_s.png" )
	local button_size = button:getSize()
	button.page_index = arg.page_index
	self.page_index = arg.page_index
	button:setPosition( 520 - button_size.width - 10, 10 )
	button:setTouchClickFun( arg.chong_zhi_button_fun )
	self.scroll = scroll
	self.button = button
	self.view:addChild( scroll.view )
	self.view:addChild( button.view )
	--return base_panel
end
-----------------------------------------------
function ZhiFuBaoPageWin:scroll_create_function(index)
	local scroll_info = { width = 520, height = 255 }
	-----------------------------------------------
	local item_gap_y = 10
	local item_list = {}
	local title_info_font_size = 18
	local notic_info_font_size = 14
	local title_info = Label:create( nil, 0, 0, string.format( Lang.chong_zhi_info.notic_info, LangGameString[751]), title_info_font_size ) -- [751]="支付宝"
	table.insert( item_list, title_info.view )
	-----------------------------------------------
	local notic_info_one = Label:create( nil, 0, 0, LangGameString[791], notic_info_font_size ) -- [791]="请选择支付宝充值金额"
	table.insert( item_list, notic_info_one.view )
	-----------------------------------------------
	local chong_zhi_info = ChongZhiConfig:get_chong_zhi_info()
	local gapX = 140
	local gapY = 40
	local curPosX = 0
	local beginPosY = 0
	local curPosY = beginPosY
	local percent_rate = 10
	local first_select_num = 0
	local no_two_lab = nil
	local select_item_info = {}
	for i = 1, #chong_zhi_info.zhi_fu_bao do
		local temp_sprite = TextCheckBox:create( nil, curPosX, curPosY, 22, 22, {UIResourcePath.FileLocate.common .. "common_toggle_n.png", UIResourcePath.FileLocate.common .. "common_toggle_s.png"}, 
			string.format( "%d%s",chong_zhi_info.zhi_fu_bao[i],LangGameString[747], 5 )) -- [747]="元"
		curPosX = curPosX + gapX
		if i == 1 then
			first_select_num = chong_zhi_info.zhi_fu_bao[i]
		end
		if i % 4 == 0 and i < # chong_zhi_info.zhi_fu_bao then
			curPosX = 0
			curPosY = curPosY - gapY
		end
		local function button_fun()
			local cur_num = chong_zhi_info.zhi_fu_bao[i]
			local lab_info = Lang.chong_zhi_info.zhi_fu_bao_chong_info
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
	local notic_info_two = Label:create( nil, 0, 0, string.format( Lang.chong_zhi_info.zhi_fu_bao_chong_info, first_select_num, first_select_num * percent_rate ), 16 )
	no_two_lab = notic_info_two
	table.insert( item_list, notic_info_two.view )
	local notic_info_three = Label:create( nil, 0, 0, Lang.chong_zhi_info.zhi_fu_bao_warning_info, 16 )
	table.insert( item_list, notic_info_three.view )
	-- local notic_info_two = Dialog:create( nil, 0, 0, scroll_info.width, notic_info_font_size * 2, ADD_LIST_DIR_UP, 500 )
	-- table.insert( item_list, notic_info_two.view )
	-- notic_info_two:setText( Lang.chong_zhi_info.zhi_fu_bao_chong_info .. "#r#cffffff" .. Lang.chong_zhi_info.zhi_fu_bao_warning_info )
	-----------------------------------------------
	local sumHeight = 0
	local item_size_list = {}
	for i = 1, #item_list do
		local temp_size = item_list[i]:getSize()
		item_size_list[i] = temp_size.height
		sumHeight = sumHeight + temp_size.height
	end
	--self.view:setSize( scroll_info.width, sumHeight + item_gap_y * #item_list )
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
	-----------------------------------------------
	temp_page_info = base_panel
	--chong_zhi_scroll_page[1] = base_panel 
	return base_panel
end
-----------------------------------------------
function ZhiFuBaoPageWin:destroy()
	print("run zhi fu bao page destroy")
	Window.destroy(self)
	if temp_page_info ~= nil then
		temp_page_info:destroy()
	end
end
-----------------------------------------------
function ZhiFuBaoPageWin:get_page_info()
	if temp_page_info ~= nil then
		return temp_page_info.radio_button:getCurSelect() + 1
	else
		return -1
	end
end
-----------------------------------------------
function ZhiFuBaoPageWin:clear_insert_info()
	if temp_page_info ~= nil then
		temp_page_info.radio_button:selectItem(0)
	end
end
