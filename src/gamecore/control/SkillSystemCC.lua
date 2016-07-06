--SkillSystemCC.lua
--create by tgh on 2015-5-9
--技能系统逻辑处理

SkillSystemCC = {}

function SkillSystemCC:init(  )
	-- body
	SkillSystemCC:regist_protocol()
end

function SkillSystemCC:finish(  )
	-- body
end

--5,5 下发技能cd
local function do_update_skill_cd( skill_id,cd_time )
	print("5,5 下发技能cd", skill_id,cd_time)
end

--5,7 自己给目标造成伤害
local function do_damage_to_the_target( handle, value )
	print("--5,7 自己给目标造成伤害", handle,value)
end

--5,1 初始化玩家技能
local function do_init_all_skill( count, skill_table )
	print("--5,1 初始化玩家技能", count)
	for i=1,count do
		for k,v in pairs(skill_table[i]) do
			--print(k,v)
		end
	end
end

function SkillSystemCC:regist_protocol(  )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_5_1, do_init_all_skill )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_5_5, do_update_skill_cd )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_5_7, do_damage_to_the_target )

end

--使用技能
function SkillSystemCC:req_use_skill( skill_id, handle, x, y, dir )
	PacketDispatcher:send_protocol( PROTOCOL_ID_C_5_2, skill_id, handle, x, y, dir)
end

--请求技能列表
function SkillSystemCC:req_skill_list( )
	PacketDispatcher:send_protocol( PROTOCOL_ID_C_5_1)
end