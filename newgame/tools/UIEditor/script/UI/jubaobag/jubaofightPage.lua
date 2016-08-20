
-- JubaoFightPage.lua
-- created by liuguowang on 2014-4-6
-- 角色属性窗口  user_attr_win

super_class.JubaoFightPage()


local function scroll_create_item_fight(item_data,index, itemWidth, itemHeight, sizeInfo)
	---------------
					print(" index = ",index)
					print("itemWidth  = ",itemWidth)
					print("itemHeight  = ",itemHeight)
  			local list_vector = ZListVertical:create( nil, 0, 0, itemWidth, itemHeight, sizeInfo )
		-- if #item_table > 0 then
				--动态model数据
				--查询item的静态配置
			local item = item_data[index]
			local item_config = ItemConfig:get_item_by_id(item.id);
				--item名字
			local color = "#c"..ItemConfig:get_item_color(item_config.color+1);
			local item_name = string.format(color..LangGameString[883],tostring(item_config.name)); -- [883]="【%s】"
			local item_name_label =  ZLabel:create( nil, item_name , 0, 0 )
			  	--item数量
			local count_str = string.format("#cfff000x%d",item.count);
			local item_count_label =  ZLabel:create( nil, count_str , 0, 0 )
			list_vector:addItem( item_name_label )
			list_vector:addItem( item_count_label )
		-- end

		print("list_vector2")

	return list_vector
end

local function scroll_create_fun_fight(self, index)
	print("scroll_create_fun_fight index=",index)
	--require "UI/component/List"
	-- local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
	local list_info = {vertical = 1, horizontal = 5}
	local size_info = { 130,70 }
	local item_table = DreamlandModel:get_item_table(); --  1 10 50
	print("#item_table=",#item_table)
	local list = ZList:create( nil, 0, 0, 180, 153, list_info.vertical, list_info.horizontal )
	for i = 1, list_info.horizontal do	
		if index * list_info.horizontal + i <= #item_table then
			local item = scroll_create_item_fight(item_table, index * list_info.horizontal + i,180, math.floor(153 / list_info.horizontal), size_info)
			list:addItem( item )
			print("list:addItem")
		end
	end
	return list
	-- end
end

function JubaoFightPage:__init( bgPanel )

    self.bgPanel = ZBasePanel:create(bgPanel,nil,0, 105, 200,155, 500, 500)
    self.view = self.bgPanel
    print("------------------------------------------------------------------------2")
---------------------------------------------------------------------------
	local item_table = DreamlandModel:get_item_table(); --  1 10 50
	-- local page_count = math.floor(#item_table/5) 
	-- if #item_table%5 ~= 0 then
	-- 	page_count = page_count + 1
	-- end
	-- print("page_count=",page_count)
	self.scroll = ZScroll:create( nil, nil, 0,0,186,142, 1, TYPE_HORIZONTAL )--maxnum写1 ，update里重设置
	-- self.scroll:setScrollLump( 10, 20, 290 / 4 )
	-- self.scroll.view:setScrollLump( UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 20, 290 / 4 )
	--self.scroll.view:setTexture("ui/common/nine_grid_bg.png")
	self.scroll:setScrollCreatFunction(scroll_create_fun_fight)
	self.scroll.view:setScrollLump( UIResourcePath.FileLocate.jubaobag .. "up_progress.png", UIResourcePath.FileLocate.jubaobag .. "down_progress.png", 4, 10, 200 )
	self.bgPanel.view:addChild( self.scroll.view )

	ZLabel:create(self.bgPanel,Lang.jubao.item_name,20,149)
	ZLabel:create(self.bgPanel,Lang.jubao.item_num,140,149)

	if self.scroll ~= nil then
		self.scroll.view:refresh()
	end
end



--刷新所有属性数据
function JubaoFightPage:update(  )
	local max_num = DreamlandModel:get_item_table_size(); --  1 10 50
	if self.scroll ~= nil and max_num > 0 then
		local page_count = math.floor(max_num/5)
		if max_num%5 ~= 0 then
			page_count = page_count+1
		end
		print("page_count=",page_count)
		self.scroll.view:setMaxNum(page_count)
		self.scroll.view:clear()
		self.scroll.view:refresh()
	end
end



-- 打开或者关闭是调用. 参数：是否激活
function JubaoFightPage:active( show )

end