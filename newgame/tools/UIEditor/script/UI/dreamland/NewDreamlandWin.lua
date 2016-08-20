---NewDreamlandWin.lua
----HWL
----2014-12-12
----
super_class.NewDreamlandWin(NormalStyleWindow)

-- 横排icon坐标信息
local hor_pos = {
	int_w = 90,
	[1]	= {x = 22, y = 405 },	--上排
	[2]	= {x = 22, y = 100 },	--下排
}
-- 竖排icon坐标信息
local ver_pos = {
	int_h = 98,
	[1]	= {x = 22, y = 198 },	--左排
	[2]	= {x = 472, y = 198 },	--右排
}

-- 探宝按钮位置信息
-- [1]为1个按钮, [2]为2个按钮,[3]为3按钮
local tb_btn_info = {
	[1] = {x = 234, y = 190},
	[2] = {{x = 184, y = 190}, {x = 284, y = 190}},
	[3] = {{x = 157, y = 190}, {x = 237, y = 190}, {x = 317, y = 190}},
	btn_image = UIPIC_DREAMLAND.tanbao_btn,
	fontSize = 16,
}

--令牌信息
local use_text = {
	[DreamlandModel.DREAMLAND_TYPE_XY] = Lang.dreamland.label_xyjiejing_text, 
	[DreamlandModel.DREAMLAND_TYPE_YH] = Lang.dreamland.label_yhjiejing_text, 
	[DreamlandModel.DREAMLAND_TYPE_RY] = Lang.dreamland.label_ryjiejing_text, 
	[DreamlandModel.DREAMLAND_TYPE_TBS] =Lang.dreamland.label_tbjiejing_text, 
}
--创建物品项
local function create_item_obj(x, y, width, height, item_id)
	local icon = ItemConfig:get_item_icon(item_id)
	local slot_width = width
	local slot_height = height
    local item_obj = SlotBag(slot_width, slot_height);
    local tips_id = item_id
    item_obj:setPosition (x, y);
    item_obj:set_icon_texture(icon);

    function item_obj:set_item_id( id )
    	tips_id = id
    end
    --道具单击事件回调
    local function item_clicked( slot_obj,eventType, args, msgid )
		local click_pos = Utils:Split(args, ":")
        local world_pos = item_obj.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2])))
      	TipsModel:show_shop_tip( world_pos.x,world_pos.y, tips_id);
    end
    if item_id == 18614 or item_id == 18636 or item_id == 18615 or item_id == 38202 or
    	item_id == 38206 or item_id == 48265 then
    else  
   	 	item_obj:set_color_frame( item_id );
   	end
    item_obj:set_click_event(item_clicked);

    return item_obj;
end

--探宝1次
local function tanbao_1_event( )

		Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_TANBO1)
		Analyze:parse_click_main_menu_info(256)
		DreamlandModel:req_tao_bao(1);
end

--探宝10次
local function tanbao_10_event(  )
	Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_TANBO1)
	DreamlandModel:req_tao_bao(10);
end
--探宝50次
local function tanbao_50_event( eventType, arg, msgid, selfItem )
	DreamlandModel:req_tao_bao(50);
end

function NewDreamlandWin:change_dreamlandType(type )
	print("change_dreamlandType",type)
	if type == DreamlandModel.DREAMLAND_TYPE_XY then
		self.radio_btn1:setCurState(CLICK_STATE_DISABLE);
		self.radio_btn2:setCurState(CLICK_STATE_UP);
		self.radio_btn3:setCurState(CLICK_STATE_UP)
		DreamlandModel:req_free_count()
	elseif type == DreamlandModel.DREAMLAND_TYPE_YH then
		-- 月华梦境
		self.radio_btn1:setCurState(CLICK_STATE_UP);
		self.radio_btn2:setCurState(CLICK_STATE_DISABLE);		
		self.radio_btn3:setCurState(CLICK_STATE_UP)
		DreamlandModel:req_free_count()

	elseif type == DreamlandModel.DREAMLAND_TYPE_TBS then
		-- 淘宝树
		--self.radio_btn1_lab:setTexture( UIPIC_DREAMLAND_016 );
		self.radio_btn1:setIsVisible(false)
		self.radio_btn2:setIsVisible(false)
		self.radio_btn3:setIsVisible(false)
		self.radio_btn4:setIsVisible(true)
		--self.radio_btn2:setIsVisible(false);
		self.radio_btn2:setCurState(CLICK_STATE_DISABLE);
		self.radio_btn3:setCurState(CLICK_STATE_DISABLE)

	elseif type == DreamlandModel.DREAMLAND_TYPE_RY then
		-- 月华梦境
		self.radio_btn1:setCurState(CLICK_STATE_UP);
		self.radio_btn2:setCurState(CLICK_STATE_UP);		
		self.radio_btn3:setCurState(CLICK_STATE_DISABLE)
	end

