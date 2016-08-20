----PlantHelp.lua
----HJH
----2013-8-7
----事件界面
super_class.PlantHelp(Window)
-----------------------------
local function create_panel( self, width, height )
	-- local bg = CCZXImage:imageWithFile( 0, 0, width, height, UIResourcePath.FileLocate.common .. "dialog_bg.png", 113, 93, 104, 93, 113, 59, 104, 59 )
	-- self:addChild(bg)
	-----------------------------
	local title = ZImageImage:create( nil, UIResourcePath.FileLocate.plant .. "help_title.png", UIResourcePath.FileLocate.common .. "dialog_title_bg.png", 0, 0, -1, -1 )
	local title_size = title:getSize()
	title:setPosition( (width - title_size.width) / 2, height - title_size.height / 2 - 8 )
	self:addChild( title.view )
	-----------------------------
	local exit_btn = ZButton:create( nil, { UIResourcePath.FileLocate.common .. "close_btn_z.png", UIResourcePath.FileLocate.common .. "close_btn_z.png" }, nil, 0, 0, -1, -1 )
	local exit_size = exit_btn:getSize()
	exit_btn:setPosition( width - exit_size.width , height - exit_size.height )
	exit_btn:setTouchClickFun(PlantModel.help_btn_fun)
	self:addChild( exit_btn.view )
	-----------------------------
	self.scroll = ZScroll:create( nil, nil, 20, 35, 455, 282 - 15, 1, TYPE_HORIZONTAL )
	self:addChild( self.scroll.view )
	-----------------------------
	local dialog = ZDialog:create( nil, nil, 0, 0, 455, 100 )
	dialog:setText( Lang.plant.plant_help_info )
	self.scroll.view:addItem( dialog.view )
end
-----------------------------
function PlantHelp:__init(window_name, window_info)--texture_name, pos_x, pos_y, width, height)
	create_panel( self, window_info.width, window_info.height )
end
-----------------------------
function PlantHelp:update( itemindex, time, exp, spend )
	-- if self.slot_item ~= nil and self.time_lab ~= nil and self.exp_lab ~= nil and self.spend_lab ~= nil then
	-- 	local item_info = 
	-- 	{
	-- 		{ image = UIResourcePath.FileLocate.plant .. "plant_begin_1.png", name = "#cfff000普通的神龙草" },
	-- 		{ image = UIResourcePath.FileLocate.plant .. "plant_begin_2.png", name = "#cfff000优秀的神龙草" },
	-- 		{ image = UIResourcePath.FileLocate.plant .. "plant_begin_3.png", name = "#cfff000精良的神龙草" },
	-- 		{ image = UIResourcePath.FileLocate.plant .. "plant_begin_4.png", name = "#cfff000完美的神龙草" },
	-- 		{ image = UIResourcePath.FileLocate.plant .. "plant_begin_5.png", name = "#cfff000百年的神龙草" },
	-- 	}
	-- 	self.slot_item.icon:setTexture( item_info[itemindex].image )
	-- 	self.name_lab:setText( item_info[itemindex].name )
	-- 	self.time_lab:setText( string.format( Lang.plant.plant_qiuck_info.time_info, time) )
	-- 	self.exp_lab:setText( string.format( Lang.plant.plant_qiuck_info.exp_info, exp ) )
	-- 	self.spend_lab:setText( string.format( Lang.plant.plant_qiuck_info.spend_info, spend ) )
	-- end
end

function PlantHelp:active(show)
	-- if show == false then
	-- 	PlantModel:help_btn_fun()
	-- end
end	