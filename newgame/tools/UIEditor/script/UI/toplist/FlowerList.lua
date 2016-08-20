------------------------------
------------------------------
----HJH
----2013-2-27
----宠物坐骑排行榜界面
------------------------------
super_class.FlowerList(Window)
------------------------------
local _cur_index_select = TopListConfig.TopListType.PerWeekCharm
local _self_panel = nil
------------------------------
function FlowerList:flower_per_week_charm_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.PerWeekCharm
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.flower[1]) -- [2088]="#c00ff00本周魅力"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
		_self_panel.radio_button_group:selectItem(0)
	end
end
---------------
function FlowerList:flower_charm_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Charm
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.flower[2]) -- [2089]="#c00ff00魅力"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
	end
end
------------------------------
local function flower_scroll_create_item(index, topListStruct, itemWidth, itemHeight, sizeInfo)
	---------------
	local list_vector = ZListVertical:create( nil, 0, 0, itemWidth, itemHeight, sizeInfo )
	local image = ZImage:create( nil, UILH_COMMON.split_line, 0, 0, itemWidth, 2)
	list_vector.view:addChild(image.view)
	local index_label = ZLabel:create( nil, LH_COLOR[2] .. tostring(index), 0, 0 )
	local name_panel = QQVipInterface:create_qq_vip_info( topListStruct.qqVip, LH_COLOR[2] .. topListStruct.playerName )
	--设置名字为可点穿
	name_panel:setDefaultReturnValue( false )
	-- local camp_label = ZLabel:create( nil, Lang.camp_info[topListStruct.campId], 0, 0 )
	local xz_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.guildName, 0, 0 )
	local fight_label = ZLabel:create( nil, LH_COLOR[2] .. tostring(topListStruct.point), 0, 0 )
	list_vector:addItem( index_label )
	--list_vector:addItem( item_name )
	list_vector:addItem( name_panel )
	-- list_vector:addItem( camp_label )
	list_vector:addItem( fight_label )
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
---------------
local function flower_scroll_create_fun(self, index)
	--require "UI/component/List"
	local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
	local list_info = {vertical = 1, horizontal = 5}
	local size_info = {65, 195, 190, 115 }
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
				local item = flower_scroll_create_item( index * list_info.horizontal + i, temp_info[i], 584, 190 / list_info.horizontal, size_info)
				list:addItem( item )
			end
		end
		return list
	end