end

--探宝回调
function NewDreamlandWin:tanbao_callback( item_table )
	--更新界面数据
	print("###tanbao_callback###")
	self:update();
	DreamlandModel:req_zhenpin_jilu()

	local count = DreamlandModel:get_item_table_size( )
	self.xb_scroll:clear();
	self.xb_scroll:setMaxNum(count);
	self.xb_scroll:refresh();
end

--获取珍品记录的callback
function NewDreamlandWin:zhenpin_jilu_callback(  )
	local zhenpin_model = DreamlandModel:get_zhenpin_table()
	local count = #zhenpin_model;

	-- if count == self.zp_scroll:getMaxNum() then return end
	if count > 0 then
		self.zp_scroll:clear();
		self.zp_scroll:setMaxNum(count);
		self.zp_scroll:refresh();
	end
end

function NewDreamlandWin:do_tab_choose_fun( dl_type )
	print("NewDreamlandWin:do_tab_choose_fun( dl_type )")
	DreamlandModel:set_dreamland_type(dl_type);
	self:change_dreamlandType(dl_type);
	self.jiejing_lab:setText(LH_COLOR[2]..use_text[dl_type]); -- [889]="#c38ff33星蕴结晶:"
	if dl_type == DreamlandModel.DREAMLAND_TYPE_XY then
		self.btn1_tips.view:setIsVisible(true)
		self.tanbao_money_lab_1:setText(Lang.dreamland.label_yuanbao_take[1]); -- [886]="#c38ff3310元宝"
		self.tanbao_money_lab_2:setText(Lang.dreamland.label_yuanbao_take[2]); -- [887]="#c38ff3390元宝"
		self.tanbao_money_lab_3:setText(Lang.dreamland.label_yuanbao_take[3]); -- [888]="#c38ff33450元宝"
	elseif dl_type ==DreamlandModel.DREAMLAND_TYPE_TBS then
		self.btn1_tips.view:setIsVisible(false)
		self.btn3_tips.view:setIsVisible(false)
		self.tanbao_money_lab_1:setText(Lang.dreamland.label_yuanbao_take[4]); -- [886]="#c38ff3310元宝"
		self.tanbao_money_lab_2:setText(Lang.dreamland.label_yuanbao_take[7]); -- [887]="#c38ff3390元宝"
		self.tanbao_money_lab_3:setText(Lang.dreamland.label_yuanbao_take[8]); -- [888]="#c38ff33450元宝"
	else
		self.btn1_tips.view:setIsVisible(false)
		self.tanbao_money_lab_1:setText(Lang.dreamland.label_yuanbao_take[4]); -- [886]="#c38ff3310元宝"
		self.tanbao_money_lab_2:setText(Lang.dreamland.label_yuanbao_take[5]); -- [887]="#c38ff3390元宝"
		self.tanbao_money_lab_3:setText(Lang.dreamland.label_yuanbao_take[6]); -- [888]="#c38ff33450元宝"
	end
	local items_table = {}
	if dl_type == DreamlandModel.DREAMLAND_TYPE_XY then

		items_table = self.xy_items
	elseif dl_type == DreamlandModel.DREAMLAND_TYPE_YH then
		items_table = self.yh_items
	elseif dl_type == DreamlandModel.DREAMLAND_TYPE_TBS then  --淘宝树配置
		items_table = self.tb_items

	elseif dl_type == DreamlandModel.DREAMLAND_TYPE_RY then
		items_table = self.tb_items
	end
	if #items_table == 0 or items_table == nil then
		return
	end
	self.big_icon_1:set_icon_texture(ItemConfig:get_item_icon(items_table[17]))
	self.big_icon_1:set_color_frame(items_table[17], -2, -2, 78, 78)
	self.big_icon_1:set_item_id(items_table[17])
	self.big_icon_2:set_icon_texture(ItemConfig:get_item_icon(items_table[18]))
	self.big_icon_2:set_color_frame(items_table[18], -2, -2, 78, 78)
	self.big_icon_2:set_item_id(items_table[18])

	-- 横向icon
	for i=1, 12 do
		local item_id = items_table[i];
		local item_slot = self.icon_h_table[i]
		item_slot:set_icon_texture(ItemConfig:get_item_icon(item_id))
		item_slot:set_color_frame(item_id, -2, -2, 58, 58)
		item_slot:set_item_id(item_id)
	end
	for i = 1, 4 do
		local idx = i + 12
		local item_id = items_table[idx];
		local item_slot = self.icon_v_table[idx]
		item_slot:set_icon_texture(ItemConfig:get_item_icon(item_id))
		item_slot:set_color_frame(item_id, -2, -2, 58, 58)
		item_slot:set_item_id(item_id)
	end

	self:change_dreamlandType(DreamlandModel:get_dreamland_type());
	self:update();
	DreamlandModel:req_zhenpin_jilu(  )
 
	local vip = VIPModel:get_vip_info()
	self:showTanbaoBtn_by_vip_level(vip.level)
	DreamlandCC:request_cangku_list();



