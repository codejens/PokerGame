-----------------------------------------------------------------------------
-- 输入框
-- @author zengsi
-----------------------------------------------------------------------------

--!class GUITextField
-- @see GUITouchBase
GUITextField = simple_class(GUITouchBase)

function GUITextField:__init( core )
	self.class_name = "GUITextField"	
end

function GUITextField:create_by_layout(layout)
	local textField = self(ccui.TextField:create())
	if layout.str then
		textField:setPlaceHolder(layout.str)
	end
	if layout.maxnum then
		textField:setMaxLengthEnabled(true)
		textField:setMaxLength(layout.maxnum)
	end
	if layout.fontsize then
		textField:setFontSize(layout.fontsize)
	end
	if layout.pos then
		textField:setPosition(layout.pos[1],layout.pos[2])
	end
	return textField
end

function GUITextField:create()
	return self(ccui.TextField:create())
end

--设置占位符
function GUITextField:setPlaceHolder(place_holder_text)
	if self.core then
		self.core:setPlaceHolder(place_holder_text)
	end
end

function GUITextField:setFontSize(font_size)
	if self.core then
		self.core:setFontSize(font_size)
	end
end

function GUITextField:setFontName(font_name)
	if self.core then
		self.core:setFontName(font_name)
	end
end

function GUITextField:setString(str)
	if self.core then
		self.core:setString(str)
	end
end

function GUITextField:setMaxLengthEnabled(is_maxlength)
	if self.core then
		self.core:setMaxLengthEnabled(is_maxlength)
	end
end

function GUITextField:setMaxLength(length)
	if self.core then
		self.core:setMaxLength(length)
	end
end


