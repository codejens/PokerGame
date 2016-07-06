--GUINode.lua
--节点
-----------------------------------------------------------------------------
-- 节点类
-- @author lushan
-- 
-----------------------------------------------------------------------------

--!class GUINode
-- @see GUIBase
GUINode = simple_class(GUIBase)

--- 构造函数
-- @param view cc.Node控件对象
-- @see members
function GUINode:__init( view )
	
end

--创建节点函数
function GUINode:create()
	return self(cc.Node:create())
end
