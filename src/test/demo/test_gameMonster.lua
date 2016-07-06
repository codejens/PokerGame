module(...,package.seeall)
local testGameMonster = {}
local _AsyncLoadOption = resourceHelper.getAsyncLoadOption
local _priority = ASYNC_PRIORITY.ANIMATION
local script_cb_helpers = helpers.ScriptCallbackHelpers

function testGameMonster:init(name)
	local node = ccsext.XCSBNode:create()
    local option = _AsyncLoadOption(name,name,_priority,function() 
      node:load(name,true)
      --增加C++层面的移除调用
      local timeline = node:getTimeLine()
      local root = node:getNode()
      root:setScaleX(-1.0)
      node:setCascadeOpacityEnabled(true)
      node:play("idle",true)
      print('>>>>>>>>>>>>>>>>>>>>>>>!!!!!!')
    end)
    node:loadAsync(option,true)
    self.model = node

end

function testGameMonster:playAction(id, loop)
	self.model:play(id,false)
end

function startTest(view)
	testGameMonster:init('demo/cocos/nodes/monster/0000.csb')
	view:addChild(testGameMonster.model)
	return testGameMonster
end