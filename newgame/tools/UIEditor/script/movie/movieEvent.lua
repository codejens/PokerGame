
local _openEvents = {}
local _cameraMoved = false
local _playerMoving = false
local _cppLogicScene = ZXLogicScene:sharedScene()
local _effects_Tags = {}

function printEvent(msg)
	--print(string.format("%s [%s]",msg,))
end
function _spawnActor(data,group)
	local dur = data.dur or 0
	print('dur:', dur)
	local function _spawnFunc()
		--function()  end
		movieActorManager:createActor(data.cast,data,data.clone,data.isSceneActor)
	end 
	group:executeEvent(_spawnFunc, data, 0, data.dir)
	group:executeEvent(function() print('        >>finish Moves',os.date('%H-%M-%S')) end, data, data.delay + dur)
end

function _moveActor(data,group)
	local function _moveFunc()
		-- body
		local actor = movieActorManager:getActor(data.cast)
		if actor then
			print('------------data.cast:', data.cast)
			if data.cast == "player" then
				CommandManager:move( data.pos[1],data.pos[2], true ,nil,actor);
				-- _playerMoving = true
			else
				actor:goto(data.pos[1],data.pos[2],data.speed)
			end
		end
	end
	group:executeEvent(_moveFunc, data, data.delay)
	group:executeEvent(function() print('        >>finish Moves',os.date('%H-%M-%S')) end, data, data.delay + data.dur)
end

function _jumpActor(data,group)
	local function _jumpFunc()
		-- body
		local actor = movieActorManager:getActor(data.cast)
		if actor then
			actor:jumpto(data.pos[1],data.pos[2])
		end
	end
	group:executeEvent(_jumpFunc, data, data.delay)
	group:executeEvent(function() print('        >>finish Jumps',os.date('%H-%M-%S')) end, data, data.delay + data.dur)
end

function _actorTalk(data,group)
	local function _talkFunc()
		local actor = movieActorManager:getActor(data.cast, data.isEntity)
		if actor then
			actor:talk(data.talk,data.dur,data.emote)
		end
	end
	group:executeEvent(_talkFunc, data, data.delay)
	group:executeEvent(function() print('        >>finish Talks',os.date('%H-%M-%S')) end, data, data.delay + data.dur)
end

function _killActor(data,group)
	local function _killFunc()
		movieActorManager:killActor(data.cast,data.style)
	end
	group:executeEvent(_killFunc, data, data.delay)
end

function _showDialog(data,group)
	local dialog_info = movie_dialogs[data.dialog_id]
	group:registerEvent()
	movieDialog:play(dialog_info,function() group:checkEventGroupEnd() end)
end

function _showEffect(data,group)
	local function _effectFunc()
		if data.cast then
			if data.layer then
				local actor = movieActorManager:getActor(data.cast)
				if actor then
					local effect_info = movie_effects[data.effect_id]
					local sp =EffectBuilder.createAnimationInterval( effect_info[1],
														  	 		 effect_info[2],
														  	 		 data.times )
					local root = actor.model:getParent()
					local x,y = actor.model:getPosition()
					local dx = data.dx or 0
					local dy = data.dy or 0
					sp:setPosition(CCPointMake(x+dx,y+dy))
					root:addChild(sp,y)
				end
			else
				local actor = movieActorManager:getActor(data.cast)
				if actor then
					local effect_info = movie_effects[data.effect_id]
					local sp =EffectBuilder.createAnimationInterval( effect_info[1],
														  	 		 effect_info[2],
														  	 		 data.times )
					actor.model:addChild(sp,MOVIE_ACTOR_ZORDER)
				end
			end
		else
			local effect_info = movie_effects[data.effect_id]
			EffectBuilder:playMapLayerEffect( effect_info,
										  	  data.pos[1], data.pos[2], 0, 
										  	  data.time, data.dir,
										  	  data.tag,
										  	  data.times)
			if data.tag then
				EffectBuilder.registerMapEffectByTag(effect_info.layer, data.tag)
			end
		end
	end
	group:executeEvent(_effectFunc, data, data.delay)
end

function _cameraAction(data,group)
	local function _lookAtFunc()
		local cast = data.cast
		local style = data.style
		if data.c_topox then
			local c_topox = data.c_topox
			local player = EntityManager:get_player_avatar()
			SceneCamera:lookAt(c_topox[1], c_topox[2], data.dur)
		elseif style == 'player' then
			local actor = movieActorManager:getActor(cast)
			if actor then
				local model = actor.model
				SceneCamera:lookAt(model.m_x,model.m_y,data.dur)
			end
		else
			local actor = movieActorManager:getActor(cast)
			if actor then
				local model = actor.model
				SceneCamera:follow(model,data.dur)
			end
		end
	end
	group:executeEvent(_lookAtFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _cameraAction',os.date('%H-%M-%S')) 
					   end, data, data.delay + data.dur)

	_cameraMoved = true
