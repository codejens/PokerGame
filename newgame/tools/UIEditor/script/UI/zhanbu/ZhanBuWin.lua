----ZhanBu.lua
----HJH
----2013-9-6
----
super_class.ZhanBuWin(Window)
-----------------------------
local _self_panel = nil
local _is_run_timer = false
-----------------------------
local function create_left(self, x, y, width, height)
	-----------------------------
	local bg = ZImage:create( nil, UIPIC_GRID_nine_grid_bg3, x, y, width, height, nil, 600, 600 )
	self:addChild( bg.view )
	-----------------------------
	local girl = ZImage:create( nil, UIResourcePath.FileLocate.zhanbu .. "girl.png", x + 5, y + 2, -1, -1 )
	self:addChild( girl.view )
	-----------------------------
	local notic_info = ZDialog:create( nil, nil, 10 + x , height + 12, 270, 74 )
	notic_info.view:setAnchorPoint( 0, 1 )
	notic_info.view:setFontSize( 12 )
	self:addChild( notic_info.view )
	notic_info:setText( Lang.zhan_bu.notic_info )
	-----------------------------
	local talk_bg = ZImage:create( nil, UIResourcePath.FileLocate.zhanbu .. "talk_bg.png", 155 - x, 220 - y, -1, -1 )
	self:addChild( talk_bg.view )
	-----------------------------
	self.button = ZTextButton:create( nil, LangGameString[2282], UIResourcePath.FileLocate.common .. "button4.png", nil, 260 - x,  100 - y, -1, -1 ) -- [2282]="轻轻点击"
	self:addChild( self.button.view )
	self.button:setTouchClickFun( ZhanBuModel.zhanbu_button_fun )
	--self.button.view:setColor(0x80ffffff)
	-----------------------------
	local lab = ZLabel:create( nil, LangGameString[2283], 255 - x, height - 320 - y, 14) -- [2283]="#cff66cc占卜时间："
	self:addChild( lab.view )
	local lab_size = lab:getSize()
	local lab_pos = lab:getPosition()
	local function reset_timer_fun()
		_self_panel.time_lab:setString("")
	end
	self.time_lab = TimerLabel:create_label(self, lab_pos.x + lab_size.width, lab_pos.y, 18, 0, "#c38ff33", reset_timer_fun, false )
end
-----------------------------
local function scroll_create_fun( self, index )
	-----------------------------
	local panel_info = ZhanBuModel:get_panel_info()
	--index = 0
	local temp_info = panel_info.event_info[index + 1]
	-----------------------------
	local slot_size = 38
	-----------------------------
	local panel_size_h = slot_size + 20
	-----------------------------
	local slot_item = SlotItem( slot_size, slot_size )
	slot_item:set_icon_bg_texture( UIPIC_ITEMSLOT, -7, -7, 52, 52 )
	local slot_item_pos = slot_item.view:getPositionS()
	print("temp_info.event_id ,temp_info.name",temp_info.event_id ,temp_info.name)
	local temp_event_info = ZhanBuConfig:get_index_event_info( temp_info.event_id )
	if temp_event_info.ttype == 1 then
		slot_item:set_icon_ex( temp_event_info.info[1] )
		slot_item:set_item_count( temp_event_info.info[2] )
		slot_item._count_image.view:setPosition(CCPointMake( 50 - 7,  8))
		local item_info = ItemConfig:get_item_by_id( temp_event_info.info[1] )
		slot_item:set_color_frame( temp_event_info.info[1] )
		slot_item.color_frame:setSize( 47, 47 )
		local function temp_click_fun(arg)
			local click_pos = Utils:Split(arg, ":")
			local world_pos = slot_item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
			TipsModel:show_shop_tip( world_pos.x, world_pos.y, temp_event_info.info[1] )
		end
		slot_item:set_click_event( temp_click_fun )
	elseif temp_event_info.ttype == 2 then
		local icon_path = string.format( "icon/buff/%05d.jd",temp_event_info.info.type )
		slot_item:set_icon_texture( icon_path )
		slot_item.icon:setScale( 2.0 )
	elseif temp_event_info.ttype == 3 then
		local temp_image = string.format( "icon/buff/%05d.jd",1 )
		--local temp_image = string.format( "%s%s%d.png", UIResourcePath.FileLocate.zhanbu, "exchange_", temp_event_info.info ) 
		slot_item:set_icon_texture( temp_image )
		slot_item.icon:setScale( 2.0 )
	end
	-----------------------------
	local dialog = ZDialog:create( nil, nil, 30 + slot_size , 0, 323 - slot_item_pos.x - slot_size - 40, 20 )
	dialog.view:setAnchorPoint( 0, 1 )
	local temp_lab_info = string.gsub( Lang.zhan_bu.event_notic_info[ temp_info.event_id ], Lang.zhan_bu.event_notic_target, temp_info.name )
	dialog:setText( temp_lab_info )
	local dialog_size = dialog.view:getSize()
	-----------------------------
	local line = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", 0, -2, 323, 2 )
	-----------------------------
	if dialog_size.height > panel_size_h then
		panel_size_h = dialog_size.height
		dialog:setPosition( 30 + slot_size, dialog_size.height )
	else
		dialog:setPosition( 30 + slot_size, dialog_size.height + panel_size_h - dialog_size.height )
	end
	local basePanel = ZBasePanel:create( nil, nil, 0, 0, 323, panel_size_h )
	slot_item.view:setPosition( 10, panel_size_h - slot_size - 10 )
	basePanel.view:addChild( slot_item.view )
	basePanel:addChild( dialog )
	basePanel:addChild( line )
	-----------------------------
	return basePanel
