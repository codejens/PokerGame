---------------------------------------------
-----HJH 2014-10-22
-----必杀技动作


ActionCombatPowerAttack = simple_class(ActionSpell)

function ActionCombatPowerAttack:__init( skill, target_id )
	ActionSpell.__init(self,skill,target_id)
	self.priority = ActionConfig.PRIORITY_THREE
	self.type = skill.id
end

function ActionCombatPowerAttack:_on_start()
	-- xprint('ActionSpell:stopMove')
	print(" ActionCombatPowerAttack:_on_start(  )..........")
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

	print('ActionSpell >>.',self.user_skill.id,self.user_skill.name, self.effect_id)
	print("actionSpell action_id,player.dir",self.action_id, self.player.dir)
	self.player:playAction(self.action_id, self.player.dir, false)
	local delay_skill_request = -1
	-- 播放特效
	if self.effect_id ~= 0 then
		self.delay_cb = callback:new();
		local m_x = self.player.model.m_x
		local m_y = self.player.model.m_y
		local effect_animation_table = effect_config[self.effect_id];
		local skill_id = self.user_skill.id;
		if skill_id == 33 then
			delay_skill_request = bishaji_config.sword_rain.delay_skill_request
		end

		local function cb()
			if skill_id == 33 then
				-- 刀客必杀技
				-- 拿到屏幕中点位置，确定动画播放位置的基准点
				local cam_pos 		= ZXGameScene:sharedScene():cameraMapPosition()
				self:attack_animation(effect_animation_table,cam_pos.x,cam_pos.y,33)
			elseif skill_id == 34 then
				-- 枪士必杀技
				local cam_pos 		= ZXGameScene:sharedScene():cameraMapPosition()
				self:attack_animation(effect_animation_table,cam_pos.x,cam_pos.y,34)
			elseif skill_id == 35 then
				-- 弓手必杀技
				-- 这两个reload是调试用的，不是为了调试配置，切勿打开
				-- reload "../data/action_effects/effects"
				-- reload "config/EffectConfig"
				local cam_pos 		= ZXGameScene:sharedScene():cameraMapPosition()
				-- 最后一个参数是动画持续时间，以毫秒为单位，表示动画一直循环，直到超时删除。
				-- 2450不可随意改，跟着配置走的。因为配置的动作动画时间是2.5秒，所以这里旋风动画也要维持2.45秒
				self:attack_animation(effect_animation_table,cam_pos.x,cam_pos.y,35,2450)
			elseif skill_id == 36 then
				-- 贤儒必杀技
				local cam_pos 		= ZXGameScene:sharedScene():cameraMapPosition()
				self:attack_animation(effect_animation_table,cam_pos.x,cam_pos.y,36)
			end

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
	
	local tmp_max_cd = self.user_skill.max_cd
	local tmp_skill_id = self.user_skill.id
	local tmp_target_id = self.target_id
	local tmp_dir = self.player.dir
	local function call_back()
		-- 通知服务器
		local curSceneId = SceneManager:get_cur_scene()
		-- 如果玩家当前在新手体验副本中,则释放的技能为假技能
		if curSceneId == 27 then
			UserSkillModel:use_skill_request_to_dummy_server(tmp_skill_id, tmp_target_id)
		else
			UserSkillModel:use_skill_request(tmp_skill_id, tmp_target_id, target_x, target_y, tmp_dir)
		end

		if ( tmp_max_cd ~= 0 ) then
			-- -- 更新技能cd
			UserSkillModel:set_skill_cd( tmp_skill_id );
		end
	end

	if delay_skill_request == -1 then
		call_back()
	elseif delay_skill_request > 0 then
		local request_delay_cb = callback:new();
		request_delay_cb:start(delay_skill_request,call_back);
	end

end

function ActionCombatPowerAttack:attack_animation(effect_animation_table,m_x,m_y,effect_type,time)
	-- reload "../data/action_effects/effects"
	EffectBuilder:playBishajiMapLayerEffect(effect_animation_table,m_x, m_y,nil,time,nil,nil,nil,effect_type)
end