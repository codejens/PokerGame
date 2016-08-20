Cinema = { }
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local STATE_STOP = 1
local STATE_PLAYING = 2

Cinema.STOP_ACTION  	  = 0
Cinema.LEAVE_SCENE_ACTION = 1
Cinema.QUIT_ACTION  	  = 2

function _createEvent(event)

end

local function _stopCinema()
	print('########_stopCinema')
	Cinema:stop(Cinema.STOP_ACTION, true)
end

function Cinema:init()
	if not self._inited then
		movieActorManager:init()
		self.ui_node = ZXLogicScene:sharedScene():getUINode();
		self.state = STATE_STOP
	end
	self._inited = true
end

function Cinema:play( _id , finishCallback, stopCallFinish)
	if self.state == STATE_PLAYING then
		self:stop(Cinema.STOP_ACTION)
	end

	print('------------------------------------')
	print('Cinema:play',_id)
	local current = movie_config[_id]
	self.state = STATE_PLAYING
	self.act = current
	self.act_id = _id
	self.max_eventGroup = #current
	self.finishCallback = finishCallback
	self:playEventGroup(1)

	-- self.button = ZButton:create(self.ui_node,'nopack/skip.png',_stopCinema,
	-- 						     _refWidth(1.0) - 8,_refHeight(1.0) - 8,-1,-1,Z_CINEMA_UI)
	-- self.button.view:setAnchorPoint(1,1)
	self.stopCallFinish = stopCallFinish
	
	--停掉AI
	--AIManager:set_state(AIConfig.COMMAND_IDLE);
	AIManager:pause()
end


function Cinema:playEventGroup( id )
	if id > self.max_eventGroup then
		if self.finishCallback then
			print('------------------------------------')
			self:finish()
		end
		return
	end
	self.eventGroup_id = id
	local eventGroupData = self.act[self.eventGroup_id] 
	self.eventGroup = movieEventGroup(eventGroupData,self)
	self.eventGroup.act_id = self.act_id
	self.eventGroup.group_id = id
	self.eventGroup:start()
	print('>>Cinema:playEventGroup',id, self.eventGroup ,os.date('%H-%M-%S'))
end

function Cinema:onEventGroupEnd()
	print('>>Cinema:onEventGroupEnd',self.eventGroup_id,os.date('%H-%M-%S'))
	self:playEventGroup(self.eventGroup_id + 1)
	
end

function Cinema:finish()
	movieActorManager:stop()
	self:removeButton()
	if self.eventGroup then
		self.eventGroup:finish()
	end
	self.state = STATE_STOP
	print('self.act_id:', self.act_id)
	if self.act_id ~= 'act39' then
		AIManager:resume()
	end

	ResourceManager:garbage_collection(true)

	self.finishCallback()

	print('Cinema:finish',self.act_id)
	print('------------------------------------')
end

function Cinema:removeButton()
	if self.button then
		self.button.view:removeFromParentAndCleanup(true)
		self.button = nil
		print('Cinema:removeButton')
	end
end

-- is_click 是否为玩家点击跳过, 玩家移动时不可停止
function Cinema:stop(action, is_click)
	action = action or Cinema.STOP_ACTION
	local can_stop = true
	if self.state ~= STATE_STOP then
		if self.eventGroup then
			can_stop = self.eventGroup:stop(action)
			if is_click and not can_stop then return end
		end
		self.eventGroup = nil
		movieActorManager:stop(action)
		movieDialog:stop(action)
		self:removeButton()
		self.state = STATE_STOP

		if action == Cinema.STOP_ACTION and self.stopCallFinish then
			AIManager:resume()
			self.finishCallback()
		end
		ResourceManager:garbage_collection(true)
		print('Cinema:stop',self.act_id,action)
		print('------------------------------------')
	end

	if is_click and not can_stop then return end
	if state ~= Cinema.STOP_ACTION  then
		movieActorManager:onSceneLeave()
	end
end

function Cinema:fini()
	self:stop(Cinema.QUIT_ACTION)
end

function Cinema:OnQuit()
	self:stop(Cinema.QUIT_ACTION)
end

function Cinema:onSceneLeave()
	self:stop(Cinema.LEAVE_SCENE_ACTION)
end