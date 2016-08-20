------------------------------
------------------------------
----HJH
----2013-2-27
----个人实力排行榜界面
------------------------------
super_class.PersonalAbilityList(Window)
------------------------------
local _cur_index_select = TopListConfig.TopListType.Fight
local _self_panel = nil
------------------------------
function PersonalAbilityList:personal_battle_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Fight
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.personal[1]) -- [1]="#c00ff00战斗力"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
		_self_panel.radio_button_group:selectItem(0)
	end
end
---------------
function PersonalAbilityList:personal_level_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Level
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.personal[2]) -- [2112]="#c00ff00等级"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
	end
end
---------------
function PersonalAbilityList:personal_lg_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Lg
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.personal[3]) -- [2113]="#c00ff00忍の书"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
	end
end
---------------
function PersonalAbilityList:personal_achieve_button_click_fun()
	if _self_panel ~= nil then
		-- print("<<<<<<<<<<<<<<<<<<<PersonalAbilityList:personal_achieve_button_click_fun")
		_cur_index_select = TopListConfig.TopListType.Achieve
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.personal[4]) -- [2114]="#c00ff00成就"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
	end
end
------------------------------
local function scroll_create_item( index, topListStruct, itemWidth, itemHeight, sizeInfo )
	---------------
	local list_vector = ZListVertical:create( nil, 0, 0, itemWidth, itemHeight, sizeInfo )

	local image = ZImage:create( nil,UILH_COMMON.split_line, 0, 0, itemWidth, 2)
	list_vector.view:addChild(image.view)
	
	local index_label = ZLabel:create( nil, LH_COLOR[2] .. tostring(index), 0, 0 )
	--print("PersonalAbilityList topListStruct.playerName ",topListStruct.playerName )
	local name_panel = QQVipInterface:create_qq_vip_info( topListStruct.qqVip, LH_COLOR[2] .. topListStruct.playerName )
	--设置名字为可点穿
	name_panel:setDefaultReturnValue( false )
	--print("PersonalAbilityList topListStruct.playerName ",topListStruct.playerName )
	-- local camp_label = ZLabel:create( nil, Lang.camp_info[topListStruct.campId], 0, 0 )
	local xz_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.guildName, 0, 0 )
	list_vector:addItem( index_label )
	list_vector:addItem( name_panel )
	-- list_vector:addItem( camp_label )

	-------
	local top_list_win = UIManager:find_window("top_list_win")
	local cur_select = _cur_index_select
	if cur_select == TopListConfig.TopListType.Lg then
		local temp_name
		local temp_point = tonumber(topListStruct.point)
		if temp_point == 0 then
			temp_name = Lang.topList[3] -- [532]="无"
		else
			local lg_index = ZXLuaUtils:highByte(temp_point)
			local lg_level = ZXLuaUtils:lowByte(temp_point)
		 	temp_name = RootConfig:get_lg_info_by_index( lg_index, lg_level )
		end
		local lg_label = ZLabel:create( nil, LH_COLOR[2] .. temp_name, 0, 0 )
		list_vector:addItem( lg_label )
	else		
		local fight_label = ZLabel:create( nil, LH_COLOR[2] .. tostring(topListStruct.point), 0, 0 )	
		list_vector:addItem( fight_label )
	end
	list_vector:addItem( xz_label )
	local function click_fun()
		local info = {roleId = topListStruct.playerId, roleName = topListStruct.playerName, qqvip = topListStruct.qqVip, level = topListStruct.level, camp = topListStruct.campId, job = topListStruct.job, sex = topListStruct.sex }
		--params.roleId, params.roleName, params.level,params.camp, params.job, params.sex
		if info.roleName ~= EntityManager:get_player_avatar().name then
			LeftClickMenuMgr:show_left_menu("chat_other_list_menu", info)
		end
	end
	list_vector:setTouchClickFun(click_fun)
	return list_vector
