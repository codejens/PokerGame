EffectBuilder = {}

local _cpplogicScene = nil
local _bufferEffectStartID = 100
local _map_effects_Tags = {}

local _FOOT_ZORDER = -1
local _ENTITY_OFFSET_ZORDER = 4
local _EFFECT_ZORDER = 500

--临时变量，由于图片过大，后面记得删除
local _scale = 0;

local function createAnimation( path, speed, time, act_param, beginIndex, stept )
	-- xprint("!!!!!!!!!@@@@@@@run EffectBuilder path,time,beginIndex,stept",path,time,beginIndex,stept)
	local sprite = nil
	if time > 0 then
		--如果有持续时间，无限循环知道超时删除
		sprite = effectCreator.createEffect_animation(path,speed,-1, time / 1000.0)
	else
		beginIndex = beginIndex or -1
		stept = stept or -1
		--播放几次
		sprite = effectCreator.createEffect_animation(path,speed,1, -1, beginIndex, stept)
	end
	return sprite
end

local function createAnimationForever( path, speed, time, act_param )
	local sprite = nil
	sprite = effectCreator.createEffect_animation(path,speed,-1)
	return sprite
end

local function createAnimationFadeOut( path, speed, time, act_param )
	local sprite = nil
	if time > 0 then
		--如果有持续时间，无限循环知道超时删除
		sprite = effectCreator.createEffect_fo(path,speed,-1,act_param[1],time / 1000.0)
	else
		--播放几次
		sprite = effectCreator.createEffect_fo(path,speed,1,act_param[1])
	end
	return sprite
end

function EffectBuilder:init(root)
	_cpplogicScene = root
end


function EffectBuilder.createAnimationInterval(path, frames, times)
	local sprite = nil
	local times = times or 1
	sprite = effectCreator.createEffect_animation(path,frames,times)
	return sprite
end

function EffectBuilder.createAnimation(path, frames, times)
	local sprite = nil
	local times = times or 1
	sprite = effectCreator.createEffect_animation(path,1.0/frames,times)
	return sprite
end

local AnimationEffect_Creators =
{
	[0] = createAnimation,
	[1] = createAnimationFadeOut,
	[2] = createAnimationForever
}


local function createMapAnimationFactory(creator, ani_table,x,y,z,time,dir,tag,times,root)
	local path = ani_table[1]
	local speed = ani_table[2]
	local sprite = nil
	local offset = { 0, 0 } 
	local flip = 1.0
	local layer  = ani_table.layer or 0
	local act_param = ani_table.act_param
	if dir > 4 then
		flip = -1.0
	end
	tag = tag or 0
	z = z or 0
	time = time or -1
	times = times or 1
	if ani_table.offset then
		x = x + ani_table.offset[1] * flip
		y = y + ani_table.offset[2]
	end
	---------------------------
	---HJH 2014-10-24 add begin
	local beginIndex = ani_table.beginIndex
	local stept = ani_table.stept
	local temp_x_stept = 0
	local temp_y_stept = 0
	if ani_table.over_stept then
		if dir == 0 then
			temp_x_stept = ani_table.over_stept[1].x
			temp_y_stept = ani_table.over_stept[1].y
		elseif dir == 1 then
			temp_x_stept = ani_table.over_stept[1].x
			temp_y_stept = ani_table.over_stept[1].y
		elseif dir == 2 then
			temp_x_stept = ani_table.over_stept[2].x
			temp_y_stept = ani_table.over_stept[2].y
		elseif dir == 3 then
			temp_x_stept = ani_table.over_stept[3].x
			temp_y_stept = ani_table.over_stept[3].y
		elseif dir == 4 then
			temp_x_stept = ani_table.over_stept[3].x
			temp_y_stept = ani_table.over_stept[3].y
		elseif dir == 5 then
			temp_x_stept = ani_table.over_stept[3].x * -1
			temp_y_stept = ani_table.over_stept[3].y
		elseif dir == 6 then
			temp_x_stept = ani_table.over_stept[2].x * -1
			temp_y_stept = ani_table.over_stept[2].y 
		elseif dir == 7 then
			temp_x_stept = ani_table.over_stept[1].x * -1
			temp_y_stept = ani_table.over_stept[1].y
		end
	end

	if stept and stept > 0 then
		if dir == 0 then
			beginIndex = stept * 0
		elseif dir == 1 then
			beginIndex = stept * 0
		elseif dir == 2 then
			beginIndex = stept * 1
		elseif dir == 3 then
			beginIndex = stept * 2
		elseif dir == 4 then
			beginIndex = stept * 2
		elseif dir == 5 then
			beginIndex = stept * 2
		elseif dir == 6 then
			beginIndex = stept * 1
		elseif dir == 7 then
			beginIndex = stept * 0
		end
	else
		beginIndex = -1
		stept = -1	
	end	
	---HJH 2014-10-24 add end
	---------------------------
	--// Parameter: const char * effect		特效id
	--// Parameter: float aniTime			动画每帧之间的间隔
	--// Parameter: int times				播放次数 -1 = forever
	--// Parameter: float duration	        如果times == -1 duration > 0 则会在duration完结删除动画
	if beginIndex and beginIndex >= 0 then
		sprite = AnimationEffect_Creators[creator](path, speed, time, act_param, beginIndex, stept)
	else
		sprite = AnimationEffect_Creators[creator](path, speed, time, act_param)
	end

	if ani_table.scale then
		sprite:setScale(ani_table.scale)
	end

	sprite:setFlipX(flip < 0)
	_cpplogicScene:addChildSceneLayer( sprite,
									   layer, 
									   x + temp_x_stept,
									   y + temp_y_stept,
									   z,
									   tag )
