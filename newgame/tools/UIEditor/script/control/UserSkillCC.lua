-- UserSkillCC.lua
-- created by lyl on 2012-12-1
-- 人物技能系统

-- super_class.UserSkillCC()
UserSkillCC = {}


-- 申请获取技能列表
function UserSkillCC:request_skill_list()
	local pack = NetManager:get_socket():alloc(5, 1)
	NetManager:get_socket():SendToSrv(pack)
end

function UserSkillCC:request_skill_list_from_dummy_server()
	local pack = NetManager:get_socket():alloc(5, 1)
	NetManager.SendToDummyServer(pack)
end

-- 返回玩家技能列表
function UserSkillCC:do_query_skill_list( pack, is_newer_camp )
	print("s->c (5, 1) UserSkillCC:do_query_skill_list")
	local curSceneId = SceneManager:get_cur_scene()
	-- 检测玩家当前是否在新手副本中,如果在的话,则向客户端(模拟服务器)请求技能列表
	-- if curSceneId == 27 and not is_newer_camp then
	-- 	return
	-- end
	local count = pack:readByte()
	-- require "struct/UserSkill"
	-- require "model/UserSkillModel"
	local skill_data = {} 
	for i = 1, count do
        skill_data[i] = UserSkill(pack)
        -- print(" skill id !!!!!!!!!!!!!!",skill_data[i].id)
        -- if skill_data[i].id == 33 then
        -- 	skill_data[i].id = 300
        -- 	print("change skill id !!!!!!!!!!!!!!")
        -- end
	end
	UserSkillModel:set_skill_list( skill_data );

	-- 判断玩家如果没有技能，那他就是第一次登录游戏，这时候他是没有设置快捷键的
	-- 我发送请求快捷键列表这个协议，服务器会没有任何响应，所以的话，玩家第一次登录
	-- 我要帮他设置第一个技能为快捷键
	-- print("count = ",count);
	if ( count == 0 ) then
		UserSkillModel:do_first_enter_game()
	else
		-- 返回技能列表以后，向服务器请求快捷键信息，然后更新主界面
		UserSkillModel:init_skill_key()
	end

end

--local _last_call = 0
--local _last_time = 0
-- 申请使用技能
function UserSkillCC:request_use_skill( id, target_handle, target_x, target_y, forward )
	print("c->s (5, 2) UserSkillCC:request_use_skill")
	print("UserSkillCC:request_use_skill id, target_handle, target_x, target_y, forward",id, target_handle, target_x, target_y, forward)
	local pack = NetManager:get_socket():alloc(5, 2)
    pack:writeWord(id)
    -- 群攻技能填0
	pack:writeInt64(target_handle)
    pack:writeWord(target_x)
    pack:writeWord(target_y)
    pack:writeByte(forward)
	NetManager:get_socket():SendToSrv(pack)

	local entity = EntityManager:get_player_avatar()
	LuaEffectManager:SpellEffect(id,entity)
	--print('请求使用技能',id, os.clock() - _last_call)
	--_last_call = os.clock()
end

-- 申请升级技能.   book_count 不用的参数，直接弄个0
function UserSkillCC:request_upgrade_skill( skill_id, book_count )
	print("c->s (5, 3) UserSkillCC:request_upgrade_skill")
	local pack = NetManager:get_socket():alloc(5, 3)
    pack:writeWord(skill_id)
    pack:writeByte(0)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器：技能的经验发生改变
function UserSkillCC:do_change_skill_exp( pack )
	print("s->c (5, 4) UserSkillCC:do_change_skill_exp")
	local skill_id = pack:readWord()
    local exp   = pack:readInt()
	
	require "model/UserSkillModel"
	UserSkillModel:change_skill_attr( skill_id, "exp", exp )

end

