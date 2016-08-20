---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------文本类
require "XWidget/base/XAbstructNode"

super_class.XLabel(XAbstructNode)

local _default_font_size = 16
local _default_align_state = ALIGN_LEFT

---------
---------
function XLabel:__init(text)
	local tText = text or ""
	self.view = CCZXLabel:labelWithText( 0, 0, tText, _default_font_size, _default_align_state )
	self._text_info = text
end

---------
---------设置文本字体大小
function XLabel:setFontSize(size)
	self.view:setFontSize(size)
end

---------
---------设置内容
function XLabel:setText(text)
	self.view:setText(text)
	self._text_info = text
end

---------
---------取得不带格式文本内容
function XLabel:getText()
	return self.view:getText()
end

---------
---------取得带格式文本内容
function XLabel:getStyleText()
	return self._text_info
end