----JiShouCC.lua
----HJH
----2013-7-25
----
-- 	
JiShouCC = {}
--------------------------------------
------27,1 c->s
function JiShouCC:send_get_my_item_list()
	-- print("JiShouCC:send_get_my_item_list------------------------")
	local pack = NetManager:get_socket():alloc(27, 1)
	NetManager:get_socket():SendToSrv(pack)
end
--------------------------------------
------27,1 s->c
function JiShouCC:receive_my_item_list(pack)
	local item_num = pack:readByte()
	local item_list = {}
	for i = 1, item_num do
		item_list[i] = JiShouStruct(pack)
	end
	-- print("JiShouCC:receive_my_item_list item_num,item_list", item_num, item_list)
	JiShouShangJiaModel:update_my_ji_shou_info( item_num, item_list )
end
--------------------------------------
------27,2 c->s
function JiShouCC:send_find_item(page_num, page_index, ttype, min_money, max_money, quality, min_level, max_level, job, search_num, id_list,money_type)
	print("JiShouCC:send_find_item: page_num, page_index, type, min_money, max_money, quality, min_level, max_level, job, search_num, id_list, money_type",page_num, page_index, ttype, min_money, max_money, quality, min_level, max_level, job, search_num, id_list, money_type)
	local pack = NetManager:get_socket():alloc(27, 2)
	pack:writeInt(page_num)
	pack:writeInt(page_index)
	pack:writeInt(ttype)
	pack:writeInt(min_money)
	pack:writeInt(max_money)
	pack:writeInt(money_type)
	if ttype ~= 100001 and ttype ~= 100003 then
		pack:writeInt(quality)
		pack:writeInt(min_level)
		pack:writeInt(max_level)
		pack:writeInt(job)
		pack:writeInt(search_num)
		for i = 1, search_num do
			print("id_list[i]",id_list[i])
			pack:writeInt(id_list[i])
		end
	else
		pack:writeInt(32)
	end
	NetManager:get_socket():SendToSrv(pack)
end
--------------------------------------
------27、2 s->c
function JiShouCC:receive_search_result(pack)
	local num = pack:readInt()
	local page_index = pack:readInt()
	local max_page = pack:readInt()
	local item_info = {}
	print("JiSHouCC:receive_search_result num,page_index,max_page",num, page_index, max_page)
	if num <= 0 then
		return
	end
	for i = 1, num do
		item_info[i] = JiShouSerchStruct(pack)
	end
	--print("JiSHouCC:receive_search_result num,page_index,max_page",num, page_index, max_page)
	JiShouModel:add_serch_info( page_index, max_page, item_info )
end
--------------------------------------
------27、3 c->s
function JiShouCC:send_item_info(item_id, money, money_type, time, price, price_type, coust)
	print("item_id, money, money_type, time, price, price_type, coust",item_id, money, money_type, time, price, price_type, coust)
	local pack = NetManager:get_socket():alloc(27, 3)
	pack:writeInt64(item_id)
	pack:writeInt(money)
	pack:writeInt(money_type)
	pack:writeUInt(time)
	pack:writeUInt(price)
	pack:writeInt(price_type)
	pack:writeUInt(coust)
	NetManager:get_socket():SendToSrv(pack)
end
--------------------------------------
------27、3 s->c
function JiShouCC:receive_item_result(pack)
	local state = pack:readByte()
	local item_info = nil
	if state >= 1 then
		item_info = JiShouStruct(pack)
	end
	print("JiShouCC:receive_item_result, state, item_info", state, item_info)
	if item_info ~= nil then
		JiShouShangJiaModel:my_ji_shou_result(state, item_info)
	end
	
end
--------------------------------------
------27、4 c->s
function JiShouCC:send_cancel_item(item_id, item_handle, type)
	local pack = NetManager:get_socket():alloc(27, 4)
	pack:writeInt64(item_id)
	pack:writeUInt(item_handle)
	pack:writeByte(type)
	NetManager:get_socket():SendToSrv(pack)
end
--------------------------------------
------27、5 c->s
function JiShouCC:send_buy_item(item_id, item_handle)
	local pack = NetManager:get_socket():alloc(27, 5)
	pack:writeInt64(item_id)
	pack:writeUInt(item_handle)
	NetManager:get_socket():SendToSrv(pack)
end
--------------------------------------
------27,5 s->c
function JiShouCC:receive_item_buy_result(pack)
	local result = pack:readByte()
	if result == 1 then
		JiShouModel:buy_finish()
	end
	print("JiShouCC:receive_item_buy_result-----------------------------")
end
--------------------------------------
------27,7 c->s
function JiShouCC:send_calculate_money(time, money_type, price)
	if price <= 0 then
		return
	end
	print("JiShouCC:receive_calculate_money time, money_type, price", time, money_type, price)
	local pack = NetManager:get_socket():alloc(27, 7)
	pack:writeUInt(time)
	pack:writeByte(money_type)
	pack:writeUInt(price)
	NetManager:get_socket():SendToSrv(pack)
end
--------------------------------------
------27,7 s->c
function JiShouCC:receive_jishou_price(pack)
	local money = pack:readUInt()
	print("JiShouCC:receive_jishou_price money",money)
	JiShouShangJiaModel:update_bao_guan_fei(money)
end
--------------------------------------
------27,4 s->c
function JiShouCC:receive_delete_item(pack)
	local item_handle = pack:readUInt()
	JiShouModel:delete_item(item_handle)
	JiShouShangJiaModel:delete_my_ji_shou_item(item_handle)
	print("JiShouCC:receive_delete_item----------------")
end