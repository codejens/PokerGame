-- SceneManager.lua
-- created by aXing on 2012-11-15
-- 这是一个管理游戏场景的管理器
-- 例如切换场景，移动场景camera等...
super_class.SceneManager()

require "action/CommandManager"
require "ResourceManager"
require 'scene/WeatherSystem'
require 'scene/SceneEffectManager'
require 'effect/SpecialSceneEffect'
require 'effect/FlowerEffect'
require 'effect/TextEffect'
-- require "utils/Utils"

local _scene_root 		= nil			-- 场景根节点
local _message_node		= nil			-- 点击消息节点
local _current_fuben_id = 0				-- 当前副本id(0表示不在副本里面)
local _current_scene_id = -1 			-- 当前场景id
local _current_scene_name	= ""		-- 当前场景名字
local _current_tyc_lord = nil;			-- 当前天元之主的名字

local _game_scene = nil --ZXGameScene:sharedScene()
local _director = nil --CCDirector:sharedDirector()

--- 手势使用的坐标
local start_x = 0;
local start_y = 0;

local SceneEffectLayerDepth = 401
local FlowTextLayerDepth = 402
local WeatherLayerDepth =  403
local SkyLayerDepth = 404
local SPECIAL_SCENE_ = 1


local _screen_to_ui_factorX = GameScaleFactors.screen_to_ui_factorX
local _screen_to_ui_factorY = GameScaleFactors.screen_to_ui_factorY

--全屏大小
local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

-- 玩家点击地板3秒钟不动的话自动上坐骑
local ride_a_mount_timer = timer();
-- 旧的方向
local _now_direction = 0;

SceneCamera = {}

-- 场景管理器初始化
function SceneManager:init(root)

	if _scene_root ~= nil then
		print("scene manager has been initialized!")
		return
	end

	_scene_root = root:getSceneNode()

	local start_time = 0;
	local old_time = 0;

	local function main_msg_fun(eventType,x,y)
		--print(eventType,x,y)
		MapModel:touch_event( eventType,x,y )

		if eventType == CCTOUCHBEGAN then
			--print("CCTOUCHBEGAN") 
			start_x = x
		    start_y = y
		    _now_direction = 0;
		    self:do_touch_began_event({x,y,true})
		    start_time = GameStateManager:get_total_milliseconds(  )
		    old_time = start_time;
			return true
		elseif eventType == CCTOUCHMOVED then
			
			local curr_time = GameStateManager:get_total_milliseconds(  )
			--print("CCTOUCHMOVED",curr_time - old_time,start_time,curr_time);
			--if ( curr_time - start_time > 1000 and curr_time - old_time > 100) then
				--ride_a_mount_timer:stop();	
				
				old_time = curr_time;
			--end
			return true;
		elseif eventType == CCTOUCHENDED then
		--	print("CCTOUCHENDED")
			-- 取消上坐骑cb
		
			ride_a_mount_timer:stop();
			self:do_scroll_event({x,y})
			self:do_touch_moved_event({x,y,true});
			return true
		end
	end

	self.main_msg_fun = main_msg_fun

	_scene_root:registerScriptTouchHandler(main_msg_fun, false, 0, false)


	-- 然后添加地图场景单例
	_game_scene = ZXGameScene:sharedScene()
	_director = CCDirector:sharedDirector()
	
	_scene_root:addChild(_game_scene)



	self.game_scene = 		_game_scene
	self.logicScene =       ZXLogicScene:sharedScene();

	self.SceneRoot = 		root:getSceneRoot()
	self.UIRoot = 			root:getUINode()
	self.SceneNode = 		root:getSceneNode()
	self.SceneEntityRoot =  root:getEntityNode()
	self.SpecialSceneEffect = root:getSceneUINode()


	self.WeatherRoot = 		CCNode:node()
	self.SceneEffectRoot =  CCNode:node()
	self.FlowTextRoot    =  CCNode:node()

	self.skyRoot = CCNode:node()
	--self.skyRoot:setAnchorPoint(CCPointMake(0,1))

	self.SceneRoot:addChild(self.SceneEffectRoot,SceneEffectLayerDepth)
	self.SceneRoot:addChild(self.FlowTextRoot,FlowTextLayerDepth)
	self.SceneRoot:addChild(self.WeatherRoot,WeatherLayerDepth)
	self.SceneRoot:addChild(self.skyRoot,SkyLayerDepth)

	SceneEffectManager:init(self.SceneEffectRoot)
	--天气特效
	WeatherSystem:init(self.WeatherRoot)
	--特效层
	LuaEffectManager:init(self.SceneEffectRoot)
	--鲜花特效
	FlowerEffect:init(self.UIRoot)
	--清空文字特效根
	TextEffect:init(self.FlowTextRoot, self.UIRoot)
	
	--场景特殊特效
	SpecialSceneEffect:init()

	--摄像头
	SceneCamera:init()
