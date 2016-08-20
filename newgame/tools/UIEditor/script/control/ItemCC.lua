-- ItemCC.lua
-- created by aXing on 2012-11-30
-- 道具系统

-- super_class.ItemCC()

ItemCC = {}

-- 申请删除背包的一个道具
function ItemCC:request_remove_bag_item( series )
	local pack = NetManager:get_socket():alloc(8, 1)
	pack:writeUint64(series)
	NetManager:get_socket():SendToSrv(pack)
end

-- 8.1 s->c 服务器删除一个背包道具
function ItemCC:do_remove_bag_item( pack )
	-- print(" 服务器删除一个背包道具  ")
	local series = pack:readUint64()
	-- ItemModel:remove_bag_item(series)
	-- print("ItemCC:do_remove_bag_item...", series);
	ItemModel:do_del_bag_item( series )
	SoundManager:playUISound('drop_item',false)
end

-- 8.2 C-> S, 申请获取玩家背包物品列表
function ItemCC:request_player_bag_items(  )
	-- local pack = NetManager:get_socket():alloc(8, 2)
	-- NetManager:get_socket():SendToSrv(pack)
	NetManager:get_socket():SendCmdToSrv(8, 2)
end

-- 8.2 服务器添加一个背包道具
function ItemCC:do_add_bag_item( pack )
	-- print("8.2 服务器添加一个背包道具")
	local new_item = UserItem(pack)
	ItemModel:add_bag_item(new_item)


--	bagWin = UIManager:show_window("bagWin") --跳转到角色选择界面
--	bagWin:show_role_sele()            --必须放入角色，才调用show方法，显示角色选择item
--	bagWin:show_bag_items();
	
end

-- 获取扩展背包格子的费用列表
function ItemCC:request_expend_bag_cost_list(  )
	-- local pack = NetManager:get_socket():alloc(8, 3)
	-- NetManager:get_socket():SendToSrv(pack)
	NetManager:get_socket():SendCmdToSrv(8, 3)
end

-- 8.3 S->C 服务器认为物品数量发生改变
function ItemCC:do_bag_count_changed( pack )
	-- print("8.3 S->C 服务器认为物品数量发生改变")
	local series 	= pack:readUint64()
	local new_count	= pack:readWord()
	ItemModel:change_item_attr( series, "count", new_count )
	-- print("new count = " .. new_count);
	-- print("===============ItemCC:do_bag_count_changed======================  ",  series, "count", new_count )
	-- ItemModel:update_bag_item_count(series, new_count)
end

-- 申请扩展背包
function ItemCC:request_expend_bag( money_type )
    -- print(" 发送申请扩展背包 ")
	local pack = NetManager:get_socket():alloc(8, 4)
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack)
	-- NetManager:get_socket():SendCmdToSrv(8, 4)
end

-- 8.4 S->C
-- 服务器初始化玩家的背包物品
function ItemCC:do_init_bag( pack )
	--print("8.4 服务器初始化玩家的背包物品")
	local count = pack:readWord()
	local new_items = {}
	for i = 1, count do
		new_items[i] = UserItem(pack)
	end
	ItemModel:set_bag_data(count, new_items)
end

-- 申请拆分背包道具
function ItemCC:request_split_item( series, count )
	local pack = NetManager:get_socket():alloc(8, 5)
	pack:writeInt64(series)
	pack:writeWord(count)
	NetManager:get_socket():SendToSrv(pack)
end

-- 8.5, S->C
-- 发送背包扩展需要的费用
function ItemCC:do_expend_cost( pack )
    -- print("8.5 发送背包扩展需要的费用")
	local money_count = pack:readInt();	-- 需要的元宝数量
	local grid_count = pack:readByte(); -- 扩展的背包的格子数量
    
    BagModel:show_expand_bag_confirm_win( money_count, grid_count )
end


