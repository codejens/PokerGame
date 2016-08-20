---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------九宫格面板
require "XWidget/base/XAbstructPanelNormal"

super_class.XPanelNineGrid(XAbstructPanelNormal)

---------
---------
function XPanelNineGrid:__init(width, height, image)

	local tImage = image or ""
	local tWidth = width
	local tHeight = height
	local tNgWidth = DefaultNineGridSize
	local tNgHeight = DefaultNineGridSize

	self.view = CCBasePanel:panelWithFile( 0, 0, tWidth, tHeight, tImage, tNgWidth, tNgHeight, 0, 0, 0, 0, 0, 0 )
	self:registerScriptFun()

end