end



local function createEntityAnimationFactory(creator, ani_table,x,y,z,time,dir,tag,times,root, src_model, dst_model)
	local path = ani_table[1]
	local speed = ani_table[2]
	local sprite = nil
	local offset = { 0, 0 } 
	local flip = 1.0
	local act_param = ani_table.act_param
	if dir > 4 then
		flip = -1.0
	end
	tag = tag or 0
	z = z or 0
	time = time or -1
	times = times or 1
	if ani_table.offset then
		x = x + ani_table.offset[1] * flip
		y = y + ani_table.offset[2]
	end
	---------------------------
	---HJH 2014-10-24 add begin
	local beginIndex = ani_table.beginIndex
	local stept = ani_table.stept
	local temp_x_stept = 0
	local temp_y_stept = 0

	if ani_table.over_stept then
		if dir == 0 then
			temp_x_stept = ani_table.over_stept[1].x
			temp_y_stept = ani_table.over_stept[1].y
		elseif dir == 1 then
			temp_x_stept = ani_table.over_stept[1].x
			temp_y_stept = ani_table.over_stept[1].y
		elseif dir == 2 then
			temp_x_stept = ani_table.over_stept[2].x
			temp_y_stept = ani_table.over_stept[2].y
		elseif dir == 3 then
			temp_x_stept = ani_table.over_stept[3].x
			temp_y_stept = ani_table.over_stept[3].y
		elseif dir == 4 then
			temp_x_stept = ani_table.over_stept[3].x
			temp_y_stept = ani_table.over_stept[3].y
		elseif dir == 5 then
			temp_x_stept = ani_table.over_stept[3].x * -1
			temp_y_stept = ani_table.over_stept[3].y
		elseif dir == 6 then
			temp_x_stept = ani_table.over_stept[2].x * -1
			temp_y_stept = ani_table.over_stept[2].y 
		elseif dir == 7 then
			temp_x_stept = ani_table.over_stept[1].x * -1
			temp_y_stept = ani_table.over_stept[1].y
		end
	end

	if stept and stept > 0 then
		if dir == 0 then
			beginIndex = stept * 0
		elseif dir == 1 then
			beginIndex = stept * 0
		elseif dir == 2 then
			beginIndex = stept * 1
		elseif dir == 3 then
			beginIndex = stept * 2
		elseif dir == 4 then
			beginIndex = stept * 2
		elseif dir == 5 then
			beginIndex = stept * 2
		elseif dir == 6 then
			beginIndex = stept * 1
		elseif dir == 7 then
			beginIndex = stept * 0
		end
	else
		beginIndex = -1
		stept = -1	
	end
	-- xprint("$$$$$$$$$$EffectBuilder createEntityAnimationFactory beginIndex,stept,path,creator",beginIndex,stept,path,creator)

	if beginIndex and beginIndex >= 0 then
		sprite = AnimationEffect_Creators[creator](path, speed, time, act_param, beginIndex, stept)
	else
		sprite = AnimationEffect_Creators[creator](path, speed, time, act_param)
	end
	---HJH 2014-10-24 add end
	--// Parameter: const char * effect		特效id
	--// Parameter: float aniTime			动画每帧之间的间隔
	--// Parameter: int times				播放次数 -1 = forever
	--// Parameter: float duration	        如果times == -1 duration > 0 则会在duration完结删除动画
	-- sprite = AnimationEffect_Creators[creator](path, speed, time, act_param)
