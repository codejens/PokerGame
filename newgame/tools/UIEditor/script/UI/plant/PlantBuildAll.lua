----PlantBuildAll.lua
----HJH
----2013-8-7
----一键种植
super_class.PlantBuildAll(Window)
-----------------------------
local plant_build_all_panel = nil
local _last_item_select = 0
local select_effect = 10007
-----------------------------
local function create_panel( self, width, height )
	-----------------------------
	local title = ZImageImage:create( nil, UIResourcePath.FileLocate.plant .. "plant_item_titel.png", UIResourcePath.FileLocate.common .. "dialog_title_bg.png", 0, 0, -1, -1 )
	local title_size = title:getSize()
	title:setPosition( (width - title_size.width) / 2, height - title_size.height / 2 - 8 )
	self:addChild( title.view )
	-----------------------------
	local role_bg = ZImage:create( nil, "nopack/npc1.png" , 0, 0, -1, -1)
	role_bg.view:setAnchorPoint( 1, 0 )
	role_bg:setPosition( 145 + 150 - 14, height - 313 - 3 )
	self:addChild( role_bg.view )
	-----------------------------
	local bg = ZImage:create( nil, UIPIC_GRID_nine_grid_bg3, 155, height - 255, 280 + 50, 220, nil, 600, 600 )
	self:addChild( bg.view )
	-----------------------------
	self.slot_item_left = SlotItem( 48, 48 )
	self.slot_item_left:set_icon_bg_texture( UIPIC_ITEMSLOT, -7, -7, 62, 62 )
	self.slot_item_left:set_icon_texture( UIResourcePath.FileLocate.plant .. "plant_begin_1.png" )
	self:addChild( self.slot_item_left.view )
	self.slot_item_left.view:setPosition( 217, height - 122 )
	local function left_fun()
		PlantModel:build_all_seed_type_select( 1 )
		plant_build_all_panel:update_setlect(  )
	end
	self.slot_item_left:set_click_event( left_fun )
	-----------------------------
	self.slot_item_right = SlotItem( 48, 48 )
	self.slot_item_right:set_icon_bg_texture( UIPIC_ITEMSLOT, -7, -7, 62, 62 )
	self.slot_item_right:set_icon_texture( UIResourcePath.FileLocate.plant .. "plant_begin_5_d.png")
	self:addChild( self.slot_item_right.view )
	self.slot_item_right.view:setPosition( 315, height - 122 )
	local function right_fun()
		PlantModel:build_all_seed_type_select( 5 )
		plant_build_all_panel:update_setlect(  )
	end
	self.slot_item_right:set_click_event( right_fun )
	-----------------------------
	self.name_lab = ZLabel:create( nil, string.format( Lang.plant.plant_build_all_info.name_info, "a" ), 160, height - 157 )
	self:addChild( self.name_lab.view )
	-----------------------------
	self.get_lab = ZLabel:create( nil, string.format( Lang.plant.plant_build_all_info.get_info, 0, 0 ), 160, height - 186 )
	self:addChild( self.get_lab.view )
	-----------------------------
	self.num_lab = ZLabel:create( nil, string.format( Lang.plant.plant_build_all_info.num_info, 0), 160, height - 215 )
	self:addChild( self.num_lab.view )
	-----------------------------
	self.spend_lab = ZLabel:create( nil, string.format( Lang.plant.plant_build_all_info.spend_info, 1), 160, height - 250 )
	self:addChild( self.spend_lab.view )
	-----------------------------
	self.button = ZImageButton:create( nil, UIResourcePath.FileLocate.common .. "tishi_button.png",
	 UIResourcePath.FileLocate.plant .. "plant_all_btn.png", nil, (width - 110) / 2 + 180, height - 313, 110, 41, 600, 600 )
	self:addChild( self.button.view )
	self.button:setTouchClickFun( PlantModel.send_buill_all )
	-----------------------------
	local exit_btn = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_z.png", UIResourcePath.FileLocate.common .. "close_btn_z.png" }, nil, 0, 0, -1, -1 )
	local exit_size = exit_btn:getSize()
	exit_btn:setPosition( width - exit_size.width , height - exit_size.height )
	exit_btn:setTouchClickFun(PlantModel.build_all_btn_fun)
	self:addChild( exit_btn.view )