end

function SceneManager:fini(  )

	--删除浮动文字
	_scene_root:removeAllChildrenWithCleanup(true)
	_scene_root = nil

	_message_node		= nil			-- 点击消息节点
	_current_fuben_id = 0				-- 当前副本id(0表示不在副本里面)
	_current_scene_id = -1 			-- 当前场景id
	_current_scene_name	= ""		-- 当前场景名字
	_current_tyc_lord = nil;			-- 当前天元之主的名字

	_game_scene = nil --ZXGameScene:sharedScene()
	_director = nil --CCDirector:sharedDirector()

	--- 手势使用的坐标
	start_x = 0;
	start_y = 0;

	--清空场景特效
	if LuaEffectManager then
		LuaEffectManager:scene_leave()
	end

	--清空鲜花特效
	FlowerEffect:scene_leave()

	--清空飘血特效
	TextEffect:scene_leave()

	if CenterNoticWin then
		CenterNoticWin.scene_leave()
	end

	if TimerLabel_SceneLeave then
		TimerLabel_SceneLeave()
	end

	SceneCamera:fini()
end

function SceneManager:scene_on_click( args )

	-- added by aXing on 2013-6-4
	-- 添加BI打点，玩家点击场景进行移动的次数
	Analyze:parse_click_scene_move()

	-- 要先判断是不是在双修，如果双修的话点击地面会先弹一个二次确认框 
	if ( DaZuoWin:scene_on_click() ) then
		-- 打断AI
		AIManager:set_AIManager_idle(  )
		--print("parse_click_scene_move.....................")
		local position = args --Utils:Split(args, ":")

		local world_pos_x, world_pos_y = SceneManager:view_pos_to_world_pos(position[1], position[2])

		-- ZXLog('======>>> cursor', position[1],position[2])
		-- ZXLog('======>>> target', world_pos_x,world_pos_y)

		--增加点击按钮过1/4屏时自动上坐骑功能,by mwy@2014-08-14
		--delete 在onActionMove统一处理了
		CommandManager:move(world_pos_x, world_pos_y, true,nil,EntityManager:get_player_avatar())
		PowerCenter:OnPlayerTakeAction()
		--print("scene_on_click...........................CommandManager:move")
		-- 点击地板时隐藏下面的菜单栏
		local win = UIManager:find_visible_window("menus_panel")
		if win then 
			-- 取消隐藏 by hwl
			-- win:show_or_hide_panel(false)
		end
	end
	-- 判断是否日常指引中
	--去掉旧版新手指引 by mwy@2014-05-014
	-- XSZYManager:is_richang_zy()

end

