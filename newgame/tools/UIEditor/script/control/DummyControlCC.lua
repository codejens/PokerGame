-- DummyControlCC
super_class.DummyControlCC()

function DummyControlCC:__init(lbX,lbY,rtX,rtY,progress)
	-- 用于创建handle的序列号
	self.sequence = 100000
	-- 怪物列表
	self.monster_list = {}
	-- 怪物活动范围
	if lbX and lbY and rtX and rtY then
		self.lbX = lbX
		self.lbY = lbY
		self.rtX = rtX
		self.rtY = rtY
	end
	self:SetupMonsterLogic(progress)
	if progress == 2 then
		self:SetupMonsterLogic(progress + 1)
	end
end

-- 设置怪物的活动范围
function DummyControlCC:SetupMonsterActiveArea(lbX,lbY,rtX,rtY)
	if lbX and lbY and rtX and rtY then
		self.lbX = lbX
		self.lbY = lbY
		self.rtX = rtX
		self.rtY = rtY
	end
end

-- 玩家是否处于怪物的攻击区域内(此处攻击区域设定为,怪物的活动区域)
function DummyControlCC:isPlayerInAttackArea()
	local player = EntityManager:get_player_avatar()
	local pos_x,pos_y = player.model.m_x, player.model.m_y

	-- 怪物的活动范围(矩形区域的左下角、右上角坐标)
	if pos_x < self.lbX-200 or pos_x > self.rtX+200 or pos_y < self.lbY-200 or pos_y > self.rtY+200 then
		return false
	end
	return true
end

local function playerLoseBlood(hp)
	local pack = NetManager:get_socket():alloc(0,7)
	-- attr count
	pack:writeByte(1)
	-- attr id
	pack:writeByte(7)
	-- attr value
	pack:writeUInt(hp)
	NetManager.SendToClient(pack)
end

-- 怪物攻击玩家
function DummyControlCC:AttackPlayer(entity)
	-- 获得player的坐标,运动到离玩家一定的距离的时候,开始发起攻击
	local player = EntityManager:get_player_avatar()
	if not player.model or not entity.model then
		return
	end
	local pos_x,pos_y = player.model.m_x, player.model.m_y
	local x,y = entity.model.m_x, entity.model.m_y
	local absX= math.abs(pos_x-x)
	local absY= math.abs(pos_y-y)
	local length = math.floor(math.sqrt(absX*absX + absY*absY))

	-- 面向玩家
	entity:face_to(pos_x, pos_y)

	-- 检查怪物与玩家的距离
	if length <= 90 and length >= 40 then
		entity:use_skill(40, 1, entity.dir)
		LuaEffectManager:SpellEffect(40,entity)
		-- 主角掉血、受伤害
		if player.hp > 1 then
			playerLoseBlood(player.hp - 1)
		end
	else
		-- 随机出一个点,作为怪物朝玩家移动的终点,要求玩家与怪物的距离在(0,60)之间
		local desX,desY
		local need_move_l = math.random(length-90,length)
		local dis_x = x - pos_x
		local dis_y = y - pos_y
		if dis_x == 0 then
			desX = x
			if dis_y > 0 then
				desY = y - need_move_l
			else
				desY = y + need_move_l
			end
		elseif dis_y == 0 then
			desY = y
			if dis_x > 0 then
				desX = x - need_move_l
			else
				desX = x + need_move_l
			end
		elseif dis_x > 0 then
			local arg = math.atan(absX/absY)
			if dis_y > 0 then
				desX = x - math.floor(math.sin(arg) * need_move_l)
				desY = y - math.floor(math.cos(arg) * need_move_l)
			else
				desX = x - math.floor(math.sin(arg) * need_move_l)
				desY = y + math.floor(math.cos(arg) * need_move_l)
			end
		elseif dis_x < 0 then
			local arg = math.atan(absY/absX)
			if dis_y > 0 then
				desX = x + math.floor(math.cos(arg) * need_move_l)
				desY = y - math.floor(math.sin(arg) * need_move_l)
			else
				desX = x + math.floor(math.cos(arg) * need_move_l)
				desY = y + math.floor(math.sin(arg) * need_move_l)
			end
		end
		if desX and desY then
			entity:startMove(desX, desY, true)
		end
	end
