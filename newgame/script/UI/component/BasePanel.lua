---------HJH
---------2012-2-15
---------
require "UI/component/AbstractBase"
---------BasePanel类
super_class.BasePanel(AbstractBasePanel)
---------
---------
local function BasePanelCreateFunction(self, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x or 0
	local tPosY = y or 0
	local tWidth = width or 0
	local tHeight = height or 0
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
function BasePanel:__init(fatherPanel)
end
---------
---------
--九宫格的命名有误 应该是下左  下右 上左 上右的四个矩阵的大小。不是像素。
function BasePanel:create(fatherPanel, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local sprite = BasePanel(fatherPanel)
	BasePanelCreateFunction(sprite, width, height, x, y, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	sprite:registerScriptFun()
	return sprite;
end