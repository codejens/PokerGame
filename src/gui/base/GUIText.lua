-----------------------------------------------------------------------------
-- 文字控件
-- @author tjh,liubo
-- @release 2
-----------------------------------------------------------------------------

--!class GUIText
-- @see GUITouchBase
GUIText = simple_class(GUITouchBase)

--默认配置
local _fontsize = FONT_SIZE_NORMAL
local _alignment = cc.TEXT_ALIGNMENT_LEFT 

--- 构造函数
-- @param core ccui.Text控件对象
-- @see members
function GUIText:__init( core )
	
end

--- 创建文字控件函数
-- @param string 内容 默认""
-- @param fontsize  字号 字号传入常量（config.lua），不要传入魔法数字 默认FONT_SIZE_NORMAL 
-- @param alignment  对齐方式  默认cc.TEXT_ALIGNMENT_LEFT 
function GUIText:create(string,fontsize,alignment)
	local label = self(ccui.Text:create())
	label:setString(string or "")
	label:setFontSize(fontsize or _fontsize)
	label:setTextHorizontalAlignment(alignment or _alignment)
	return label
end

--- 设置内容函数
-- @param text 内容 
function GUIText:setString( text )
	self.core:setString(text)
end

--- 设置字体大小
-- @param size 大小
function GUIText:setFontSize( size )
	self.core:setFontSize(size)
end

--- 设置文字对齐方式
-- @param alignment 对齐方式  = cc.TEXT_ALIGNMENT_LEFT  cc.TEXT_ALIGNMENT_RIGHT  cc.TEXT_ALIGNMENT_CENTER
function GUIText:setTextHorizontalAlignment( alignment )
	self.core:setTextHorizontalAlignment(alignment)
end

--- 设置字体名称
-- @param name  系统字体，传一个字体名称的参数 TTF字体，传一个TTF字体的文件路径
-- @usage setFontName("Marfelt") 或 setFontName("xxxx/xxx.ttf")
function GUIText:setFontName( name )
	self.core:setFontName(name)
end

--- 字体阴影
-- @param r, g, b, a 阴影颜色，分别代表Red、Green、Blue和Alpha，默认黑色(0, 0, 0, 255)，可选
-- @param offset_x, offset_y 阴影偏移量，默认（2，-2），可选
-- @param blur_radius 模糊半径，默认0，可选
-- @usage enableShadow(0, 0, 0, 255, 2, -2, 0) 
function GUIText:enableShadow( r, g, b, a, offset_x, offset_y, blur_radius )
	local shadow_color, offset
	if not r or not g or not b or not a then
		shadow_color = cc.c4b(0, 0, 0, 255)
	else
		shadow_color = cc.c4b(r, g, b, a)
	end
	if not offset_x or not offset_y then
		offset = cc.size(2, -2)
	else
		offset = cc.size(offset_x, offset_y)
	end
	if not blur_radius then
		blur_radius = 0
	end
	self.core:enableShadow(shadow_color, offset, blur_radius)
end

---字体描边 只支持TTF
-- @param r, g, b, a 描边颜色，分别代表Red、Green、Blue和Alpha
-- @param outline_size 描边宽度，默认1，可选
-- @usage enableOutline(0, 0, 0, 255, 2) 
function GUIText:enableOutline( r, g, b, a, outline_size )
	local outline_color = cc.c4b(r, g, b, a)
	if not outline_size then
		outline_size = 1
	end
	self.core:enableOutline(outline_color, outline_size)
end