end

-- 怪物是否位于自己的家中
function DummyControlCC:isMonsterAtHome(entity,lbX,lbY,rtX,rtY)
	local pos_x,pos_y = entity.model.m_x, entity.model.m_y

	if pos_x < lbX or pos_x > rtX or pos_y < lbY or pos_y > rtY then
		return false
	else
		return true
	end
end

-- 怪物返回家(回到自己的活动区域)
function DummyControlCC:goHome(entity,x,y)
	-- 改变朝向
	entity:face_to(x, y)
	entity:startMove(x, y, true)
end

-- 怪物自由移动
function DummyControlCC:freeMove(entity,x,y)
	if entity.model.m_x == x and entity.model.m_y == y then
		return
	end
	-- 改变朝向
	entity:face_to(x, y)
	entity:startMove(x, y, true)
end

-- 怪物控制主逻辑
function DummyControlCC:doLogic(entity)
	-- 检查玩家是否在自己的攻击范围之内(攻击范围设定为：以玩家出生点为中心,以一个固定长度为半径的区域内)
	if self:isPlayerInAttackArea(self.lbX, self.lbY, self.rtX, self.rtY) then
		-- 发起攻击
		self:AttackPlayer(entity)
	else
		local x = math.random(self.lbX, self.rtX)
		local y = math.random(self.lbY, self.rtY)
		-- 如果当前不在活动范围内,则返回怪物的活动范围
		if not self:isMonsterAtHome(entity, self.lbX, self.lbY, self.rtX, self.rtY) then
			self:goHome(entity,x,y)
		else
			-- 玩家不在可攻击范围内,随机自由移动怪物
			-- self:freeMove(entity,x,y)
		end
	end
end

--模拟服务器向客户端发怪物飘血信息
function DummyControlCC:monsterDamageFromDummy(entity, damage)
	local pack   = NetManager:get_socket():alloc(0, 6)
	local handle = entity.handle
    -- handle
    pack:writeUint64(handle)
    -- attr count
    pack:writeByte(1)
    -- attr id
    pack:writeByte(7)
    -- attr value
    pack:writeUInt(damage)
    -- send to client
    NetManager.SendToClient(pack)
    -- 怪物被干死后,从场景中移出掉它
    if damage == 0 then
    	-- 从怪物控制列表中,删除怪物
        self:removeMonsterFromList(handle)
        -- 目标调用函数 GameLogicCC:do_entity_died(0, 35)
        local pack = NetManager:get_socket():alloc(0, 35)
        pack:writeUint64(handle)
        local killer_handle = EntityManager:get_player_avatar_handle()
        pack:writeUint64(killer_handle)
        -- is_hit_fly
        pack:writeInt(1)
        -- send to client
        NetManager.SendToClient(pack)
        if EntityManager:get_entity(handle) then
            EntityManager:destroy_entity(handle)
        end

        -- 怪物被干死后,检查它是否是任务怪,如果是任务怪的话,则要更新任务进度
        -- self:updateQuestByMonsterDied(entity.id)
        if self.monster_list and #self.monster_list == 0 then
        	NewerCampModel:ReportProgress()
        end
    end
end
-- 处理怪物伤害(掉血、飘字)
function DummyControlCC:processMonsterDamage(entity, attack_type, skill_id, curProcess)
	local handle = entity.handle
	local player = EntityManager:get_player_avatar();
	-- 当handle为玩家handle时,技能变为群攻伤害
	if handle == player.handle then
		self:processPowerDamage(skill_id)
		return
	end

	local loseHp = 17
	local extra  = 0
	-- 现在的特殊副本没有宠物和翅膀 先去掉,by hwl