end

function NewDreamlandWin:choose_xymj_tab()
	self:do_tab_choose_fun(DreamlandModel.DREAMLAND_TYPE_XY)
end

function NewDreamlandWin:choose_yhmj_tab()
	self:do_tab_choose_fun(DreamlandModel.DREAMLAND_TYPE_YH)
end
  
function NewDreamlandWin:choose_tbmj_tba()
	self:do_tab_choose_fun(DreamlandModel.DREAMLAND_TYPE_TBS)
end

--- 从配置里拿取梦境物品列表
function NewDreamlandWin:update_display_items( )

	self.xy_items = (DreamlandConfig:get_dreamland_items())[1];
	self.yh_items = (DreamlandConfig:get_dreamland_items())[2];
	self.tb_items = DreamlandConfig:get_taobao_tree_items();
	self.open_lv  = DreamlandConfig:get_open_lv()

end

------------------------------------------------------------------
------------------ 左边panel -----------------------------------
function NewDreamlandWin:create_left_panel( panel )
	local frame1 = ZImage:create(panel, "nopack/BigImage/dreamland_bg.png", -13, 78, -1, -1)
	local frame2 = ZImage:create(panel, "nopack/BigImage/dreamland_bg.png", 275, 78, -1, -1)
	frame2.view:setFlipX(true)
	local slot_w, slot_h = 54, 54
	self.big_icon_1 = create_item_obj(162, 305, 70, 70 , self.xy_items[17])
    self.big_icon_1:set_icon_bg_texture(UILH_COMMON.slot_bg, -9, -9, 88, 88)
    self.big_icon_1:set_color_frame(self.xy_items[17], -2, -2, 75, 75)
	-- LuaEffectManager:play_view_effect( 11007,slot_w/2,slot_h/2,self.big_icon_1.view,true )
	panel:addChild(self.big_icon_1.view);

	self.big_icon_2 = create_item_obj(317, 305, 70, 70 , self.xy_items[18])
	self.big_icon_2:set_icon_bg_texture(UILH_COMMON.slot_bg, -9, -9, 88, 88)
    self.big_icon_2:set_color_frame(self.xy_items[18], -2, -2, 75, 75)
	-- LuaEffectManager:play_view_effect( 11007,slot_w/2,slot_h/2,self.big_icon_2.view,true )
	panel:addChild(self.big_icon_2.view);

	for i=1,12 do
		--icon
		local item_id = self.xy_items[i];
		local idx = i > 6 and 2 or 1 	--上排还是下排
		local di = math.fmod((i-1),6)
		local px, py = hor_pos[idx].x + hor_pos.int_w * di, hor_pos[idx].y
		--print("itempos x y" .. itempos.x .. " " .. itempos.y)
		local small_item = create_item_obj(px, py, slot_w, slot_h, item_id)
		small_item:set_icon_bg_texture(UILH_COMMON.slot_bg, -9, -9, 73, 73)
    	small_item:set_color_frame(item_id, -2, -2, 58, 58)
    	-- local eff = LuaEffectManager:play_view_effect( 11009, 27, 25, small_item.view, true )
    	-- eff:setScale(54/67)
		panel:addChild(small_item.view);
		--保存icon对象
		self.icon_h_table[i] = small_item;
	end

	for i=1,4 do
		--icon
		local item_id = self.xy_items[12+i];
		local idx = i > 2 and 2 or 1 	--左排还是右排
		local di = math.fmod((i-1),2)
		local px, py = ver_pos[idx].x, ver_pos[idx].y + ver_pos.int_h * di
		--print("itempos x y" .. itempos.x .. " " .. itempos.y)
		local small_item = create_item_obj(px, py, slot_w, slot_h, item_id)
		small_item:set_icon_bg_texture(UILH_COMMON.slot_bg, -9, -9, 73, 73)
    	small_item:set_color_frame(item_id, -2, -2, 58, 58)
    	-- local eff = LuaEffectManager:play_view_effect( 11009, 27, 25, small_item.view, true )
    	-- eff:setScale(54/67)
		panel:addChild(small_item.view);
		--保存icon对象
		self.icon_v_table[12+i] = small_item;
	end
	local function open_cangku( )
		Instruction:handleUIComponentClick(instruct_comps.DREAMLAND_OPENWAREHOUSE)
		UIManager:show_window("dreamland_cangku_win");
	end
	ZImage:create(panel, UILH_COMMON.split_line, 10, 85, 525, 2)
	self.cangku_btn = ZTextButton:create(panel, Lang.dreamland.btn_dreamcangku_text, UILH_COMMON.btn4_nor, open_cangku, 30, 20, -1, -1)
    -- _cangku_btn:setFontSize(16) --设置字体大小
	-- _cangku_btn:setAnchorPoint(1,0);

	--探宝1次按钮
	self.tanbao_btn_1 = ZImageButton:create(panel, tb_btn_info.btn_image, UIPIC_DREAMLAND.tanbao1,tanbao_1_event,tb_btn_info[3][1].x, tb_btn_info[3][1].y, -1, -1);
	local text_bg1 = CCZXImage:imageWithFile(41, -5, -1, -1, UIPIC_DREAMLAND.text_bg)
	self.tanbao_btn_1:addChild(text_bg1)
	text_bg1:setAnchorPoint(0.5, 0.5)
	self.tanbao_money_lab_1 = CCZXLabel:labelWithTextS(CCPointMake(38,10), Lang.dreamland.label_yuanbao_take[1], tb_btn_info.fontSize, ALIGN_CENTER)
	text_bg1:addChild(self.tanbao_money_lab_1)
	local btn_size = self.tanbao_btn_1:getSize()
	self.btn1_tips = ZLabel:create(self.tanbao_btn_1.view, Lang.dreamland.btn_1_tips,btn_size.width/2, btn_size.height+5, 15, 2)
	-- 探宝2次按钮
	self.tanbao_btn_2 = ZImageButton:create(panel, tb_btn_info.btn_image, UIPIC_DREAMLAND.tanbao10,tanbao_10_event,tb_btn_info[3][2].x, tb_btn_info[3][2].y, -1, -1);
	local text_bg2 = CCZXImage:imageWithFile(41, -5, -1, -1, UIPIC_DREAMLAND.text_bg)
	self.tanbao_btn_2:addChild(text_bg2)
	text_bg2:setAnchorPoint(0.5, 0.5)
	self.tanbao_money_lab_2 = CCZXLabel:labelWithTextS(CCPointMake(38,10), Lang.dreamland.label_yuanbao_take[2], tb_btn_info.fontSize, ALIGN_CENTER)
	text_bg2:addChild(self.tanbao_money_lab_2)

	-- 探宝3次按钮
	self.tanbao_btn_3 = ZImageButton:create(panel, tb_btn_info.btn_image, UIPIC_DREAMLAND.tanbao50,tanbao_50_event,tb_btn_info[3][3].x, tb_btn_info[3][3].y, -1, -1);
	local text_bg3 = CCZXImage:imageWithFile(41, -5, -1, -1, UIPIC_DREAMLAND.text_bg)
	self.tanbao_btn_3:addChild(text_bg3)
	text_bg3:setAnchorPoint(0.5, 0.5)
	self.tanbao_money_lab_3 = CCZXLabel:labelWithTextS(CCPointMake(38,10), Lang.dreamland.label_yuanbao_take[3], tb_btn_info.fontSize, ALIGN_CENTER)
	text_bg3:addChild(self.tanbao_money_lab_3)
	self.btn3_tips = ZLabel:create(self.tanbao_btn_3.view, Lang.dreamland.btn_50_tips,btn_size.width/2, btn_size.height+5, 15, 2)
    
	local beg_x = 380
	local beg_y = 24
	local font = 16
	local yb_text = ZLabel:create(panel, LH_COLOR[2] .. Lang.dreamland.label_yuanbao_text, beg_x, beg_y+30, 16)
	self.yuanbao_count = ZLabel:create(panel, "0", beg_x + 70, beg_y + 30, 16)
	self.jiejing_lab = ZLabel:create(panel, LH_COLOR[2] .. Lang.dreamland.label_xyjiejing_text, beg_x, beg_y, 16)
	self.jiejin_count = ZLabel:create(panel, "0", beg_x + 70, beg_y, 16)

	return panel
