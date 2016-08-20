-- SelectRoleCC.lua
-- created by aXing on 2012-11-27
-- 选择角色系统

-- super_class.SelectRoleCC()
SelectRoleCC = {}


-- 查询角色列表
-- c->s 255,4
function SelectRoleCC:request_role_list(  )
	local pack = NetManager:get_socket():alloc(255, 4)
	NetManager:get_socket():SendToSrv(pack)	
end

-- 返回查询角色列表
-- s->c 255,4
function SelectRoleCC:do_query_role_list( pack )
	local account 	= pack:readInt()				-- 账号id
	local count		= pack:readByte()				-- 如果是负数，表示是错误码，否则表示角色的数量
	if count < 0 then
		print("错误码")
		MUtils:lockScreen(false,2048,LangGameString[452],3) -- [452]='出错了'
		return
	end

	require "struct/UserRole"
	-- print("SelectRoleCC:do_query_role_list count",count)
	local role_data = {}
	for i=1,count do
		role_data[i] = UserRole(pack)
	end

	local default_role  = pack:readByte()		-- 默认选中哪个角色	
	local default_job	= pack:readByte()		-- 最少人选择的职业
	local default_camp	= pack:readWord()		-- 可选择阵营列表

	-- TODO:显示逻辑
	-- 这里需要有一个测试逻辑，就是如果只有一个角色，那么直接跳进场景
	-- if count ~= 0 then
	-- 	--进入游戏  暂不做角色列表。直接使用第一个账号进入游戏
	-- 	RoleModel:enter_game_scene(role_data[1].id, 0);
	-- 	MUtils:lockScreen(false,2048,LangGameString[453],3) -- [453]='登录游戏'

	if count == 0 then
	    --如果角色不是1，就进入创建角色界面。
		RoleModel:open_role_win( default_role, default_job, default_camp )
		MUtils:lockScreen(false,2048,LangGameString[454],3) -- [454]='创建角色'
	elseif count == 1 then
		RoleModel:enter_game_scene(role_data[1].id, 0)
		MUtils:lockScreen(false,2048,LangGameString[453],3) -- [453]='登录游戏'
	elseif count > 1 then
		SelectServerRoleModel:set_role_data_list( role_data )
		RoleModel:change_login_page("select_alive_role_page")
	end
end

-- 申请创建角色
-- c->s 255,2
function SelectRoleCC:request_create_role( name, sex, job, icon, camp, platform )
	local pack = NetManager:get_socket():alloc(255, 2)
	pack:writeString(name)
	pack:writeChar(sex)
	pack:writeChar(job)
	pack:writeChar(icon)
	pack:writeChar(camp)
	pack:writeString(platform)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回创建角色结果
-- s->c 255,2
function SelectRoleCC:do_result_create_role( pack )
	local role_id 	= pack:readInt()
	local error_id	= pack:readByte()
	-- if error_id == 0 then
		-- 角色成功, 请求进入游戏场景
		require "model/RoleModel"
		-- RoleModel:enter_game_scene( role_id, error_id )
		RoleModel:create_role_success( role_id, error_id )
	-- end
end

-- 申请删除角色
-- c->s 255,3
function SelectRoleCC:request_delete_role( role_id )
	local pack = NetManager:get_socket():alloc(255, 3)
	pack:writeInt(role_id)
	NetManager:get_socket():SendToSrv(pack)	
end

-- 返回删除角色结果
-- s->c 255,3
function SelectRoleCC:do_result_delete_role( pack )
	local role_id 	= pack:readInt()
	local error_id	= pack:readByte()
	if error_id == 0 then
		-- 成功
	end
end



-- 申请进入游戏
-- c->s 255,5
function SelectRoleCC:request_enter_game( role_id, tile_width_limit, tile_height_limit, platform )
	local pack = NetManager:get_socket():alloc(255, 5)
	pack:writeInt(role_id)
	pack:writeInt(tile_width_limit)
	pack:writeInt(tile_height_limit)
	pack:writeString(platform)
	NetManager:get_socket():SendToSrv(pack)

	SceneLoadingWin:enterGameWorld()
end

-- 返回进入游戏的结果
-- s->c 255,5
function SelectRoleCC:do_result_enter_game( pack )
	--print("SelectRoleCC:do_result_enter_game( pack )")
	local error_id = pack:readByte()
	if error_id == 0 then
		--  成功, 
		require "model/RoleModel"
		RoleModel:did_enter_game_scene_success(  )
	else
		SceneLoadingWin:destroy_instance()
	end
end

-- 申请随机名字
-- c->s 255,6
function SelectRoleCC:request_random_name( sex )
	local pack = NetManager:get_socket():alloc(255, 6)
	pack:writeChar(sex)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回随机名字结果
-- s->c 255,6
function SelectRoleCC:do_result_random_name( pack )
	local error_id 	= pack:readByte()
	if error_id == 0 then
		local sex 	= pack:readByte()
		local name 	= pack:readString()
		
		require "model/RoleModel"
		RoleModel:set_random_name( name )
	end
end

-- 查询最少的职业
-- c->s 255,7
function SelectRoleCC:request_least_job(  )
	local pack = NetManager:get_socket():alloc(255, 7)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回查询最少的职业的结果
-- s->c 255,7
function SelectRoleCC:do_result_least_job( pack )
	local error_id 	= pack:readByte()
	if error_id == 0 then
		local job 	= pack:readByte()
		-- TODO::游戏逻辑
		RoleModel:set_ramdom_job( job )
	end
end

-- 查询最少的阵营
-- c->s 255,8
function SelectRoleCC:request_least_camp(  )
	local pack = NetManager:get_socket():alloc(255, 8)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回查询最少的阵营的结果
-- s->c 255,8
function SelectRoleCC:do_result_least_camp( pack )
	local error_id 	= pack:readByte()
	if error_id == 0 then
		local camp_index 	= pack:readByte()
		print("----服务器下发最少的阵营：", camp_index)
		require "model/RoleModel"
		RoleModel:set_ramdom_camp( camp_index )
	end
end

-- 玩家退出
-- c->s 255,9
function SelectRoleCC:req_exit( server_id,user_account )
	--print("SelectRoleCC:req_exit( server_id,user_account )",server_id,user_account);
	local pack = NetManager:get_socket():alloc(255, 9)
	pack:writeInt(server_id)
	pack:writeString(user_account);
	NetManager:get_socket():SendToSrv(pack)	
end

-- 玩家退出结果
-- s->c 255,9
function SelectRoleCC:do_exit(pack)
	local result = pack:readByte();		--0成功或其他是错误码
	-- enPasswdError =1,    //密码错误
	-- enNoAccount=2,       //没有这个账号
	-- enIsOnline =3,       //已经在线,注意：如果已经在线，客户端应该在1秒后重试登陆
	-- enServerBusy =4,     //服务器忙
	-- enServerClose =5,    //服务器没有开放 
	-- enSessionServerError =6 , //session服务器有问题，比如db没有连接好
	-- enServerNotExisting =7, //不存在这个服务器
	-- enFcmLimited =8 ,      //账户纳入防沉迷
	--print("SelectRoleCC:do_exit(pack)",result)
end