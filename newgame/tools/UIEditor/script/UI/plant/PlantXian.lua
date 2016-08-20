----PlantWin.lua
----HJH
----2013-8-7
----请仙界面
super_class.PlantXian(Window)
-----------------------------
local plant_xian_panel = nil
-----------------------------
local function create_panel( self, width, height )
	-----------------------------
	local title = ZImageImage:create( nil, UIResourcePath.FileLocate.plant .. "luck_title.png", UIResourcePath.FileLocate.common .. "dialog_title_bg.png", 0, 0, -1, -1 )
	local title_size = title:getSize()
	title:setPosition( (width - title_size.width) / 2, height - title_size.height / 2 - 8 )
	self:addChild( title.view )
	-----------------------------
	local exit_btn = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_z.png", UIResourcePath.FileLocate.common .. "close_btn_z.png" }, nil, 0, 0, -1, -1 )
	local exit_size = exit_btn:getSize()
	exit_btn:setPosition( width - exit_size.width , height - exit_size.height )
	exit_btn:setTouchClickFun(PlantModel.xian_panel_btn_fun)
	self:addChild( exit_btn.view )
	-----------------------------
	local role_bg = ZImage:create( nil, "nopack/npc1.png", 0, 0, -1, -1 )
	role_bg.view:setAnchorPoint( 1, 0 )
	role_bg:setPosition( 145 + 150 - 14, height - 313 - 3 )
	self:addChild( role_bg.view )
	-----------------------------
	local image = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "xian_bg.png", 145 + 50, height - 200, -1, -1 )
	self:addChild( image.view )
	-----------------------------
	self.time_lab = ZLabel:create( nil, string.format( Lang.plant.plant_xian_info.time_info, 0 ), 290 + 50, height - 83 )
	self:addChild( self.time_lab.view )
	-----------------------------
	self.spend_lab = ZLabel:create( nil, string.format( Lang.plant.plant_xian_info.spend_info, 0 ), 290 + 50, height - 113 )
	self:addChild( self.spend_lab.view )
	-----------------------------
	self.radio_button_group = ZRadioButtonGroup:create( nil, 340 + 50, height - 200, 100, 87, 1 )
	--self.radio_button_group.view:setTexture("ui/common/nine_grid_bg.png")
	self:addChild( self.radio_button_group.view )
	for i = 1, #Lang.plant.plant_xian_info.select_info do
		local temp_btn = TextCheckBox:create( nil, 0, 0, -1, -1,
		 { UIResourcePath.FileLocate.common .. "common_toggle_n.png", UIResourcePath.FileLocate.common .. "common_toggle_s.png" },
		 Lang.plant.plant_xian_info.select_info[i], 2, 16 )
		local function select_fun()
			local temp_index = i
			PlantModel:set_cur_luck_type_select(temp_index)
			plant_xian_panel:reinit()
		end
		temp_btn:setTouchClickFun(select_fun)
		self.radio_button_group:addItem( temp_btn, 0 )
	end
	-----------------------------
	self.dialog = ZDialog:create( nil, nil, 145 + 50, height - 210, 270, 60 )
	self.dialog.view:setAnchorPoint( 0, 1)
	self.dialog:setText( Lang.plant.plant_xian_info.notic_info )
	--self.dialog.view:setTexture("ui/common/nine_grid_bg.png")
	self:addChild( self.dialog.view )
	-----------------------------
	local button = ZImageButton:create( nil, UIResourcePath.FileLocate.common .. "tishi_button.png",
	 UIResourcePath.FileLocate.plant .. "xian_btn.png", nil, 267, height - 313, -1, -1 )
	local button_size = button:getSize()
	button:setPosition( ( width - button_size.width ) / 2 + 175, height - 313 )
	self:addChild( button.view )
	button:setTouchClickFun( PlantModel.get_luck )
end
-----------------------------
function PlantXian:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	create_panel( self, window_info.width, window_info.height )
	plant_xian_panel = self
end
-----------------------------
function PlantXian:reinit( )
	if PlantModel:get_is_my_room() == true then
		self.view:setIsVisible( true )
		local cur_info = PlantModel:get_cur_plant_room_info()
		local time_lab_info = ""
		if cur_info.luck_type_select == 1 then
			time_lab_info = LangGameString[1785] -- [1785]="7天"
		elseif cur_info.luck_type_select == 2 then
			time_lab_info = LangGameString[1786] -- [1786]="30天"
		end
		self.time_lab:setText( string.format( Lang.plant.plant_xian_info.time_info, time_lab_info ) )
		self.spend_lab:setText( string.format( Lang.plant.plant_xian_info.spend_info, PlantConfig:get_luck_money(cur_info.luck_type_select ) ) )
		self.radio_button_group:selectItem( cur_info.luck_type_select - 1 )
	else
		self.view:setIsVisible( false )
	end
end

function PlantXian:active(show)
	-- if show == false then
	-- 	PlantModel:xian_panel_btn_fun()
	-- end
end