-- 请求合并背包的格子 C->S
-- srcID: 源物品GUID(int64)
-- dstID: 目标物品的GUID(int64)
function ItemCC:req_merge_item (srcID, dstID)
	local pack = NetManager:get_socket():alloc(8, 6);
	pack:writeInt64(srcID);
	pack:writeInt64(dstID);
	NetManager:get_socket():SendToSrv(pack);
end

-- 使用物品 C->S
-- item_id: 物品的GUID
-- extended: 扩展参数, 如果是宠物的装备的话，表示宠物id
function ItemCC:req_use_item (item_series, ext_param)
	local pack = NetManager:get_socket():alloc(8, 7);
	pack:writeInt64(item_series);
	pack:writeInt(ext_param);
	NetManager:get_socket():SendToSrv(pack);
	-- print("ItemCC:req_use_item (item_series, ext_param)",item_series, ext_param)
end

-- 8.8 处理一件装备(强化，镶嵌等通用) C->S
-- item_count: 物品的GUID个数, (byte)
-- id_items: 物品GUID列表 (array, int64)
-- htype: 处理的类型 (byte)
-- param_count: 参数的个数 (byte)
-- param_arr: 参数的列表 (array, int)
function ItemCC:req_handle_item (item_count, id_items, htype, param_count, param_arr)
	-- print("=============================ItemCC:req_handle_item==", htype)
	local pack = NetManager:get_socket():alloc(8, 8);
	pack:writeByte(item_count)

	for i=1, item_count do
		 -- print("i=",i)
		 -- print("id_items[i]=",id_items[i])
		pack:writeInt64(id_items[i]);
		
		-- print(id_items[i])
	end
	pack:writeByte(htype);
	-- print(htype)
	pack:writeByte(param_count);
	for i=1, param_count do
		pack:writeInt (param_arr[i]);
		-- print("param....................."..param_arr[i])
	end
	NetManager:get_socket():SendToSrv(pack);
	-- print("==========================================================8, 8")
end

-- 特殊，请求免费洗练次数
function ItemCC:req_free_xilian_count()
	-- print("............................请求免费洗练次数.........................................")
	local pack = NetManager:get_socket():alloc(8, 8);
	pack:writeByte(0)
	pack:writeByte(10)
	pack:writeByte(0);
	NetManager:get_socket():SendToSrv(pack);
end


-- 8.9 C->S
-- 获取处理一件装备需要的消耗 
-- item_id: 物品的GUID(int64)
-- htype: 处理的类型(byte)
-- param_count: 参数个数(byte)
-- param_list: 参数列表(array, int)
function ItemCC:req_lost_energy(item_id, htype, param_count, param_list)
	local pack = NetManager:get_socket():alloc(8, 9);
	pack:writeInt64(item_id);
	pack:writeByte(htype);
	pack:writeByte(param_count);
	for i=1, param_count do
		pack:writeInt(param_list[i]);
	end
	NetManager:get_socket():SendToSrv(pack);
end

-- 8.6 S->C
-- 通知客户端装备处理的消耗(比如强化)
function ItemCC:do_lost_energy (pack)
	-- print("8.6 通知客户端装备处理的消耗(比如强化)")
	local lost_energy = {};
	lost_energy.item_id = pack:readUint64();		-- 物品的GUID
	lost_energy.item_count = pack:readByte();		-- 消耗物品的数量
	lost_energy.money_type = pack:readByte();		-- 金钱类型
	lost_energy.money_count = pack:readInt();		-- 金钱数量
	lost_energy.lost_item_id = pack:readWord();	-- 消耗物品的ID(强化石的ID)
	llost_energy.item_type = pack:readByte(); 		-- 物品的处理类型

	-- TODO with lost_energy...
end

-- 8.10, C->S
-- 获取物品处理的一些配置
-- item_conf_id: 物品配置的ID(byte)
function ItemCC:req_item_conf(item_conf_id)
	local pack = NetManager:get_socket():alloc(8, 10);
	pack:writeByte(item_conf_id);
	NetManager:get_socket():SendToSrv(pack);