end

------------------------------------------------------------------
------------------ 右上角panel -----------------------------------
function NewDreamlandWin:create_zhenpin_item( row )
	local row_panel = CCBasePanel:panelWithFile(0, 0, 265, 73, nil)
	self.zp_scroll:addItem(row_panel)

	local zhenpin_table_model = DreamlandModel:get_zhenpin_table();
	if #zhenpin_table_model <= 0 then return end
	local zhenpin_item_model = zhenpin_table_model[row+1];
	
	print("活动的道具ＩＤ",zhenpin_item_model.item_id)
	--珍品点击的事件
	local function zhenpin_item_event( )
		TipsModel:show_shop_tip( 223,395, zhenpin_item_model.item_id);
	end

	local slot_item = SlotItem(50, 50)
	slot_item:set_icon_bg_texture(UILH_COMMON.slot_bg2, -6, -6, 62, 62)
	slot_item:set_icon(zhenpin_item_model.item_id)
	slot_item:set_color_frame(zhenpin_item_model.item_id, 0, 0, 51, 51)
	slot_item:set_item_count(1);
	slot_item:set_click_event(zhenpin_item_event)
	slot_item.view:setPosition(20, 14)
	row_panel:addChild(slot_item.view)
	-- slot_item.view:setAnchorPoint(0.5, 0)

	--仙友名字
	local name_str = string.format("#cffffff%s", tostring(zhenpin_item_model.user_name));

  	local xianyou_name = TextButton:create(nil, 185, 37, 120, 20, name_str);
  	xianyou_name:setFontSize(18)
  	xianyou_name.view:setAnchorPoint(0.5, 0.5)
  	row_panel:addChild(xianyou_name.view);

  	local user_data = {
	  	roleId = zhenpin_item_model.user_id,
	  	roleName = zhenpin_item_model.user_name, 
	  	level = zhenpin_item_model.user_level, 
	  	camp = zhenpin_item_model.user_camp,
	  	job = zhenpin_item_model.user_job,
	  	sex = zhenpin_item_model.user_sex, 
	  	qqvip = zhenpin_item_model.qqVip
	};
  	
  	local function show_left_click_menu(  )
  		if EntityManager:get_player_avatar().id ~= user_data.roleId then
  			LeftClickMenuMgr:show_left_menu( "chat_other_list_menu" ,user_data);
  		end
  	end
  	xianyou_name:setTouchClickFun(show_left_click_menu);

  	--珍品列表分割线
  	
  	local split_line = ZImage:create(row_panel, UIPIC_DREAMLAND.split_line, 0, 0, 260, 2, 0, 500)
	self.zp_scroll:refresh()

