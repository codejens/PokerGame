-- Actor.lua
-- created by aXing on 2012-12-1
-- 游戏场景中具备移动属性的实体基类
-- 主要是派生出玩家，NPC，怪物和采集怪
-- 并实现选中功能
-- 实现实体上面的存在的buff字典			-- 2013-4-12

-- require "entity/Entity"

--创建残影
local SHADOW_TAIL_COLOR    = ccc3(100,100,255) --残影颜色
local SHADOW_CREATE_TIME   = 0.08			   --残影创建间隔
local SHADOW_FADEOUT_TIME  = 0.25 			   --残影Fadeout时间
local SHADOW_FADEOUT_EASEIN= 4 				   --残影加速
local _doStruckDis = 24
local _doStruckScale = 1.09

Actor = simple_class(Entity)

function Actor:__init( handle )
	Entity.__init(self,handle)
	-- added by aXing on 2013-4-12
	-- 添加buff字典
	self.buff_dict = {}			-- {buff_type : buffStruct, ...}

	-- 称号对应的控件 {1:image,...}
	self._title_component = {}
	self._if_show_title = true       -- 是否显示称号

	self._shadow_tail_timer = timer() 

	self._is_shadow_tail = false

	self.__classname = "Actor"

	self._highlight_init = false
end

function Actor:destroy()
	Entity.destroy(self)
	self._shadow_tail_timer:stop()
end

-- 实体更改自己的属性
function Actor:change_entity_attri( attri_type, attri_value )

	local old_value 	= self[attri_type]
	Entity.change_entity_attri(self, attri_type, attri_value)
	self[attri_type]	= attri_value
	-- 以下是主角属性变更的时候，触发的事件
	if attri_type == "moveSpeed" then
		-- 当修改移动速度的时候，修改另外一个叫step步进的属性，用于每帧计算
		-- step为移动两个逻辑格子的步进
		if attri_value then
			self.step = SceneConfig.LOGIC_TILE_WIDTH * 2 / ( attri_value / 1000 )
		else
			self.step = 0
		end

		if self.model ~= nil then
			self.model:changeMoveSpeed(attri_value);
		end

	elseif attri_type == "model" then
		self.model = ZXEntityMgr:toActor(attri_value)
		if self.model == nil then
			print("ERROR:: entity转换actor出错！")
			return
		end
		self:register_click_event()
	-- 即时更新称号
	elseif attri_type == "title" then
		if old_value and old_value ~= attri_value then
			self.camp = Utils:low_word(attri_value)
		   	self.hpStore = Utils:high_word(attri_value)
		   	self:add_title( self.hpStore )
		end
	elseif attri_type == "state" then
		-- 如果实体改变状态，就检查这个实体是否是玩家的攻击目标
		if old_value  then
			-- 如果实体的状态改变为死亡或者禁止攻击
			if ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_DEATH) > 0 or
				ZXLuaUtils:band(attri_value, EntityConfig.ACTOR_STATE_ATTACK_FORBIDEN) > 0 then
				print("实体死亡或者禁止攻击",self.name);
				-- 怪物死亡后马上取消选中
				UserPanel:is_selected_entity( self.handle );
			end
		end

	end
end

-- 注册选中事件
function Actor:register_click_event(  )
	local function on_click( entity_handler )
		-- 不能选中主角
		if ( self == EntityManager:get_player_avatar() ) then
			return
		end
		-- 通知更新主角target_id 
		EntityManager:get_player_avatar():set_target( self );
	end
	-- 策划要求主角和主角的宠物能够点穿，所以他们不注册点击事件
	if ( self.type == -1 or self.type == -2 ) then
		self.model:setClickEvent(0);
	else
		self.model:setClickEvent(GetLuaFuncID(on_click))
	end
end

