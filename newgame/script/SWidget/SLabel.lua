--SLabel.lua
--create by tjh on 2015.7.13
--文字控件类

SLabel = simple_class(SWidgetBase)

function SLabel:__init(view, layout)
	SWidgetBase.__init(self, view, layout)
end

--创建文字控件函数
--@param str 文字
--@param FontSize字体大中 可选 默认FONT_DEF_SIZE 参考SWidgetConfig文件
--@param align对齐方式 可选 默认左对齐 参考SWidgetConfig文件  ALIGN_CENTER ALIGN_LEFT ALIGN_RIGHT
--@param scroll_type 文字方向
function SLabel:create(str, fontSize, align, scroll_type)
	local fontSize = fontSize or FONT_DEF_SIZE
	local align = align or ALIGN_DEFAULT
	local font_showType = scroll_type or FONT_HORIZONTAL 
	local view = CCZXLabel:labelWithText(0, 0, str, fontSize, align, font_showType)
	return self(view)
end

function SLabel:quick_create(str, x, y, parent, zOrder, fontSize, align, scroll_type)
	local fontSize = fontSize or FONT_DEF_SIZE
	local align = align or ALIGN_DEFAULT
	local font_showType = scroll_type or FONT_HORIZONTAL
	local view = CCZXLabel:labelWithText(x, y, str, fontSize, align, font_showType)
	local obj = self(view)
	obj:addTo(parent, zOrder)
	return obj
end

function SLabel:create_by_layout(layout)
	local font_showType = layout.scroll_type or FONT_HORIZONTAL
	local view = CCZXLabel:labelWithText(layout.pos[1], layout.pos[2], layout.str, layout.fontsize, layout.align, font_showType)
	return self(view, layout)
end

---------设置文本
function SLabel:setText(text)
	if self.view ~= nil then
		self.view:setText(text)
	end
end
---------
---------设置文本字体大小
function SLabel:setFontSize(fontSize)
	if self.view ~= nil then
		self.view:setFontSize(fontSize)
	end
end

---------取得文本内容
function SLabel:getText()
	if self.view ~= nil then
		return self.view:getText()
	else
		return ""
	end
end

---------取得文本范围
function SLabel:getSize()
	if self.view ~= nil then
		return self.view:getSize()
	else
		return {width = 0, height = 0}
	end
end

--设置颜色
function SLabel:set_color(color)
	self:setText(color..self:getText())
end