-- 申请学习技能秘籍
function UserSkillCC:request_study_scre_book( skill_id , book_id)
	print("c->s (5, 11) UserSkillCC:request_study_scre_book")
	local pack = NetManager:get_socket():alloc(5, 11)
    pack:writeWord(skill_id)
    pack:writeWord(book_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器：学习或者升级技能的结果
function UserSkillCC:do_result_study_skill( pack )
	print("s->c (5, 2) UserSkillCC:do_result_study_skill")
	local skill_id  = pack:readWord()
    local new_level = pack:readByte()
    -- print( "收到升级成功消息  ", skill_id, new_level )
	require "model/UserSkillModel"
	UserSkillModel:study_or_upgrade_skill_success( skill_id, new_level )
end

-- 服务器：玩家成功学习技能秘籍
function UserSkillCC:do_study_scre_success( pack )
	print("s->c (5, 3) UserSkillCC:do_study_scre_success")
	local id             = pack:readWord()
    local good_id        = pack:readWord()
    local overdue_time   = pack:readUInt()
	-- TODO

end

-- 申请同步CD
function UserSkillCC:request_syn_cd( id )
	print("c->s (5, 4) UserSkillCC:request_syn_cd")
	local pack = NetManager:get_socket():alloc(5, 4)
    pack:writeWord(id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器：下发技能CD
function UserSkillCC:do_result_syn_cd( pack )
	print("s->c (5, 5) UserSkillCC:do_result_syn_cd")
	local id             = pack:readWord()
    local remain_time    = pack:readInt()

	-- TODO true代表要强制清除技能cd动画
	UserSkillModel:set_skill_cd_zero( id ,true);

    -- 秘籍特效减少技能CD问题 add by gzn
	if remain_time > 0 then
		UserSkillModel:set_skill_cd_time(id,remain_time)
	end
end

-- 申请设置默认技能
function UserSkillCC:request_set_def_skill( id )
	print("c->s (5, 5) UserSkillCC:request_set_def_skill")
	local pack = NetManager:get_socket():alloc(5, 5)
    pack:writeWord(id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 申请使用肉搏攻击
function UserSkillCC:request_use_close_attack( target_handle, action_id, effi_id )
	print("c->s (5, 6) UserSkillCC:request_use_close_attack")
	local pack = NetManager:get_socket():alloc(5, 6)
    pack:writeInt64(target_handle)
    pack:writeByte(action_id)
    pack:writeWord(effi_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 申请开始吟唱技能
function UserSkillCC:request_begin_sing_skill( skill_id, target_handle, skill_x, skill_y, forward )
	local pack = NetManager:get_socket():alloc(5, 7)
    pack:writeWord(skill_id)
    pack:writeUint64(target_handle)
    pack:writeShort(skill_x)
    pack:writeShort(skill_y)
    pack:writeByte(forward)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器：被其他玩家攻击掉血
function UserSkillCC:do_by_attacked_damage( pack )
	--print(" 服务器：被其他玩家攻击掉血  ")
	local attacker_handle  = pack:readUint64()
    local attack_target    = pack:readInt64()
	-- TODO
	-- 玩家被攻击后，交给宠物AI处理
	PetAI:on_player_avatar_be_attacked( attacker_handle ,attack_target);
end

-- 服务器：自己给目标造成了伤害
function UserSkillCC:do_to_attack_damage( pack )
	--print(" 服务器：自己给目标造成了伤害  ")
	local target_handle  = pack:readUint64()
    local damage_stats   = pack:readInt()
	-- TODO
	--print('>>>>>>>>>>>>>>>>>', damage_stats)
end

-- 服务器：被攻击的目标吸收了伤害
function UserSkillCC:do_target_absorb_damage( pack )
--	print(" 服务器：被攻击的目标吸收了伤害  ")
	local target_handle  = pack:readUint64()
    local absorb_stats   = pack:readInt()
	-- TODO

end

-- 申请删除技能的秘籍效果
function UserSkillCC:request_dele_scre_effi( skill_id )
	local pack = NetManager:get_socket():alloc(5, 9)
    pack:writeWord(skill_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器：删除技能的秘籍结果
function UserSkillCC:do_result_dele_scre_effi( pack )
	-- print(" 服务器：删除技能的秘籍结果  ")
	local skill_id  = pack:readWord()
	-- TODO

end

-- 申请 启用/停止一个技能（主要是江湖绝学）
function UserSkillCC:request_stop_skill( skill_id , use_flag)
	local pack = NetManager:get_socket():alloc(5, 11)
    pack:writeWord(skill_id)
    pack:writeByte(use_flag)
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器：服务器下发停用/启用技能
function UserSkillCC:do_result_stop_skill( pack )
	-- print(" 服务器：服务器下发停用/启用技能  ")
	local skill_id  = pack:readWord()
	local use_flag  = pack:readByte()
	-- TODO

end

-- 服务器：遗忘一个技能
function UserSkillCC:do_forget_skill( pack )
	local skill_id  = pack:readWord()
	-- TODO

end

-- 服务器：设置技能的CD时间
function UserSkillCC:do_set_cd_time( pack )
	print("s->c: (5, 12) 服务器：设置技能的CD时间  ")
	local skill_id       = pack:readWord()
	local skill_level    = pack:readByte()
	local skill_cd_time  = pack:readInt()
	require "model/UserSkillModel"
	UserSkillModel:change_skill_attr( skill_id, "level", skill_level )
	UserSkillModel:change_skill_attr( skill_id, "cd", skill_cd_time )

end


-- 服务器：设置技能的吟唱时间
function UserSkillCC:do_set_sing_time( pack )
	print("s->c: (5, 13) -- do_set_sing_time -- ")
	-- print(" 服务器：设置技能的吟唱时间  ")
	local skill_id       = pack:readWord()
	local skill_level    = pack:readByte()
	local skill_sing_time= pack:readInt()
	-- TODO

end

-- 服务器：使用技能失败了
function UserSkillCC:do_use_skill_failed(pack)
	print("s->c: (5, 15) -- do_use_skill_failed -- ")
	local skill_id       = pack:readWord()
	local skill_error    = pack:readInt()
	local skill = SkillConfig:get_skill_by_id(skill_id)
	if skill_error == SkillConfig.USE_SKILL_COMMOM_CD_FAILED then
		--GlobalFunc:create_screen_notic( skill.name .. ' 施法失败【公共CD中】');
		UserSkillModel:set_skill_cd_zero( skill_id ,true);
	else
		print( skill.name .. ' 施法失败 ', skill_error);
	end
	--print('服务器：使用技能失败了',skill_id,skill_error)
	--assert(false)
end