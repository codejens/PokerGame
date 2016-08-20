--STextArea.lua
--create by tjh on 2015.7.13
--文本控件

STextArea = simple_class(SWidgetBase)

function STextArea:__init(view, layout)
	SWidgetBase.__init(self,view,layout)
end

function STextArea:create(tWidth, tHeight, fontsize)
	local fontsize = fontsize or FONT_DEF_SIZE
	local view = CCDialogEx:dialogWithFile(0, 0, tWidth, tHeight, 1000, "", TYPE_VERTICAL, ADD_LIST_DIR_UP)
	view:setFontSize(fontsize)
	view:setAnchorPoint(0,1)
	return self(view)
end

function STextArea:create_by_layout(layout)
	local nine_size = 0
	if layout.is_nine then
		nine_size = 500
	end
	local view = CCDialogEx:dialogWithFile(layout.pos[1],layout.pos[2], layout.size[1] ,
		layout.size[2], 1000, layout.img_n, TYPE_VERTICAL, ADD_LIST_DIR_UP,nine_size,nine_size)
	view:setFontSize(layout.fontsize or FONT_DEF_SIZE)
	view:setAnchorPoint(0,1)
	view:setText(layout.str)
	return self(view,layout)
end

function STextArea:setText(str)
	self.view:setText(str)
end

function STextArea:setFontSize(fontsize)
	self.view:setFontSize(fontsize)
end

--设置行距
function STextArea:setLineEmptySpace(num)
	self.view:setLineEmptySpace(num)
end

--获取多行的高度
function STextArea:getInfoSize()
	return self.view:getInfoSize()
end