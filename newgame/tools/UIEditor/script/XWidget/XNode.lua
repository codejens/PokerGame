---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------节点类
---------本应self.view为一个CCNode,但由于引擎原因，1.1版本就用着CCBasePanel代替先
require "XWidget/base/XAbstructPanel"

super_class.XNode(XAbstructPanel)

---------
---------
function XNode:__init(width, height)

	local tWidth = width or DefaultNodeSize
	local tHeight = height or DefaultNodeSize
	self.view = CCBasePanel:panelWithFile( 0, 0, tWidth, tHeight, "", 0, 0, 0, 0, 0, 0, 0, 0 )
	self:registerScriptFun()

end

---------
---------屏蔽设置图片方法
function XNode:setTexture(file)
	return
end

---------
---------屏蔽设置X翻转
function XNode:setFlipX(result)
	return
end

---------
---------屏蔽设置Y翻转
function XNode:setFlipY(result)
	return
end