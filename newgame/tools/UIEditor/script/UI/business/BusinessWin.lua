-----------------------------------------------
-----------------------------------------------
---------HJH
---------2013-5-20
---------交易界面
super_class.BusinessRole(Window)

local buniess_type_left = 1
local buniess_type_right = 2


local function create_BusinessRole_panel(self, width, height, ttype)
	self.ttype = ttype
	-- 创建交易方的名字
	local name_bg = ZImage:create( self.view, UILH_NORMAL.title_bg4, 5, height - 36, width-10, -1, 500, 500)

	local role_name_font_size = 16
	self.role_name = ZLabel:create( nil, Lang.business[1], (width-10)/2, 10, role_name_font_size, 2 )
	name_bg.view:addChild( self.role_name.view )

	-- local line = CCZXImage:imageWithFile( 6, height-33, width-13, 3, UILH_COMMON.split_line )     
 --    self.view:addChild(line)

	self.item_area = {}
	self.item_name = {}
	self.item_num = {}

	local max_item_num = 4
	local item_pos_x = 20
	local item_size = 50
	local item_gapsize = 20
	local item_pos_y = height - item_size - 48
	local name_and_num_font_size = 16

	for i = 1, max_item_num do
		self.item_area[i] = SlotItem( item_size, item_size)
		self.item_area[i]:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, 65, 65 )   -- 背框 UILH_COMMON.solt_bg UIPIC_ITEMSLOT
		self.item_area[i].temp_user_item = nil
		self.item_area[i].view:setPosition( item_pos_x, item_pos_y )

		-- 名字和数量
		-- self.item_name[i] = ZLabel:create( nil, COLOR.r_y .. Lang.business[4], item_pos_x + item_size + 7, item_pos_y + item_size - name_and_num_font_size - 8, name_and_num_font_size ) -- [658]="名称:"
		self.item_num[i] = ZLabel:create( nil, COLOR.r_y .. Lang.business[5], item_pos_x + item_size + 7, item_pos_y + 8, name_and_num_font_size ) -- [659]="数量:"
		-- 名字 ------------------------------------------------------------
	    self.item_name[i] = CCDialogEx:dialogWithFile( item_pos_x+item_size+7, item_pos_y+item_size-name_and_num_font_size+15, 120, 45, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
	    self.item_name[i]:setAnchorPoint(0,1);
	    self.item_name[i]:setFontSize(name_and_num_font_size);
	    self.item_name[i]:setText( COLOR.r_y .. Lang.business[4] );  -- "#cffff00当前效果:#cffffff:"
	    self.item_name[i]:setTag(0)
	    self.item_name[i]:setLineEmptySpace (1)
	    -- panel:addChild(self.item_name[i])

		-- 新效果图(火影)
		if i ~= max_item_num then
			-- local line = ZImage:create( nil, UI_BusinessWin_006, 81, item_pos_y-5, 97, 2)
			local line = CCZXImage:imageWithFile( 6, item_pos_y-15, width-13, 3, UILH_COMMON.split_line)
			self.view:addChild(line)
			-- local bottom_line = CCZXImage:imageWithFile( 6, item_pos_y - 9, width-13, 3, UILH_COMMON.split_line)     
			-- self.view:addChild(bottom_line) 
		end

		if i ~= max_item_num then
			item_pos_y = item_pos_y - item_size - item_gapsize
		end

		local function drag_in_function(item)
			local index = i 
			if self.ttype == buniess_type_right then	
				if self.arc.touch_end_fun == nil then
					if self.item_area[index].temp_user_item == nil then
						self.item_area[index]:set_icon(item.obj_data.item_id)
						self.item_area[index]:set_color_frame(item.obj_data.item_id, 0, 0, item_size, item_size)
						self.item_area[index].temp_user_item = item.obj_data
						--self.item_area[index].temp_item_id = item.obj_data.item_id
						self.item_name[index]:setText( COLOR.r_y .. ItemConfig:get_item_name_by_item_id(item.obj_data.item_id) )
						self.item_num[index]:setText( COLOR.r_y .. Lang.business[5]..item.obj_data.count ) -- [660]="数量："
						--BuniessModel:update_my_item_area_add_index(index)
						--BuniessModel:data_add_my_item_info( item.obj_data )
						BuniessCC:send_change_item(item.obj_data.series, 1)
					else
						NormalDialog:show(Lang.business[6],nil,1) -- [661]="已有物品在格子上"
					end
				else
					NormalDialog:show(Lang.business[7],nil,2) -- [662]="交易已鎖定"
					BuniessModel:set_is_run_tips_in_lock_left(true)
				end
			else
				if self.arc.touch_end_fun ~= nil then
					NormalDialog:show(Lang.business[6],nil,2) -- [662]="交易已鎖定"
					BuniessModel:set_is_run_tips_in_lock_right(true)
				end
			end
		end

		local function touch_click_function(slot_obj, eventType, arg, msgid)
			local index = i
			local click_pos = Utils:Split(arg, ":")
			local world_pos = self.item_area[index].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
			if self.item_area[index].temp_user_item ~= nil then
				TipsModel:show_tip( world_pos.x, world_pos.y, self.item_area[index].temp_user_item, nil, nil, nil, nil, nil, nil)
			end
			if self.ttype == buniess_type_left then
				BuniessModel:set_is_run_tips_in_lock_left(true)
			else
				BuniessModel:set_is_run_tips_in_lock_right(true)
			end
		end
		local function touch_double_function()
			local index = i
			if self.ttype == buniess_type_right then
				local state = BuniessModel:get_right_lock_state();
				-- 锁定状态怎能改变物品
				if state then
					return
				end
				if self.item_area[index].temp_user_item ~= nil then
					BuniessCC:send_change_item( self.item_area[index].temp_user_item.series, 0)
				end
			end
		end

		self.item_area[i]:set_drag_in_event(drag_in_function)
		-- self.item_area[i]:setTouchBeginFunction(touch_click_function)
		self.item_area[i]:set_double_click_event(touch_double_function)
		self.item_area[i]:set_click_event(touch_click_function)
		end

	-- 创建最底部的那根线
	-- local bottom_line = ZImage:create( nil, UI_BusinessWin_006, 10, item_pos_y - 9, 170, 2)
	-- self.view:addChild(bottom_line.view)

	local bottom_line = CCZXImage:imageWithFile( 6, item_pos_y - 9, width-13, 3, UILH_COMMON.split_line)     
    self.view:addChild(bottom_line) 

	-- 元宝控件组
	self.yb = ZLabel:create( nil, COLOR.r_y .. Lang.business[8], 10, item_pos_y - 45 , 16) -- [663]="#cfff000元宝:"
	local yb_pos = self.yb:getPosition()
	self.yb_editbox = MUtils:create_num_edit( 55, item_pos_y - 55, 135, 30, 10, BuniessModel.yb_edit_finish_function, UILH_NORMAL.text_bg2, ALIGN_LEFT )--EditBox:create( nil, 45, item_pos_y - 20, 100, 20, 10)
	self.yb_editbox.is_active_zero = true
	if self.yb_editbox.label then
		self.yb_editbox.label:setPosition( 10, 9 );
		self.yb_editbox.label:setAnchorPoint(CCPoint(0,0));
	end

	self.view:addChild( self.yb.view )
	self.view:addChild( self.yb_editbox.view )
	--self.view:addChild( self.yb_editbox_bg.view )
	
	-- 银两控件组
	self.yl = ZLabel:create( nil, COLOR.r_y .. Lang.business[9], yb_pos.x, yb_pos.y - 45) -- [664]="#cfff000银两:"
	local yl_pos = self.yl:getPosition()
	self.yl_editbox =  MUtils:create_num_edit( 55, yb_pos.y - 55, 135, 30, 10, BuniessModel.yl_edit_finish_function, UILH_NORMAL.text_bg2, ALIGN_LEFT )--EditBox:create( nil, 45, yb_pos.y - 40, 100, 20, 10 )
	self.yl_editbox.is_active_zero = true
	if self.yl_editbox.label then
		self.yl_editbox.label:setPosition( 10, 9 );
		self.yl_editbox.label:setAnchorPoint(CCPoint(0,0));
	end

	self.view:addChild( self.yl.view )
	self.view:addChild( self.yl_editbox.view )
	--self.view:addChild( self.yl_editbox_bg.view )	

	-- 锁定交易按钮	
	-- self.lock_buniss = ZTextButton:create( nil, LangGameString[665], {UIResourcePath.FileLocate.common .. "button2_bg.png", UIResourcePath.FileLocate.common .. "button2_bg.png"}, nil, 7, yl_pos.y - 46, 80, 32, nil, 600, 600 ) -- [665]="锁定"
	-- self.view:addChild( self.lock_buniss.view )

	-- 确认交易按钮
	-- self.confirm = ZTextButton:create( nil, LangGameString[666], {UIResourcePath.FileLocate.common .. "button2_bg.png", UIResourcePath.FileLocate.common .. "button2_bg.png"}, nil, yb_pos.x + 78, yl_pos.y - 46, 80, 32, nil, 600, 600 ) -- [666]="交易"
	-- self.view:addChild( self.confirm.view )

	self.arc = ArcRect:create( nil, 0, 0, width, height, 0xffffff00 )
	self.arc.ttype = ttype
	--self.arc:setTouchBeganFun(BuniessModel.arc_rect_function)
	self.arc:setTouchBeganReturnValue(false)
	self.arc:setTouchMovedReturnValue(false)
	self.arc:setTouchEndedReturnValue(false)
	--self.arc:setDefaultMessageReturn(false)
	--self.arc:setIsVisible(false)
	self.view:addChild( self.arc.view )
	self.arc.view:setIsVisible(false)

	for i = 1 , #self.item_area do
		self.view:addChild( self.item_area[i].view )
		self.view:addChild( self.item_name[i] )
		self.view:addChild( self.item_num[i].view )
	end

	-- -- 提示
	-- local tips = ZDialog:create(nil, LangGameString[2373], 24, 115, 290/2, 45, 15, 30) -- [2373]="#cfff000注意：寄售所得的元宝将自动转化为礼券"
	-- tips.view:setAnchorPoint( 0, 1 )
	-- self.view:addChild(tips.view)
end
-----------------------------------------------
-----------------------------------------------
function BusinessRole:__init(window_name, texture_name, is_grid, width, height, ttype)
	create_BusinessRole_panel( self, width, height, ttype )
end
-----------------------------------------------
-----------------------------------------------
super_class.BusinessWin(NormalStyleWindow)


function BusinessWin:__init( window_name, texture_name, is_grid, width, height )

	local bg_h = 470
	local bg_w = 201

	-- 透明底板
	local bg = CCZXImage:imageWithFile( 5, 10, 425, 550, UILH_COMMON.normal_bg_v2, 500, 500)
    self.view:addChild(bg)

	-- 左边面板
	self.left_role_info = BusinessRole( "BusinessRole_left", UILH_COMMON.bottom_bg, true, bg_w, bg_h, buniess_type_left )
		--[[{ texture = "",
		x = 45, y = 70, width = 180, height = 470}, 
		buniess_type_left )--]]
	-- self.left_role_info.lock_buniss.view:setIsVisible(false)
	-- self.left_role_info.confirm.view:setIsVisible(false)
	self.left_role_info.arc:setTouchEndedReturnValue(true)
	self:addChild( self.left_role_info )
	self.left_role_info:setPosition( 15, 80 )

	-- 右边面板
	self.right_role_info = BusinessRole( "BusinessRole_right", UILH_COMMON.bottom_bg, true, bg_w, bg_h, buniess_type_right )
		--[[{ texture = "",
		x = 230, y = 70, width = 180, height = 470}, 
		buniess_type_right )--]]
	-- self.right_role_info.lock_buniss:setTouchClickFun( BuniessModel.lock_buniess_function )
	-- self.right_role_info.confirm:setTouchClickFun( BuniessModel.right_confirm_function )
	self:addChild( self.right_role_info )
	self.right_role_info:setPosition( 15 +bg_w, 80 )

	-- 关闭按钮需要自定义
	-- self.exit_btn = ZButton:create(self.view, UIResourcePath.FileLocate.common .. "close_btn_z.png", BuniessModel.exit_btn_function,0,0,60,60,999);
	-- local winSize = self.view:getSize();
	-- local exitSize= self.exit_btn:getSize();
	-- self.exit_btn:setPosition( winSize.width - exitSize.width - 6, winSize.height - exitSize.height - 1 );

	-- 锁定交易按钮 UI_BusinessWin_004->UIPIC_COMMOM_002
	self.lock_business_btn = ZButton:create(self.view, UILH_COMMON.lh_button2, self.lock_business_btn_func, 60, 25);
	local lock_business_btn_name = CCZXLabel:labelWithText( 28, 20, Lang.business[2], 16, ALIGN_LEFT)
	self.lock_business_btn:addChild( lock_business_btn_name )
	self.lock_business_btn:addImage( CLICK_STATE_DOWN, UILH_COMMON.lh_button2_s )
	--UI_BusinessWin_009 ->UIPIC_COMMOM_003
	self.lock_business_btn:addImage( CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable )
	
	-- 确认交易按钮
	--UI_BusinessWin_005
	self.confirm_btn = ZButton:create(self.view, UILH_COMMON.lh_button2, self.confirm_btn_func, 260, 25);
	local confirm_btn_name = CCZXLabel:labelWithText( 28, 20, Lang.business[3], 16, ALIGN_LEFT)
	self.confirm_btn:addChild( confirm_btn_name )
	self.confirm_btn:addImage( CLICK_STATE_DOWN, UILH_COMMON.lh_button2_s )
	--UI_BusinessWin_009 ->UIPIC_COMMOM_003
	self.confirm_btn:addImage( CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable )

	-- 提示
	-- local tips = ZDialog:create(nil, Lang.business[10], 20, 70, 180, 45, 15, 25) -- [2373]="#cfff000注意：寄售所得的元宝将自动转化为礼券"
	-- tips.view:setAnchorPoint( 0, 1 )
	-- self.view:addChild(tips.view)

	self:setExitBtnFun(BuniessModel.exit_btn_function)
