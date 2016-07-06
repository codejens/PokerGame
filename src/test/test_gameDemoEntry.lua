module(...,package.seeall)
local _AsyncLoadOption = resourceHelper.getAsyncLoadOption
local _priority = ASYNC_PRIORITY.ANIMATION
local script_cb_helpers = helpers.ScriptCallbackHelpers

local testGameAvatar = nil
local testGameMonster = nil
local window = nil
local playerActionMap = 
{

	idle0 		= 400, idle1 		= 300, idle2 		= 200,
	run0  		= 401, run1  		= 301, run2  		= 201,
	die0  		= 402, die1  		= 302, die2  		= 202,
	attack1_0  	= 403, attack1_1  	= 303, attack1_2  	= 203,
	attack2_0  	= 404, attack2_1  	= 304, attack2_2  	= 204,
	attack3_0  	= 405, attack3_1  	= 305, attack3_2  	= 205,
	rideIdle0  	= 406, rideIdle1  	= 306, rideIdle2  	= 206,
	ride0  		= 407, ride1  		= 307, ride2  		= 207,
	sit			= 506
}

local monsterActionMap = 
{

	idle0 		= 'idle',
	run0  		= 'run',
	attack1_0  	= 'attack1',
	attack2_0  	= 'attack2',
}

function bindPlayerAction(window)
	for k,v in pairs(playerActionMap) do
		window:addClickEventListener(k,
		function()
			testGameAvatar:playAction(v,false)
		end)
		local v = window:findWidgetByName(k)
		v:setVisible(true)
	end
end

function bindMonsterAction(window)
	for k,v in pairs(playerActionMap) do
		local v = window:findWidgetByName(k)
		v:setVisible(false)
	end

	for k,v in pairs(monsterActionMap) do
		window:addClickEventListener(k,
		function()
			testGameMonster:playAction(v,false)
		end)
		local v = window:findWidgetByName(k)
		v:setVisible(true)
	end
end

--测试XCSBNode节点
function test_XCSBNode0( view, file, once , window)
  -- body
  local node = ccsext.XCSBNode:create()

  local name = file
    local option = _AsyncLoadOption(name,name,_priority,function() 
      node:load(name,true)
      --增加C++层面的移除调用
      local timeline = node:getTimeLine()
      node:setCascadeOpacityEnabled(true)
      	if once then
	      	cocosActionHelper.removeWhenTimelineFinish(timeline,0,0)
	      	node:gotoFrameAndPlay(0,false)
	  	else
	  		local action = cocosActionHelper.delayFadoutRemove(5.0,1.0)
	  		node:gotoFrameAndPlay(0,true)
	  		node:runAction(action)
	   	end
	   	local nl = helpers.NodeHelpers
	    local msg =nl:getUserObject(node:getNode()) 
	    if msg then
	      	window:findWidgetByName('desc'):setString(msg)
	    end


      	script_cb_helpers.setFrameEventCallFunc(timeline,
        function(frame)
        	local event = frame:getEvent()
        	testGameAvatar:playAction(402,false)
        end)

    end)
    node:loadAsync(option,true)
    view:addChild(node)
end

function test_gameDemoEntry(view)
	require 'test.demo.test_gameDemotestGameAvatar'
	require 'test.demo.test_gameMonster'
	local ret = resourceHelper.loadCSB('demo/cocos/testUI.csb',false,nil)
	local node = ret:getNode()
	view:addChild(node)
	local p_root = node:getChildByName('playerRoot')
	local m_root = node:getChildByName('monsterRoot')
	local e_root = node:getChildByName('effectRoot')
	testGameAvatar =  test.demo.test_gameDemotestGameAvatar.startTest(p_root)
	testGameMonster = test.demo.test_gameMonster.startTest(m_root)
	--test_XCSBNode0(e_root)

	local window = GUIWindow(node)

	local scroll = window:findWidgetByName('actionScroll')
	scroll:setVisible(false)
	local function on_click_event( sender,eventType )
	  	local v = not scroll:isVisible()
	  	scroll:setVisible(v)
	  	bindPlayerAction(window)
	end
	window:addClickEventListener('playPlayerAction',on_click_event)

	local function on_click_event( sender,eventType )
	  	local v = not scroll:isVisible()
	  	scroll:setVisible(v)
	  	bindMonsterAction(window)
	end
	window:addClickEventListener('playMonsterAction',on_click_event)




	local function on_click_event( sender,eventType )
		local s = window:findWidgetByName('playEffectEdit')
		local n = s:getString()
		local s = string.format('demo/cocos/nodes/effects/skill/000%d.csb',tonumber(n))
		local f = cc.FileUtils:getInstance():isFileExist(s)
		if f then
			test_XCSBNode0(e_root,s,true,window)
		else
			print('file not found',s)
		end
	end
	window:addClickEventListener('playEffect',on_click_event)


	local function on_click_event( sender,eventType )
		local s = window:findWidgetByName('playEffectEdit')
		local n = s:getString()
		local s = string.format('demo/cocos/nodes/effects/skill/000%d.csb',tonumber(n))
		local f = cc.FileUtils:getInstance():isFileExist(s)
		if f then
			test_XCSBNode0(e_root,s,false,window)
		else
			print('file not found',s)
		end
	end
	window:addClickEventListener('playEffect5Sec',on_click_event)
end

function startTest(root)
	test_gameDemoEntry(root)
end