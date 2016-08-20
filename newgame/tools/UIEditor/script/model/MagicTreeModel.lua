-- MagicTreeModel.lua
-- create by chj on 2015-3-16
-- 昆仑神树Model

MagicTreeModel = {}

-- 活动id 
MagicTreeModel.ACT_ID = 16
-- 成熟
-- MagicTreeModel.maturity_all = 6

-- ==========================
-- 状态 ------------------
-- ==========================
MagicTreeModel.REC_OWN = 0
MagicTreeModel.REC_FRI = 1

-- 浇水状态
MagicTreeModel.WATER_NOT = 0
MagicTreeModel.WATER_YES = 1

-- 收获状态
MagicTreeModel.RECEIVE_NOT = 0
MagicTreeModel.RECEIVE_YES = 1

-- 果实类型（1蓝色果实，2紫色果实，3金色果实）
MagicTreeModel.TYPE_BLUE = 1
MagicTreeModel.TYPE_PERPLE = 2
MagicTreeModel.TYPE_GOLD = 3

-- data
-- 主界面数据
MagicTreeModel.main_info = {
        player_id = nil,
        player_name = nil, 
        maturity = nil, 
        remaintime_water = nil, 
        num_fruit = nil, 
        fruit_tabel = {}, -- type, index
}

-- 好友收获日志列表
MagicTreeModel.fri_rec_log = {}
-- 自己的收获日志
MagicTreeModel.own_opr_log = {}

-- 好友列表
MagicTreeModel.friendlist = {}
-- 积分
MagicTreeModel.point = 0


MagicTreeModel.data_rec_fri = {}

MagicTreeModel.data_rec_own = {}

-- 好友数据
MagicTreeModel.data_fri_list = {}

-- 昆仑神树仓库列表
local _magictree_cangku_table   = {};                   --仓库列表

function MagicTreeModel:fini( ... )
	print("MagicTreeModel:fini( ... )")
        _magictree_cangku_table         = {};                   --仓库列表
end

-- 获取活动时间
function MagicTreeModel:get_actvity_time( )
        local t_remainTime = SmallOperationModel:get_act_time(MagicTreeModel.ACT_ID)
        return t_remainTime
end

-- 获取活动id
function MagicTreeModel:get_act_id( )
    return self.ACT_ID
end

-- 获取成熟度
-- function MagicTreeModel:get_maturity()
--         return self.maturity_all
-- end

-- =======================================
-- 仓库 ---start------------------------
-- =======================================
-- 存放入仓库物品 ALL
function MagicTreeModel:set_cangku_item_all( cangku_table, num_point)
        _magictree_cangku_table = cangku_table
        self.point = num_point
        local win = UIManager:find_visible_window("magictree_cangku_win")
        if win then
                win:update()
        end
end

--往仓库列表插入一个物品
function MagicTreeModel:add_cangku_item( key, value )
        _magictree_cangku_table[key] = value;
end

