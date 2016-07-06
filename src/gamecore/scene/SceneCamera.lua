--SceneCamera.lua
SceneCamera = {}

local __CAMARA_HEART_TIME = 0 -- 心跳间隔
local _CAMARA_SPEED = 10     -- 摄像机速度
--------------------------------------------------
function SceneCamera:init()
	self.logicScene = scene.XLogicScene:sharedScene()
	self.gameScene = scene.XGameScene:sharedScene()

    self._camara_heart_timer = timer:create()     -- 摄像机心跳。定时查看目标位置来移动自己
	--self._sin_zoomer = TimeLerpSin()
	self._lock_entity_timer = timer:create()
	self._look_at =  timer:create()
	self._zoom_lerp =  timer:create()
	self._target = nil
	self.zoom_fator = 1.0

	SceneCamera:lookAt(0,0)
end

-- 加入target
function SceneCamera:add_target( target )
	self._target = target
    local function camara_heart_cb( t )
	    if self._target == nil then 
	        self._camara_heart_timer:stop()
	        return
		end

		local mx,my = self._target:getPosition()
		SceneCamera:lookAt(mx,my)
    end
    self._camara_heart_timer:start( __CAMARA_HEART_TIME, camara_heart_cb )
end

--屏幕抖动
function SceneCamera:play_screen_jitter(  dir,times,range )

	--停止跟着移动
	self._camara_heart_timer:stop()

	local _time = timer:create(  )
	local pass_time = 0
	local x = 1
	local y = 1
	local mx = 1
	local my = 1
	local function time( dt )
		pass_time = pass_time + dt
		if pass_time > times then
			_time:stop()
			--恢复跟着目标移动
			SceneCamera:add_target(self._target)
		end
		x = math.random(-range,range)
		y = math.random(-range,range)
		if dir == 1 then
			x = 0
		elseif dir == 2 then
			y = 0
		end
		mx,my = self._target:getPosition()
		SceneCamera:lookAt(mx+x,my+y)
	end
	_time:start(0.01,time)
end


-- function SceneCamera:zoom(value,dur)
-- 	self._zoom_lerp:stop()
-- 	self._sin_zoomer:stop()
-- 	self:_zoom(value)
-- end

-- function SceneCamera:_zoom(factor)
-- 	local w = GameScreenConfig.viewPort_width * factor
-- 	local h = GameScreenConfig.viewPort_height * factor
-- 	local scale = GameScreenConfig.viewPort_scale / factor
-- 	local player = EntityManager:get_player_avatar()
-- 	if player and player.model then
-- 		local x,y = player.model:getPosition()
-- 		self.logicScene:setViewPortSize(w, h, scale)
-- 		self.logicScene:moveCamera(x, y)
-- 	end
-- 	self.zoom_fator = factor
-- end


-- function SceneCamera:zoomLerp(startValue,endValue,dur)
-- 	if startValue == endValue and startValue == self.zoom_fator then
-- 		return
-- 	end

-- 	if dur then
-- 		self._zoom_lerp:start(0,dur,
-- 		function(t)
-- 			local v = startValue + (endValue - startValue) * t
-- 			self:_zoom(v)
-- 		end)
-- 	else
-- 		self:zoom(value)
-- 	end
-- end

-- function SceneCamera:zoomSin(startValue, zoomOffset, dur)
-- 	self._sin_zoomer:start(0,dur,function(h)
-- 		self:_zoom(startValue + h * zoomOffset)
-- 	end)
-- end

function SceneCamera:fini()
	self._zoom_lerp:stop()
	self._lock_entity_timer:stop()
	-- self._sin_zoomer:stop()
	self._look_at:stop()
	self:_resetZoom()
end

local function _safeLockModel(model, tt)
	local s,e = pcall(function() 
		local mx,my = model:getPosition()
		SceneCamera.logicScene:moveCamera(mx, my) end
	)
	if not s then
		tt:stop()
	end
end

function SceneCamera:lock(model)
	self._look_at:stop()
	self._lock_entity_timer:stop()
	
	self._lock_entity_timer:start(0,bind(_safeLockModel,
										 model,
										 self._lock_entity_timer))
end

function SceneCamera:follow(model,dur)

	self._look_at:stop()
	self._lock_entity_timer:stop()

	local p = self.gameScene:getCameraPositionInPixels()
	self._target = model
	self._look_at:start(0,dur,
		function(t)
			local mx,my = model:getPosition()
			local x = p.x + (mx - p.x) * t
			local y = p.y + (my - p.y) * t
			self.logicScene:moveCamera(x, y)
			if t == 1.0 then
				self:lock(model)
			end
		end)
end


function SceneCamera:lookAtMap(mx,my,dur)
	self._look_at:stop()
	self._lock_entity_timer:stop()

	if not dur then
		self.logicScene:moveCamera(mx, my)
	else
		local p = self.gameScene:cameraMapPosition()
		self._look_at:start(0,dur,
			function(t)
				local x = p.x + (mx - p.x) * t
				local y = p.y + (my - p.y) * t
				self.logicScene:moveCameraMap(x, y)
			end)
	end
end
local lastx = 1
local lasty = 1
--速度不一样导致屏幕抖动，处理下
function SceneCamera:lookAt(mx,my)

	self:lookAtMap(mx,my)
	-- local p = self.gameScene:cameraMapPosition()
	-- local distance = mx-p.x
	-- local speed = (distance) / 20 
	-- --self:lookAtMap(speed+p.x,speed+p.y)
	-- if(mx==lastx and lasty == my ) then
	-- 	return
	-- end
	-- lastx = mx
	-- lasty = my
end

-- function SceneCamera:_resetZoom()
-- 	local w = GameScreenConfig.viewPort_width
-- 	local h = GameScreenConfig.viewPort_height
-- 	local scale = GameScreenConfig.viewPort_scale
-- 	self.logicScene:setViewPortSize(w, h, scale)
-- 	self.zoom_fator = 1.0
-- end