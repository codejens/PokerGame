-- BagCC.lua 
-- created by lyl on 2015-4-28
-- 背包 系统事物处理


BagCC = {}

local _MAX_GRID_NUM = 100 -- 最大格子数

function BagCC:init(  )


	-- 事件中心时间处理注册
	-- 背包视图激活
 --    notifySystem:listenNotify( NOTICE_V_BAG_ACTIVE, BagCC, BagCC.update_bag_win_all )
 --    -- 背包道具列表变更
 --    notifySystem:listenNotify( NOTICE_M_BAG_ITEM_LIST, BagCC, BagCC.update_bag_item_list )
    

	-- -- 请求背包列表
	-- PacketDispatcher:send_protocol( PROTOCOL_ID_C_8_2  )
end

function BagCC:finish( ... )
	BagCC = {}
end

-- 处理下发背包道具列表协议
local function p_bag_list( item_count, item_list_t )
	print("p_bag_list ::: ")
	BagModel:set_item_list_t( item_list_t )
    BagCC:update_bag_item_list(  )
end


-- 注册要处理的协议
function BagCC:register_protocol(  )
	-- PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_8_4, p_bag_list )
end





------------------------------------------
--- 回调
------------------------------------------
-- 道具单击   item_index:第几个道具被点击
function BagCC:item_click( item_index )
    local userItem = BagModel:get_item_by_index( item_index )
    if userItem == nil then 
        return
    end
    -- lp todo 显示tips
end




------------------------------------------
-- 更新视图 函数
------------------------------------------
-- 刷新背包视图所有内容
function BagCC:update_bag_win_all(  )
	BagCC:update_bag_item_list(  )
end

-- 更新背包道具列表
function BagCC:update_bag_item_list(  )
	
	local itemList = BagModel:get_item_list_t(  )  -- 道具列表
	local openGridNum = EntityManager:get_player_avatar_attr( "bagVolumn" )
    
    local update_data = {
        itemListData = itemList,
        openNum = openGridNum,
        maxNum = _MAX_GRID_NUM
    }                          -- 更新需要的结构

    local win = GUIManager:find_window( "common" )
    if win then 
        win:update( UPDATE_BAG_ITEMLIST, update_data )
    end
end

