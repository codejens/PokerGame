-- SceneManager.lua
-- created by aXing on 2012-11-15
-- 这是一个管理游戏场景的管理器
-- 例如切换场景，移动场景camera等...
SceneManager = {}



local _scene_root 		= nil			-- 场景根节点
local _message_node		= nil			-- 点击消息节点
local _current_fuben_id = 0				-- 当前副本id(0表示不在副本里面)
local _current_scene_id = 0 			-- 当前场景id
local _current_scene_name	= ""		-- 当前场景名字
local _current_tyc_lord = nil;			-- 当前玄都之主的名字

local _entity_root = nil
local _game_scene = nil --ZXGameScene:sharedScene()
local _scene = nil

SceneManager.MAP_EVENT_CLICK = "MAP_EVENT_CLICK"

-- 场景管理器初始化
function SceneManager:init()
    -- 只能初始化一次
	if _scene_root ~= nil then
		print("scene manager has been initialized!")
		return
	end
	self.map_event_lister_cb = {}   -- 地图事件回调函数
	_scene = scene.XLogicScene:sharedScene()
	_scene_root = scene.XLogicScene:sharedScene():getSceneNode()
	_entity_root =scene.XLogicScene:sharedScene():getEntityNode()

	-- 添加地图场景单例
	_game_scene = scene.XGameScene:sharedScene()
	local function scene_root_func( touch, event )
		print("11111111通知监听者地图点击1111111")
        local position = touch:getLocation()
        local x = position.x
       	local y = position.y 
        -- 地图坐标
        -- print("x, y=",x, y)
        local map_positon = cc.p( _game_scene:screenToMap( x, y ) )
        -- print("map_positon=",map_positon.x,map_positon.y)
        -- GL 坐标。 摄像机使用的是这个坐标
        local gl_position = cc.p(_game_scene:screenToGLPosition(x,y))
        -- print("gl_position=",gl_position.x,gl_position.y)
        -- 通知监听者地图点击
        local tile_x,tile_y = self:pixels_to_tile(gl_position.x,gl_position.y)

	    self.player = EntityManager:get_player_avatar()
        local t_x,t_y=self:pixels_to_tile(self.player.x, self.player.y)
        print("t_x,t_y,",t_x,t_y)
        print("tile_x,tile_y=",tile_x,tile_y)
        -- local can_move = self:can_move(tile_x,tile_y)
        -- print(can_move)
        -- if can_move == true then
	        self:map_event_notice( SceneManager.MAP_EVENT_CLICK, map_positon )
	        -- print("通知监听者地图点击")
	        -- print("player=",player.x,player.y)
	        -- _game_scene:cameraMoveInPixels(map_positon.x,map_positon.y)
	        -- _game_scene:mapPosToGLPos(map_positon)
	    -- else
	    -- 	print("该区域不能行走")
	    -- end
    end
    cocosEventHelper.registerScriptHandler( _scene_root, scene_root_func, cocosEventHelper.EventType.EVENT_TOUCH_BEGAN )
	_scene_root:addChild(_game_scene)

	SceneCamera:init()
end

-- 注册地图事件
-- callback_func: 回调函数
-- event_type: 类型
function SceneManager:register_map_event( callback_func, event_type )

	if( type( callback_func ) == "function" and 
		type( event_type ) == "string"  ) then
        -- 加入列表 
        self.map_event_lister_cb[ event_type ] = self.map_event_lister_cb[ event_type ] or {}
        table.insert( self.map_event_lister_cb[ event_type ], callback_func )
	end
end

-- 事件回调
function SceneManager:map_event_notice( event_type, data )
	-- 根据事件找到对应的列表，逐一回调
	local cb_t = self.map_event_lister_cb[ event_type ]   -- 获取回调函数table
	if cb_t then 
        for key, callback_func in ipairs( cb_t ) do 
            callback_func( data )
        end
	end
end

function SceneManager:get_scene()
	return _scene,_scene_root,_entity_root
end

function SceneManager:fini(  )

	--删除浮动文字
	_scene_root:removeAllChildrenWithCleanup(true)
	_scene_root = nil

	_game_scene = nil --ZXGameScene:sharedScene()

end


-- 进入某场景
-- fb_id 		副本id
-- scene_id		场景id
-- x 			camera坐标x
-- y			camera坐标y
-- keep_walking	是否继续寻路
-- scene_name 	场景名字
-- map_name		地图名字
-- tyc_lord		玄都主的名字
function SceneManager:enter_scene( fb_id, scene_id, x, y, keep_walking, scene_name, map_name, tyc_lord )
	_current_fuben_id = fb_id
	_current_scene_id = scene_id
	-- 保存玄都之主的名称
	_current_tyc_lord = tyc_lord;

	DefaultSystemModel:set_player_pos( x,y )
	-- 先显示loading界面，盖住地图 
	-- lp todo
	-- SceneLoadingWin:show_instance(1) 

    -- 加载场景
	-- local scene = SceneConfig:get_scene_by_id(scene_id)
	_current_scene_name = scene_name--scene.mapfilename
	if _current_scene_name == nil then
		print("map has not write a mmap file name!")
		return
	end
	-- _current_scene_name = LoginWin:get_map_name()
	print("enter_sceneenter_scene",_current_scene_name)
	local config = MiniMapConfig:get_mini_map_info( _current_scene_name);

	local miniMapFile = string.format('nopack/MiniMap/%s.jpg',_current_scene_name)
	-- 打开地图
	local mapfile = _current_scene_name .. ".mmap"

	local tileConfig = SceneConfig:getSceneTileConfig(_current_scene_name)   
	_game_scene:initWithMapFile( "map/" .. mapfile, 
								 tileConfig.prefix,
								 tileConfig.basePath,
								 tileConfig.tilePath,
								 miniMapFile, 
							     config.width,
							     config.height)
	
	-- 移动镜头
	-- _game_scene:cameraMoveInPixels(0,500)
	-- _game_scene:mapPosToGLPos(cc.p(0,0))
	-- xprint("111111111")
	
	-- local player = EntityManager:get_player_avatar()
	-- local  pos = cc.p(x,y)
	-- _game_scene:mapPosToGLPos(pos)
	-- print(x,y,pos.x, pos.y)
	-- player:setPosition(pos.x, pos.y)
	
