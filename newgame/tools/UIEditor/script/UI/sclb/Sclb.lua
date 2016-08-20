-----------------------------------------------
-----------------------------------------------
---------HJH
---------2013-5-20
---------首冲礼包
super_class.SCLB(Window)
-----------------------------------------------
-----------------------------------------------
-- local effect_id_outside = 57
-- local effect_id_blue = 92
local effect_id_inside = 11009
-- local effect_id_other = 11007
-----------------------------------------------
-- 礼包数据
local award_item_info = nil
local scroll_info = {x = 365, y = 125, width = 450, height = 90, gapSize = 20, maxnum = 1, pageItemNum = 10, ttype = TYPE_VERTICAL }
local award_btn_img = { UILH_BENEFIT.lingqujiangli, UILH_BENEFIT.yilingqu}
local function create_sclb_panel(self, width, height)
	-- 窗口底板
	local panel = self.view
	-- 窗口标题
	-- local frame1 = CCZXImage:imageWithFile( -10, 380, -1, -1, UILH_SCLB.frame )
	-- local bg_size = frame1:getSize()
	-- local frame2 = CCZXImage:imageWithFile( width - bg_size.width + 10, 380, -1, -1, UILH_SCLB.frame )
	-- frame2:setFlipX(true)
	-- 添加一个内框
	panel:addChild( CCZXImage:imageWithFile( 40, 40, -1, -1, UILH_SCLB.bg, 500, 500 ) )
	-- panel:addChild( CCZXImage:imageWithFile( 41, 28, 834, 515, UI_SclbWin_009, 500, 500 ) )
	local t_bg1 = CCZXImage:imageWithFile( 240, 450, -1, -1, UILH_SCLB.title1 )
	-- local t_bg2 = CCZXImage:imageWithFile( 450, 520, -1, -1, UILH_SCLB.title_bg )
	-- t_bg2:setFlipX(true)
	-- t_bg1:addChild( CCZXImage:imageWithFile(120, 30, -1, -1, UILH_SCLB.title1) )
	-- t_bg2:addChild( CCZXImage:imageWithFile(20, 30, -1, -1, UILH_SCLB.title2) )

	local item_bg1 = CCZXImage:imageWithFile( 210, 100, -1, -1, UILH_SCLB.item_bg )
	local item_bg2 = CCZXImage:imageWithFile( 461, 100, -1, -1, UILH_SCLB.item_bg )
	item_bg2:setFlipX(true)

	panel:addChild(t_bg1)
	panel:addChild(t_bg2)
	-- panel:addChild(frame1)
	-- panel:addChild(frame2)
	panel:addChild(item_bg1)
	panel:addChild(item_bg2)
	-- 添加妹子
	-- local is_ckeck_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
	-- if is_ckeck_version then
	-- 	local girl = CCZXImage:imageWithFile( 10, 50, -1, -1, 'nopack/body/41.png', 500, 500 )
	-- 	panel:addChild(girl)
	-- else
	-- 	if Target_Platform == Platform_Type.Platform_91 or Target_Platform == Platform_Type.Platform_ap then
	-- 		local girl = CCZXImage:imageWithFile(10, 50, -1, -1, 'nopack/body/41.png', 500, 500)
	-- 		panel:addChild(girl)
	-- 	else
	-- 		local girl = CCZXImage:imageWithFile(-34, 30, -1, -1, UI_SclbWin_010, 500, 500)
	-- 		girl:setScale(0.9)
	-- 		panel:addChild(girl)
	-- 	end
	-- end
	-- 妹子
	local gril = ZImage:create(panel, "nopack/girl.png", -65, 40, -1, -1)
	gril.view:setScale(0.85)

	ZImage:create(panel, UILH_SCLB.text1, 200, 275, -1, -1)
	ZImage:create(panel, UILH_SCLB.sclb_text, 305, 240, -1, -1)
	local logo_path = "nopack/login_logo4.png"
	local is_test_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_test_version")
    if is_test_version then
        logo_path = 'nopack/login_logo_test.png'
    elseif GetPlatform() == CC_PLATFORM_IOS or Target_Platform == Platform_Type.Platform_MSDK then
        logo_path = 'nopack/login_logo4.png'
    elseif Target_Platform == Platform_Type.Platform_Hoolai then
        logo_path = 'nopack/login_logo5.png'
    elseif Target_Platform == Platform_Type.Platform_Hoolai2 then
        logo_path = 'nopack/login_logo7.png'
    elseif Target_Platform == Platform_Type.Platform_SC or Target_Platform == Platform_Type.Platform_Any 
    	or Target_Platform == Platform_Type.Platform_ZS or Target_Platform == Platform_Type.Platform_sy 
    	or Target_Platform == Platform_Type.Platform_YL or Target_Platform == Platform_Type.Platform_DY then
        logo_path = 'nopack/login_logo6.png'
    else
        logo_path = 'nopack/login_logo3.png'
    end
	local logo_img = ZImage:create(panel, logo_path, 10, 64, -1, -1)
	logo_img.view:setScale(0.5)
	-- ZImage:create(panel, UILH_SCLB.text4, 382, 321, -1, -1)
	ZImage:create(panel, UILH_SCLB.ingot, 640, 160, -1, -1)

	-- 翅膀名字
	-- local wing_name = ZImage:create(panel, UI_SclbWin_018, 65, 95, -1, -1, 3)

	-- bg1.png
	-- panel:addChild( CCZXImage:imageWithFile( 358, 102, -1, -1, UI_SclbWin_004, 500, 500 ), 4 )

	-- 创建tab栏
	self.raido_btn_group = ZRadioButtonGroup:create(self.view, 260, 240,420, 60);
	for i=1, 3 do
		local function btn_fun(eventType,args,msg_id)
            self:do_tab_button_method(i);
        end   
        local btn_img = {UILH_SCLB.first, UILH_SCLB.second, UILH_SCLB.third}
        local btn = ZImageButton:create(nil, {UILH_COMMON.lh_button_4_r, UILH_COMMON.btn4_sel}, btn_img[i], btn_fun, 0, 0, -1, -1)
        self.raido_btn_group:addItem(btn, 20);
	end
	self.award_tab = {};
	award_item_info = SCLBConfig:get_info().sclb_item_info

	-- 单击物品孔
	local function item_click_fun( slot_item, event_type, args, msgid )
		-- 被点击的坐标点
		local position = Utils:Split(args,":");
		if slot_item.item_id then
			local item_type = ItemModel:get_item_type( slot_item.item_id )
			if item_type == ItemConfig.ITEM_TYPE_WING then
				TipsModel:show_wing_tip_by_item_id( position[1], position[2], slot_item.item_id )
			else
				TipsModel:show_shop_tip( position[1],position[2], slot_item.item_id )
			end
		end
	end
	self.curr_select_index = 1;
	local pos_x = 278
	local pos_y = 140
	local int_w = 90
	for i = 1, 5 do
		self.award_tab[i] = SCLB:create_slot_item(nil,pos_x + int_w * ( i - 1 ),pos_y,award_item_info[self.curr_select_index][i].id, 1);
		self.award_tab[i]:set_click_event( item_click_fun )
		panel:addChild(self.award_tab[i].view)
	end
	-- 充点小钱玩一玩按钮
	local func = SCLBModel.send_money_btn_function
	-- UI_SclbWin_007 ->UIPIC_COMMOM_005
	self.recharge_btn = ZButton:create(panel, UILH_NORMAL.special_btn, func, 380.5, 50, -1, -1)
	local img_text = ZImage:create(self.recharge_btn.view, UILH_SCLB.recharge, 71, 26, -1, -1)
	img_text.view:setAnchorPoint(0.5, 0.5)

	-- 领取奖励按钮
	local function get_award_func()
		local can_get_award_state,get_award_state = SCLBModel:get_award_info();
		-- 是否已经领取奖励
		local get_award_record = Utils:get_bit_by_position( get_award_state, self.curr_select_index );
		if get_award_record == 0 then
			OnlineAwardCC:get_recharge_award( 0, self.curr_select_index-1 )
		end
	end
	-- self.get_award_btn = ZButton:create(panel, UILH_NORMAL.special_btn, get_award_func, 500, 34, -1, -1)
	-- self.get_award_btn.view:addTexWithFile(CLICK_STATE_DISABLE,UILH_NORMAL.special_btn_d)
	-- self.get_award_btn_img = ZImage:create(self.get_award_btn.view, UILH_SCLB.get, 81, 26, -1, -1)
	-- self.get_award_btn_img.view:setAnchorPoint(0.5, 0.5)
	self.get_award_btn = ZImageButton:create(panel, UILH_NORMAL.special_btn, award_btn_img[1],get_award_func, 380.5, 34, -1, -1)
	self.get_award_btn.view:addTexWithFile(CLICK_STATE_DISABLE,UILH_NORMAL.special_btn_d)
	-- 添加带翅膀的人物模型
	-- self.playerModel = ShowAvatar:create_wing_panel_avatar( 470, 170 )
	-- self.playerModel:update_wing(2)
	-- self.playerModel:change_attri("body")
	-- panel:addChild(self.playerModel.avatar)
	-- 人物模型脚底的特效
	-- LuaEffectManager:play_view_effect(13, 470, 170, panel, true, 5)
	local function exit_fun()
		UIManager:hide_window("sclb_win")
	end
	self.exit_btn = ZButton:create( nil, {UILH_SCLB.sclb_close, UILH_SCLB.sclb_close}, exit_fun, 0, 0, -1, -1)
	local exit_size = self.exit_btn:getSize()
	-- self.exit_btn:setPosition( width - exit_size.width, height - exit_size.height )
	self.exit_btn:setPosition( 720, 480 )
	local exit_pos = self.exit_btn:getPosition()
	--self.exit_btn:setTouchClickFun(exit_fun)
	self:addChild( self.exit_btn.view )
