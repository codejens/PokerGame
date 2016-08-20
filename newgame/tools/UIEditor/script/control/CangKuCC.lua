-- filename: CangKuCC.lua
-- author: created by Hardgame on 2012-12-12
-- 功能：本文件实现仓库子系统网络数据交互

-- super_class.CangKuCC();

CangKuCC = {}

-- 23.1, C->S
-- 获取仓库物品列表
function CangKuCC:req_cangku_items()
	local pack = NetManager:get_socket():alloc(23, 1);
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.2, C->S
-- 背包拖一个物品到仓库
-- item_id: 物品的guid
-- target_id: 目标位置物品的guid, 如果为0表示放在空的格子上面
function CangKuCC:req_bag_to_cangku (item_series, target_series)
	local pack = NetManager:get_socket():alloc(23, 2);
	pack:writeInt64(item_series);
	pack:writeInt64(target_series);
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.3, C->S
-- 仓库拖一个物品到背包
-- item_id: 物品的guid
-- target_id: 目标位置物品的guid, 如果为0表示放在空的格子上面
function CangKuCC:req_cangku_to_bag (item_series, target_series)
	local pack = NetManager:get_socket():alloc(23, 3);
	pack:writeInt64(item_series);
    pack:writeInt64(target_series);
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.4, C->S
-- 丢弃仓库物品
-- item_id: 物品的guid
function CangKuCC:req_del_item (item_id)
	local pack = NetManager:get_socket():alloc(23, 4);
	pack:writeUint64(item_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.5, C->S
-- 扩展仓库格子数量
function CangKuCC:req_expand_grid_count (money_type)
	local pack = NetManager:get_socket():alloc(23, 5);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.6, C->S
-- 获取扩展仓库格子的费用列表
function CangKuCC:req_cost_for_expand_grid ()
	local pack = NetManager:get_socket():alloc(23, 6);
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.1, S->C
-- 下发仓库的物品列表
function CangKuCC:do_item_list (pack)
	print("服务器通知：", "下发仓库的物品列表")
	-- unsigned char, 物品的数量
	local item_count = pack:readByte();
	-- array(UserItem), 仓库的物品列表
	local items = {};
	for i=1, item_count do
		items[i] = UserItem(pack);
	end
    CangKuItemModel:set_items_date( items, item_count )
end

-- 23.2, S->C
-- 添加物品
function CangKuCC:do_add_item (pack)
	print("服务器通知：", "仓库添加物品")
	local item = UserItem(pack);
    CangKuItemModel:add_item( item )
end

-- 23.3, S->C
-- 删除物品
function CangKuCC:do_del_item (pack)
	print("服务器通知：", "仓库删除物品")
	-- 物品的guid
	local item_series = pack:readInt64();
	CangKuItemModel:remove_item_from_cangku( item_series )
end

-- 23.4, S->C
-- 仓库的物品数量发生改变
function CangKuCC:do_items_changed (pack)
	print("服务器通知：", "仓库的物品数量发生改变")
	-- 物品的guid
	local item_series = pack:readUint64();
	-- 物品的新数量
	local item_new_count = pack:readByte();

	CangKuItemModel:change_item_attr( item_series, "count", item_new_count )
end

-- 23.5, S->C
-- 发送仓库扩展需要的费用
function CangKuCC:do_cost_for_expand_cangku(pack)
	print("服务器通知：", "发送仓库扩展需要的费用")
	-- 需要的元宝数量
	local yuanbao_count = pack:readInt();
	-- 扩展的背包的格子数量
	local grid_count = pack:readByte();
    
    CangKuWin:show_expand_bag_confirm_win( yuanbao_count, grid_count )
end

-- 23.7, C->S
-- 拆分仓库物品
-- item_id: 拆分物品的GUID
-- count: 拆分出来的物品数量
function CangKuCC:req_seperate_cangku_item(item_id, count)
	print("服务器通知：", "拆分仓库物品")
	local pack = NetManager:get_socket():alloc(23, 7);
	pack:writeInt64(item_id);
	pack:writeByte(count);
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.8, C->S
-- 合并仓库物品
-- src_id: 源物品的guid
-- dst_id: 目标物品的guid
function CangKuCC:req_merge_items(src_id, dst_id)
	print("服务器通知：", "合并仓库物品")
	local pack = NetManager:get_socket():alloc(23, 8);
	pack:writeInt64(src_id);
	pack:writeInt64(dst_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 23.9, C->S
-- 整理仓库物品
function CangKuCC:req_trim_cangku()
	print("服务器通知：", "整理仓库物品")
	local pack = NetManager:get_socket():alloc(23, 9);
	NetManager:get_socket():SendToSrv(pack);
end

function CangKuCC:init_cangku_cc()
	local func = {};
	func[1] = CangKuCC.do_item_list;
	func[2] = CangKuCC.do_add_item;
	func[3] = CangKuCC.do_del_item;
	func[4] = CangKuCC.do_items_changed;
	func[5] = CangKuCC.do_cost_for_expand_cangku;

	return func;
end