-- ActionSpell.lua
-- created by aXing on 2013-1-18
-- 主角使用技能类

-- require "action/ActionBase"
-- require "entity/EntityManager"
-- require "config/EffectConfig"

--super_class.ActionSpell(ActionBase)
ActionSpell = simple_class(ActionBase)

function ActionSpell:__init( skill, target_id ,entity)
	ActionBase.__init(self)
	self.class_name = "ActionSpell";
	self.user_skill	= skill
	self.target_id 	= target_id

	-- 保存释放技能的实体
	if (  entity ) then
		self.player = entity;
	end


	-- 获取技能动作
	self.action_id, self.effect_id, self.effect_type = SkillConfig:get_spell_action(skill.id, skill.level)
	-- self.duration = SkillConfig:get_skill_duration( skill.id, skill.level )
	-- 毫秒数
	self.duration = self.player.attackSpeed + math.random(20,60)
	--self.is_need_duration = true;
end

-- 判断技能是否能做
function ActionSpell:can_do(  )
	return true
end


-- 技能准备
function ActionSpell:_on_start(  )
--	xprint('ActionSpell:stopMove')
	print(" ActionSpell:_on_start(  )..........")
	local target_x = 0;
	local target_y = 0;
	-- 如果目标id不为0说明是指定技能，否则是群攻技能
	if ( self.target_id ~= 0 ) then

		local target = EntityManager:get_entity(self.target_id)
		-- 如果攻击的时候发现怪物已经死了，这时候马上停止动作
		if ( target ) then
			-- 面向目标
			self.player:face_to_target(target)
			target_x = target.x;
			target_y = target.y;
		else
			self:end_action();
			print("怪物已死..................................")
			return;
		end
	else
		target_x = self.player.x;
		target_y = self.player.y;
	end
	-- 主角停止手上的动作
	self.player:stopMove()
	-- 然后做动作

	-- print('ActionSpell >>.',self.user_skill.id,self.user_skill.name, self.effect_id)
	-- print("actionSpell action_id,player.dir",self.action_id, self.player.dir)
	self.player:playAction(self.action_id, self.player.dir, false)
	-- 播放特效
	if self.effect_id ~= 0 then
		self.delay_cb = callback:new();
		local m_x = self.player.model.m_x
		local m_y = self.player.model.m_y
		local effect_animation_table = effect_config[self.effect_id];
		local function cb()
			EffectBuilder:playMapLayerEffect( effect_animation_table,
										  	  m_x, m_y)

			require "../data/sound_effect"
			-- print("==========ActionSpell >> sound_effect: ", self.effect_id, sound_effect[self.effect_id])
			if ( sound_effect[self.effect_id] ) then
				-- 播放技能音效
				SoundManager:playEffectSound( self.effect_id , false )
			end
		end
		local delay = effect_animation_table.delay or 0.0
		self.delay_cb:start(delay,cb);
	end
	
	-- 通知服务器
	local curSceneId = SceneManager:get_cur_scene()
	-- 如果玩家当前在新手体验副本中,则释放的技能为假技能
	if curSceneId == 27 then
		UserSkillModel:use_skill_request_to_dummy_server(self.user_skill.id, self.target_id)
	else
		UserSkillModel:use_skill_request(self.user_skill.id, self.target_id, target_x, target_y, self.player.dir)
	end

	if ( self.user_skill.max_cd ~= 0 ) then
		-- -- 更新技能cd
		UserSkillModel:set_skill_cd( self.user_skill.id );
	end

	--print("主角使用技能。。。。。。。。。。。。。。。。。。。。。。。。。。")
	--print("ActionSpell:_on_start")
end

-- 动作失败
function ActionSpell:_on_fail(  )
--@modified by Shan lu 貌似以前都没调用过都没问题,会自动调用Idle
	--self.player.model:stopAction()
	--print("ActionSpell:_on_fail")
end

-- 动作结束
function ActionSpell:_on_end(  )
--@modified by Shan lu 貌似以前都没调用过都没问题,会自动调用Idle
	--self.player.model:stopAction()
	-- print("ActionSpell:_on_end...")
	if self.delay_cb ~= nil then
		self.delay_cb:cancel()
		self.delay_cb = nil
	end
end
