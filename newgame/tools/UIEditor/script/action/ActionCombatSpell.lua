-- ActionCombatSpell.lua
-- created by aXing on 2013-1-22
-- 处理主角战斗技能动作(技能)

-- require "action/ActionSpell"
-- 战斗技能
--super_class.ActionCombatSpell(ActionSpell)
ActionCombatSpell = simple_class(ActionSpell)

function ActionCombatSpell:__init( skill, target_id )
	ActionSpell.__init(self,skill,target_id)
	self.priority = ActionConfig.PRIORITY_THREE
end

function ActionCombatSpell:_on_start()
--	xprint('ActionSpell:stopMove')
	-- print(" ActionSpell:_on_start(  )..........")
	local target_x = 0;
	local target_y = 0;
	-- 如果目标id不为0说明是指定技能，否则是群攻技能
	local target = nil
	if ( self.target_id ~= 0 ) then

		target = EntityManager:get_entity(self.target_id)
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
	--print("ActionCombatSpell action_id,player.dir",self.action_id, self.player.dir)
	self.player:playAction(self.action_id, self.player.dir, false)
	-- 播放特效
	if self.effect_id ~= 0 then
		self.delay_cb = callback:new();
		local m_x = self.player.model.m_x
		local m_y = self.player.model.m_y
		local effect_animation_table = effect_config[self.effect_id];
		--print("ActionCombatSpell self.effect_id",self.effect_id)
		-- local function cb()
			--------------------------------------------
			---HJH 2014-10-24
			---由于只是六方向，动画起始值要修改	
			local temp_x_stept = 0
			local temp_y_stept = 0
			if effect_animation_table.over_stept then
				if self.player.dir == 0 then
					temp_x_stept = effect_animation_table.over_stept[1].x
					temp_y_stept = effect_animation_table.over_stept[1].y
				elseif self.player.dir == 1 then
					temp_x_stept = effect_animation_table.over_stept[1].x
					temp_y_stept = effect_animation_table.over_stept[1].y	
				elseif self.player.dir == 2 then
					temp_x_stept = effect_animation_table.over_stept[2].x
					temp_y_stept = effect_animation_table.over_stept[2].y	
				elseif self.player.dir == 3 then
					temp_x_stept = effect_animation_table.over_stept[3].x
					temp_y_stept = effect_animation_table.over_stept[3].y
				elseif self.player.dir == 4 then
					temp_x_stept = effect_animation_table.over_stept[3].x
					temp_y_stept = effect_animation_table.over_stept[3].y	
				elseif self.player.dir == 5 then
					temp_x_stept = effect_animation_table.over_stept[3].x * -1
					temp_y_stept = effect_animation_table.over_stept[3].y	
				elseif self.player.dir == 6 then
					temp_x_stept = effect_animation_table.over_stept[2].x * -1
					temp_y_stept = effect_animation_table.over_stept[2].y
				elseif self.player.dir == 7 then
					temp_x_stept = effect_animation_table.over_stept[1].x * -1
					temp_y_stept = effect_animation_table.over_stept[1].y
				end
			end

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
			print("ActionCombatSpell temp_x_stept,temp_y_stept",temp_x_stept,temp_y_stept)
			-- print("effect_animation_table.beginIndex,effect_animation_table.stept,self.player.dir",
				-- effect_animation_table.beginIndex,effect_animation_table.stept,self.player.dir)
			-- EffectBuilder:playMapLayerEffect( effect_animation_table,
			-- 							  	  m_x + temp_x_stept, m_y + temp_y_stept, nil, nil, self.player.dir )
			-- modify after tjxs
			if self.effect_id ~= 1602 then
				if effect_animation_table.is_mapEffect then
					print("--chj", effect_animation_table,
										  	  m_x, m_y, nil, nil, self.player.dir )
					EffectBuilder:playMapLayerEffect( effect_animation_table,
										  	  m_x, m_y, nil, nil, self.player.dir )
				else
					EffectBuilder:playEntityEffect(self.effect_type,
										   effect_animation_table,
										   time,
										   target,
										   self.player,
										   self.effect_id)
				end
			end

			-- 受击特效
			if target_attacked_effects[self.effect_id] then
				-- target_attacked_effect_
				local tg_effect_t = target_attacked_effects[self.effect_id]
				local tg_eff_ani_t = effect_config[tg_effect_t.effect_id]
				EffectBuilder:playEntityEffect( tg_effect_t.type,
											   tg_eff_ani_t,
											   time,
											   target,
											   self.player,
											   tg_effect_t.effect_id)
			end

			-- 播放特效字
			LuaEffectManager:play_skill_effect( self.effect_id, self.player )

			require "../data/sound_effect"
			-- print("==========ActionSpell >> sound_effect: ", self.effect_id, sound_effect[self.effect_id])
			if ( sound_effect[self.effect_id] ) then
				-- 播放技能音效
				SoundManager:playEffectSound( self.effect_id , false )
			end
		-- end
		-- local delay = effect_animation_table.delay or 0.0
		-- self.delay_cb:start(delay,cb);
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
end