-- 进入某场景
-- fb_id 		副本id
-- scene_id		场景id
-- x 			camera坐标x
-- y			camera坐标y
-- keep_walking	是否继续寻路
-- scene_name 	场景名字
-- map_name		地图名字
-- tyc_lord		天元城主的名字
function SceneManager:enter_scene( fb_id, scene_id, x, y, keep_walking, scene_name, map_name, tyc_lord )
	-- print("***********************************************************************************")
	-- print("***********************************************************************************")
	-- print("***********************************************************************************")
	-- print("***********************************************************************************")
	-- print("***********************************************************************************")
	-- print("***********************************************************************************")
	-- print("------------enter_scene------------fb_id,map_name,scene_name",fb_id,scene_id,map_name,scene_name)
	SceneManager:leave_scene()

	local old_scene_id = _current_scene_id
	_current_fuben_id = fb_id
	_current_scene_id = scene_id

	--EventSystem.setParam('sceneInfo', { ['fb_id'] = fb_id, ['scene_id'] = scene_id })

	-- 先显示loading界面，盖住地图
	SceneLoadingWin:enterScene()

	-- 先显示loading界面，盖住地图
	--SceneLoadingWin:show_instance(1,100,100)

    -- 判断是否副本，如果是副本就显示退出副本按钮
	local win = UIManager:find_window("right_top_panel");

	if ( win ) then
		--添加一個天元之戰的出口、添加一个自由赛报名场景18
		if ( (_current_fuben_id ~= 0 and _current_scene_id ~= 27) or (_current_fuben_id == 0 and _current_scene_id == 28)  
			or scene_id == 18) then
			--win:set_fuben_exit_ben_visible(true);
		else
			--win:set_fuben_exit_ben_visible(false);
		end		

	end
	-- require "model/FubenModel/FubenCenterModel"
	--通知 副本第三方model处理进入对应副本或场景的逻辑
	--FubenCenterModel:did_eneter_scene(_current_fuben_id, _current_scene_id, old_scene_id );

	-- require "config/SceneConfig"
	--local scene = SceneConfig:get_scene_by_id(scene_id)
	_current_scene_name = map_name--scene.mapfilename
	if _current_scene_name == nil then
		print("map has not write a mmap file name!")
		return
	end
	


	-- print("来到", _current_scene_name,"天元之主",tyc_lord);

	-- 打开地图
	local mapfile = _current_scene_name .. ".mmap"
	local miniMapFile = string.format('nopack/MiniMap/%s.jpg',_current_scene_name)
	local config = SceneConfig:get_mini_map_info( _current_scene_name);
	if config == nil then
		config = { width = 256, height = 256 }
	end


	local tileConfig = SceneConfig:getSceneTileConfig(_current_scene_name)

	_game_scene:initWithMapFile( "map/" .. mapfile, 
								 tileConfig.prefix,
								 tileConfig.basePath,
								 tileConfig.tilePath,
								 miniMapFile, 
							     config.width,
							     config.height)
	
	SceneEffectManager:changeScene(mapfile)
	-- 移动镜头
	_game_scene:cameraMoveInPixels(x, y)
	
	-- if scene.color then
	-- 	_game_scene:setTileColor(ccc3(scene.color[1],
	-- 								  scene.color[2],
	-- 								  scene.color[3]))
	-- else
	-- 	_game_scene:setTileColor(ccc3(255,255,255))
	-- end

	-- 加载场景资源
	-- 加载场景资源xml配置
	ResourceManager:load_scene(_current_scene_name)

	-- 保存天元之主的名称
	_current_tyc_lord = tyc_lord;
		
	-- 更新小地图的场景
	-- require "model/MiniMapModel"
	--MiniMapModel:update_microMap_scene();
	
	-- 内存回收
	ResourceManager:set_resource_dirty()

	-- 切换地图后要判断是否要更新ui
	--self:update_ui(old_scene_id, scene_id);

	-- 切换地图后要更新地图特效
	--self:update_map_effect_data( scene_id )

	-- 隐藏loading界面，盖住地图
	-- SceneLoadingWin:destroy_instance()
	-- print("old_scene_id = ",old_scene_id,"_current_scene_id",_current_scene_id);
	-- if ( old_scene_id ~= _current_scene_id ) then
	-- 关闭之前的音乐，
	--SoundManager:stopBackgroundMusic(true);
	--SoundManager:playeSceneMusic(scene_id , true);
	--SetSystemModel:set_bg_music_volume(  )
	
	-- 播放场景文字特效
	--LuaEffectManager:play_scene_font_effect_2( scene_id, fb_id )
	-- 切换场景以后更新主界面菜单栏
	--MenusPanel:on_enter_scene();
	--self:update_sky_info(x,y)

	
	-- end

	-- 切换经常更新玩家是否需要副本优化
	--SetSystemModel:set_fuben_optimize(  )
