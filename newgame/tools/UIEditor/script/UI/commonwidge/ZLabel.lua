---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文本类

super_class.ZLabel()

local DEFAULT_FONT_SIZE = 16
local DEFAULT_ALIGN_STATE = ALIGN_LEFT

---------
---------
local function LabelCreateFunction(self, x, y , text, fontSize, aline)
	local tPosX = x or 0
	local tPosY = y or 0
	local tText = text or ""
	local tFontSize = fontSize or DEFAULT_FONT_SIZE
	local tAline = aline or DEFAULT_ALIGN_STATE

	self.view = CCZXLabel:labelWithText( tPosX, tPosY, tText, tFontSize, tAline )
end
---------
---------
function ZLabel:__init(fatherPanel)
	self.father_panel = fatherPanel
	-- LabelCreateFunction(self)
end
---------
---------文本类不用接收消息，所以不用注册消息函数
function ZLabel:create(fatherPanel, text, x, y, fontSize, aline, z)
	local sprite = ZLabel(fatherPanel)
	LabelCreateFunction(sprite, x, y, text, fontSize, aline)
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			if z ~= nil then 
				fatherPanel.view:addChild( sprite.view, z )
			else
				fatherPanel.view:addChild( sprite.view )
			end
		else
			if z ~= nil then
				fatherPanel:addChild( sprite.view, z )
			else
				fatherPanel:addChild( sprite.view )
			end
		end
	end
	return sprite
end
---------
---------设置文本
function ZLabel:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end
---------
---------设置文本字体大小
function ZLabel:setFontSize(fontSize)
	if self.view ~= nil then
		self.view:setFontSize(fontSize)
	end
end
---------
---------
function ZLabel:setPosition(x, y)
	if self.view ~= nil then
		self.view:setPosition(x, y)
	end
end
-------
-------
function ZLabel:getPosition()
	if self.view ~= nil then
		return self.view:getPositionS()
	else
		return {x = 0, y = 0}
	end
end
---------
---------取得文本范围
function ZLabel:getSize()
	if self.view ~= nil then
		return self.view:getSize()
	else
		return {width = 0, height = 0}
	end
end
---------
---------取得文本内容
function ZLabel:getText()
	if self.view ~= nil then
		return self.view:getText()
	else
		return ""
	end
end




-- 新创建的构造函数
function ZLabel.new( text )
	local tText = text or ""
	local label = ZLabel()
	label.view = CCZXLabel:labelWithText( 0, 0, tText, DEFAULT_FONT_SIZE, DEFAULT_ALIGN_STATE )
	return label
end