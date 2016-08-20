----JiShouWin.lua
----HJH
----2013-7-25
----
super_class.JiShouWin(NormalStyleWindow)
local _special_page_index = -1
local last_select = 1 --用于搜索返回时的显示
local quality_select_panel = nil
local money_select_panel = nil
--local _is_next_not_show = false
-----------------------------------------
function JiShouWin:get_special_page_index()
	return _special_page_index
end
-----------------------------------------
local _index_page_cur_select = {}
-----------------------------------------
-------寄售物品名称
function JiShouWin:change_page(index)
	-- print("JiShouWin:change_page(index)",index)
	--local temp_info = { 0, 0, 0, 1, 1, 2, 2, 3, 3, 3, 4, 4, 5, 6 }
	JiShouModel:set_cur_top_page_select(index)
	self.radio_button:selectItem( index - 1 )
	if index == _special_page_index then
		local temp_index = JiShouModel:get_index_page_cur_select(index)
		JiShouModel:set_cur_page_select(temp_index)
	end
	self.search_container.view:setIsVisible(false)
	for i = 1, #self.left_container do
		if i == index then
			self.left_container[i].view:setIsVisible(true)
			local temp_index = JiShouModel:get_index_page_cur_select(i)
			JiShouModel:set_cur_page_select(temp_index)
		else
			self.left_container[i].view:setIsVisible(false)
		end
	end
	self.return_button.view:setIsVisible(false)
	self.serch_button.view:setCurState(CLICK_STATE_UP)
	if index==9 then
		self.serch_button.view:setCurState(CLICK_STATE_DISABLE)
		local temp_index = JiShouModel:get_index_page_cur_select(index)
		JiShouModel:set_cur_page_select(temp_index)
		self.search_container.view:setIsVisible(true)
		self.return_button.view:setIsVisible(true)
	else
		last_select = index
	end
end
-----------------------------------------
function JiShouWin:update_yb_and_yl(yb, yl)
	if self.yb_num ~= nil and self.yl_num ~= nil then
		self.yb_num:setText(yb)
		self.yl_num:setText(yl)
	end
end
-----------------------------------------
local function create_left_panel(self, x, y, width, height, num)
	self.left_container = {}
	self.search_container = {}
	local temp_info = {
		btn_bg_path = { UILH_JISHOU.left_btn_nor, UILH_JISHOU.left_btn_sel },
		btn_base_path = "ui/lh_jishou/left_"; 
		btn_fun = {
			-- 装备材料
			{ JiShouModel.item_level_btn_fun, JiShouModel.item_tp_btn_fun,JiShouModel.item_sj_btn_fun},
			-- 宝石强化
			{ JiShouModel.gem_btn_fun, JiShouModel.strengthen_btn_fun},
			-- 式神坐骑
			{ JiShouModel.wing_btn_fun, JiShouModel.trump_btn_fun},
			-- 通灵兽
			{ JiShouModel.pet_egg_btn_fun, JiShouModel.pet_pei_btn_fun, JiShouModel.mount_btn_fun},
			-- 药品消耗
			{ JiShouModel.role_medicine_btn_fun, JiShouModel.pet_medicine_btn_fun},
			-- 元宝银两
			{ JiShouModel.yb_btn_fun},
			--其他道具
			{  JiShouModel.other_btn_fun},
			
		}
	};
	for i = 1, num do
		local radio_button = ZRadioButtonGroup:create( nil, x, y, width, height, 1 )
		local fun_tab = temp_info.btn_fun[i]
		local btn_num = #fun_tab;
		for j = 1, btn_num do
			local temp_btn = ZImageButton:create( nil, temp_info.btn_bg_path,string.format("%s%d%d.png",temp_info.btn_base_path,i,j), fun_tab[j], 0, 0, -1, -1 )
			-- temp_btn:setTouchClickFun( temp_info[i][j].fun )
			--分割线
		--	local temp_btn_size = temp_btn:getSize()
		--	local temp_line = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", -2,  -5, 160, 2 )
		--	temp_btn.view:addChild(temp_line.view)
			--文字间距
			radio_button:addItem( temp_btn , -2)
		end
		self.left_container[i] = radio_button
		self:addChild( radio_button.view)
	end
