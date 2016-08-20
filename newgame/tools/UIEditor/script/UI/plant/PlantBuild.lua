----PlantBuild.lua
----HJH
----2013-8-7
----种植界面
super_class.PlantBuild(Window)
-----------------------------
local _last_plant_select = 0
local select_effect = 10007
local name_info = 
{ 
	{ plant_image = UIResourcePath.FileLocate.plant .. "plant_begin_1.png", plant_image_d = UIResourcePath.FileLocate.plant .. "plant_begin_1_d.png", image = UIResourcePath.FileLocate.plant .. "notic_1.png", fun = nil }, 
	{ plant_image = UIResourcePath.FileLocate.plant .. "plant_begin_2.png", plant_image_d = UIResourcePath.FileLocate.plant .. "plant_begin_2_d.png", image = UIResourcePath.FileLocate.plant .. "notic_2.png", fun = nil },
	{ plant_image = UIResourcePath.FileLocate.plant .. "plant_begin_3.png", plant_image_d = UIResourcePath.FileLocate.plant .. "plant_begin_3_d.png", image = UIResourcePath.FileLocate.plant .. "notic_3.png", fun = nil },
	{ plant_image = UIResourcePath.FileLocate.plant .. "plant_begin_4.png", plant_image_d = UIResourcePath.FileLocate.plant .. "plant_begin_4_d.png", image = UIResourcePath.FileLocate.plant .. "notic_4.png", fun = nil },
	{ plant_image = UIResourcePath.FileLocate.plant .. "plant_begin_5.png", plant_image_d = UIResourcePath.FileLocate.plant .. "plant_begin_5_d.png", image = UIResourcePath.FileLocate.plant .. "notic_5.png", fun = nil },
}
local _cur_panel_win = nil
-----------------------------
local function create_panel( self, width, height )
	-----------------------------
	local title = ZImageImage:create( nil, UIResourcePath.FileLocate.plant .. "plant_title.png", UIResourcePath.FileLocate.common .. "dialog_title_bg.png", 0, 0, -1, -1 )
	local title_size = title:getSize()
	title:setPosition( (width - title_size.width) / 2, height - title_size.height / 2 - 8 )
	self:addChild( title.view )
	-----------------------------
	local exit_btn = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_z.png", UIResourcePath.FileLocate.common .. "close_btn_z.png" }, nil, 0, 0, -1, -1 )
	local exit_size = exit_btn:getSize()
	exit_btn:setPosition( width - exit_size.width , height - exit_size.height )
	exit_btn:setTouchClickFun(PlantModel.build_btn_fun)
	self:addChild( exit_btn.view )
	-----------------------------
	self.slot_item_container = {}
	local slot_begin_info = { x = 36, y = 123, dis_x = 96 }
	local name_begin_info = { x= 18, y = 185, dis_x = 96 }
	for i = 1, #name_info do
		self.slot_item_container[i] = SlotItem( 48, 48 )
		self.slot_item_container[i]:set_icon_texture( name_info[i].plant_image )
		--self.slot_item_container[i]:set_slot_disable()
		self.slot_item_container[i]:set_icon_bg_texture( UIPIC_ITEMSLOT, -7, -7, 62, 62 )
		self:addChild(self.slot_item_container[i].view )
		self.slot_item_container[i]:setPosition( slot_begin_info.x, height - slot_begin_info.y )
		slot_begin_info.x = slot_begin_info.x + slot_begin_info.dis_x
		-----------
		local temp_name = Image:create( nil, name_begin_info.x, name_begin_info.y, -1, -1, name_info[i].image )
		--temp_name.view:setAnchorPoint( 0, 0 )
		self:addChild( temp_name.view )
		name_begin_info.x = name_begin_info.x + name_begin_info.dis_x
		-----------
		local function select_fun()
			local temp_index = i
			_cur_panel_win:set_info( temp_index )
		end
		self.slot_item_container[i]:set_click_event( select_fun )
	end
	-----------------------------
	self.name_lab = ZLabel:create( nil, string.format( Lang.plant.plant_build_all_info.name_info, "a" ), 36, height - 185 )
	self:addChild( self.name_lab.view )
	-----------------------------
	self.exp_lab = ZLabel:create( nil, string.format( Lang.plant.plant_qiuck_info.exp_info, 0, 0 ), 36, height - 212 )
	self:addChild( self.exp_lab.view )
	-----------------------------
	self.notic_lab = ZLabel:create( nil, string.format( Lang.plant.plant_build_info.notic_info ), 36, height - 240 )
	self:addChild( self.notic_lab.view )
	-----------------------------
	self.refresh_btn = ZTextButton:create( nil, LangGameString[1770], UIResourcePath.FileLocate.common .. "button4.png", nil, 376, height - 199, -1, -1 ) -- [1770]="刷新"
	self:addChild( self.refresh_btn.view )
	self.refresh_btn:setTouchClickFun( PlantModel.refresh_seed_quality )
	-----------------------------
	self.full_btn = ZTextButton:create( nil, LangGameString[1775], UIResourcePath.FileLocate.common .. "button4.png", nil, 376, height - 240, -1, -1 ) -- [1775]="一键满级"
	self:addChild( self.full_btn.view )
	self.full_btn:setTouchClickFun( PlantModel.one_key_refresh_seed_quality )
	-----------------------------
	self.build_plant_btn = ZImageButton:create( nil, UIResourcePath.FileLocate.common .. "tishi_button.png",
	 UIResourcePath.FileLocate.plant .. "plant_btn.png", nil, 0, 0, -1, -1 )
	self.build_plant_btn:setTouchClickFun( PlantModel.build_seed )
	local button_size = self.build_plant_btn:getSize()
	self.build_plant_btn:setPosition( ( width - button_size.width ) / 2 + 175, height - 313)
	self:addChild( self.build_plant_btn.view )
	------------------------------
	local player = EntityManager:get_player_avatar()
	local cur_yb = player.yuanbao
	self.cur_yb = ZLabel:create( nil, string.format( Lang.plant.plant_build_info.yb_info, cur_yb ), 36, height - 300, 20 )
	self:addChild( self.cur_yb )
