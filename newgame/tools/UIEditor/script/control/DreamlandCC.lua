
-- DreamlandCC.lua
-- created by fjh on 2012-12-20
-- 梦境系统 ,36
-- super_class.DreamlandCC()

DreamlandCC = {}

--探宝请求， dreamland_type:梦境类型，1为星蕴，2为月华 3聚宝袋ption_id:探宝类型，1为1次，2为10次，3为50次
-- c->s 36,1
function DreamlandCC:request_tanbao(dreamland_type,option_id, money_type)
	-- require "model/DreamlandModel"
	--每次探宝前，先清空探宝列表
	DreamlandModel:clear_item_table();

	local pack = NetManager:get_socket():alloc(36, 1);
	pack:writeByte(dreamland_type);
	pack:writeByte(option_id);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end
-- 探宝callback
-- s->c 36,1
function DreamlandCC:do_tanbao( pack )

	local item_info = DreamItemStruct(pack);
	
	DreamlandModel:add_item(item_info);
	
	--等到服务器分发的探宝结果为最后一次的时候，通知UI界面。
	if DreamlandModel:get_item_table_size() == DreamlandModel:get_tanbao_count() then
	
		--在返回UI界面显示探宝收获前要进行排序，把相同id的物品进行合并数量叠加
		local sort_item_table = DreamlandModel:table_sort(DreamlandModel:get_item_table());
		DreamlandModel:set_item_table(sort_item_table);
		local win = UIManager:find_visible_window("new_dreamland_win")
		if win then
			win:tanbao_callback(sort_item_table)
		end
			-- UIManager:get_win_obj("dreamland_win"):tanbao_callback(sort_item_table);

			-- if UIManager:get_win_status("dreamland_info_win") then

			-- 	UIManager:get_win_obj("dreamland_info_win"):tanbao_callback(sort_item_table);
			-- end

		
		--清除探宝次数
		DreamlandModel:set_tanbao_count(0);	

	end

end

--获取仓库列表
--c->s 36,2
function DreamlandCC:request_cangku_list( )
	local pack = NetManager:get_socket():alloc(36,2);
	NetManager:get_socket():SendToSrv(pack);
	
end
--获取仓库列表callback
--s->c 36,2
function DreamlandCC:do_cangku_list( pack )
	local count = pack:readWord();
	print("DreamlandCC:do_cangku_list( pack )",count)
	require "struct/UserItem"
	require "model/DreamlandModel"
	--在重新填充仓库前要清空一编
	DreamlandModel:clear_cangku_table();
	for i=1,count do
		local item = UserItem(pack);
		DreamlandModel:add_cangku_item(i,item);
	end

end

--将物品放入到包裹里
--c->s 36,3
function DreamlandCC:request_moveItem_to_package( item_guid)
	
	local count = 1;--默认取出1个
	if item_guid == 0 then --0:代表着要取出所有的物品
		count = #DreamlandModel:get_cangku_table();
	end
	-------------
	local package_count = ItemModel:get_bag_space_gird_count(  ); --背包的空格数量，这里应该去调背包的model数据
	-------------
	--如果背包的空格数足够存放这些物品才进行请求
	if package_count>=count then
		local pack = NetManager:get_socket():alloc(36,3);
		pack:writeInt64(item_guid);
		NetManager:get_socket():SendToSrv(pack);
	end

end
--将物品放入包裹的callback
-- s->c 36,3
function DreamlandCC:do_moveItem_to_package( pack )
	-- 物品id，如果id为0的话，意味着是转移了所有的物品
	local item_id = pack:readInt64();
	-- 0：不成功，1：成功
	local status = pack:readByte();
	if status == 1 then
		if item_id ~= 0 and item_id ~= "0x0" then --如果不为0，则删除某个item
			DreamlandModel:remove_cangku_item_by_GUID(item_id);
		else				--如果为0，则清空仓库
			DreamlandModel:clear_cangku_table();
		end
		if UIManager:get_win_status("dreamland_cangku_win") then
			UIManager:get_win_obj("dreamland_cangku_win"):cangku_item_changed();
		end
	else
		--通知UI层操作失败
		print("option fail");
	end
end

-- 珍品记录,
-- c->s 36,4
function DreamlandCC:request_zhenpin_jilu( )
	-- body
	local pack = NetManager:get_socket():alloc(36,4);
	NetManager:get_socket():SendToSrv(pack);

end
-- 珍品记录callback
-- s->c 36,4
function DreamlandCC:do_zhenpin_jilu( pack )
	
	local count = pack:readInt();
	for i=1,count do
		local zhenpin_info = ZhenPinStruct(pack);
		DreamlandModel:add_zhenpin(i,zhenpin_info);
	end

	local win = UIManager:find_visible_window("new_dreamland_win")
	if win then
		win:zhenpin_jilu_callback()
	end
	-- if UIManager:get_win_obj("dreamland_info_win") then
	-- 	UIManager:get_win_obj("dreamland_info_win"):zhenpin_jilu_callback();
	-- end