end

-- 离开某场景
function SceneManager:leave_scene()
	print("SceneManager:leave_scene")
	Cinema:onSceneLeave()
	--ResourceManager:set_resource_dirty(  )
	ResourceManager:garbage_collection(true)
end

-- 判断当前场景是不是安全区
function SceneManager:is_forbid_pk_area(  )
	return false
end

----取得当前天元之主的名字
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
	return p.x * _screen_to_ui_factorX ,p.y * _screen_to_ui_factorY
end

-- 把屏幕坐标转化成世界坐标
function SceneManager:view_pos_to_world_pos( view_pos_x, view_pos_y )
	--[[
	local winSize		= CCDirector:sharedDirector():getWinSizeInPixels();
	local halfWinWidth	= winSize.width  / 2
	local halfWinHeight	= winSize.height / 2
	local cam_pos 		= _game_scene:getCameraPositionInPixels()
	local world_pos_x	= view_pos_x + cam_pos.x - halfWinWidth
	local world_pos_y	= cam_pos.y - view_pos_y + halfWinHeight
	
	local px = ( cam_pos.x - halfWinWidth) + view_pos_x
	local py = ( cam_pos.y - halfWinHeight) + view_pos_y
	print(cam_pos.x, cam_pos.y, px,py, world_pos_x,world_pos_y)
	ZXLogicScene:sharedScene():screenToMap(view_pos_x,view_pos_y)
	]]--
	local p = _game_scene:screenToMap(view_pos_x,view_pos_y)

	return p.x ,p.y

end
-- 屏幕坐标转化为地图坐标
function SceneManager:view_pos_to_map_pos( view_pos_x, view_pos_y )
	local world_pos_x, world_pos_y = SceneManager:view_pos_to_world_pos(view_pos_x, view_pos_y)
	local point = CCPoint(world_pos_x,world_pos_y)
	ZXGameScene:sharedScene():mapPosToGLPos(point)
	return point.x,point.y;
end

-- 把世界像素坐标转化成逻辑格子坐标
function SceneManager:pixels_to_tile( pos_x, pos_y )
	local tile_x = math.floor(pos_x / SceneConfig.LOGIC_TILE_WIDTH)
	local tile_y = math.floor(pos_y / SceneConfig.LOGIC_TILE_HEIGHT)
	return tile_x, tile_y
end

-- 逻辑格子中心的世界坐标
function SceneManager:tile_to_pixels( tile_x, tile_y )
	--xprint("tile_x",tile_x)
	local pos_x = (tile_x + 0.5) * SceneConfig.LOGIC_TILE_WIDTH
	local pos_y = (tile_y + 0.5) * SceneConfig.LOGIC_TILE_HEIGHT
	return pos_x, pos_y
end

-- 如果主角一直走的话，我们认为是最远距离是10000像素
local DISTANCE_MAX 			= 10000
-- 角度变化的容忍值
local _direction_limit 		= 5

-- 处理按住事件
function SceneManager:do_touch_moved_event( args )
	local player = EntityManager:get_player_avatar();
	local end_x = args[1];
	local end_y = args[2];
	end_x,end_y = SceneManager:view_pos_to_world_pos( end_x, end_y );
	local old_angle = _now_direction;
	local is_auto_move = args[3];
	--print("end_x,end_y,player.model.m_x,player.model.m_y",end_x,end_y,player.model.m_x,player.model.m_y)
	--local angle = math.deg( math.atan( (end_y-player.model.m_y)/(end_x - player.model.m_x) ) );
	local final_x = end_x;
	local final_y = end_y
	print("-- 处理按住事件",end_x,end_y)

	--self.logicScene:moveCameraMap(end_x, end_y)
end

