----PlantEvent.lua
----HJH
----2013-8-7
----事件界面
super_class.PlantEvent(Window)
-----------------------------
local function scroll_create_fun( self, index )
	local event_info = PlantModel:get_my_event_info()
	local temp_info = event_info[index + 1]
	-----------------------------
	local basePanel = ZBasePanel:create( nil, nil, 0, 0, 463, 282 / 6 )
	-----------------------------
	local img = ZImage:create( nil, UIResourcePath.FileLocate.plant .. "foot.png", 20, 10, -1, -1 )
	basePanel:addChild(img)
	-----------------------------
	local temp_lab_info = ""
	if temp_info.op_type == 1 then
		temp_lab_info = string.format( Lang.plant.plant_event_info.grass_info, temp_info.name )
	elseif temp_info.op_type == 2 then
		temp_lab_info = string.format( Lang.plant.plant_event_info.worm_info, temp_info.name )
	elseif temp_info.op_type == 3 then
		temp_lab_info = string.format( Lang.plant.plant_event_info.water_info, temp_info.name )
	end
	local info_lab = ZLabel:create( nil, temp_lab_info, 65, 10 )
	basePanel:addChild(info_lab)
	-----------------------------
	local time_info = Utils:format_time_to_data( temp_info.time - Utils:get_mini_bate_time_base(), "-")
	local time_labe = ZLabel:create( nil, time_info, 360, 10 )
	basePanel:addChild(time_labe)
	-----------------------------
	local line_img = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", 0, 0, 463, 2 )
	basePanel:addChild( line_img )
	-----------------------------
	return basePanel
end
-----------------------------
local function create_panel( self, width, height )
	-----------------------------
	local title = ZImageImage:create( nil, UIResourcePath.FileLocate.plant .. "event_title.png", UIResourcePath.FileLocate.common .. "dialog_title_bg.png", 0, 0, -1, -1 )
	local title_size = title.view:getSize()
	print("width, title_size.width", width, title_size.width)
	title:setPosition( (width - title_size.width) / 2, height - title_size.height / 2 - 8 )
	self:addChild( title.view )
	-----------------------------
	local exit_btn = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_z.png", UIResourcePath.FileLocate.common .. "close_btn_z.png" }, 0, 0, -1, -1 )
	local exit_size = exit_btn:getSize()
	exit_btn:setPosition( width - exit_size.width , height - exit_size.height )
	exit_btn:setTouchClickFun(PlantModel.event_btn_fun)
	self:addChild( exit_btn.view )
	-----------------------------
	local title_bg = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", 30, height - 62, width - 60, 25, nil, 600, 600 )
	self:addChild( title_bg.view )
	-----------------------------
	local title_lab = ZLabel:create( nil, LangGameString[1778], 130, height - 60, 20) -- [1778]="事件                      时间"
	self:addChild( title_lab.view )
	-----------------------------
	self.scroll = ZScroll:create( nil, nil, 20, 20, 463, 250, 1, TYPE_HORIZONTAL )
	self.scroll:setScrollLump( 10, 40, 282 / 6 )
	self:addChild( self.scroll.view )
	self.scroll:setScrollCreatFunction( scroll_create_fun )
end
-----------------------------
function PlantEvent:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	--print("window_name, texture_name, pos_x, pos_y, width, height",window_name, texture_name, pos_x, pos_y, width, height)
	create_panel( self, window_info.width, window_info.height )
end
-----------------------------
function PlantEvent:reinit()
	local event_info = PlantModel:get_my_event_info()
	self.scroll:setMaxNum( #event_info )
	self.scroll:clear()
	self.scroll:refresh()
end

function PlantEvent:active(show)
	-- if show == false then
	-- 	PlantModel:event_btn_fun()
	-- end
end