end

-- 锁定交易按钮
function BusinessWin:lock_business_btn_func( ... )
	BuniessModel:lock_buniess_function()
	if self.lock_business_btn then
		self.lock_business_btn:setCurState( CLICK_STATE_DISABLE )
	end
	return true
end

-- 确认交易按钮
function BusinessWin:confirm_btn_func(  )
	BuniessModel:right_confirm_function()
end

-- 清除左侧栏信息
function BusinessWin:clear_left_info()
	
	if self.left_role_info == nil then
		return
	end
	
	for i = 1, #self.left_role_info.item_area do
		self.left_role_info.item_area[i]:set_icon_ex(nil)
		self.left_role_info.item_area[i]:set_color_frame(nil)
		self.left_role_info.item_area[i].temp_user_item = nil
		self.left_role_info.item_name[i]:setText("")
		self.left_role_info.item_num[i]:setText("")
	end
	-- self.left_role_info.yb_editbox.set_num("")
	-- self.left_role_info.yl_editbox.set_num("")
	self.left_role_info.role_name:setText("")
	self.left_role_info.yl_editbox.set_num_not_do_cb(0)
	self.left_role_info.yb_editbox.set_num_not_do_cb(0)
	--self.left_role_info.arc:setDefaultMessageReturn(false)
	self.left_role_info.arc:setTouchBeganReturnValue(false)
	self.left_role_info.arc:setTouchMovedReturnValue(false)
	self.left_role_info.arc:setTouchEndedReturnValue(true)
	self.left_role_info.arc:setTouchEndedFun(nil)
	self.left_role_info.arc:setColor(0x00000000)
	-- self.left_role_info.lock_buniss.view:setCurState(CLICK_STATE_UP)
	-- self.left_role_info.confirm.view:setCurState(CLICK_STATE_DISABLE)
