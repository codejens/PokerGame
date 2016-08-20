---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------普通面板,初始化时节点包围大小取图片大小
require "XWidget/base/XAbstructPanelNormal"

super_class.XPanelNormal(XAbstructPanelNormal)

---------
---------
function XPanelNormal:__init(image)

	local tImage = image or ""
	local tWidth = DefaultNodeSize
	local tHeight = DefaultNodeSize

	if image then
		local tempSize = ZXResMgr:sharedManager():getTextureSize(image)
		tWidth = tempSize.width
		tHeight = tempSize.height
	end
	
	self.view = CCBasePanel:panelWithFile( 0, 0, tWidth, tHeight, tImage, 0, 0, 0, 0, 0, 0, 0, 0 )
	self._scale_x = 1
	self._sclae_y = 1
	self:registerScriptFun()

end

