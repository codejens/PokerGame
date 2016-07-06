-----------------------------------------------------------------------------
-- 按钮控件
-- @author tjh
-- @release 2
-----------------------------------------------------------------------------

--!class GUIButton
-- @see GUITouchBase
GUIButton = simple_class(GUITouchBase)

--- 构造函数
-- @param view ccui.Button控件对象
-- @see members
function GUIButton:__init(view)
	self.class_name = "GUIButton"
	-- self.init_count = self.init_count or 1
	-- self.init_count = self.init_count + 1
end

function GUIButton:create_by_layout(layout)
	local btn = self(ccui.Button:create())
	if Utils:has_value(layout.img_n) then
		btn:setTextureNormal(layout.img_n)
	end
	if Utils:has_value(layout.img_s) then
		btn:setTexturePressed(layout.img_s)
	end
	if Utils:has_value(layout.str) then
		btn:setTitleText(layout.str,layout.fontsize)
	end
	btn:setPosition(layout.pos[1],layout.pos[2])
	btn:setContentSize(layout.size[1],layout.size[2])
	btn:setScale9Enabled(true)
	return btn
end

--- 创建按钮函数
-- @param normal_img 正常贴图资源 可选参数
-- @param pressed_img 按下贴图 可选参数
function GUIButton:create(normal_img,pressed_img)
	local btn =  self(ccui.Button:create())
	if normal_img then
		btn:setTextureNormal(normal_img)
	end
	if pressed_img then
		btn:setTexturePressed(pressed_img)
	end
	return btn
end

--- 设置正常图片
-- @param texture 正常贴图资源 
function GUIButton:setTextureNormal( texture )
	self.core:loadTextureNormal(texture)
end

--- 设置禁用图片
-- @param texture 禁用贴图资源 
function GUIButton:setTextureDisabled( texture )
	self.core:loadTextureDisabled(texture)
end

--- 设置按下图片
-- @param texture 按下贴图资源 
function GUIButton:setTexturePressed( texture )
	self.core:loadTexturePressed(texture)
end

--- 设置按钮文字
-- @param text 按钮文字
-- @param fontsize 文字大小 可选参数 默认正常大小 见配置FONT_SIZE_NORMAL
function GUIButton:setTitleText( text,fontsize )
	self.core:setTitleText(text)
	self:setTitleFontSize(fontsize or FONT_SIZE_NORMAL)
end

--- 设置按钮文字字体大小
-- @param size 字体大小
function GUIButton:setTitleFontSize( size )
	self.core:setTitleFontSize(size)
end

--- 设置按钮文字颜色
--@param r，g，b 颜色
function GUIButton:setTitleColor(r, g, b)
	self.core:setTitleColor(cc.c3b(r, g, g))
end

--- 设置按钮文字字体
--@param fontname 字体
function GUIButton:setTitleFontName( fontname )
	self.core:setTitleFontName(fontname)
end

