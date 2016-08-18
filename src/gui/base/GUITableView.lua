-----------------------------------------------------------------------------
-- 滚动控件
-- @author zengsi
-- @release 1
-----------------------------------------------------------------------------

GUITableView = simple_class(GUIBase)

function GUITableView:__init( view )
	self.class_name = "GUITableView"
	self.max_num = 0
	self.is_regist = false
	self.size = {1,1}
	self.tag_touch = {}
	self.touch_func = {}
	-- self:setTouchEnabled(false)
end

--创建图片控件函数
--@param texture 贴图资源
function GUITableView:create(width,height)
	width = width or 100
	height = height or 100
	return self(cc.TableView:create(cc.size(width,height)))
end

function GUITableView:quick_create(x,y,w,h,dir_type,vertical_type)

end

function GUITableView:create_by_layout(layout)
	local dir_type = layout.dir_type or cc.SCROLLVIEW_DIRECTION_HORIZONTAL
	local vertical_type = layout.vertical_type or cc.TABLEVIEW_FILL_TOPDOWN
	local table_view = self(self:create(layout.size[1],layout.size[2]).core)
	local item_size = layout.item_size or {80,80}
	table_view:setPosition(layout.pos[1],layout.pos[2])
	table_view:setDirection(dir_type)
	table_view:setDelegate()
	table_view.item_size = item_size
	-- table_view.size = layout.size
	-- table_view:setVerticalFillOrder(vertical_type)
	return table_view
end

function GUITableView:setDirection(dir_type)
	if self.core then
		self.core:setDirection(dir_type)
	end
end

function GUITableView:numberOfCellsInTableView()
	return self.max_num
end

function GUITableView:cellSizeForTable(p1,p2)
	return self.item_size[1],self.item_size[2]
end


function GUITableView:tableCellAtIndex(table, idx)
	local cell = table:dequeueCell()
	local func = self.touch_func[cc.TABLECELL_SIZE_AT_INDEX]
	if func then
		cell = func(cell,idx+1)
	end
	cell = cell or cc.TableViewCell:new()
	for tag , callback in pairs(self.tag_touch) do
		print("tag----------",tag)
		local btn = cell:getChildByTag(tag)
		if btn then
			local function touch_event_func(sender,eventType)
				-- if eventType == ccui.TouchEventType.ended then
					callback(idx+1)
				-- end
			end
			btn:addClickEventListener(touch_event_func)
		end
	end
	return cell
end

function GUITableView:set_item_size(s_w,s_h)
	self.size = {s_w,s_h}
end

function GUITableView:update(max_num)
	self.max_num = max_num
	if self.is_regist == false then
		self.core:registerScriptHandler(bind(self.numberOfCellsInTableView,self),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
		self.core:registerScriptHandler(bind(self.cellSizeForTable,self),cc.TABLECELL_SIZE_FOR_INDEX)
		self.core:registerScriptHandler(bind(self.tableCellAtIndex,self),cc.TABLECELL_SIZE_AT_INDEX)
		self.is_regist = true
	end 
	self:reloadData()
end

function GUITableView:addTagTouch(tag,func)
	self.tag_touch[tag] = func
end

function GUITableView:setVerticalFillOrder(vertical_type)
	if self.core then
		self.core:setVerticalFillOrder(vertical_type)
	end
end

function GUITableView:setDelegate()
	if self.core then
		self.core:setDelegate()
	end
end

function GUITableView:set_refresh()

end

--重写
function GUITableView:set_touch_func(func,touch_type)
	self.touch_func[touch_type] = func
end

function GUITableView:reloadData()
	if self.core then
		self.core:reloadData()
	end
end