-- 刚点击地面时的操作
function SceneManager:do_touch_began_event( args )
	local player = EntityManager:get_player_avatar();
	-- 判断玩家是否已经上坐骑
	if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT, false) and ZXLuaUtils:band( player.state , EntityConfig.ACTOR_STATE_RIDE) == 0 ) then
		ride_a_mount_timer:stop();
		local index = 1;
		local function ride_a_mount_fun()
			if ( index == 1 ) then
				self:do_touch_moved_event(args);
			elseif ( index == 3 ) then
				-- 再判断一次是否上坐骑
				if ( ZXLuaUtils:band( player.state , EntityConfig.ACTOR_STATE_RIDE) == 0 ) then
					MountsModel:ride_a_mount( )
				end
			end
			index = index + 1;
		end
		ride_a_mount_timer:start( t_ride_a_mount,ride_a_mount_fun);
	end
end

-- 处理滑动事件
function SceneManager:do_scroll_event( args )
	--local temparg = Utils:Split(args,":")
    local end_x = args[1];
    local end_y = args[2];
  --  print("end_y = ",end_y,"start_y = ",start_y);
  	local player = EntityManager:get_player_avatar();
  	if not player then
  		return
  	end
  	-- 先清除玩家当前的行动队列
  	-- player:clean_waiting_queue(  )
  	if ( XianYuModel:get_status(  ) == false and ZXLuaUtils:band( player.state,EntityConfig.ACTOR_STATE_COUPLE_ZANZEN ) == 0 ) then
	    -- 往下滑
	    if ( start_y - end_y  > 100 ) then
	    	
	    	-- print("player.state",player.state);
	    	-- 如果当前在上坐骑
	    	if ( ZXLuaUtils:band( player.state , EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
		    	-- 下坐骑
		    	MountsModel:ride_a_mount( )
		    	--print("MountsModel:ride_a_mount( )...........................")
		    	return;
		    -- 如果当前在站着
		    elseif (player.is_enable_dazuo and  ZXLuaUtils:band( player.state,EntityConfig.ACTOR_STATE_ZANZEN ) == 0 and 
		    	player.stand_time > 0 ) then
		    	ShuangXiuCC:req_start_normal_dazuo( 1, 1 );
		    	player:client_sit_down();
		    	return;
		    end
		-- 往上滑
		elseif ( end_y - start_y > 100 ) then
	    	if ( GameSysModel:isSysEnabled(GameSysModel.MOUNT, false) and player and ZXLuaUtils:band( player.state , EntityConfig.ACTOR_STATE_RIDE) == 0 ) then

	    	--解决斩仙遗留bug  判断是否无法骑乘应该在滑动时判断  added by xiehande 2015-1-31
		    -- 上坐骑
		    local isProtectionQuest = TaskModel:has_star_task_accepted(QuestConfig.QUEST_PROTECTION)
			-- pk状态下不能上坐骑
			if ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_PK_STATE) ~= 0 or 
				ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_PROTECTION) ~= 0  or 
				 isProtectionQuest then
				GlobalFunc:create_screen_notic( LangModelString[381] ) -- [381]="PK或护送状态下无法骑乘!"
            end

		    	MountsModel:ride_a_mount( )
		    	--print("player:ride_a_mount( )...........................")
		    	return;
		    end
		end
	end
	self:scene_on_click(args)
end

-- 更新地图特效
function SceneManager:update_map_effect_data( scene_id )
	-- 先清除地图数据
	_game_scene:clear_map_effect_data();
	-- 取得地图数据
	local map_data = effect_config:get_map_effect_data_by_id( scene_id );
	if ( map_data ) then
		local effect_data_table = map_data.effects;
		for k,v in pairs(effect_data_table) do
			for i=1,#v do
				local effect_table = effect_config[v[i].id]
				-- print("添加场景特效数据", k,v[i].id,v[i].x,v[i].y,effect_table[1])
				_game_scene:add_map_effect_data(k,v[i].id,v[i].x,v[i].y,effect_table[1]);
			end
			
		end
	end
end


function SceneManager:onPause()
	FlowerEffect:onPause()
	TextEffect:onPause()

	if CenterNoticWin then
		CenterNoticWin.onPause()
	end