-- print("flip",flip)

	if ani_table.scale then
		sprite:setScale(ani_table.scale)
	end
	
	if root then
		sprite:setPosition(CCPointMake(x,y))
		root:addChild(sprite,z,tag)
		if src_model and dst_model then

			local body_height_scale = ani_table.begin_y_scale or 0.7
			local h = src_model:getBodyHeight()*body_height_scale
			sprite:setPosition(CCPointMake(0, h))
			-- sprite:setAnchorPoint(CCPoint(0.7,0.5))
			local end_x, end_y = dst_model.x-src_model.x, dst_model.y-src_model.y+h


			-- 设置弓箭手特效锚点，弓箭需要缩小，并设置默哀点
			if _scale == 1 then
				-- sprite:setScale(0.5)
				-- sprite:setAnchorPoint( CCPoint(0.7,0.5) )
			else
				sprite:setAnchorPoint( CCPoint(0.3,0.5) )
			end

			-- 获取角度值
			local rad = math.atan2( (dst_model.y-src_model.y), (dst_model.x-src_model.x) )
			local degree = math.deg( rad )
			-- sprite:setPosition(CCPointMake(src_model.x,src_model.y+h))
			sprite:setRotation( -degree )

			-- debug.debug()
			local distance = math.sqrt( end_x*end_x+end_y*end_y)
			local move_to_time = 0.2

			if distance < 25 then
				move_to_time = 0.05
			elseif distance < 50 then
				move_to_time = 0.075
			elseif distance < 100 then
				move_to_time = 0.1
			elseif distance < 150 then
				move_to_time = 0.125
			elseif distance < 200 then
				move_to_time = 0.15 
			end
			if ani_table.move_speed then
				move_to_time = ani_table.move_speed * distance
			end

			if _scale == 1 then
				if ani_table.fly_type then
					-- 弓箭手特殊处理，佩戴飞行类型2(1定为普通类型)
					if ani_table.fly_type == 2 then
						if dir < 4 then
							local y = sprite:getPositionY()
							local new_y = y - 20
							sprite:setPositionY(new_y)
							end_y = end_y - 20
						else
							local y = sprite:getPositionY()
							local new_y = y + 20
							sprite:setPositionY(new_y)
							end_y = end_y + 20
						end
					end
				end
			else
				if distance > 100 then
					if dir == 0 or dir == 7 or dir == 1 then
						end_x = (distance-140)*math.cos(rad)
						end_y = (distance-140)*math.sin(rad)+h
					else
						end_x = (distance-90)*math.cos(rad)
						end_y = (distance-90)*math.sin(rad)+h
					end
					-- print("----------------------x,y:", end_x, end_y)
				end
			end
			local move_to = CCMoveTo:actionWithDuration( move_to_time,CCPoint(end_x,end_y) );
			sprite:runAction(move_to)
		else

		end
	else	
		_cpplogicScene:addChildSceneLayer( sprite,
										   ani_table.layer, 
										   x + temp_x_stept,
										   y + temp_y_stept,
										   z,
										   tag )
		-- if src_model and dst_model then
		-- 	local h = dst_model:getBodyHeight()*0.8
		-- 	local end_x, end_y = dst_model.x, dst_model.y+h
		-- 	-- 获取角度值
		-- 	local rad = math.atan2( (dst_model.y-src_model.y), (dst_model.x-src_model.x) )
		-- 	local degree = math.deg( rad )
		-- 	sprite:setPosition(CCPointMake(src_model.x,src_model.y+h))
		-- 	sprite:setRotation( -degree )
		-- 	-- local action_moveBy = CCMoveTo:actionWithDuration(0.3,CCPoint(end_x,end_y))
		-- 	-- sprite:runAction(action_moveBy)

		-- 	-- debug.debug()
		-- 	local move_to = CCMoveTo:actionWithDuration(0.3,CCPoint(dst_model.x,dst_model.y));
		-- 	sprite:runAction(move_to)
		-- else
			sprite:setFlipX(flip < 0)
		-- end
		return sprite 
	end