end
------------------------------
local function scroll_create_fun(self, index)
	---------------
	--print("index", index)
	local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
	local list_info = {vertical = 1, horizontal = 5}
	local size_info =  { 65, 195, 195, 120} 
	local temp_info = TopListModel:data_get_top_list_index_index_info( _cur_index_select, index )
	if temp_info == nil and #panel_info.info == 0 and panel_info.init == false then
		TopListModel:data_set_top_list_index_init( _cur_index_select, true )
		_self_panel.scroll:setMaxNum(0)
		return nil
	end
	if temp_info == nil then
		--_self_panel.scroll:setMaxNum( #panel_info.info.page_info )
		return nil
	end
	if index <= panel_info.info.max_num then
		local list = ZList:create( nil, 0, 0, 585, 190, list_info.vertical, list_info.horizontal )
		for i = 1, list_info.horizontal do
			if temp_info[i] ~= nil then
				local item = scroll_create_item( index * list_info.horizontal + i, temp_info[i], 584, 190 / list_info.horizontal, size_info )
				list:addItem( item )
			end
		end
		return list
	end
end
------------------------------
local function createPersonal(self, width, height)
	------------------------------
	--local _window_size = {width = 800, height = 450}
	-- 当前显示页码
	--左边的四个选项 战力 等级....
	local _list_btn_info =
	{ 
		x = 20, y = 250, width = -1 , height = -1, gapsize = -2, 
		image = { 
			UILH_TOPLIST.left_btn_nor,UILH_TOPLIST.left_btn_sel
		}
	 }

	--分割线
	local _line_info = { width = 214, height = 2, gapsize = 45, image = UIPOS_PersonalAbilityList_003 }
	
	--右边区域标题的
	local _right_title_info = {x = 280, y = 477, width = 584, height = 32, 
		sizeinfo =  {85, 200, 180, 120}, 
		fontsize = 18, 
	  	text_change_info = {Lang.topList.personal[1], Lang.topList.personal[2],Lang.topList.personal[3],Lang.topList.personal[4]}, 
	  	text = {Lang.topList.personal[5], Lang.topList.personal[6], Lang.topList.personal[7], Lang.topList.personal[8]} 
	  } 
    --战斗力 等级 成就 ....

	local _radio_button_info = {x = 32, y = 0, width = 230, height = 505, addtype = 1}

	local _scroll_info = {x = 266, y = 75, width = 585, height = 390, vertical = 1, horizontal = 5, maxnum = 1, gapsize = 10}
	
	------战场
	local battle_button = ZImageButton:create( nil,  _list_btn_info.image,UILH_TOPLIST.battle, nil, 0, 0, _list_btn_info.width, _list_btn_info.height )
	battle_button:setTouchClickFun(PersonalAbilityList.personal_battle_button_click_fun)
	-- self.battle_line = ZImage:create( battle_button.view, _line_info.image, 0, -1, _line_info.width, _line_info.height)
	-- local battle_line_pos = self.battle_line:getPosition()

	------等级
	local level_button = ZImageButton:create( nil, _list_btn_info.image, UILH_TOPLIST.level,nil, 0, 0, _list_btn_info.width, _list_btn_info.height)
	level_button:setTouchClickFun(PersonalAbilityList.personal_level_button_click_fun)

	-- self.level_line = ZImage:create( level_button.view, _line_info.image, 0, -1, _line_info.width, _line_info.height)
	-- local level_line_pos = self.level_line:getPosition()

	------灵根
	local lg_button = ZImageButton:create( nil, _list_btn_info.image, UILH_TOPLIST.achieve,nil, 0, 0, _list_btn_info.width, _list_btn_info.height)
	lg_button:setTouchClickFun(PersonalAbilityList.personal_achieve_button_click_fun)
	-- self.lg_line = ZImage:create( lg_button.view, _line_info.image, 0,-1, _line_info.width, _line_info.height)
	-- local lg_line_pos = self.lg_line:getPosition()

	------成就
	local achieve_button = ZImageButton:create( nil, _list_btn_info.image,UILH_TOPLIST.linggen, nil, 0, 0, _list_btn_info.width, _list_btn_info.height)
	achieve_button:setTouchClickFun(PersonalAbilityList.personal_lg_button_click_fun)

	-- 左：分割线
	-- self.achieve_line = ZImage:create( achieve_button.view, _line_info.image, 10, -15, _line_info.width, _line_info.height)

	------------------------------tagview--------------------------------
	self.radio_button_group = ZRadioButtonGroup:create( nil, _radio_button_info.x, _radio_button_info.y, _radio_button_info.width, _radio_button_info.height, _radio_button_info.addtype)

	self.radio_button_group:addItem( battle_button, _list_btn_info.gapsize )
	self.radio_button_group:addItem( level_button, _list_btn_info.gapsize )
	self.radio_button_group:addItem( lg_button, _list_btn_info.gapsize )
	self.radio_button_group:addItem( achieve_button, _list_btn_info.gapsize )

	------------------------------标题：排名，角色名，阵营，and so on...
	self.right_title = ZListVertical:create( nil, _right_title_info.x, _right_title_info.y, _right_title_info.width, _right_title_info.height, _right_title_info.sizeinfo )
	local label_one = ZLabel:create( nil, _right_title_info.text[1], 0, 0, _right_title_info.fontsize, 2 )
	local label_two = ZLabel:create( nil, _right_title_info.text[2], 0, 0, _right_title_info.fontsize, 2 )
	-- local label_three = ZLabel:create( nil, _right_title_info.text[3], 0, 0, _right_title_info.fontsize )
	local label_four = ZLabel:create( nil, _right_title_info.text_change_info[1], 0, 0, _right_title_info.fontsize, 2 )
	local label_five = ZLabel:create( nil, _right_title_info.text[4], 0, 0, _right_title_info.fontsize, 2 )
	------------------
	self.right_title:addItem( label_one )
	self.right_title:addItem( label_two )
	-- self.right_title:addItem( label_three )
	self.right_title:addItem( label_four )
	self.right_title:addItem( label_five )

	-----拖动条
	self.scroll = ZScroll:create( nil, nil, _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, TYPE_HORIZONTAL)
	self.scroll:setScrollLump( 10, 20, _scroll_info.height )
	--self.scroll.view:setScrollLump(UIResourcePath.FileLocate.common .. "progress_green.png", UIResourcePath.FileLocate.common .. "input_frame_bg.png", 10, 20, _scroll_info.height)
	--self.scroll.view:setScrollLumpPos( _scroll_info.width )
	self.scroll:setScrollCreatFunction(scroll_create_fun)
	local arrow_up = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y+_scroll_info.height-2, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y-2, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
	------------------------------
	------------------------------
	self.view:addChild(self.radio_button_group.view )
	self.view:addChild(self.right_title.view )
	self.view:addChild(self.scroll.view )
	self.view:addChild(arrow_up)
	self.view:addChild(arrow_down)
	-- 我的排名信息
	-- self.my_top_list_num = ZLabel:create(self.view, Lang.topList[2], 710, 36, 18)
end
------------------------------
------------------------------
function PersonalAbilityList:__init(window_name, texture_name, grid, width, height)
	createPersonal(self, width, height)
	_self_panel = self
end
------------------------------
function PersonalAbilityList:reinit_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		self.scroll.view:setMaxNum( panel_info.info.max_num )
		self.scroll:refresh()
	end
end
------------------------------
function PersonalAbilityList:refresh_panel()
	local temp_fun = { self.personal_battle_button_click_fun, self.personal_level_button_click_fun, self.personal_lg_button_click_fun, self.personal_achieve_button_click_fun }
	temp_fun[ _cur_index_select ]() 
end

------------------------------
function PersonalAbilityList:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll:refresh()
	end
end
------------------------------
function PersonalAbilityList:clear_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
	end
end
------------------------------
function PersonalAbilityList:set_max_num(num)
	if self.scroll ~= nil then
		local cur_num = self.scroll.view:getMaxNum()
		if cur_num ~= num then
			self.scroll:setMaxNum( num )
		end
	end
end
-------------------------------
function PersonalAbilityList:reinit_info(info)
	local value = info and info[_cur_index_select+1] or TopListModel:get_my_top_list(_cur_index_select+1)
	local str = value ~= 0 and tostring(value) or Lang.topList.mytoplist[15]
	-- self.my_top_list_num:setText(Lang.topList[2] .. LH_COLOR[15] .. str)
end