-- 往仓库列表末尾加一个物品
function MagicTreeModel:add_cangku_item_end( item )
        _magictree_cangku_table[#_magictree_cangku_table+1] = item;
end

-- 删除仓库某个物品
function MagicTreeModel:remove_cangku_item_by_GUID( guid )
        -- body
        for i,v in ipairs(_magictree_cangku_table) do
                if v.series == guid then
                        table.remove(_magictree_cangku_table,i);
                end
        end
end

function MagicTreeModel:get_item_in_cangku_by_index( index )
        if #_magictree_cangku_table ~= 0 then
                return _magictree_cangku_table[index];
        end
end

--获取仓库列表
function MagicTreeModel:get_cangku_table( )
        -- body
        return _magictree_cangku_table;
end

--清空仓库列表
function MagicTreeModel:clear_cangku_table( )
        -- if #_dreamland_cangku_table ~= 0 then
        --      for i=1,#_dreamland_cangku_table do
        --              table.remove(_dreamland_cangku_table);
        --      end
        -- end
        _magictree_cangku_table = {}
end

-- 获取仓库积分
function MagicTreeModel:get_point( )
    return self.point
end

-- 刷新积分
function MagicTreeModel:set_point( point )
    self.point = point
    local win = UIManager:find_visible_window("magictree_cangku_win")
    if win then
            win:update("point")
    end
end


-- =========================================
-- 仓库 ---ended------------------------
-- =========================================

-- =========================================
-- 服务器请求 & 返回数据处理
-- =========================================
-- 请求神树界面信息
-- function MagicTreeModel:req_magictree_info( player_id)
--         MagicTreeCC:req_magictree_info( player_id)
-- end

-- 处理神树界面信息
function MagicTreeModel:do_magictree_info( player_id, player_name, maturity, remaintime_water, num_fruit, fruit_tabel)
        self.main_info.player_id = player_id
        self.main_info.player_name = player_name
        self.main_info.maturity = maturity or 0
        if remaintime_water < 0 then
               self.main_info.remaintime_water = 0 
        else
                self.main_info.remaintime_water = remaintime_water
        end
        self.main_info.num_fruit = num_fruit
        self.main_info.fruit_tabel = fruit_tabel
        local win = UIManager:find_visible_window("magictree_win")
        if win then
                win:update("main")
        end
end

-- 获取当前显示的神树的玩家id
function MagicTreeModel:get_cur_player_id( )
        return self.main_info.player_id
end

--获取主界面信息
function MagicTreeModel:get_main_info()
        return self.main_info
end

-- 刷新好友收获日志
function MagicTreeModel:setFriendReceiveLog( fri_rec_log)
        self.fri_rec_log = fri_rec_log
        local win = UIManager:find_visible_window("magictree_win")
        if win then
                win:update("fri_rec_log")
        end
end
-- 获取好友收获日志
function MagicTreeModel:getFriendReceiveLog( )
        return self.fri_rec_log
end

-- 刷新自己收获日志
function MagicTreeModel:setOwnOperationLog( own_opr_log)
        self.own_opr_log = own_opr_log
        local win = UIManager:find_visible_window("magictree_win")
        if win then
                win:update("own_opr_log")
        end
end
-- 获取自己收获日志
function MagicTreeModel:getOwnOprLog( )
        return self.own_opr_log
end

-- 刷新好友列表数据
function MagicTreeModel:setFriendList( friendlist )
        self.friendlist = friendlist
        local win = UIManager:find_visible_window("magictree_win")
        if win then
                win:update("friend_lsit")
        end
end
-- 获取好友列表
function MagicTreeModel:getFriendList()
-- print("--------self.friendlist[]:", self.friendlist[1].water_state, self.friendlist[1].rec_state)
        return self.friendlist
end



-- 
-- 获取收获日志数据
function MagicTreeModel:get_data_rec( _type)
	if _type == MagicTreeModel.REC_OWN then
		return self.data_rec_own
	elseif _type == MagicTreeModel.REC_FRI then
		return self.data_rec_fri
	end
end

-- 获取好友列表数据
function MagicTreeModel:get_data_friend_list( )
	return MagicTreeModel.data_fri_list
end

-- 获取果实的位置
function MagicTreeModel:get_fruit_pos()
        return MagicTreeConfig:get_fruit_position( )
end


-- 更具item_id 获取item_icom
function MagicTreeModel:get_icon_by_id( item_id )
        local icon_path = "icon/item/"
        local icon_id = string.format( "%05d", item_id)
        return icon_path .. icon_id .. ".pd"
end

-- 获取果实item_id 获取果实的序号（1,2,3）
function MagicTreeModel:get_fruit_index_by_item_id( item_id)
    local fruit_t = MagicTreeConfig:get_fruit_item_tabel()
    for i=1, #fruit_t do
        if fruit_t[i] == item_id then
            return i
        end
    end
end