----PlantWin.lua
----HJH
----2013-8-7
----
super_class.PlantWin(Window)
-----------------------------
local _cur_show_panel = nil
local _plant_win_panel = nil
-----------------------------
local function create_panel(self, tx, ty, width, height)
	-----------------------------
	self.bg = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "bg_1.jpg", tx, ty, width, height )
	self:addChild( self.bg.view )
	-----------------------------
	self.level_up_btn = ZButton:create( nil, UIResourcePath.FileLocate.plant .. "level_up.png", nil, tx + 100, height - 94 * 4 + ty + 20, -1, -1 )
	self.level_up_btn:setTouchClickFun( PlantModel.level_up_btn_fun )
	self:addChild( self.level_up_btn.view )
	-----------------------------
	local land_image_info = 
	{
		UIResourcePath.FileLocate.plant .. "land_1.png",
		UIResourcePath.FileLocate.plant .. "land_2.png",
		UIResourcePath.FileLocate.plant .. "land_3.png",
	}
	local land_info = 
	{
		{ x = tx + 241 - 6, y = height - 217 + ty + 18, width = -1, height = -1 }, --4
		{ x = tx + 162 - 6, y = height - 257 + ty + 18, width = -1, height = -1 }, --2
		{ x = tx + 321 - 6, y = height - 257 + ty + 18, width = -1, height = -1 }, --7
		{ x = tx + 83 - 6, y = height - 297 + ty + 18, width = -1, height = -1  }, --1
		{ x = tx + 241 - 6, y = height - 297 + ty + 18, width = -1, height = -1 }, --5
		{ x = tx + 402 - 6, y = height - 297 + ty + 18, width = -1, height = -1 }, --9
		{ x = tx + 162 - 6, y = height - 336 + ty + 18, width = -1, height = -1 }, --3
		{ x = tx + 321 - 6, y = height - 336 + ty + 18, width = -1, height = -1 }, --8
		{ x = tx + 241 - 6, y = height - 376 + ty + 18, width = -1, height = -1 }, --6
	}
	self.land_item = {}
	for i = 1, #land_info do
		-----------------------------
		self.land_item[i] = ZButton:create( nil, land_image_info[1], nil, land_info[i].x, land_info[i].y, land_info[i].width, land_info[i].height)
		local land_size = self.land_item[i]:getSize()
		self:addChild( self.land_item[i].view )
		local function land_fun()
			local index = i
			local build_panel_visible = self.build_panel.view:getIsVisible()
			local cur_room_info = PlantModel:get_cur_plant_room_info()
			--print("build_panel_visible,cur_room_info.land_info[index].seed_type",build_panel_visible,cur_room_info.land_info[index].seed_type)
			if build_panel_visible == false and cur_room_info.land_info[index].seed_type == 0 then
				PlantModel:init_build_info(index)
				--self.build_panel.view:setIsVisible(true)
			end
		end
		self.land_item[i]:setTouchClickFun( land_fun )
		-----------------------------
		self.land_item[i].plant = ZButton:create( nil, UIResourcePath.FileLocate.plant .. "plant_end_1_1.png", nil, 0, 0, -1, -1 )
		self.land_item[i].plant.view:setAnchorPoint( 0.5, 0 )
		self.land_item[i].plant:setPosition( land_size.width / 2, land_size.height / 2 - 18 )
		self.land_item[i]:addChild( self.land_item[i].plant )
		local function plant_fun()
			local temp_index = i
			PlantModel:plant_click_fun(temp_index)
		end
		self.land_item[i].plant:setTouchClickFun( plant_fun )
		-----------------------------
		self.land_item[i].plant_state = ZButton:create( nil, UIResourcePath.FileLocate.plant .. "plant_state_2.png", nil, 0, 0, -1, -1 )
		local plant_state_size = self.land_item[i].plant_state.view:getSize()
		self.land_item[i].plant_state:setPosition( ( land_size.width - plant_state_size.width ) / 2, ( land_size.height - plant_state_size.height ) / 2 + 30 )
		self.land_item[i]:addChild( self.land_item[i].plant_state )
		local function plant_state_fun()
			local temp_index = i
			PlantModel:plant_state_fun(temp_index)
		end
		self.land_item[i].plant_state:setTouchClickFun( plant_state_fun )
		-----------------------------
	end
	-----------------------------
	local left_button_info = 
	{
		{ x = tx + 9, y = height - 84 * 1 + ty + 20, width = -1, height = -1, isVisible = true, image = UIResourcePath.FileLocate.plant .. "qiuck.png", fun = PlantModel.one_key_quick },
		{ x = tx + 9, y = height - 84 * 2 + ty + 20, width = -1, height = -1, isVisible = true, image = UIResourcePath.FileLocate.plant .. "build_all.png", fun = PlantModel.build_all_btn_fun },
		{ x = tx + 9, y = height - 84 * 3 + ty + 20, width = -1, height = -1, isVisible = true, image = UIResourcePath.FileLocate.plant .. "xian.png", fun = PlantModel.xian_panel_btn_fun },
		{ x = tx + 9, y = height - 84 * 4 + ty + 20, width = -1, height = -1, isVisible = true, image = UIResourcePath.FileLocate.plant .. "event.png", fun = PlantModel.event_btn_fun },
	}
	self.left_button_item = {}
	for i = 1, #left_button_info do
		self.left_button_item[i] = ZButton:create( nil, left_button_info[i].image, nil, left_button_info[i].x, left_button_info[i].y, left_button_info[i].width, left_button_info[i].height )
		self:addChild( self.left_button_item[i].view )
		self.left_button_item[i]:setTouchClickFun( left_button_info[i].fun )
		self.left_button_item[i].view:setIsVisible( left_button_info[i].isVisible )
	end
	-----------------------------
	self.luck_time_lab = TimerLabel:create_label(self, left_button_info[3].x, left_button_info[3].y - 13, 16, 0, "#c38ff33", PlantWin.reset_luck_time, true  )
	self.help_btn = ZButton:create( nil, UIResourcePath.FileLocate.plant .. "help_btn.png", tx + 9, ty + 5, -1, -1 )
	self.help_btn:setTouchClickFun( PlantModel.help_btn_fun )
	self:addChild( self.help_btn.view )
	-----------------------------
	self.water = ZButton:create( nil, UIResourcePath.FileLocate.plant .. "water_1.png", nil, tx + 100, height - 61 + ty, -1, -1 )
	self:addChild( self.water.view )
	self.water:setTouchClickFun( PlantModel.send_water_power )
	-----------------------------
	self.water_timer = TimerLabel:create_label(self, tx + 100, height - 84 + ty, 16, 0, "#cfff000", PlantWin.reset_water_time, false  )
	-----------------------------
	self.process = ZXProgress:createWithValue( 0, 100, 79 , 21 )
	self.process:setPosition( tx + 100, height - 109 + ty )
	self:addChild( self.process )
	-----------------------------
	self.level_icon = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "level_1.png", tx + 240, height - 70 + ty + 10, 48, 48 )
	self:addChild( self.level_icon.view )
	local level_icon_size = self.level_icon:getSize()
	-----------------------------
	self.name_lab = ZLabel:create( nil, "a", tx + 245 + level_icon_size.width, height - 60 + ty + 10, 20 )
	self:addChild( self.name_lab.view )
	-----------------------------
	self.xianlu_lab = ZLabel:create( nil, string.format( Lang.plant.plant_xian_lu_info, 0 ), tx + 390, height - 340 + ty, 18 )
	self:addChild( self.xianlu_lab.view )