end

-- 8.7, S->C
-- 下发物品的配置
function ItemCC:do_item_conf(pack)
	-- print("8.6 下发物品的配置")
	local param_count = pack:readByte();	-- 参数的个数, 后面全部接int型的参数多个
	local param_list={};
	for i = 1, param_count do
		param_list[i] = pack:readInt();	-- 整形的参数列表, int 类型，表示参数
	end
	local item_conf_id = pack:readByte(); -- 获取参数的ID
	-- TODO
end

-- 8.8, S->C
-- 装备处理的结果
function ItemCC:do_item_result(pack)

	local item_id = pack:readUint64();	-- 物品的GUID
	local ret_type = pack:readByte();	-- 处理的类型
	local result = pack:readByte();	-- 处理的结果,  1表示成功，0表示失败
	local str = pack:readString();	-- 处理结果提示消息
	-- print("8.8 装备处理的结果(result,ret_type,str)",result,ret_type,str);
	-- TODO
	-- 炼器窗口的处理：如果物品的改变是炼制引起的（根据 forge 的 _if_waiting_result 字段，就获取该窗口，并调用显示结果方法）
	-- require "UI/forge/ForgeWin"
 --    if ForgeWin:get_if_waiting_result() then
    	-- 就发送请求重新获取物品列表.
	    -- ItemCC:request_player_bag_items()
    --     require "UI/UIManager"
    --     local win = UIManager:find_visible_window( "forge_win" )
    --     if win ~= nil then
    --         win:show_handle_result( result , str)
    --     end
    -- end
    require "model/ForgeModel"	
    print("ItemCC:do_item_result result , str, ret_type, item_id",result , str, ret_type, item_id)
    ForgeModel:show_handle_result( result , str, ret_type, item_id)
end

-- 8.9, S->C
-- 物品的数据发生改变了
function ItemCC:do_item_data_changed(pack)
	-- print("8.9 物品的数据发生改变了")
	-- print("lyl---------------------ItemCC:do_item_data_changed----------------------   ")
	if (pack == nil) then
		-- print ("8.9, pack from server is nil");
		return;
	end
	local user_item = UserItem(pack);	-- 数据信息, 同以前的物品信息

	-- 先更新装备，如果没有，再更新背包
	require "model/UserInfoModel"
	require "model/ItemModel"
	UserInfoModel:change_equip_by_struct( user_item )
	ItemModel:change_item_by_struct( user_item )
	-- 炼器系统处理某些背包中的道具时要更新背包 modify by hcl on 2013/12/9
	local win = UIManager:find_window("bag_win")
	if win then
		win:update_bag_item(user_item);
	end
end

-- 8.10, S->C
-- 使用物品的结果
function ItemCC:do_use_item_result(pack)
	-- print("8.10 使用物品的结果")
	local item_id = pack:readWord();	--物品的ID. 基础属性id
	local result = pack:readByte();	    --使用物品的结果， 成功是1，否则是0 
	
	--print("ItemCC:do_use_item_result(item_id,result)",item_id,result)
	if result == 1 then
        ItemModel:use_item_success( item_id )
    else
    	print("使用物品失败！！！！！！")
	end
end

-- 8.11，C->S
-- 灌注源泉
-- medicine_id: 灌注源泉药品的guid(uint64)
-- item_id: 源泉装备的guid(uint64)
function ItemCC:req_hp_store(medicine_id, item_id)
	local pack = NetManager:get_socket():alloc(8, 11);
	pack:writeUint64(medicine_id);
	pack:writeUint64(item_id);

	NetManager:get_socket():SendToSrv(pack);
end

-- 8.12, C->S
-- 整理背包，如果成功，服务器会重新下发背包物品
function ItemCC:req_settle_bag()
	-- print("  ItemCC:req_settle_bag  请求整理装备 ")
	-- local pack = NetManager:get_socket():alloc(8, 12);
	-- NetManager:get_socket():SendToSrv(pack);
	NetManager:get_socket():SendCmdToSrv(8, 12);
