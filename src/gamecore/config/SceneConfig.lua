-- SceneConfig.lua
-- created by aXing on 2012-12-20
-- 场景配置

-- super_class.SceneConfig()
SceneConfig = {}

SceneConfig.LOGIC_TILE_WIDTH 	= 32		-- 一个逻辑地块的宽度是32像素
SceneConfig.LOGIC_TILE_HEIGHT 	= 32		-- 一个逻辑地块的高度是32像素

require "res.data.std_scene"

-- 这里由于配置表里面太多字表包含关系，所以导致需要运行时重复排序以及表的深复制
local _scene_dict = {}


local defaultBasePath  = 'map/Objects'
local defaultCachePath = 'cache/map'

local defaultCacheConfig = 
{
	basePath = 'cache/map',			--所在目录
	tilePath = '',					--tile纹理所在位置，如果是空，则读取nmap内容，否则读取这里内容
	prefix   = nil,					--文件前缀,一般是场景名
}


local _scene_tile_config =
{
	['jxyz']  = { basePath  = defaultBasePath, tilePath = '', prefix = "" },
	['dhb']  = { basePath  = defaultBasePath, tilePath = '', prefix = "" },
	['lz']  = { basePath  = defaultBasePath, tilePath = '', prefix = "" },
	['sxd']  = { basePath  = defaultBasePath, tilePath = '', prefix = "" },
	['xyl']  = { basePath  = defaultBasePath, tilePath = '', prefix = "" },
	['jxyz']  = { basePath  = defaultBasePath, tilePath = '', prefix = "" },
	['yms02']  = { basePath  = defaultBasePath, tilePath = '', prefix = "" },
	
}

function SceneConfig:getSceneTileConfig(key)
	local data = _scene_tile_config[key]
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
	require "res.data.std_scene"
	return std_scene[fuben_id]
end

-- 获取场景配置
function SceneConfig:get_scene_by_id( scene_id )
	require "res.data.std_scene"
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
	local npc_table = scene_table.npc;
	for i=1,#npc_table do
		if ( npc_table[i].name == npc_name ) then
			return npc_table[i].posx,npc_table[i].posy;
		end
	end
end

-- 根据场景id和npc的名字取得npc配置数据
function SceneConfig:get_npc_data(scene_id, npc_name)
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
	-- 如果没有找到这个怪物id 返回地图中间的坐标
	local center_table = scene_table.area[1].center
	return center_table[1],center_table[2]
end

-- 根据场景名字取得场景id
function SceneConfig:get_id_by_name( scene_name )
	require "res.data.std_scene"
	local tab_scene = std_scene[0];
	for i,v in ipairs(tab_scene.scenes) do
		if ( v.scencename == scene_name) then
			return v.scenceid;
		end
	end
end

-- 根据场景id取得场景名字
function SceneConfig:get_scene_name_by_id(scene_id ,fb_id)
	

end

-- 取得当前场景的目标点能否pk
function SceneConfig:get_curr_scene_can_pk( tx, ty )

end


-- 获取该场景的怪物种类, fjh
function SceneConfig:get_curr_scene_monster_category( scene_id )

end



-- 取得场景对应的音乐
function SceneConfig:get_music_by_scene_id( scene_id )

end

-- 取得副本对应的宽度
function SceneConfig:get_scene_width( fb_id )

end