--[[	-- 攻击者类型：0代表主角、1代表宠物
	if attack_type == 0 then
		loseHp = NewerCampConfig:get_hero_damage_by_skill_id(skill_id) or 17
		玩家召唤出了宠物,将享有宠物加成伤害
		if curProcess == 2 then
			local pet_extra  = NewerCampConfig:get_extra_damage_by_pet()
			extra = extra + pet_extra
		elseif curProcess == 3 then
			local pet_extra  = NewerCampConfig:get_extra_damage_by_pet()
			local wing_extra = NewerCampConfig:get_extra_damage_by_wing()
			extra = extra + pet_extra + wing_extra
		end
	else
		loseHp = NewerCampConfig:get_pet_damage_by_skill_id(skill_id) or 17
	end
	技能伤害加上加成伤害
	loseHp = loseHp + extra
]]

	loseHp = NewerCampConfig:get_hero_damage_by_skill_id(skill_id) or 17

	local damage = 0
    if entity.hp >= loseHp then
        damage = entity.hp - loseHp
    end
    self:monsterDamageFromDummy(entity, damage)
end

function DummyControlCC:processPowerDamage(skill_id)
	local loseHp = NewerCampConfig:get_hero_damage_by_skill_id(skill_id) or 17
	local monsters = {}
	--临时怪物表
	for i, v in ipairs(self.monster_list or {}) do
		table.insert(monsters, v)
	end
	for i = 1, #monsters do
		local entity = monsters[i]
		local damage = 0
		if entity.hp >= loseHp then
	        damage = entity.hp - loseHp
	    end
		self:monsterDamageFromDummy(entity, damage)
	end
end

-- 启动怪物逻辑控制
function DummyControlCC:SetupMonsterLogic(progress)
	-- 每次开启新关卡的时候,都需要重新读取新配置
	print('267      progress:', progress)
	local monster_conf = NewerCampConfig:get_progress_config(progress)
	if not monster_conf then
		return
	end

	local function monsterTick()
		for i=1, #self.monster_list do
			local entity = self.monster_list[i]
			self:doLogic(entity)
		end
	end

	if not self.monster_timer then
		self.monster_timer = timer()
		self.monster_timer:start(1, monsterTick)
	else
		self.monster_timer:stop()
		self.monster_timer = nil
		self.monster_timer = timer()
		self.monster_timer:start(1, monsterTick)
	end

	-- 人物自动回血(每2s回复一次血)
	local function humanTick()
		local player = EntityManager:get_player_avatar()
		if player.hp < player.maxHp then
			local pack = NetManager:get_socket():alloc(0,7)
			-- attr count
			pack:writeByte(1)
			-- attr id
			pack:writeByte(7)
			-- attr value
			pack:writeUInt(player.hp+10)
			NetManager.SendToClient(pack)
		end
	end

	if not self.human_timer then
		self.human_timer = timer()
		self.human_timer:start(3, humanTick)
	else
		self.human_timer:stop()
		self.human_timer = nil
		self.human_timer = timer()
		self.human_timer:start(3, humanTick)
	end

	-- 刷怪
	local count = monster_conf.monster_num
	for i=1, count do
		self:refreshMonster(monster_conf, progress)
	end
end

