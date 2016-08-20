-- TableView.lua
-- create by hcl on 2013-1-14
-- 表格控件

super_class.TableView()

-- 面板
local panel = nil;
-- 面板的高
local panel_height = 0;
-- 子控件的宽和高
local item_width = 0;
local item_height = 0;
-- 所有子控件的列表,暂时每个item是btn
local tab_view = {};

function TableView:create(parent,panel_x,panel_y,col_num,row_num,item_width,item_height)
	return TableView(parent,panel_x,panel_y,col_num,row_num,item_width,item_height);
end

function TableView:__init( window_name, parent,panel_x,panel_y,col_num,row_num,item_width,item_height)
	panel_height = row_num * item_height;
	item_width = item_width;
	item_height = item_height;
	panel = CCBasePanel:panelWithFile(panel_x,panel_y, col_num * width , panel_height ,nil,0,0);
	parent:addChild(panel);
end

-- 添加一个item到最后
function TableView:add_item(item)
	local tab_len = #tab_view;
	tab_view[ tab_len ] = item;

end

function TableView:remove_item(item_index)
	-- 删除指点控件
	tab_view[item_index]:removeFromParentAndCleanup(true);
	table.remove(tab_view,item_index);
	-- 更新后面的控件
	for i=item_index,#tab_view do
		local pos_x = (item_index-1) % 4 * item_width;
		local pos_y = panel_height - math.floor((item_index-1) / 4) * item_height;
		tab_view[item_index]:setPosition( pos_x ,pos_y );
	end
end