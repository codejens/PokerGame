---------HJH
---------2012-2-15
---------
require "UI/commonwidge/base/ZAbstractNode"
---------BasePanel类
super_class.ZBasePanel(ZAbstractBasePanel)
---------
---------
local function BasePanelCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x or 0 
	local tPosY = y or 0 
	local tWidth = width or -1
	local tHeight = height or -1
	local tImage = image or ''
	local tTopLeftWidth = topLeftWidth or 0
	local tTopLeftHeight = topLeftHeight or 0
	local tTopRightWidth = topRightWidth or 0
	local tTopRightHeight = topRightHeight or 0
	local tBottomLeftWidth = bottomLeftWidth or 0
	local tBottomLeftHeight = bottomLeftHeight or 0
	local tBottomRightWidth = bottomRightWidth or 0
	local tBottomRightHeight = bottomRightHeight or 0
	-------
	-------create basepanel
	self.view = CCBasePanel:panelWithFile(tPosX, tPosY, tWidth, tHeight, tImage, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
	-------
end
---------
---------
function ZBasePanel:__init(fatherPanel)
	self.father_panel = fatherPanel
end
---------
---------
function ZBasePanel:create(fatherPanel, image, x, y, width, height, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = ZBasePanel(fatherPanel)
	BasePanelCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	if fatherPanel ~= nil then
		if fatherPanel.view ~= nil then
			fatherPanel.view:addChild( sprite.view )
		else
			fatherPanel:addChild( sprite.view )
		end
	end
	return sprite;
end

function ZBasePanel:getPositionY(  )
    local x,y = self.view:getPosition()
    return y
end

function ZBasePanel:setPosition( x, y )
	self.view:setPosition(x, y)
end

-- 新的构造函数
function ZBasePanel.new( texture, width, height )
	local base_panel = ZBasePanel:create(nil, texture, 0, 0, width, height, DefaultNineGridSize, DefaultNineGridSize, 0, 0, 0, 0)
	return base_panel
end