end

--仓库里的添加一个物品
-- s->c 36,5
function DreamlandCC:do_add_item( pack )
	
	local item = UserItem(pack);
	DreamlandModel:add_cangku_item_end(item);
	print("new add",item.item_id);
	if UIManager:get_win_obj("dreamland_cangku_win") then
		UIManager:get_win_obj("dreamland_cangku_win"):cangku_item_changed();
	end
end

--仓库里的物品数量发生改变
-- s->c 36,6
function DreamlandCC:do_item_count_change( pack )

	local item_series = pack:readInt64(); --物品的唯一序列号
	local item_count = pack:readByte();
	local cangku_table = DreamlandModel:get_cangku_table();

	for i=1,#cangku_table do
		local item = cangku_table[i];
		if item.series == item_series then
			item.count = item_count;
			DreamlandModel:add_cangku_item(i,item);
			break;
		end
	end
	print("new add",item_series);
	if UIManager:get_win_obj("dreamland_cangku_win") then
		UIManager:get_win_obj("dreamland_cangku_win"):cangku_item_changed();
	end

end

--------------------------------------淘宝树活动
-- 淘宝树探宝
-- c->s 36,8
function DreamlandCC:req_taobao_tree_tan_bao(Type, option_id, money_type)
	--每次探宝前，先清空探宝列表
	DreamlandModel:clear_item_table();
	-- print("36,8 Type=",Type)
	-- print("36,8 option_id=",option_id)

	local pack = NetManager:get_socket():alloc(36,8);
	pack:writeByte(Type);
	pack:writeByte(option_id);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end

-- 淘宝树探宝返回
-- s->c 36,8
function DreamlandCC:do_taobao_tree_tan_bao( pack )

	
	local item_info = DreamItemStruct(pack);
	local Type =  pack:readInt()
	DreamlandModel:add_item(item_info);
	
	local count = DreamlandModel:get_item_table_size()
	print("count=",count)
	--等到服务器分发的探宝结果为最后一次的时候，通知UI界面。
	if DreamlandModel:get_item_table_size() == DreamlandModel:get_tanbao_count() then
		print("进入更新UI~~~~~~~~~~~~~~~~~~~~~~~~dsdsds")
		--在返回UI界面显示探宝收获前要进行排序，把相同id的物品进行合并数量叠加
		-- local sort_item_table = DreamlandModel:table_sort(DreamlandModel:get_item_table());
		-- DreamlandModel:set_item_table(sort_item_table);

		if Type == 3 then --聚宝袋， 要更新到聚宝袋窗口的UI
			-- 更新到聚宝战报
			local win = UIManager:find_window("jubao_bag_win")
			if win then
				win:change_page_index(2) --切换到 聚宝战报
				win:update(2)
			end
		else --更新梦境ui
			--把新的表返回给UI显示
		--把新的表返回给UI显示
			local win = UIManager:find_visible_window("new_dreamland_win")
		if win then
			win:tanbao_callback(sort_item_table)
		end
		end
		
		--清除探宝次数
		DreamlandModel:set_tanbao_count(0);	

	end

end

-- 请求淘宝树珍品日志
-- c->s 36,9
function DreamlandCC:req_taobao_tree_zhenpin(  )
	local pack = NetManager:get_socket():alloc(36,9);
	NetManager:get_socket():SendToSrv(pack);
end

-- 淘宝树珍品的返回
-- s->c 36,9
function DreamlandCC:do_taobao_tree_zhenpin( pack )
	local count = pack:readInt();
	for i=1,count do
		local zhenpin_info = ZhenPinStruct(pack);
		DreamlandModel:add_zhenpin(i,zhenpin_info);
	end

	local win = UIManager:find_visible_window("new_dreamland_win")
	if win then
		win:zhenpin_jilu_callback()
	end
end
-- c>s 36,11 请求梦境免费次数
function DreamlandCC:req_free_count()
	print("36,11 请求梦境免费次数")
	local pack = NetManager:get_socket():alloc(36, 11);
	NetManager:get_socket():SendToSrv(pack);
end

-- s>c 36,11 下发梦境免费次数
function DreamlandCC:do_get_free_count(pack)
	print("36,11 下发梦境免费次数")
	local times = pack:readInt()
	DreamlandModel:do_get_count(times)

	local win = UIManager:find_visible_window("right_top_panel")
	if win then
		if times == 0 then
			win:remove_btntip_first(6)
		else
			win:set_btntip_active_first( 6)
		end
	end
end