end

function EffectBuilder:playMapLayerEffect( ani_table,x,y,z,time,dir,tag,times)
	local creator = ani_table.act_type or 0
	--print('[EffectBuilder:playMapLayerEffect]', ani_table[1])
	ResourceManager.AnimationBackgroudnLoad(ani_table[1], function(_filename)
		if not _filename then
			return
		end
		createMapAnimationFactory(creator, ani_table,x,y,z,time,dir,tag,times)
	end)
end

function EffectBuilder:_showMapLayerEffect( ani_table,x,y,z,time,dir,tag,times)
	local creator = ani_table.act_type or 0
	createMapAnimationFactory(creator, ani_table,x,y,z,time,dir,tag,times)
end

function EffectBuilder:_showEntityEffect( ani_table,x,y,z,time,dir,tag,times,root, src_model, dst_model)
	local creator = ani_table.act_type or 0
	local sprite = createEntityAnimationFactory(creator, ani_table,x,y,z,time,dir,tag,times,root, src_model, dst_model)
	return sprite
end
--无效果=0,挥洒=1,中心爆炸=2,飞行=3,脚下爆炸=4,脚下持续=5,持续=6,
--中心爆炸使用施法者朝向=7
--中心爆炸使用施法者朝向
--[[
SKILL_EFFECT_TYPE_NONE  = 0 
SKILL_EFFECT_TYPE_SLASH = 1
SKILL_EFFECT_TYPE_ONCE = 2
SKILL_EFFECT_TYPE_FLY = 3
SKILL_EFFECT_TYPE_FOOT_ONCE = 4
SKILL_EFFECT_TYPE_FOOT_TIME = 5
SKILL_EFFECT_TYPE_CONSTANT = 6
SKILL_EFFECT_TYPE_ONCE_SRC_DIR = 7
SKILL_EFFECT_TYPE_BE_ATTACKED = 9 普通攻击
]]
function EffectBuilder:playEntityEffect( effect_type, ani_table, time, dst_entity, src_entity, tag)
	_scale = 0
	print("EffectBuilder:playEntityEffect,path",ani_table[1])
 	if effect_type == SKILL_EFFECT_TYPE_NONE then
 		return
 	end

 	if tag == 1705 or tag == 1701 or tag == 7102 then
 		_scale =1
 	end
 	-- xprint('EffectBuilder:playEntityEffect', effect_type,src_entity,dst_entity)
 	-- print("------------------:", effect_type, dst_entity, dst_entity.model)
 	if not dst_entity.model then return end
 	local creator = ani_table.act_type or 0
 	local _model = dst_entity.model
 	local _m_x = _model.m_x
 	local _m_y = _model.m_y
 	local _h = nil
 	if _model.getBodyHeight then
 		_h = _model:getBodyHeight() * -0.5
 	end
 	local _dir = dst_entity.dir

 	if effect_type == SKILL_EFFECT_TYPE_ONCE_SRC_DIR then
 		_dir = src_entity.dir
 	end

 	ResourceManager.AnimationBackgroudnLoad(ani_table[1], function(_filename)
 		-- print("ResourceManager.AnimationBackgroudnLoad,ani_table[1],_filename",ani_table[1],_filename)
 		if not _filename then
 			return
 		end
	 	--挥洒=1,中心爆炸=2 脚下爆炸=4
	 	--
	 	if effect_type == SKILL_EFFECT_TYPE_SLASH or effect_type == SKILL_EFFECT_TYPE_FOOT_ONCE then
	 		
	 		if model then
 				_m_x = _model.m_x
 				_m_y = _model.m_y
 				_dir = dst_entity.dir
		 	end

		 	if tag == 1703 then
		 		self.effect_cbs = {}
			 	local arrow_t = arrow_effect_config
		 		for i=1, 7 do
		 			self.effect_cbs[i] = callback:new()
		 			local function function_effect_cb( )
			 			local spirte = EffectBuilder:_showEntityEffect( ani_table,
						   _m_x+arrow_t[i].x, _m_y + arrow_t[i].y, _h + _EFFECT_ZORDER,
						   time, _dir,
						   0,1)
			 			spirte:setScale(arrow_t[i].scale)
			 			if self.effect_cbs[i] then
			 				self.effect_cbs[i]:cancel()
			 				self.effect_cbs[i] = nil
			 			end
		 			end
		 			self.effect_cbs[i]:start(arrow_t[i].time, function_effect_cb)
		 		end
		 	else
	 			EffectBuilder:_showEntityEffect( ani_table,
	 										   _m_x,_m_y,_EFFECT_ZORDER,
	 										   time,_dir,
	 										   0,1)
	 		end
	 	elseif effect_type == SKILL_EFFECT_TYPE_FLY then
	 		if src_entity ~= nil and src_entity.model ~= nil and dst_entity ~= nil and dst_entity.model ~= nil then
		 		local src_model = src_entity.model
		 		local dst_model = dst_entity.model

		  		_dir = src_entity.dir
		 		if src_model then
			 		_h = src_model:getBodyHeight() * -0.5
	 				_m_x = src_model.m_x
	 				_m_y = src_model.m_y
	 				_dir = src_entity.dir
			 	end
			 	EffectBuilder:_showEntityEffect( ani_table,
		 										   _m_x,_m_y + _h, _h + _EFFECT_ZORDER,
		 										   time, _dir,
		 										   0,1, src_model, src_model, dst_model)
			end
	 	elseif effect_type == SKILL_EFFECT_TYPE_ONCE then
	 		local model = dst_entity.model
	 		if model then
		 		_h = model:getBodyHeight() * -0.5
 				_m_x = _model.m_x
 				_m_y = _model.m_y
 				if src_entity then
 					_dir = src_entity.dir
 				end
		 	end

	 		EffectBuilder:_showEntityEffect( ani_table,
	 										   _m_x, _m_y + _h, _h + _EFFECT_ZORDER,
	 										   time, _dir,
	 										   0,1)

	  	elseif effect_type == SKILL_EFFECT_TYPE_ONCE_SRC_DIR then
	  		local model = src_entity.model
	  		if model then
		 		_h = model:getBodyHeight() * -0.5
 				_m_x = _model.m_x
 				_m_y = _model.m_y
		 	end
	 		EffectBuilder:_showEntityEffect( ani_table,
	 										   _m_x,_m_y + _h, _h + _EFFECT_ZORDER,
	 										   time, _dir,
	 										   0,1)

	 	elseif effect_type == SKILL_EFFECT_TYPE_FOOT_TIME then
	  		local model = dst_entity.model
	  		if model then
		 		EffectBuilder:_showEntityEffect( ani_table,
		 										 0,0,_FOOT_ZORDER,
		 										 time,_dir,
		 										 0,1,model)
	  		end

	 	elseif effect_type == SKILL_EFFECT_TYPE_CONSTANT then
	  		local model = dst_entity.model
	  		if model then
		 		EffectBuilder:_showEntityEffect( ani_table,
		 										 0,0,_EFFECT_ZORDER,
		 										 time,_dir,
		 										 0,1,model)
	  		end

	  	elseif effect_type == SKILL_EFFECT_TYPE_ONCE_FROM_SRC then
	  		local model = src_entity.model
	  		_dir = src_entity.dir
	  		if model then
		 		_h = model:getBodyHeight() * -0.5
 				_m_x = model.m_x
 				_m_y = model.m_y
		 	end
	 		EffectBuilder:_showEntityEffect( ani_table,
	 										   _m_x,_m_y + _h, _h + _EFFECT_ZORDER,
	 										   time, _dir,
	 										   0,1)
	 	elseif effect_type == SKILL_EFFECT_TYPE_BE_ATTACKED then
	 		local model = dst_entity.model 
	 		local target = EntityManager:get_entity(model.target_id)
	 		if target then
		 		if model then
		 			if not model.m_h or model.m_h > 10 then
						_h = model.m_h * -model.effect_h
					else
						_h = -70
					end
	 				_m_x = model.m_x
	 				_m_y = model.m_y
			 	end
			 	EffectBuilder:_showEntityEffect( ani_table,
		 										   _m_x, _m_y + _h, _h + _EFFECT_ZORDER,
		 										   time, 1,
		 										   0,1)
			 end
	 	else
	 		assert(false)
	 	end
	end)
 	if effect_type < _bufferEffectStartID and effect_type ~= 9 then
 		--攻击来自玩家才显示高亮
	 	local player = EntityManager:get_player_avatar()
		if not src_entity or src_entity.handle ~= player.handle then
			return
		end
 		dst_entity:doHighlightStruck(src_entity)
 		--end
 		--EntityManager:doEntityStruck(dst_entity,src_entity)
 	end
	--createEntityAnimationFactory(creator, ani_table,x,y,z,time,dir,tag,times)
