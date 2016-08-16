--STouchPanel.lua
--create by tjh on 2015.7.12
--面板控件

STouchPanel = simple_class(SPanel)

--面板控件创建函
--@param x,y 坐标 必选
--@param w,h 宽高 必选
--@param parent 父节点 	 可选
--@param zOrder zorder层 可选
function STouchPanel:create(x, y, w, h, parent, zOrder)
	local layout = {
		pos = {x,y},
		size = {w,h},
	}
	local view = STouchPanel:create_by_layout(layout)
	view:addTo(parent, zOrder)
	return view
end

function STouchPanel:create_by_layout(layout)
	local view = CCTouchPanel:touchPanel(layout.pos[1], layout.pos[2], layout.size[1] ,layout.size[2])
	view:setTexture(layout.img_n or "")
	return self(view,layout)
end

--构造函数
function STouchPanel:__init(view, layout)
	SPanel.__init(self, view, layout)
end