-- filename: NPCTradeCC.lua
-- author: created by fanglilian on 2012-12-26
-- function: NCP交易子系统

-- super_class.NPCTradeCC();
NPCTradeCC = {}

local npc_cmd_id=133;

-- 133.1, C->S
-- 从NPC商店或者背包商店买东西
-- item_id: 涉及的物品ID(unsigned short)
-- item_count: 涉及的物品数量(unsigned short)
-- npc_no:	NPC的编号(unsigned short)(用来表示是哪个NPC，0表示背包商店 )
function NPCTradeCC:req_buy_from_npc(item_id, item_count, npc_no)
	local pack = NetManager:get_socket():alloc (npc_cmd_id, 1);
	pack:writeWord(item_id);
	pack:writeWord(item_count);
	pack:writeWord(npc_no);
	NetManager:get_socket():SendToSrv(pack);
end

-- 133.1, S->C
-- 从商店购买了一件物品
function NPCTradeCC:do_get_res_from_shop(pack)
	-- 物品的guid(unsigned int64)
	local res_guid = pack:readUint64();
	-- 物品的数量(unsigned short)
	local res_count = pack:readWord();
end

-- 133.2, C->S
-- 购买声望物品
-- item_id: 物品的ID(unsigned short)
-- count: 购买的数量(unsigned short)
-- level: 物品品质等级(unsigned char)
-- en_level: 物品强化等级(unsigned char)
-- groud_id: 组号ID(unsigned char)(购买的组号ID)
function NPCTradeCC:req_buy_exp_item(item_id, count, level, en_level, groud_id)
	local pack = NetManager:get_socket():alloc (npc_cmd_id, 2);
	pack:writeWord(item_id);
	pack:writeWord(count);
	pack:writeByte(level);
	pack:writeByte(en_level);
	pack:writeByte(groud_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 133.2, S->C
-- NPC交易结果
function NPCTradeCC:do_trade_result(pack)
	-- 交易类型unsigned char, 
	-- 1 购买, 2 售卖, 3 回购
	local trade_type = pack:readByte();
	-- 交易涉及的物品GUID(unsigned int64)
	local item_guid = pack:readUint64();
	-- 涉及的物品的数量(unsigned char)
	local item_count = pack:readByte();

end

-- 133.3, C->S
-- 请求背包购买的物品的列表
function NPCTradeCC:req_bag_item_list()
	local pack = NetManager:get_socket():alloc (npc_cmd_id, 3);
	NetManager:get_socket():SendToSrv(pack);
end

-- 133.3, S->C
-- 客户端获得NPC交易物品数据
function NPCTradeCC:do_get_item_data(pack)
	-- print("133.3, S->C 客户端获得NPC交易物品数据")
	-- NPC交易品表长度(unsigned char)
	local list_length = pack:readByte();
	-- print("133.3  客户端获得NPC交易物品数据。。。。。。。。。。", list_length)
	-- NPC交易品数据项(struct)
	-- {
	--    {
	-- 	 string 售卖标签名, 
	-- 	 byte 售卖物品长度, 
	-- 	 array 物品ID{word, word,...} 
	--    }
	--    {
	-- 	 string 售卖标签名,
	-- 	 byte 售卖物品长度,
	-- 	 array 物品ID{word, word,...}
	--    }
	--    ...
	-- }
	-- NPC出售的编号，0表示背包的商店(unsigned char)
	local sold_id = pack:readByte();
	require "model/ShopModel"
    ShopModel:open_shop_by_npc_id( sold_id )
end

-- 133.4, C->S
-- 出售物品给商店
-- item_guid: 物品的GUID(unsigned int64)
function NPCTradeCC:req_sell_res_to_shop(res_id)
	local pack = NetManager:get_socket():alloc (npc_cmd_id, 4);
	pack:writeUint64(res_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 133.4, S->C
-- 成功出售一件物品给商店
function NPCTradeCC:do_sold_res_to_shop(pack)
	-- 物品的GUID(unsigned int64)
	local series = pack:readUint64();
	ShopModel:sell_item_success( series )
end

-- 133.5, C->S
-- 从商店回购物品
-- res_guid: 物品的GUID(unsigned int64)
-- npc_id: NPC的ID，随时商店是0(unsigned short)
function NPCTradeCC:req_buy_res_from_shop(res_guid, npc_id)
	print("res_guid, npc_id",res_guid, npc_id)
	local pack = NetManager:get_socket():alloc (npc_cmd_id, 5);
	pack:writeUint64(res_guid);
	pack:writeWord(npc_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 133.5, S->C
-- 成功回购一件物品
function NPCTradeCC:do_buyback_res(pack)
	-- 物品的GUID(unsigned int64)
	local res_guid = pack:readUint64();
end

function NPCTradeCC:req_buy_honor_item( item_id,item_num,item_pz,item_qh,item_group )
	print(" NPCTradeCC:req_buy_honor_item",item_id,item_num,item_pz,item_qh,item_group )
	local pack =  NetManager:get_socket():alloc (npc_cmd_id, 6);
	pack:writeWord(item_id)
	pack:writeWord(item_num)
	pack:writeByte(item_pz)
	pack:writeByte(item_qh)
	pack:writeByte(item_group)
	NetManager:get_socket():SendToSrv(pack);
end

--聚仙令兑换
function NPCTradeCC:req_buy_jxl_item( item_id,item_num,item_pz,item_qh,item_group )
	local pack =  NetManager:get_socket():alloc (npc_cmd_id, 7);
	pack:writeWord(item_id)
	pack:writeWord(item_num)
	pack:writeByte(item_pz)
	pack:writeByte(item_qh)
	pack:writeByte(item_group)
	NetManager:get_socket():SendToSrv(pack);
end







