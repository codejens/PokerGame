------------------------------
-- @gameStateManager
-- 登录状态
--
------------------------------
testState = { id = 'loginState' }

function createItem(name, title, func)
  local ret = resourceHelper.loadCSB('demo/cocos/testMenuItem.csb',false,nil)
  local node = ret:getNode()
  local widget = cocosHelper.findWidgetByName(node,name)
  cocosHelper.safeRemoveFromParent(widget,true)
  widget:setTitleText(title)

  local function _click_func( sender,eventType )
    if eventType == ccui.TouchEventType.ended then
      func(sender,eventType)
    end
  end
  widget:setTouchEnabled(true)
  widget:addTouchEventListener(_click_func)

  return widget
end

function testState:enter(oldstate)
  strict_if_strict(false)


  require 'test.test_AutoTips'
  require 'test.test_avatar'
  require 'test.test_Downloader'
  require 'test.test_Joystick'
  require 'test.test_LPRenderSlotHolder'
  require 'test.test_RichTextCreator'
  require 'test.test_luaSocket'
  require 'test.test_timer'
  require 'test.test_XAnimateSprite'
  require 'test.test_XCSBLoader'
  require 'test.test_XCSBNode'  
  require 'test.test_XSlotAnimateSprite'  
  require 'test.test_gameDemoEntry'  
  require 'test.test_layoutcreator'
  require 'test.test_customShader'
  
  
  
	--print('loginState:enter')
	baseState.enter(self)
  local ret = resourceHelper.loadCSB('demo/cocos/testMenu.csb',false,nil)
  local node = ret:getNode()
  --view:getParent():addChild(node,255,0)
  --[[
  local p_root = node:getChildByName('playerRoot')
  local m_root = node:getChildByName('monsterRoot')
  local e_root = node:getChildByName('effectRoot')
  ]]--
  testState.mainMenu = GUIWindow(node)
  local scene = scene.XLogicScene:sharedScene()
  local test_root = cc.Node:create()
  scene:addChild(node,255,0)
  scene:addChild(test_root,254,0)

  local window = GUIWindow(node)
  local listView = window:findWidgetByName('ListView_1')
  window:addTouchEventListener('Back', function()
    local name = testState.current_test_name
    if name and test[name].endTest then
      test[name].endTest()
    end
    test_root:removeAllChildren(true)
    listView:setVisible(true)
  end)

  for k,v in pairs(test) do
    if type(v) == 'table' and test[k].startTest then
      local _click_func = function() 
        test[k].startTest(test_root)
        testState.current_test_name = k
        listView:setVisible(false)
      end
      
      local widget = createItem('buttom', k , _click_func)
      listView:pushBackCustomItem(widget)
    end
  end



  --strict_if_strict(true)
end

function testState:leave()
	--print('loginState:leave')
	baseState.leave(self)
  if testState.current_test and testState.current_test.endTest then
    testState.current_test.endTest()
  end
  --离开登陆界面
end