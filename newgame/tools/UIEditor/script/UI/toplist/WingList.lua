------------------------------
------------------------------
----HJH
----2013-2-27
----翅膀排行榜界面(式神)
------------------------------
super_class.WingList(Window)
------------------------------
local _cur_index_select = TopListConfig.TopListType.Trump
local _self_panel = nil
------------------------------
function WingList:wing_wing_button_click_fun()
	-- print("WingList:wing_wing_button_click_fun()")
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Wing
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.wing[1]) -- [2120]="#c00ff00翅膀"
		_self_panel.scroll.view:reinitScroll()
		-- print("panel_info.info.max_num---------------------",panel_info.info.max_num)
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
	end
end
---------------灵器
function WingList:wing_trump_button_click_fun()
	-- print("WingList:wing_trump_button_click_fun()")
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Trump
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.wing[4])
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
		_self_panel.radio_button_group:selectItem(0)
	end
end
------------------------------
local function wing_scroll_create_item( index, topListStruct, itemWidth, itemHeight, sizeInfo )
	---------------
	local list_vector = ZListVertical:create( nil, 0, 0, itemWidth, itemHeight, sizeInfo )

	local image = ZImage:create( nil, UILH_COMMON.split_line, 0, 0, itemWidth, 2)

	list_vector.view:addChild(image.view)
	local index_label = ZLabel:create( nil, LH_COLOR[2] .. tostring(index), 0, 0 )
	local item_name = nil
	local str_name = nil
	
	if _cur_index_select == TopListConfig.TopListType.Wing then
		local temp_item = ItemConfig:get_item_by_id( topListStruct.wingId)
		item_name = ZLabel:create( nil, LH_COLOR[2] .. tostring(temp_item.name), 0, 0)
	elseif _cur_index_select == TopListConfig.TopListType.Trump then
		local fabao_name = FabaoConfig:get_fabao_name( topListStruct.gemStage ) or ""
		item_name = ZLabel:create( nil, LH_COLOR[2] .. fabao_name, 0, 0 )
		 --print(">>>>>>>>>>>>> SpriteConfig:get_sprite_data_by_id(topListStruct.gemStage)",FabaoConfig:get_fabao_name( topListStruct.gemStage ))
		-- local sprite_name = SpriteModel:get_spritename_by_modelid(topListStruct.gemStage)
		-- if sprite_name == nil then
		-- 	 sprite_name = ""
		-- end
		-- item_name = ZLabel:create(nil,LH_COLOR[2] .. sprite_name,0,0)
	end

	local name_panel = QQVipInterface:create_qq_vip_info( topListStruct.qqVip, LH_COLOR[2] .. topListStruct.playerName )
	--设置名字为可点穿
	name_panel:setDefaultReturnValue( false )
	-- local camp_label = ZLabel:create( nil, Lang.camp_info[topListStruct.campId], 0, 0 )
	local xz_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.guildName, 0, 0 )
	local fight_label = ZLabel:create( nil, LH_COLOR[2] .. tostring(topListStruct.point) , 0, 0)
	list_vector:addItem( index_label )
	list_vector:addItem( name_panel )
	list_vector:addItem( item_name )
	-- list_vector:addItem( camp_label )
	list_vector:addItem( fight_label )
	list_vector:addItem( xz_label )

	local function click_fun()
		local info = {roleId = topListStruct.playerId, roleName = topListStruct.playerName, qqvip = topListStruct.qqVip, level = topListStruct.level, camp = topListStruct.campId, job = topListStruct.job, sex = topListStruct.sex }
		--params.roleId, params.roleName, params.level,params.camp, params.job, params.sex
		if info.roleName ~= EntityManager:get_player_avatar().name then
			if _cur_index_select == TopListConfig.TopListType.Wing then
				LeftClickMenuMgr:show_left_menu("top_list_wing", info)
			else
				LeftClickMenuMgr:show_left_menu("top_list_trump", info)
			end
		end
	end

	list_vector:setTouchClickFun(click_fun)
	return list_vector
end
---------------
local function wing_scroll_create_fun(self, index)
	---------------
	local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
	local list_info = {vertical = 1, horizontal = 5}
	local size_info = { 75, 120, 160, 145, 75}
	local temp_info = TopListModel:data_get_top_list_index_index_info( _cur_index_select, index )
	if temp_info == nil and #panel_info.info == 0 and panel_info.init == false then
		TopListModel:data_set_top_list_index_init( _cur_index_select, true )
		_self_panel.scroll:setMaxNum(0)
		return nil
	end
	if temp_info == nil then
		return nil
	end
	if index <= panel_info.info.max_num then
		local list = ZList:create( nil, 0, 0, 585, 190, list_info.vertical, list_info.horizontal )
		for i = 1, list_info.horizontal do
			if temp_info[i] ~= nil then
				local item = wing_scroll_create_item( index * list_info.horizontal + i, temp_info[i], 584, 190 / list_info.horizontal, size_info )
				list:addItem( item )
			end
		end
		return list
	end