end

function EffectBuilder.removeMapEffectByTag(tag)
	local layer = _map_effects_Tags[tag]
	if layer then
		local node = _cpplogicScene:getSceneLayer(layer)
		node:removeChildByTag(tag,true)
		_map_effects_Tags[tag] = nil
	end
end

function EffectBuilder.registerMapEffectByTag(layer, tag)
	_map_effects_Tags[tag] = layer
end

function EffectBuilder.onQuit()
	_map_effects_Tags = {}
end

function EffectBuilder.onEnterScene()
	for k,v in pairs(_map_effects_Tags) do
		EffectBuilder.removeMapEffectByTag(k)
	end
end

--[[
function EffectBuilder:playMapEffect( ani_table,x,y,z,time,tag,times)
	local ccp = CCPoint( x,y );
	ZXGameScene:sharedScene():mapPosToGLPos(ccp)
	local layer = ani_table.act_type or 0
	EffectBuilder:playMapLayerEffect(ani_table,ccp.x,ccp.y,is_forever,z,time,tag,times)
end
]]--

local _bishaji_duation = {}
local _bishaji_timer = {}

local function playBishajiMapLayerEffectDaoke(creator, ani_table,x,y,z,time,dir,tag,times,root)
	-- 这里禁止一下连续播放必杀技动画
	-- if _bishaji_timer[bishaji_config.sword_rain.effect_number] ~= nil then
	if _bishaji_timer[1] ~= nil then
		print("太快了，不播放")
		return
	end
	_bishaji_timer[1] = 1

	local path = ani_table[1]
	local speed = ani_table[2]
	local sprite = nil
	local offset = { 0, 0 } 
	local flip = 1.0
	local layer  = ani_table.layer or 0
	local act_param = ani_table.act_param
	if dir == 6 then
		flip = -1.0
	end
	tag = tag or 0
	z = z or 0
	time = time or -1
	times = times or 1

	for i=1,bishaji_config.sword_rain.effect_number do
		local delay_cb = callback:new();
		local function cb()
			local t_x = bishaji_config.sword_rain.spawn_point[i].x
			local t_y = bishaji_config.sword_rain.spawn_point[i].y
			ani_table.offset = {t_x, t_y, 0}
			t_x = x + ani_table.offset[1]
			t_y = y + ani_table.offset[2]

			--// Parameter: const char * effect		特效id
			--// Parameter: float aniTime			动画每帧之间的间隔
			--// Parameter: int times				播放次数 -1 = forever
			--// Parameter: float duration	        如果times == -1 duration > 0 则会在duration完结删除动画
			sprite = AnimationEffect_Creators[creator](path, speed, time, act_param)
			if bishaji_config.sword_rain.spawn_point[i].is_flip then
				sprite:setFlipX(true)
			end
			sprite:setScale(bishaji_config.sword_rain.spawn_point[i].scale)

			-- 建立父节点，方便做移动动画
			local father = CCNode:node();
			father:addChild(sprite)

			ZXLogicScene:sharedScene():addChildSceneLayer( father,
											   layer, 
											   t_x, t_y ,z,
											   tag )
			-- 移动动画
			_bishaji_duation[i] = 0
			_bishaji_timer[i] = timer()
			local function bishaji_move(t)
				-- 有时候会找不到father，不知道原因，加个判断吧
				if father == nil then
					if _bishaji_timer[i] ~= nil then
						_bishaji_timer[i]:stop()
						_bishaji_timer[i] = nil
					end
					return;
				end

				_bishaji_duation[i] = _bishaji_duation[i] + t
				local fx,fy = father:getPosition()
				fx = fx + bishaji_config.sword_rain.fall_offset[i].x*(t/bishaji_config.sword_rain.fall_offset[i].fall_duation)
				fy = fy + bishaji_config.sword_rain.fall_offset[i].y*(t/bishaji_config.sword_rain.fall_offset[i].fall_duation)
				father:setPosition(fx, fy)
				if _bishaji_duation[i] >= bishaji_config.sword_rain.fall_offset[i].fall_duation then
					_bishaji_timer[i]:stop()
					_bishaji_timer[i] = nil
				end
			end
			_bishaji_timer[i]:start(0,bishaji_move)

			local remove_cb = callback:new()
			local function remove_cb_func()
				father:removeFromParentAndCleanup(true);
				father = nil
			end
			remove_cb:start(0.125*11,remove_cb_func)
		end

		local delay = bishaji_config.sword_rain.spawn_point[i].delay_duation or 0.0
		delay_cb:start(delay,cb);		
	end
