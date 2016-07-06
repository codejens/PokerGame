--RoleCC.lua
--created by liubo on 2015-05-04
--角色逻辑控制器

RoleCC = {}

local _select_sex = 0 	--当前选中性别 0=男 1=女
local _default_role = 1 --默认角色
local _default_job = 1 	--默认职业
local _default_camp = 1 --默认阵营

--创建角色结果处理
--s->c 255,2
local function receive_create_role(role_id,error_id)
	if error_id == 0 then
		RoleCC:enter_game_scene(role_id)
	else
		local result_notice_t = {
			[-1]  = "sql错误",                                      -- -1
			[-2]  = "用户没登陆",                                   -- -2
			[-3]  = "游戏服务没准备好",                             -- -3
			[-4]  = "角色上一次保存数据是否出现异常",               -- -4
			[-5]  = "客户端选择角色的常规错误",                     -- -5
			[-6]  = "角色名称重复",                                 -- -6
			[-7]  = "角色不存在",                                   -- -7
			[-8]  = "错误的性别",                                   -- -8
			[-9]  = "随机生成的名字已经分配完",                     -- -9
			[-10] = "客户端上传的角色阵营参数错误",                 -- -10
			[-11] = "客户端上传的角色职业参数错误",                 -- -11
			[-12] = "名称无效，名称中包含非法字符或长度不合法",     -- -12
			--[-13] = "如果玩家是盟主，不能删除该角色，需要玩家退出仙盟",     -- -13
		}
		if result_notice_t[error_id] then
			print(result_notice_t[error_id])
		end
	end
end

--返回删除角色结果
--s->c 255,3
local function receive_delete_role(role_id,error_id)
	if error_id == 0 then
		-- 成功
	end
end

--服务器返回角色列表
--s->c 255,4
local function receive_role_list(account_id,role_count,role_data,default_role,default_job,default_camp)
	if role_count == 0 then
		--没有角色进入创建角色页面
		RoleCC:open_create_role(default_role,default_job,default_camp)
	elseif role_count == 1 then
		--有一个角色直接进入游戏
		RoleCC:enter_game_scene(role_data[1].id)
	elseif role_count > 1 then
		--多个角色进入选择角色页面
		RoleCC:open_select_role(role_data)
	else
		print("错误码：",role_count)
	end
end

--返回进入游戏的结果
--s->c 255,5
local function receive_enter_game(error_id)
	if error_id == 0 then --成功
		RoleCC:result_enter_game_success()
	end
end

--返回随机名字结果
--s->c 255,6
local function receive_random_name(error_id,sex,name)
	if error_id == 0 then
		RoleCC:set_random_name(name)
	end
end

--返回查询最少的职业的结果
--s->c 255,7
local function receive_least_job(error_id,job)
	if error_id == 0 then

	end
end

-- 返回查询最少的阵营的结果
-- s->c 255,8
local function receive_least_camp(error_id,camp_index)
	if error_id == 0 then

	end
end

--初始化
function RoleCC:init()

end

function RoleCC:finish( ... )
	
end

--注册协议处理函数
function RoleCC:register_protocol()
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID_S_255_2,receive_create_role)
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID_S_255_3,receive_delete_role)
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID_S_255_4,receive_role_list)
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID_S_255_5,receive_enter_game)
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID_S_255_6,receive_random_name)
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID_S_255_7,receive_least_job)
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID_S_255_8,receive_least_camp)
end

--申请创建角色
--c->s 255,2
function RoleCC:request_create_role(name,sex,job,icon,camp,platform)
	PacketDispatcher:send_protocol(PROTOCOL_ID_C_255_2,name,sex,job,icon,camp,platform)
end

--申请删除角色
--c->s 255,3
function RoleCC:request_delete_role( role_id )
	PacketDispatcher:send_protocol(PROTOCOL_ID_C_255_3,role_id)
end

--查询角色列表
--c->s 255,4
function RoleCC:request_role_list()
	PacketDispatcher:send_protocol(PROTOCOL_ID_C_255_4)
end

--申请进入游戏
--c->s 255,5
function RoleCC:request_enter_game(role_id,platform)
	PacketDispatcher:send_protocol(PROTOCOL_ID_C_255_5,role_id,platform)
end

--申请随机名字
--c->s 255,6
function RoleCC:request_random_name(sex)
	PacketDispatcher:send_protocol(PROTOCOL_ID_C_255_6,sex)
end

--查询最少的职业
--c->s 255,7
function RoleCC:request_least_job()
	PacketDispatcher:send_protocol(PROTOCOL_ID_C_255_7,sex)
end


--查询最少的阵营
--c->s 255,8
function RoleCC:request_least_camp()
	PacketDispatcher:send_protocol(PROTOCOL_ID_C_255_8)
end


--登录游戏服务器成功
function RoleCC:login_server_success(  )
	--请求角色列表
	RoleCC:request_role_list()
end

--打开创建角色页面
function RoleCC:open_create_role(default_role,default_job,default_camp)
	_default_camp = default_role
	_default_job = default_job
	_default_camp = default_camp
	local win = GUIManager:show_window('role')
	win:show_page("CreateRole")
end

--申请创建角色
function RoleCC:apply_create_role(name)
	local icon = 1
	local platform = ""
	RoleCC:request_create_role(name,_select_sex,_default_job,icon,_default_camp,platform)
end

--选择完角色后向服务器请求进入游戏场景
function RoleCC:enter_game_scene(role_id)
	local platform = ""
	RoleCC:request_enter_game(role_id,platform)
end

--打开角色选择页面
function RoleCC:open_select_role(role_data)
	local win = GUIManager:show_window('role')
	win:show_page("SelectRole")
	win:update_role_list( role_data )
end

--请求进入游戏场景成功，开始初始化游戏场景
function RoleCC:result_enter_game_success()
	--通知场景管理器进入游戏场景状态
	GUIManager:hide_window('role')
	gameStateManager:setState(SceneState)
end

--选择性别
function RoleCC:select_sex(stype)
	_select_sex = stype
	local win = GUIManager:find_window('role')
	win:set_select_sex(_select_sex)
end

--随机名字
function RoleCC:random_name()
	RoleCC:request_random_name(_select_sex)
end

--设置随机名字
function RoleCC:set_random_name(name)
	local win = GUIManager:show_window('role')
	win:set_role_name(name)
end