end

-- 清除右侧栏信息
function BusinessWin:clear_right_info()
	
	if self.right_role_info == nil then
		return
	end
	
	for i = 1, #self.right_role_info.item_area do
		self.right_role_info.item_area[i]:set_icon_ex(nil)
		self.right_role_info.item_area[i]:set_color_frame(nil)
		self.right_role_info.item_area[i].temp_user_item = nil
		self.right_role_info.item_name[i]:setText("")
		self.right_role_info.item_num[i]:setText("")
	end
	--self.right_role_info.yb_editbox.set_num("")
	--self.right_role_info.yl_editbox.set_num("")
	self.right_role_info.role_name:setText("")
	self.right_role_info.yl_editbox.set_num_not_do_cb(0)
	self.right_role_info.yb_editbox.set_num_not_do_cb(0)
	--self.right_role_info.arc:setDefaultMessageReturn(false)
	self.right_role_info.arc:setTouchBeganReturnValue(false)
	self.right_role_info.arc:setTouchMovedReturnValue(false)
	self.right_role_info.arc:setTouchEndedReturnValue(false)
	self.right_role_info.arc:setTouchEndedFun(nil)
	self.right_role_info.arc:setColor(0x00000000)
	-- self.right_role_info.lock_buniss.view:setCurState(CLICK_STATE_UP)
	-- self.right_role_info.confirm.view:setCurState(CLICK_STATE_DISABLE)
