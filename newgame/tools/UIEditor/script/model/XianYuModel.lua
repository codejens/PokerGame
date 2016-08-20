-- XianYuModel.lua
-- created by fjh on 2013-3-7
-- 灵泉仙浴 模型

-- super_class.XianYuModel() 
XianYuModel = {}

local _paopao_count = 0;	--打泡泡的剩余次数
local _xishui_count = 0;	--戏水的剩余次数

local _is_xianyu_statue = false;	--是否在灵泉仙浴状态
local _player_pet_id = nil;			--记录进入灵泉仙浴前出战的宠物id
local _player_is_ride_mount = false;	--记录进入灵泉仙浴前是否骑着坐骑
local _play_action_id = 0;			--戏耍动作id
-------------------- 业务相关逻辑
-- added by aXing on 2013-5-25
function XianYuModel:fini( ... )
	_paopao_count = 0;
	_xishui_count = 0;
	_is_xianyu_statue = false;
	_player_pet_id = nil;
	_player_is_ride_mount = false;
	_play_action_id = 0;
	UIManager:destroy_window("xianyu_win");
end

-- 获取是否正在灵泉仙浴状态
function XianYuModel:get_status(  )
	return _is_xianyu_statue;
end



-- 进入了灵泉仙浴的回调,这是服务器对于 进入灵泉仙浴请求的响应
function XianYuModel:enter_scene_callback(  )
	UIManager:show_window("xianyu_win")
	--------设置状态
	_is_xianyu_statue = true;

	-------- 收起宠物
	--先判断是否有宠物出战中
	if PetModel:get_current_pet_id() ~= nil then
		--保存当前的宠物id
		_player_pet_id = PetModel:get_current_pet_id();
	
		PetCC:req_fight( _player_pet_id, 0 ); --参数1：宠物id。参数2：状态id，0代表休息，1代表出战
	end

	local player = EntityManager:get_player_avatar();
	-- 临时去掉脚底的影子
	player:setShadowIsVisible(false)
	-- 如果是在打坐，先取消再进入仙浴
	if ( player.state and ZXLuaUtils:band(player.state, EntityConfig.ACTOR_STATE_ZANZEN) > 0  ) then
		-- print("进入仙浴之前，判断为打坐状态，取消打坐ing");
		player:stop_dazuo();
	end
	
	if ( MountsModel:get_is_shangma() ) then
		-- 如果是在乘骑中，则先下坐骑，再进入仙浴
		-- print("进入仙浴之前，判断为乘骑状态，取消乘骑");
		_player_is_ride_mount = true;
		-- MountsModel:ride_a_mount( );
		player:client_get_down_mount();
	else
		_player_is_ride_mount = false;
	end

	------- 更换成游泳姿态并收翅膀、武器
	player:update_default_body( player.body );
	player:take_off_weapon()
	player:hide_wing();	-- player:take_off_wing();

	--关闭活动面板
	UIManager:destroy_window("activity_sub_win");

	-- 隐藏技能按钮
	local win = UIManager:find_visible_window("menus_panel");
	if win then 
		win:hide_skill_panel(false);
	end
end

-- 退出灵泉仙浴
function XianYuModel:exit_xianyu_fuben(  )

	_is_xianyu_statue = false;

	--如果宠物id不为空，则在退出时把宠物放出来
	if _player_pet_id ~= nil then
		
		PetCC:req_fight( _player_pet_id, 1 );
	end
	
	local player = EntityManager:get_player_avatar();
	player:update_weapon( player.weapon )
	-- 退出时要穿戴回原来的翅膀，武器
	player:update_default_body( player.body );
	-- 显示主角脚底的影子
	player:setShadowIsVisible(true)
	
	if player.wing_id then
		player:update_wing( player.wing_id );
	end
	-- print("退出仙浴时，穿戴翅膀 ",player.wing_id);
	--如果_player_is_ride_mount 为true，则在退出时把坐骑骑上
	if _player_is_ride_mount then
		--骑上坐骑
		
		MountsModel:ride_a_mount( );
		-- player:ride_a_mount(MountsModel:get_mounts_info().model_id);
	end

	UIManager:destroy_window("caiquan_win");
	--关闭灵泉仙浴win
	UIManager:destroy_window("xianyu_win")

	-- 显示技能按钮
	local win = UIManager:find_visible_window("menus_panel");
	if win then 
		-- win:hide_skill_panel(true);
		win:show_or_hide_panel(true)
	end
end

-- 不管有无选中目标时，自动寻找附近目标的回调
function XianYuModel:AI_play_action_callback(  )
	if _play_action_id ~= 0 then
		-- print("选中目标时",_play_action_id);
		XianYuModel:play_action( _play_action_id );
	end
end
-- 自动寻找目标失败
function XianYuModel:AI_play_action_fail(  )
	GlobalFunc:create_screen_notic( LangModelString[483] ); -- [483]="附近没有目标"
end

-- 打泡泡
function XianYuModel:play_paopao_action(  )
	
	local player = EntityManager:get_player_avatar();
	--判断是否选中了某个目标
	_play_action_id = 1;

	if player.target_id ~= nil then
		-- XianYuModel:play_action( 1 );
		AIManager:xianyu_da_paopao_with_target();
	else
		--没有选中目标，则调用AIManager 寻找最近的目标
		
		AIManager:xianyu_find_nearest_avater_play_action( );
	end

end

-- 戏水
function XianYuModel:play_xishui_action(  )
	
	local player = EntityManager:get_player_avatar();
	--判断是否选中了某个目标
	_play_action_id = 2;

	if player.target_id ~= nil then
		-- 选中目标，于目标玩家戏水
		AIManager:xianyu_da_paopao_with_target();
	else
		--没有选中目标，则调用AIManager 寻找最近的目标
		
		AIManager:xianyu_find_nearest_avater_play_action( );
	end
end

-- 获取剩余的打泡泡次数和戏水次数
function XianYuModel:get_play_action_count(  )
	return _paopao_count,_xishui_count;
end

-------------------- 网络相关逻辑

-- 进入灵泉仙浴
function XianYuModel:enter_xianyu_scene(  )
	
	MiscCC:req_enter_xianyu();
end

--打泡泡或者戏水, 1为打泡泡，2为戏水
function XianYuModel:play_action( action_id )
	
	--获取选中玩家的名字
	local select_id = UIManager:find_visible_window("user_panel").target_entity.handle;
	if select_id ~= nil then
		-- print("获取选中玩家的名字",select_id);
		local entity = EntityManager:get_entity( select_id );
		--发送嬉戏动作
		MiscCC:req_xianyu_playActoin(action_id,entity.name);
		--开始cd
		local win = UIManager:find_visible_window( "xianyu_win" );
		if win~=nil then
			win:cd_time( action_id,30 );
		end
	end
end

--服务器返回剩余的戏水和打泡泡次数
function XianYuModel:update_play_count( paopao_count,xishui_count )
	_paopao_count = paopao_count;
	_xishui_count = xishui_count;
	local win = UIManager:find_visible_window( "xianyu_win" );
	if win~=nil then
		win:update_play_action_count( _paopao_count,_xishui_count );
	end
	-- print("服务器返回剩余的戏水和打泡泡次数,",_paopao_count,_xishui_count);
end

-- 广播 其他玩家的嬉戏活动
function XianYuModel:broadcast_playAction( action_id, code, target_handle )
	if code ~= -1 then
		--0成功，-1失败
		local entity = EntityManager:get_entity( target_handle );
		local player_name =	entity.name;
		-- print("对--"..player_name.."--调戏了一下");
	end
	
end