-- 改变面向
function Actor:face_to( target_x, target_y )
	--print("actor face_to")	
	-- local dx = math.floor(self.model.m_x - target_x)
	-- local dy = math.floor(self.model.m_y - target_y)
	-- if dx ~= 0 or dy ~= 0 then
	-- 	local new_angle = math.atan2(dy, dx)
	-- 	local angle 	= math.deg(new_angle + math.pi / 2)
	-- 	self.dir = (1 - angle / 360) * 8 % 8
	-- 	xprint("mx,my,tx,ty,dir",self.model.m_x, self.model.m_y,target_x,target_y,self.dir)
	-- end

	-- local dx = math.floor(self.model.m_x - target_x)
	-- local dy = math.floor(self.model.m_y - target_y)	
	local dx = math.floor(target_x - self.model.m_x)
	local dy = math.floor(target_y - self.model.m_y)
	local temp_stept = 45
	local begin_stept = temp_stept / 2
	if dx ~= 0 or dy ~= 0 then
		local new_angle = math.atan2(dy,dx)
		local angle = math.deg(new_angle)
		if angle < 0 then
			--print("temp_angle",angle)
			angle = 360 + angle
		end
		if ( angle >= 0 and angle < begin_stept ) or ( angle >= 360 - temp_stept / 2 and angle <= 360 ) then
			self.dir = 2
		elseif angle >= begin_stept and angle < begin_stept + temp_stept then
			self.dir = 3
		elseif angle >= begin_stept + temp_stept and angle < begin_stept + temp_stept * 2 then
			self.dir = 4
		elseif angle >= begin_stept + temp_stept * 2 and angle < begin_stept + temp_stept * 3 then
			self.dir = 5
		elseif angle >= begin_stept + temp_stept * 3 and angle < begin_stept + temp_stept * 4 then
			self.dir = 6
		elseif angle >= begin_stept + temp_stept * 4 and angle < begin_stept + temp_stept * 5 then
			self.dir = 7
		elseif angle >= begin_stept + temp_stept * 5 and angle < begin_stept + temp_stept * 6 then
			self.dir = 0
		elseif angle >= begin_stept + temp_stept * 6 and angle < begin_stept + temp_stept * 7 then
			self.dir = 1
		end
		--print(string.format("mx=%d,my=%d,tx=%d,ty=%d,dir=%d,new_angle=%f,angle=%f",self.model.m_x, self.model.m_y,target_x,target_y,self.dir,new_angle,angle))
	end
end

-- 开始朝某个方向移动
function Actor:startMoveFrom( cur_x, cur_y, target_x, target_y )
	-- print(string.format("来到Actor start move: %d %d %d %d", cur_x, cur_y, target_x, target_y), self.scheduler_id)
	-- 不需要跟服务器做同步
	-- self.x = cur_x
	-- self.y = cur_y
	self:face_to(target_x, target_y)
	self.model:startMove(self.dir, cur_x, cur_y, target_x, target_y)
end

--由Action驱动的移动事件
function Actor:startMove(tx,ty,IdleOnStopMove)
	self:setShadowTail(true,0.1,2)
	self.model:startMove(self.dir, 
						 self.x, self.y, 
						 tx, ty,
						 IdleOnStopMove)
end





function Actor:stopMove()
	self.model:stopMove(self.x, self.y)
end

-- 结束移动
function Actor:stopMoveAt(x,y)
--	xprint('Actor:stop_move')
	self.model:stopMove(x, y)
end

-- 判断是否已死
function Actor:is_dead(  )
	return (self.hp <= 0)
end

-- 实体死亡
function Actor:die(  )
	-- 暂时只有玩家角色才享有死亡动作
	--self.model:playAction(ZX_ACTION_DIE, self.dir, false)
end

-- 实体释放技能
function Actor:use_skill( skill_id, skill_level, dir, handler )

	-- 根据技能id和等级，获取技能动作
	local action_id, effect_id = SkillConfig:get_spell_action(skill_id, skill_level)
	-- print("Actor skill_id, skill_level,action_id, effect_id",skill_id, skill_level,action_id, effect_id);
	if ( effect_id ~= 0 ) then
		local delay_cb = callback:new();
		local function cb()
			local effect_animation_table = effect_config[effect_id];
			if ( self.model and effect_animation_table) then
				--print("playEffect skill_id",effect_id)
				--self.model:playEffect( effect_animation_table[1],effect_id, 2, effect_animation_table[3],nil,dir,0,500,effect_animation_table[2]);
				if handler ~= nil then
					local player = EntityManager:get_player_avatar()
					if handler == player.handle then
						self:playEffectAt(effect_animation_table)
					end
				else
					self:playEffectAt(effect_animation_table)
				end

			end
		end
		delay_cb:start(0.2,cb);
	end
	if ( action_id > -1 ) then
		self:playAction(action_id, dir)
	end
