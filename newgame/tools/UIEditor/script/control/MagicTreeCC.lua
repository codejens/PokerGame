-- MagicTreeCC.lua
-- created by chj on 2015-0--23
-- 昆仑神树


MagicTreeCC = {}

-- 请求神树信息 ---------------
function MagicTreeCC:req_magictree_info( player_id)
	print( "c->s(165, 1) MagicTreeCC:req_magictree_info")
	local pack = NetManager:get_socket():alloc(165, 1)
	pack:writeInt( player_id)
	NetManager:get_socket():SendToSrv(pack)
end

--服务器下发 神树信息
function MagicTreeCC:do_magictree_info( pack )
	print( "s->c(165, 1) MagicTreeCC:do_magictree_info")
	local player_id = pack:readInt()
	local player_name = pack:readString()
	local maturity = pack:readInt()
	local remaintime_water = pack:readInt()
	local num_fruit = pack:readInt()
	local fruit_tabel = {}
	--int （1蓝色果实，2紫色果实，3金色果实）
	for i=1, num_fruit do
		fruit_tabel[i] = {}
		fruit_tabel[i]._type = pack:readInt()
		fruit_tabel[i].index = pack:readInt()
	end
	-- 数据处理
	MagicTreeModel:do_magictree_info( player_id, player_name, maturity, remaintime_water, num_fruit, fruit_tabel)
end

-- 请求获取收获日志 -------------
function MagicTreeCC:req_receive_log( )
	print( "c->s(165, 2) MagicTreeCC:req_receive_log")
	local pack = NetManager:get_socket():alloc(165, 2)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回收获日志
function MagicTreeCC:do_receive_log( pack)
	print( "s->c(165, 2) MagicTreeCC:do_receive_log")
	local num_log = pack:readInt()
	local log_tabel = {}
	for i=1, num_log do
		-- string  具体的每一条日志
		log_tabel[i] = {}
		log_tabel[i].content = pack:readString()
	end
	MagicTreeModel:setFriendReceiveLog( log_tabel)
end

-- 请求仓库信息 ---------------------
function MagicTreeCC:req_cangku_info( )
	print( "c->s(165, 3) MagicTreeCC:req_cangku_info")
	local pack = NetManager:get_socket():alloc(165, 3)
	NetManager:get_socket():SendToSrv(pack);
end

-- 返回仓库信息
function MagicTreeCC:do_cangku_info( pack)
	print( "s->c(165, 3) MagicTreeCC:do_cangku_info")
	local num_point = pack:readInt()
	local num_item = pack:readInt()
	-- local item_tabel = {}
	for i=1, num_item do
		-- int 分别对应蓝色、紫色、金色果实的物品ID; int 果实的数量
		local item = {}
		item.item_id = pack:readInt()
		item.count = pack:readInt()
		item.series = pack:readInt()
		cangku_table[i] = item
		-- MagicTreeModel:add_cangku_item( i, item )
	end
	MagicTreeModel:set_cangku_item_all( cangku_table, num_point)
	local win = UIManager:find_visible_window("magictree_cangku_win")
    if win then
        	win:update()
    end
end

-- 请求好友信息 ---------------------
function MagicTreeCC:req_friend_info()
	print( "c->s(165, 4) MagicTreeCC:req_friend_info")
	local pack = NetManager:get_socket():alloc(165, 4)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回好友信息
function MagicTreeCC:do_friend_info( pack)
	print( "s->c(165, 4) MagicTreeCC:do_friend_info")
	local num_friend = pack:readInt()
	local friend_tabel = {}
	for i=1, num_friend do
		friend_tabel[i].id = pack:readInt()				-- 好友ID
		friend_tabel[i].name = pack:readString()       -- string 好友名字
		friend_tabel[i].state = pack:readChar()        -- char 1是否可浇水，2是否可偷果子
	end
end

-- 请求玩家操作日志(自己收获日志)
function MagicTreeCC:req_opera_log( )
	print( "c->s(165, 5) MagicTreeCC:req_opera_log")
	local pack = NetManager:get_socket():alloc(165, 5)
	NetManager:get_socket():SendToSrv(pack)
end

-- 返回玩家自己操作日志(自己收获日志)
function MagicTreeCC:do_opera_log( pack)
	print( "s->c(165, 5) MagicTreeCC:do_opera_log")
	local num_opr_log = pack:readInt()
	print("-------------num_opr_log:", num_opr_log);
	local opr_log_tabel = {}
	for i=1, num_opr_log do
		opr_log_tabel[i].content = pack:readString()
	end
	MagicTreeModel:setOwnOperationLog( opr_log_tabel)
end

-- 请求浇水 -------------------------
function MagicTreeCC:req_water( player_id)
	print( "c->s(165, 5) MagicTreeCC:req_water")
	local pack = NetManager:get_socket():alloc(165, 6)
	pack:writeInt( player_id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 请求摘果子 -----------------------
-- 玩家ID, 果实序列号
function MagicTreeCC:req_get_fruit( player_id, index)
	print( "c->s(165, 6) MagicTreeCC:req_get_fruit")
	local pack = NetManager:get_socket():alloc(165, 7)
	pack:writeInt( player_id)
	pack:writeInt( index)
	NetManager:get_socket():SendToSrv(pack)
end

-- 请求摘果子 -----------------------
-- 玩家ID, 果实序列号
function MagicTreeCC:req_mature_once()
	print( "c->s(165, 8) MagicTreeCC:req_mature_once")
	local pack = NetManager:get_socket():alloc(165, 8)
	NetManager:get_socket():SendToSrv(pack)
end

-- 请求使用道具 -----------------------
-- 果实序列号 series
function MagicTreeCC:req_use_item( series)
	print( "c->s(165, 9) MagicTreeCC:req_use_item", series)
	local pack = NetManager:get_socket():alloc(165, 9)
	pack:writeInt( series)
	NetManager:get_socket():SendToSrv(pack)
end

-- 请求一键开启( not use)
-- function MagicTreeCC:req_use_item_once( ) 
-- 	print( "c->s(165, 10) MagicTreeCC:req_use_item_once")
-- 	local pack = NetManager:get_socket():alloc(165, 10)
-- 	NetManager:get_socket():SendToSrv(pack)
-- end

-- 收入背包
function MagicTreeCC:req_to_bag()
	print( "c->s(165, 10) MagicTreeCC:req_use_item_once")
	local pack = NetManager:get_socket():alloc(165, 10)
	NetManager:get_socket():SendToSrv(pack)
end

-- 开始下一轮成熟
function MagicTreeCC:req_next_mature()
	print( "c->s(165, 11) MagicTreeCC:req_next_mature")
	local pack = NetManager:get_socket():alloc(165, 11)
	NetManager:get_socket():SendToSrv(pack)
end

-- 单个放入背包
function MagicTreeCC:req_to_bag_once( index)
	print( "c->s(165, 12) MagicTreeCC:req_to_bag_once", index)
	local pack = NetManager:get_socket():alloc(165, 12)
	pack:writeInt( index)
	NetManager:get_socket():SendToSrv(pack)
end