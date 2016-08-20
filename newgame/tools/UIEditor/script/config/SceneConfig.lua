-- SceneConfig.lua
-- created by aXing on 2012-12-20
-- 场景配置

-- super_class.SceneConfig()
require '../data/scene/map_data'
SceneConfig = {}

SceneConfig.LOGIC_TILE_WIDTH 	= 32		-- 一个逻辑地块的宽度是32像素
SceneConfig.LOGIC_TILE_HEIGHT 	= 32		-- 一个逻辑地块的高度是32像素

local _scene_dict = {}

--[[
	读取地图Tile
	basePath .. tilePath .. prefix .. xxxx.jpg
]]--
local defaultCacheConfig = 
{
	basePath = 'cache/map',			--所在目录
	tilePath = '',					--tile纹理所在位置，如果是空，则读取nmap内容，否则读取这里内容
	prefix   = nil,					--文件前缀,一般是场景名
}

SceneConfig.scenceid = {
	MU_YE_CUN = 3,
}


function SceneConfig:getSceneTileConfig(key)
	local data = scene_map_config[key]
	-- ZXLog('------------getSceneTileConfig------------',data)
	if not data then
		data = defaultCacheConfig
		defaultCacheConfig.prefix = key
	else
		if not data.prefix then
			data.prefix = key
		end
	end
	return data
end


-- 获取副本配置
function SceneConfig:get_fuben_by_id( fuben_id )
	require "../data/std_scene"
	return std_scene[fuben_id]
end

-- 获取场景配置
function SceneConfig:get_scene_by_id( scene_id )
	require "../data/std_scene"
	-- 首先尝试从最优字典中寻找
	local result = _scene_dict[scene_id]
	
	if result ~= nil then
		return result
	end

	-- 如果没有，则遍历副本表，找出场景
	for fuben_id,fuben in pairs(std_scene) do
		for i,v in ipairs(fuben.scenes) do
			if v.scenceid ~= nil then
				-- 如果发现这个场景没有被复制过去新表，则复制过去
				if _scene_dict[v.scenceid] == nil then
					_scene_dict[v.scenceid] = v
				end

				-- 如果是我们要找的场景配置，则返回
				if v.scenceid == scene_id then
					return v
				end
			end
		end
	end
end