end
-----------------------------------------
--搜索面板
function JiShouWin:create_search_panel( ... )
	self.equip_type = 0 		--所选物品种类
	self.item_lv = 0 	--所选物品等级
	self.item_quality = -1 	--所选物品品质
	self.price_lv = 0 	--所选价格范围
	self.money_type = 0 	--所选货币类型
	self.job_type = 0   --所选职业
	--ui/common/buykey_bg.png
	local search_bg =ZBasePanel:create(self.view, "", 12, 100, 240, 428, 500, 500)
	--search_bg.view:setIsVisible(false)
	self.item_name = ZEditBox:create(search_bg, 30, 360, 188,40,10,14,UILH_COMMON.bg_02,500,500)
	self.item_name:setText(Lang.jiShou.search_key)
	--self.condition_notice = ZLabel:create(self.item_name, "输入关键字", 10,0, 16, ALIGN_CENTER )
    --全部品质
    local function but_1_fun()
        -- LeftClickMenuMgr:show_left_menu( "item_quality_list", {})
        if quality_select_panel ~= nil then
			local result = quality_select_panel:getIsVisible()
			quality_select_panel:setIsVisible(not result)
		end
    end
    self:create_left_click(Lang.jiShou.item_sel_quality, "item_quality", 43, 107, 188, 40)
    self.quality_list_panel =ZBasePanel:create(search_bg,UILH_COMMON.bg_02, 30, 290, 188, 40, 500, 500)
    self.quality_list_panel:setTouchClickFun( but_1_fun )
    local push_but = ZImage:create(self.quality_list_panel, UILH_JISHOU.arrow, 145, -1, -1, -1) -- 下拉按钮
    push_but.view:setDefaultMessageReturn(false)  -- 设置可穿透
    self.item_quality_name =ZLabel:create(self.quality_list_panel, Lang.jiShou.quality, 87, 10, 15, ALIGN_CENTER )

    --货币类型
    local function but_2_fun()
        -- LeftClickMenuMgr:show_left_menu( "money_type_list", {})
        if money_select_panel ~= nil then
			local result = money_select_panel:getIsVisible()
			money_select_panel:setIsVisible(not result)
		end
    end
    self:create_left_click(Lang.jiShou.money_sel_type, "money_type", 42, 188, 188, 40)
    self.money_list_panel =ZBasePanel:create(search_bg,UILH_COMMON.bg_02, 30, 210, 188, 40, 500, 500)
    self.money_list_panel:setTouchClickFun( but_2_fun )
    local push_but = ZImage:create(self.money_list_panel, UILH_JISHOU.arrow, 145, -1, -1, -1) -- 下拉按钮
    push_but.view:setDefaultMessageReturn(false)  -- 设置可穿透
    self.money_type_name =ZLabel:create(self.money_list_panel, Lang.jiShou.money_type, 87, 10, 15, ALIGN_CENTER )

 	local function search_now( ... )
 		self:search_fun( )
 	end
    ZTextButton:create(search_bg, Lang.jiShou.start, UILH_COMMON.btn4_nor, search_now, 61, 20, -1, -1) 

    self.search_container = search_bg
