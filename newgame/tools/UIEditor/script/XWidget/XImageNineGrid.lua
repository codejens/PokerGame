---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------九宫格图片类
require "XWidget/base/XAbstructPanelNormal"

super_class.XImageNineGrid(XAbstructPanelNormal)

---------
---------
function XImageNineGrid:__init(width, height, image)

	local tImage = image or ""
	local tWidth = width
	local tHeight = height
	local tNgWidth = DefaultNineGridSize
	local tNgHeight = DefaultNineGridSize

	self.view = CCZXImage:imageWithFile( 0, 0, tWidth, tHeight, tImage, tNgWidth, tNgHeight, 0, 0, 0, 0, 0, 0 )
end