end

function NewDreamlandWin:create_right_up_panel( panel )
	local panel_size = panel:getSize()
	local width, height = panel_size.width, panel_size.height
	local title_bg = ZImage:create(panel, UILH_NORMAL.title_bg4, 2, height - 36, width - 4, -1)
	local title1 = ZLabel:create(title_bg, Lang.dreamland_info.zhenpin_record.tab_text, 25, 7, 18)
	local title2 = ZLabel:create(title_bg, Lang.dreamland_info.zhenpin_record.xingyunrenzhe, 150, 7, 18)
	self.zp_scroll = CCScroll:scrollWithFile(8, 8, width - 26, height - 45, 0, "", TYPE_HORIZONTAL)
	self.zp_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 25, 11)
	panel:addChild(self.zp_scroll)
	local arrow_up = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_up, width - 18, height - 47, -1, -1)
	local arrow_down = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_down, width - 18, 8, -1, -1)
	local function scrollfun(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return false
		end

		local temparg = Utils:Split(arg,":")
		local row = temparg[1]	--列数
		-- local ver = temparg[2]	--行数
		if row == nil then 
			return false;
		end
		--间距大小
		if eventType == SCROLL_CREATE_ITEM then
			self:create_zhenpin_item(row)
		end
		return true
	end
	self.zp_scroll:registerScriptHandler(scrollfun)
	self.zp_scroll:refresh()
	return panel
end


------------------------------------------------------------------
-- 右下角panel ---------------------------------------------------
function NewDreamlandWin:create_xunbao_scroll(row)
	local row_panel = CCBasePanel:panelWithFile(0, 0, 265, 73, nil)
	self.xb_scroll:addItem(row_panel)

	local xunbao_table = DreamlandModel:get_item_table()
	if #xunbao_table < row + 1 then return end
	local xunbao_item = xunbao_table[row+1];
	
	--珍品点击的事件
	local function xunbao_item_event( )
		TipsModel:show_shop_tip( 223,158, xunbao_item.id);
	end

	local slot_item = SlotItem(50, 50)
	slot_item:set_icon_bg_texture(UILH_COMMON.slot_bg2, -6, -6, 62, 62)
	slot_item:set_icon(xunbao_item.id)
	slot_item:set_color_frame(xunbao_item.id, 0, 0, 51, 51)
	-- slot_item:set_item_count(1);
	slot_item:set_click_event(xunbao_item_event)
	slot_item.view:setPosition(20, 14)
	row_panel:addChild(slot_item.view)
	-- slot_item.view:setAnchorPoint(0.5, 0)

	local numStr = string.format("x%d", xunbao_item.count)
	--数量
  	local xianyou_name = ZLabel:create(row_panel, numStr,185, 30, 20, 2)

  	--珍品列表分割线
  	
  	local split_line = ZImage:create(row_panel, UIPIC_DREAMLAND.split_line, 0, 0, 260, 2, 0, 500)
	self.xb_scroll:refresh()
end

function NewDreamlandWin:create_right_down_panel( panel )
	local panel_size = panel:getSize()
	local width, height = panel_size.width, panel_size.height
	local title_bg = ZImage:create(panel, UILH_NORMAL.title_bg4, 2, height - 36, width - 4, -1)
	local title = ZLabel:create(title_bg, Lang.dreamland_info.tanbao_state.tab_text, 105, 7, 18)
	self.xb_scroll = CCScroll:scrollWithFile(8, 8, width - 26, height - 45, 0, "", TYPE_HORIZONTAL)
	self.xb_scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 25, 11)
	panel:addChild(self.xb_scroll)
	local arrow_up = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_up, width - 18, height - 47, -1, -1)
	local arrow_down = ZImage:create(panel, UIPIC_DREAMLAND.scrollbar_down, width - 18, 8, -1, -1)
	local function scrollfun(eventType, arg, msgid)
		if eventType == nil or arg == nil or msgid == nil then
			return false
		end

		local temparg = Utils:Split(arg,":")
		local row = temparg[1]	--列数
		-- local ver = temparg[2]	--行数
		if row == nil then 
			return false;
		end
		--间距大小
		if eventType == SCROLL_CREATE_ITEM then
			self:create_xunbao_scroll(row)
		end
		return true
	end
	self.xb_scroll:registerScriptHandler(scrollfun)
	self.xb_scroll:refresh()

	return panel
