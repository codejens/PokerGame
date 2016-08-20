-- 构建一个假服务器关于新手体验副本的处理模块
NewerCampServerCC = {}
local job_to_skill_id = { [1] = { 1, },
                          [3] = { 7, },
                          [4] = { 13, }
                      	}
-- 收到客户端请求服务器发送技能列表的请求 c-->s(5,1)
function NewerCampServerCC:request_skill_list(client_pack)
	local pack = NetManager:get_socket():alloc()
	-- local player = EntityManager:get_player_avatar()
	-- local skill_data = job_to_skill_id[player.job]
	local skill_data = UserSkillModel:get_skill_list()
	-- 写入技能数量(#skill_data个)
	pack:writeByte(#skill_data)

	for i=1, #skill_data do
		pack:writeWord(skill_data[i].id)	-- id
		pack:writeByte(1)				-- level
		pack:writeWord(0)				-- secret_id
		pack:writeInt(0)				-- cd
		pack:writeInt(0)				-- exp
		pack:writeUInt(0)				-- dead_time
		pack:writeByte(0)				-- ifStop
	end
	pack:setPosition(0)
	UserSkillCC:do_query_skill_list( pack, true )
end

-- 收到客户端请求服务器发送任务列表的请求
function NewerCampServerCC:req_task_list(client_pack)
	-- 获取玩家在新手体验副本中的当前进度
	local progress = NewerCampModel:get_curr_progress()

	-- 进度有效性检查
	if progress < 1 or progress > 3 then
		return
	end

	if progress == 1 or progress == 2 or progress == 3 then
		local quest_id = progress + 996
		local pack = NetManager:get_socket():alloc()
		-- 写入result
		pack:writeByte(0)
		-- 写入任务数量
		pack:writeWord(1)
		-- 任务id
		pack:writeWord(quest_id)
		-- 任务目标数量
		pack:writeWord(1)
		-- 任务当前进度值
		pack:writeInt(0)

		-- 模拟发送到客户端
		pack:setPosition(0)
		TaskCC:do_task_list(pack, true)
	end
end

-- 模拟客户端向服务器发送请求宠物列表,收到此消息后,dummy server向客户端发送一份假列表
function NewerCampServerCC:req_get_pet_list(client_pack)
	local pet_list = NewerCampConfig:get_pet_list()
	local pet_conf = pet_list[1]
	if not pet_conf then
		return
	end
	local pack = NetManager:get_socket():alloc()
	-- 宠物栏的大小
	pack:writeInt(3)
	-- 宠物的数量
	pack:writeInt(1)
	-- 写入宠物数据
	pack:writeInt(pet_conf.id)			-- id
	pack:writeInt(pet_conf.monster_id)	-- 怪物id
	pack:writeInt(pet_conf.life)		-- 生命值
	pack:writeInt(pet_conf.shouming) 	-- 寿命
	pack:writeInt(pet_conf.happy_val) 	-- 快乐值
	pack:writeInt(pet_conf.level) 		-- 等级
	pack:writeInt(pet_conf.fight_type) 	-- 战斗类型
	pack:writeInt(pet_conf.blood_bag) 	-- 血包
	pack:writeInt(pet_conf.cur_exp) 	-- 当前经验
	pack:writeInt(pet_conf.max_exp) 	-- 最大经验
	pack:writeInt(pet_conf.wuxing) 		-- 悟性
	pack:writeInt(pet_conf.grow_val) 	-- 成长值
	pack:writeInt(pet_conf.pet_type) 	-- 宠物类型
	pack:writeInt(pet_conf.attack_type) -- 攻击类型
	pack:writeInt(pet_conf.level_title) -- 等级称号
	pack:writeInt(pet_conf.mon_title) 	-- 兽阶称号
	-- 战斗属性
	pack:writeInt(pet_conf.max_blood) 	-- 最大血
	pack:writeInt(pet_conf.attack) 		-- 攻击
	pack:writeInt(pet_conf.inner_defen) -- 内防御
	pack:writeInt(pet_conf.outer_defen) -- 外防御
	pack:writeInt(pet_conf.baoji) 		-- 暴击
	pack:writeInt(pet_conf.hit) 		-- 命中
	pack:writeInt(pet_conf.duck) 		-- 闪避
	pack:writeInt(pet_conf.fight_baoji) -- 抗暴击
	-- 资质值
	pack:writeInt(pet_conf.attack_zz) 	-- 攻击资质
	pack:writeInt(pet_conf.defen_zz) 	-- 防御资质
	pack:writeInt(pet_conf.skillful_zz) -- 灵巧资质
	pack:writeInt(pet_conf.shenfa_zz) 	-- 身法资质
	-- 基础资质
	pack:writeInt(pet_conf.att_base_zz) -- 攻击基础资质
	pack:writeInt(pet_conf.def_base_zz) -- 防御基础资质
	pack:writeInt(pet_conf.ski_base_zz) -- 灵巧基础资质
	pack:writeInt(pet_conf.sf_base_zz) 	-- 身法基础类型
	pack:writeInt(pet_conf.fight_val) 	-- 战斗力
	pack:writeInt(pet_conf.jineng_slot) -- 技能槽
	pack:writeInt(pet_conf.max) 		-- max
	pack:writeString(pet_conf.name) 	--名字
	-- 技能数量
	local skill_num = #pet_conf.skill
	pack:writeInt(skill_num)
	for i=1, skill_num do
		local skill_info = pet_conf.skill[i]
		pack:writeInt(skill_info.skill_id)
		pack:writeInt(skill_info.skill_lv)
		pack:writeInt(skill_info.skill_cd)
		pack:writeInt(skill_info.skill_keyin)
	end

	-- 模拟发送到客户端
	pack:setPosition(0)
	PetCC:do_get_pet_list(pack, true)
end

-- 服务器假技能快捷键
function NewerCampServerCC:req_get_key_from_dummy()
	print('req_get_key_from_dummy')
	-- local player = EntityManager:get_player_avatar()
	-- local skill_data = job_to_skill_id[player.job]
	local skill_data = UserSkillModel:get_skill_list()
	local pack = NetManager:get_socket():alloc()
	pack:writeByte(#skill_data)
	if #skill_data > 0 then
		for i = 1, #skill_data do
			if i > 4 then return end
			pack:writeByte(i)
			pack:writeByte(1)
			pack:writeWord(skill_data[i].id)
		end
	end
	-- 模拟发送到客户端
	pack:setPosition(0)
	KeySettingCC:do_get_key_setting(pack)
end