end
------------------------------
local function createFlowerList(self, width, height)
	------------------------------
	local _window_size = {width = 800, height = 500}
	--左排标题底色
	local _list_btn_info = {
		 x = 20, y = 250, width = -1 , height = -1, gapsize = -2, 
		image = {
			UILH_TOPLIST.left_btn_nor,UILH_TOPLIST.left_btn_sel
		} 
	}
	-- local _per_week_info = { x = 21, y = 289, width = 154 , height = 44, gapsize = 30, image = { UIResourcePath.FileLocate.topList .. "per_week_charm_n.png",
	--  UIResourcePath.FileLocate.topList .. "per_week_charm_n.png" } }
	-- local _charm_info = { x = 36, y = 239, width = 89, height = 20, gapsize = 30, image = {UIResourcePath.FileLocate.topList .. "charm_n.png",
	--  UIResourcePath.FileLocate.topList .. "charm_n.png"} }
	-- local _left_bg_info = { x = 0, y = 0, width = 162, height = 343, image = "ui/common/nine_grid_bg.png" }
	-- local _right_bg_info = { x = 167, y = 0, width = 555, height = 344, image = "ui/common/nine_grid_bg.png" }
	--分割线
	local _line_info =  { width = 214, height = 2, gapsize = 45, image = UIPOS_FlowerList_02 }

	local _right_title_info = {x = 280, y = 477, width = 584, height = 32, 
		sizeinfo =  {85, 205, 170, 120}, 
		fontsize = 18, 
			 text_change_info = {Lang.topList.flower[1], Lang.topList.flower[2]}, 
			 text = {Lang.topList.personal[5], Lang.topList.personal[6], Lang.topList.personal[7], Lang.topList.personal[8]} 
		} 
		-- [2088]="#c00ff00本周魅力" -- [2089]="#c00ff00魅力" 
		-- [2090]="#c00ff00排名" -- [2091]="#c00ff00角色名称" -- [2092]="#c00ff00阵营" -- [2097]="#c00ff00仙宗"
	--右拖动区域的范围
	local _scroll_info = {x = 266, y = 75, width = 585, height = 390, vertical = 1, horizontal = 5, maxnum = 1, gapsize = 10}
	--左标题文字的坐标
	local _radio_button_info =  {x = 32, y = 0, width = 230, height = 505, addtype = 1}
	-------每周排名
	local per_week_charm_button = ZImageButton:create(  nil, _list_btn_info.image,UILH_TOPLIST.per_week_charm_n, nil, 0, 0, _list_btn_info.width, _list_btn_info.height  )
	--获取跳转到每周链接的界面
	per_week_charm_button:setTouchClickFun( FlowerList.flower_per_week_charm_button_click_fun)
	--local per_week_charm_pos = self.per_week_charm_button:getPosition()
	-- self.per_week_charm_line = ZImage:create( per_week_charm_button.view, _line_info.image, 0, -1, _line_info.width, _line_info.height )
	-- local pet_line_pos = self.per_week_charm_line:getPosition()
	--------鲜花排行
	local charm_button = ZImageButton:create(  nil,  _list_btn_info.image,UILH_TOPLIST.charm, nil, 0, 0, _list_btn_info.width, _list_btn_info.height  )
	charm_button:setTouchClickFun(FlowerList.flower_charm_button_click_fun)
	--local charm_button_pos = self.charm_button:getPosition()
	-- self.charm_line = ZImage:create( charm_button.view, _line_info.image, 10, -15, _line_info.width, _line_info.height)
	------------------------------
	self.radio_button_group = ZRadioButtonGroup:create( nil, _radio_button_info.x, _radio_button_info.y, _radio_button_info.width, _radio_button_info.height, _radio_button_info.addtype)
	self.radio_button_group:addItem( per_week_charm_button, _list_btn_info.gapsize )
	self.radio_button_group:addItem( charm_button, _list_btn_info.gapsize )
	------------------------------
	self.right_title = ZListVertical:create( nil, _right_title_info.x, _right_title_info.y, _right_title_info.width, _right_title_info.height, _right_title_info.sizeinfo )
	local label_one = ZLabel:create( nil, _right_title_info.text[1], 0, 0, _right_title_info.fontsize, 2 )
	local label_two = ZLabel:create( nil, _right_title_info.text[2], 0, 0, _right_title_info.fontsize, 2 )
	-- local label_three = ZLabel:create( nil, _right_title_info.text[3], 0, 0, _right_title_info.fontsize )
	local label_four = ZLabel:create( nil, _right_title_info.text_change_info[1], 0, 0, _right_title_info.fontsize, 2 )
	local label_five = ZLabel:create( nil, _right_title_info.text[4], 0, 0, _right_title_info.fontsize, 2 )
	--local label_six = Label:create( nil, 0, 0, _right_title_info.text[5], _right_title_info.fontsize )
	self.right_title:addItem( label_one )
	self.right_title:addItem( label_two )
	-- self.right_title:addItem( label_three )
	self.right_title:addItem( label_four )
	self.right_title:addItem( label_five )
	--self.right_title:addItem( label_six )
	------------------------------
	self.scroll = ZScroll:create( nil, nil, _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, TYPE_HORIZONTAL_EX)
	--self.scroll.view:setLimitSize(10)
	self.scroll:setScrollLump( 10, 20, _scroll_info.height )
	--self.scroll.view:setScrollLumpPos( _scroll_info.width - 20 )
	self.scroll:setScrollCreatFunction(flower_scroll_create_fun)
	local arrow_up = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y+_scroll_info.height-2, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y-2, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
	------------------------------
	self.view:addChild( self.radio_button_group.view )
	self.view:addChild( self.right_title.view )
	self.view:addChild( self.scroll.view )
	self.view:addChild(arrow_up)
	self.view:addChild(arrow_down)
	
	-- 我的排名信息
	-- self.my_top_list_num = ZLabel:create(self.view, Lang.topList[2], 710, 36, 18)
end
------------------------------
------------------------------
function FlowerList:__init(window_name, texture_name, pos_x, pos_y, width, height)
	createFlowerList(self, width, height)
	_self_panel = self
end
------------------------------
function FlowerList:reinit_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		self.scroll.view:setMaxNum( panel_info.info.max_num )
		self.scroll:refresh()
	end
end
------------------------------
function FlowerList:refresh_panel()
	local temp_fun = { [TopListConfig.TopListType.PerWeekCharm] = self.flower_per_week_charm_button_click_fun, [TopListConfig.TopListType.Charm] =self.flower_charm_button_click_fun }
	-- self.radio_button_group:selectItem(_cur_index_select-1)
	temp_fun[ _cur_index_select ]() 
end
------------------------------
function FlowerList:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll.view:refresh()
	end
end
------------------------------
function FlowerList:clear_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
	end
end
------------------------------
function FlowerList:set_max_num(num)
	if self.scroll ~= nil then
		local cur_num = self.scroll.view:getMaxNum()
		if cur_num ~= num then
			self.scroll:setMaxNum( num )
		end
	end
end
-------------------------------
function FlowerList:reinit_info(info)
	local value = info and info[_cur_index_select+1] or TopListModel:get_my_top_list(_cur_index_select+1)
	local str = value ~= 0 and tostring(value) or Lang.topList.mytoplist[15]
	-- self.my_top_list_num:setText(Lang.topList[2] .. LH_COLOR[15] .. str)
end