end


function Actor:playEffectAt(effect_animation_table)
	local model  = self.model
	print("%%%%%%%%%%%%%%##playEffectAt self.dir,effect_animation_table.x_stept,effect_animation_table.y_stept",
		self.dir,effect_animation_table.x_stept,effect_animation_table.y_stept)
	local temp_x_stept = 0
	local temp_y_stept = 0
	if effect_animation_table.x_stept then
		temp_x_stept = effect_animation_table.x_stept
	end
	if effect_animation_table.y_stept then
		temp_y_stept = effect_animation_table.y_stept
	end
	EffectBuilder:playMapLayerEffect(effect_animation_table,
									 model.m_x + temp_x_stept, 
									 model.m_y + temp_y_stept,
									 2,
									 -1,
									 self.dir)
end

function Actor:playAction(action_id, dir, loop)
	loop = loop or false
	self.model:playAction(action_id, dir, loop)
	self.dir = dir
	self.last_action_id = action_id
end

--------------------------------------------
--
--		以下代码与buff相关
--
--------------------------------------------
-- 添加一个buff
function Actor:add_buff( buff )
	-- print("Actor:add_buff( buff )")
	-- 连斩buff屏蔽
	if ( buff.buff_type == 92 ) then
		return;
	end


	if self.buff_dict[buff.buff_type] ~= nil then
		local old_buff = self.buff_dict[buff.buff_type]
		if old_buff.buff_group == buff.buff_group then
			self:remove_buff(old_buff.buff_type, old_buff.buff_group)
		end
	end

	self.buff_dict[buff.buff_type] = buff
	-- print("actor add buff", self, self.buff_dict)
	-- for k,v in pairs(self.buff_dict) do
	-- 	print("k,v",k,v);
	-- end
	-- 玩家和选中角色的buff都要即时更新 
	local win = UIManager:find_window("user_panel");
	if ( win ) then 
		if ( self.type == -1 ) then
			win:add_buff ( 1,buff )
		elseif ( UserPanel:check_is_select_entity( self.handle ) ) then
			win:add_buff ( 2,buff )
		end
	end
end

-- 移除一个buff
function Actor:remove_buff( buff_type, buff_group )
	-- print("Actor:remove_buff....................",buff_type,buff_group)
	local remove_type = nil;
	if ( self.type == -1 ) then
		remove_type = 1;
	elseif UserPanel:check_is_select_entity( self.handle ) then
		remove_type = 2;
	end

	-- 如果buff_type 为空则表示要删除一个组的buff
	if ( buff_type == nil ) then
		for k,v in ipairs(self.buff_dict) do
			if ( v.buff_group == buff_group ) then
				-- TODO:: 这里添加移除一个buff的逻辑
				self:remove_a_buff( remove_type,buff_type )
			end
		end
	-- 删除一个buff
	else
		self:remove_a_buff( remove_type,buff_type, buff_group  )
	end

end

function Actor:remove_a_buff( remove_type,buff_type, buff_group )
--	print("Actor:remove_a_buff....................",remove_type,buff_type)
	if self.buff_dict[buff_type] ~= nil then
		local old_buff = self.buff_dict[buff_type]
	--	print("old_buff.buff_type",old_buff.buff_type)
		self.buff_dict[buff_type] = nil
		-- TODO:: 这里添加移除一个buff的逻辑
		local win = UIManager:find_window("user_panel");
		if ( win ) then 
			win:remove_buff( remove_type,buff_type , buff_group)
		end
	end
end
--------------------------------------------
--
--		以下代码与实体特效相关
--
--------------------------------------------

-- 添加一个特效
function Actor:add_effect( effect_type, effect_id, duration, sender )
	
end


