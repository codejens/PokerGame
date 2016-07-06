module(...,package.seeall)

local entity = {}
local _scene_root = nil
local _AsyncLoadOption = resourceHelper.getAsyncLoadOption
local _priority = ASYNC_PRIORITY.ANIMATION
local _SIZE = FILE_FORMAT.FRAME_ANIMATION_SIZE * 0.5

function entity:init()

	--创建配件
	local weapon = ccsext.XSlotHolderSprite:create()
	local wing = ccsext.XSlotSprite:create()
	local body = ccsext.XSlotAnimateSprite:create()
	local effect = ccsext.XAnimateSprite:create()
	--创建根节点
	local root = cc.Node:create()

	--local Sprite = cc.Sprite
	--local sp = Sprite:create('Star.png')
	--root:addChild(sp)

	root:setPosition(960/2,640/2)

	
	--设置配件 
	weapon:setSlotType('weapon')
	wing:setSlotType('wing')
	
	--放到场景上
	root:addChild(wing,9)
	root:addChild(body,10)
	root:addChild(weapon,11)

	effect:setPosition(_SIZE,_SIZE)
    weapon:addChild(effect)

	self.root = root
	self.weapon = weapon
	self.wing = wing
	self.body = body
	self.effect = effect
end

function entity:loadBody(name)
	
	local body = self.body
	--读取身体和配件的绑定设置
	body:loadSlotFrameConfig(name .. '.json')
	--绑定节点
	body:attachSlot('weapon',self.weapon)
	body:attachSlot('wing',self.wing)

	local option = _AsyncLoadOption(name,name,_priority,bind(self._loadBody,self))
	body:loadAnimationAsync(option)

	--self.async_load['body'] = _loadAnimationAsync(name,name,0, )

end

function entity:_loadBody(ret,customID)	
	--设置身体动作
    local _json = [[
    {
      "actions": {
          "0": {
              "restoreOriginalFrame" : false,
              "loop" : 1,
              "delay" : 0.1,
              "frames": { "start": 0, "end": 7 }
          },
          "1": {
              "restoreOriginalFrame" : false,
              "loop" : 1,
              "delay" : 0.1,
              "frames": { "start": 8, "end": 13 }
          },
          "2": {
              "restoreOriginalFrame" : false,
              "loop" : 1,
              "delay" : 0.1,
              "frames": { "start": 14, "end": 29 }
          }
      }
    }
    ]]

    --监听动作
    cocosEventHelper.listenFrameEvent(self.body,
    function(id, event) 
    	if id == 2 then
    		local actionID = math.random(0,2)
    		self.body:playAction(actionID,false)
    	end
    end)
    --初始化身体的动作和皮肤
    self.body:initWithActionJson(customID,_json)
    self.body:playAction(0,false)
end

function entity:loadWeapon(name)
	--设置配件皮肤和类型
	local weapon = self.weapon
	local option = _AsyncLoadOption(name,name,_priority,bind(self._loadWeapon,self))
	weapon:loadAnimationAsync(option)

end

function entity:_loadWeapon(ret,customID)
	-- body
	self.weapon:setSkin(customID)
end

function entity:loadWing(name)
	--设置配件皮肤和类型
	local wing = self.wing
	local option = _AsyncLoadOption(name,name,_priority,bind(self._loadWing,self))
	wing:loadAnimationAsync(option)

	--self:cancel_AsyncLoad('wing')

	--self.async_load['wing'] = handle

end

function entity:_loadWing(ret,customID)
	-- body
	self.wing:setSkin(customID)
end



function entity:loadWeaponEffect(name)
	local effect = self.effect
	local option = _AsyncLoadOption(name,name,_priority,bind(self._loadWeaponEffect,self))
	effect:loadAnimationAsync(option)
	--self.async_load['weaponEffect'] = _loadAnimationAsync(name,name,0, bind(self._loadWeaponEffect,self))
end

function entity:_loadWeaponEffect(ret,customID)
	--设置身体动作
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

function entity:cancel_AsyncLoad(key)
	local handle = self.async_load[key]
	if handle then
		self.async_load[key] = nil
		_cancel_Async(handle);
	end
end

function entity:destroy()
	local async_load = self.async_load
	for k,v in pairs(async_load) do 
		resourceHelper.cancel_Async(v)
	end
	self.async_load = nil
end
function test_XSlotAnimateSprite(scene)
	-- 创建
    entity:init()
    entity:loadBody('animations/testing/slot/body')
    entity:loadWeapon('animations/testing/slot/weapon')
    entity:loadWing('animations/testing/slot/wing')
    entity:loadWeaponEffect('animations/testing/slot/effect')

	scene:addChild(entity.root,65535)
	--entity:loadBody()
	if true then
		return
	end
end

function startTest(root)
  test_XSlotAnimateSprite(root)
end