-- 根据场景id和npc的名字取得npc的坐标
function SceneConfig:get_npc_pos(scene_id,npc_name)
	-- 场景静态配置数据
	local scene_table = self:get_scene_by_id( scene_id );
	print("scene_id",scene_id,npc_name,#scene_table)
--@debug_begin
	--xprint('SceneConfig:get_npc_pos',scene_id,npc_name)
	--assert(scene_table,string.format('SceneConfig:get_npc_pos %d %s'),scene_id,npc_name)
--@debug_end
	local npc_table = scene_table.npc;
	for i=1,#npc_table do
		if ( npc_table[i].name == npc_name ) then
			print("",npc_table[i].name,npc_name)
			return npc_table[i].posx,npc_table[i].posy;
		end
	end
end

-- 根据场景id和npc的名字取得npc配置数据
function SceneConfig:get_npc_data(scene_id, npc_name)
	-- print("get_npc_data", scene_id, npc_name)
	-- 场景静态配置数据
	local scene_table = self:get_scene_by_id( scene_id );
	local npc_list = scene_table.npc;
	for i,npc in ipairs(npc_list) do
		if npc.name == npc_name then
			return npc
		end
	end
	return nil
end

-- 根据场景id和怪物名字取得怪物的坐标
function SceneConfig:get_monster_pos( scene_id,monster_id )
	-- 场景静态配置数据
	local scene_table = self:get_scene_by_id( scene_id );
	local refresh_table = scene_table.refresh;
	for i=1,#refresh_table do
		-- 如果那里刷新的怪等于要找的怪,返回怪的坐标
		if ( refresh_table[i].entityid == monster_id and refresh_table[i].mapShow == true) then
			return refresh_table[i].mapx1,refresh_table[i].mapy1;
		end
	end
	local center_table = scene_table.area[1].center
	if center_table then
		return center_table[1], center_table[2]
	end
end

-- 根据场景名字取得场景id
function SceneConfig:get_id_by_name( scene_name )
	require "../data/std_scene"
	--print("scene_name",scene_name);
	-- 遍历场景 std_scene[0] 是副本场景
	local tab_scene = std_scene[0];
	for i,v in ipairs(tab_scene.scenes) do
		--print("v.scencename",v.scencename);
		if ( v.scencename == scene_name) then
			return v.scenceid;
		end
	end
	-- assert(false,scene_name)
end

-- 格子坐标转换为世界坐标
function SceneConfig:grid2pos(grid_x,grid_y)
	local pos_x = (grid_x + 0.5) * SceneConfig.LOGIC_TILE_WIDTH;
	local pos_y = (grid_y + 0.5) * SceneConfig.LOGIC_TILE_HEIGHT;
	return pos_x,pos_y;
end

-- 世界坐标转换为格子坐标
function SceneConfig:pos2grid(pos_x,pos_y)
	local grid_x = math.floor(pos_x  / SceneConfig.LOGIC_TILE_WIDTH);
	local grid_y = math.floor(pos_y  / SceneConfig.LOGIC_TILE_HEIGHT);
	return grid_x,grid_y;
end

-- 根据场景id取得场景名字
function SceneConfig:get_scene_name_by_id(scene_id ,fb_id)
	
	require "../data/std_scene"
	-- modify by fjh. 2013-4-23
	if fb_id == nil or fb_id == 0 then

		-- 遍历场景 std_scene[0] 是普通场景
		local tab_scene = std_scene[0];
		for i,v in ipairs(tab_scene.scenes) do
			--print("v.scencename",v.scencename);
			if ( v.scenceid == scene_id) then
				return v.scencename;
			end
		end
	elseif fb_id ~= 0 and fb_id ~= nil then
		-- 遍历场景 std_scene[1] 是副本场景
		local fuben_scene = std_scene[fb_id];
		if #fuben_scene.scenes > 1 then
			for i,scene in ipairs(fuben_scene.scenes) do
				if scene.scenceid == scene_id then
					return scene.scencename;
				end
			end
		else 
			return fuben_scene.scenes[1].scencename;
		end
		
	end

end

-- 取得当前场景的目标点能否pk
function SceneConfig:get_curr_scene_can_pk( tx, ty )
	--print("tx,ty",tx,ty);
	local curr_scene_id = SceneManager:get_cur_scene();
	local scene_info = SceneConfig:get_scene_by_id( curr_scene_id );
	-- 解析当前场景区域属性
	local area_table = scene_info.area;
	for i=1,#area_table do
		-- 先判断目标点是否在该矩形范围中
		local range_table = area_table[i].range;
		--print("#range_table",#range_table);
		-- 只判断左下角和右上角，因为是矩形
		if ( tx >= range_table[1] and ty >= range_table[2] and tx < range_table[5] and ty < range_table[6] ) then
			local attri_table = area_table[i].attri;
			for j=1,#attri_table do
				if ( attri_table[j].type == 1 ) then
					--print("当前场景不能Pk.....")
					return false;
				end
			end
		end
	end
	return true;
end


-- 获取该场景的怪物种类, fjh
function SceneConfig:get_curr_scene_monster_category( scene_id )
	local scene_info = SceneConfig:get_scene_by_id( scene_id );

	if scene_info ~= nil and #scene_info.refresh ~= 0 then

		local monster_category = {};
	
		for i,monster in ipairs(scene_info.refresh) do

			local is_exist = false;
			--游戏中 小地图不能同时出现相同名字  策划要求  秦皇地宫需要有相同的怪物名字 ，特殊处理   xiehande
			if scene_id ~= 1128 then 
				for i,categoty in ipairs(monster_category) do
					if categoty.entityid == monster.entityid then
						is_exist = true;
						break;
					end
				end
			end
		

			if not is_exist then
				monster_category[#monster_category+1] = monster;
			end

		end
	
		return monster_category;
	end
	return nil;
end



-- 取得场景对应的音乐
function SceneConfig:get_music_by_scene_id( scene_id )
	local scene_info = SceneConfig:get_scene_by_id( scene_id );
	--TODO_KAIFU 开服只播放这几首音乐，其他音乐都屏蔽掉
	-- if ( scene_info.music == "xianzonglingdi.mp3" or scene_info.music == "zhandou.mp3" ) then
	-- 	return scene_info.music;
	-- end
	-- return nil;
	return scene_info.music
end

-- 取得副本对应的宽度
function SceneConfig:get_scene_width( fb_id )
	local fb_info = SceneConfig:get_fuben_by_id( fb_id );
	return fb_info.scenes[1].sceneWidth;
end

function SceneConfig:get_mini_map_info( mapfile)
 	if mapfile == "60fb01" or mapfile == "60fb02" or mapfile == "60fb03"
 		 or mapfile == "60fb04" or mapfile == "60fb05" or mapfile == "60fb06" then 
 		return mini_map_config["fb6001"];
 	end
 	print("小地图名字:",mapfile);
 	return mini_map_config[mapfile];

 end 