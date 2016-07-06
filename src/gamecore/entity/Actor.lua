-- Actor.lua
-- created by aXing on 2012-12-1
-- 游戏场景中具备移动属性的实体基类
-- 主要是派生出玩家，NPC，怪物和采集怪
-- 并实现选中功能
-- 实现实体上面的存在的buff字典			-- 2013-4-12

-- require "entity/Entity"

Actor = simple_class(Entity)

local eAnimateSpriteMoveTag = 3  --移动动作tag 定义在引擎

--上右，右，右下，下左，左，左上   1，2，3， 4，5,6, 
local _action_info ={
	--翻转           站立动作id  移动id    攻击1id   攻击2id    坐骑待机id     坐骑移动id
	{  isflip=false, stand_id=0, move_id=3,att_id1=6,att_id2=9, rind_stand_id=12 ,rind_move_id=15},    --  方向1
	{  isflip=false, stand_id=1, move_id=4,att_id1=7,att_id2=10,rind_stand_id=13,rind_move_id=16},
	{  isflip=false, stand_id=2, move_id=5,att_id1=8,att_id2=11,rind_stand_id=14,rind_move_id=17 },
	{  isflip=true,  stand_id=2, move_id=5,att_id1=8,att_id2=11,rind_stand_id=14,rind_move_id=17 },
	{  isflip=true,  stand_id=1, move_id=4,att_id1=7,att_id2=10,rind_stand_id=13,rind_move_id=16 },
	{  isflip=true,  stand_id=0, move_id=3,att_id1=6,att_id2=9, rind_stand_id=12, rind_move_id=15 }

}

local _FACE_COUNT = 6        -- 朝向数

Actor.STATE_STAND = 1  --站立
Actor.STATE_MOVE = 2   --移动
Actor.STATE_RID_MOVE = 2 --坐骑移动
Actor.STATE_ATTR = 3   --攻击


function Actor:__init( handle )
	-- Entity.__init(self,handle)
	self.model_body = nil  --模型的body
	self.cur_state = Actor.STATE_STAND --当前状态

	self.action_info = _action_info[1] --当前动作信息
	self.cur_action_id = 0 --当前动作

	-- cocosEventHelper.listenActionNodeEvent(self.root, 
	-- function(id)
		-- if id == 0 then
			--self:stopAction( )
		-- end
	-- end)

end

-- 实体析构
function Actor:destroy(  )
	Entity.destroy(self)
end

-- 根据目标点计算面向
function Actor:face_to( target_x, target_y )
	-- lp todo
	-- 改变玩家朝向	
	local old_dir = self.dir
	local x,y = self.root:getPosition()
	local dx = math.floor(x - target_x)
	local dy = math.floor(y - target_y)
	if dx ~= 0 or dy ~= 0 then
		local new_angle = math.atan2(dy, dx)
		local angle 	= math.deg(new_angle + math.pi / 2)
		self.dir = math.ceil( (1 - angle / 360) * _FACE_COUNT % _FACE_COUNT ) 
	end

	if old_dir ~= self.dir then
		return self:charge_dir(self.dir)
	end
	self.action_info = _action_info[self.dir] or _action_info[1]
end

--改变方向
function Actor:charge_dir( dir )
	self.dir = dir
	self.action_info = _action_info[self.dir] or _action_info[1]
	self:stopAction()
end

-- 开始朝某个方向移动 target_x,target_y 地图坐标
function Actor:start_move(  target_x, target_y )
	-- lp todo
	--坐标转换到opgl坐标
	local o_pos = SceneManager:map_pos_to_opgl_pos(  target_x, target_y )
	 target_x = o_pos.x
	 target_y = o_pos.y
	-- 改变朝向
	self:face_to(target_x,target_y)

	self:playAction(self.action_info.move_id,true)
	--end
	-- 移动
	self:move(target_x,target_y)
end

function Actor:playAction( action_id,loop )
	if self.cur_action_id ~= action_id then
		self.model:playAction(action_id,loop or false)
		self.cur_action_id = action_id
	end
end

-- 结束移动
function Actor:stopMove(  )
    self.root:stopActionByTag(eAnimateSpriteMoveTag)
end

-- 移动
function Actor:move( x, y )
	--lp todo 速度还要修改
	--self.stopMove()
	-- print("self.moveSpeed = ",self.moveSpeed)
	-- self.moveSpeed = 0.2*1000
	local speed = SceneConfig.LOGIC_TILE_WIDTH / self.moveSpeed--*2+50+50
	-- print("speed = ",speed)
	-- speed = 100
	self.root:moveTo( x, y ,speed)
	print("111111111111x,y",x,y)
	self.cur_state = Actor.STATE_MOVE
end


--动作结束回调
function Actor:_endAction( action_id )
	-- body
	--EffectManage:play_screen_jitter(1,0.3,2)
	--print("--动作结束回调")
	self:stopAction(  )
end