end

local function playBishajiMapLayerEffectQiangshi(creator, ani_table,x,y,z,time,dir,tag,times,root)
	-- 这里禁止一下连续播放必杀技动画
	-- if _bishaji_timer[bishaji_config.spear_formation.effect_number] ~= nil then
	-- if _bishaji_timer[1] ~= nil then
	-- 	return
	-- end 

	local path = ani_table[1]
	local speed = ani_table[2]
	local sprite = nil
	local offset = { 0, 0 } 
	local flip = 1.0
	local layer  = ani_table.layer or 0
	local act_param = ani_table.act_param
	if dir == 6 then
		flip = -1.0
	end
	tag = tag or 0
	z = z or 0
	time = time or -1
	times = times or 1

	for i=1,bishaji_config.spear_formation.effect_number do
		local delay_cb = callback:new();
		local function cb()
			local t_x = bishaji_config.spear_formation.spawn_point[i].x
			local t_y = bishaji_config.spear_formation.spawn_point[i].y
			ani_table.offset = {t_x, t_y, 0}
			t_x = x + ani_table.offset[1]
			t_y = y + ani_table.offset[2]

			--// Parameter: const char * effect		特效id
			--// Parameter: float aniTime			动画每帧之间的间隔
			--// Parameter: int times				播放次数 -1 = forever
			--// Parameter: float duration	        如果times == -1 duration > 0 则会在duration完结删除动画
			sprite = AnimationEffect_Creators[creator](path, speed, time, act_param)
			sprite:setScale(bishaji_config.spear_formation.spawn_point[i].scale)

			ZXLogicScene:sharedScene():addChildSceneLayer( sprite,
											   layer, 
											   t_x, t_y ,z,
											   tag )
		end

		local delay = bishaji_config.spear_formation.spawn_point[i].delay_duation or 0.0
		delay_cb:start(delay,cb);		
	end