end

function NewDreamlandWin:__init(window_name, texture_name, is_grid, width, height)
	-- 获取配置信息
	self:update_display_items( );
	self.icon_h_table = {}	--横排icon
	self.icon_v_table = {}	--竖排icon
	-- local player = 
	local tab_text = Lang.dreamland.tab_text
	-- for i = 1, 2 do
		-- local temp = ZImageButton:create( nil, { UI_JISHOUWIN_015, UI_JISHOUWIN_016}, tab_info[i][1], nil,  0, 0, -1, -1)
		-- temp:setTouchClickFun(btn_fun)
		-- self.radio_button:addItem( temp,6 )
	-- 	self:create_a_button(self.radio_button, 0, 0, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, tab_text[i], i)
	-- end
	-- 阿房废墟按钮
	self.radio_btn1 = self:create_a_button(self.view, 22, 520, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, tab_text[1], 1)
	-- 西周遗冢
	self.radio_btn2 = self:create_a_button(self.view, 122, 520, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, tab_text[2], 2)
	self.radio_btn2:setIsVisible(false)
	-- 皇陵天宫
	self.radio_btn3 = self:create_a_button(self.view, 222, 520, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, tab_text[3], 2)
	self.radio_btn3:setIsVisible(false)

	self.radio_btn4 = self:create_a_button(self.view, 22, 520, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, Lang.dreamland.taobao_tree, 3)
	self.radio_btn4:setIsVisible(false)


	local panel_info	= { x = 8, y = 17, width = 885, height = 510 }	--大背景
	local left_info		= {x = 15, y = 15, width = 550, height = 480 }	--左边的panel
	local right_up_info		= {x = 570, y = 255, width = 295, height = 240 }	--右上的panel
	local right_down_info		= {x = 570, y = 15, width = 295, height = 240 }	--右下的panel

	-- 添加一层背景
	local tmpBg = CCBasePanel:panelWithFile( panel_info.x, panel_info.y, panel_info.width, panel_info.height, UILH_COMMON.normal_bg_v2, 500, 500 )
	self.view:addChild( tmpBg )
	-- 左边背景
	local left_panel = CCBasePanel:panelWithFile( left_info.x, left_info.y, left_info.width, left_info.height, UILH_COMMON.bottom_bg, 500, 500 )
	tmpBg:addChild( left_panel )
	-- 右上背景
	local rightUp_panel = CCBasePanel:panelWithFile( right_up_info.x, right_up_info.y, right_up_info.width, right_up_info.height, UILH_COMMON.bottom_bg, 500, 500 )
	tmpBg:addChild( rightUp_panel )
	-- 右下背景
	local rightDown_panel = CCBasePanel:panelWithFile( right_down_info.x, right_down_info.y, right_down_info.width, right_down_info.height, UILH_COMMON.bottom_bg, 500, 500 )
	tmpBg:addChild( rightDown_panel )

	self.left_panel = self:create_left_panel(left_panel)
	self.rightUp_panel = self:create_right_up_panel(rightUp_panel)
	self.rightDown_panel = self:create_right_down_panel(rightDown_panel)
	DreamlandModel:req_free_count()