end

-----------------------------------------------
-----------------------------------------------
function SCLB:__init(window_name, texture_name, is_grid, width, height)
	create_sclb_panel( self, width, height )
end
-----------------------------------------------
-----------------------------------------------
function SCLB:destroy()
	Window.destroy(self)
end

function SCLB:active( show )
	if ( show ) then
		self:update_state();
		for i=1,5 do
			if self.award_tab[i] then
				local spr = self.award_tab[i]:play_activity_effect()
				if spr then
					spr:setAnchorPoint(CCPointMake(0.5,0.5))
					spr:setScale(75/67)
					spr:setPosition(34,34)
				end
			end
		end
	end
end

function SCLB:update_state()
	-- 是否完成首充、是否已经领取奖励
	local can_get_award_state,get_award_state = SCLBModel:get_award_info();
	local get_award_index = 1;
	for i=1,3 do
		local can_get_record = Utils:get_bit_by_position( can_get_award_state, i );
		local get_award_record = Utils:get_bit_by_position( get_award_state, i );
		if can_get_record == 1 and get_award_record == 0 then
			get_award_index = i
			break
		end
	end
	self:do_tab_button_method( get_award_index );
end

function SCLB:create_slot_item( father, pos_x, pos_y, item_id, count )
	local slot_item = SlotItem( 64, 64 );
	slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -9, -9, 83, 83 )
    slot_item:setPosition( pos_x, pos_y )
    slot_item:set_color_frame( item_id, -2, -2, 69, 69 )

    if item_id and count then
    	slot_item:set_icon( item_id )
    	slot_item.item_id = item_id;
    	slot_item:set_item_count(count)
    end

    if father then
    	father:addChild( slot_item.view )
    end

    return slot_item;
