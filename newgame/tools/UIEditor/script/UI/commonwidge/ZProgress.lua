---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------文本类
super_class.ZProgress(ZAbstractBasePanel)

local STYLE_TABLE = {
	[UISTYLE_ZPROGRESS_ONE] = { UILH_NORMAL.progress_bar_orange, UILH_NORMAL.progress_bg2 },
	[UISTYLE_ZPROGRESS_TWO] = {  UILH_NORMAL.progress_bar, UILH_NORMAL.progress_bg2 },
}

---------
---------
local function ProgressCreateFunction(self, curValue, maxValue, x, y, width, height, showNum, bg, img, ttype )
	local tPosX = x
	local tPosY = y
	local tCurValue = curValue
	local tMaxValue = maxValue
	local tWidth = width
	local tHeight = height
	local tShowNum = showNum
	local tType = ttype
	local tBg = bg
	local tImg = img
	if ttype == nil then
		tType = 0
	end
	if bg == nil then
		tBg = UIResourcePath.FileLocate.common .. "progress_gray.png"
	end
	if img == nil then
		tImg = UIResourcePath.FileLocate.common .. "progress_green.png"
	end
	if x == nil then
		tPosX = 0
	end
	if y == nil then
		tPosY = 0
	end
	if width == nil then
		tWidth = 100
	end
	if height == nil then
		tHeight = 20
	end
	if curValue == nil then
		tCurValue = 0
	end
	if maxValue == nil then
		tMaxValue = 1 
	end
	if showNum == nil then
		tShowNum = true
	end
	---------
	print("tCurValue=",tCurValue)
	print("tMaxValue=",tMaxValue)

	self.view = ZXProgress:createWithValueEx( tCurValue, tMaxValue, tWidth, tHeight, tBg, tImg, tShowNum, tType)
	self.view:setPosition( tPosX, tPosY )
	--CCZXLabel:labelWithText( tPosX, tPosY, tText, tFontSize, tAline )
end
---------
---------
function ZProgress:__init(fatherPanel)
	self.father_panel = fatherPanel
	self.view = nil
end
---------
---------文本类不用接收消息，所以不用注册消息函数
function ZProgress:create(fatherPanel, curValue, maxValue, x, y, width, height, showNum, bg, img, ttype )
	local sprite = ZProgress(fatherPanel)
	ProgressCreateFunction( sprite, curValue, maxValue, x, y, width, height, showNum, bg, img, ttype )
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
---------
function ZProgress:setProgressValue(cur, max)
	if self.view ~= nil then
		self.view:setProgressValue(cur, max)
	end
end

function ZProgress:setAnchorPoint(point)
	if self.view ~= nil then
		self.view:setAnchorPoint(point)
	end
end

---------
---------
function ZProgress:setTextVisible(result)
	if self.view ~= nil then
		self.view:setLabVisible( result )
	end
end

function ZProgress:createByStyle( _style,layout )
	local image_table = STYLE_TABLE[_style];
	local component = ZProgress:create(nil, layout.curValue, layout.maxValue, layout.posX, layout.posY,
	 layout.width, layout.height,
	 layout.showNum, image_table[2], image_table[1])
	return component;
end