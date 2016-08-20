--SScroll.lua
--create by tjh on 2015.7.13
--滑动控件

SScroll = simple_class(STouchBase)

function SScroll:__init(view, layout)
	STouchBase.__init(self, view, layout)
	self.move_height = 0
	--self:set_touch_func(SCROLL_CREATE_ITEM,func)
end

--创建滑动控件
--@param tWidth,tHeight 宽高
--@param img 背景图片 可选
--@param is_nine 可选是够九宫格
--@param tType 类型 垂直或水平 默认垂直TYPE_HORIZONTAL 参考SWidgetConfig
function SScroll:create(tWidth, tHeight, img, is_nine, tType)
	local ni_size = 0
	if is_nine then
		ni_size = 500 
	end
	local tType = tType or TYPE_HORIZONTAL
	local view = CCScroll:scrollWithFile(0, 0, tWidth, tHeight, 0, img or "", tType,ni_size,ni_size)
	-- view:setCurIndex(row_num-7)

	return self(view)
end

function SScroll:create_by_layout(layout)
	local ni_size = 0
	if layout.is_nine then
		ni_size = 500 
	end
	local view = CCScroll:scrollWithFile(
		layout.pos[1], layout.pos[2], layout.size[1],
		layout.size[2], 0, layout.img_n, layout.scroll_type, ni_size, ni_size
	)

	return self(view,layout)
end

--[[
常用更新
cur_index,要显示第几个,c++默认从0开始
max_show_count,最多同时显示多少个
--]]
function SScroll:update(max_num, cur_index, max_show_count)
	cur_index = cur_index or 1
	if cur_index > max_num or cur_index < 1 then
		cur_index = 1
	end
	if max_show_count ~= nil then
		if max_num > max_show_count then
			local max_show_index = max_num-max_show_count+1
			if cur_index > max_show_index then
				cur_index = max_show_index
			end
		end
	end
	self:clear()
	self:setMaxNum(max_num)
	self.view:setCurIndex(cur_index-1)
	self:refresh()
end


function SScroll:setMaxNum(max_num)
	self.view:setMaxNum(max_num)
end

function SScroll:clear()
	self.view:clear()
end

function SScroll:refresh()
	self.view:refresh()
end

function SScroll:addItem(item)
	if item.view then
		return self.view:addItem(item.view)
	end
	return self.view:addItem(item)
end

function SScroll:setPosition(x, y)
	self.view:setPosition(x, y)
end

-- 设置间距
function SScroll:setGapSize(g)
	self.view:setGapSize(g)
end

--自动滚动到指定位置 目前只支持竖向方向
--还没做好
function SScroll:autoRunPositon( height,time )
	local _height = height - self.move_height
	self.move_height = height
	self.view:autoRunPositon(CCPoint(0,_height),0)
end