--SWidgetBase.lua
--create by tjh on 2015.7.12
--控件抽象类
--所有控件 派生这个类 .view是具体C++控件 所以控件基本都支持九宫格 看需求添加创建方法

SWidgetBase = simple_class()

--构造函数
--@param view是具体C++控件
function SWidgetBase:__init(view,layout)
	self.view = view
	self.edit_key = nil

	if layout then
		self.layout = layout

		if layout.flip then
			self:setFlip(layout.flip[1],layout.flip[2])
		end
	end
end

--@param width height宽高
function SWidgetBase:setSize(width,height)
	self.view:setSize(width or 0, height or 0)
end

function SWidgetBase:getSize()
	return self.view:getSize()
end

function SWidgetBase:getContentSize()
	return self.view:getContentSize()
end

function SWidgetBase:setIsVisible(visible)
	self.view:setIsVisible(visible)
end

function SWidgetBase:getIsVisible()
	return self.view:getIsVisible()
end

--设置位置
function SWidgetBase:setPosition(x, y)
	self.view:setPosition(x or 0, y or 0)
end

--设置位置
function SWidgetBase:setPositionX(x)
	self.view:setPositionX(x or 0)
end

--设置位置
function SWidgetBase:setPositionY(y)
	self.view:setPositionY(y or 0)
end

--获取位置
function SWidgetBase:getPosition()
    local x,y = self.view:getPosition()
    return x,y
end

--设置锚点
function SWidgetBase:setAnchorPoint(x, y)
	self.view:setAnchorPoint(CCPoint(x or 0, y or 0))
end

function SWidgetBase:addTexWithFile(state,path)
	self.view:addTexWithFile(state,path)
end

--设置缩放
function SWidgetBase:setScale(x,y)
	if x then
		self.view:setScaleX(x)
	end
	if y then 
		self.view:setScaleY(y)
	end
	if not y then
		self.view:setScale(x)
	end
end

--添加节点
function SWidgetBase:addChild(item,zOrder)
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

--添加到哪个父节点
function SWidgetBase:addTo(parent,zOrder)
	if not parent then return end
	if parent.view then
		parent.view:addChild(self.view,zOrder or 0)
	else
		parent:addChild(self.view,zOrder or 0)
	end
end

--设置tag
function SWidgetBase:setTag(tag)
	self.view:setTag(tag)
end

--从父节点删除自己
function SWidgetBase:removeFromParentAndCleanup(is_clean)
	self.view:removeFromParentAndCleanup(is_clean)
end

--删除一个子节点
function SWidgetBase:removeChild(child,is_clean)
	self.view:removeChild(child, is_clean)
end

--设置翻转
function SWidgetBase:setFlip(bx,by)
	self.view:setFlipX(bx)
	self.view:setFlipY(by)
end

function SWidgetBase:setFlipX(bx)
	self.view:setFlipX(bx)
end

function SWidgetBase:setFlipY(by)
	self.view:setFlipY(by)
end

function SWidgetBase:runAction(action)
	if self.view then
		self.view:runAction(action)
	end
end

function SWidgetBase:stopAllActions()
	if self.view then
		self.view:stopAllActions()
	end
end

--设置文字方向
function SWidgetBase:setComposeType(n_type)
	if self.view then
		self.view:setComposeType(n_type)
	end
end

--替换图片
function SWidgetBase:setTexture(path)
	if self.view then
		self.view:setTexture(path)
	end
end