end

local function playBishajiMapLayerEffectXianru(creator, ani_table,x,y,z,time,dir,tag,times,root)
	-- 这里禁止一下连续播放必杀技动画
	-- if _bishaji_timer[bishaji_config.sword_formation.effect_number] ~= nil then
	-- if _bishaji_timer[1] ~= nil then
	-- 	return
	-- end 

	local path = ani_table[1]
	local speed = ani_table[2]
	local sprite = nil
	local offset = { 0, 0 } 
	local flip = 1.0
	local layer  = ani_table.layer or 0
	local act_param = ani_table.act_param
	if dir == 6 then
		flip = -1.0
	end
	tag = tag or 0
	z = z or 0
	time = time or -1
	times = times or 1

	for i=1,bishaji_config.sword_formation.effect_number do
		local delay_cb = callback:new();
		local function cb()
			local t_x = bishaji_config.sword_formation.spawn_point[i].x
			local t_y = bishaji_config.sword_formation.spawn_point[i].y
			ani_table.offset = {t_x, t_y, 0}
			t_x = x + ani_table.offset[1]
			t_y = y + ani_table.offset[2]

			--// Parameter: const char * effect		特效id
			--// Parameter: float aniTime			动画每帧之间的间隔
			--// Parameter: int times				播放次数 -1 = forever
			--// Parameter: float duration	        如果times == -1 duration > 0 则会在duration完结删除动画
			sprite = AnimationEffect_Creators[creator](path, speed, time, act_param)
			sprite:setScale(bishaji_config.sword_formation.spawn_point[i].scale)

			ZXLogicScene:sharedScene():addChildSceneLayer( sprite,
											   layer, 
											   t_x, t_y ,z,
											   tag )
		end

		local delay = bishaji_config.sword_formation.spawn_point[i].delay_duation or 0.0
		delay_cb:start(delay,cb);		
	end
end

