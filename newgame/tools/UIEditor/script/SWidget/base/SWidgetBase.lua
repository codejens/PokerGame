--SWidgetBase.lua
--create by tjh on 2015.7.12
--控件抽象类
--所有控件 派生这个类 .view是具体C++控件 所以控件基本都支持九宫格 看需求添加创建方法

SWidgetBase = simple_class()

--构造函数
--@param view是具体C++控件
function SWidgetBase:__init( view,layout )
	self.view = view
	self.edit_key = nil

	if layout then
		self.layout = layout
	end
end

--@param width height宽高
function SWidgetBase:setSize( width,height )
	if self.view.setSize then
		self.view:setSize(width or 0, height or 0)
	end
end

function SWidgetBase:setIsVisible( visible )
	self.view:setIsVisible(visible)
end

--设置位置
function SWidgetBase:setPosition( x, y )
	self.view:setPosition( x or 0, y or 0 )
end

--获取位置
function SWidgetBase:getPosition(  )
    local x,y = self.view:getPosition()
    return x,y
end

--设置锚点
function SWidgetBase:setAnchorPoint( x, y )
	self.view:setAnchorPoint( CCPointMake( x or 0, y or 0 ) )
end

--设置缩放
function SWidgetBase:setScale( x,y )
	if x then
		self.view:setScaleX(x)
	end
	if y then 
		self.view:setScaleY(y)
	end
end

--添加节点
function SWidgetBase:addChild( item,zOrder )
	if not item then
		return
	end
	if item.view then
		self:addChild(item.view,zOrder or 0)
	else
		self.view:addChild(item,zOrder or 0)
		return
	end
end

--设置tag
function SWidgetBase:setTag( tag )
	self.view:setTag(tag)
end

--从父节点删除自己
function SWidgetBase:removeFromParentAndCleanup( is_clean )
	self.view:removeFromParentAndCleanup(is_clean)
end

--删除一个子节点
function SWidgetBase:removeChild( child,is_clean )
	self.view:removeChild(child, is_clean)
end
