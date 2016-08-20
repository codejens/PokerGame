-----HJH 2013-6-17
-----------------------------------------------
-----------------------------------------------
super_class.CreditCardWin(Window)
-----------------------------------------------
function CreditCardWin:__init( window_name, window_info, arg )
	local scroll = Scroll:create( nil, 0, 50 + 15, 520, 255, 1, TYPE_HORIZONTAL )
	scroll:setScrollCreatFunction( CreditCardWin.scroll_create_fun )
	-----------------------------------------------
	local dis_x = 20
	local chong_zhi_button = TextButton:create( nil, 0, 0, 115, 38, arg.button_text_one, UIResourcePath.FileLocate.chongZhi .. "button_s.png" )
	local chong_zhi_button_size = chong_zhi_button:getSize()
	chong_zhi_button.page_index = arg.page_index
	chong_zhi_button:setPosition( 520 - chong_zhi_button_size.width - 10, 10 )
	local chong_zhi_button_pos = chong_zhi_button:getPosition()
	chong_zhi_button:setTouchClickFun( arg.chong_zhi_button_fun )
	-----------------------------------------------
	local jie_bang_button = TextButton:create( nil, 0, 0, 115, 38, arg.button_text_two, UIResourcePath.FileLocate.chongZhi .. "button_s.png")
	jie_bang_button.page_index = arg.page_index
	jie_bang_button:setPosition( chong_zhi_button_pos.x - chong_zhi_button_size.width - dis_x, chong_zhi_button_pos.y )
	jie_bang_button.view:setCurState(CLICK_STATE_DISABLE)
	local jie_bang_button_pos = jie_bang_button:getPosition()
	jie_bang_button:setTouchClickFun( arg.jie_bang_button_fun )
	-----------------------------------------------
	local bang_ka_button = TextButton:create( nil, 0, 0, 115, 38, arg.button_text_three, UIResourcePath.FileLocate.chongZhi .. "button_s.png" )
	bang_ka_button.page_index = arg.page_index
	bang_ka_button:setPosition( jie_bang_button_pos.x - chong_zhi_button_size.width - dis_x, chong_zhi_button_pos.y )
	bang_ka_button:setTouchClickFun( arg.bang_ka_button_fun )
	-----------------------------------------------
	self.scroll = scroll
	self.chong_zhi_button = chong_zhi_button
	self.jie_bang_button = jie_bang_button
	self.bang_ka_button = bang_ka_button
	self.temp_page_info = nil
	-----------------------------------------------
	self.view:addChild( scroll.view )
	self.view:addChild( chong_zhi_button.view )
	self.view:addChild( jie_bang_button.view )
	self.view:addChild( bang_ka_button.view )