end
-----------------------------
function PlantWin:reset_luck_time()
	_plant_win_panel.luck_time_lab:setString("")
end
-----------------------------
function PlantWin:reset_water_time()
	_plant_win_panel.water_timer:setString("")
	_plant_win_panel:update_fun( PlantUpdateType.update_water_num )
	PlantModel:check_water_finish_friend_state()
end
-----------------------------
local function scroll_create_fun(self, index)
	local cur_room_info = PlantModel:get_cur_plant_room_info()
	local cur_friend_info = PlantModel:get_my_friend_info()
	local temp_info = cur_friend_info[index + 1]
	local basePanel = ZBasePanel:create( nil, nil, 0, 0, 145, 300 / 5 )
	local panel_size = basePanel:getSize()
	local friend_info = FriendModel:data_get_my_friend_info_by_id(temp_info.id)
	-----------------------------
	local select_image = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "select_bg.png", 0, 0, panel_size.width, panel_size.height , nil, 600, 600 )
	basePanel:addChild(select_image)
	if cur_room_info.role_id == temp_info.id then
		select_image.view:setIsVisible( true )
	else
		select_image.view:setIsVisible( false )
	end
	-----------------------------
	local name = ZLabel:create( nil, string.format( "#cfff000%s",friend_info.roleName ), 0, 0 )
	basePanel:addChild(name)
	local name_size = name:getSize()
	name:setPosition( 10, panel_size.height - name_size.height )
	local name_pos = name:getPosition()
	local water_state = Utils:get_bit_by_position( temp_info.state, 1 )
	local grass_state = Utils:get_bit_by_position( temp_info.state, 2 )
	local worm_state = Utils:get_bit_by_position( temp_info.state, 3 )
	print("temp_info.state,water_state, grass_state, worm_state",temp_info.state, water_state, grass_state, worm_state)
	-----------------------------
	local grass = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "plant_state_1.png", 0, 3, -1, -1 )
	if grass_state <= 0 then
		grass.view:setCurState(CLICK_STATE_DISABLE)
	end
	basePanel:addChild(grass)
	-----------------------------
	local worm = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "plant_state_2.png", panel_size.width / 3 , 3, -1, -1)
	if worm_state <= 0 then
		worm.view:setCurState(CLICK_STATE_DISABLE)
	end
	basePanel:addChild(worm)
	-----------------------------
	local water = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "water_1.png", panel_size.width / 3 * 2, 3, -1, -1 )
	if water_state <= 0 then
		water.view:setCurState(CLICK_STATE_DISABLE)
	end
	basePanel:addChild(water)
	-----------------------------
	local line = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", 0, 0, 145, 2 )
	basePanel:addChild(line)
	-----------------------------
	local function enter_friend_fun()
		local friend_id = temp_info.id
		PlantCC:client_exit()
		PlantCC:client_etner_room(friend_id)
	end
	basePanel:setTouchClickFun(enter_friend_fun)
	-----------------------------
	return basePanel
