
-- MiniMapModel.lua
-- created by fjh on 2013-3-21
-- 小地图的model

-- super_class.MiniMapModel()
MiniMapModel = {}

local _map_open_statu = false;

local _map_teleport_selected = false;

-- added by aXing on 2013-5-25
function MiniMapModel:fini( ... )
	_map_open_statu = false;
	_map_teleport_selected = false;
end

-- 设置小地图是否打开着的状态
function MiniMapModel:set_mini_map_open( bool )
	_map_open_statu = bool;
end
function MiniMapModel:get_mini_map_open(  )
	return _map_open_statu;
end

--地图自动传送的选择状态
function MiniMapModel:set_teleport_selected( bool )
	_map_teleport_selected = bool;
end
function MiniMapModel:get_teleport_selected(  )
	return _map_teleport_selected;
end


-- 同步小地图中主角的坐标
function MiniMapModel:sync_player_position( w_pos_x, w_pos_y )
	
	if _map_open_statu then
		
		local win = UIManager:find_visible_window( "mini_map_win" );
		if win ~= nil then 
			win:sync_player_position(w_pos_x, w_pos_y);
		end
	end

	local win = UIManager:find_window("right_top_panel");
	if win then
		win:sync_avatar_point(w_pos_x, w_pos_y);
	end
	
end


--将世界逻辑格子坐标 转化成 小地图 的像素坐标
function MiniMapModel:world_tile_to_mini_map_pixels( tile_x,tile_y, map_scale )
	
	require "scene/SceneManager"
	local pos_x,pos_y = SceneManager:tile_to_pixels( tile_x, tile_y )

	local mini_pos_x = pos_x * map_scale;
	local mini_pos_y = pos_y * map_scale;
	return mini_pos_x,mini_pos_y;

end

-- 将小地图的像素坐标转化成世界逻辑格子坐标
function MiniMapModel:mini_map_pixels_to_world_tile( mini_pos_x, mini_pos_y, map_scale)
	
	require "config/SceneConfig"
	local tile_x = math.floor( mini_pos_x / ( SceneConfig.LOGIC_TILE_WIDTH * map_scale ) )
	local tile_y = math.floor( mini_pos_y / ( SceneConfig.LOGIC_TILE_HEIGHT * map_scale) )
	return tile_x, tile_y

end

-- 查询有多少筋斗云
function MiniMapModel:get_jindouyun_count(  )
	-- require "model/ItemModel"
	return ItemModel:get_item_count_by_id( 18601 );
end

-- 场景发生变化,更新主屏幕上的微地图场景
function MiniMapModel:update_microMap_scene(  )
	local win = UIManager:find_window("right_top_panel");
	if win then
		win:update_mini_map();
	end

	UIManager:destroy_window("mini_map_win");
end

-- 根据AOI内的实体变化来生成微地图上对应的点
-- status : 0 为实体消亡，1 为实体产生
function MiniMapModel:update_entity_point( status, handler, entity )
	
	local win = UIManager:find_window("right_top_panel");
	if win then
		win:update_AOI_entity( status, handler, entity )
	end
	
end


-- 立即传送到某场景的某坐标
function MiniMapModel:update_teleport_btn(  )
	
	local win = UIManager:find_visible_window("mini_map_win");
	if win then
		win:update_auto_telep_btn();
	end
end


----------------网络接口请求--------------
function MiniMapModel:req_npc_task_status( scene_id )
	MiscCC:req_npc_task_status( scene_id )
end
function MiniMapModel:do_npc_task_status( scene_id, npcs )
	
	if UIManager:find_visible_window("mini_map_win") then
		print("MiniMapModel,npc任务");
		UIManager:find_visible_window("mini_map_win"):do_npc_task_status(scene_id, npcs);
	end

end