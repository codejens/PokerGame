--MapModel.lua

MapModel = {}

local start_x = 1
local start_y = 1

local move_x = 1
local move_y = 1

local _color	 = ccc3(0, 255, 0)
local _color1	 = ccc3(255, 0, 0)
local _color2	 = ccc3(0, 0, 255)

local _line_root = nil

local _selecte_rect = nil

local _monster_pos = {}
local _monster_node = {}

local _one_ref_pos = {
	
}

local _ref_date = {} --怪物刷新点数据

local _npc_date = {}

local _tp_date = {}

MapModel.EDITE_MODEL_NO = 0 --无模式
MapModel.EDITE_MODEL_M = 1 --刷怪模式
MapModel.EDITE_MODEL_N = 2 --NPC模式
MapModel.EDITE_MODEL_C = 3 --传送模式

local _curr_model = MapModel.EDITE_MODEL_M 

function MapModel:enter_scene( id )
	local win = UIManager:find_window("mapedite_win")
	if win then
		win:enter_scene( )
	end
	
	
end

function MapModel:init_npc_date( data )
	_npc_date = data
	MapNpcEdite:update_npc( _npc_date )
end

function MapModel:get_npc_date( ... )
	return _npc_date
end

function MapModel:init_tp_date( data )
	_tp_date = data
	MapTpEdite:update_tp( _tp_date )
end

function MapModel:get_tp_date( ... )
	return _tp_date
end

function MapModel:init_monster_info( filename )
	_monster_pos = MapEditeUtil:txt_to_lua( filename )

	MapModel:update_monster_pos(  )
end

function MapModel:get_monster_info(  )
	return _monster_pos
end

function MapModel:menu_event( edite_model )
	if edite_model < 4 then
		_curr_model = edite_model
		MapEditeWin:select_page( edite_model )
	elseif edite_model == 4 then
		--保存坐标
		MapModel:save_curr_pos(  )
	
	end
end

function MapModel:save_curr_pos(  )


		local mx1,my1 = SceneManager:view_pos_to_world_pos(start_x,start_y)
		local tx1,ty1 = SceneManager:pixels_to_tile( mx1,my1 )

		local mx2,my2 = SceneManager:view_pos_to_world_pos(move_x,move_y)
		local tx2,ty2 = SceneManager:pixels_to_tile( mx2,my2 )

		if _curr_model == MapModel.EDITE_MODEL_N then
			local index = MapNpcEdite:get_curr_select(  )
			if index then
				_npc_date[index].posx = tx1
				_npc_date[index].posy = ty1
				MapModel:update_npc_pos( index )
				MapNpcEdite:update_npc( _npc_date )
			end
		elseif _curr_model == MapModel.EDITE_MODEL_M then
			local index = MapMonsterEdite:get_curr_select(  )
			if index then
				_monster_pos[index].mapx1 = tx1
				_monster_pos[index].mapy1 = ty1
				_monster_pos[index].mapx2 = tx2
				_monster_pos[index].mapy2 = ty2

				MapModel:update_monster_pos(  )
				MapMonsterEdite:update_info( _monster_pos[index] )
			end
		elseif _curr_model == MapModel.EDITE_MODEL_C then
			local index = MapTpEdite:get_curr_select(  )
			if index then
				_tp_date[index].posx = tx1
				_tp_date[index].posy = ty1
				MapModel:update_tp_pos( index )
				MapTpEdite:update_tp( _tp_date )
			end
		end

end

function MapModel:update_npc_pos( index )
	MapNpcEdite:update_info( index )
end

function MapModel:update_tp_pos( index )
	MapTpEdite:update_info( index )
end

--处理touch事件
function MapModel:touch_event( eventType,x,y )
	if eventType == CCTOUCHBEGAN then
			start_x = x
		    start_y = y

			return true
	elseif eventType == CCTOUCHMOVED then
			move_x = x
			move_y = y
			local sp = ZXGameScene:sharedScene():screenToMap(start_x,start_y)
			local tp = ZXGameScene:sharedScene():screenToMap(move_x,move_y)
			_line_root = MapModel:drwa_line( _line_root,sp.x,sp.y,tp.x,tp.y,_color2 )
			return true;
	elseif eventType == CCTOUCHENDED then
		if _curr_model == MapModel.EDITE_MODEL_NO then
			MapModel:move_camera( x,y )
		elseif _curr_model == MapModel.EDITE_MODEL_M then
			move_x = x
			move_y = y
		end
		return true
	end
end

function MapModel:move_camera( x,y )

	x,y = SceneManager:view_pos_to_world_pos(x,y)
	local speed = 1
	local p = ZXGameScene:sharedScene():cameraMapPosition()
	local distance = math.sqrt( (x-p.x)*(x-p.x)+(y-p.y)*(y-p.y))
	SceneCamera:lookAt(x,y,distance/500)
end

