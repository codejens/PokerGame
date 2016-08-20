------------------------------
------------------------------
----HJH
----2013-2-27
----宠物坐骑排行榜界面
------------------------------
super_class.PetList(Window)
------------------------------
local _cur_index_select = TopListConfig.TopListType.Pet
local _self_panel = nil
------------------------------
function PetList:pet_pet_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Pet
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.pet[1]) -- [2115]="#c00ff00通灵兽"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
		_self_panel.radio_button_group:selectItem(0)
	end
end
---------------
function PetList:pet_mount_button_click_fun()
	if _self_panel ~= nil then
		_cur_index_select = TopListConfig.TopListType.Mount
		local temp_name = _self_panel.right_title:getIndexItem(3)
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		temp_name:setText(Lang.topList.pet[2]) -- [2116]="#c00ff00坐骑"
		_self_panel.scroll.view:reinitScroll()
		_self_panel.scroll:setMaxNum( panel_info.info.max_num )
		_self_panel.scroll:refresh()
		_self_panel:reinit_info()
	end	
end
------------------------------
local function pet_scroll_create_item(index, topListStruct, itemWidth, itemHeight, sizeInfo)
	---------------
	local list_vector = ZListVertical:create( nil, 0, 0, itemWidth, itemHeight, sizeInfo )
	local image = ZImage:create( nil, UILH_COMMON.split_line, 0, 0, itemWidth, 2)

	list_vector.view:addChild(image.view)
	local x = 10;
	local index_label = ZLabel:create( nil, index, x, 0 )
	local top_list_win = UIManager:find_window("top_list_win")
	local item_name = nil
	local str_name = nil
	if _cur_index_select == TopListConfig.TopListType.Mount then
		print(">>>>>>>>>>>>>>>>>>>topListStruct.mountStage",topListStruct.mountStage)
		local mount_data = MountsConfig:get_mount_data_by_id(topListStruct.mountStage)
		-- print(">>>>>>>>>>>>>>>>>>>>>mount_data.name",mount_data.name)
		if mount_data== nil then
			str_name=""
		else
			print(">>>>>>>>>>>>>>>>>>>>>mount_data.name",mount_data.name)
			str_name=mount_data.name
		end
		item_name = ZLabel:create( nil, LH_COLOR[2] .. str_name, x, 0)
	else
		item_name = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.petName, x, 0)
	end
	local name_panel = QQVipInterface:create_qq_vip_info( topListStruct.qqVip, LH_COLOR[2] .. topListStruct.playerName )
	--设置名字为可点穿
	name_panel:setDefaultReturnValue( false )
	-- local camp_label = ZLabel:create( nil, Lang.camp_info[topListStruct.campId], x, 0 )
	local xz_label = ZLabel:create( nil, LH_COLOR[2] .. topListStruct.guildName, x, 0 )
	local fight_label = ZLabel:create( nil, LH_COLOR[2] .. tostring(topListStruct.point), x, 0 )
	list_vector:addItem( index_label )
	list_vector:addItem( name_panel )
	list_vector:addItem( item_name )
	-- list_vector:addItem( camp_label )
	list_vector:addItem( fight_label )
	list_vector:addItem( xz_label )
	local function click_fun()
		local self_id = EntityManager:get_player_avatar().id
		if topListStruct.playerId ~= self_id then
			local info 
			if _cur_index_select == TopListConfig.TopListType.Mount then
				info = {roleId = topListStruct.playerId, roleName = topListStruct.playerName, qqvip = topListStruct.qqVip, level = topListStruct.level, camp = topListStruct.campId, job = topListStruct.job, sex = topListStruct.sex }
				LeftClickMenuMgr:show_left_menu("top_list_mount", info)
			else
				info = {roleId = topListStruct.playerId, roleName = topListStruct.playerName, qqvip = topListStruct.qqVip, level = topListStruct.level, camp = topListStruct.campId, job = topListStruct.job, sex = topListStruct.sex ,master_id = topListStruct.playerId , pet_id = topListStruct.petId }
				LeftClickMenuMgr:show_left_menu("top_list_pet", info)
			end
		end
	end
	list_vector:setTouchClickFun(click_fun)
	return list_vector
