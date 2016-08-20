------------------------------
------------------------------
----HJH
----2013-2-27
----战场排行榜界面
------------------------------
super_class.BattleList(Window)
------------------------------
local _cur_index_select = TopListConfig.TopListType.FMSL
local _self_panel = nil
------------------------------
function BattleList:battlelist_fmsl_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.FMSL
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
	end
end
------------------------------
local function battlelist_scroll_create_item(index, topListStruct, itemWidth, itemHeight, sizeInfo)
	---------------
	local list_vector = ZListVertical:create( nil, 0, 0, itemWidth, itemHeight, sizeInfo )
	local image = ZImage:create( nil, UILH_COMMON.split_line, 0, 0, itemWidth, 2)
	list_vector.view:addChild(image.view)
	local index_label = ZLabel:create( nil, index , 0, 0)
	--local name_label = Label:create( nil, 0, 0, topListStruct.playerName )
	local name_panel = QQVipInterface:create_qq_vip_info( topListStruct.qqVip, LH_COLOR[2] .. topListStruct.playerName )
	--设置名字为可点穿
	name_panel:setDefaultReturnValue( false )
	local kill_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.kill, 0, 0)
	-- local camp_label = ZLabel:create( nil, Lang.camp_info[topListStruct.campId], 0, 0 )
	local kill_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.kill, 0, 0)
	local help_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.help, 0, 0)
	local hit_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.hit, 0, 0)
	local scroe_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.score, 0, 0)
	--local xz_label = Label:create( nil, 0, 0, topListStruct.guildName )
	--local fight_label = Label:create( nil, 0, 0, tostring(topListStruct.point) )
	list_vector:addItem( index_label )
	list_vector:addItem( name_panel )
	-- list_vector:addItem( camp_label )
	list_vector:addItem( kill_label )
	list_vector:addItem( help_label )
	list_vector:addItem( hit_label )
	list_vector:addItem( scroe_label )
	local function click_fun()
		local info = {roleId = topListStruct.playerId, roleName = topListStruct.playerName, qqvip = topListStruct.qqVip, level = topListStruct.level, camp = topListStruct.campId, job = topListStruct.job, sex = topListStruct.sex }
		--require "model/LeftClickMenuMgr"
		--params.roleId, params.roleName, params.level,params.camp, params.job, params.sex
		if info.roleName ~= EntityManager:get_player_avatar().name then
			LeftClickMenuMgr:show_left_menu("chat_other_list_menu", info)
		end
	end
	list_vector:setTouchClickFun(click_fun)
	return list_vector
end
---------------
local function battlelist_scroll_create_fun(self, index)
	--require "UI/component/List"
	---------------
	--local index = tindex
	--local top_list_win = UIManager:find_window("top_list_win")
	---------------
	--local _battle_type = TopListConfig.TopListType.FMSL
	local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
	--if top_list_win ~= nil then
	-- if _index_panel_scroll_max_num[_battle_type] ~= nil and  top_list_win.personal_list.scroll:getMaxNum() ~= _index_panel_scroll_max_num[_battle_type] then
	-- 	--print(" _index_panel_scroll_max_num[_battle_type]", _index_panel_scroll_max_num[_battle_type])
	-- 	top_list_win.battle_list.scroll:setMaxNum( _index_panel_scroll_max_num[_battle_type] )
	-- end
	--local scroll_info = top_list_win.wing_list:get_scroll_info()
	local list_info = {vertical = 1, horizontal = 5}
	local size_info = { 75, 150, 75, 75, 110, 100 }
	local temp_info = TopListModel:data_get_top_list_index_index_info( _cur_index_select, index)
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
				local item = battlelist_scroll_create_item( index * list_info.horizontal + i, temp_info[i], 584, 190 / list_info.horizontal, size_info)
				list:addItem( item )
			end
		end
		return list
	end
