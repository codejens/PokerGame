---Widget 控件
--!class GUIWidget
-- @see GUITouchBase
GUIWidget = simple_class(GUITouchBase)


--- 构造函数
-- @param view ccui.Widget控件对象
-- @see members
function GUIWidget:__init( view )
	
end

--创建一个Widget
function GUIWidget:create()
	return self(ccui.Widget:create())
end
