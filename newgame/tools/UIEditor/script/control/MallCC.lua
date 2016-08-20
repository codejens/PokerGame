-- filename: MallCC.lua
-- author: created by fanglilian on 2012-12-25
-- function: 该文件实现“商城系统”数据模型

-- super_class.MallCC();

MallCC = {}

local cmd_id_mall = 12;

-- 12.1, C->S
-- 购买商城物品
-- item_tag: 购买商城物品的标示，不是物品的ID
-- buy_count: 购买数量
-- use_count: 使用数量，如果购买后不马上使用，则写0
function MallCC:req_buy_mall_item(item_tag, buy_count, use_count, money_type)
	-- print("=======MallCC:req_buy_mall_item(item_tag, buy_count, use_count, money_type)", item_tag, buy_count, use_count, money_type)
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 1);
	pack:writeInt(item_tag);
	pack:writeInt(buy_count);
	pack:writeInt(use_count);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.1, S->C
-- 购买商城物品返回
function MallCC:do_buy_mall_item(pack)
	-- print("12.1, S->C 购买商城物品返回")
	local flag = pack:readByte();

    -- 如果成功，就回调通用的购买窗口
    if ( flag == 1 ) then
    	require "UI/common/BuyKeyboardWin"
    	BuyKeyboardWin:cb_buy_mall_item();
    	SoundManager:playUISound('buy_item',false)
    end
end

-- 12.2, C->S
-- 查询商城销量排行
function MallCC:req_mall_sales_chart()
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 2);
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.2, S->C
-- 返回商城销量排行
function MallCC:do_mall_sales_chart(pack)
	-- print("12.2, S->C 返回商城销量排行")
	-- 销量记录数量(unsigned short)
	local count = pack:readWord();
	local hot_sell_list = {}
	require "struct/MallSellItemStruct"
    for i = 1, count do
        hot_sell_list[i] = MallSellItemStruct(pack)
    end
    require "model/MallModel"
    -- MallModel:set_hot_sell_list( hot_sell_list )
end

-- 12.3, C->S
-- 查询可提取元宝数量
function MallCC:req_available_yuanbao_count()
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 3);
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.3, S->C
-- 返回玩家可提取元宝数量
function MallCC:do_available_yuanbao_count(pack)
	-- print("12.3, S->C 返回玩家可提取元宝数量")
	-- 玩家可提取元宝数量(unsigned int)
	local yuanbao_count = pack:readUint();
	-- TODO
end

-- 12.4, C->S
-- 请求提取元宝
function MallCC:req_get_yuanbao(yuanbao_count)
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 3);
	-- 请求提取元宝数量(unsigned int)
	pack:writeUInt(yuanbao_count);
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.5, C->S
-- 改变商城购物是否广播标记
function MallCC:req_change_broadcast_flag()
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 5);
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.5, S->C
-- 广播刷新分类，通知客户端可以获取
function MallCC:do_broadcast_refresh_category(pack)
	-- print("12.5, S->C 广播刷新分类，通知客户端可以获取")
	-- 分类的ID,1表示限时抢购(unsigned char)
	local category_id = pack:readByte();
end

-- 12.6, C->S
-- 获取限制物品的剩余时间和剩余数量
function MallCC:req_left_time_count()
	-- print("发送请求  12.6, C->S 获取限制物品的剩余时间和剩余数量")
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 6);
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.6, S->C
-- 限购商品的数目发生改变
function MallCC:do_count_changed(pack)
	-- print("12.6, S->C限购商品的数目发生改变")
	-- 商品的ID(unsigned int)
	-- 该商品剩余数目(int)
	-- 分类的ID(unsigned char)
	local item_id = pack:readUint();
	local left_count = pack:readInt();
	local category_id = pack:readByte();
	require "model/MallModel"
	MallModel:change_limit_sell_item_num( item_id, left_count, category_id )
end

-- 12.7, C->S
-- 获取商城特价商品列表
function MallCC:req_bargain_list( ... )
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 7);
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.7, S->C
-- 下发商城特价商品列表
function MallCC:do_bargain_list(pack)
	-- print("12.7, C->S 获取商城特价商品列表")
	
	local left_time = pack:readInt();       -- 商品的剩余时间(int)
	local item_count = pack:readInt();      -- 物品数量(int)
	local limit_sell_list = {}
	require "struct/MallSellItemStruct"
	for i=1, item_count do
		limit_sell_list[i] = MallSellItemStruct(pack)
	end

    require "model/MallModel"
    MallModel:set_limit_time( left_time )
    MallModel:set_limit_sell_item_list( limit_sell_list )
    
end

-- 12.8, C->S
-- 拉取团购界面    tuangou_type: 1:返还元宝界面  2.团购界面
function MallCC:req_tuangou( tuangou_type )
	-- print("12.8, C->S ", tuangou_type)
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 8);
	pack:writeInt( tuangou_type )
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.8, S->C
-- 下发返回元宝界面 
function MallCC:do_back_yuanbao(pack)
	-- print("12.8, S->C ")
	
	-- local can_get_back_yuanbao = pack:readInt();       -- 可领取返回元宝数(int)
	local had_get_back_yuanbao_total = pack:readInt();       -- 累计领取的返还元宝数(int)

    TuangouModel:set_back_yuanbao_info( had_get_back_yuanbao_total )
end

-- 12.9, S->C
-- 下发团购界面
function MallCC:do_tuangou(pack)
	-- print("12.9, S->C ")
    local count = pack:readInt()          -- 团购物品数量
    local tuangou_items_list = {}         -- 团购物品列表
    for i = 1, count do 
        local one_item = TuangouItemStruct( pack )
        table.insert( tuangou_items_list, one_item )
    end

    TuangouModel:set_tuangou_item_list( tuangou_items_list )
    
end

-- 12.9, C->S
-- 团购购买物品 tuangou_type 物品索引，即 1 2 类    下发协议 9
function MallCC:buy_tuangou_item( tuangou_type)
	-- print("12.9, C->S")
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 9);
	pack:writeInt( tuangou_type )
	NetManager:get_socket():SendToSrv(pack);
end

-- 12.10, C->S
-- 领取返回元宝    下发协议 8    
function MallCC:get_back_yuanbao(  )
	-- print("12.10, C->S " )
	local pack = NetManager:get_socket():alloc(cmd_id_mall, 10);
	NetManager:get_socket():SendToSrv(pack);
end

-- 无此项命令
function MallCC:do_error( ... )
	-- print ("Error! MallCC.lua, do_error(), no such kind of process.");
end

function MallCC:init_mall_cc()
	local func = {};
	func[1] = MallCC.do_buy_mall_item;
	func[2] = MallCC.do_mall_sales_chart;
	func[3] = MallCC.do_available_yuanbao_count;
	func[4] = MallCC.do_error;
	func[5] = MallCC.do_broadcast_refresh_category;
	func[6] = MallCC.do_count_changed;
	func[7] = MallCC.do_bargain_list;
	func[8] = MallCC.do_back_yuanbao;
	func[9] = MallCC.do_tuangou;
	return func;
end