end
--根据tab_info创建下拉框, 
--tab_info 下拉框内容
function JiShouWin:create_left_click(tab_info, sel_type, x, y, width, theight)
	local sell_time_select = ZRadioButtonGroup:create( nil,  x, y, width, #tab_info*theight, 1, UILH_COMMON.bg_10, 600, 600)
	-- sell_time_select.view:setOpacity(175)
	if sel_type == "money_type" then
		money_select_panel = sell_time_select.view
	elseif sel_type == "item_quality" then
		quality_select_panel = sell_time_select.view
	end
	self.view:addChild(sell_time_select.view, 501)
	sell_time_select.view:setIsVisible(false)
	for i = 1, #tab_info do
		-- local temp = ZTextButton:create( nil, time_info[i], UIResourcePath.FileLocate.normal .. "empyt_tex.png", nil, 0, 0, 88 + 30, 25, nil, 600, 600 )
		local temp = ZButton:create(nil, "", nil, 0, 0, width, theight)
		local lab = ZLabel:create(temp.view, tab_info[i], 94, 15, 16, ALIGN_CENTER)
		sell_time_select:addItem( temp, 0, 1 )
		local function time_btn_fun()
			local temp_index = i
			local win = UIManager:find_visible_window("ji_shou_win")
			if win then
				if sel_type == "money_type" then
					local type_index = {0, 1, 3}
					win:set_select_money(type_index[temp_index],tab_info[temp_index])
					money_select_panel:setIsVisible(false)
				elseif sel_type == "item_quality" then
					local quality_index = {-1, 0, 1, 2, 3, 4, 5}
					win:set_select_quality(quality_index[temp_index],tab_info[temp_index])
					quality_select_panel:setIsVisible(false)
				end
			end
		end
		temp:setTouchClickFun(time_btn_fun)
	end
	return sell_time_select
end
function JiShouWin:get_search_name()
	return self.item_name:getText()
end
function JiShouWin:get_search_money_type(  )
	return self.money_type
end
-- 搜索事件
function JiShouWin:search_fun( ... )
	local id_list = {}
	local prefix = "../data/"
	local data_name = "std_items"
	local name = self.item_name:getText()
	if name~="" then
		print("输入的内容",name)
		for i=0,150 do
			local config_index = data_name .. i
			local config = _G[config_index]
			if config then
				for k,v in pairs(config) do			
					local p = string.find(v.name, name)
					if p~=nil then
						--print("物品名称",v.name)
						table.insert(id_list,v.id)
					end
				end
			end
		end
	end

	local num = #id_list
	local min_price_lv = 0  --最小价格
	local min_item_lv = 0  --最小等级
	if self.price_lv~= 0 then
		min_price_lv = 1
	end
	if self.item_lv~= 0 then
		min_item_lv = 1
	end
	if num>2 then
		id_list = JiShouWin:sort_id_list(id_list )
	end
	JiShouModel:init_serch_page_info()
	--self:set_scroll_max_num( _page_serch_info[index].max_num )
	self:clear_scroll()
	--self:refresh_scroll()
	local temp_index = JiShouModel:check_serch_send_index(16)
	print("self.money_type",self.money_type,temp_index)
	JiShouCC:send_find_item(4, temp_index, -1, min_price_lv, self.price_lv, self.item_quality, min_item_lv, self.item_lv, self.job_type, num, id_list,self.money_type)

end
-- 排序ID列表
function JiShouWin:sort_id_list(id_list )
	print("排序ID列表")
	local function sort_fun(a,b)
		if a ~= nil and b ~= nil then
			if a > b then
				return true
			else
				return false
			end
		end
	end
	table.sort( id_list, sortfunction )
	return id_list
end

function JiShouWin:get_select_quality(  )
	return self.item_quality
end

-- 设置 寄售搜索 物品品质
function JiShouWin:set_select_quality( index, param )
	self.item_quality   = index
	self.item_quality_name:setText(param)
end

-- 设置 寄售搜索 货币类型
function JiShouWin:set_select_money( index, param )
	self.money_type    = index
	self.money_type_name:setText(param)
end

-------右边拖动区域
local function scroll_create_fun(self, index)
	--每个纵列表的宽度
	local size_info = { 90, 130, 40, 150, 85, 120 }
	local cur_page_select = JiShouModel:get_cur_page_select()
	local select_info = JiShouModel:data_get_index_data_info( cur_page_select )
	local temp_info = select_info.info
	if temp_info[index + 1] == nil then
		if select_info.is_send == false then
			JiShouModel:set_index_page_is_send( cur_page_select, true )
			JiShouModel:get_index_page_info( cur_page_select )
			return nil
		else
			if os.time() - select_info.refresh_time > JiShouModel:get_scroll_refresh_limit_time() then
				JiShouModel:set_index_page_is_send( cur_page_select, false )
				print("select_info.refresh_time",select_info.refresh_time, os.time())	
			end
			return nil
		end
	end

	local panel_size = { width = 585, height = 95 }
	local list_ver = ZListVertical:create( nil, 0, 0, panel_size.width, panel_size.height, size_info, 2, 2 )
	--local temp_panel = BasePanel:create( nil, 0, 0, panel_size.width, panel_size.height )
	-----------------------
	local leve_num = 1
	local job_text_info = Lang.jiShou.job_text_info[1]
	local slot_item = SlotItem(64, 64)
	slot_item:setPosition( 12, 2 );
	local function slot_click_fun(slot_obj,eventType, arg, msgid)
		local click_pos = Utils:Split(arg, ":")
		local world_pos = slot_item.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
		if temp_info[index + 1].bag_item ~= nil then
			TipsModel:show_tip( world_pos.x, world_pos.y, temp_info[index + 1].bag_item, nil, nil, nil, nil, nil, nil)
		else
			local temp_date = { item_id = temp_info[index + 1].send_money_type, item_count = temp_info[index + 1].send_money }
			TipsModel:show_money_tip( world_pos.x, world_pos.y, temp_date )
		end
	end
	slot_item:set_click_event(slot_click_fun)
	slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -11, -10, 82, 82 )
	if temp_info[index + 1].type == 0 then
		local item_id = temp_info[index + 1].bag_item.item_id 
		local series = temp_info[index + 1].bag_item.series
		slot_item:set_icon_ex( item_id )
		slot_item:set_color_frame( item_id )
		slot_item:set_item_count( temp_info[index + 1].bag_item.count )
		list_ver:addItem( slot_item, true, true )
		local item_name = ItemConfig:get_item_name_by_item_id( item_id )
		local temp_item_quality = temp_info[index + 1].bag_item.quality + 1
		if temp_item_quality <= 0 then
			temp_item_quality = 1 
		elseif temp_item_quality > 6 then
			temp_item_quality = 6
		end
		local slot_item_name_lab = ZLabel:create(nil, string.format("%s%s%s","#c",ItemConfig:get_item_color(temp_item_quality), item_name), 0, 0, 14 )
		list_ver:addItem( slot_item_name_lab, false, true )
		local item_conds_info = ItemConfig:get_conds_info( item_id )
		----------取得使用等级与职业
		for i = 1, #item_conds_info do
			if item_conds_info[i].cond == 1 then
				leve_num = item_conds_info[i].value
			end
			---------
			if item_conds_info[i].cond == 3 then
				job_text_info = Lang.jiShou.job_text_info[ item_conds_info[i].value + 1]
			end
		end
	else
		local money_name = ""
		--print("temp_info[index + 1].sell_money_type ",temp_info[index + 1].sell_money_type )
		if temp_info[index + 1].send_money_type == 3 then
			slot_item:set_icon_texture(UILH_JISHOU.yb_48)
			money_name = ""
		else
			slot_item:set_icon_texture(UILH_JISHOU.yl_48)
			money_name = ""
		end
		list_ver:addItem( slot_item, true, true )
		--local item_name = ItemConfig:get_item_name_by_item_id( item_id )
		print("temp_info[index+1].type,temp_info[index+1].send_money,temp_info[index+1].send_money_type",temp_info[index+1].type,temp_info[index+1].send_money,temp_info[index+1].send_money_type)
		local slot_item_name_lab = ZLabel:create(nil, string.format("%d%s", temp_info[index + 1].send_money, money_name), 0, 0 )
		list_ver:addItem( slot_item_name_lab, false, true )		
	end
	-------------------------
	local used_level_lab = ZLabel:create( nil, tostring(leve_num), 0, 0 )
	list_ver:addItem( used_level_lab )
	-----------------
	local job_lab = ZLabel:create( nil, job_text_info, 20, 0 )
	list_ver:addItem( job_lab, true, true )
	
	-- 价格
	local price_image = ""
	-- print("temp_info[index + 1].money_type",temp_info[index + 1].money_type)
	if temp_info[index + 1].money_type == 1 then
		price_image = UILH_JISHOU.yl_48
	elseif temp_info[index + 1].money_type == 3 then
		price_image = UILH_JISHOU.yb_48
	end
	local price_icon = ZImage:create( nil, price_image, 0, 0, 24, 24 )
	local price_icon_size = price_icon.view:getSize()
	--price_icon:setPosition( -price_icon_size.width , 0 )
	local price_lab = ZLabel:create( nil, tostring( temp_info[index + 1].price ), 0, 0 )
	price_lab:setPosition( price_icon_size.width + 8, 5 )
	price_icon.view:addChild( price_lab.view )
	list_ver:addItem( price_icon, false, true )
	
	-- 购买按钮  xiehande UI_JISHOUWIN_019 ->UIPIC_COMMOM_001
	local buy_button = ZTextButton:create( nil, Lang.shop[23], --"购买"
	 {UILH_COMMON.button5_nor, UILH_COMMON.button5_nor }, nil, 0, 0, -1, -1, nil, 600, 600 )
	buy_button.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.button5_dis)
	local cur_player_name = EntityManager:get_player_avatar().name
	if cur_player_name == temp_info[index + 1].name then
		buy_button.view:setCurState(CLICK_STATE_DISABLE)
	end
	list_ver:addItem( buy_button, true, true )
	local function confirm_fun()
		local temp_id = temp_info[index + 1].handle
		local item_info = JiShouModel:data_get_index_data_item_info(cur_page_select, temp_id)
		if item_info.type == 0 then
			JiShouModel:buy_item( item_info.bag_item.series, item_info.handle )
		else
			JiShouModel:buy_item( 0, item_info.handle )
		end
	end
	local function buy_fun()
		local temp_id = temp_info[index + 1].handle
		local item_info = JiShouModel:data_get_index_data_item_info(cur_page_select, temp_id)
		if item_info ~= nil then
			local player = EntityManager:get_player_avatar()
			local cur_yb = player.yuanbao
			local cur_yl = player.yinliang
			local money_notic
			if item_info.money_type == 1 then
				if item_info.price > cur_yl then
					  --天降雄狮修改 xiehande  如果是铜币不足/银两不足/经验不足 做我要变强处理
       	   			 ConfirmWin2:show( nil, 15, Lang.screen_notic[13],  need_money_callback, nil, nil )
					return
				else
					money_notic = Lang.normal[1]-- "银两"
				end
			else
				if item_info.price > cur_yb then
					GlobalFunc:create_screen_notic(Lang.jiShou[2]) -- "元宝不足"
					return
				else
					money_notic = Lang.normal[4] -- "元宝"
				end
			end

			local temp_notic 
			if item_info.type == 1 then
				if item_info.send_money_type == 1 then
					temp_notic = string.format(Lang.jiShou.buy_notic_info, item_info.send_money, Lang.normal[1], item_info.price, money_notic ) -- "银两"
				else
					temp_notic = string.format(Lang.jiShou.buy_notic_info, item_info.send_money, Lang.normal[4], item_info.price, money_notic ) -- "元宝"
				end
			else
				local temp_item_quality = item_info.bag_item.quality + 1
				if temp_item_quality <= 0 then
					temp_item_quality = 1 
				elseif temp_item_quality > 6 then
					temp_item_quality = 6
				end
				local item_name = ItemConfig:get_item_name_by_item_id( item_info.bag_item.item_id )
				local temp_name = string.format("%s%s%s","#c",ItemConfig:get_item_color(temp_item_quality), item_name)
				temp_notic = string.format(Lang.jiShou.buy_notic_info, item_info.bag_item.count, temp_name, item_info.price, money_notic )
			end
			local temp_not_show = JiShouModel:get_is_next_not_show()
			local function swithc_btn_fun( is_select )
				JiShouModel:set_is_next_not_show( is_select )
				--print("_is_next_not_show",_is_next_not_show)
			end
			if temp_not_show == false then
				ConfirmWin2:show(1, nil, temp_notic, confirm_fun, swithc_btn_fun )
			else
				confirm_fun()
			end
		end
	end
	buy_button:setTouchClickFun(buy_fun)

	-- 添加一根线
	local line = ZImage:create( nil, UILH_COMMON.split_line, 5, 0, 610, 2 )
	list_ver.view:addChild(line.view)

	return list_ver
