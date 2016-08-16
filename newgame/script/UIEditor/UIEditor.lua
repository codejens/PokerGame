UIEditor = { enable_flag = false }
editorGUI = {}
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

require '../data/layouts/windowsLayouts'
require 'UIEditor/UIEditorUtils'
require 'UIEditor/selectionComponent'

VK_LEFT     =     0x25
VK_UP       =     0x26
VK_RIGHT    =     0x27
VK_DOWN     =     0x28
VK_MENU     =     0x12
SELECT_RECT_TAG = -100


function UIEditor:init()
	if self.initialized then
		return
	end

	self.layer = CCBasePanel:panelWithFile( 0, 0, _refWidth(1.0), _refHeight(1.0),'')
	self.layer:setTag(SELECT_RECT_TAG)
	self.layer:setEnableHitTest(false)
	local cross = editorGUI:init(self.layer,_refWidth(1.0), _refHeight(1.0))
	self.UIRoot:addChild(self.layer,70000)
	self.layer:addChild(cross,0)

	self.selectRect = CCDebugRect:create()
	safe_retain(self.selectRect)
	self.selectRect:setTag(SELECT_RECT_TAG)
	--self.timer = timer()
	--self.timer:start(0, function() UIEditor:checkKeyEvent() end)



	lastTouch = nil
	local function basePanelMessageFun(eventType,args)
		if not self.enable_flag then
			return false
		end

		local x,y = string.match(args,"(%d+):(%d+)")

		local down = GetKeyDown(VK_MENU)
		if not down then
			lastTouch = nil
		end
		if eventType == TOUCH_BEGAN then
			if not down then
				local node = ZXLuaUtils:selectCCNode(self.UIRoot,CCPointMake(x,y))
				self:setSelected(node)
			else
				lastTouch = { x, y }
			end
		elseif eventType == TOUCH_MOVED then
			
			if down then
				if lastTouch then
					local dx = x - lastTouch[1]
					local dy = y - lastTouch[2]
					self:moveSelected(dx,dy)
				end
				lastTouch = { x, y }
			end

		elseif eventType == TOUCH_ENDED then
			lastTouch = nil
		end

		
		return true
	end

	self.layer:registerScriptHandler(basePanelMessageFun)

	self.key_events = 
	{
		[VK_LEFT] = false,
		[VK_UP] = false,
		[VK_RIGHT] = false,
		[VK_DOWN] = false
	}

	self.initialized = true
	self.selected = selectionComponent()
end

function UIEditor:checkKeyEvent()
	for k,v in pairs(self.key_events) do
		local down = GetKeyDown(k)
		if v == false and down then
			--print(k, 'key down')
			UIEditor:onKeyEvent(k,down)
		elseif v == true and not down then
			--print(k, 'key up')
			UIEditor:onKeyEvent(k,down)
		elseif v and v == down then
			UIEditor:onKeyEvent(k,down)
		end
		self.key_events[k] = down
	end
end

function UIEditor:onKeyEvent(code, down)
	if down then
		if self.selected.target then
			local x,y = self.selected:getPosition()
			if code == VK_LEFT then
				self.selected:setPosition(x - 1,y)
			elseif code == VK_RIGHT then
				self.selected:setPosition(x + 1,y)
			elseif code == VK_UP then
				self.selected:setPosition(x,y + 1)
			elseif code == VK_DOWN then		
				self.selected:setPosition(x,y - 1)
			end	
		end
	end
end

function UIEditor:toggle()
	self:enable(not self.enable_flag)
end

function UIEditor:enable(flag)
	if self.enable_flag == flag then
		return
	end

	local root = ZXLogicScene:sharedScene()
	self.UIRoot = root:getUINode()


	UIEditor:init()

	self.enable_flag = flag

	self:setSelected(nil)

	self.layer:setIsVisible(flag)

	local win0 = UIManager:find_window('screen_notic_win')
	local win1 = UIManager:find_window('center_notic_win')
	local win2 = UIManager:find_window('screen_run_notic_win')
	if not flag then
		if win0 then
			win0.view:setIsVisible(true)
		end
		if win1 then
			win1.view:setIsVisible(true)
		end
		if win2 then
			win2.view:setIsVisible(true)
		end
	else
		if win0 then
			win0.view:setIsVisible(false)
		end
		if win1 then
			win1.view:setIsVisible(false)
		end
		if win2 then
			win2.view:setIsVisible(false)
		end
	end
end

function UIEditor:setSelectedPosition(x,y)
	self.selected:setPosition(x,y,true)
end

function UIEditor:setSelectedSize(w,h)
	self.selected:setSize(w,h)
end

function UIEditor:getSelectedParent(tag)
	local node = self.selected:getParent()
	self:setSelected(node)
end

function UIEditor:setSelected(node)
	self.selectRect:removeFromParentAndCleanup(true)
	if node then
		node:addChild(self.selectRect,70000)
	end
	self.selected:setTarget(node)
end



function UIEditor:setSelectedChild(i)
	self.selected:setSelectedChild(i)
end

function UIEditor:onQuit()
	safe_release(self.selectRect)
end

function UIEditor:setSelectedTexture(texture)
	self.selected:setTexture(texture)
end

function UIEditor:moveSelected(dx,dy)
	if self.selected.target then
		local x, y = self.selected:getPosition()
		self.selected:setPosition(x+dx,y+dy)
	end
end

function UIEditor:save()
	-- body
	local o = table_serialize(windowsLayouts)
	local f = io.open('resource/data/layouts/windowsLayouts.lua', 'w+')
	f:write('windowsLayouts =' .. o)
	f:close()
end