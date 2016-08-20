--MapNpcEdite.lua

MapNpcEdite = {}


local _old_item = nil

local _curr_select = nil

local _layout = {
	{name = "新建",x=0,y=600},
	{name = "保存",x=100,y=600},
	--{name = "修改坐标",x=20,y=390},
}

local show_key = {"name","posx","posy","modelid","icon","script"}
local _attr = {}

local _npc_model = {}

function menu_event( index )
	if index == 2 then
		MapModel:save_npc_tp_file(  )
	end
end

function MapNpcEdite:create(  )
	local page =   SPanel:create( UIPIC_WINDOWS_BG,200, 640,true )

	local sx = 10
	local sy = 400
	for i=1,#show_key do
		_attr[i]= MapMonsterEdite:create_info( page,sx,sy,show_key[i],"请选择" )
		sy = sy - 35
	end
	

	local function create_scroll(index )
		local panel = MapNpcEdite:create_scroll( index )
		return panel
	end

	self.scroll = SScroll:create( 180, 180)
	self.scroll:setPosition(10,420)
	self.scroll:set_touch_func(SCROLL_CREATE_ITEM,create_scroll)
	--self.scroll:set_touch_func(ITEM_DELETE,delete_func)

	self.scroll:update(11)
	page:addChild(self.scroll)

	for i=1,#_layout do
		local function btn_func( ... )
			menu_event(i)
		end 
		local btn = ZTextButton:create( page, _layout[i].name, 
		    	 UILH_COMMON.lh_button2, btn_func, _layout[i].x, _layout[i].y )
	end



	return page
end

function MapNpcEdite:update_info( index )
	local date = MapModel:get_npc_date( )
	date = date[index]
	for i=1,#show_key do
		_attr[i]:setText(date[show_key[i]])
	end
end


function MapNpcEdite:create_scroll( index )

	    local layout = {}
	    local npcdate = MapModel:get_npc_date( )
	    local name =  npcdate[index+1].name
		local panel =  CCBasePanel:panelWithFile( 0, 0, 180, 30, UILH_COMMON.bg_10, 500, 500 )
		local label = SLabel:create( name,18 ).view
		label:setPosition(10,8)
		panel:addChild(label)

		local function panel_func( eventType )
			 if eventType == TOUCH_CLICK then 
	            local text = label:getText()
			   	text = "#cff0000" .. text
			   	label:setText(text)
			   
			   	if _old_item then
			   		local text = _old_item.label:getText()
			   		_old_item.label:setText("#cffffff"..text)
			   	end
			   	_old_item = layout
			   	MapNpcEdite:save_last_attr(  )
			   	_curr_select = index + 1
			   	MapNpcEdite:update_info( _curr_select )
			   	MapNpcEdite:move_camera_tile( _curr_select )
			   	return true
			elseif eventType == ITEM_DELETE then
				if _old_item and _old_item.panel == panel then
					_old_item = nil
				end
            end
            	return true
		end
		layout.label = label
		layout.panel = panel 
		panel:registerScriptHandler(panel_func)
		return panel
end

function MapNpcEdite:move_camera_tile( index )
	local npcdate = MapModel:get_npc_date( )
	local tx = npcdate[index].posx
	local ty = npcdate[index].posy
	MapModel:move_camera_ttile( tx,ty)
end

function MapNpcEdite:save_last_attr(  )
	if _curr_select then
		local attr_t = {}
		for i=1,#show_key do
			local key = show_key[i]
			attr_t[key] = _attr[i]:getText()
		end
		MapModel:sava_one_npc_attr( _curr_select,attr_t )
	end
end

function MapNpcEdite:get_curr_select( ... )
	return _curr_select
end

function MapNpcEdite:update_npc( date )
	print("update_npc")
	for i=1,#_npc_model do
		_npc_model[i]:removeFromParentAndCleanup(true)
	end
	for i=1,#date do
		local x = date[i].posx
		local y = date[i].posy
		x,y = SceneManager:tile_to_pixels(x,y)
		local body = date[i].modelid or 1

		_npc_model[i] =ZXEntityMgr:sharedManager():createEntity(1, 2, x, y, body, 1, 1) 
		local path = EntityFrameConfig:get_npc_path( body );--frameloc .. attri_value
		_npc_model[i]:changeBody(path)
	end
	
end