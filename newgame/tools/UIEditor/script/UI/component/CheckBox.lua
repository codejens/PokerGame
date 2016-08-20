---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------复选按钮
super_class.CheckBox(AbstractBasePanel)
---------
---------
function CheckBox:registerScriptFun()
	if self.view ~= nil then
		local function checkBoxMessageFun(eventType, arg, msgid, selfItem)
			-------
			if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
				return 
			end
			-------
			if eventType == TOUCH_BEGAN then
				self.click_num = self.click_num + 1
				if self.touch_begin_fun ~= nil then
					self.touch_begin_fun()
				end
				if self.click_num % 2 == 0 then
					self.view:setCurState(CLICK_STATE_UP)
				else 
					self.view:setCurState(CLICK_STATE_DOWN)
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
				if self.click_num % 2 == 0 then
					self.view:setCurState(CLICK_STATE_UP)
				else 
					self.view:setCurState(CLICK_STATE_DOWN)
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
			end
		end
		-------
		self.view:registerScriptHandler(checkBoxMessageFun)
	end
end
---------
---------
local function CheckBoxCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tImageUp = ""
	local tImageDown = nil
	local tTopLeftWidth = topLeftWidth
	local tTopLeftHeight = topLeftHeight
	local tTopRightWidth = topRightWidth
	local tTopRightHeight = topRightHeight
	local tBottomLeftWidth = bottomLeftWidth
	local tBottomLeftHeight = bottomLeftHeight
	local tBottomRightWidth = bottomRightWidth
	local tBottomRightHeight = bottomRightHeight
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
	if type(image) == 'table' and  #image > 1 then
		tImageUp = image[1]
		tImageDown = image[2]
	else
		tImageUp = image
	end
	---------
	self.view = CCRadioButton:radioButtonWithFile(tPosX, tPosY, tWidth, tHeight, tImageUp, TYPE_MUL_TEX, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	if tImageDown ~= nil then
		self.view:addTexWithFile(CLICK_STATE_DOWN, tImageDown)
	end
end
---------
---------
function CheckBox:__init(fatherPanel)
	self.click_num = 0
end
---------
---------
function CheckBox:create(fatherPanel, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = CheckBox(fatherPanel)
	CheckBoxCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	return sprite
end
---------
---------添加对应状态图片
function CheckBox:addImage(state, image)
	if self.view ~= nil then
		self.view:addTexWithFile(state, image)
	end
end
---------
---------添加对应状态变灰图片
function CheckBox:addGrayImage(state, image)
	if self.view ~= nil then
		self.view:addTexWithFileEx(state, TYPE_GRAY, image)
	end
end
---------
---------
function CheckBox:setCurState(state)
	if state == CLICK_STATE_UP then
		self.view:setCurState(CLICK_STATE_UP)
		self.click_num = 0
	else
		self.view:setCurState(CLICK_STATE_DOWN)
		self.click_num = 1
	end
end
---------
---------
function CheckBox:getClickNum()
	return self.click_num
end