end
-----------------------------
function PlantBuild:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	create_panel( self, window_info.width, window_info.height )
	_cur_panel_win = self
end
-----------------------------
function PlantBuild:set_info(index)
	print("PlantBuild:set_info index", index)
	local temp_info = PlantModel:get_cur_plant_room_info()
	local cur_play = EntityManager:get_player_avatar()
	--print("PlantBuild:set_info temp_info.cur_plant_seed_quality, cur_play.level", temp_info.cur_plant_seed_quality, cur_play.level )
	local price = PlantConfig:get_plant_award_info( index, cur_play.level )
	local luck_price = PlantConfig:get_luck_award_info( temp_info.level )
	if temp_info.luck_time - os.time() <= 0 then
		luck_price = 0
	end
	local land_price = PlantConfig:get_land_award_info( temp_info.level )
	self.name_lab.view:setText( Lang.plant.plant_build_info.plant_name[ index ] )
	self.exp_lab.view:setText( string.format( Lang.plant.plant_build_info.exp_info, price, price * luck_price + price * land_price ) )
	self:set_select_effect( index )
end
-----------------------------
function PlantBuild:set_select_effect(index)
	for i = 1, #self.slot_item_container do
		if i == index then
			--self.slot_item_container[i]:set_icon_texture( name_info[i].plant_image )
			if _last_plant_select ~= i then
				_last_plant_select = i
				LuaEffectManager:play_view_effect( select_effect,0,0,self.slot_item_container[i].view ,true)
			end
		else
			--self.slot_item_container[i]:set_icon_texture( name_info[i].plant_image_d )
			LuaEffectManager:stop_view_effect( select_effect,self.slot_item_container[i].view )
		end
	end
end
-----------------------------
function PlantBuild:reset_win_effect()
	_last_plant_select = 0
	for i = 1, #self.slot_item_container do
		LuaEffectManager:stop_view_effect( select_effect,self.slot_item_container[i].view )
	end
end
-----------------------------
function PlantBuild:reinit()
	if PlantModel:get_is_my_room() == true then
		self.view:setIsVisible( true )
		local temp_info = PlantModel:get_cur_plant_room_info() 
		print("PlantBuild:reinit temp_info.cur_plant_seed_quality ", temp_info.cur_plant_seed_quality )
		for i = 1, #self.slot_item_container do
			if i == temp_info.cur_plant_seed_quality then
				self.slot_item_container[i]:set_icon_texture( name_info[i].plant_image )
				if _last_plant_select ~= i then
					_last_plant_select = i
					LuaEffectManager:play_view_effect( select_effect,0,0,self.slot_item_container[i].view ,true)
				end
			else
				self.slot_item_container[i]:set_icon_texture( name_info[i].plant_image_d )
				LuaEffectManager:stop_view_effect( select_effect,self.slot_item_container[i].view )
			end
		end
		--self:set_select_effect( temp_info.cur_plant_seed_quality )
		self:set_info( temp_info.cur_plant_seed_quality )
		local award_value = PlantConfig:get_award_value()
		if temp_info.cur_plant_seed_quality >= #award_value then
			self.refresh_btn.view:setCurState( CLICK_STATE_DISABLE )
			self.full_btn.view:setCurState( CLICK_STATE_DISABLE )
		else
			self.refresh_btn.view:setCurState( CLICK_STATE_UP )
			self.full_btn.view:setCurState( CLICK_STATE_UP )
		end
	else
		self.view:setIsVisible( false )
	end
end

function PlantBuild:active(show)
	if show == true then
		self:update_cur_yb()
	end
	-- if show == false then
	-- 	PlantModel:build_btn_fun()
	-- end
end

function PlantBuild:update_cur_yb()
	local player = EntityManager:get_player_avatar()
	local cur_yb = player.yuanbao
	self.cur_yb.view:setText( string.format( Lang.plant.plant_build_info.yb_info, cur_yb ) )
end