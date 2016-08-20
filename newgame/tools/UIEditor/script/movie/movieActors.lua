movieActor = simple_class()
local JUMPING_LAND_ACTION_T = 0.2     --着地时间
local JUMPTIME_MOD = 2000000
local _delayRemoveAction = effectCreator.createDelayRemove
local _math_max = math.max

local SHADOW_TAIL_COLOR    = ccc3(128,128,255) --残影颜色
local SHADOW_CREATE_TIME   = 0.08			   --残影创建间隔
local SHADOW_FADEOUT_TIME  = 0.25 			   --残影Fadeout时间
local SHADOW_FADEOUT_EASEIN= 4 				   --残影加速

function movieActor:__init(model,dir)
	self.model = model
	self.model:registerScriptHandler(bind(movieActor.onScriptEvent,self))
	self.dir = dir
	self.jumpCallbacks = {}
	self.isJumping = false
	self._shadow_tail_timer = timer() 
	self._is_shadow_tail = false
end

function movieActor:destory(style)
	print(' movieActor:destory')
	if not style then
		self.model:removeShadow()
		self.model:removeFromParentAndCleanup(true)

	elseif style == 'fade' then
		self.model:fadeOut(0.5)
		self.model:removeShadow()
		self.model:runAction(_delayRemoveAction(0.5))
	else
		self.model:removeShadow()
		self.model:removeFromParentAndCleanup(true)
	end

	for i, cb in ipairs(self.jumpCallbacks) do
		cb:cancel()
	end

	self._shadow_tail_timer:stop()
end

function movieActor:relocate(x,y)
	self.model:relocate(x,y)
end

function movieActor:changeBody(path)
	self.model:changeBody(path)
end

function movieActor:idle()
	self.model:playAction(ZX_ACTION_IDLE,self.dir,true)
	self.action_id = ZX_ACTION_IDLE
end

function movieActor:playAction( action_id, dir , loop)
	--print('>>>>>>>>>>>>playAction',action_id,dir,loop)
	self.model:playAction(action_id,dir,loop)
	self.dir = dir
	self.action_id = action_id
end

function movieActor:face_to( target_x, target_y )

	if (self.model.m_x - target_x) > 0 then
		self.dir = 7
	elseif (self.model.m_x - target_x) < 0 then 
		self.dir = 1
	end
end

function movieActor:goto(ex,ey,speed)
	local sx = self.model.m_x
	local sy = self.model.m_y
	self.model:changeMoveSpeed(speed)
	if self.action then
		self.action:stop()
	end
	self.action = movieActorMove(self,sx,sy,ex,ey)
end

function movieActor:jumpto( ex,ey )
	-- body
	self:jump(ex,ey)
end

function movieActor:startMove(ex,ey)
	local sx = self.model.m_x
	local sy = self.model.m_y
	self:face_to(ex,ey)
	--print('>>>>>>>>>',sx,sy,ex,ey)
	self.model:startMove(self.dir,sx,sy,ex,ey,false)
end

function movieActor:moveToNextWayPoint()

end

function movieActor:onScriptEvent(id)
	if id == eOnEntityStopMove then
		if self.action then
			self.action:onMoveStop()
		end
	end
end

function movieActor:talk(msg,delay,emote)
	msg = movieParseDialogText(msg,emote)
	EntityDialog(self.model:getBillboardNode(), msg , delay);
end

function movieActor:onActionEnd()
	self.action = nil
end


function movieActor:_jumpTime(tx,ty)
	local m = self.model
	local dx = tx - m.m_x
	local dy = ty - m.m_y
	local d = dx * dx + dy * dy
	return _math_max(d / JUMPTIME_MOD * JUMPING_ACTION_T,0.25)

end

function movieActor:_onPrepareJump(jump_time,tx,ty)
	-- body
	self.model:playAction(ZX_JUMPING_ID,self.dir,true)
	local p = CCPointMake(tx,ty)
	SceneManager.game_scene:mapPosToGLPos(p)
	local j = CCJumpTo:actionWithDuration(jump_time,p,JUMPING_DEFAULT_HEIGHT,1);
	self.model:runAction(j)

	self:setShadowTail(true,0.03,0.2)
end

function movieActor:_onEndJump()
	self.model:playAction(ZX_JUMP_FINISH_ID,self.dir,false)
	if self.jumpLandingAction then
		 self.jumpLandingAction()
	end
	self.jumpLandingAction = nil
	self:setShadowTail(false)
end

		--
function movieActor:jump(tx,ty,action)
	local m = self.model

	for i, cb in ipairs(self.jumpCallbacks) do
		cb:cancel()
	end

	--self:face_to(tx,ty)

	local jump_time = self:_jumpTime(tx,ty)

	-- 停止移动,准备瞬间移动
	self.dir = self.model:prepareTeleport(tx,ty)

	self.isJumping = true
	self.model:playAction(ZX_JUMP_PREPARE_ID,self.dir)

	local cb1 = callback:new()
	local cb2 = callback:new()

	cb1:start(JUMP_PREPARE_ACTION_T, function()
		self:_onPrepareJump(jump_time,tx,ty)
	end)

	cb2:start(jump_time + JUMPING_LAND_ACTION_T, function()
		self:_onEndJump()
	end)

	self.jumpCallbacks = { cb1, cb2 }

	self.jumpLandingAction  = action
end

function movieActor:setShadowTail(flag, time_tick, fade_time)
	if self._is_shadow_tail == flag then
		return
	end

	self._shadow_tail_timer:stop()
	if flag then
		time_tick = time_tick or SHADOW_CREATE_TIME
		fade_time = fade_time or SHADOW_FADEOUT_TIME
		self._shadow_tail_timer:start(time_tick, function()
			local spr = self.model:get_body():createCurrentFrame( true )
			SceneManager.SceneNode:addChild(spr)
			spr:setColor(SHADOW_TAIL_COLOR)
			spr:runAction(effectCreator.createFadeoutRemove(fade_time))
		end)
	end
	self._is_shadow_tail = flag
end


function movieActor:setShadowTailEase(flag, time_tick, fade_time)
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


function movieActor:setIsVisible(state)
	local model = self.model
	model:setIsVisible(state)
	model:showShadow(state)
end