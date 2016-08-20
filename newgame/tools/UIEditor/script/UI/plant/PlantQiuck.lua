----PlantQiuck.lua
----HJH
----2013-8-7
----催熟界面
super_class.PlantQiuck(Window)
-----------------------------
local function create_panel( self, width, height )
	-----------------------------
	local title = ZImageImage:create( nil, UIResourcePath.FileLocate.plant .. "exp_info_title.png", UIResourcePath.FileLocate.common .. "dialog_title_bg.png", 0, 0, -1, -1 )
	local title_size = title:getSize()
	title:setPosition( (width - title_size.width) / 2, height - title_size.height / 2 - 8 )
	self:addChild( title.view )
	-----------------------------
	local exit_btn = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_z.png", UIResourcePath.FileLocate.common .. "close_btn_z.png" }, nil, 0, 0, -1, -1 )
	local exit_size = exit_btn:getSize()
	exit_btn:setPosition( width - exit_size.width , height - exit_size.height )
	exit_btn:setTouchClickFun(PlantModel.qiuck_panel_btn_fun)
	self:addChild( exit_btn.view )
	-----------------------------
	local role_bg = ZImage:create( nil, "nopack/npc1.png", 0, 0, -1, -1 )
	role_bg.view:setAnchorPoint( 1, 0 )
	role_bg:setPosition( 145 + 150 - 14, height - 313 - 3 )
	self:addChild( role_bg.view )
	-----------------------------
	self.slot_item = SlotItem( 48, 48 )
	self.slot_item:set_icon_bg_texture( UIPIC_ITEMSLOT, -7, -7, 62, 62 )
	self:addChild( self.slot_item.view )
	self.slot_item.view:setPosition( 285, height - 120 )
	-----------------------------
	local name_bg = ZImage:create( nil, UIResourcePath.FileLocate.common .. "red_title.png", 240, height - 165, -1, -1 )
	self:addChild( name_bg.view )
	-----------------------------
	self.name_lab = ZLabel:create( nil, "a" , 250, height - 160)
	self:addChild( self.name_lab.view )
	-----------------------------
	self.time_lab = ZLabel:create( nil, string.format( Lang.plant.plant_qiuck_info.time_info, "0" ), 250, height - 196 )
	self:addChild( self.time_lab.view )
	-----------------------------
	self.exp_lab = ZLabel:create( nil, string.format( Lang.plant.plant_qiuck_info.exp_info, 0, 0), 250, height - 222 )
	self:addChild( self.exp_lab.view )
	-----------------------------
	self.spend_lab = ZLabel:create( nil, string.format( Lang.plant.plant_qiuck_info.spend_info, 1), 250, height - 250 )
	self:addChild( self.spend_lab.view )
	-----------------------------
	self.button = ZImageButton:create( nil, UIResourcePath.FileLocate.common .. "tishi_button.png",
	 UIResourcePath.FileLocate.plant .. "group_up_btn.png", nil, 267, height - 313, -1, -1 )
	local button_size = self.button:getSize()
	self.button:setPosition( ( width - button_size.width ) / 2 + 175, height - 313 )
	self:addChild( self.button.view )
	self.button:setTouchClickFun( PlantModel.qiuck_plant )
end
-----------------------------
function PlantQiuck:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	create_panel( self, window_info.width, window_info.height )
end
-----------------------------
function PlantQiuck:reinit()
	local cur_room_info = PlantModel:get_cur_plant_room_info()
	if self.slot_item ~= nil and self.time_lab ~= nil and self.exp_lab ~= nil and self.spend_lab ~= nil then
		local item_info = 
		{
			{ image = UIResourcePath.FileLocate.plant .. "plant_begin_1.png", name = LangGameString[1779] }, -- [1779]="#cfff000普通的神龙草"
			{ image = UIResourcePath.FileLocate.plant .. "plant_begin_2.png", name = LangGameString[1780] }, -- [1780]="#cfff000优秀的神龙草"
			{ image = UIResourcePath.FileLocate.plant .. "plant_begin_3.png", name = LangGameString[1781] }, -- [1781]="#cfff000精良的神龙草"
			{ image = UIResourcePath.FileLocate.plant .. "plant_begin_4.png", name = LangGameString[1782] }, -- [1782]="#cfff000完美的神龙草"
			{ image = UIResourcePath.FileLocate.plant .. "plant_begin_5.png", name = LangGameString[1783] }, -- [1783]="#cfff000百年的神龙草"
		}
		local cur_seed_type = cur_room_info.land_info[cur_room_info.cur_plant_select].seed_quality
		self.slot_item:set_icon_texture( item_info[cur_seed_type].image )
		self.name_lab:setText( item_info[cur_seed_type].name )
		local temp_time = cur_room_info.land_info[cur_room_info.cur_plant_select].seed_time - os.time()
		if temp_time <= 0 then
			temp_time = 0
			self.button.view:setCurState(CLICK_STATE_DISABLE)
		else
			self.button.view:setCurState(CLICK_STATE_UP)
		end
		local temp_time_format = Utils:formatTime( temp_time, true )
		self.time_lab:setText( string.format( Lang.plant.plant_qiuck_info.time_info, temp_time_format ) )
		local cur_play = EntityManager:get_player_avatar()
		local award_info = PlantConfig:get_plant_award_info( cur_seed_type, cur_play.level )
		local luck_price = PlantConfig:get_luck_award_info( cur_room_info.level )
		if cur_room_info.luck_time - os.time() <= 0 then
			luck_price = 0
		end
		local land_price = PlantConfig:get_land_award_info( cur_room_info.level )
		self.exp_lab:setText( string.format( Lang.plant.plant_qiuck_info.exp_info, award_info , luck_price * award_info + land_price * award_info ) )
		self.spend_lab:setText( string.format( Lang.plant.plant_qiuck_info.spend_info, temp_time / 60 * PlantConfig:get_quick_per_yb() ) )
	end
end

function PlantQiuck:active(show)
	-- if show == false then
	-- 	PlantModel:quick_panel_btn_fun()
	-- end
end