end

local function create_right_panel( self, x, y, twidth, theight)
	local right_title_bg = CCBasePanel:panelWithFile( 257, 470, 605, -1, UILH_NORMAL.title_bg4, 500, 500 );
	self.view:addChild( right_title_bg );
	-- 标题文字
	local title_text_pos_x = { 81, 228, 322, 431, 543 };
	local title_text_pos_y = 8;
	local title_text_info = Lang.jiShou.title_info
	for i = 1, #title_text_info do
		local temp = ZLabel:create( nil, title_text_info[i], title_text_pos_x[i], title_text_pos_y, 16)
		right_title_bg:addChild( temp.view )
	end
	self.scroll = ZScroll:create( nil, nil, x, y, twidth, theight, 1, TYPE_HORIZONTAL )
	self:addChild( self.scroll )
	-- self.scroll:setScrollLump( 10, 30, theight-20)
	self.scroll.view:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 10, 30, theight-20)
	local arrow_up = CCZXImage:imageWithFile(x + twidth, y+theight-10, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(x + twidth, y, 10, -1 , UILH_COMMON.scrollbar_down, 500, 500)
	self.view:addChild(arrow_up,500)
	self.view:addChild(arrow_down,500)
	self.scroll:setScrollCreatFunction(scroll_create_fun)
end
------左边列表
local function create_down_panel(self, x, y, width, height)
	-- local basePanel = BasePanel:create( nil, x, y, width, height)
	local edit_box_info = { width = 150, height = 30, max_num = 10, font_size = 16 }
	local serch_button_info = { width = 58, height = 30 , image = UILH_COMMON.lh_button2, text = Lang.jiShou.serch_text }
	local label_font_size = 16
	local shangjia_button_info = { width = -1, height = -1, image = UILH_COMMON.btn4_nor, text = Lang.jiShou.shangjia }

	local woyaojishou_button_info = { width = -1, height = -1, image = UILH_COMMON.btn4_nor, text = Lang.jiShou.woyaojishou }
	-------------------------------------
	self.reset_button = TextButton:create( nil, 31, 45, -1, -1, Lang.jiShou.all, UILH_COMMON.lh_button2 )
	self:addChild(self.reset_button.view)

	self.reset_button:setTouchClickFun( JiShouModel.reset_btn_fun )
	self.return_button = TextButton:create( nil, 31, 45, -1, -1, Lang.jiShou.back, serch_button_info.image )
	self:addChild(self.return_button.view)
	local function return_fun( ... )
		self:change_page(last_select)
	end
	self.return_button:setTouchClickFun( return_fun )
	self.return_button.view:setIsVisible(false)
    local function serch_btn_cb(  )
		local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
		if ji_shou_win ~= nil then
			ji_shou_win:change_page(9)
		end
	end 
	self.serch_button = TextButton:create( nil, 137, 45, -1, -1, serch_button_info.text, UILH_COMMON.lh_button2 )
	self.serch_button.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable)
	self:addChild(self.serch_button.view)
	self.serch_button:setTouchClickFun( serch_btn_cb )
	-- self.serch_button.view:setCurState(CLICK_STATE_DISABLE)
	--self.serch_button.view:setIsVisible( false )

	-------元宝
	local yb_label = Label:create( nil, 280, 60, Lang.jiShou.yb_text, label_font_size )
	self:addChild(yb_label.view)
	local yb_label_pos = yb_label:getPosition()
	local yb_label_size = yb_label.view:getSize()
	-------------------------------------
	self.yb_num = Label:create( nil, 330, 60,  "0" , label_font_size)
	self:addChild(self.yb_num.view)
	----------银两
	local yl_label = Label:create( nil, 465, 60, Lang.jiShou.yl_text, label_font_size )
	self:addChild(yl_label.view)
	local yl_label_pos = yl_label:getPosition()
	local yl_label_size = yl_label.view:getSize()
	--------------------------------------
	self.yl_num = Label:create( nil, 515, 60, "0" , label_font_size)
	self:addChild(self.yl_num.view)
	---------上架按钮
	self.shangjia_btn = TextButton:create( nil, 600, 43, -1, -1, shangjia_button_info.text,
	 shangjia_button_info.image)
	self:addChild(self.shangjia_btn.view)
	self.shangjia_btn:setTouchClickFun(JiShouModel.shanjia_btn_fun)
	--寄售按钮
	-- TextButton:create(father, posX, posY, width, height, text, image)
	local woyaojishou_btn = TextButton:create( nil, 740, 43, -1, -1, Lang.jiShou.woyaojishou, UILH_COMMON.btn4_nor)
	self:addChild(woyaojishou_btn.view)
	woyaojishou_btn:setTouchClickFun(JiShouModel.woyaojishou_btn_fun)
	----------------------------------------
	-- self:addChild( basePanel.view )
