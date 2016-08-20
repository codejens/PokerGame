--MapMonsterEdite.lua

MapMonsterEdite = {}

local _def_date = {		count=1,	--外族
		time=4,	
		firstTime=0,	
		mapx1=1,	
		mapx2=1,	
		mapy1=1,	
		mapy2=1,	
		entityid=999,	
		entityLevel=0,	
		progress=0,	
		mapShow= true,	}

local _show_key = {
	{"count","数量"},
	{"entityid","怪ID",},
	{"entityLevel","等级",},
	{"mapx1","x1",},{"mapy1","y1",},{"mapx2","x2",},{"mapy2","y2",},
	{"time","time",},{"firstTime","fTime"},{"progress","pro",},{"mapShow","Show"},
}
local _attr = {}

local _layout = {
	{name = "新建",x=0,y=600},
	{name = "保存",x=100,y=600},
	--{name = "修改坐标",x=20,y=390},
}

local _old_item = nil

local _ref_date = {}

local _curr_select = nil

local function menu_event( index )
	if index ==  2 then
		MapMonsterEdite:save_last_attr(  )
		MapModel:save_ref_to_file(  )
	elseif index == 1 then
		
	end
end

function MapMonsterEdite:init(  )
   _ref_date = MapModel:get_monster_info(  )
end

function MapMonsterEdite:draw_rect(	 )
	for i=1,10 do
		print(i)
	end
end

function MapMonsterEdite:create(  )
	local page =   SPanel:create( UIPIC_WINDOWS_BG,200, 640,true )

	_old_item = nil

	local sx = 10
	local sy = 400
	local key = ""
	local value = 1
	for i=1,#_show_key do
		key =_show_key[i][1]
		value = _show_key[i][2]
		_attr[i] = self:create_info(page,sx,sy,value,_ref_date[1][key])
		sy = sy - 35
	end


	local function create_scroll(index )
		local panel = MapMonsterEdite:create_scroll( index )
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


function MapMonsterEdite:update_info( date )
	for i=1,#_show_key do
		key =_show_key[i][1]
		value = date[key]
		_attr[i]:setText(tostring(value))
	end
end

function MapMonsterEdite:create_info( page,x,y,key,value )
	local label = SLabel:create( key,13,ALIGN_CENTER )
	label:setPosition(x+50, y-20)
	page:addChild(label)

	local editbox_title =  SEditBox:create( 100,25, UILH_COMMON.bg_10, nil, 13)
	editbox_title:setPosition(x+80,y-30)
	page:addChild(editbox_title)
	editbox_title:setText(tostring(value))
	return editbox_title
end

function MapMonsterEdite:create_scroll( index )

	    local layout = {}
	    local name = _ref_date[index+1].entityid
		local panel =  CCBasePanel:panelWithFile( 0, 0, 180, 30, UILH_COMMON.bg_10, 500, 500 )
		local label = SLabel:create( "怪物名"..name,18 ).view
		label:setPosition(10,8)
		panel:addChild(label)

		local function panel_func( eventType )
			print("eventType",eventType)
			 if eventType == TOUCH_CLICK then 
	            local text = label:getText()
			   	text = "#cff0000" .. text
			   	label:setText(text)
			   
			   	if _old_item then
			   		local text = _old_item.label:getText()
			   		_old_item.label:setText("#cffffff"..text)
			   	end
			   	_old_item = layout
			   	MapMonsterEdite:save_last_attr(  ) --保存上一个属性
			   	MapMonsterEdite:update_info( _ref_date[index+1] )
			   	MapModel:move_camera_ttile( _ref_date[index+1].mapx1,_ref_date[index+1].mapy1)
			   	MapModel:draw_one_monster_pos( index+1 )
			   	_curr_select = index + 1
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

function MapMonsterEdite:get_curr_select( ... )
	return _curr_select
end

function MapMonsterEdite:save_last_attr(  )
	if _curr_select then
		local attr_t = {}
		for i=1,#_show_key do
			local key = _show_key[i][1]
			attr_t[key] = _attr[i]:getText()
		end
		MapModel:sava_one_monster_attr( _curr_select,attr_t )
	end
end