-- ActionCombatAttack.lua
-- created by aXing on 2013-1-18
-- 主角使用技能类

-- require "action/ActionBase"
-- require "entity/EntityManager"
-- require "config/EffectConfig"

--super_class.ActionCombatAttack(ActionBase)
ActionCombatAttack = simple_class(ActionBase)

local _math_random = math.random

local _NEXT_ACTION = avatar_normal_attack_loop
local _SHADOW_ACTION = avatar_shadow_normal_attack
local _default_effect = { effect = 0 }

-- 被攻击的缓存复制对象
-- 延迟回调使用
local target_model = {}

local function getNextAction(skill_action, id)
	for k, v in ipairs(skill_action) do
		if v.act == id then
			return v
		end
	end
--@debug_begin
	for k, v in ipairs(skill_action) do
		print('普通技能的动作配置',v.act, id)
	end
--@debug_end
	return _default_effect
end


function ActionCombatAttack:__init( skill, target_id ,entity)
	ActionBase.__init(self)
	self.class_name = "ActionCombatAttack";
	self.user_skill	= skill
	self.target_id 	= target_id

--[[
	local skillinfo = SkillConfig:get_skill_by_id( skill.id )
	local skill_action = skillinfo.actions

	assert(skill_action,string.format('ActionCombatAttack:skill_action 没有配置 %s %d',skillinfo.name, skill.id))
]]--
	local skill_action = SkillConfig.getSimpleAttackWithBodyID(entity.job,skill.id).actions
	-- 保存释放技能的实体
	if (  entity ) then
		self.player = entity;
	end
	local last_action_id = entity.last_action_id
	local action_id = nil

	-- 获取技能动作
	if not last_action_id or not _NEXT_ACTION[last_action_id] then
		--print("run if last_action_id,_NEXT_ACTION[last_action_id]",last_action_id,_NEXT_ACTION[last_action_id])
		self.action_id = ZX_ACTION_HIT
		self.effect_id = getNextAction(skill_action,ZX_ACTION_HIT).effect
		self.effect_type = getNextAction(skill_action,ZX_ACTION_HIT).type
		--skill_action[ZX_ACTION_HIT].effect
	else
		--print("run else")
		local next_action_list = _NEXT_ACTION[last_action_id]
		--print('>>>>>>>>>>>>>>>>>>>>',last_action_id,#next_action_list)
		self.action_id = next_action_list[_math_random(1,#next_action_list)]
		self.effect_id = getNextAction(skill_action,self.action_id).effect --skill_action[self.action_id].effect
		self.effect_type = getNextAction(skill_action,self.action_id).type
	end

	--SkillConfig:get_spell_action(skill.id, skill.level)
	-- self.duration = SkillConfig:get_skill_duration( skill.id, skill.level )
	-- 毫秒数
	self.duration = self.player.attackSpeed + math.random(20,60)
	--print('self.player.attackSpeed',self.player.attackSpeed)
	--self.is_need_duration = true;
end

-- 判断技能是否能做
function ActionCombatAttack:can_do(  )

	return true
end


-- 技能准备
function ActionCombatAttack:_on_start(  )
--	xprint('ActionSpell:stopMove')
	-- print(" ActionSpell:_on_start(  )..........")
	local target_x = 0;
	local target_y = 0;
	local _player = self.player
	-- 如果目标id不为0说明是指定技能，否则是群攻技能
	local target = nil
	if ( self.target_id ~= 0 ) then

		target = EntityManager:get_entity(self.target_id)
		-- 如果攻击的时候发现怪物已经死了，这时候马上停止动作
		if ( target ) then
			-- 面向目标
			_player:face_to_target(target)
			target_x = target.x;
			target_y = target.y;
		else
			self:end_action();
			print("怪物已死..................................")
			return;
		end
	else
		target_x = _player.x;
		target_y = _player.y;
	end
	-- 主角停止手上的动作
	_player:stopMove()
	-- 然后做动作
	_player:playAction(self.action_id, _player.dir, false)
--print("^^^^^^^^^^^^^^^^^ActionCombatAttack:_on_start _player.dir",_player.dir)
	_player:createShadowAction(self.action_id)
	
	-- 播放特效
	if ( self.effect_id ~= 0 ) then
		-- self.delay_cb = callback:new();
		-- local function cb()
			local model = _player.model
			local effect_animation_table = effect_config[self.effect_id];
			if effect_animation_table.stept then	
				if self.player.dir == 0 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 0
				elseif self.player.dir == 1 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 0
				elseif self.player.dir == 2 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 1
				elseif self.player.dir == 3 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 2
				elseif self.player.dir == 4 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 2
				elseif self.player.dir == 5 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 2
				elseif self.player.dir == 6 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 1
				elseif self.player.dir == 7 then
					effect_animation_table.beginIndex = effect_animation_table.stept * 0
				end
			else
				effect_animation_table.beginIndex = -1
				effect_animation_table.stept = -1
			end
			-- modify after tjxs 3为飞行特效
			if self.effect_type == 3 then
				EffectBuilder:playEntityEffect(self.effect_type,
											   effect_animation_table,
											   time,
											   target,
											   self.player,
											   self.effect_id)

				-- 添加受击特效
				-- if target_attacked_effects[self.effect_id] then
				-- 	-- target_attacked_effect_
				-- 	local tg_effect_t = target_attacked_effects[self.effect_id]
				-- 	local tg_eff_ani_t = effect_config[tg_effect_t.effect_id]
				-- 	EffectBuilder:playEntityEffect( tg_effect_t.type,
				-- 								   tg_eff_ani_t,
				-- 								   time,
				-- 								   target,
				-- 								   self.player,
				-- 								   tg_effect_t.effect_id)
				-- end
			else
				_player:playEffectAt(effect_animation_table)
			end

			-- 添加受击特效
			local target = EntityManager:get_entity(self.target_id)
			target_model[self.target_id]= { model = { 
				m_x=target.model.m_x, 
				m_y= target.model.m_y, 
				m_h= target.model:getBodyHeight(),
				target_id = self.target_id
				}
			}
			
			if target_attacked_effects[_player.job] then

				local tg_effect_t = target_attacked_effects[_player.job]
				target_model[self.target_id].model.effect_h = tg_effect_t.effect_h
				local cb = callback:new()
				local function cb_func()
					local tg_eff_ani_t = effect_config[tg_effect_t.effect_id]
					EffectBuilder:playEntityEffect( tg_effect_t.type,
												   tg_eff_ani_t,
												   time,
												   target_model[self.target_id],
												   _player,
												   tg_effect_t.effect_id)
					target_model[self.target_id] = nil
				end
				cb:start( tg_effect_t.delay, cb_func)
				-- target_attacked_effect_
			end
			--self.player.model:playEffectAt( effect_animation_table[1],self.effect_id, 2, effect_animation_table[3],nil,self.player.dir,0,-100,effect_animation_table[2]);
			-- self.delay_cb = nil
		-- end
		-- self.delay_cb:start(0.01,cb);
		SoundManager:playEffectSound(self.effect_id,false)
	else
		SoundManager:playActionSound( self.action_id, false )
	end

	--获取打击事件
	local event = EntityActionConfig.getStruckEvent(self.action_id)
	event = {0.5}
	if event then
		print("xxx-1")
		EntityManager:setEntityStruck(event, _player.handle, self.target_id)
	end
	--通知受击
	--self.player:setTargetStruckEvent(action_id,self.target_id)

	-- 通知服务器
	
	local curSceneId = SceneManager:get_cur_scene()
	-- 如果玩家当前在新手体验副本中,则释放的技能为假技能
	if curSceneId == 27 then
		UserSkillModel:use_skill_request_to_dummy_server(self.user_skill.id, self.target_id)
	else
		UserSkillModel:use_skill_request(self.user_skill.id, self.target_id, target_x, target_y, _player.dir)
	end

	if ( self.user_skill.max_cd ~= 0 ) then
		-- -- 更新技能cd
		UserSkillModel:set_skill_cd( self.user_skill.id );
	end

	--print("主角使用技能。。。。。。。。。。。。。。。。。。。。。。。。。。")
	--print("ActionSpell:_on_start")
end

-- 动作失败
function ActionCombatAttack:_on_fail(  )
--@modified by Shan lu 貌似以前都没调用过都没问题,会自动调用Idle
	--self.player.model:stopAction()
	--print("ActionSpell:_on_fail")
	self.player:stopShadowAction()
end

-- 动作结束
function ActionCombatAttack:_on_end(  )
--@modified by Shan lu 貌似以前都没调用过都没问题,会自动调用Idle
	--self.player.model:stopAction()
	-- print("ActionSpell:_on_end...")
	if self.delay_cb ~= nil then
		self.delay_cb:cancel()
		self.delay_cb = nil
	end
	self.player:stopShadowAction()
end
