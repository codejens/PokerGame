-----------------------------------------------------------------------------
-- 所有控件的基类<br/> <code>抽象类</code>
-- @author lushan
-- @release 1
-----------------------------------------------------------------------------

--!class GUIBase

GUIBase 		= simple_class()
	
--- 成员变量
-- @class table
-- @name members
-- @field core cpp控件对象

--- 构造函数
-- @param core cpp控件对象
-- @see members
function GUIBase:__init(core,layout)
	if core == nil then 
		print( "create UI, the core is nil" )
        return
	end
	self.core = core
	-- if layout then
	-- 	self.layout = layout
	-- 	if layout.flip then
	-- 		self:setFlip(layout.flip[1],layout.flip[2])
	-- 	end
	-- end

end

--设置翻转
function GUIBase:setFlip( bx,by )
	self.core:setFlipX(bx)
	self.core:setFlipY(by)
end

function GUIBase:create_by_layout()
	print("GUIBase:create_by_layout")
end

--- 设置控件大小
-- @param w 宽度
-- @param h 高度
-- @usage setContentSize(1,2)
function GUIBase:setContentSize( w,h )
	self.core:setContentSize(cc.size(w,h))
end

function GUIBase:setScale9Enabled(enable)
	self.core:setScale9Enabled(enable)
end

--获取宽高
function GUIBase:getContentSize(  )
	return self.core:getContentSize()
end

function GUIBase:getString()
	if self.core then
		return self.core:getString()
	end
end

--设置缩放
function GUIBase:setScale( x,y )
	if y then
		self.core:setScale(x,y)
	else
		self.core:setScale(x)
	end

end

--设置位置
function GUIBase:setPosition( x,y )
	self.core:setPosition(x,y)
end

--- 获取控件位置
-- @return 控件位置
function GUIBase:getPosition( x,y )
	return self.core:getPosition()
end

--设置锚点
function GUIBase:setAnchorPoint( x,y )
	self.core:setAnchorPoint(x,y)
end

--设置是否隐藏
function GUIBase:setVisible( vis)
	self.core:setVisible(vis)
end

--获取是否隐藏状态
function GUIBase:isVisible( )
	return self.core:isVisible()
end

--添加子节点
function GUIBase:addChild( child, localZOrder, tag )
	if not child then return end
	if tag then
		self.core:addChild( child.core or child ,localZOrder or 0, tag)
	else
		self.core:addChild( child.core or child ,localZOrder or 0)
	end
end

--移除子节点
--@param child 子节点
--@param cleanup是否删除回调跟动作
function GUIBase:removeChild( child,cleanup )
	self.core:removeChild(child,cleanup)
end

--从父节点移除自己
--@param cleanup是否删除回调跟动作
function GUIBase:removeFromParent( cleanup )
	self.core:removeFromParent(cleanup)
end

function GUIBase:setTouchEnabled(enable)
	if self.core then
		self.core:setTouchEnabled(enable)
	end
end

function GUIBase:setTag(tag)
	if self.core then
		self.core:setTag(tag)
	end
end