end
------------------------------
local function createBattleList(self, width, height)
	------------------------------
	--左排标题底色
	local _list_btn_info = { 
		 x = 20, y = 250, width = -1 , height = -1, gapsize = -2, 
		image = {
				UILH_TOPLIST.left_btn_nor,UILH_TOPLIST.left_btn_sel
			} 
		}

	local _line_info = { width = 214, height = 2, gapsize = 45, image = UIPOS_BattleList_02 }

	local _right_title_info = {x = 280, y = 477, width = 584, height = 32, 
		sizeinfo =  {65, 150, 75, 75, 110, 100}, 
		fontsize = 18, 
		text_change_info = {Lang.topList.flower[1], Lang.topList.flower[2]}, text = {Lang.topList.personal[5], Lang.topList.personal[6], Lang.topList.personal[7], Lang.topList.battle[1],Lang.topList.battle[2], Lang.topList.battle[3], Lang.topList.battle[4]}
	 } -- [2088]="#c00ff00本周魅力" -- [2089]="#c00ff00魅力" -- [2090]="#c00ff00排名" -- [2091]="#c00ff00角色名称" -- [2092]="#c00ff00阵营" -- [2093]="#c00ff00杀人" -- [2094]="#c00ff00助攻" -- [2095]="#c00ff00最大连斩" -- [2096]="#c00ff00积分"
	
	local _scroll_info = {x = 266, y = 75, width = 585, height = 390, vertical = 1, horizontal = 5, maxnum = 1, gapsize = 10}
	local _radio_button_info = {x = 32, y = 0, width = 230, height = 505, addtype = 1}
	------------------------------
	local fmsl_button = ZImageButton:create(  nil,  _list_btn_info.image, UILH_TOPLIST.fmsl, nil, 0, 0, _list_btn_info.width, _list_btn_info.height )
	fmsl_button:setTouchClickFun(BattleList.battlelist_fmsl_button_click_fun)
	--local fmsl_pos = self.fmsl_button:getPosition()
	-- self.fmsl_line = ZImage:create( fmsl_button.view, _line_info.image, 10, -15, _line_info.width, _line_info.height )
	--local pet_line_pos = self.per_week_charm_line:getPosition()
	self.radio_button_group = ZRadioButtonGroup:create( nil, _radio_button_info.x, _radio_button_info.y, _radio_button_info.width, _radio_button_info.height, _radio_button_info.addtype)
	self.radio_button_group:addItem( fmsl_button, -8 )
	------------------------------
	self.right_title = ZListVertical:create( nil, _right_title_info.x, _right_title_info.y, _right_title_info.width, _right_title_info.height, _right_title_info.sizeinfo )
	local label_one = ZLabel:create( nil, _right_title_info.text[1], 0, 0, _right_title_info.fontsize )
	local label_two = ZLabel:create( nil, _right_title_info.text[2], 0, 0, _right_title_info.fontsize )
	-- local label_three = ZLabel:create( nil, _right_title_info.text[3], 0, 0, _right_title_info.fontsize )
	local label_four = ZLabel:create( nil, _right_title_info.text[4], 0, 0, _right_title_info.fontsize )
	local label_five = ZLabel:create( nil, _right_title_info.text[5], 0, 0, _right_title_info.fontsize )
	local label_six = ZLabel:create( nil, _right_title_info.text[6], 0, 0, _right_title_info.fontsize )
	local label_sevent = ZLabel:create( nil, _right_title_info.text[7], 0, 0, _right_title_info.fontsize )
	self.right_title:addItem( label_one )
	self.right_title:addItem( label_two )
	-- self.right_title:addItem( label_three )
	self.right_title:addItem( label_four )
	self.right_title:addItem( label_five )
	self.right_title:addItem( label_six )
	self.right_title:addItem( label_sevent )
	------------------------------
	self.scroll = ZScroll:create( nil, nil, _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, TYPE_HORIZONTAL_EX)
	--self.scroll.view:setLimitSize(10)
	self.scroll:setScrollLump( 10, 20, _scroll_info.height )
	-- self.scroll.view:setScrollLumpPos( _scroll_info.width - 20 )
	self.scroll:setScrollCreatFunction(battlelist_scroll_create_fun)
	local arrow_up = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y+_scroll_info.height-2, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y-2, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
	------------------------------
	self.view:addChild( self.radio_button_group.view )
	self.view:addChild( self.right_title.view )
	self.view:addChild( self.scroll.view )
	self.view:addChild(arrow_up)
	self.view:addChild(arrow_down)
	-- self.view:addChild( self.fmsl_line.view )
	-- 我的排名信息
	-- self.my_top_list_num = ZLabel:create(self.view, Lang.topList[2], 710, 36, 18)
end
------------------------------
------------------------------
function BattleList:__init(window_name, texture_name, grid, width, height)
	createBattleList(self, width, height)
	_self_panel = self
end
------------------------------
function BattleList:reinit_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		self.scroll.view:setMaxNum( panel_info.info.max_num )
		self.scroll:refresh()
	end
end
------------------------------
function BattleList:refresh_panel()
	local temp_fun = { [TopListConfig.TopListType.FMSL] = self.battlelist_fmsl_button_click_fun }
	temp_fun[ _cur_index_select ]() 
end
------------------------------
function BattleList:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll:refresh()
	end
end
------------------------------
function BattleList:clear_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
	end
end
------------------------------
function BattleList:set_max_num(num)
	if self.scroll ~= nil then
		local cur_num = self.scroll.view:getMaxNum()
		if cur_num ~= num then
			self.scroll:setMaxNum( num )
		end
	end
end
-------------------------------
function BattleList:reinit_info(info)
	local value = info and info[_cur_index_select+1] or TopListModel:get_my_top_list(_cur_index_select+1)
	local str = value ~= 0 and tostring(value) or Lang.topList.mytoplist[15]
	-- self.my_top_list_num:setText(Lang.topList[2] .. LH_COLOR[15] .. str)
end