end


function _zoomEvent(data,group)
	local function _zoomFunc()
		SceneCamera:zoomLerp(data.sValue, data.eValue, data.dur)
	end
	group:executeEvent(_zoomFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _zoomEvent',os.date('%H-%M-%S')) 
					   end, data, data.delay + data.dur)

end

local function _hideAvatarsFunc()
	EntityManager:hide_all_player_and_pet()
end

local function _showAvatarsFunc()
	EntityManager:show_all_player_and_pet()
end

function _hideAvatars(data,group)

	group:executeEvent(_hideAvatarsFunc, data, 0)
	--[[group:executeEvent(function() 
							
					   end, data, data.delay)
	]]--
	print('        >>finish _hideAvatars',os.date('%H-%M-%S')) 
	_openEvents[_showAvatarsFunc] = '_showAvatarsFunc'
end

function _showAvatars(data,group)
	group:executeEvent(_showAvatarsFunc, data, 0)
	--[[
	group:executeEvent(function() 
							
					   end, data, data.delay) ]]--
	print('        >>finish _showAvatars',os.date('%H-%M-%S')) 
	_openEvents[_showAvatarsFunc] = nil
end


local function _hideOthersFunc()
	EntityManager:hide_others()
end

local function _showOthersFunc()
	EntityManager:show_others()
end

function _hideOthers(data,group)

	group:executeEvent(_hideOthersFunc, data, 0)
	--[[
	group:executeEvent(function() 
							print('        >>finish _hideOthers',os.date('%H-%M-%S')) 
					   end, data, data.delay)
	]]--
	print('        >>finish _hideOthers',os.date('%H-%M-%S')) 
	_openEvents[_showOthersFunc] = '_showOthersFunc'
end

function _showOthers(data,group)
	group:executeEvent(_showOthersFunc, data, 0)
	--[[
	group:executeEvent(function() 
							print('        >>finish _showOthers',os.date('%H-%M-%S')) 
					   end, data, data.delay)
	]]--
	print('        >>finish _showOthers',os.date('%H-%M-%S')) 
	_openEvents[_showOthersFunc] = nil
end


local function _hideAllFunc()
	EntityManager:hide_all()
end

local function _showAllFunc()
	EntityManager:show_all()
end

function _hideAll(data,group)

	group:executeEvent(_hideAllFunc, data, 0)
	--[[
	group:executeEvent(function() 
							print('        >>finish _hide_all',os.date('%H-%M-%S')) 
					   end, data, data.delay)
	]]--
	print('        >>finish _hide_all',os.date('%H-%M-%S')) 
	_openEvents[_showAllFunc] = '_showAllFunc'
end

function _showAll(data,group)

	group:executeEvent(_showAllFunc, data, 0)
	--group:executeEvent(function() 
	---						 
	--				   end, data, data.delay)
	print('        >>finish _show_all',os.date('%H-%M-%S'))
	_openEvents[_showAllFunc] = nil
end


local function _hideUIFunc()
	UIManager:setWindowVisible(false)
end

local function _showUIFunc()
	UIManager:setWindowVisible(true)
end

function _hideUI(data,group)

	group:executeEvent(_hideUIFunc, data, 0)
	--[[group:executeEvent(function() 
							print('        >>finish _hideUI',os.date('%H-%M-%S')) 
					   end, data, 0)]]--
	print('        >>finish _hideUI',os.date('%H-%M-%S'))
	_openEvents[_showUIFunc] = '_showUIFunc'
end

function _showUI(data,group)

	group:executeEvent(_showUIFunc, data, 0)
	--[[
	group:executeEvent(function() 
							print('        >>finish _showUI',os.date('%H-%M-%S')) 
					   end, data, data.delay)
	]]--
	print('        >>finish _showUI',os.date('%H-%M-%S')) 
	_openEvents[_showUIFunc] = nil
end

function _playAction(data,group)
	local function _playActionFunc()
		-- body
		local actor = movieActorManager:getActor(data.cast)
		if actor then
			actor:playAction(data.action_id, data.dir, data.loop)
		else
			print('_playAction failed',data.cast)
		end
	end
	group:executeEvent(_playActionFunc, data, data.delay)
	group:executeEvent(function() print('        >>finish _playAction',os.date('%H-%M-%S')) end, data, data.delay + data.dur)