function Actor:play_more_action( id_t )
	local actions ={}
	for i=1,#id_t do
		actions[i] = self:_prepareAction(id_t[i],false)
	end

	local function endAction(  )
		self:_endAction(id_t[1])
	end 
	actions[#actions+1] = cc.CallFunc:create(endAction)
	local quence = cc.Sequence:create(actions)
	self:_runAction(quence)

	self.cur_action_id = id_t[1]
end
--播放动作
function Actor:play_once_action( action_id )

	local action = self:_prepareAction(action_id,false)

	local function endAction(  )
		self:_endAction(action_id)
	end 
	local quence = cc.Sequence:create(action,cc.CallFunc:create(endAction))
	self:_runAction(quence)

	self.cur_action_id = action_id

end

--根据动作ID构建动作
function Actor:_prepareAction( action_id,loop )
	return self.model:prepareAction(action_id,loop or false)
end

--根据动作ID构建动作
function Actor:_runAction( action )
	self.model:runAction(action)
end

-- 实体死亡
function Actor:die(  )
	-- 暂时只有玩家角色才享有死亡动作
	
end

function Actor:attack( target )
	
end

-- 实体释放技能 
function Actor:use_skill( skill_id, skill_level, dir )
    -- lp todo
	--根据技能id获取到 动作，特效
	self.cur_state = Actor.STATE_ATTR

	--播放攻击动作
	local action_id = nil
	if skill_id == 1 or skill_id == 40 then
		action_id = self.action_info.att_id1
	else
	 	action_id = self.action_info.att_id2
	end
	local isflip = self.action_info.isflip

	local rand = math.random(3,5)
	--action_id = rand * 3 + self.action_info.stand_id
	-- rand = math.random(3,5)
	-- local action_id1 = rand * 3 + self.action_info.stand_id
	-- rand = math.random(3,5)
	-- local action_id2 = rand * 3 + self.action_info.stand_id
	-- local rand2 = math.random(1,3)
	-- local actions_id = {}
	-- if rand2 == 1 then
	-- 	actions_id[1] = action_id
	-- elseif rand2 == 2 then
	-- 	actions_id[1] = action_id
	-- 	actions_id[2] = action_id1
	-- elseif rand2 == 3 then
	-- 	actions_id[1] = action_id
	-- 	actions_id[2] = action_id1
	-- 	actions_id[3] = action_id2
	-- end
	--self:play_more_action(actions_id)
	self:play_once_action(action_id)

	-- --测试代码
	-- if self.type ~= -1 then
	-- 	return 
	-- end
	-- --播放特效
	-- local date_t = self:_get_skill_effect(skill_id)
	-- if skill_id == 5 then
	-- 	EffectManage:play_bs_effect(self.root,999)
	-- 	return
	-- end
	-- for i=1,#date_t do
	-- 	self:playEffect(skill_id,date_t[i].effect_action,isflip)
	-- end

	-- SkillSystemCC:req_use_skill( skill_id, self.target_entity, self.target_x, self.target_y ,self.dir )
end

--特效以后还要换实现方式 先写测试用的
function Actor:_get_skill_effect( skill_id )
	local _table = {}
	_table[1] = {}
	--获取特效路径
	_table[1].effect_path =string.format("animations/skill/001/00%d",skill_id)
	--获取特效json
	_table[1].json = SkillConfig:get_skill_effect_josn( skill_id )
	--特效动作
	_table[1].effect_action = SkillConfig:get_skill_effect_action( skill_id )
	if _table[1].effect_action ~= 0 then
		_table[1].effect_action = _action_info[self.dir].stand_id --跟待机一个方向
	end

	if skill_id == 1 then
		_table[2] = {}
		_table[1].effect_path =string.format("animations/skill/001/001/00%d",1)
		_table[2].effect_path = string.format("animations/skill/001/001/00%d",2)
		_table[2].json=_table[1].json
		_table[2].effect_action = _table[1].effect_action
	end
	return _table
end


function Actor:playEffect( id,action_id,isflip )
	--延迟播放特效
	local cb_func =  callback:create()
	local function playeffect( ... )
		EffectManage:play_skill_effect( self.root,id,false,0,0,action_id,isflip )
	end 
	cb_func:start(0.2,playeffect)

end

-- 属性改变需要做的处理。  例如某个属性改变，向通知中心发送一个通知
function Actor:change_attr_event( attri_type, attri_value, attr_value_old  )
	Entity.change_attr_event(self,attri_type, attri_value, attr_value_old)
	if attri_type == "dir" then
		self:charge_dir(attri_value)
	end
end


--停止动作
function Actor:stopAction(  )
	--if self.cur_state ~= Actor.STATE_STAND then
		self.root:stopActionByTag(eAnimateSpriteMoveTag)
		local action_id = 0
		local flip = self.action_info.isflip

		if self.cur_state == Actor.STATE_MOVE then
			action_id = self.action_info.stand_id

		elseif self.cur_state == Actor.STATE_RID_MOVE then
			action_id = self.action_info.rind_stand_id

		elseif self.cur_state == Actor.STATE_ATTR then
			action_id = self.action_info.stand_id
		end

		self:_standby(action_id,flip)
		self.cur_state = Actor.STATE_STAND
	--end

end

--待机
function Actor:_standby( action_id,flip )
	(self.model_body or self.model):setFlippedX(self.action_info.isflip)
	self:playAction(action_id,true)
end