end
-----------------------------
function PlantBuildAll:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	create_panel( self, window_info.width, window_info.height )
	plant_build_all_panel = self
end
-----------------------------
function PlantBuildAll:reset_win_effect()
	_last_item_select = 0
	LuaEffectManager:stop_view_effect( select_effect,self.slot_item_left.view )
	LuaEffectManager:stop_view_effect( select_effect,self.slot_item_right.view )
end
-----------------------------
function PlantBuildAll:update_setlect( )
	print("run PlantBuildAll:update_setlect")
	local empty_land = PlantModel:get_my_empty_land()
	local cur_play = EntityManager:get_player_avatar()
	local cur_room_info = PlantModel:get_cur_plant_room_info()
	local award_info = PlantConfig:get_plant_award_info( cur_room_info.cur_build_all_select, cur_play.level )
	local luck_price = PlantConfig:get_luck_award_info( cur_room_info.level )
	if cur_room_info.luck_time - os.time() <= 0 then
		luck_price = 0
	end
	local land_price = PlantConfig:get_land_award_info( cur_room_info.level )
	print("luck_price,land_price",luck_price,land_price)
	-----------------------------
	local temp_num = empty_land
	if empty_land > cur_room_info.cur_build_num then
		temp_num = cur_room_info.cur_build_num
	end
	-----------------------------
	if _last_item_select ~= cur_room_info.cur_build_all_select then
		_last_item_select = cur_room_info.cur_build_all_select
		if cur_room_info.cur_build_all_select == 1 then
			self.slot_item_left:set_icon_texture( UIResourcePath.FileLocate.plant .. "plant_begin_1.png" )
			LuaEffectManager:play_view_effect( select_effect,0,0,self.slot_item_left.view ,true)
			self.slot_item_right:set_icon_texture( UIResourcePath.FileLocate.plant .. "plant_begin_5_d.png" )
			LuaEffectManager:stop_view_effect( select_effect,self.slot_item_right.view )
			self.name_lab.view:setText( string.format( Lang.plant.plant_build_all_info.name_info, LangGameString[1776] ) ) -- [1776]="普通的神农草"
			
		else
			self.slot_item_left:set_icon_texture( UIResourcePath.FileLocate.plant .. "plant_begin_1_d.png" )
			LuaEffectManager:stop_view_effect( select_effect,self.slot_item_left.view )
			self.slot_item_right:set_icon_texture( UIResourcePath.FileLocate.plant .. "plant_begin_5.png" )
			LuaEffectManager:play_view_effect( select_effect,0,0,self.slot_item_right.view ,true)
			self.name_lab.view:setText( string.format( Lang.plant.plant_build_all_info.name_info, LangGameString[1777] ) ) -- [1777]="百年的神农草"
			
		end
	end
	if cur_room_info.cur_build_all_select == 1 then
		self.spend_lab.view:setText( string.format( Lang.plant.plant_build_all_info.spend_info, 0 ) )
	else
		self.spend_lab.view:setText( string.format( Lang.plant.plant_build_all_info.spend_info, temp_num * PlantConfig:get_build_full_level_money() ) )
	end
	-----------------------------
	self.get_lab.view:setText( string.format( Lang.plant.plant_build_all_info.get_info, temp_num * award_info, temp_num * luck_price * award_info + temp_num * land_price * award_info ) )
	self.num_lab.view:setText( string.format( Lang.plant.plant_build_all_info.num_info, temp_num ) )
	-----------------------------
	if empty_land <= 0 then
		self.button.view:setCurState(CLICK_STATE_DISABLE)
	else
		self.button.view:setCurState(CLICK_STATE_UP)
	end
	-----------------------------
end

function PlantBuildAll:active(show)
	-- if show == false then
	-- 	PlantModel:build_all_btn_fun()
	-- end
end