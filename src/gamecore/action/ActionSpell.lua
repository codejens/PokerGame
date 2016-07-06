-- ActionSpell.lua
-- created by tjh on 2015-5-22
-- 主角使用技能类

ActionSpell = simple_class(ActionBase)

function ActionSpell:__init( skill_id, target_id ,entity)

	self.priority = ActionConfig.PRIORITY_THREE

	self.skill_id	= skill_id
	self.target_id 	= target_id

	-- 保存释放技能的实体
	if (  entity ) then
		self.player = entity;
	end

	-- 获取技能动作
	--self.action_id, self.effect_id = SkillConfig:get_spell_action(skill.id, skill.level)
	-- 毫秒数
	self.duration = 1--self.player.attackSpeed/1000

	if self.duration > 0 then
		local endback = callback:create(  )
		local function end_cb_func(  )
			self:stop_action()
		end
		endback:start(self.duration,end_cb_func)
	end
end

-- 判断技能是否能做
function ActionSpell:can_do(  )


	return true
end


-- 技能准备
function ActionSpell:_on_start(  )

	local target_x = 0;
	local target_y = 0;
	-- 如果目标id不为0说明是指定技能，否则是群攻技能
	if ( self.target_id ~= 0 ) then

		local target = EntityManager:get_entity(self.target_id)
		-- 如果攻击的时候发现怪物已经死了，这时候马上停止动作
		if ( target ) then
			-- 面向目标
			target_x,target_y = target:get_map_position()
			local pos = SceneManager:map_pos_to_opgl_pos(  target_x, target_y )
			target_x = pos.x
			target_y = pos.y
			self.player:face_to(target_x,target_y)
			
		else
			self:end_action();
			return
		end
	else
		-- target_x = self.player.x;
		-- target_y = self.player.y;
		self:end_action()
		return 
	end
	-- 主角停止手上的动作
	self.player:stopAction()
	-- 然后做动作
	self.player:use_skill()

	-- 通知服务器
	print(self.skill_id, self.target_id, target_x, target_y, self.player.dir )
	SkillSystemCC:req_use_skill( self.skill_id, self.target_id, target_x, target_y, self.player.dir )


end

-- 动作失败
function ActionSpell:_on_fail(  )

	self.player:stopAction()
end

-- 动作结束
function ActionSpell:_on_end(  )

	self.player.model:stopAction()
	if self.delay_cb ~= nil then
		self.delay_cb:cancel()
		self.delay_cb = nil
	end
end