end
function NewDreamlandWin:active(show)
	if show then
		-- print("梦境类型",DreamlandModel:get_dreamland_type())
		-- self:change_dreamlandType(DreamlandModel:get_dreamland_type());
		-- self:update();
		-- DreamlandModel:req_zhenpin_jilu(  )
 
		-- local vip = VIPModel:get_vip_info()
		-- self:showTanbaoBtn_by_vip_level(vip.level)
		-- DreamlandCC:request_cangku_list();
		local eff1 = LuaEffectManager:play_view_effect( 11007,35,35,self.big_icon_1.view,true )
		local eff2 = LuaEffectManager:play_view_effect( 11007,35,35,self.big_icon_2.view,true )
		eff1:setScale(70/67)
		eff2:setScale(70/67)
	else
		LuaEffectManager:stop_view_effect( 11007,self.big_icon_1.view )
		LuaEffectManager:stop_view_effect( 11007,self.big_icon_2.view )
	end
end

function NewDreamlandWin:update_yuanbao(  )
	--设置元宝数量
	if self.yuanbao_count then
		local avatar = EntityManager:get_player_avatar();
		local yuanbao_str = string.format("%d", avatar.yuanbao);
		self.yuanbao_count:setText(yuanbao_str);	
	end
end

function NewDreamlandWin:update(  )

	self:update_yuanbao()
   
	local dream_type = DreamlandModel:get_dreamland_type();
	--获得当前梦境对应的结晶
	local crystal_id = DreamlandModel:get_current_crystal();
	local jiejin_str = string.format("%d",ItemModel:get_item_count_by_id( crystal_id ));
	self.jiejin_count:setText(jiejin_str);

	-- 判断是否达到了50级开启月华梦境
	local avatar = EntityManager:get_player_avatar();
	local type = DreamlandModel:get_dreamland_type( );
	if avatar.level < 50 then
		self.radio_btn2:setIsVisible(false)
		--dream_tab_ry:setIsVisible(false)
	elseif avatar.level >= 50 then
		self.radio_btn2:setIsVisible(true)
		--dream_tab_ry:setIsVisible(false)
	elseif avatar.level >= 60 then
		-- self.radio_btn3:setIsVisible(true)
		--dream_tab_ry:setIsVisible(true)
	end

	if dream_type ==DreamlandModel.DREAMLAND_TYPE_TBS then
		self.radio_btn1:setIsVisible(false)
		self.radio_btn2:setIsVisible(false)
		self.radio_btn3:setIsVisible(false)
		self.radio_btn4:setIsVisible(true)

		self.window_title:setTexture(UILH_MAINACTIVITY.taobaoshu_title)
		self.tanbao_btn_1:set_image_texture(UILH_MAINACTIVITY.taobao1)
		self.tanbao_btn_2:set_image_texture(UILH_MAINACTIVITY.taobao10)
		self.tanbao_btn_3:set_image_texture(UILH_MAINACTIVITY.taobao50)
	end

