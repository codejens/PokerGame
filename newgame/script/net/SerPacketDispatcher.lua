-- 客户端模拟服务器处理网络数据包

SerPacketDispatcher = {}

-- 任务相关 6
local function init_task_cc()
	local func = {}
	-- func[1]    = NewerCampServerCC.req_task_list;

	return func
end

-- 技能相关 5
local function init_skill_cc()
	local func = {}
	-- 客户端向假服务器请求技能列表
	-- func[1]    = NewerCampServerCC.request_skill_list;

	return func
end

-- 宠物相关 34
local function init_pet_cc()
	local func = {}
	-- 客户端请求宠物列表
	-- func[1]	= NewerCampServerCC.req_get_pet_list;

	return func
end

local _packet_function = {};

-- 初始化函数包
local function init_packet_dispatcher()
	-- _packet_function[5] = init_skill_cc()
	-- _packet_function[6] = init_task_cc()
	-- _packet_function[34]= init_pet_cc()
end

init_packet_dispatcher()

function SerPacketDispatcher:do_game_logic(sysid, pid, pack)
	local system = _packet_function[sysid]
	if system == nil then
		return
	end
	local func = system[pid]
	if func == nil then
		return
	end

	func(nil, pack)
end