end

function SceneManager:onResume()
	FlowerEffect:onResume()
	TextEffect:onResume()
end

-- 进入pk场景时显示玩家的仙宗名，隐藏掉玩家的称号
-- 69 八卦地宫 59阵营战 28王城之战
-- 14 天魔城
local pk_fb_id = { 59, 69 }
local pk_scene_id = { 28 };	-- 斩仙的14 ,15,16,21这些pk副本，都被改成渡劫副本了，所以不写上 note by guozhinan
local is_pk_scene = false;

-- 创建主角和其他玩家之前询问下sceneManager
function SceneManager:update_pk_scene( scene_id ,fb_id)
	-- print("SceneManager:update_pk_scene( scene_id ,fb_id)",scene_id,fb_id)
	for i,v in ipairs(pk_scene_id) do
		if ( scene_id == v ) then
			is_pk_scene = true;
			SceneManager:update_player_avatar_title( is_pk_scene )
			return;
		end
	end

	for i,v in ipairs(pk_fb_id) do
		if ( fb_id == v ) then
			is_pk_scene = true;
			SceneManager:update_player_avatar_title( is_pk_scene )
			return;
		end
	end

	is_pk_scene = false;
	SceneManager:update_player_avatar_title( is_pk_scene )

	-- add by liuguwoang
	if fb_id >= 76 and fb_id <= 80 then----如果是  76 -80=仙宗副本， 弄个倒计时
		local lave_times = GuildModel:get_fuben_lave_times()
		if lave_times ~= nil then
			local countdown = 60 - (3600 - lave_times) --从多少开始倒计时 
			if countdown > 0 then
				CountDownView:show(0,countdown)
			end
		end
	end
end
-- 取得当前是否pk场景
function SceneManager:get_is_pk_scene()
	-- print("is_pk_scene",is_pk_scene);
	return is_pk_scene;
end
-- 更新玩家的头顶标题显示方式
function SceneManager:update_player_avatar_title( is_pk_scene )
	local player_avatar = EntityManager:get_player_avatar();
	if ( player_avatar ) then
		if ( is_pk_scene ) then
			player_avatar:update_title_type( 2 )
		else
			player_avatar:update_title_type( 1 )
		end
		EntityManager:set_avatar_hide_title( player_avatar )
	end
end

-- 切换场景后是否要更新ui
function SceneManager:update_ui(old_scene_id, new_scene_id)
	-- 切换场景，尝试消除连斩层数
	UIManager:destroy_window("combo_attack_win");
	-- 如果是争霸赛
	if ( _current_fuben_id ==  72 ) then
		-- 显示争霸赛动作界面
		UIManager:show_window("zbs_action_win");
	else
		local win = UIManager:find_visible_window("zbs_action_win")
		if ( win ) then
			UIManager:destroy_window("zbs_action_win");
		end
	end

	-- 如果不是自由赛报名场景
	if ( _current_scene_id ~=  18 ) then
		local win = UIManager:find_visible_window("pipei_dialog")
		if ( win ) then
			UIManager:destroy_window("pipei_dialog");
		end
	end 

	--如果不是自由赛和争霸赛的话
	if (_current_fuben_id ~= 71 and _current_fuben_id ~= 72 ) then
		local win = UIManager:find_visible_window("result_dialog")
		if ( win ) then
			UIManager:destroy_window("result_dialog");
		end
	end

	-- 如果突然进入聚仙令场景，那么把聚仙令的进入窗口关掉
	if (_current_fuben_id == 81 or _current_fuben_id == 82 or _current_fuben_id == 83) then
		UIManager:destroy_window("juxianling_win");
	end

	-- 玩家刚从新手副本场景中出来
	if old_scene_id == 0 and new_scene_id ~= 0 then
		SceneManager:setNewerCampUI(false)
	-- 玩家进入了新手体验副本场景中
	elseif new_scene_id == 0 then
		SceneManager:setNewerCampUI(true)
	end
end

