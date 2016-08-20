---------HJH
---------2014-5-6
---------X通用控件
---------
----------------------------------------------------------------------
----------------------------------------------------------------------
---------Notic:
---------抽象节点类，只提供方法
---------注意X控件只适应于X类派生的控件，关于这个问题已在2.0解决，并统一成一套脚本控件
super_class.XAbstructNode()

DefaultNodeSize = 1

---------
---------
function XAbstructNode:__init()

	-------
	-------用于指当前父节点，如果父节点为一个LUA对象，则不可通过CCNode::getParent获得一个LUA对象
	self.father_panel = nil
	self.view = nil

end

---------
---------设置位置
function XAbstructNode:setPosition(x, y)
	--cancel safe check
	--if self.view ~= nil then
	self.view:setPosition(x, y)
	--end
end

---------
---------取得位置
function XAbstructNode:getPosition()
	--cancel safe check
	--if self.view ~= nil then
	return self.view:getPositionS()
	--end
end

---------
---------添加一个子节点
function XAbstructNode:addChild(item)
	--cancel safe check
	--if self.view ~= nil then
	if item.view ~= nil then
		self.view:addChild(item.view)
	else
		self.view:addChild(item)
	end
	--end
end

---------
---------设置锚点
function XAbstructNode:setAnchorPoint(x,y)
	--cancel safe check
	--if self.view ~= nil then
	self.view:setAnchorPoint(x, y)
	--end
end

---------
---------取得锚点
function XAbstructNode:getAnchorPoint()
	return self.view:getAnchorPoint()
end

---------
---------设置显隐
function XAbstructNode:setIsVisible(result)
	self.view:setIsVisible(result)
end

---------
---------取得显隐
function XAbstructNode:getIsVisible()
	return self.view:getIsVisible()
end

---------
---------设置缩放
function XAbstructNode:setScale(arg)
	self.view:setScale(arg)
end

---------
---------取得缩放
function XAbstructNode:getScale()
	return self.view:getScale()
end

---------
---------设置X缩放
function XAbstructNode:setScaleX(arg)
	self.view:setScaleX(arg)
end

---------
---------取得X缩放
function XAbstructNode:getScaleX()
	return self.view:getScaleX()
end

---------
---------设置Y缩放
function XAbstructNode:setScaleY(arg)
	self.view:setScaleY(arg)
end

---------
---------取得Y缩放
function XAbstructNode:getScaleY(arg)
	return self.view:getScaleY()
end