end
-----------------------------
local function create_friend_list( self, tx, ty, width, height )
	-----------------------------
	self.clip_panel = CCTouchPanel:touchPanel( tx, ty, width - 10, height )
	self:addChild( self.clip_panel )
	-----------------------------
	self.friend_list_panel = CCBasePanel:panelWithFile( 0, 0, width, height, "" )
	--self.friend_list_panel.view:setDefaultMessageReturn(false)
	self.clip_panel:addChild( self.friend_list_panel )
	-----------------------------
	local bg = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "left_bg.png", 45, 0, 190, height, nil, 600, 600 )
	self.friend_list_panel:addChild( bg.view )
	-----------------------------
	local title = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "friend_title.png", 104, height - 33, -1, -1 )
	self.friend_list_panel:addChild( title.view )
	-----------------------------
	self.scroll = ZScroll:create( nil, nil, 68, 10, 145, 300, 1, TYPE_HORIZONTAL )
	self.scroll:setScrollLump( 10, 40, 300 / 5 )
	--self.scroll.view:setTexture("ui/common/bg_06.png")
	self.friend_list_panel:addChild( self.scroll.view )
	self.scroll:setScrollCreatFunction( scroll_create_fun )
	-----------------------------
	self.friend_list_return_button = ZButton:create( nil, UIResourcePath.FileLocate.common .. "right_page_turn_btn_s.png", nil, 30, 0, -1, -1 )
	self.friend_list_panel:addChild( self.friend_list_return_button.view )
	self.friend_list_return_button.run_timer = false
	self.friend_list_return_button:setTouchClickFun( PlantWin.friend_list_return_btn_fun )
	-----------------------------
	self.return_btn = ZButton:create( nil, UIResourcePath.FileLocate.plant .. "return.png", nil, 0, height - 90 + ty, -1, -1 )
	self.friend_list_panel:addChild( self.return_btn.view )
	self.return_btn:setTouchClickFun( PlantModel.exit_plant_room )
	--self.return_btn.run_timer = false