-----------------------------------------------------------
--
--       下面是处理称号的代码
--
-----------------------------------------------------------

local TITLE_START_Y = 18;

-- 添加一个头顶上面的称号
function Actor:add_title( title_index, is_shangma )
	-- local path  = string.format("ui/title/%05d.png", title_index)
	-- local image = CCZXImage:imageWithFile( 0, 0, -1, -1, path )
	-- image:setAnchorPoint(0.5, 0);
	-- self._title_component[title_index] = image
	-- self:update_title(is_shangma)

	local path = nil
	local image = nil
	if title_index < 82 then
		local grade = math.ceil(title_index/9) -1
		local pin = 10 - (title_index-grade*9)

		path  = string.format("ui/lh_title/%d/%05d.png", grade+1, grade+1)
		image = CCZXImage:imageWithFile( 0, 0, -1, -1, path )

		-- title
		path  = string.format("ui/lh_title/%d/title.png", grade+1)
		local image_title = CCZXImage:imageWithFile( 75, 10, -1, -1, path )
		image_title:setScale(1.2)
		image:addChild(image_title)
		-- n品
		path  = string.format("ui/lh_title/%d/%d.png", grade+1, pin)
		local image_pin = CCZXImage:imageWithFile( 77, 22, -1, -1, path )
		image_pin:setScale(1.2)
		image_pin:setAnchorPoint(1, 0.5);
		image:addChild(image_pin)
	else
		path  = string.format("ui/lh_title/10/%05d.png", title_index)
		image = CCZXImage:imageWithFile( 0, 0, -1, -1, path )
	end
	-- local 
	image:setAnchorPoint(0.5, 0);
	self._title_component[title_index] = image
	self:update_title(is_shangma)
end

-- 减少一个头顶上面的称号
function Actor:remove_title( title_index )
	if self._title_component[title_index] then
		self._title_component[title_index]:removeFromParentAndCleanup(true)
		self._title_component[title_index] = nil
	end
	self:update_title()
end

-- 宠物要增加宠物品阶称号
function Actor:add_pet_pj( pj_value )

	if ( self.lab_pj_title ) then
		self.lab_pj_title:removeFromParentAndCleanup(true);
		self.lab_pj_title = nil;
	end

	local wx =  ZXLuaUtils:lowByte(pj_value); --悟性
	local cz =  ZXLuaUtils:highByte(pj_value); --成长
	--print("wx,cz",wx,cz);
	self:update_pet_pj( wx,cz );
end

function Actor:update_pet_pj( wx,cz )
	local pj_name = ""
	if ( wx > 0 ) then
		pj_name = pj_name.. _static_pet_wx_str[wx];
	end 	
	if ( cz > 0 ) then
		pj_name = pj_name.. _static_pet_cz_str[cz];
	end
	if self.lab_pj_title then
		self.lab_pj_title:setText("#cff66cc"..pj_name)
	else
		self.lab_pj_title = MUtils:create_zxfont(self.model:getBillboardNode(),"#cff66cc"..pj_name,0,TITLE_START_Y,2,14);
	end
end

-- 更新头顶称号的位置
function Actor:update_title( is_shangma )
	-- 由于Actor是很多实体的父类(主角、其他玩家、NPC等),
	-- 但是主角的称号需要update的时候,必须要考虑是否在坐骑上
	if self.type == EntityConfig.TYPE_PLAYER_AVATAR then
		is_shangma = MountsModel:get_is_shangma()
	end

	local dy = TITLE_START_Y		-- 从18像素开始往上排称号 名字的16号字

	if ( self.lab_pj_title ) then
		dy = dy + TITLE_START_Y;
	end

	if is_shangma then
		dy = dy + 30
	end

	-- 这里要排序
	local key_list = {}
	for k,component in pairs(self._title_component) do
		table.insert(key_list, k)
	end

	table.sort(key_list)

	for i,key in ipairs(key_list) do
		local component = self._title_component[key]
		if component:getParent() == nil then
			self.model:getBillboardNode():addChild(component)
		end
		component:setPosition(0, dy)
		dy = dy + component:getSize().height
		component:setIsVisible(self._if_show_title)
	end
	
