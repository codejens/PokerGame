---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------自动换行文档框,默认锚点为左上角
require "XWidget/base/XAbstructPanel"

super_class.XTextArea(XAbstructPanel)

local _insert_max_num = 9999

---------
---------
function XTextArea:__init(width, height)

	local tImage = ""
	local tWidth = width
	local tHeight = height
	local tNum = _insert_max_num

	self.view = CCDialogEx:dialogWithFile( 0, 0, tWidth, tHeight, tNum, "", TYPE_VERTICAL, ADD_LIST_DIR_UP )
	self.view:setAnchorPoint(0,1)
	self._scale_x = 1
	self._sclae_y = 1
	self:registerScriptFun()

end

---------
---------屏蔽设置图片方法
function XTextArea:setTexture(file)
	return
end

---------
---------屏蔽设置X翻转
function XTextArea:setFlipX(result)
	return
end

---------
---------屏蔽设置Y翻转
function XTextArea:setFlipY(result)
	return
end