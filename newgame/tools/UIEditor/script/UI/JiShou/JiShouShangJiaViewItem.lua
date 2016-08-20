----JiShouShangJiaViewItem.lua
----HJH
----2013-7-25
----上架物品
super_class.JiShouShangJiaViewItem(Window)
-----------------------------------------
-----------------------------------------
local function create_panel( self, width, height )
	local scroll_bg = ZImage:create( nil,UILH_COMMON.normal_bg_v2, 10, 15, width+15, height+15, nil, 600, 600 )
	self:addChild(scroll_bg.view)
	self.scroll = ZScroll:create( nil, nil, 20, 30, width-10, height-20, 1, TYPE_HORIZONTAL )
	self.scroll:setScrollLump( 10, 30, 1)
	self.scroll.view:setScrollLumpPos( width  - 22)
--	self.scroll.view:setScrollLump( UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 20, ( height - 10 ) / 5 )
--	self.scroll.view:setScrollLumpPos( width  - 12)
	self:addChild(self.scroll)
	local arrow_up = CCZXImage:imageWithFile(width-2, height, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(width-2, 30, 10, -1 , UILH_COMMON.scrollbar_down, 500, 500)
	self.view:addChild(arrow_up,500)
	self.view:addChild(arrow_down,500)

	local item_info = { twidth = width - 20, theight = height-20, page_num = 4, image = UILH_COMMON.split_line } 
	local slot_size = 64
	--图标区域，文字区域，按钮区域的大小
	local size_info = { 20, 108, 294 }
	local function scroll_fun(self,index)
		print("index", index)
		local all_item_info = JiShouShangJiaModel:get_my_ji_shou_item_info()
		local cur_item = all_item_info[index + 1]
		if cur_item == nil then
			return
		end
		local basePanel = ZListVertical:create(nil, 0, 0, item_info.twidth, item_info.theight / item_info.page_num, size_info, 2, 2 )
		local slot_item = SlotItem( slot_size, slot_size )
		slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -11, -11, 82, 82 )
		local function slot_click_fun(slot_obj,eventType, arg, msgid)
			local click_pos = Utils:Split(arg, ":")
			local world_pos = slot_item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
			if cur_item.bag_item ~= nil then
				TipsModel:show_tip( world_pos.x, world_pos.y, cur_item.bag_item, nil, nil, nil, nil, nil, nil)
			else
				local temp_data = { item_id = cur_item.sell_money_type, item_count = cur_item.sell_money }
				TipsModel:show_money_tip( world_pos.x, world_pos.y, temp_data )
			end
		end
		slot_item:set_click_event(slot_click_fun)
		if cur_item.type == 0 then
			slot_item:set_icon_ex( cur_item.bag_item.item_id )
			slot_item:set_color_frame( cur_item.bag_item.item_id )
			slot_item:set_item_count( cur_item.bag_item.count )		
		else
			if cur_item.sell_money_type == 3 then
				slot_item:set_icon_texture(UILH_JISHOU.yb_48)
			else
				slot_item:set_icon_texture(UILH_JISHOU.yl_48)
			end
			--slot_item:set_icon_ex()
		end
		local label_info
		if cur_item.money_type == 1 then
			label_info = Lang.jiShou.yl_text .. COLOR.w .. cur_item.price -- "#cd58a08银两："
		else
			label_info = Lang.jiShou.yb_text .. COLOR.w .. cur_item.price -- "#cd58a08元宝："
		end
		local label = ZLabel:create( nil, label_info, 0, 0 )
		local text_info
		if cur_item.reset_time - os.time() > 0 then
			text_info = Lang.jiShouShangJia.page_three.cancel -- "取消拍卖"
		else
			text_info = Lang.jiShouShangJia.page_three.timeout -- "拍卖到期"
		end
		  --xiehande   UI_JISHOUWIN_041 ->UIPIC_COMMOM_002
		local text_button = ZButton:create(basePanel,UILH_COMMON.btn4_nor,nil,250,30, -1, -1);
		local btn_text_info = CCZXLabel:labelWithText( 25, 21, text_info, 16, ALIGN_LEFT)
		--ZTextButton:create(nil, text_info, UI_JISHOUWIN_041, nil, 0, 0, -1, -1, 0, 500, 500 )
		local function btn_fun()
			local btn_info = cur_item
			local cancel_type = 1
			if btn_info.reset_time - os.time() > 0 then
				cancel_type = 0
			end
			if btn_info.type == 0 then
				JiShouCC:send_cancel_item( btn_info.bag_item.series, btn_info.handle, cancel_type )
			else
				JiShouCC:send_cancel_item( 0, btn_info.handle, cancel_type )
			end	
		end
		text_button:setTouchClickFun(btn_fun)
		text_button:addChild(btn_text_info);
		basePanel:addItemNew( slot_item )
		basePanel:addItemNew( label )
		-- basePanel:addItemNew( text_button )
		local line = ZImage:create( nil, item_info.image, 0, 0, item_info.twidth, 2,500 )
		basePanel.view:addChild(line.view)
		return basePanel
	end
	self.scroll:setScrollCreatFunction(scroll_fun)
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaViewItem:__init(window_name, texture_name, is_grid, width, height)
	create_panel( self, width, height )
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaViewItem:active(show)
	if show then
		JiShouShangJiaModel:check_my_ji_shou_info()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaViewItem:set_scroll_max_num(num)
	if self.scroll ~= nil then
		self.scroll:setMaxNum( num )
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaViewItem:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll:refresh()
	end
end
-----------------------------------------
-----------------------------------------
function JiShouShangJiaViewItem:clear_scroll()
	print("clear info")
	if self.scroll ~= nil then
		print("clear info 2")
		self.scroll:clear()
	end
end