end

-- 8.11, S->C
-- 下发本人可以领取的活动背包的物品列表,只在登录的时候发
function ItemCC:do_item_list (pack)
	-- print("8.11 下发本人可以领取的活动背包的物品列表,只在登录的时候发")
	local item_count = pack:readWord();	-- 物品的数量(ushort)
	local btype = pack:readByte();	-- 绑定类型，1：账户绑定，2角色绑定 (byte)
										--客户端请求一次，服务器会返回两次（如果有数据的话）
										--一次是账户绑定的数据，一次是角色绑定的数据，
										--客户端把这两个数据合并显示在界面
	for i=1, item_count do
		-- item_content_list: 物品内容(array, )
		-- int64:序列号
		-- BYTE:类型，10：物品，0：绑定银两，1：银两，类推
		-- int:count，数量，如果是金钱类，后面的字段不用读了
		-- unsigned short:物品id
		-- unsigned char:bind,是否绑定
		-- unsigned char:strong，强化值
		-- unsigned char:quality，品质
	end
	-- TODO
end

-- 8.13, C->S
-- 领取某个活动背包的物品
-- item_series_id: 物品的序列号，即消息号11里面的id字段
-- btype: 绑定类型，1：账户绑定，2角色绑定
function ItemCC:req_get_item (item_series_id, btype)
	local pack = NetManager:get_socket():alloc(8, 13);
	pack:writeUint64(item_series_id);
	pack:writeByte(btype);
	NetManager:get_socket():SendToSrv(pack);
end

-- 8.12, S->C
-- 是否领取物品成功
function ItemCC:do_get_item_status(pack)
	-- print("8.12 是否领取物品成功")
	local series_id = pack:readUint64();	-- 序列号
	local status = pack:readByte();	-- 是否成功，0：不成功，1成功
	local btype = pack:readByte();	-- 绑定类型，1：账户绑定，2角色绑定
	-- TODO
end

-- 8.13, S->C
-- 背包获得了一件新的装备(包括源泉)
function ItemCC:do_get_new_item( pack)
	-- print("8.13 背包获得了一件新的装备(包括源泉)")
	local item_id = pack:readUint64();	-- 物品的guid
	-- body
	local bagWin = UIManager:show_window("bagWin") --跳转到角色选择界面

--	bagWin:show_bag_items();
end

-- 8.15, S->C
-- 下发批量洗炼结果
function ItemCC:do_xilian_result(pack)
	-- print("8.15 下发批量洗炼结果")
	local attr_list = {}; -- 批量洗炼属性列表
							-- 共10条，每条3个属性
							-- 每个属性的结构为
							-- unsigned char 属性类型
							--int 属性值
	for i=1,8 do
		attr_list[i] = {}
		attr_list[i].attrs = {};
		-- 3个属性
		for j=1,3 do
			attr_list[i].attrs[j] = {};
			local sub_attr_table = attr_list[i].attrs[j]
			sub_attr_table.type	= pack:readByte()
			if ( AttrDataTypes[sub_attr_table.type] == "adInt" ) then 
				sub_attr_table.value	= pack:readInt();
			elseif ( AttrDataTypes[sub_attr_table.type] == "adFloat" ) then
				sub_attr_table.value = pack:readFloat();
			else
				sub_attr_table.value = pack:readInt();
			end
		end
	end

	-- TODO
	local win = UIManager:find_visible_window("zhizunxilian_win")
	if ( win ) then
		win:update("zzxl",attr_list)
	end
end

-- 8.16, C->S
-- 使用气血储量
-- htype, 类型,1:生命,2:法力(int)
function ItemCC:req_use_hp_store(htype)
	local pack = NetManager:get_socket():alloc(8, 16);
	pack:writeInt(htype);
	NetManager:get_socket():SendToSrv(pack);