end

function _screenTextAction(data,group)
	local dialog_info = movie_screen_texts[data.id]
	group:registerEvent()
	movieScreenText:screenText(dialog_info,function() group:checkEventGroupEnd() end)
end

function _hideCast(data,group)
	local function _hideCastFunc()
		local cast = data.cast
		local actor = movieActorManager:getActor(cast, data.isEntity)
		if actor then
			actor:setIsVisible(false)
		end
	end

	group:executeEvent(_hideCast, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _hideCast',os.date('%H-%M-%S')) 
					   end, data, data.delay)
end

function _showCast(data,group)

	local function _showCastFunc()
		local cast = data.cast
		local actor = movieActorManager:getActor(cast, data.isEntity)
		if actor then
			actor:setIsVisible(true)
		end
	end

	group:executeEvent(_showCastFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _showCast',os.date('%H-%M-%S')) 
					   end, data, data.delay)
end

function _enableClick(data,group)
	local function _enableClickFunc()
		SceneManager:enableClicking(true)
	end

	group:executeEvent(_enableClickFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _enableClick',os.date('%H-%M-%S')) 
					   end, data, data.delay)
end


function _disbleClick(data,group)
	local function _disbleClickFunc()
		SceneManager:enableClicking(false)
	end
	group:executeEvent(_disbleClickFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _disbleClickFunc',os.date('%H-%M-%S')) 
					   end, data, data.delay)
end

function _removeEffect(data,group)
	local function _removeEffectFunc()
		EffectBuilder.removeMapEffectByTag(data.tag)
	end
	group:executeEvent(_removeEffectFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _removeEffect',os.date('%H-%M-%S')) 
					   end, data, data.delay)
end

function _flowerEffect(data, group)
	local function _flowerEffectFunc()
		FlowerEffect:play(data.count)
	end
	group:executeEvent(_flowerEffectFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _flowerEffectFunc',os.date('%H-%M-%S')) 
					   end, data, data.delay)
end

function _shakeEffect(data, group)
	local function _shakeEffectFunc()
		local player = EntityManager:get_player_avatar();
		local root = ZXLogicScene:sharedScene()
		local x = math.random(-4,4);
	    local y = 0;
	    local z = 0;
	    local timer = timer();
	    local index = 0;
	    local function cb()
	        z = math.random(1,data.rate);
	        if ( z== 1 ) then 
	            x = math.random(-data.radius,data.radius);
	            y = math.random(-data.radius,data.radius);
	           -- print("x,y = ",x,y);
	            root:moveCameraMap(player.x + x, player.y + y);
	        end
	        index = index + 1;
	        if ( index == data.index ) then 
	            timer:stop();
	        end
	    end
	    timer:start(0.01,cb);
	end
	group:executeEvent(_shakeEffectFunc, data, data.delay)
	group:executeEvent(function() 
							print('        >>finish _flowerEffectFunc',os.date('%H-%M-%S')) 
					   end, data, data.delay + data.dur)
end

function _playSkill( data, group )
	local effect_tab = {[1] = { 1601, 1603, 1602, 1604},
	                    [2] = { 1101, 1103, 1102, 1104},
	                    [3] = { 1701, 1703, 1702, 1704},
	                    [4] = { 2501, 2503, 2502, 2504}}
	local function _playSkillFunc()
		if data.cast then
			local player	= EntityManager:get_player_avatar()
			local job 		= player.job
			local skill 	= data.skill
			local effect_id = effect_tab[job][skill]
			local actor = movieActorManager:getActor(data.cast)
			local dis_tab = {
					[1704] = {x = 0, y = 20},
					[2503] = {x = -20, y = 60},
				}
			if actor then
				local effect_info = movie_effects[effect_id]
				local effect_animation_table = effect_config[effect_id]
				local temp_x_stept = 0
				local temp_y_stept = 0
				if dis_tab[effect_id] then
					temp_x_stept = dis_tab[effect_id].x
					temp_y_stept = dis_tab[effect_id].y
				end
				local sp =EffectBuilder.createAnimationInterval( effect_info[1],
													  	 		 effect_info[2],
													  	 		 data.times )
				if temp_x_stept or 0 and temp_x_stept ~= 0 then
					sp:setPosition(CCPointMake(temp_x_stept,temp_y_stept))
				end
				actor.model:addChild(sp,MOVIE_ACTOR_ZORDER)
			end
		end
	end
	group:executeEvent(_playSkillFunc, data, data.delay)