end
---------------
local function pet_scroll_create_fun(self, index)
	---------------
	local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
	local list_info = {vertical = 1, horizontal = 5}
	local size_info = { 75, 120, 160, 145, 75 }
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
	--print(string.format("index * list_info.horizontal=%d #_top_list_info[_pet_scroll_type][index]=%d",index * list_info.horizontal,#_top_list_info[_pet_scroll_type][index]))
	if index <= panel_info.info.max_num then
		local list = ZList:create( nil, 0, 0, 584, 190, list_info.vertical, list_info.horizontal )
		for i = 1, list_info.horizontal do
			if temp_info[i] ~= nil then
				local item = pet_scroll_create_item( index * list_info.horizontal + i, temp_info[i], 584, 190 / list_info.horizontal, size_info)
				list:addItem( item )
			end
		end
		return list
	end
end
------------------------------
local function createPetList(self, width, height)
	------------------------------
	local _window_size = {width = 800, height = 400}
	local _list_btn_info = { 
		x = 20, y = 250, width = -1 , height = -1, gapsize = -2, 
		image = {
			UILH_TOPLIST.left_btn_nor,UILH_TOPLIST.left_btn_sel
		} 
	}
	-- local _left_bg_info = { x = 0, y = 0, width = 162, height = 343, image = "ui/common/nine_grid_bg.png" }
	-- local _right_bg_info = { x = 167, y = 0, width = 555, height = 344, image = "ui/common/nine_grid_bg.png" }
	local _line_info = { width = 214, height = 2, gapsize = 45, image = UIPOS_PetList_02 }

	local _right_title_info = {x = 285, y = 477, width = 584, height = 32, 
		sizeinfo =  { 80, 110, 170, 150, 60 }, 
		fontsize = 18, 
		text_change_info = {Lang.topList.pet[1], Lang.topList.pet[2]}, 
		text = {Lang.topList.personal[5], Lang.topList.wing[3], Lang.topList.personal[7], Lang.topList.personal[8], Lang.topList.personal[1]} 
	}
		-- [2115]="#c00ff00宠物" -- [2116]="#c00ff00坐骑" 
		-- [2090]="#c00ff00排名" -- [2117]="#c00ff00主人" -- [2092]="#c00ff00阵营" -- [2097]="#c00ff00仙宗" -- [2111]="#c00ff00战斗力"

	local _scroll_info =  {x = 266, y = 75, width = 585, height = 390, vertical = 1, horizontal = 10, maxnum = 1, gapsize = 10}
	local _radio_button_info = {x = 32, y = 0, width = 230, height = 505, addtype = 1}
	------------------------------
	local pet_button = ZImageButton:create(  nil,  _list_btn_info.image,UILH_TOPLIST.pet, nil, 0, 0, _list_btn_info.width, _list_btn_info.height  )
	pet_button:setTouchClickFun(PetList.pet_pet_button_click_fun)
	--local pet_button_pos = self.pet_button:getPosition()
	-- self.pet_line = ZImage:create( pet_button.view, _line_info.image, 0, -1, _line_info.width, _line_info.height )
	-- local pet_line_pos = self.pet_line:getPosition()
	------------------------------
	local mount_button = ZImageButton:create(  nil,  _list_btn_info.image,UILH_TOPLIST.mount, nil, 0, 0, _list_btn_info.width, _list_btn_info.height  )
	mount_button:setTouchClickFun(PetList.pet_mount_button_click_fun)

	-- self.mount_line = ZImage:create( mount_button.view, _line_info.image, 10, -15 ,_line_info.width, _line_info.height)

	------------------------------
	self.radio_button_group = ZRadioButtonGroup:create( nil, _radio_button_info.x, _radio_button_info.y, _radio_button_info.width, _radio_button_info.height, _radio_button_info.addtype)
	self.radio_button_group:addItem( pet_button, _list_btn_info.gapsize )
	self.radio_button_group:addItem( mount_button, _list_btn_info.gapsize )
	------------------------------
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
	--self.scroll.view:setLimitSize(10)
	self.scroll:setScrollLump( 10, 20, _scroll_info.height)
	--self.scroll.view:setScrollLumpPos( _scroll_info.width - 20 )
	self.scroll:setScrollCreatFunction(pet_scroll_create_fun)
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
function PetList:__init(window_name, texture_name, pos_x, pos_y, width, height)
	createPetList(self, width, height)
	_self_panel = self
end
------------------------------
function PetList:reinit_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
		local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
		self.scroll.view:setMaxNum( panel_info.info.max_num )
		self.scroll:refresh()
	end
end
------------------------------
function PetList:refresh_panel()
	local temp_fun = { [TopListConfig.TopListType.Pet] = self.pet_pet_button_click_fun, [TopListConfig.TopListType.Mount] = self.pet_mount_button_click_fun }
	-- self.radio_button_group:selectItem(_cur_index_select-1)
	temp_fun[ _cur_index_select ]() 
end
------------------------------
function PetList:refresh_scroll()
	if self.scroll ~= nil then
		self.scroll:refresh()
	end
end
------------------------------
function PetList:clear_scroll()
	if self.scroll ~= nil then
		self.scroll.view:reinitScroll()
	end
end
------------------------------
function PetList:set_max_num(num)
	if self.scroll ~= nil then
		local cur_num = self.scroll.view:getMaxNum()
		if cur_num ~= num then
			self.scroll:setMaxNum( num )
		end
	end
end
-------------------------------
function PetList:reinit_info(info)
	local value = info and info[_cur_index_select+1] or TopListModel:get_my_top_list(_cur_index_select+1)
	local str = value ~= 0 and tostring(value) or Lang.topList.mytoplist[15]
	-- self.my_top_list_num:setText(Lang.topList[2] .. LH_COLOR[15] .. str)
end