end

-- index 显示奖励页的序号
function SCLB:do_tab_button_method(index)
	for i=1,5 do
		self.award_tab[i]:update(award_item_info[index][i].id,1,nil, -2, -2, 69, 69)
		-- 翅膀的tips要特殊处理
		if index == 1 and i == 1 then
			local function fun( self, event_type, args)
				local click_pos = Utils:Split(args, ":")
    			local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
			 	TipsModel:show_wing_tip_by_item_id(world_pos.x, world_pos.y, award_item_info[index][i].id)
			end
			-- print("翅膀tip特殊处理。。。。。。")
			self.award_tab[i]:set_click_event(fun)
		end
	end
	self.raido_btn_group:selectItem(index-1);
	local can_get_award_state,get_award_state = SCLBModel:get_award_info();
	local can_get_record = Utils:get_bit_by_position( can_get_award_state, index )
	local get_record = Utils:get_bit_by_position( get_award_state, index )
	if can_get_award_state == 0 then
		self.recharge_btn.view:setIsVisible(true)
		self.get_award_btn.view:setIsVisible(false)
	else
		if get_record == 0 and can_get_record == 1 then
			self.get_award_btn.view:setCurState(CLICK_STATE_UP)
		else
			self.get_award_btn.view:setCurState(CLICK_STATE_DISABLE)
		end
		if get_record == 1 and can_get_record == 1 then
			self.get_award_btn:set_image_texture(award_btn_img[2])
		else
			self.get_award_btn:set_image_texture(award_btn_img[1])
		end
		self.get_award_btn.view:setIsVisible(true)
		self.recharge_btn.view:setIsVisible(false)
	end

	self.curr_select_index = index;
end