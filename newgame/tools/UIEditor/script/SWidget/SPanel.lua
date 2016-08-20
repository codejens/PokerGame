--SPanel.lua
--create by tjh on 2015.7.12
--面板控件

SPanel = simple_class(STouchBase)

--面板控件创建函
--@param img背景 可选
--@param width,height 宽高 可选 默认原图大小 -1,-1
--@param is_nine是否九宫格 可选
function SPanel:create(img, width, height, is_nine, parent, zorder)
	-- body
	local img = img or ""
	--引擎潜规则 九宫格判定方法
	local nine_size = 0
	if is_nine then
		nine_size = 500
	end
	local view = CCBasePanel:panelWithFile(0, 0, width or -1, height or -1, img, nine_size,nine_size)
	if parent ~= nil then
		if parent.view ~= nil then
			if zorder ~= nil then
				parent.view:addChild(view,zorder)
			else
				parent.view:addChild(view)
			end
		else
			if zorder ~= nil then
				parent:addChild(view,zorder)
			else
				parent:addChild(view)
			end
		end
	end
	return self(view)
end

function SPanel:quick_create(x, y, w, h, img, is_nine, parent, zOrder)
	-- body
	local img = img or ""
	w = w or -1
	h = h or -1
	--引擎潜规则 九宫格判定方法
	local nine_size = 0
	if is_nine then
		nine_size = 500
	end
	local view = CCBasePanel:panelWithFile(x, y, w, h, img, nine_size,nine_size)
	local obj = self(view)
	obj.x = x
	obj.y = y
	obj.size = view:getContentSize()
	obj:addTo(parent,zOrder)
	return obj
end

function SPanel:create_by_layout(layout)

	local nine_size = 0
	if layout.is_nine then
		nine_size = 500
	end

	local view = CCBasePanel:panelWithFile(layout.pos[1],layout.pos[2], layout.size[1] ,
		layout.size[2], layout.img_n, nine_size,nine_size)
	return self(view,layout)
end

--构造函数
function SPanel:__init(view,layout)
	STouchBase.__init(self,view,layout)
end

function SPanel:setTexture(path)
	self.view:setTexture(path)
end

--设置锚点
function SPanel:setAnchorPoint(x, y)
	self.view:setAnchorPoint(x or 0, y or 0)
end

function SPanel:getSize()
	return self.view:getSize()
end