function MapModel:move_camera_ttile( tx,ty )
		
		local sx,sy = SceneManager:tile_to_pixels( tx, ty )

		-- local p =ZXGameScene:sharedScene():GLPositionToScreen(sx,sy)
		-- p =ZXGameScene:sharedScene():screenToMap(p.x,p.y)

		local p = ZXGameScene:sharedScene():cameraMapPosition()
		local distance = math.sqrt( (sx-p.x)*(sx-p.x)+(sy-p.y)*(sy-p.y))
		SceneCamera:lookAt(sx,sy,distance/2000 )
end

--话一个矩形
function MapModel:drwa_line( node, sx,sy,ex,ey,color )

	if not node then
		local root = GameStateManager:get_game_root()
		node = CCDebugLine:node()
		root:getSceneRoot():addChild(node, 65535)
	end

	-- if node == _line_root then
	-- 	_one_ref_pos = {mapx1 = sx,mapy1 = sy,mapx2 =ex,mapy2 = ey }
	-- end

	local pos = {
		{sx = sx,sy = sy,ex =sx,ey =ey},
		{sx = sx,sy = sy,ex =ex,ey =sy},
		{sx = sx,sy = ey,ex =ex,ey =ey},
		{sx = ex,sy = ey,ex =ex,ey =sy},
	}
	--print(sx,sy,ex,ey )
	for i=1,4 do
		local sp = CCPointMake(pos[i].sx, pos[i].sy)
		local tp = CCPointMake(pos[i].ex, pos[i].ey)

		 ZXGameScene:sharedScene():mapPosToGLPos(sp)
		 ZXGameScene:sharedScene():mapPosToGLPos(tp)
	
		node:setLine(i, sp, tp, color or _color)
	end

	node:draw()

	return node
end

--添加一个刷怪点
function MapModel:add_monster_pos( ... )
	local pos_t = {}
	local w_sx,w_sy = SceneManager:view_pos_to_world_pos( start_x, start_y )

	pos_t.mapx1,pos_t.mapy1=SceneManager:pixels_to_tile( w_sx, w_sy )
	pos_t.mapx2,pos_t.mapy2=SceneManager:pixels_to_tile( w_sx, w_sy )


	_monster_pos[#_monster_pos] = pos_t	


end

--更新绘制所有刷怪点
function MapModel:update_monster_pos(  )
	for i=1,#_monster_node do
		if _monster_node[i] then
			_monster_node[i]:removeFromParentAndCleanup(true)
			_monster_node[i] = nil
		end
	end

	local root = GameStateManager:get_game_root()
	local pos_t = {}
	local sx,xy,ex,ey 
	for i=1,#_monster_pos do
		pos_t = _monster_pos[i]

		sx,sy = SceneManager:tile_to_pixels( pos_t.mapx1, pos_t.mapy1 )
		ex,ey = SceneManager:tile_to_pixels( pos_t.mapx2, pos_t.mapy2 )
		if sx == ex then
			sx = sx - 10
			ex = ex + 10
		end
		if sy == ey then
			sy = sy + 10
			ey = ey - 10
		end
		--_monster_node[i] = MapModel:drwa_line( _monster_node[i],sx-10,sy+10,ex+10,ey-10 )
		_monster_node[i] = MapModel:drwa_line( _monster_node[i],sx,sy,ex,ey )
	end
end

function MapModel:draw_one_monster_pos( index )
	local sx,xy,ex,ey 
	if _selecte_rect then
		_selecte_rect:removeFromParentAndCleanup(true)
		_selecte_rect = nil
	end
	pos_t = _monster_pos[index]
	sx,sy = SceneManager:tile_to_pixels( pos_t.mapx1, pos_t.mapy1 )
	ex,ey = SceneManager:tile_to_pixels( pos_t.mapx2, pos_t.mapy2 )
			if sx == ex then
			sx = sx - 10
			ex = ex + 10
		end
		if sy == ey then
			sy = sy + 10
			ey = ey - 10
		end
	_selecte_rect = MapModel:drwa_line( _selecte_rect,sx,sy,ex,ey,_color1 )
end

function MapModel:save_ref_to_file(  )
	MapEditeUtil:sava_to_file( "data/envir/scene/refresh1",_monster_pos )
end

function MapModel:sava_one_monster_attr( index,date_t )
	for k,v in pairs(date_t) do
		_monster_pos[index][k] = v
	end
end

function MapModel:sava_one_npc_attr( index,date_t )
	for k,v in pairs(date_t) do
		_npc_date[index][k] = v
	end
end

function MapModel:sava_one_tp_attr( index,date_t )
	for k,v in pairs(date_t) do
		_tp_date[index][k] = v
	end
end

function MapModel:save_npc_tp_file(  )
	MapEditeUtil:save_npc_tp_file( "data/envir/scene/scene1",_npc_date,_tp_date )
end