end
-----------------------------------------------
function CreditCardWin:scroll_create_fun( index, arg )
	-----------------------------------------------
	local scroll_info = { width = 520, height = 255 }
	-----------------------------------------------
	local item_gap_y = 10
	local item_list = {}
	local font_size = 16
	-----------------------------------------------
	local title_info_one = Label:create( nil, 0, 0, string.format(Lang.chong_zhi_info.notic_credit_card_info_one,LangGameString[789]), font_size ) -- [789]="#cffffff未绑定"
	table.insert( item_list, title_info_one.view )
	-----------------------------------------------
	local title_info_two = Label:create( nil, 0, 0, Lang.chong_zhi_info.notic_credit_card_info_two, font_size )
	--table.insert( item_list, title_info_two.view )
	local money_insert_edit_bg = Image:create( nil, 178, -5, 100, 32, UIPIC_GRID_nine_grid_bg3, 600, 600 )
	local money_insert_edit_box = EditBox:create( nil, 180, -5, 100, 32, 7 )
	local temp_label_three = nil
	local function edit_box_insert_fun()
		print("run edit_box_insert_fun")
		if temp_label_three ~= nil then
			local cur_money = money_insert_edit_box:getText()
			local temp_one = 1
			local per_rate = 10
			if cur_money ~= "" then
				temp_one = tonumber( cur_money )
			end
			temp_label_three:setText( string.format( Lang.chong_zhi_info.yi_dong_chong_info, temp_one, temp_one * per_rate ) )
		end
	end
	money_insert_edit_box:setKeyBoardClickFunction(edit_box_insert_fun)
	money_insert_edit_box:setKeyBoardBackSpaceFunction(edit_box_insert_fun)
	local money_insert_panel = BasePanel:create( nil, 0, 0, scroll_info.width, 25, "" )
	money_insert_panel.view:addChild( title_info_two.view )
	money_insert_panel.view:addChild( money_insert_edit_bg.view )
	money_insert_panel.view:addChild( money_insert_edit_box.view )
	table.insert( item_list, money_insert_panel.view )
	-----------------------------------------------
	local title_info_three = Label:create( nil, 0, 0, string.format( Lang.chong_zhi_info.yi_dong_chong_info, 1, 10), font_size )
	temp_label_three = title_info_three
	table.insert( item_list, title_info_three.view )
	-----------------------------------------------
	local edit_box_info = { width = 430, height = 32 }
	local user_info_panel = BasePanel:create( nil, 0, 0, scroll_info.width, edit_box_info.height, "" )
	table.insert( item_list, user_info_panel.view )
	local user_info_label = Label:create( nil, 0, 0, LangGameString[748], font_size ) -- [748]="卡号："
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
	local psw_info_label = Label:create( nil, 0, 0, LangGameString[749], font_size) -- [749]="密码："
	local psw_info_label_size = psw_info_label.view:getSize()
	psw_info_label:setPosition( 0, (edit_box_info.height - psw_info_label_size.height) * 0.5 )
	local psw_info_edit_bg = Image:create( nil, 50, 0, edit_box_info.width, edit_box_info.height, UIPIC_GRID_nine_grid_bg3, 600, 600 )
	local psw_info_edit_box = EditBox:create( nil, 50, 0, edit_box_info.width, edit_box_info.height, 30 )
	psw_info_edit_box.view:setEditBoxType(EDITBOX_TYPE_PASSWORD)
	psw_info_panel.view:addChild( psw_info_label.view )
	psw_info_panel.view:addChild( psw_info_edit_bg.view )
	psw_info_panel.view:addChild( psw_info_edit_box.view )
	-----------------------------------------------
	local notic_info = Dialog:create( nil, 0, 0, scroll_info.width, font_size * 2, ADD_LIST_DIR_UP, 500 )
	notic_info:setText(Lang.chong_zhi_info.credit_card_warning_info)
	table.insert( item_list, notic_info.view )
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
	local curPosY = sumHeight + item_gap_y * #item_list
	for i = 1, #item_list do
		curPosY = curPosY - item_size_list[i] - item_gap_y
		item_list[i]:setPosition( 0, curPosY )
		base_panel.view:addChild( item_list[i] )
	end
	-----------------------------------------------
	base_panel.title_info_one = title_info_one
	base_panel.user_info_label = user_info_label
	base_panel.user_info_edit_bg = user_info_edit_bg
	base_panel.psw_info_panel = psw_info_panel
	base_panel.money_insert_edit_box = money_insert_edit_box
	base_panel.user_info_edit_box = user_info_edit_box
	base_panel.psw_info_edit_box = psw_info_edit_box
	-----------------------------------------------
	self.temp_page_info = base_panel
	-- chong_zhi_scroll_page[arg.index] = base_panel 
	return base_panel
end
-----------------------------------------------
function CreditCardWin:destroy()
	Window.destroy(self)
	if self.scroll.temp_page_info ~= nil then
		self.scroll.temp_page_info:destroy()
	end
end
-----------------------------------------------
function CreditCardWin:get_page_info()
	if self.scroll.temp_page_info ~= nil then
		return {
				self.scroll.temp_page_info.money_insert_edit_box.view:getText(),
				self.scroll.temp_page_info.user_info_edit_box.view:getText(),
				self.scroll.temp_page_info.psw_info_edit_box.view:getText(),
				}
	else
		return { "", "", "" }
	end
end
-----------------------------------------------
function CreditCardWin:clear_insert_info()
	if self.scroll ~= nil and self.scroll.temp_page_info ~= nil then
		self.scroll.temp_page_info.money_insert_edit_box.view:setText("")
		self.scroll.temp_page_info.user_info_edit_box.view:setText("")
		self.scroll.temp_page_info.psw_info_edit_box.view:setText("")
	end
end
-----------------------------------------------
function CreditCardWin:reinit_info(info)
	local credit_card_type = ChongZhiModel:get_credit_card_type()
	if credit_card_type == 0 then
		self.scroll.temp_page_info.title_info_one:setText( string.format(Lang.chong_zhi_info.notic_credit_card_info_one,LangGameString[789]) ) -- [789]="#cffffff未绑定"
		self.scroll.temp_page_info.user_info_label:setText(LangGameString[748]) -- [748]="卡号："
		self.scroll.temp_page_info.user_info_edit_bg.view:setIsVisible(true)
		self.scroll.temp_page_info.user_info_edit_box.view:setIsVisible(true)
		self.scroll.temp_page_info.psw_info_panel.view:setIsVisible(true)
		self.jie_bang_button.view:setCurState(CLICK_STATE_DISABLE)
		self.bang_ka_button.view:setCurState(CLICK_STATE_UP)
	else
		self.scroll.temp_page_info.title_info_one:setText( string.format(Lang.chong_zhi_info.notic_credit_card_info_one,LangGameString[790]) ) -- [790]="#c38ff33已绑定"
		self.scroll.temp_page_info.user_info_label:setText(info)
		self.scroll.temp_page_info.user_info_edit_bg.view:setIsVisible(false)
		self.scroll.temp_page_info.user_info_edit_box.view:setIsVisible(false)
		self.scroll.psw_info_panel.view:setIsVisible(false)
		self.jie_bang_button.view:setCurState(CLICK_STATE_UP)
		self.bang_ka_button.view:setCurState(CLICK_STATE_DISABLE)
	end
end
