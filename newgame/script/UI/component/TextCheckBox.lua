---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------后带文字复选按钮
super_class.TextCheckBox(AbstractBasePanel)
---------
---------
local function TextCheckBoxCreateFunction(self, width, height, x, y, image, text, gapSize, fontSize)
	local tPosX = x
	local tPosY = y
	local tWidth = width
	local tHeight = height
	local tFontSize = fontSize
	local tImage = image
	local tText = text
	local tGapSize = gapSize
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
	if fontSize == nil then
		tFontSize = 16
	end
	if text == nil then
		tText = ""
	end
	if gapSize == nil then
		tGapSize = 0
	end
	---------
	require "UI/component/CheckBox"
	require "UI/component/Label"
	require "UI/component/BasePanel"
	local checkbox = CheckBox:create(nil, 0, 0, tWidth, tHeight, tImage)
	self.check_button = checkbox
	local checkboxsize = checkbox:getSize()
	checkbox.view:setEnableHitTest(false)
	checkbox:setTouchBeganReturnValue(false)
	checkbox:setTouchEndedReturnValue(false)
	checkbox:setTouchClickReturnValue(false)
	checkbox:setTouchDoubleClickReturnValue(false)
	local text = Label:create(nil, checkboxsize.width + tGapSize, (tHeight-tFontSize)/2, tText, tFontSize)
	self.text = text
	local textsize = text:getSize()
	local temp_height = checkboxsize.height
	local basepanel = BasePanel:create(self, tPosX, tPosY, checkboxsize.width + textsize.width + tGapSize, checkboxsize.height)
	basepanel.view:addChild(checkbox.view)
	basepanel.view:addChild(text.view)
	self.view = basepanel.view
end
---------
---------
function TextCheckBox:__init(fatherPanel)
	self.check_button = nil
	self.normal_color = nil
	self.select_color = nil
end
---------
---------参数说明：x、y代表位置。width、height代表图片长宽,image代表图片路径,text代表文本内容,fontSize代表文本字体字号
function TextCheckBox:create(fatherPanel, x, y, width, height, image, text, gapSize, fontSize)
	local sprite = TextCheckBox(fatherPanel)
	TextCheckBoxCreateFunction(sprite, width, height, x, y, image, text, gapSize, fontSize)
	sprite:registerScriptFun()
	return sprite
end
---------
---------
-- function TextCheckBox:setTouchClickFun(userFunction)
-- 	if self.check_button ~= nil then
-- 		self.check_button:setTouchClickFun(userFunction)
-- 	end
-- end
---------
---------
function TextCheckBox:setCurState(state)
	self.check_button:setCurState(state)
end
---------
---------
function TextCheckBox:getText()
	if self.text ~= nil then
		return self.text:getText()
	end
end
---------
---------
function TextCheckBox:getClickNum()
	return self.check_button:getClickNum()
end
---------
---------
function TextCheckBox:setClickStateColor(normalColor, selectColor)
	self.normal_color = normalColor
	self.select_color = selectColor
end
---------
---------
function TextCheckBox:registerScriptFun()
	if self.view ~= nil then
		local function basePanelMessageFun(eventType, args, msgid, selfItem)
			-------
			if eventType == nil or args == nil or msgid == nil or selfItem == nil then
				return 
			end
			-------
			----print("eventType",eventType)
			if eventType == TOUCH_BEGAN then
				if self.touch_begin_fun ~= nil then
					self.touch_begin_fun(args)
				end
				return self.touch_begin_return
			elseif eventType == TOUCH_MOVED then
				if self.touch_move_fun ~= nil then
					self.touch_move_fun(args)
				end
				return self.touch_move_return
			elseif eventType == TOUCH_ENDED then
				if self.touch_end_fun ~= nil then
					self.touch_end_fun(args)
					if self.check_button.view:getCurState() == CLICK_STATE_UP then
						if self.normal_color ~= nil then
							self.text.view:setColor(tonumber(self.normal_color))
						end
					else
						if self.select_color ~= nil then
							self.text.view:setColor(tonumber(self.select_color))
						end
					end
				end
				return self.touch_end_return
			elseif eventType == TOUCH_CLICK then
				------print("self.touch_click_fun",self.touch_click_fun)
				if self.touch_click_fun ~= nil then
					self.touch_click_fun(args)
					----print("self.check_button.view:getCurState()",self.check_button.view:getCurState())
					if self.check_button.view:getCurState() == CLICK_STATE_UP then
						if self.normal_color ~= nil then
							self.text.view:setColor(tonumber(self.normal_color))
						end
					else
						if self.select_color ~= nil then
							self.text.view:setColor(tonumber(self.select_color))
						end
					end
				end
				return self.touch_click_return
			elseif eventType == TOUCH_DOUBLE_CLICK then
				if self.touch_double_click_fun ~= nil then
					self.touch_double_click_fun(args)
				end
				return self.touch_double_click_return
			elseif eventType == TIMER then
				if self.touch_timer_fun ~= nil then
					self.touch_timer_fun()
				end
				return true
			elseif eventType == OUT_OF_FOCUS then
				if self.normal_color ~= nil then
					self.text.view:setColor(tonumber(self.normal_color))
				end
			elseif eventType == ON_FOCUS then
				if self.select_color ~= nil then
					self.text.view:setColor(tonumber(self.select_color))
				end
			end
		end
		-------
		self.view:registerScriptHandler(basePanelMessageFun)
	end
end