end

function _FlowText(data, group)
	local function _FlowTextFunc( )
		if data.cast then
			local actor = movieActorManager:getActor(data.cast)
			if actor then
				TextEffect:FlowText(actor.model, data.yOffset, data.prefix,data.colortype, tostring(data.numbermessage), data.isHeal)
			end
		end
	end

	group:executeEvent(_FlowTextFunc, data, data.delay)
end

local _eventCreator = 
{
	['spawn']  = _spawnActor,
	['move']   = _moveActor,
	['talk']   = _actorTalk,
	['kill']   = _killActor,
	['dialog'] = _showDialog,
	['effect'] = _showEffect,
	['jump']   = _jumpActor,
	['camera'] = _cameraAction,
	['zoom']   = _zoomEvent,
	['hideAvatars'] = _hideAvatars,
	['showAvatars'] = _showAvatars,
	['hideOthers'] = _hideOthers,
	['showOthers'] = _showOthers,
	['hideAll'] = _hideAll,
	['showAll'] = _showAll,
	['hideUI'] = _hideUI,
	['showUI'] = _showUI,
	['playAction'] = _playAction,
	['screenText'] = _screenTextAction,
	['hideCast'] = _hideCast,
	['showCast'] = _showCast,
	['disableSceneClicks'] = _disbleClick,
	['removeEffect'] = _removeEffect,
	['flower']       = _flowerEffect,
	['shake']	= _shakeEffect,
	['playSkill'] = _playSkill,
	['FlowText'] = _FlowText,
}

movieEventGroup = simple_class()

function movieEventGroup:__init( eventGroupData, manager )
	self.manager = manager
	self.callbacks = {}
	self.callback_count = 0
	self.eventGroupData = eventGroupData
end


function movieEventGroup:start()
	local eventGroupData = self.eventGroupData
	for k, eventData in ipairs(eventGroupData) do
		_eventCreator[eventData.event](eventData,self)
	end
	if self.callback_count == 0 then
		self:_onEventGroupEnd()
	end
end
function movieEventGroup:executeEvent(func, data, delay) 
	delay = delay or 0
	if delay <= 0 then
		_playerMoving = (data.event == 'move')
		func()
		print('    >>',self.act_id, data.event,data.cast,os.date('%H-%M-%S'))
		return 
	end
	local cb = callback:new()
	cb:start(delay, function()
						_playerMoving = (data.event == 'move')
						func()
						print('    >>',self.act_id, data.event,data.cast,os.date('%H-%M-%S'))
						self.callbacks[cb] = nil
						self:checkEventGroupEnd()
					end)
	self.callbacks[cb] = true
	self.callback_count = self.callback_count + 1
end

function movieEventGroup:_onEventGroupEnd()
	self.manager:onEventGroupEnd()
end

function movieEventGroup:registerEvent()
	self.callback_count = self.callback_count + 1
end

function movieEventGroup:checkEventGroupEnd( ... )
	self.callback_count = self.callback_count - 1
	if self.callback_count == 0 then
		self:_onEventGroupEnd()
	end
end

function movieEventGroup:onEventGroupEnd()
	self._onEventGroupEnd()
	self:restore()
end

--[[
Cinema.STOP_ACTION  	  = 0
Cinema.LEAVE_SCENE_ACTION = 1
Cinema.QUIT_ACTION  	  = 2
]]--
function movieEventGroup:stop(action)
	if _playerMoving and action == Cinema.STOP_ACTION then return false end
	for cb, v in pairs(self.callbacks) do
		cb:cancel()
	end
	if action == Cinema.STOP_ACTION then
		self:restore(0.25)
		
	elseif action == Cinema.LEAVE_SCENE_ACTION then
		self:restore()
	end
	return true
end

function movieEventGroup:finish()
	self:restore(0.25)
end

function movieEventGroup:restore(delay)
	print('movieEventGroup:restore >',delay,'<')
	EntityManager:restore_show_entity()
	UIManager:setWindowVisible(true)
	if _cameraMoved then
		local player = EntityManager:get_player_avatar()
		if player then
			local model = player.model
			if player then
				SceneCamera:lookAt(model.m_x,model.m_y,delay)
			end
		end
	end
	_cameraMoved = false
	
	SceneCamera:zoom(1.0)

	movieScreenText:stop()

	SceneManager:enableClicking(true)
end

function movieEventGroup.onQuit()
	_effects_Tags = {}
end