local function playBishajiMapLayerEffectGongshou(creator, ani_table,x,y,z,time,dir,tag,times,root)
	-- 这里禁止一下连续播放必杀技动画
	-- if _bishaji_timer[bishaji_config.archer_wind.effect_number] ~= nil then
	if _bishaji_timer[1] ~= nil then
		print("太快了，不播放")
		return
	end 
	_bishaji_timer[1] = 1

	local path = ani_table[1]
	local speed = ani_table[2]
	local sprite = nil
	local offset = { 0, 0 } 
	local flip = 1.0
	local layer  = ani_table.layer or 0
	local act_param = ani_table.act_param
	if dir == 6 then
		flip = -1.0
	end
	tag = tag or 0
	z = z or 0
	time = time or -1
	times = times or 1

	for i=1,bishaji_config.archer_wind.effect_number do
		local delay_cb = callback:new();
		local function cb()
			local t_x = bishaji_config.archer_wind.spawn_point[i].x
			local t_y = bishaji_config.archer_wind.spawn_point[i].y
			ani_table.offset = {t_x, t_y, 0}
			t_x = x + ani_table.offset[1]
			t_y = y + ani_table.offset[2]

			--// Parameter: const char * effect		特效id
			--// Parameter: float aniTime			动画每帧之间的间隔
			--// Parameter: int times				播放次数 -1 = forever
			--// Parameter: float duration	        如果times == -1 duration > 0 则会在duration完结删除动画
			sprite = AnimationEffect_Creators[creator](path, speed, time, act_param)
			sprite:setScale(bishaji_config.archer_wind.spawn_point[i].scale)

			-- 建立父节点，方便做移动动画
			local father = CCNode:node();
			father:addChild(sprite)

			ZXLogicScene:sharedScene():addChildSceneLayer( father,
											   layer, 
											   t_x, t_y ,z,
											   tag )

			-- 移动动画
			_bishaji_duation[i] = 0
			_bishaji_timer[i] = timer()
			-- 极坐标原点
			local origin_x,origin_y = father:getPosition()
			local function bishaji_animation(t)
				_bishaji_duation[i] = _bishaji_duation[i] + t
				local config = bishaji_config.archer_wind.spawn_point[i];
				-- 先计算阿基米德螺旋的轨迹
				-- 弧度=基础弧度+弧速度*时间
				local radian = config.radian_base + config.radian_speed*_bishaji_duation[i]
				-- 半径 = 弧度*阿基米德系数
				local radius = (radian-config.radian_base) * config.ARC_factor
				-- 极坐标向笛卡尔坐标系转换
				local next_x = origin_x + radius * math.cos(radian)
				local next_y = origin_y + radius * math.sin(radian)
				-- 再来累加直线偏移值
				if config.move_offset_x and config.move_offset_y then
					next_x = next_x + config.move_offset_x*(_bishaji_duation[i]/config.action_duation)
					next_y = next_y + config.move_offset_y*(_bishaji_duation[i]/config.action_duation)
				end
				father:setPosition(next_x, next_y)
				if _bishaji_duation[i] >= config.action_duation then
					_bishaji_timer[i]:stop()
					_bishaji_timer[i] = nil
					father:removeFromParentAndCleanup(true)
					father = nil
				end
			end

			_bishaji_timer[i]:start(0,bishaji_animation)
		end

		local delay = bishaji_config.archer_wind.spawn_point[i].delay_duation or 0.0
		delay_cb:start(delay,cb);		
	end
end

function EffectBuilder:playBishajiMapLayerEffect( ani_table,x,y,z,time,dir,tag,times,effect_type)
	local creator = ani_table.act_type or 0
	ResourceManager.AnimationBackgroudnLoad(ani_table[1], function(_filename)
		if not _filename then
			return
		end
		if effect_type == 33 then
			playBishajiMapLayerEffectDaoke(creator, ani_table,x,y,z,time,dir,tag,times)
		elseif effect_type == 34 then
			playBishajiMapLayerEffectQiangshi(creator, ani_table,x,y,z,time,dir,tag,times)
		elseif effect_type == 35 then
			playBishajiMapLayerEffectGongshou(creator, ani_table,x,y,z,time,dir,tag,times)
		elseif effect_type == 36 then
			playBishajiMapLayerEffectXianru(creator, ani_table,x,y,z,time,dir,tag,times)
		end
	end)
end