end

-- 设置是否显示称号
function Actor:set_if_show_title( if_show )
	self._if_show_title = if_show
	self:update_title(  )
end

-----------------------------------------------------------

function Actor:setBody(path)
	if self.model then
		self.body_path = path
		self.model:changeBody(path)
	end
end

local _canStruck = EntityActionConfig.canStruck
local _isStrucking = EntityActionConfig.isStruck
local _createStruck = effectCreator.createStruck
function Actor:doStruck(attacker)
	
	local self_model = self.model
	local action_id = self_model:get_curr_action_type()
	if attacker then
		local attacker_model = attacker.model
		--
		local dx = math.floor(self_model.m_x - attacker_model.m_x)
		if dx > 0 then
			self_model:runAction(_createStruck(0.06,CCPointMake(_doStruckDis,0),0.06,CCPointMake(-_doStruckDis,0)))
		else
			self_model:runAction(_createStruck(0.06,CCPointMake(-_doStruckDis,0),0.06,CCPointMake(_doStruckDis,0)))
		end
		
		if _canStruck(action_id) then
			local rand = math.random(0,2)
			if rand == 0 then
				self_model:playAction(ZX_ACTION_STRUCK,self.dir,false)
			else
				self_model:playAction(ZX_ACTION_STRUCK_2,self.dir,false)
			end
		else
			--self:doHighlight()
		end
	else
		if _canStruck(action_id) then
			local rand = math.random(0,2)
			if rand == 0 then
				self_model:playAction(ZX_ACTION_STRUCK,self.dir,false)
			else
				self_model:playAction(ZX_ACTION_STRUCK_2,self.dir,false)
			end
		end
	end
	self:doHighlight(0.2)
	self_model:runAction(effectCreator.createScaleInOut(0.05,_doStruckScale,0.08,1.0))
	--end
end

function Actor:doHighlightStruck()
	local self_model = self.model
	if self.dir >= 6 then
		self_model:runAction(_createStruck(0.06,CCPointMake(_doStruckDis,0),0.06,CCPointMake(-_doStruckDis,0)))
	else
		self_model:runAction(_createStruck(0.06,CCPointMake(-_doStruckDis,0),0.06,CCPointMake(_doStruckDis,0)))
	end
	self:doHighlight()
	--self_model:runAction(effectCreator.createScaleInOut(0.05,_doStruckScale,0.08,1.0))
end

function Actor:doHighlight(dur)
	dur = dur or 0.75
	--print('?>?????????????????')
	if not self._highlight_init then
		self.model:setHighlightColor(0,0,0)
		self._highlight_init = true
	end
	self.model:setHighlight(true,dur)
end

function Actor:setShadowTail(flag, time_tick, fade_time)
	if self._is_shadow_tail == flag then
		return
	end
	time_tick = time_tick or SHADOW_CREATE_TIME
	fade_time = fade_time or SHADOW_FADEOUT_TIME
	self._shadow_tail_timer:stop()
	if flag then
		self._shadow_tail_timer:start(time_tick, function()
			local spr = self.model:get_body():createCurrentFrame( true )
			if spr then
				SceneManager.SceneNode:addChild(spr)
				spr:setColor(SHADOW_TAIL_COLOR)
				spr:runAction(effectCreator.createFadeoutRemove(fade_time))
			end
		end)
	end
	self._is_shadow_tail = flag
end


function Actor:setShadowTailEase(flag, time_tick, fade_time)
	if self._is_shadow_tail == flag then
		return
	end
	time_tick = time_tick or SHADOW_CREATE_TIME
	fade_time = fade_time or SHADOW_FADEOUT_TIME
	self._shadow_tail_timer:stop()
	if flag then
		self._shadow_tail_timer:start(time_tick, function()
			local spr = self.model:get_body():createCurrentFrame( true )
			SceneManager.SceneNode:addChild(spr)
			spr:setColor(SHADOW_TAIL_COLOR)
			spr:runAction(effectCreator.createEaseInFadeoutRemove(fade_time,SHADOW_FADEOUT_EASEIN))
		end)
	end
	self._is_shadow_tail = flag
end