end
-----------------------------
function PlantWin:friend_list_return_btn_fun()
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win == nil then
		return
	end
	if plant_win.friend_list_return_button.run_timer == false then
		plant_win.friend_list_return_button.run_timer = true
		local cur_pos = plant_win.friend_list_panel:getPosition() 
		if cur_pos > 95 then
			plant_win.friend_list_return_button:setTouchTimerFun( PlantWin.friend_panel_left_time_fun )
		else
			plant_win.friend_list_return_button:setTouchTimerFun( PlantWin.friend_panel_right_time_fun )
		end
		plant_win.friend_list_return_button.view:setTimer( 0.01 )
	end
end
-----------------------------
function PlantWin:friend_panel_left_time_fun()
	-----------------------------
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win == nil then
		return
	end
	if plant_win.friend_list_panel == nil then
		return
	end
	-----------------------------
	local cur_pos = plant_win.friend_list_panel:getPositionS()
	local cur_size = plant_win.friend_list_panel:getSize()
	local per_stept = 5
	local end_pos_x = 0
	local finish_timer = false
	-----------------------------
	local temp_pos = 0
	--print("PlantWin:friend_panel_left_time_fun cur_pos.x", cur_pos.x)
	if cur_pos.x + per_stept <= end_pos_x then
		finish_timer = true
		temp_pos = end_pos_x
	else
		temp_pos = cur_pos.x - per_stept
	end
	plant_win.friend_list_panel:setPosition( temp_pos, cur_pos.y )
	if finish_timer == true then
		plant_win.friend_list_return_button.view:setTimer( 0 )
		plant_win.friend_list_return_button.view:setFlipX( false )
		plant_win.friend_list_return_button.run_timer = false
	end	
end
-----------------------------
function PlantWin:friend_panel_right_time_fun()
	-----------------------------
	local plant_win = UIManager:find_visible_window("plant_win")
	if plant_win == nil then
		return
	end
	if plant_win.friend_list_panel == nil then
		return
	end
	-----------------------------
	local cur_pos = plant_win.friend_list_panel:getPositionS()
	local cur_size = plant_win.friend_list_panel:getSize()
	local cur_rotate = plant_win.friend_list_return_button.view:getRotation()
	local per_stept = 5
	local end_pos_x = 160
	local per_rotate = 90 / 160
	local finish_timer = false
	-----------------------------
	local temp_pos = 0
	--print("PlantWin:friend_panel_right_time_fun cur_pos.x",cur_pos.x)
	if cur_pos.x + per_stept >= end_pos_x then
		finish_timer = true
		temp_pos = end_pos_x
	else
		temp_pos = cur_pos.x + per_stept
	end
	plant_win.friend_list_panel:setPosition( temp_pos, cur_pos.y )
	if finish_timer == true then
		plant_win.friend_list_return_button.view:setTimer( 0 )
		plant_win.friend_list_return_button.view:setFlipX(true)
		plant_win.friend_list_return_button.run_timer = false
	end
end
-----------------------------
function PlantWin:hide_cur_show_panel()
	if _cur_show_panel ~= nil then
		_cur_show_panel.view:setIsVisible(false)
		_cur_show_panel = nil
	end
end
-----------------------------
function PlantWin:set_xian_panel_visible()
	if self.xian_panel ~= nil then
		local result = self.xian_panel.view:getIsVisible()
		self:hide_cur_show_panel()
		if result == true then
			self.xian_panel.view:setIsVisible( false )
		else
			self.xian_panel.view:setIsVisible( true )
			_cur_show_panel = self.xian_panel
			self.xian_panel:reinit()
		end
	end
