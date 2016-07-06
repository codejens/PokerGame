module(...,package.seeall)
local _AsyncLoadOption = resourceHelper.getAsyncLoadOption
local _priority = ASYNC_PRIORITY.ANIMATION
local script_cb_helpers = helpers.ScriptCallbackHelpers
function test_XCSBNode( view )
  test_XCSBNode0(view)
  test_XCSBNode1(view)
end
--测试XCSBNode节点
function test_XCSBNode0( view )
  -- body
  local node = ccsext.XCSBNode:create()

  local name = 'cocos/animation/slots/body/b0000/Node.csb'
    local option = _AsyncLoadOption(name,name,_priority,function() 
      node:load(name,true)
      --增加C++层面的移除调用
      local timeline = node:getTimeLine()
      node:setCascadeOpacityEnabled(true)
      cocosActionHelper.removeWhenTimelineFinish(timeline,2,5)
      node:play("run",false)
    end)
    node:loadAsync(option,true)
    node:setPosition(960*0.6,640*0.5)
    view:addChild(node)
end

function test_XCSBNode1( view )

	-- body
	local node = ccsext.XCSBNode:create()

	local name = 'cocos/animation/slots/body/b0000/Node.csb'
  	local option = _AsyncLoadOption(name,name,_priority,function() 
  		node:load(name,true)
  		node:play("idle",false)
  		--播放完毕
      --监听帧回调
      cocosEventHelper.setLastFrameCallFunc(node:getTimeLine(),
        function()
          print('called')
          node:setCascadeOpacityEnabled(true)
          node:runAction(cocosActionHelper.delayFadoutRemove( 1.0,  2.0))
        end)
  	end)
  	node:loadAsync(option,true)
  	node:setPosition(960*0.3,640*0.5)
  	view:addChild(node)
end

function startTest(root)
  print('test_XCSBNode')
  test_XCSBNode(root)
end