end

-- 初始左栏名字
function BusinessWin:init_left_info(name)
	
	if self.left_role_info == nil then
		return
	end
	
	self.left_role_info.role_name:setText(name)
end

-- 初始右栏名字
function BusinessWin:init_right_info(name)
	
	if self.right_role_info == nil then
		return
	end
	
	self.right_role_info.role_name:setText(name)
end

-- 清除右栏指定格子信息
function BusinessWin:clear_right_item_area_info(id)
	if self.right_role_info.item_area == nil then
		return
	end
	for i = 1, #self.right_role_info.item_area do
		if self.right_role_info.item_area[i].temp_user_item ~= nil and self.right_role_info.item_area[i].temp_user_item.series == id then
			self.right_role_info.item_area[i].temp_user_item = nil
			self.right_role_info.item_area[i]:set_icon_ex(nil)
			self.right_role_info.item_area[i]:set_color_frame(nil)
			self.right_role_info.item_name[i]:setText("")
			self.right_role_info.item_num[i]:setText("")
			break
		end
	end
end
-----------------------------------------------
-----------------------------------------------清除左栏指定格子信息
function BusinessWin:clear_left_item_area_info(id)
	if self.left_role_info.item_area == nil then
		return
	end
	for i = 1, #self.left_role_info.item_area do
		if self.left_role_info.item_area[i].temp_user_item ~= nil and self.left_role_info.item_area[i].temp_user_item.series == id then
			self.left_role_info.item_area[i].temp_user_item = nil
			self.left_role_info.item_area[i]:set_icon_ex(nil)
			self.left_role_info.item_area[i]:set_color_frame(nil)
			self.left_role_info.item_name[i]:setText("")
			self.left_role_info.item_num[i]:setText("")
			break
		end
	end
