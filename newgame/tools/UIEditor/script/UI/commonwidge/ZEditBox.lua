---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------输入框类
super_class.ZEditBox(ZAbstractBasePanel)
---------
---------
local function EditBoxCreateFunction(self, width, height, x, y, maxnum, image, fontSize, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tImage = image
	local tTopLeftWidth = topLeftWidth
	local tTopLeftHeight = topLeftHeight
	local tTopRightWidth = topRightWidth
	local tTopRightHeight = topRightHeight
	local tBottomLeftWidth = bottomLeftWidth
	local tBottomLeftHeight = bottomLeftHeight
	local tBottomRightWidth = bottomRightWidth
	local tBottomRightHeight = bottomRightHeight
	local tMaxNum = maxnum
	local tFontSize = fontSize
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if width == nil then
		tWidth = 0
	end
	if height == nil then
		tHeight = 0
	end
	if image == nil then
		tImage = ""
	end
	if topLeftWidth == nil then
		tTopLeftWidth = 0
	end
	if topLeftHeight == nil then
		tTopLeftHeight = 0
	end
	if topRightWidth == nil then
		tTopRightWidth = 0
	end
	if topRightHeight == nil then
		tTopRightHeight = 0
	end
	if bottomLeftWidth == nil then
		tBottomLeftWidth = 0
	end
	if bottomLeftHeight == nil then
		tBottomLeftHeight = 0
	end
	if bottomRightWidth == nil then
		tBottomRightWidth = 0
	end
	if bottomRightHeight == nil then
		tBottomRightHeight = 0
	end
	if maxnum == nil then
		tMaxNum = 20
	end
	if fontSize == nil then
		tFontSize = 16
	end
	---------
	self.view = CCZXEditBox:editWithFile( tPosX, tPosY, tWidth, tHeight, tImage, tMaxNum, tFontSize, EDITBOX_TYPE_NORMAL, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
end
---------
---------
function ZEditBox:__init(fatherPanel)
	self.father_panel = fatherPanel
	self.keyBoardEnterFun = nil
	self.keyBoardClickFun = nil
	self.keyBoardAttachFun = nil
	self.keyBoardDetachFun = nil
	self.keyBoardBackSpaceFun = nil
end
---------
---------
function ZEditBox:registerScriptFun()
	if self.view ~= nil then
		local function editBoxMessageFun(eventType, arg, msgid, selfItem)
			-------
			if eventType == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				if self.touch_begin_fun ~= nil then
					self.touch_begin_fun()
				end
				return self.touch_begin_return
			elseif eventType == TOUCH_MOVED then
				if self.touch_move_fun ~= nil then
					self.touch_move_fun()
				end
				return self.touch_move_return
			elseif eventType == TOUCH_ENDED then
				if self.touch_end_fun ~= nil then
					self.touch_end_fun()
				end
				return self.touch_end_return
			elseif eventType == TOUCH_CLICK then
				if self.touch_click_fun ~= nil then
					self.touch_click_fun()
				end
				return self.touch_click_return
			elseif eventType == TOUCH_DOUBLE_CLICK then
				if self.touch_double_click_fun ~= nil then
					self.touch_double_click_fun()
				end
				return self.touch_double_click_return
			elseif eventType == TIMER then
				if self.touch_timer_fun ~= nil then
					self.touch_timer_fun()
				end
				return true
			elseif eventType == KEYBOARD_ENTER then
				if self.keyBoardEnterFun ~= nil then
					self.keyBoardEnterFun(self.view:getText())
				end
			elseif eventType == KEYBOARD_CLICK then
				if self.keyBoardClickFun ~= nil then
					self.keyBoardClickFun()
				end
			elseif eventType == KEYBOARD_ATTACH then
				if self.keyBoardAttachFun ~= nil then
					self.keyBoardAttachFun()
				end
			elseif eventType == KEYBOARD_DETACH then
				if self.keyBoardDetachFun ~= nil then
					self.keyBoardDetachFun()
				end
			elseif eventType == KEYBOARD_BACKSPACE then
				if self.keyBoardBackSpaceFun ~= nil then
					self.keyBoardBackSpaceFun()
				end
			end
		end
		-------
		self.view:registerScriptHandler(editBoxMessageFun)
	end
end
---------
---------
function ZEditBox:create(fatherPanel, x, y, width, height, maxnum, fontSize, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZEditBox(fatherPanel)
	EditBoxCreateFunction(sprite, width, height, x, y, maxnum, image, fontSize, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			fatherPanel.view:addChild( sprite.view )
		else
			fatherPanel:addChild( sprite.view )
		end
	end
	return sprite
end
---------
---------设置键盘回车函数
function ZEditBox:setKeyBoardEnterFunction(userFunction)
	self.keyBoardEnterFun = userFunction
end
---------
---------设置键盘按下函数
function ZEditBox:setKeyBoardClickFunction(userFunction)
	self.keyBoardClickFun = userFunction
end
---------
---------设置输入框按下函数
function ZEditBox:setKeyBoardAttachFunction(userFunction)
	self.keyBoardAttachFun = userFunction
end
---------
---------设置输入框离开函数，暂时不起作用
function ZEditBox:setKeyBoardDetachFunction(userFunction)
	self.keyBoardDetachFun = userFunction
end
---------
---------设置输入框退格键函数
function ZEditBox:setKeyBoardBackSpaceFunction(userFunction)
	self.keyBoardBackSpaceFun = userFunction
end
---------
---------设置文本内容
function ZEditBox:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end
---------
---------设置文本最大输入数目
function ZEditBox:setMaxNum(num)
	if self.view ~= nil then
		self.view:setMaxTextNum(num)
	end
end
---------
---------设置输入框种类，共三种，EDITBOX_TYPE_NORMAL：普通文本框,EDITBOX_TYPE_PASSWORD：密码文本框,EDITBOX_TYPE_NUMBER：数字文本框，数字文本框暂时不起作用
function ZEditBox:setType(type)
	if self.view ~= nil then
		self.view:setEditBoxType(type)
	end
end
-- ---------
-- ---------设置是否使用剪裁
-- function ZEditBox:setCut(isCut)
-- 	if self.view ~= nil then
-- 		self.view:setEnabelCut(isCut)
-- 	end
-- end
---------
---------取得文本内容
function ZEditBox:getText()
	if self.view ~= nil then
		return self.view:getText()
	else
		return nil
	end
end
---------
---------取得最大输入数量
function ZEditBox:getMaxNum()
	if self.view ~= nil then
		return self.view:getMaxTextNum()
	else
		return 0
	end
end
---------
---------取得当前输入数量
function ZEditBox:getCurNum()
	if self.view ~= nil then
		return self.view:getCutTextNum()
	else
		return 0
	end
end
---------
---------设置是否启用光标
function ZEditBox:runIcon(isRun)
	if self.view ~= nil then
		self.view:isRunIcon(isRun)
	end
end