function SceneManager:update_sky_info(x, y)
	-- print("update_sky_info",x,y)
	-- self.skyRoot:setPosition(CCPointMake(0,0-y))
end

function SceneManager.sceneFindPath(map_sX, map_sY, map_tX, map_tY)
	local pScene	= ZXGameScene:sharedScene():toPtr()
	return MapFindPath(pScene, map_sX, map_sY, map_tX, map_tY)
end

function SceneManager:enableClicking(bState)
	if bState then
		_scene_root:registerScriptTouchHandler(self.main_msg_fun, false, 0, false)
	else
		local function _func_null(eventType,x,y)
			return true
		end
		_scene_root:registerScriptTouchHandler(_func_null, false, 0, false)
	end

end

--------------------------------------------------
function SceneCamera:init()
	self.logicScene = ZXLogicScene:sharedScene()
	self.gameScene = ZXGameScene:sharedScene()

	self._sin_zoomer = TimeLerpSin()
	self._lock_entity_timer = timer()
	self._look_at = TimeLerp()
	self._zoom_lerp = TimeLerp()
	self._target = nil
end


function SceneCamera:zoom(value,dur)
	self._zoom_lerp:stop()
	self._sin_zoomer:stop()
	self.logicScene:zoom(value)
end



function SceneCamera:zoomLerp(startValue,endValue,dur)
	if dur then
		self._zoom_lerp:start(0,dur,
		function(t)
			--print('>>>>>>>>>>>>>', t)
			local v = startValue + (endValue - startValue) * t
			self.logicScene:zoom(v)
		end)
	else
		self.logicScene:zoom(value)
	end
end

function SceneCamera:zoomSin(startValue, zoomOffset, dur)
	self._sin_zoomer:start(0,dur,function(h)
		self.logicScene:zoom(startValue + h * zoomOffset)
	end)
end

function SceneCamera:fini()
	self._zoom_lerp:stop()
	self._lock_entity_timer:stop()
	self._sin_zoomer:stop()
	self._look_at:stop()
end

local function _safeLockModel(model, tt)
	local s,e = pcall(function() 
		local mx,my = model:getPosition()
		SceneCamera.logicScene:moveCamera(mx, my) end
	)
	if not s then
		tt:stop()
	end
end

function SceneCamera:lock(model)
	self._look_at:stop()
	self._lock_entity_timer:stop()
	
	self._lock_entity_timer:start(0,bind(_safeLockModel,
										 model,
										 self._lock_entity_timer))
end

function SceneCamera:follow(model,dur)

	self._look_at:stop()
	self._lock_entity_timer:stop()

	local p = self.gameScene:getCameraPositionInPixels()
	self._target = model
	self._look_at:start(0,dur,
		function(t)
			local mx,my = model:getPosition()
			local x = p.x + (mx - p.x) * t
			local y = p.y + (my - p.y) * t
			self.logicScene:moveCamera(x, y)
			if t == 1.0 then
				self:lock(model)
			end
		end)
end

function SceneCamera:lookAt(mx,my,dur)
	self._look_at:stop()
	self._lock_entity_timer:stop()

	if not dur then
		self.logicScene:moveCameraMap(mx, mx)
	else
		local p = self.gameScene:cameraMapPosition()
		self._look_at:start(0,dur,
			function(t)
				local x = p.x + (mx - p.x) * t
				local y = p.y + (my - p.y) * t
				self.logicScene:moveCameraMap(x, y)
			end)
	end
end

-- 玩家进入新手副本后,要屏蔽掉一些界面的显示
-- @param: bShow为true时,玩家进入了新手副本
function SceneManager:setNewerCampUI(bShow)
	if bShow then
		UIManager:hide_window("right_top_panel")
	else
		UIManager:show_window("right_top_panel")
	end

	-- 玩家刚进入新手副本场景,或者刚从新手副本场景中出来的时候,更新MenusPanel窗口的显示
	local menus_panel = UIManager:find_visible_window("menus_panel")
	if menus_panel then
		menus_panel:update_ui_by_newer_camp(bShow)
	end
end