-- BaguadigongModel.lua
-- created by fjh on 2013-7-9
-- 八卦地宫的活动

BaguadigongModel = {};


function BaguadigongModel:fini(  )
	
	
	
end

------------------游戏逻辑
-- 传送到某个怪物生产点
function BaguadigongModel:teleport_to_position( tile_x, tile_y )
	
	-- local monster_config = scene_config.refresh[i]
 --    if i == 1 then
 --        -- 仙草
 --        monster_config = scene_config.refresh[1];
 --    elseif i == 2 then
 --        -- 幽魂
 --        monster_config = scene_config.refresh[3];
 --    elseif i == 3 then
 --        -- 绿妖
 --        monster_config = scene_config.refresh[5];
 --    elseif i == 4 then
 --        -- 魔刃
 --        monster_config = scene_config.refresh[7];
 --    elseif i == 5 then
 --        -- 绿妖
 --        monster_config = scene_config.refresh[6];
 --    elseif i == 6 then
 --        -- 幽魂
 --        monster_config = scene_config.refresh[4];
 --    elseif i == 7 then
 --        -- 仙草
 --        monster_config = scene_config.refresh[2];
 --    elseif i == 8 then
 --        --傀儡
 --        monster_config = scene_config.refresh[8];
 --    elseif i == 9 then
 --        --傀儡
 --        monster_config = scene_config.refresh[9];

	-- end
    -- if monster_config.entityid == 701 then
    -- 	GlobalFunc:teleport_to_target_scene( SceneManager:get_cur_scene(), monster_config.mapx1+5, monster_config.mapy1+5 );
    -- else
    -- 	GlobalFunc:teleport_to_target_scene( SceneManager:get_cur_scene(), monster_config.mapx1, monster_config.mapy1 );
    -- end

	GlobalFunc:teleport_to_target_scene( SceneManager:get_cur_scene(), tile_x, tile_y );
end

-- 寻路到某个怪物生成点
function BaguadigongModel:move_to_monster_position( scene_config, entity_id )
	
	xprint("寻路到某个怪物生成点", scene_config.scenceid, entity_id, #scene_config);
	local mons_dict = {};
	for i,v in ipairs(scene_config.refresh) do
		if v.entityid == entity_id then
			if #mons_dict < 2 then
				table.insert( mons_dict, v );
			end
		end
	end
-- print("#mons_dict",#mons_dict)
	if #mons_dict == 2 then
		-- 有多个相同entity生成点的话，去最近的一个entity
		local location_x = EntityManager:get_player_avatar().x;
		local location_y = EntityManager:get_player_avatar().y;

		local mons_x_1, mons_y_1 = mons_dict[1].mapx1 * 32, mons_dict[1].mapy1 * 32;
		local mons_x_2, mons_y_2 = mons_dict[2].mapx1 * 32, mons_dict[2].mapy1 * 32;

		local w_1 = math.abs(mons_x_1 - location_x);
		local h_1 = math.abs(mons_y_1 - location_y);
		local distance_1 =  w_1 * w_1 + h_1 * h_1;

		local w_2 = math.abs(mons_x_2 - location_x);
		local h_2 = math.abs(mons_y_2 - location_y);
		local distance_2 =  w_2 * w_2 + h_2 * h_2;		 

		local index;
		if math.min(distance_1, distance_2) == distance_1 then
			-- 当前player距离第一个entity生成点最近
			index = 1;
		else
			index = 2;
		end

		if entity_id == 591 then
			-- 如果目标是采集，则调采集的函数
			AIManager:gather_by_pos( mons_dict[index].mapx1, mons_dict[index].mapy1 )

		else
			
			AIManager:auto_kill_monster_by_pos( mons_dict[index].mapx1, mons_dict[index].mapy1 );
		end
	
	else
		local mons = mons_dict[1];
		AIManager:auto_kill_monster_by_pos( mons.mapx1, mons.mapy1 );
	end

end

function BaguadigongModel:move_to_boss_position(  )
	-- AIManager:auto_kill_monster_by_pos( 78, 45 );
	local tile_x, tile_y = FubenConfig:get_baguadigong_boss_tile( )
	local pos_x, pos_y = SceneManager:tile_to_pixels( tile_x, tile_y )
	GlobalFunc:move_to_target_scene( SceneManager:get_cur_scene(), pos_x, pos_y) 
end


------------------网络协议
-- 进入八卦地宫
function BaguadigongModel:enter_digong_fuben(  )
	MiscCC:enter_baguadigong(  )
end
function BaguadigongModel:did_enter_digong_fuben(  )
	UIManager:hide_window("activity_sub_win");
end

--领取八卦地宫的奖励
function BaguadigongModel:get_award( target_id )
	MiscCC:req_baguadigong_get_award( target_id );
end

-- 