end
------------------------------
local function createWingList(self, width, height)
	------------------------------
	--local _window_size = {width = 800, height = 450}
	--左排标题底色
	local _list_btn_info = {
		 x = 20, y = 250, width = -1 , height = -1, gapsize = -2, 
		image = {
		    UILH_TOPLIST.left_btn_nor,UILH_TOPLIST.left_btn_sel
		} 
	}
	-- local _trump_btn_info = { x = 36, y = 289, width = -1, height = -1, gapsize = 30, image = { UIResourcePath.FileLocate.topList .. "trump_n.png", UIResourcePath.FileLocate.topList .. "trump_n.png" } }
	local _line_info = { width = 214, height = 2, gapsize = 45, image = UIPOS_WingList_03 }

	local _right_title_info = {x = 285, y = 477, width = 584, height = 32, 
		sizeinfo =  {   80, 110, 170, 150, 60 }, 
		fontsize = 18, 
		 text_change_info = {Lang.topList.wing[1], Lang.topList.wing[2]}, 
		 text = {Lang.topList.personal[5], Lang.topList.wing[3], Lang.topList.personal[7], Lang.topList.personal[8], Lang.topList.personal[1]} 
		 }
	-- [2120]="#c00ff00翅膀" -- [2121]="#c00ff00法宝" 
	-- [2090]="#c00ff00排名" -- [2117]="#c00ff00主人" -- [2092]="#c00ff00阵营" -- [2097]="#c00ff00仙宗" -- [2111]="#c00ff00战斗力"

	local _scroll_info = {x = 266, y = 75, width = 585, height = 390, vertical = 1, horizontal = 10, maxnum = 1, gapsize = 10}
	local _radio_button_info = {x = 32, y = 0, width = 230, height = 505, addtype = 1}

    ----------------------------------------------------
	local trump_button = ZImageButton:create(  nil,  _list_btn_info.image,UILH_TOPLIST.lingqi, nil, 0, 0, _list_btn_info.width, _list_btn_info.height  )
	trump_button:setTouchClickFun(WingList.wing_trump_button_click_fun)

	local wing_button = ZImageButton:create(  nil,  _list_btn_info.image,UILH_TOPLIST.chibang, nil, 0, 0, _list_btn_info.width, _list_btn_info.height  )
	wing_button:setTouchClickFun(WingList.wing_wing_button_click_fun)

	-- 左：分割线
	-- self.trump_line = ZImage:create( trump_button.view, _line_info.image, 10, -15, _line_info.width, _line_info.height )

	self.radio_button_group = ZRadioButtonGroup:create( nil, _radio_button_info.x, _radio_button_info.y, _radio_button_info.width, _radio_button_info.height, _radio_button_info.addtype)

	self.radio_button_group:addItem( trump_button, _list_btn_info.gapsize)
	self.radio_button_group:addItem( wing_button, _list_btn_info.gapsize)


	------------------------------


	------------------------------标题栏
	self.right_title = ZListVertical:create( nil, _right_title_info.x, _right_title_info.y, _right_title_info.width, _right_title_info.height, _right_title_info.sizeinfo )

	local label_one = ZLabel:create( nil, _right_title_info.text[1], 0, 0, _right_title_info.fontsize, 2 )
	local label_two = ZLabel:create( nil, _right_title_info.text[2], 0, 0, _right_title_info.fontsize, 2 )
	local label_three = ZLabel:create( nil, _right_title_info.text_change_info[1], 0, 0, _right_title_info.fontsize, 2 )
	-- local label_four = ZLabel:create( nil, _right_title_info.text[3], 0, 0, _right_title_info.fontsize )
	local label_five = ZLabel:create( nil, _right_title_info.text[5], 0, 0, _right_title_info.fontsize, 2 )
	local label_six = ZLabel:create( nil, _right_title_info.text[4], 0, 0, _right_title_info.fontsize, 2 )
	self.right_title:addItem( label_one )
	self.right_title:addItem( label_two )
	self.right_title:addItem( label_three )
	-- self.right_title:addItem( label_four )
	self.right_title:addItem( label_five )
	self.right_title:addItem( label_six )
	------------------------------
	self.scroll = ZScroll:create( nil, nil, _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, TYPE_HORIZONTAL_EX)
	self.scroll:setScrollLump( 10, 20, _scroll_info.height )
	--self.scroll.view:setScrollLumpPos( _scroll_info.width - 20 )
	self.scroll:setScrollCreatFunction( wing_scroll_create_fun )
	local arrow_up = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y+_scroll_info.height-2, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
	local arrow_down = CCZXImage:imageWithFile(_scroll_info.x+_scroll_info.width, _scroll_info.y-2, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
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

function WingList:__init(window_name, texture_name,is_grid, width, height)
	createWingList(self, width, height)
	_self_panel = self
end
------------------------------
function WingList:reinit_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		self.scroll.view:setMaxNum( panel_info.info.max_num )
		self.scroll:refresh()
	end
end
------------------------------
function WingList:refresh_panel()
	local temp_fun = { [TopListConfig.TopListType.Trump] = self.wing_trump_button_click_fun, [TopListConfig.TopListType.Wing] = self.wing_wing_button_click_fun }
	temp_fun[ _cur_index_select ]() 
end
------------------------------
function WingList:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll:refresh()
	end
end
------------------------------
function WingList:clear_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
	end
end
------------------------------
function WingList:set_max_num(num)
	if self.scroll ~= nil then
		local cur_num = self.scroll.view:getMaxNum()
		if cur_num ~= num then
			self.scroll:setMaxNum( num )
		end
	end
end
-------------------------------
function WingList:reinit_info(info)
	local value = info and info[_cur_index_select+1] or TopListModel:get_my_top_list(_cur_index_select+1)
	local str = value ~= 0 and tostring(value) or Lang.topList.mytoplist[15]
	-- self.my_top_list_num:setText(Lang.topList[2] .. LH_COLOR[15] .. str)
end