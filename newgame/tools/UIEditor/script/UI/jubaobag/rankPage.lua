-- RankPage.lua
-- created by liuguowang on 2014-4-6
-- 角色属性窗口  user_attr_win

super_class.RankPage()


local _other_data = nil	

------------------------------
function scroll_create_item_rank(index, itemWidth, itemHeight, sizeInfo)
	---------------
  local list_vector = ZListVertical:create( nil, 0, 0, itemWidth, itemHeight, sizeInfo )
	-- local image = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png", -10, 0, itemWidth-5, 1)
	-- list_vector.view:addChild(image.view)
	-- print("!!!!!!!!!!!!!  index = ",index)
	-- print("!!!!!!!!!!!!  _other_data[index]=",_other_data[index])
	if _other_data[index] ~= nil then
		local index_label = ZLabel:create( nil, "#c7a3e1a" .. index, 0, 0 )
		local name_label =  ZLabel:create( nil, "#c7a3e1a" .. _other_data[index].player_name , 0, 0 )
		local score_label = ZLabel:create( nil, "#c7a3e1a" .. _other_data[index].player_score, 0, 0 )

		list_vector:addItem( index_label )
		list_vector:addItem( name_label )
		list_vector:addItem( score_label )
	end
	-- list_vector:addItem( index_label )
	-- list_vector:addItem( index_label )
	--list_vector:addItem( item_name )
	
	-- print("list_vector2")

	return list_vector
end

local function scroll_create_fun_rank(self, index)
	-- print("scroll_create_fun_rank index=",index)
	--require "UI/component/List"
	-- local panel_info = TopListModel:data_get_top_list_index_panel_info( _cur_index_select )
	local list_info = {vertical = 1, horizontal = 5}
	local size_info = { 45,85,60 }

	local list = ZList:create( nil, 0, 0, 180, 153, list_info.vertical, list_info.horizontal )
	for i = 1, list_info.horizontal do		
		local item = scroll_create_item_rank( index * list_info.horizontal + i,180, math.floor(153 / list_info.horizontal), size_info)
		list:addItem( item )
		-- print("list:addItem")
	end
	return list
	-- end
end

function RankPage:__init( bgPanel )

    self.bgPanel = ZBasePanel:create(bgPanel,nil,0, 105, 200,145, 500, 500)
    self.view = self.bgPanel
    self.rank_data = {}
---------------------------------------------------------------------------
	self.scroll = ZScroll:create( nil, nil, 0,0,200,142, 1, TYPE_HORIZONTAL )
	-- self.scroll:setScrollLump( 10, 20, 290 / 4 )
	-- self.scroll.view:setScrollLump( UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 20, 290 / 4 )
	--self.scroll.view:setTexture("ui/common/nine_grid_bg.png")
	self.scroll:setScrollCreatFunction(scroll_create_fun_rank)
	self.bgPanel.view:addChild( self.scroll.view )

	ZLabel:create(self.bgPanel,Lang.jubao.player_rank,5,149)
	ZLabel:create(self.bgPanel,Lang.jubao.player_name,57,149)
	ZLabel:create(self.bgPanel,Lang.jubao.player_score,140,149)
    -- self.bgPanel.view:addChild(list_ver.view)
end


function RankPage:active( bActive )
	ZXLog("RankPage:active( bActive )",bActive)
    if bActive then 
        OnlineAwardCC:req_get_jubaodai_rank() 
    end
end


--刷新所有属性数据
function RankPage:update(other_data )

	ZXLog("enter here")
	_other_data = other_data
	ZXLog("#_other_data=",#_other_data)
	if self.scroll ~= nil then
		-- local maxNum = math.floor(#_other_data/5)   
		-- if #_other_data%5 ~= 0 then
		-- 	maxNum = maxNum+1
		-- end
		-- print("maxNum=",maxNum)
		self.scroll.view:setMaxNum(1)
		self.scroll.view:clear()
		self.scroll.view:refresh()
	end
	-- for i=1,5 do
	-- 	self.rank_data[i].player_rank
	-- 	-- self.rank_data[i].player_rank.view:addChild("1")
	-- 	-- self.rank_data[i].player_id.view:addChild("1")
	-- 	-- self.rank_data[i].player_score.view:addChild("1")
	-- 	self.rank_data[i].id = other_data[i].player_id
	-- 	self.rank_data[i].id = other_data[i].player_name
	-- 	self.rank_data[i].id = other_data[i].player_score
	-- end
    
end