end
function NewDreamlandWin:showTanbaoBtn_by_vip_level( vip_level )
	if vip_level <= 3 then 
		self.tanbao_btn_1:setPosition(tb_btn_info[1].x,tb_btn_info[1].y);
		-- _tip_lab:setPosition(_tip_lab_pos);
		self.tanbao_btn_2.view:setIsVisible(false);
		self.tanbao_btn_3.view:setIsVisible(false);
	elseif vip_level >= 4 and vip_level <6 then
		self.tanbao_btn_1:setPosition(tb_btn_info[2][1].x,tb_btn_info[2][1].y);
		-- _tip_lab:setPosition(_tip_lab_pos);
		self.tanbao_btn_2.view:setIsVisible(true);
		self.tanbao_btn_2:setPosition(tb_btn_info[2][2].x,tb_btn_info[2][2].y);
		self.tanbao_btn_3.view:setIsVisible(false);
	elseif vip_level >=6 then
		self.tanbao_btn_1:setPosition(tb_btn_info[3][1].x,tb_btn_info[3][1].y);
		-- _tip_lab:setPosition(_tip_lab_pos);
		self.tanbao_btn_2.view:setIsVisible(true);
		self.tanbao_btn_3.view:setIsVisible(true);
		self.tanbao_btn_2:setPosition(tb_btn_info[3][2].x,tb_btn_info[3][2].y);
		self.tanbao_btn_3:setPosition(tb_btn_info[3][3].x,tb_btn_info[3][3].y);		
	end
end
------------------------------------------------
-- 标签选项
function NewDreamlandWin:create_a_button( panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, index )
    -- local radio_button = ZTextButton:create(nil, but_name, {image_n,image_s}, nil, pos_x, pos_y, size_w, size_h)
	local radio_button = ZButton:create(nil, {image_n,image_s}, nil, pos_x, pos_y, size_w, size_h)
	radio_button.view:addTexWithFile(CLICK_STATE_DISABLE, image_s)
	local radio_text = ZLabel:create(radio_button.view, but_name, 50, 12, 16, 2)
	local function btn_fun()
		self:do_tab_choose_fun(index)
	end
    radio_button:setTouchClickFun(btn_fun)
    panel:addChild(radio_button.view)
    return radio_button.view
end

-- 改变免费次数的提示信息
function NewDreamlandWin:change_free_tips(count)
	local tips_text = ""
	if count > 0 then
		tips_text = Lang.dreamland.btn_1_tips
	else
		tips_text = Lang.dreamland.btn_1_tips2
	end
	self.btn1_tips:setText(tips_text)
end

function NewDreamlandWin:destroy()
	-- for i, item in ipairs(self.icon_v_table) do
	-- 	LuaEffectManager:stop_view_effect( 11009, item.view )
	-- end
	-- for i, item in ipairs(self.icon_h_table) do
	-- 	LuaEffectManager:stop_view_effect( 11009, item.view )
	-- end
	LuaEffectManager:stop_view_effect( 11007, self.big_icon_1.view )
	LuaEffectManager:stop_view_effect( 11007, self.big_icon_2.view )
	Window.destroy(self)
end