end
-----------------------------
function PlantWin:set_qiuck_panel_visible()
	print("PlantWin:set_qiuck_panel_visible self.qiuck_panel",self.qiuck_panel)
	if self.qiuck_panel ~= nil then
		local result = self.qiuck_panel.view:getIsVisible()
		self:hide_cur_show_panel()
		if result == true then
			self.qiuck_panel.view:setIsVisible( false )
		else
			self.qiuck_panel.view:setIsVisible( true )
			_cur_show_panel = self.qiuck_panel
			self.qiuck_panel:reinit()
		end
	end
end
-----------------------------
function PlantWin:set_build_all_visible()
	if self.build_all_panel ~= nil then
		local result = self.build_all_panel.view:getIsVisible()
		self:hide_cur_show_panel()
		if result == true then
			self.build_all_panel.view:setIsVisible( false )
		else
			self.build_all_panel.view:setIsVisible( true )
			_cur_show_panel = self.build_all_panel
			self.build_all_panel:update_setlect()
		end
	end
end
-----------------------------
function PlantWin:set_build_visible()
	if self.build_panel ~= nil then
		local result = self.build_panel.view:getIsVisible()
		self:hide_cur_show_panel()
		if result == true then
			self.build_panel.view:setIsVisible( false )
		else
			self.build_panel.view:setIsVisible( true )
			_cur_show_panel = self.build_panel
		end
	end
end
-----------------------------
function PlantWin:set_event_panel_visible()
	if self.event_panel ~= nil then
		local result = self.event_panel.view:getIsVisible()
		self:hide_cur_show_panel()
		if result == true then
			self.event_panel.view:setIsVisible( false )
		else
			self.event_panel.view:setIsVisible( true )
			_cur_show_panel = self.event_panel
			if PlantModel:get_init_event_result() == false then
				PlantModel:set_init_event_result(true)
				PlantModel:get_event_info()
			end
		end
	end
end
-----------------------------
function PlantWin:set_help_panel_visible()
	if self.help_panel ~= nil then
		local result = self.help_panel.view:getIsVisible()
		self:hide_cur_show_panel()
		if result == true then
			self.help_panel.view:setIsVisible( false )
		else
			self.help_panel.view:setIsVisible( true )
			_cur_show_panel = self.help_panel
		end
	end
end
-----------------------------
function PlantWin:update_xian_panel_info(time, spend, index)
	if self.xian_panel ~= nil then
		self.xian_panel:update( time, spend, index )
	end
end
-----------------------------
-----------------------------
function PlantWin:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	-----------------------------
	require "UI/plant/PlantXian"
	require "UI/plant/PlantQiuck"
	require "UI/plant/PlantBuildAll"
	require "UI/plant/PlantBuild"
	require "UI/plant/PlantEvent"
	require "UI/plant/PlantHelp"
	-----------------------------
	create_panel( self, 25, 20, 698, 360 )
	create_friend_list( self, 20 + 479, 20, 236, 360 )
	-- local title = ZImageImage:create( nil, UIResourcePath.FileLocate.plant .. "title.png", UIResourcePath.FileLocate.common .. "win_title1.png", 0, 0, -1, -1 )
	-- title:setGapSize( -10, 3)
	-- self:addChild( title.view )
	-- local title_size = title.view:getSize()
	-- title:setPosition( (window_info.width - title_size.width) / 2, window_info.height - title_size.height )
	-----------------------------
	-- local exit = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png"}, nil, 0, 0, -1, -1 )
	-- self:addChild( exit.view )
	-- local exit_size = exit:getSize()
	-- exit:setPosition( width - exit_size.width, height - exit_size.height )
	-- local function exit_btn_fun()
	-- 	UIManager:hide_window("plant_win")
	-- 	PlantCC:client_exit()
	-- end
	-- exit:setTouchClickFun(exit_btn_fun)
	local temp_panel_info = { texture = UIResourcePath.FileLocate.common .. "bg_blue.png", x = 124, y = 35, width = 512, height = 338 }
	-----------------------------
	self.xian_panel = PlantXian("", temp_panel_info)
	self:addChild( self.xian_panel.view )
	self.xian_panel.view:setIsVisible( false )
	-----------------------------
	self.qiuck_panel = PlantQiuck("", temp_panel_info)
	self:addChild( self.qiuck_panel.view )
	self.qiuck_panel.view:setIsVisible( false )
	-----------------------------
	self.build_all_panel = PlantBuildAll("", temp_panel_info)
	self:addChild( self.build_all_panel.view )
	self.build_all_panel.view:setIsVisible( false )
	-----------------------------
	self.build_panel = PlantBuild("", temp_panel_info)
	self:addChild( self.build_panel.view )
	self.build_panel.view:setIsVisible( false )
	-----------------------------
	self.event_panel = PlantEvent("", temp_panel_info)
	self:addChild( self.event_panel.view )
	self.event_panel.view:setIsVisible( false )
	-----------------------------
	self.help_panel = PlantHelp("", temp_panel_info)
	self:addChild( self.help_panel.view )
	self.help_panel.view:setIsVisible( false )
	_plant_win_panel = self
