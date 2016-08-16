---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文本类
super_class.Label()
---------
---------
local function LabelCreateFunction(self, x, y , text, fontSize)
	local tPosX = x
	local tPosY = y
	local tText = text
	local tFontSize = fontSize
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if text == nil then
		tText = ""
	end
	if fontSize == nil then
		tFontSize = 16
	end
	---------
	self.view = CCZXLabel:labelWithText( tPosX, tPosY, tText, tFontSize)
end
---------
---------
function Label:__init(fatherPanel)
	self.father_panel = fatherPanel
	self.view = nil
end
---------
---------文本类不用接收消息，所以不用注册消息函数
function Label:create(fatherPanel, x, y, text, fontSize)
	local sprite = Label(fatherPanel)
	LabelCreateFunction(sprite, x, y, text, fontSize)
	return sprite
end
---------
---------设置文本
function Label:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end
---------
---------设置文本字体大小
function Label:setFontSize(fontSize)
	if self.view ~= nil then
		self.view:setFontSize(fontSize)
	end
end
---------
---------
function Label:setPosition(x, y)
	if self.view ~= nil then
		self.view:setPosition(x, y)
	end
end
-------
-------
function Label:getPosition()
	if self.view ~= nil then
		return self.view:getPositionS()
	else
		return {x = 0, y = 0}
	end
end
---------
---------取得文本范围
function Label:getSize()
	if self.view ~= nil then
		return self.view:getSize()
	else
		return {width = 0, height = 0}
	end
end
---------
---------取得文本内容
function Label:getText()
	if self.view ~= nil then
		return self.view:getText()
	else
		return ""
	end
end
