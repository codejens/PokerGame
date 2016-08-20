----QQVIPWin.lua
----HJH
----2013-9-15
----QQVIP礼包面板
super_class.QQVIPAward(Window)
----------------------------------------
---滑动条创建函数
local function scroll_create_fun( self, index )
	---取得当前平台奖励说明信息
	local panel_init_info = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function()
	----------------------------------------
	local info = nil
	local temp_vip_get_info = QQVIPModel:get_vip_info()
	local cur_name = ""
	local disable_btn = false
	--print("index",index)
	local notic_img_path = ""
	if index + 1 == 1 then				------QQVIP新手礼包
		info = QQVipConfig:get_vip_fresh_award_info()
		cur_name = panel_init_info.award_info[1]
		if temp_vip_get_info.get_fresh_award == 1 then
			disable_btn = true
		end
		notic_img_path = UIResourcePath.FileLocate.qqvip .. "fresh_award.png"
	elseif index + 1 == 2 then 			-------------QQVIP每日奖励
		local player = EntityManager:get_player_avatar()
		local vip_info =QQVipInterface:get_qq_vip_platform_info(player.QQVIP)
		if vip_info.vip_level == 0 then
			vip_info.vip_level = 1
		end
		local temp_vip_level = vip_info.vip_level
		local temp_max_vip_level = QQVipConfig:get_vip_max_level()
		if temp_vip_level > temp_max_vip_level then
			temp_vip_level = temp_max_vip_level
		end
		info = QQVipConfig:get_vip_daly_award_info(temp_vip_level)
		cur_name = string.format(panel_init_info.award_info[2], temp_vip_level)
		if temp_vip_get_info.get_today_award == 1 then
			disable_btn = true
		end
		notic_img_path = UIResourcePath.FileLocate.qqvip .. "qq_level_award.png"
	elseif index + 1 == 4 then			----------QQVIP年费奖励
		info = QQVipConfig:get_vip_year_award_info()
		cur_name = panel_init_info.award_info[4]
		if temp_vip_get_info.get_year_award == 1 then
			disable_btn = true
		end
		notic_img_path = UIResourcePath.FileLocate.qqvip .. "year_award.png"
	elseif index + 1 == 3 then			-----------QQ等级奖励
		local player = EntityManager:get_player_avatar()
		local vip_info =QQVipInterface:get_qq_vip_platform_info(player.QQVIP)
		local temp_level
		local tl = player.level
		if vip_info.is_vip == 0 then
			tl = 10
		end
		local temp_level_index = QQVIPModel:get_cur_level_award_index( tl / 10 )
		temp_level_index = math.floor( temp_level_index )
		print("temp_level, temp_level_index", temp_level,temp_level_index)
		info = QQVipConfig:get_vip_level_award_info(temp_level_index * 10)
		cur_name = string.format(panel_init_info.award_info[3],temp_level_index * 10 )
		if temp_vip_get_info.get_level_award[ temp_level_index ] == 1 then
			disable_btn = true 
		end
		notic_img_path = UIResourcePath.FileLocate.qqvip .. "level_award.png"
	end
	----------------------------------------
	local notic_ima = ZImage:create( nil, notic_img_path, -10, 0, -1, -1 )
	notic_ima.view:setAnchorPoint( 0, 1 )
	-- local dialog = Dialog:create( nil, 10, 0, 80, 48, ADD_LIST_DIR_UP, 99999 )
	-- dialog.view:setAnchorPoint( 0 , 1 )
	-- dialog:setText( cur_name )
	----------------------------------------
	local max_height = 70
	local max_vertical_num = 4
	local slot_begin_x = 115
	local slot_cur_x = slot_begin_x
	local slot_begin_y = math.floor( #info / ( max_vertical_num + 1 ) ) * max_height + 20
	local slot_item_info = {}
	-------奖励子项内容
	for i = 1, #info do
		slot_item_info[i] = SlotItem( 48 - 10, 48 - 10 )
		slot_item_info[i]:set_icon_bg_texture( UIPIC_ITEMSLOT, -7, -7, 62 - 10, 62 - 10 )
		------如果是物品
		if info[i].id ~= 0 then
			slot_item_info[i]:set_item_count(info[i].count )
			slot_item_info[i]:set_icon_ex( info[i].id)		
			slot_item_info[i]:set_color_frame( info[i].id )
			slot_item_info[i].color_frame:setSize( 46, 46 )
			slot_item_info[i]:set_item_count( info[i].count)
			slot_item_info[i]:set_gem_level( info[i].id )
		else
			if info[i].type == 3 then
				slot_item_info[i]:set_icon_texture( UILH_JISHOU.yb_48 )
			elseif info[i].type == 1 then
				slot_item_info[i]:set_icon_texture( UILH_JISHOU.yl_48 )
			elseif info[i].type == 0 then
				slot_item_info[i]:set_icon_texture( UIResourcePath.FileLocate.tzfl .. "xb_icon.png" )
			end
		end
		slot_item_info[i].view:setPosition( slot_cur_x, slot_begin_y )
		slot_cur_x = slot_cur_x + 60
		if i % max_vertical_num == 0 and i ~= #info then
			slot_cur_x = slot_begin_x
			slot_begin_y = slot_begin_y - max_height
			max_height = max_height + 60
		end
		--------奖励项点击TIPS函数
		local function slot_click_fun(arg)
			local click_pos = Utils:Split(arg, ":")
			local world_pos = slot_item_info[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
			if info[i].id == 0 then
				local temp_data = { item_id = info[i].type, item_count = info[i].count }
				TipsModel:show_money_tip( world_pos.x, world_pos.y, temp_data )
			else
				TipsModel:show_shop_tip( world_pos.x, world_pos.y, info[i].id, nil, nil, nil, nil, nil, nil)
			end
		end
		slot_item_info[i]:set_click_event( slot_click_fun )
	end
	----------------------------------------
	------领取按钮
	local get_btn = ZTextButton:create( nil, LangGameString[549], UIResourcePath.FileLocate.common .. "button2.png", nil, 395 - 20 - 14, -10, -1, -1 ) -- [549]="领取"
	if disable_btn == true then
		get_btn.view:setCurState(CLICK_STATE_DISABLE)
		get_btn.view:setText(LangGameString[550]) -- [550]="已领取"
	end
	local function get_btn_fun()
		local temp_index = index + 1
		 QQVIPModel:item_get_btn_fun(temp_index)
	end
	get_btn:setTouchClickFun(get_btn_fun)
	get_btn.view:setAnchorPoint( 0, 1 )
	----------------------------------------
	local line = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", 0, 2, 432, 2 )
	----------------------------------------
	local basepanel = ZBasePanel:create( nil, nil, 0, 0, 395, max_height + 10 )
	basepanel:addChild(notic_ima)
	notic_ima:setPosition( 10, max_height )
	get_btn:setPosition( 380 - 20 , max_height-10 )
	for i = 1, #slot_item_info do
		basepanel:addChild( slot_item_info[i] )
	end
	basepanel:addChild( get_btn )
	basepanel:addChild( line )
	----------------------------------------
	-------调整位置
	if index + 1 == 2 then
		-- local player = EntityManager:get_player_avatar()
		-- local vip_info =QQVipInterface:get_qq_vip_platform_info(player.QQVIP)
		-- if vip_info.vip_level == 0 then
		-- 	vip_info.vip_level = 1
		-- end
		-- local temp_vip_level = vip_info.vip_level
		-- local temp_max_vip_level = QQVipConfig:get_vip_max_level()
		-- if temp_vip_level > temp_max_vip_level then
		-- 	temp_vip_level = temp_max_vip_level
		-- end
		-- local level_img = ImageNumber:create( temp_vip_level )
		-- --Image:create( nil, 10, max_height + 20, -1, -1, UIResourcePath.FileLocate.fontEffect .. "sy" ..temp_vip_level .. ".png" )
		-- level_img.view:setAnchorPoint( CCPointMake(0, 1) )
		-- level_img.view:setPosition( 20, max_height + 30 )
		-- basepanel:addChild( level_img )
	elseif index + 1 == 3 then
		local temp_level
		local player = EntityManager:get_player_avatar()
		local vip_info =QQVipInterface:get_qq_vip_platform_info(player.QQVIP)
		local tl = player.level
		if vip_info.is_vip == 0 then
			tl = 10
		end
		local temp_level_index = QQVIPModel:get_cur_level_award_index( tl / 10 )
		temp_level_index = math.floor( temp_level_index )
		info, temp_level = QQVipConfig:get_vip_level_award_info(temp_level_index * 10)
		local level_img = ImageNumber:create( temp_level )
		level_img.view:setAnchorPoint( CCPointMake(0, 1) )
		level_img.view:setPosition( 16, max_height + 24 )
		basepanel:addChild( level_img )
	end
	----------------------------------------
	return basepanel
end
----------------------------------------
local function create_panel( self, x, y, width, height )
	local panel_init_info = QQVipInterface:get_activity_panel_info()
	----------------------------------------
	-----下区域底图
	local top_bg = ZImage:create( nil,  UIPIC_GRID_nine_grid_bg3, 11 - x, height - 128 + y - 290, 760, 60, nil, 600, 600 )
	self:addChild( top_bg.view )
	local top_bg1 = ZImage:create( top_bg,  UIResourcePath.FileLocate.qqvip .. "test_bg.jpg", 2 , 2 ,-1 ,-1 , 0 ,500 )
	----------------------------------------
	-----左区域底图
	local left_bg = ZImage:create( nil, UIPIC_GRID_nine_grid_bg3, 11 - x, height - 128 + y - 226, 438, 320, nil, 600, 600 )
	self:addChild( left_bg.view )
	----------------------------------------
	-----右区域底图
	local right_bg = ZImage:create( nil, UIPIC_GRID_nine_grid_bg3, 11 - x + 440, height - 128 + y - 226, 320, 320, nil, 600, 600 )
	self:addChild( right_bg.view )
	local right_bg1 = ZCCSprite:create( right_bg, UIResourcePath.FileLocate.pet .. "pet_bg2.jpg", 159 , 208)
	right_bg1.view:setScale(0.84)
	----------------------------------------
	----下区域说明图片大图
	--local top_notic_img = ZImage:create( nil, UIResourcePath.FileLocate.qqvip .. "notic_info.png", 31 - x, height - 100 + y - 275 - 18, -1, -1 )
	--self:addChild( top_notic_img.view )
	-- ----------------------------------------
	-- local line_one = Image:create( nil, 215 - x , height - 111 + y, 2, 80, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
	-- line_one.view:setRotation( 3.14 / 2 )
	-- self:addChild( line_one.view )
	----------------------------------------
	-----下区域说明图片小图
	local notic_img_info = { begin_x = 278 - x, begin_y = height - 111 + y - 275 - 29, gap_x = 81, img = UIResourcePath.FileLocate.qqvip .. "notic%d.png" }
	local notic_str = {"蓝钻用户可免费领取蓝钻专属宠物：卓越- 布鲁娃娃","蓝钻用户在角色名前方显示尊贵的蓝钻个性标识"
				,"蓝钻用户在商城购物可享受8折优惠","蓝钻用户可每日领取丰厚的礼包奖励"};
	for i = 1, 4 do
		local function btn_fun()
			NormalDialog:show(notic_str[i],nil,2);
		end
		local temp_img = ZButton:create( nil, string.format( notic_img_info.img, i ),btn_fun, notic_img_info.begin_x, notic_img_info.begin_y, -1, -1 )
		self:addChild( temp_img.view )
		notic_img_info.begin_x = notic_img_info.begin_x + notic_img_info.gap_x
	end
	----------------------------------------
	-----在为QQVIP按钮
	-- self.become_qq_blue_vip = QQVipInterface:QQVipInterface_Create_Platform_QQvip_Recharge_Btn_Function(591 - x, height - 111 + y - 275 - 10, -1, -1)
	-- --Button:create( nil, 591 - x, height - 111 + y - 275 - 10, -1, -1, panel_init_info.btn_image )
	-- self:addChild( self.become_qq_blue_vip.view )
	--self.become_qq_blue_vip:setTouchClickFun( QQVIPModel.qq_blue_vip_btn_fun )
	----------------------------------------
	-----宠物价图片
	local price = ZImage:create( nil, UIResourcePath.FileLocate.qqvip .. "price.png", 453 - x, height - 227 + y + 80 +20, -1, -1 )
	self:addChild( price.view )
	----------------------------------------
	------宠物属性说明
	self.dialog = ZDialog:create( nil, Lang.qqvip_info.blue_pet_info, 460 - x, height - 373 + y + 100 - 70, 316, 90 , 15)
	self:addChild( self.dialog.view )
	--self.dialog:setText(  )
	------宠物名称
	local name = ZLabel:create(self.view, "#cd5c241卓越·布鲁娃娃", 565 - x, 360, 15)	
	----------------------------------------
	-----领取宠物按钮
	self.get_btn = ZImageButton:create( nil, UIResourcePath.FileLocate.common .. "button2_red.png", UIResourcePath.FileLocate.normal .. "get.png",
	nil , 570 - x, height - 394 + y + 100 - 55, 87, 38, 0, 500, 500 )
	self:addChild( self.get_btn.view )
	self.get_btn:setTouchClickFun( QQVIPModel.get_btn_fun)
	----------------------------------------
	-----奖励项滑动条
	self.scroll = ZScroll:create( nil, nil, 14 - x, height - 394 + y + 100 - 60, 434, 320, QQVipConfig:get_vip_award_item_num(), TYPE_HORIZONTAL )
	self:addChild( self.scroll.view )
	self.scroll:setScrollCreatFunction( scroll_create_fun )
	----------------------------------------
	-----宠物动画
	self.pet_spr = MUtils:create_pet_and_mfz( self, QQVipConfig:get_vip_pet_award_info().id, 570, 130 + 140 )
	----------------------------------------
	-- self.skill_slot_item = SlotSkill( 62, 62 )
	-- self.skill_slot_item.view:setPosition( 500 - x, height - 390 + y )
	-- self.skill_slot_item:set_pet_skill_icon( 67, 2 )
	-- self:addChild( self.skill_slot_item.view )
	-- self.skill_slot_item:set_icon_bg_texture( UIPIC_ITEMSLOT, 0, 0, 62, 62 )
	-- --self.skill_slot_item:set_pet_skill_icon( id, level )
	-- local function skill_slot_item_fun( _self, eventType, arg)
	-- 	local skill_struct = PetSkillStruct( nil ,67, 2,0)
	--     local click_pos = Utils:Split(arg, ":")
 --        local world_pos = self.skill_slot_item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
 --        TipsModel:show_pet_skill_tip( world_pos.x, world_pos.y,skill_struct );	
	-- end
	-- self.skill_slot_item:set_click_event( skill_slot_item_fun )
end
----------------------------------------
function QQVIPAward:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	----------------------------------------
	create_panel( self, -1, -10, window_info.width, window_info.height )
	-- ----------------------------------------
	-- local title = ImageImage:create( nil, 0, 0, -1, -1, UIResourcePath.FileLocate.qqvip .. "title.png", UIResourcePath.FileLocate.common .. "win_title1.png" )
	-- title:setGapSize( -10, 3)
	-- self:addChild( title.view )
	-- local title_size = title.view:getSize()
	-- title:setPosition( (width - title_size.width) / 2, height - title_size.height )	
	-- ----------------------------------------
	-- local exit = Button:create( nil, 0, 0, -1, -1, { UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png"} )
	-- self:addChild( exit.view )
	-- local exit_size = exit:getSize()
	-- exit:setPosition( width - exit_size.width, height - exit_size.height )
	-- local function exit_btn_fun()
	-- 	UIManager:hide_window("qqvip_win")
	-- end
	-- exit:setTouchClickFun(exit_btn_fun)
end
----------------------------------------
function QQVIPAward:active_win()
	print("QQVIPAward:active_win")
	if self.pet_spr then
		self.pet_spr:removeFromParentAndCleanup(true)
	end
	local panel_init_info = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function()
	self.pet_spr = MUtils:create_pet_and_mfz( self, QQVipConfig:get_vip_pet_award_info().id, 613, 130 + 106 )
	self:update_win()
end
----------------------------------------
function QQVIPAward:update_win()
	print("QQVIPAward:update_win")
	local vip_info = QQVIPModel:get_vip_info()
	------更新宠物领取按钮
	if vip_info.get_blue_pet == 1 then
		self.get_btn.view:setCurState(CLICK_STATE_DISABLE)
		self.get_btn.image.view:setTexture( UIResourcePath.FileLocate.normal .. "text_4.png" )
	else
		self.get_btn.view:setCurState(CLICK_STATE_UP)
		self.get_btn.image.view:setTexture( UIResourcePath.FileLocate.normal .. "get.png" )
	end
	------更新奖励项内容
	self.scroll:clear()
	self.scroll:refresh()

	if self.become_qq_blue_vip then
		self.become_qq_blue_vip.view:removeFromParentAndCleanup(true);
	end
	self.become_qq_blue_vip = QQVipInterface:QQVipInterface_Create_Platform_QQvip_Recharge_Btn_Function(634 - 1, 429 - 111 -10 - 275 - 10, -1, -1)
	self:addChild( self.become_qq_blue_vip.view )
end