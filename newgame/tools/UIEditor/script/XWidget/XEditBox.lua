---------HJH
---------2014-9-20
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------自动换行文档框,默认锚点为左上角
require "XWidget/base/XAbstructPanel"

super_class.XEditBox(XAbstructPanel)

local _insert_max_num = 9999

---------
---------
function XEditBox:__init(width, height)

	local tImage = ""
	local tWidth = width
	local tHeight = height
	local tNum = _insert_max_num

	self.view = CCBasePanel:panelWithFile( 0, 0, tWidth, tHeight, "", 0, 0, 0, 0 ,0 ,0 )
	self._edit_box = CCDialogEx:dialogWithFile( 0, 0, tWidth, tHeight, tNum, "", TYPE_VERTICAL, ADD_LIST_DIR_UP )
	self._edit_box.
	self._label = CCZXLabel:labelWithText( 0, 0, "")
	self.view:setAnchorPoint(0,1)
	self._scale_x = 1
	self._sclae_y = 1
	self:registerScriptFun()

end

---------
---------屏蔽设置图片方法
function XEditBox:setTexture(file)
	return
end

---------
---------屏蔽设置X翻转
function XEditBox:setFlipX(result)
	return
end

---------
---------屏蔽设置Y翻转
function XEditBox:setFlipY(result)
	return
end

---------
---------
--function 