end

-- 8.16, S->C
-- 使用气血储量的结果
function ItemCC:do_hp_result(pack)
	-- print("8.16 使用气血储量的结果")
	local status = pack:readInt();	-- 0成功，1失败
	local htype = pack:readInt();	-- 类型,1:生命,2:法力
	if status == 0 then 
        if htype == 1 then 
            ItemModel:item_begin_cool( 18300 )
            -- 使用血包后更新主界面
            local win = UIManager:find_visible_window("menus_panel")
		    if ( win ) then
		        win:update_yp_view( 18300 )
		    end
        elseif htype == 2 then 
        	ItemModel:item_begin_cool( 18310 )
        	-- 使用蓝包后更新主界面
            local win = UIManager:find_visible_window("menus_panel")
		    if ( win ) then
		        win:update_yp_view( 18310 )
		    end
        end
        
	end

end

-- 8.17, S->C
-- 使用礼包返回奖励信息
function ItemCC:do_bonus_info(pack)
	-- print("8.17 使用礼包返回奖励信息")
	local bonus_count = pack:readInt();	-- 奖励个数（只发物品类和金钱类的）
	local bonus_list = {};
	for i = 1, bonus_count do
		bonus_list[i].btype = pack:readInt();
		bonus_list[i].item_id = pack:readInt();
		-- 各个奖励的信息
		-- int 奖励类型1为物品，2为金钱
		-- int 物品ID或金钱类型
	end
end

--8.18, S->C
-- 返回祝福值
function ItemCC:do_wish_val( pack )
	--print("8.18 返回祝福值")
	local val_type = pack:readInt()
	local wish_val = 0
	if val_type == 1 then
		wish_val = pack:readInt()
	end
	ForgeModel:set_wish_val(wish_val)
end

-- 8.19 c->s
-- 批量使用
function ItemCC:req_batch_use(series, num)
	local pack = NetManager:get_socket():alloc(8, 19)
	pack:writeUint64(series)
	pack:writeWord(num)
	NetManager:get_socket():SendToSrv(pack)
end

-- 背包
function ItemCC:init_item_cc(  )
	local func = {};
	func[1] = ItemCC.do_remove_bag_item;
	func[2] = ItemCC.do_add_bag_item;
	func[3] = ItemCC.do_bag_count_changed;
	func[4] = ItemCC.do_init_bag;
	func[5] = ItemCC.do_expend_cost;
	func[6] = ItemCC.do_lost_energy;
	func[7] = ItemCC.do_item_conf;
	func[8] = ItemCC.do_item_result;
	func[9] = ItemCC.do_item_data_changed;
	func[10] = ItemCC.do_use_item_result;
	func[11] = ItemCC.do_item_list;
	func[12] = ItemCC.do_get_item_status;
	func[13] = ItemCC.do_get_new_item;
	func[15] = ItemCC.do_xilian_result;
	func[16] = ItemCC.do_hp_result;
	func[17] = ItemCC.do_bonus_info;
	func[18] = ItemCC.do_wish_val;
	return func;
end 

-- 139.127 c->s
-- 获取宝石材料
function ItemCC:req_gem_meta( ... )
	local pack = NetManager:get_socket():alloc(139, 127)
	NetManager:get_socket():SendToSrv(pack)
end

function ItemCC:do_gem_meta( pack )
	-- print("==== 宝石材料 =====")
	local gem_meta_t = {}
	if nil == pack then
		-- print("======= no gem meta =======")
		gem_meta_t = {0, 0, 0, 0}
	else
		gem_meta_t[1] = pack:readInt()
		gem_meta_t[2] = pack:readInt()
		gem_meta_t[3] = pack:readInt()
		gem_meta_t[4] = pack:readInt()
	end
	require "model/ForgeModel"
	ForgeModel:set_gem_meta(gem_meta_t)
	ForgeWin:forge_win_update("show_gem_meta")
end



