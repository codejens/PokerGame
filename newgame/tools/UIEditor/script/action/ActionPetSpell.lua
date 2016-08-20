-- ActionPetSpell.lua
-- created by hcl on 2013-3-11
-- 宠物使用技能类

-- require "action/ActionBase"
-- require "entity/EntityManager"

--super_class.ActionPetSpell(ActionBase)
ActionPetSpell = simple_class(ActionBase)

function ActionPetSpell:__init( skill_id, target_id ,entity)
	ActionBase.__init(self)
	self.skill_id	= skill_id
	self.target_id 	= target_id

	-- 保存释放技能的实体
	if (  entity ) then
		self.player = entity;
	end

	-- 获取技能动作
	self.action_id, self.effect_id = SkillConfig:get_spell_action( skill_id, 1 )
	self.is_need_duration = false;
end

-- 判断技能是否能做
function ActionPetSpell:can_do(  )

	-- if self.target_id ~= nil then

	-- 	local target = EntityManager:get_entity(self.target_id)

	-- 	if target == nil then
	-- 		return false
	-- 	end

	-- 	if self.target_id ~= self.player.target_id then
	-- 		return false
	-- 	end

	-- 	-- 如果目标是自己，或者目标已死，则不能攻击
	-- 	if target == self.player or target.dead then
	-- 		return false
	-- 	end

	-- 	-- NPC不能攻击
	-- 	if EntityConfig:is_npc(target.type) then
	-- 		return false
	-- 	end

	-- 	-- 在安全区，只能攻击怪物
	-- 	if not EntityConfig:is_monster(target.type) and SceneManager:is_forbid_pk_area() then
	-- 		return false
	-- 	end
	-- end
	return true
end

-- 技能准备
function ActionPetSpell:_on_start(  )
--	xprint('ActionPetSpell:stopMove')
	local target = EntityManager:get_entity(self.target_id)
	-- 如果技能准备释放的时候发现怪已经死了。。这时候就停止攻击
	if ( target and self.player.model ) then 
		-- 主角停止手上的动作
		self.player:stopMove()
		
		-- 然后面向目标
		self.player:face_to_target(target)
		-- 然后做动作
		self.player:playAction(self.action_id, self.player.dir, false)

		local curSceneId = SceneManager:get_cur_scene()
		-- 如果玩家当前在新手体验副本中,则释放的技能为假技能
		if curSceneId == 27 then
			PetCC:req_use_dummy_skill(self.skill_id, target.handle)
		else
			PetCC:req_use_skill( self.skill_id ,target.handle ,target.x ,target.y , self.player.dir );
		end

		-- 宠物普通攻击增加飞行特效
		if self.skill_id == 78 then
			EffectBuilder:playEntityEffect(3,
								   effect_config[7102],
								   -1,
								   target,
								   self.player,
								   7102)
		end
		-- 如果宠物释放的技能不是普通攻击则飘技能文字
		-- if ( self.skill_id ~= 78 ) then
		-- 	local skill_name = SkillConfig:get_skill_name_by_id( self.skill_id )
		-- 	ZXEffectManager:sharedZXEffectManager():run_attr_change_action( self.player.model:getBillboardNode(),"#cffc000"..skill_name);
		-- end
		local cb = callback:new();
		local function fun_back( ... )
			-- body
			--增加宠物攻击音效，暂时没按技能分类做
			--addby msy@2014-08-14
			SoundManager:playPetAttackEffectSound( nil , false )
		end
		cb:start(0.5,fun_back);
		
	end
	--
	self:end_action()
end

-- 动作失败
function ActionPetSpell:_on_fail(  )
--@modified by Shan lu 貌似以前都没调用过都没问题,会自动调用Idle
	--self.player.model:stopAction()
end

-- 动作结束
function ActionPetSpell:_on_end(  )
--@modified by Shan lu 貌似以前都没调用过都没问题,会自动调用Idle
	--self.player.model:stopAction()
	--print("ActionSpell:_on_end(  )")
end
