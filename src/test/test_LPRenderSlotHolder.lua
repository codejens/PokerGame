module(...,package.seeall)
local entity = {}
local _scene_root = nil
local _AsyncLoadOption = resourceHelper.getAsyncLoadOption
local _priority = ASYNC_PRIORITY.ANIMATION
local _SIZE = FILE_FORMAT.FRAME_ANIMATION_SIZE * 0.5

function entity:init()
	local model = ccsext.LPRenderSlotHolder:create()
	self.model = model
	self.root = ccsext.XEntityNode:create()
	self.root:addChild(model)

	self._loadHandler = {}
	self.fabao = ccsext.XAnimateSprite:create()
	self.root:addChild(self.fabao)

    --监听动作
    --[[
    --动画帧事件监听枚举
XAnimateEvent = 
{
	eFrameStart = 0,
	eFrameEvent = 1,
	eFrameEnd   = 2
};
]]
    cocosEventHelper.listenFrameEvent(model,
    function(id, event) 
    	if id == 2 then
    		local actionID = math.random(0,2)
    		self.model:playAction(actionID,false)
    	end
    end)

--[[
XActionNodeEvent = 
{
	eEntityMoveEnd = 0
}
]]
	self._moveflag = true
	cocosEventHelper.listenActionNodeEvent(self.root, 
	function(id)
		if id == 0 then
			if self._moveflag then 
				self.root:moveTo(100,640/2,64)
				self.fabao:moveTo({ x = 64, y = 64, time = 1.0})
			else
				self.root:moveTo(960-100,640/2,64)
				self.fabao:moveTo({ x = 64, y = 64, time = 1.0})
			end
			self._moveflag = not self._moveflag
		end
	end)


	local function _onBodyLoad(res,slotname,skinname)
		print(res,slotname,skinname)
		if res == 0 then
			model:playAction(0,false)
		else
			--TODO FAILED reload
		end
	end

	local function _onSlotLoad(res,slotname,skinname)
		if res == 0 then
		else
			--TODO FAILED reload
		end
	end

	local function _onWeaponLoad(res,slotname,skinname)
		if res == 0 then
			local slot = model:getSlot(slotname)
			--self.effect:setRelativePosition(0.5,0.5)
		else
			--TODO FAILED reload
		end
	end
	
	self._loadHandler['body'] = _onBodyLoad
	self._loadHandler['wing'] = _onSlotLoad
	self._loadHandler['weapon'] = _onWeaponLoad
	self._loadHandler['shoulder'] = _onSlotLoad

	local effect = ccsext.XAnimateSprite:create()
	--输出源头图片大小,1024x1024
	effect:setPosition(_SIZE,_SIZE)

	self.effect = effect
	local w = model:getSlot('weapon')
	w:addChild(effect)


end

function entity:onPartLoad(res, slotname, skinname)
	self._loadHandler[slotname](res,slotname,skinname)

end

function entity:loadBody(skinname,action)
	local option = _AsyncLoadOption(skinname,'body',_priority,bind(entity.onPartLoad,self))
	local frameConfig =  skinname .. '.json'
	self.model:loadBodyAsync(action,
							 frameConfig,
							 option)
end

function entity:loadFabao(path)
	-- body
	local function onFabaoLoad(res, customID, skinname)
		if res == 0 then
			local _json = [[
		    {
		      "actions": {
		          "0": {
		              "restoreOriginalFrame" : false,
		              "loop" : 1,
		              "delay" : 0.1,
		              "frames": { "start": 0, "end": 16 }
		          },

		          "9": {
		              "restoreOriginalFrame" : false,
		              "loop" : 1,
		              "delay" : 0.1,
		              "frames": { "start": 4, "end": 5 }
		          }
		      }
		    }
		    ]]
		    --初始化身体的动作和皮肤
		    self.fabao:initWithActionJson(customID,_json)
		    self.fabao:playAction(0,true)
		end
	end
	local option = _AsyncLoadOption(path,path,0,onFabaoLoad)
	self.fabao:loadAnimationAsync(option)
end

function entity:loadSlot(slotname, skin)
	
    local option = _AsyncLoadOption(skin,slotname,_priority,bind(entity.onPartLoad,self))
    entity.model:loadSlotAsync(slotname,option)
end

function entity:loadWeaponEffect(path)

	local function onEffectLoad(res, customID, skinname)
		if res == 0 then
			local _json = [[
		    {
		      "actions": {
		          "0": {
		              "restoreOriginalFrame" : false,
		              "loop" : 1,
		              "delay" : 0.1,
		              "frames": { "start": 0, "end": 3 }
		          },

		          "9": {
		              "restoreOriginalFrame" : false,
		              "loop" : 1,
		              "delay" : 0.1,
		              "frames": { "start": 4, "end": 5 }
		          }
		      }
		    }
		    ]]
		    --初始化身体的动作和皮肤
		    self.effect:initWithActionJson(customID,_json)
		end
	end

	local option = _AsyncLoadOption(path,path,_priority,onEffectLoad)

	self.effect:loadAnimationAsync(option)
end


function entity:testMove()
	self.root:setPosition(960/2,640/2)
	self.root:moveTo(960-100,640/2,64)
end

function test_LPRenderSlotHolder(scene)
	-- 创建
	entity:init()

	local root = entity.root
	local model = entity.model

    entity:loadBody('animations/testing/slot/body','animations/testing/slot/action.json')
    entity:loadSlot('weapon','animations/testing/slot/weapon')
    entity:loadSlot('wing','animations/testing/slot/wing')
    entity:loadWeaponEffect('animations/testing/slot/effect')
    entity:loadFabao('animations/test')
    entity:testMove();
    --

	--self.effect:initWithActionJson(customID,_json,-1,false)
	--model:setPosition(960/2,640/2)
	scene:addChild(entity.root,65535)

end

function startTest(root)
  test_LPRenderSlotHolder(root)
end