function DummyControlCC:refreshMonster(monster_conf, progress)
	-- 随机获得一个坐标点
	local pos_x,pos_y,originX,originY,radius
	originX = monster_conf.x
	originY = monster_conf.y
	radius  = monster_conf.radius
	pos_x	= math.random(originX-radius, originX+radius)
	pos_y	= math.random(originY-radius, originY+radius)

	local monster_info = MonsterConfig:get_monster_by_id(monster_conf.entity_id)
	if not monster_info then
		return
	end

	local monster_name = monster_info.name
	if type(monster_name) ~= "string" then
		return
	end
	monster_name = monster_name .. "\\"
	local monster_id = monster_conf.entity_id

	self.sequence = self.sequence + 1
	local handle  = self.sequence + progress*100;
	print('1---------------create handle:', handle)
	local is_exist_entity = EntityManager:get_entity(handle)
	if is_exist_entity then
		return
	end

	local pack = NetManager:get_socket():alloc(0, 2)
	pack:writeString(monster_name)
	-- 怪物id
	pack:writeInt(monster_id)
	-- handle
	pack:writeInt64(handle)
	-- 类型
	pack:writeInt(1)
	-- 坐标x
	pack:writeInt(pos_x)
	-- 坐标y
	pack:writeInt(pos_y)
	-- move_x
	pack:writeInt(-1)
	-- move_y
	pack:writeInt(-1)
	-- model id
	pack:writeInt(monster_conf.model_id)
	-- dir
	pack:writeByte(monster_conf.dir)
	-- 等级
	pack:writeByte(monster_conf.level)
	-- HP
	pack:writeUInt(monster_conf.hp)
	-- Max HP
	pack:writeUInt(monster_conf.maxHp)
	-- move speed
	pack:writeWord(monster_conf.moveSpeed)
	-- attack speed
	pack:writeWord(monster_conf.attackSpeed)
	-- state
	pack:writeUInt(monster_conf.state)
	-- monster name corlor
	pack:writeUInt(monster_conf.name_color)
	-- monster attack type and title
	pack:writeByte(monster_conf.wing)
	-- npc功能id
	pack:writeInt(monster_conf.func)
	-- pet title
	pack:writeInt(monster_conf.pet_title)
	-- title
	pack:writeInt(monster_conf.title)
	-- effect count
	pack:writeByte(0)

	-- 发送到客户端
	NetManager.SendToClient(pack)

	-- 保存创建的entity
	local curEntity = EntityManager:get_entity("0x" .. handle)
	if curEntity then
		table.insert(self.monster_list, curEntity)
	end
end

function DummyControlCC:destroy()
	if self.monster_timer then
		self.monster_timer:stop()
		self.monster_timer = nil
	end

	if self.human_timer then
		self.human_timer:stop()
		self.human_timer = nil
	end
end

function DummyControlCC:ClearMonster()
	if not self.monster_list then return end
	for i=1, #self.monster_list do
		local entity = self.monster_list[i]
		if EntityManager:get_entity(entity.handle) then
			EntityManager:destroy_entity(entity.handle)
		end
	end
	self.monster_list = {}
end

function DummyControlCC:removeMonsterFromList(handle)
	local count = #self.monster_list
	local index = 0
	for i=1, count do
		local entity = self.monster_list[i]
		if entity.handle == handle then
			index = i
			break
		end
	end

	if index > 0 then
		for j=index+1, count do
			self.monster_list[j-1] = self.monster_list[j]
		end
		self.monster_list[count] = nil
	end
end

local function quest_complete(task_id)
	local pack = NetManager:get_socket():alloc(6, 3)
	-- 任务id
	pack:writeWord(task_id)
	-- 完成任务返回的结果(恒为0)
	pack:writeChar(0)
	-- send to client
	NetManager.SendToClient(pack)
end

local function quest_update_process(task_id, task_index, task_percent)
	local pack = NetManager:get_socket():alloc(6, 8)
	print('task_id, task_index, task_percent:', task_id, task_index, task_percent)
	-- 任务id
	pack:writeWord(task_id)
	-- 任务的process列表的index
	pack:writeByte(task_index)
	-- 任务的进度值
	pack:writeInt(task_percent)
	-- send to client
	NetManager.SendToClient(pack)
end

function DummyControlCC:updateQuestByMonsterDied(monster_id)
	local yijie_list = TaskModel:get_process_list()
	for i=1,#yijie_list do
		local quest_id = yijie_list[i].task_id
		local questinfo= QuestConfig:get_quest_by_id(quest_id)
		local quetarget= questinfo["target"][1]
		-- 当前任务进度
		local curProcess = yijie_list[i].tab_process[1]

		if type(quetarget) == "table" then
			if quetarget.type == 0 and quetarget.id == monster_id then
				-- 任务完成
				if curProcess + 1 >= quetarget.count then
					quest_complete(quest_id)
					-- 上报进度
					NewerCampModel:ReportProgress()
					-- 请求新任务
					TaskCC:req_task_list(true)
					-- 
				else
					-- 更新任务进度
					quest_update_process(quest_id, 0, curProcess+1)
				end
				-- 跳出循环
				break
			end
		end
	end
end