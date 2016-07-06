-----------------------------------------------------------------------------
-- BMFont控件
-- @author liubo
-- @release 1
-----------------------------------------------------------------------------

--!class GUIBMFont
GUIBMFont = simple_class(GUITouchBase)

--- 构造函数
-- @param view BMFont控件对象
-- @see members
function GUIBMFont:__init(view)
	
end

--- 创建函数
-- @param text 文本内容
-- @param filename FNT文件路径
-- @usage GUIBMFont:create() GUIBMFont:create("1234","res/ui/bmfont.fnt")
function GUIBMFont:create(text, filename)
	if text and filename then
		return self(ccui.TextBMFont:create(text, filename))
	else
		return self(ccui.TextBMFont:create())
	end
end

--- 设置字体
-- @param filename FNT文件路径
-- @usage setFntFile("res/ui/bmfont.fnt")
function GUIBMFont:setFntFile(filename)
	self.view:setFntFile(filename)
end

--- 设置文本内容
-- @param text 文本内容
-- @usage setString("1234")
function GUIBMFont:setString(text)
	self.view:setString(text)
end

--- 获取文本内容
-- @usage getString()
function GUIBMFont:getString()
	return self.view:getString()
end

--- 获取文本长度
-- @usage getStringLength()
function GUIBMFont:getStringLength()
	return self.view:getStringLength()
end