end
--[[
local function create_down_panel(self, x, y, width, height)
	-- "全部"、"搜索"按钮

	-- "元宝"、"银两"标签

	-- "上架物品"、"我要寄售"按钮
end
--]]
-----------------------------------------
--xiehande  点击按钮切换字体贴图
function JiShouWin:change_btn_name( index )
	-- body
	for i,v in ipairs(self.radio_button.item_group) do
		if(i==index) then
          self.radio_button:getIndexItem(i-1).view:setTexture(UILH_COMMON.tab_light)
		else
          self.radio_button:getIndexItem(i-1).view:setTexture(UILH_COMMON.tab_gray)
		end
	end
end

local function create_ji_shou_panel(self, width, height)
	local tab_text = Lang.jiShou.tab_text
	self.radio_button = ZRadioButtonGroup:create( nil, 15, 520, 117 * #tab_text, 44 )
	for i = 1, #tab_text do
		-- local temp = ZImageButton:create( nil, { UI_JISHOUWIN_015, UI_JISHOUWIN_016}, tab_info[i][1], nil,  0, 0, -1, -1)
		-- temp:setTouchClickFun(btn_fun)
		-- self.radio_button:addItem( temp,6 )
		self:create_a_button(self.radio_button, 0, 0, -1, -1, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, tab_text[i], i)
	end
	self:change_btn_name(1)
	---------------
	---special page to serch all item
	_special_page_index = #tab_text + 1
	-- local special_page = ZImageButton:create( nil, nil, "", 0, 0, -1, -1 )
	-- self.radio_button:addItem( special_page )
	---------------
	self:addChild( self.radio_button.view )
	---------------
		-------------------

	-- 添加一层背景
	local tmpBg = CCBasePanel:panelWithFile( 8, 17, 885, 510, UILH_COMMON.normal_bg_v2, 500, 500 )
	self:addChild( tmpBg )

	--left bg
	local left_bg = ZImage:create( nil, UILH_COMMON.bottom_bg, 25, 35, 225, 475, nil, 600, 600)
	self:addChild(left_bg.view)
	-------------------
	--right bg
	local right_bg = ZImage:create( nil, UILH_COMMON.bottom_bg, 255, 35, 620, 475, nil, 600, 600)
	self:addChild(right_bg.view)
	local right_bg2 = ZImage:create( nil, UILH_COMMON.bg_10, 261, 103, 608, 401, nil, 600, 600)
	self:addChild(right_bg2.view)
	---左区域的位置
	create_left_panel( self, 35, 92, 224, 398+10, #tab_text )

	-- 右区域标题
--	create_title_panel( self, 273, 470, 596, 34 )
	create_right_panel( self, 260, 108, 597, 363 )
	create_down_panel(self, 20, 20, 700, 32)
end
------------------------------------------------
-- 标签选项
function JiShouWin:create_a_button( panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, index )
    -- local radio_button = ZTextButton:create(nil, but_name, {image_n,image_s}, nil, pos_x, pos_y, size_w, size_h)
	local radio_button = ZButton:create(nil, {image_n,image_s}, nil, pos_x, pos_y, size_w, size_h)
	local radio_text = ZLabel:create(radio_button.view, but_name, 50, 12, 16, 2)
	local function btn_fun()
		local btn_index = index 
        -- self:change_btn_name(i)
		local ji_shou_win = UIManager:find_visible_window("ji_shou_win")
		if ji_shou_win ~= nil then
			ji_shou_win:change_page(btn_index)
		end
	end
    radio_button:setTouchClickFun(btn_fun)
    panel:addItem(radio_button, 0)
end
-----------------------------------------
function JiShouWin:get_serch_text()
	if self.edit_box ~= nil then
		return self.edit_box:getText()
	end
end
-----------------------------------------
function JiShouWin:__init(window_name, texture_name, is_grid, width, height)
	create_ji_shou_panel(self, width, height)
	self:create_search_panel()
	local function self_view_func( eventType )
	    if eventType == TOUCH_BEGAN then
	        if quality_select_panel ~= nil and quality_select_panel:getIsVisible() then
				quality_select_panel:setIsVisible(false)
			end
			if money_select_panel ~= nil and money_select_panel:getIsVisible() then
				money_select_panel:setIsVisible(false)
			end
	    end
	    return false
    end
    -- chat_input_edit.view:registerScriptHandler(self_view_func)
    -- chat_info.group_scroll:registerScriptHandler(self_view_func)

    -- 这里盖了一层用作回收下拉框
	local conten = self.view:getSize()
	local basepanel = CCBasePanel:panelWithFile( 0, 0, conten.width,conten.height,nil);
	basepanel:setAnchorPoint(0,0)
	self.view:addChild(basepanel,500)
	basepanel:registerScriptHandler(self_view_func)
end
-----------------------------------------
function JiShouWin:destroy()
	Window.destroy(self)
	JiShouModel:set_cur_top_page_select(-1)
	local temp_panel = { self.equip_and_material_panel }
	for i = 1, #temp_panel do
		if temp_panel[i] ~= nil then
			temp_panel:destroy()
		end
	end
end
-----------------------------------------
function JiShouWin:active(show)
	if show == true then	
		local player = EntityManager:get_player_avatar()
		local cur_yb = player.yuanbao
		local cur_yl = player.yinliang
		self:update_yb_and_yl(cur_yb, cur_yl)
		if JiShouModel:get_init_serch_info() == false then
			JiShouModel:set_init_serch_info(true)
			JiShouModel:init_serch_page_info()
			self:clear_scroll()
		end
		local cur_page_select = JiShouModel:get_cur_top_page_select()
		-- print("cur_page_select",cur_page_select)
		if cur_page_select < 0 or cur_page_select == _special_page_index or cur_page_select == 9 then
			self:change_page(1)
		else
			self:change_page(cur_page_select)
		end

		LuaEffectManager:stop_view_effect( 9,self.shangjia_btn.view)
		local temp_count = JiShouShangJiaModel:get__page_three_info_len()
		if temp_count > 0 then
			LuaEffectManager:play_view_effect( 9,60,30,self.shangjia_btn.view,false,9999)
		end 
	end
end
-----------------------------------------
function JiShouWin:set_scroll_max_num(num)
	if self.scroll ~= nil then
		self.scroll:setMaxNum(num)
	end
end
-----------------------------------------
function JiShouWin:get_scroll_cur_num()
	if self.scroll ~= nil then
		return self.scroll.view:getScrollCurNum()
	end
end
-----------------------------------------
function JiShouWin:clear_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
	end
end
-----------------------------------------
function JiShouWin:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll:refresh()
	end
end