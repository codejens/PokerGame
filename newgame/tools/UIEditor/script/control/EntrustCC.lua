-- EntrustCC.lua
-- created by lyl on 2012-5.17
-- 委托系统

EntrustCC = {}

-- c->s 42,1  获取委托仓库物品列表
function EntrustCC:request_depot_item_list()
	local pack = NetManager:get_socket():alloc(42, 1)
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 42,1 服务器下发仓库物品列表
function EntrustCC:do_result_depot_item_list( pack )
	print("s->c 42,1 服务器下发仓库物品列表")
	local count = pack:readWord()
	local new_items = {}
	for i = 1, count do
		new_items[i] = UserItem(pack)
	end
	-- todo
	EntrustModel:set_depot_item_list( new_items )
end

-- c->s 42,2  委托仓库物品移动到背包
function EntrustCC:request_depot_item_move_to_bag( series )
	local pack = NetManager:get_socket():alloc(42, 2)
	pack:writeInt64( series )                 -- 移到背包物品的GUID，如果为0表示要全部取出
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 42,2 物品移动结果
function EntrustCC:do_result_depot_item_move( pack )
	print("s->c 42,2 物品移动结果")
	local item_series = pack:readUint64();	-- 移到背包物品的GUID，如果为0表示要全部取出
	local result = pack:readByte();	-- 处理的结果,  1表示成功，0表示失败
	if result == 1 then
        EntrustModel:remove_depot_item( item_series )
    end
end

-- s->c 42,3 添加物品到仓库
function EntrustCC:add_item_to_depot( pack )
	print("s->c 42,3 添加物品到仓库")
	local new_item = UserItem(pack)
	EntrustModel:add_depot_item( new_item )
end

-- s->c 42,4 仓库中的物品发生数量变化
function EntrustCC:depot_item_count_change( pack )
	print("s->c 42,4 仓库中的物品发生数量变化")
	local item_series = pack:readUint64();	    -- 物品的GUID
	local item_count = pack:readWord();	        -- 数量
	EntrustModel:change_depot_item_count( item_series, item_count )
end

-- c->s 42,5  获取委托副本信息
function EntrustCC:request_entrust_fuben_info( fuben_id )
	print("c->s 42,5 获取委托副本信息........", fuben_id)
	local pack = NetManager:get_socket():alloc(42, 5)
	pack:writeInt( fuben_id )
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 42,5 服务器下发委托副本信息
function EntrustCC:do_result_fuben_info( pack )
	print("s->c 42,5 服务器下发委托副本信息")
	local fuben_entrust_info = EntrustInfoStruct( pack )
	EntrustModel:add_fuben_entrust_info( fuben_entrust_info )
end

-- c->s 42,6  请求委托
function EntrustCC:request_entrust( fuben_id, entrust_way, times )
	local pack = NetManager:get_socket():alloc(42, 6)
	pack:writeInt( fuben_id )
	pack:writeByte( entrust_way )                        -- 0 仙币，  1：元宝
	pack:writeInt( times )
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 42,6 委托开始
function EntrustCC:begin_entrust( pack )
	-- print("s->c 42,6 委托开始@@@@@@@@@@EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE@@@@@@@@@@EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	local fuben_id      = pack:readInt() 
	local times         = pack:readInt()         -- 第几次
	EntrustModel:entrust_start( fuben_id, times )
	EntrustModel:set_fuben_state( fuben_id, 1  )
end

-- c->s 42,7  立即完成
function EntrustCC:request_complete_immediately( fuben_id )
	local pack = NetManager:get_socket():alloc(42, 7)
	pack:writeInt( fuben_id )
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 42,7 委托结束
function EntrustCC:entrust_end( pack )
    -- print("s->c 42,7 委托结束@@@@@@@@@@EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE@@@@@@@@@@EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	local list_id = pack:readInt() 
	local entrust_way   = pack:readByte()             -- 仙币委托还是元宝委托  0：仙币委托  1：元宝委托
	print("list_id,entrust_way",list_id,entrust_way)
	EntrustModel:entrust_end( list_id, entrust_way )
	EntrustModel:set_fuben_state( list_id, 2  )
	--火影
	-- print("list_id",list_id)
	-- FuBenModel:set_current_list_id(current_list_id)
	-- local win = UIManager:find_visible_window("activity_Win")
	-- if win then
	-- 	local  str = string.format("ShowFubenList,%d",list_id)
 --    	GameLogicCC:req_talk_to_npc( 0, str)
	-- else
	-- 	local function mini_but_func(  )
 --        	local win = UIManager:show_window( "activity_Win" )
 --        	if win then 
 --            	win:change_page(2)
 --            	local btn_index = FuBenModel:get_btn_index_by_list_id(list_id)
 --        		win:update_win("change_page",btn_index)
 --        	end
 --    	end
 --    	MiniBtnWin:show( 17 , mini_but_func ,nil )
	-- end
end

-- c->s 42,8  获取经验
function EntrustCC:request_get_exp( fuben_id )
	local pack = NetManager:get_socket():alloc(42, 8)
	pack:writeInt( fuben_id )
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 42,8 获取经验结果
function EntrustCC:do_result_get_exp( pack )
	print("s->c 42,8 获取经验结果")
	local fuben_id      = pack:readInt() 
	local result        = pack:readInt();	-- 处理的结果,  0 成功， 负数：失败
	print(fuben_id,result)
    if result == 0 then
        EntrustModel:set_fuben_state( fuben_id, 0  )
    end
end

-- s->c 42,9 副本最大通关层数变化
function EntrustCC:fuben_max_tier_change( pack )
	print("s->c 42,9 副本最大通关层数变化")
	local fuben_id      = pack:readInt() 
	local max_tier      = pack:readInt();	-- 最大通关层数
    EntrustModel:fuben_max_tier_change( fuben_id, max_tier )
end

-- c->s 42,9 请求扫荡副本
-- 成功返回 139,128
function EntrustCC:request_sweep_fuben(fuben_listId)
	print("c->s 42,9 请求扫荡副本(fuben_listId)",fuben_listId)
	local pack = NetManager:get_socket():alloc(42,9)
	pack:writeInt(fuben_listId)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 42,10 请求立即完成扫荡
-- 成功返回 139,128
function EntrustCC:request_immediately_sweep(fuben_listId,money_type)
	print("c->s 42,10 请求立即完成扫荡(fuben_listId,money_type)",fuben_listId,money_type)
	local pack = NetManager:get_socket():alloc(42,10)
	pack:writeInt(fuben_listId)
	pack:writeChar(money_type)
	NetManager:get_socket():SendToSrv(pack)
end

-- c->s 42,11 请求领取奖励
-- 成功返回 139,128
function EntrustCC:request_get_fuben_award(fuben_listId)
	print("c->s 42,11 请求领取奖励",fuben_listId)
	local pack = NetManager:get_socket():alloc(42,11)
	pack:writeInt(fuben_listId)
	NetManager:get_socket():SendToSrv(pack)
end