end
-----------------------------
function PlantWin:active(show)
	if show then
		-- if GameSysModel:isSysEnabled( GameSysModel.DongFu, true ) == false then
		-- 	return
		-- end
		if PlantModel:get_init_plant_room_info() == false then
			PlantModel:reinit_plant_room_info()
			self:reset_plant_other_win_effect_info()
		end
		PlantModel:send_enter_my_plant()
		self:hide_cur_show_panel()
		local update_list = PlantModel:get_update_list()
		for i = 1, #update_list do
			self:update_fun( update_list[i] )
		end
		PlantModel:clear_update_list()
	else
		PlantCC:client_exit()
		self:reset_plant_other_win_effect_info()
		self:hide_other_panel()
	end
end
-----------------------------
function PlantWin:destroy()
	self.water_timer:destroy()
	self.luck_time_lab:destroy()
	Window.destroy(self)
	local temp_panel = { self.xian_panel, self.qiuck_panel, self.build_all_panel, self.build_panel, self.event_panel, self.help_panel }
	for i = 1, #temp_panel do
		if temp_panel[i] ~= nil then
			temp_panel[i]:destroy()
		end
	end
end
-----------------------------
function PlantWin:reset_plant_other_win_effect_info()
	self.build_all_panel:reset_win_effect()
	self.build_panel:reset_win_effect()
end
-----------------------------
local function check_button_state( self, info )
	local cur_play = EntityManager:get_player_avatar()
	local cur_room_info = PlantModel:get_cur_plant_room_info()
	if cur_play.id == info then
		self.return_btn.view:setIsVisible( false )
		if cur_room_info.level >= PlantConfig:get_dong_fu_max_level() then
			self.left_button_item[1].view:setIsVisible( true )
			self.left_button_item[2].view:setIsVisible( true )
		else
			self.left_button_item[1].view:setIsVisible( false )
			self.left_button_item[2].view:setIsVisible( false )
		end
		self.left_button_item[3].view:setIsVisible( true )
		self.left_button_item[4].view:setIsVisible( true )
		self.luck_time_lab.panel.view:setIsVisible( true )
	else
		self.return_btn.view:setIsVisible( true )
		self.left_button_item[1].view:setIsVisible( false )
		self.left_button_item[2].view:setIsVisible( false )
		self.left_button_item[3].view:setIsVisible( false )
		self.left_button_item[4].view:setIsVisible( false )
		self.luck_time_lab.panel.view:setIsVisible( false )
	end
