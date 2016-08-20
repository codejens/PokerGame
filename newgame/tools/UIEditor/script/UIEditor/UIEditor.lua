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

local _rect = {}
--多选
local _node_gruop = {}
local _index = 1

local _is_copy = false

function UIEditor:init()
	
	if self.initialized then
		return
	end

	for i=1,100 do
		_rect[i] = CCDebugRect:create()
		safe_retain(_rect[i])
	end


	self.layer = CCBasePanel:panelWithFile( 0, 0, _refWidth(1.0), _refHeight(1.0),'')
	self.layer:setTag(SELECT_RECT_TAG)
	self.layer:setEnableHitTest(false)
	--local cross = editorGUI:init(self.layer,_refWidth(1.0), _refHeight(1.0))
	self.UIRoot:addChild(self.layer,70000)
	--self.layer:addChild(cross,0)

	self.selectRect = CCDebugRect:create()
	safe_retain(self.selectRect)
	self.selectRect:setTag(SELECT_RECT_TAG)

	local function checkKeyEvent( )
		self:checkKeyEvent()

	end

	self.timer = timer()
	self.timer:start(0, checkKeyEvent)



	local lastTouch = nil
	local function basePanelMessageFun(eventType,args)
		if not self.enable_flag then
			return false
		end

		local x,y = string.match(args,"(%d+):(%d+)")

		local down = GetKeyDown(17)--ctrl
		local g_down = GetKeyDown(16)--shift
		-- if not down then
		-- 	lastTouch = nil
		-- end
		if eventType == TOUCH_BEGAN then
			--if not down then
				local node = UIEditModel:selectCCNode( self.UIRoot,x,y )
		
				self:setSelected(node)
				if g_down then
					self:selected_group(node)
				else
					self:clear_group()
				end

			--else
				lastTouch = { x, y }
			--end
		elseif eventType == TOUCH_MOVED then
				if down then
					local dx = x - lastTouch[1]
					local dy = y - lastTouch[2]
					self:moveSelected(dx,dy)

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


function UIEditor:receive( args )
	print("receive==",self,self.selected)
	self.selected:receive(args)
end


function UIEditor:checkKeyEvent()
	local x_down = GetKeyDown(88) -- x按键
	local y_down = GetKeyDown(89) -- y按键
	local shift_down = GetKeyDown(16)--shift
	local ctrl_down = GetKeyDown(17)
	local v_down = GetKeyDown(86)
	local f_down = GetKeyDown(70)

	--shift
	if shift_down then
		if x_down then
			UIEditModel:x_align( _node_gruop )
		elseif y_down then
			UIEditModel:y_align( _node_gruop )
		end

	end
	--ctrl
	--复制一个控件
	if ctrl_down then
		if  x_down then
			_is_copy = true
		elseif  v_down then
			if _is_copy then
				UIEditModel:copy_widget( self.selected.target )
				_is_copy = false
			end
		elseif  f_down then
	
		end
	end
end

function UIEditor:onKeyEvent(code, down)
	if down then
		if self.selected.target then
			local x, y = self.selected:getPosition()

			if code == VK_LEFT then
				self.selected:setPosition(x - 1, y)
			elseif code == VK_RIGHT then
				self.selected:setPosition(x + 1, y)
			elseif code == VK_UP then
				self.selected:setPosition(x, y + 1)
			elseif code == VK_DOWN then
				self.selected:setPosition(x, y - 1)
			end
		end

		if code == string.byte('Z') then
			local cdown = GetKeyDown(17) --ctrl
			if cdown and self.del_parent and self.del_target then
				UIEditModel:re_del_widget(self.del_target, self.del_parent)
				self.del_parent = nil
				self.del_target = nil
			end
		end

		if code == string.byte('S') then
			local cdown = GetKeyDown(17) --ctrl
			if cdown then
				UIEditModel:save_layout_file()
			end
		end
	else
		if self.selected.target then
			if code == 46 then --删除键
				self:save_del_target(self.selected.target)
				UIEditModel:delete_one_widget(self.selected.target)
				self.selected.target = nil
			end
		end
	end
end

function UIEditor:save_del_target(target)
	self.del_target = UIEditModel:save_del_widget(target)
	self.del_parent = target:getParent()
end

function UIEditor:toggle()
	self:enable(not self.enable_flag)
end

function UIEditor:enable(flag)
	if self.enable_flag == flag then
		return
	end

	--local root = UIEditWin:get_edit_root(  )--ZXLogicScene:sharedScene()
	self.UIRoot =  UIEditWin:get_edit_root(  ).view--root:getUINode()


	UIEditor:init()

	self.enable_flag = flag

	self:setSelected(nil)

	self.layer:setIsVisible(flag)

	-- local win0 = UIManager:find_window('screen_notic_win')
	-- local win1 = UIManager:find_window('center_notic_win')
	-- local win2 = UIManager:find_window('screen_run_notic_win')
	-- if not flag then
	-- 	if win0 then
	-- 		win0.view:setIsVisible(true)
	-- 	end
	-- 	if win1 then
	-- 		win1.view:setIsVisible(true)
	-- 	end
	-- 	if win2 then
	-- 		win2.view:setIsVisible(true)
	-- 	end
	-- else
	-- 	if win0 then
	-- 		win0.view:setIsVisible(false)
	-- 	end
	-- 	if win1 then
	-- 		win1.view:setIsVisible(false)
	-- 	end
	-- 	if win2 then
	-- 		win2.view:setIsVisible(false)
	-- 	end
	-- end
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

function UIEditor:clear_group( ... )
	for i=1,_index-1 do
		_node_gruop = {}
		_rect[i]:removeFromParentAndCleanup(true)
	end
	_index = 1
end

function UIEditor:selected_group( node )

	if node then
		node:addChild(_rect[_index],70000)
		_node_gruop[_index] = node
		_index = _index + 1
	end

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
		print("moveSelected",dx,dy)
		self.selected:setPosition(x+dx,y+dy)
	end
end

function UIEditor:save()
	-- body
	-- local o = table_serialize(windowsLayouts)
	-- local f = io.open('resource/data/layouts/windowsLayouts.lua', 'w+')
	-- f:write('root =' .. o)
	-- f:close()
	UIEditModel:save_layout_file(  )
end

function UIEditor:x_distance( x_distance )
	UIEditModel:x_distance(_node_gruop,x_distance)
end

function UIEditor:y_distance( y_distance )
	UIEditModel:y_distance(_node_gruop,y_distance)
end