end
-----------------------------------------------
-----------------------------------------------添加左栏格子信息
function BusinessWin:add_left_item_area_info(info, num)
	for i = 1, #self.left_role_info.item_area do
		if self.left_role_info.item_area[i].temp_user_item == nil then
			self.left_role_info.item_area[i].temp_user_item = info
			self.left_role_info.item_area[i]:set_icon_ex(info.item_id)
			self.left_role_info.item_area[i]:set_color_frame(info.item_id, 0, 0, 50, 50)
			self.left_role_info.item_name[i]:setText( COLOR.r_y .. ItemConfig:get_item_name_by_item_id(info.item_id) )
			self.left_role_info.item_num[i]:setText( COLOR.r_y .. Lang.business[5]..tostring(num) ) -- [660]="数量："
			break
		end
	end
end
-----------------------------------------------
-----------------------------------------------添加右栏格子信息
function BusinessWin:add_right_item_area_info(info, num)
	for i = 1, #self.right_role_info.item_area do
		if self.right_role_info.item_area[i].temp_user_item == nil then
			self.right_role_info.item_area[i].temp_user_item = info
			self.right_role_info.item_area[i]:set_icon_ex(info.item_id)
			self.right_role_info.item_area[i]:set_color_frame(info.item_id, 0, 0, 50, 50)
			self.right_role_info.item_name[i]:setText( COLOR.r_y .. ItemConfig:get_item_name_by_item_id(info.item_id) )
			self.right_role_info.item_num[i]:setText( COLOR.r_y .. Lang.business[5]..tostring(num) ) -- [660]="数量："
			return true
		end
	end
	return false
end
-----------------------------------------------
-----------------------------------------------
function BusinessWin:destroy()
	Window.destroy(self)
	if self.left_role_info then
		self.left_role_info:destroy()
	end
	if self.right_role_info then
		self.right_role_info:destroy()
	end
end
-----------------------------------------------
-----------------------------------------------
function BusinessWin:active(show)
	if show == false then
		BuniessModel:exit_btn_function()
	elseif self.lock_business_btn then
		self.lock_business_btn:setCurState( CLICK_STATE_UP )
	end
end
-----------------------------------------------
-----------------------------------------------设置右栏输入元宝与银两最大数量
function BusinessWin:set_right_max_enter_num(yb,yl)
	if self.right_role_info ~= nil then
		self.right_role_info.yl_editbox.set_max_num(yl)
		self.right_role_info.yb_editbox.set_max_num(yb)
	end
end