end

-- 离开某场景
function SceneManager:leave_scene(  )
end

-- 判断当前场景是不是安全区
function SceneManager:is_forbid_pk_area(  )
	return false
end

----取得当前玄都之主的名字
function SceneManager:get_cur_tyc_lord(  )
	return _current_tyc_lord;
end

----取得当前场景
function SceneManager:get_cur_scene()
	return _current_scene_id
end
----取得当前副本
function SceneManager:get_cur_fuben()
	return _current_fuben_id
end

-- 获取当前场景名字
function SceneManager:get_current_scene_name(  )
	return _current_scene_name
end

-- 判断当前地图某一个格子是否可行
function SceneManager:can_move(target_tile_x,target_tile_y)
	return _game_scene:canMove(target_tile_x,target_tile_y);
end

-- 把世界坐标转化成屏幕坐标
function SceneManager:world_pos_to_view_pos( world_pos_x, world_pos_y )
	-- 这里需要转换成左下角坐标系
	local p = _game_scene:mapToScreen(world_pos_x,world_pos_y)
	-- p.y = ZXLogicScene:sharedScene():getViewPortSize().height - p.y
	return p.x, p.y
end

-- 把屏幕坐标转化成世界坐标
function SceneManager:view_pos_to_world_pos( view_pos_x, view_pos_y )
	local p = _game_scene:screenToMap(view_pos_x,view_pos_y)
	return p.x,p.y
end

function SceneManager:map_pos_to_world_pos( x,y )
	local p =_game_scene:mapToScreen(x,y)
	p =_game_scene:screenToGLPosition(p.x,p.y)
	return p
end

--地图坐标转换到opgl
function SceneManager:map_pos_to_opgl_pos( x,y )
	local p =_game_scene:mapToScreen(x,y)
	p =_game_scene:screenToGLPosition(p.x,p.y)
	return p
end
--opgl坐标转换到地图
function SceneManager:opgl_pos_to_map_pos( x,y )
	local p =_game_scene:GLPositionToScreen(x,y)
	p =_game_scene:screenToMap(p.x,p.y)
	return p
end

-- 把世界像素坐标转化成逻辑格子坐标
function SceneManager:pixels_to_tile( pos_x, pos_y )
	local tile_x = math.floor(pos_x / SceneConfig.LOGIC_TILE_WIDTH)
	local tile_y = math.floor(pos_y / SceneConfig.LOGIC_TILE_HEIGHT)
	return tile_x, tile_y
end

-- 逻辑格子中心的世界坐标
function SceneManager:tile_to_pixels( tile_x, tile_y )
	local pos_x = (tile_x + 0.5) * SceneConfig.LOGIC_TILE_WIDTH
	local pos_y = (tile_y + 0.5) * SceneConfig.LOGIC_TILE_HEIGHT
	return pos_x, pos_y
end

function SceneManager:onPause()

end

function SceneManager:onResume()
	
end

-- 切换场景后是否要更新ui
function SceneManager:update_ui()
	

end

function SceneManager:update_sky_info(x, y)
	
end

--获取最近的一个传送点
function SceneManager:get_nearest_position( curr_scene_id , target_scene_id )
	local source_scene = SceneConfig:get_scene_by_id( curr_scene_id )
	local target_scene = SceneConfig:get_scene_by_id( target_scene_id )
	local nearest_position = AIManager:calculate_to_target_map_teleport( source_scene, target_scene );
	return nearest_position.teleport.posx, nearest_position.teleport.posy
end

-- 计算指定场景到目标场景的最靠近的传送点
function SceneManager:calculate_to_target_map_teleport(source_scene, target_scene, expect_list)

	if expect_list == nil then
		expect_list = {}
	end
	
	local nearest_position = nil

	-- 添加到排除列表
	table.insert(expect_list, source_scene)
	-- 遍历当前场景的出口
	for key,teleport in pairs(source_scene.teleport) do
		-- 如果下一个出口可以到达目标地图，则等于找到答案了
		if teleport.toSceneid == target_scene.scenceid then
			nearest_position = {teleport = teleport, distance = 0}
			break
		end

		local next_scene = SceneConfig:get_scene_by_id(teleport.toSceneid)
		if next_scene ~= nil and next_scene.teleport ~= nil then
			-- 如果下一个场景在忽略列表，则跳过
			local is_existed = false
			for i, scene in ipairs(expect_list) do
				if scene == next_scene then
					is_existed = true
					break
				end
			end

			if not is_existed then
				local ret = self:calculate_to_target_map_teleport(next_scene, target_scene, expect_list)
				if ret then
					if nearest_position == nil or nearest_position.distance > ret.distance then
						nearest_position = ret
						nearest_position.teleport = teleport
					end 
				end
			end
		end
	end

	table.remove(expect_list)
	if nearest_position ~= nil then
		nearest_position.distance = nearest_position.distance + 1
		return nearest_position
		-- return nearest_position.teleport.posx , nearest_position.teleport.posy
	end
	-- nearest_position.teleport.posx   / posy
	return nil
end