end
-----------------------------
local function update_level_fun( self, level )
	-----------------------------
	local bg_image = string.format( "%s%s%d.jpg", UIResourcePath.FileLocate.plant, "bg_", level )
	self.bg.view:setTexture( bg_image )
	print("bg_image",bg_image)
	local level_image = string.format( "%s%s%d.png", UIResourcePath.FileLocate.plant, "level_", level )
	self.level_icon.view:setTexture( level_image )
	print("level_image",level_image)
	-----------------------------
	if level >= PlantConfig:get_dong_fu_max_level() or PlantModel:get_is_my_room() == false then
		self.level_up_btn.view:setIsVisible( false )
	else
		self.level_up_btn.view:setIsVisible( true )
	end
	-----------------------------
	local land_image = string.format( "%s%s%d.png", UIResourcePath.FileLocate.plant, "land_", level )
	print("land_image", land_image)
	for i = 1, #self.land_item do
		self.land_item[i].view:addTexWithFile( CLICK_STATE_UP , land_image )
		self.land_item[i].view:setCurState( CLICK_STATE_UP )
	end
	local cur_room_info = PlantModel:get_cur_plant_room_info()
	check_button_state(self, cur_room_info.role_id )
end
-----------------------------
local function update_land_fun( self, info )
	print("run update_land_fun")
	local cur_time = os.time()
	for i = 1, #self.land_item do
		if info[i].seed_type <= 0 then
			self.land_item[i].plant.view:setIsVisible( false )
			self.land_item[i].plant_state.view:setIsVisible( false )
		else
			self.land_item[i].plant.view:setIsVisible( true )
			self.land_item[i].plant.view:addTexWithFile( CLICK_STATE_UP, string.format( "%s%s%d_%d.png", UIResourcePath.FileLocate.plant, "plant_end_", info[i].seed_type, info[i].seed_quality ) )
			self.land_item[i].plant.view:setCurState( CLICK_STATE_UP )
			if info[i].seed_state <= 0 then
				self.land_item[i].plant_state.view:setIsVisible( false )
			else
				self.land_item[i].plant_state.view:setIsVisible( true )
				self.land_item[i].plant_state.view:addTexWithFile( CLICK_STATE_UP, string.format( "%s%s%d.png", UIResourcePath.FileLocate.plant, "plant_state_", info[i].seed_state ) )
				self.land_item[i].plant_state.view:setCurState( CLICK_STATE_UP )
			end
			if cur_time - info[i].seed_time >= 0 then
				self.land_item[i].plant_state.view:setIsVisible( true )
				self.land_item[i].plant_state.view:addTexWithFile( CLICK_STATE_UP, UIResourcePath.FileLocate.plant .. "get.png" )
				self.land_item[i].plant_state.view:setCurState( CLICK_STATE_UP )
			end
		end
	end
end
-----------------------------
local function update_water_time_fun( self, info )
	print("update_water_time_fun info",info)
	local cur_room_info = PlantModel:get_cur_plant_room_info()
	if info > 0 and cur_room_info.cur_water_power < cur_room_info.max_water_power then
		-- local water_time_info = Utils:format_time( info )
		-- if water_time_info.min > 0 then
		-- 	self.water_timer:setText( string.format( "%s分%s秒", water_time_info.min, water_time_info.sec ) )
		-- else
		self.water_timer:setText( info )
		--end
	else
		self.water_timer:setString( "" )
	end
end
-----------------------------
local function update_luck_fun( self, info )
	if info > 0 then 
		-- local luck_time_info = Utils:format_time( info )
		-- if luck_time_info.min > 0 then
		-- 	self.luck_time_lab.view:setText( string.format( "%s分%s秒", luck_time_info.min, luck_time_info.sec ) )
		-- else
		self.luck_time_lab:setText( info )
		--end
	else
		self.luck_time_lab:setString( "" )
	end
end
-----------------------------
local function update_water_process( self, cur, max )
	local cur_room_info = PlantModel:get_cur_plant_room_info()
	self.process:setProgressValue( cur, max )
	print("update_water_process cur,max",cur,max)
	if cur >= max then
		if PlantModel:get_is_my_room() == true and cur_room_info.is_get_price == 1 then
			self.water.view:addTexWithFile( CLICK_STATE_DISABLE, UIResourcePath.FileLocate.plant .. "water_2_d.png" )
			self.water.view:setCurState( CLICK_STATE_DISABLE )
		else
			self.water.view:addTexWithFile( CLICK_STATE_UP, UIResourcePath.FileLocate.plant .. "water_2.png" )
			self.water.view:setCurState( CLICK_STATE_UP )
		end
	elseif cur_room_info.water_cd - os.time() <= 0 then
		self.water.view:addTexWithFile( CLICK_STATE_UP, UIResourcePath.FileLocate.plant .. "water_1.png" )
		self.water.view:setCurState( CLICK_STATE_UP )
	else
		self.water.view:addTexWithFile( CLICK_STATE_DISABLE, UIResourcePath.FileLocate.plant .. "water_1_d.png" )
		self.water.view:setCurState( CLICK_STATE_DISABLE )
	end
