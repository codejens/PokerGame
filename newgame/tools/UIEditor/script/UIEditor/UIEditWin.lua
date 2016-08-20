--UIEditWin.lua
require "SWidget/__init"
super_class.UIEditWin() 

local standard_width = GameScreenConfig.standard_width
local standard_height = GameScreenConfig.standard_height

local _edit_root = nil
local _win = nil
local _dialog = nil
local _icon = nil

function UIEditWin:destroy()
	_edit_root:removeFromParentAndCleanup(true)
	_win.root.view:removeFromParentAndCleanup(true)
	_dialog.view:removeFromParentAndCleanup(true)
end

function UIEditWin:show_window()
	local ui_root = UIManager:get_main_panel()
	if not _edit_root then
		UIEditWin:create_root_panel()
	end
	if not _win then
		_win = UIEditWin()
		ui_root:addChild(_win.root.view)
	end
	if not _dialog then
		_dialog = UIEidtDilog()
		ui_root:addChild(_dialog.view,8888)
	end

	require 'UIEditor/UIEditor'
	UIEditor:toggle()
end

function UIEditWin:create_by_layout(node)
	--local node = CreateUIByLayout(layout)
	local ui_root = UIManager:get_main_panel()
	if _win.ui_layout.node then
		_win.ui_layout.node.view:removeFromParentAndCleanup(true)
	end
	_win.root:addChild(node.view)

	-- 更新原有的layout为当前的layout，保存操作实质保存的是laytou，
	--如果不覆盖以前的layout则会打开文件后，进行保存操作会清除以前的数据保存一个新的表
	_win.ui_layout.layout = node.layout
	_win.ui_layout.node = node
	
end

function UIEditWin:__init()
	self.root = SPanel:create("",960,640,true)
	--self.root:setPosition(15,10)917, height = 628
	--self:addChild(self.root)
	local layout = {class="SPanel",name = "win_root",parent = "ui_root",pos = {5,5},size={950,630},img_n ="",is_nine = true}
	self.ui_layout = SPanel:create("",950,630,true)
	self.ui_layout.layout = layout
	self.ui_layout:setPosition(5,5)
	self.root:addChild(self.ui_layout)

	UIEditModel:init()
	UIEditModel:set_cobj_for_luaobj(self.ui_layout)
end

--根节点 接受所有消息
function UIEditWin:create_root_panel()
	_edit_root = SPanel:create("",standard_width,standard_height,true)
	local ui_root = UIManager:get_main_panel()
	ui_root:addChild(_edit_root.view,9999)

	lastTouch = nil
	local function edit_root_func(eventtype,args)
		args = Utils:Split(args,":")
		local x,y = args[1],args[2]
		if eventtype == TOUCH_BEGAN then
			lastTouch = args
		end

		if eventtype == TOUCH_MOVED then
			UIEditModel:move_event(x,y )
			self:move_dlg(x,y,lastTouch)
			lastTouch = args
		end
		if eventtype == TOUCH_ENDED then
			
			if _icon then
				_icon:setIsVisible(false)
			end
			UIEditWin:add_widget(x,y)

			_dialog.can_move = false
			lastTouch = nil
		end
	end
	_edit_root:set_all_touch_func(edit_root_func)
end 

function UIEditWin:get_edit_root()
	return _win.root
end

function UIEditWin:add_widget(x, y)
	UIEditModel:add_widget(x,y,_win.root.view,_dialog.view)
end

function UIEditWin:move_icon(x, y)
	if not _icon then
		_icon = SPanel:create("nopack/item_cd.png", 100, 30, true)
		_edit_root:addChild(_icon)
	end
	_icon:setIsVisible(true)
	_icon:setPosition(x+1, y+1)
end

function UIEditWin:move_dlg(x,y,lastTouch)
	if _dialog.can_move then
		local dx = x - lastTouch[1]
		local dy = y - lastTouch[2]
		_dialog:move(dx,dy)
	end
end

function UIEditWin:get_root_layout()
	return _win.ui_layout.layout
end