end
-----------------------------
local function create_right(self, x, y, width, height)
	-----------------------------
	local bg = ZImage:create( nil, UIPIC_GRID_nine_grid_bg3, x, y, width, height, nil, 600, 600 )
	self:addChild( bg.view )
	-----------------------------
	local left_title = ZTextImage:create( nil, LangGameString[2284], UIResourcePath.FileLocate.common .. "title_bg_01_s.png", nil, 107 + x, height - y + 10, -1, -1 ) -- [2284]="#cfff000事件记录"
	self:addChild( left_title.view )
	-----------------------------
	self.scroll = ZScroll:create( nil, nil, x + 5, y + 5, 323 - 10, 330, 1, TYPE_HORIZONTAL )
	self:addChild( self.scroll.view )
	--self.scroll.view:setScrollLump( UIResourcePath.FileLocate.common .. "progress_green.png", 10, 30, 80 )
	--self.scroll.view:setTexture("ui/common/bg_06.png")
	-----------------------------
	self.scroll:setScrollCreatFunction( scroll_create_fun )
end
-----------------------------
local function create_panel(self, tx, ty, width, height)
	-----------------------------
	-- local title = ZImageImage:create( nil, UIResourcePath.FileLocate.zhanbu .. "title.png", UIResourcePath.FileLocate.common .. "win_title1.png", 0, 0, -1, -1 )
	-- title:setGapSize( -10, 3)
	-- self:addChild( title.view )
	-- local title_size = title.view:getSize()
	-- title:setPosition( (width - title_size.width) / 2, height - title_size.height )
	-----------------------------
	create_right( self, 400, height - 406, 324, 377 )
	create_left( self, 19, height - 406, 380, 377 )
	-----------------------------
	-- local title = ZImageImage:create( nil, UIResourcePath.FileLocate.zhanbu .. "title.png", UIResourcePath.FileLocate.common .. "win_title1.png", 0, 0, -1, -1 )
	-- title:setGapSize( -10, 3)
	-- self:addChild( title.view )
	-- local title_size = title.view:getSize()
	-- title:setPosition( (width - title_size.width) / 2, height - title_size.height )
	-----------------------------
	-- local exit = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png"}, nil, 0, 0, -1, -1 )
	-- self:addChild( exit.view )
	-- local exit_size = exit:getSize()
	-- exit:setPosition( width - exit_size.width, height - exit_size.height )
	-- local function exit_btn_fun()
	-- 	UIManager:hide_window("zhanbu_win")
	-- end
	-- exit:setTouchClickFun(exit_btn_fun)
end
-----------------------------
function ZhanBuWin:active_time(result)
	print("run ZhanBuWin:active_time ", result)
	if result == true then
		_self_panel.view:setTimer(10)
		_is_run_timer = true
	elseif _is_run_timer == true then
		_is_run_timer = false
		_self_panel.view:setTimer(0)
		ZhanBuModel:reset_buff_panel()
	end
end
-----------------------------
function ZhanBuWin:timer_fun()
	local result = ZhanBuModel:check_buff_out_of_time()
	if result == true then
		_self_panel:active_time(false)
	end
end
-----------------------------
function ZhanBuWin:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	create_panel( self, 0, 0, window_info.width, window_info.height )
	_self_panel = self
	self:registerScriptFun()
	self:setTouchTimerFun(ZhanBuWin.timer_fun)
end
-----------------------------
function ZhanBuWin:active(show)
	if show == true then
		print("ZhanBuModel:get_reinit_info()",ZhanBuModel:get_reinit_info())
		if ZhanBuModel:get_reinit_info() == true then
			self.scroll:clear()
			self.scroll:setMaxNum(0)
			ZhanBuModel:reinit_win_info()
			_is_run_timer = false
		end
		local temp_update_list = ZhanBuModel:get_update_list()
		for i = 1, #temp_update_list do
			self:update_fun( temp_update_list[i] )
		end
		ZhanBuModel:clear_update_list()
		self:active_time(true)

		-- 删除特效
		local effectNode = self.view:removeChildByTag(11024,true);
	end
end
-----------------------------
function ZhanBuWin:update_fun(index)
	-----------------------------
	local panel_info = ZhanBuModel:get_panel_info()
	----------------------------- 
	if index == ZhanBuUpdateType.update_time then
		if panel_info.cur_time - os.time() > 0 then
			self.time_lab:setText( panel_info.cur_time - os.time() )
		else
			self.time_lab:setString( LangGameString[2285] ) -- [2285]="0秒"
		end
		-- if panel_info.cur_time - os.time() > 0 then
		-- 	self.button.view:setCurState( CLICK_STATE_DISABLE )
		-- else
		-- 	self.button.view:setCurState( CLICK_STATE_UP )
		-- end
	elseif index == ZhanBuUpdateType.update_scroll then
		self.scroll:setMaxNum( #panel_info.event_info )
		self.scroll:clear()
		self.scroll:refresh()
	end
end

function ZhanBuWin:destory()
	self.time_lab:destory()
	Window.destory(self)
end