end
-----------------------------
local function update_friend( self, info )
	self.scroll:setMaxNum( info )
	self.scroll:clear()
	self.scroll:refresh()
end
-----------------------------
local function update_event( self )
	self.event_panel:reinit()
end
-----------------------------
local function update_xianlu( self )
	if PlantModel:get_is_my_room() == true then
		local cur_room_info = PlantModel:get_cur_plant_room_info()
		self.xianlu_lab.view:setIsVisible( true )
		self.xianlu_lab.view:setText( string.format( Lang.plant.plant_xian_lu_info, cur_room_info.cur_build_num ) )
	else
		self.xianlu_lab.view:setIsVisible( false )
	end
end
-----------------------------
local function update_plant_build_yb(self)
	self.build_panel:update_cur_yb()
end
-----------------------------
function PlantWin:update_fun(stype)
	print("PlantWin:update_fun stype", stype)
	local temp_info = PlantModel:get_cur_plant_room_info()
	--------------safe check
	if temp_info == nil then
		return
	end
	--------------
	--print("temp_info.role_name", temp_info.role_name)
	if stype == PlantUpdateType.update_all then
		update_level_fun( self, temp_info.level )
		-----------------------------
		self.name_lab.view:setText( string.format( LangGameString[1784], temp_info.role_name ) ) -- [1784]="%s的洞府"
		-----------------------------
		update_water_time_fun( self, temp_info.water_cd - os.time() )
		-----------------------------
		update_water_process( self, temp_info.cur_water_power, temp_info.max_water_power )
		-----------------------------
		update_land_fun( self, temp_info.land_info )
		-----------------------------
		update_luck_fun( self, temp_info.luck_time - os.time() )
		-----------------------------
		check_button_state( self, temp_info.role_id )
		-----------------------------
		local cur_friend_info = PlantModel:get_my_friend_info()
		update_friend( self, #cur_friend_info )
		-----------------------------
		update_xianlu( self )
	elseif stype == PlantUpdateType.update_level then
		update_level_fun( self, temp_info.level )
	elseif stype == PlantUpdateType.update_land then
		update_land_fun( self, temp_info.land_info )
	elseif stype == PlantUpdateType.update_water_num then
		update_water_process( self, temp_info.cur_water_power, temp_info.max_water_power )
	elseif stype == PlantUpdateType.update_water_cd then
		update_water_time_fun( self, temp_info.water_cd - os.time() )
	elseif stype == PlantUpdateType.update_luck then
		update_luck_fun( self, temp_info.luck_time - os.time() )
	elseif stype == PlantUpdateType.update_friend then
		local cur_friend_info = PlantModel:get_my_friend_info()
		update_friend( self, #cur_friend_info )
	elseif stype == PlantUpdateType.update_event then
		update_event( self )
	elseif stype == PlantUpdateType.update_xianlu then
		update_xianlu( self )
	elseif stype == PlantUpdateType.update_build_yb then
		update_plant_build_yb( self)
	end
end
-----------------------------
function PlantWin:hide_other_panel()
	local temp_panel = { self.xian_panel, self.qiuck_panel, self.build_all_panel, self.build_panel, self.event_panel, self.help_panel }
	for i = 1, #temp_panel do
		temp_panel[i].view:setIsVisible(false)
	end
end
-----------------------------
function PlantWin:update_plant_build_win()
	if self.build_panel ~= nil then
		local plant_build_visible = self.build_panel.view:getIsVisible()
		-- if plant_build_visible == true then
			self.build_panel:reinit()
		-- end
	end
end
