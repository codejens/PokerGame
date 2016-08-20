-- MoveCC.lua
-- created by aXing on 2012-12-25
-- 游戏主角移动逻辑处理类

-- super_class.MoveCC()
MoveCC = {}

-- 主角开始跑动
function MoveCC:request_start_move( cur_x, cur_y, target_x, target_y )
	local pack = NetManager:get_socket():alloc(1, 1)
	pack:writeInt(cur_x)
	pack:writeInt(cur_y)
	pack:writeInt(target_x)
	pack:writeInt(target_y)
	NetManager:get_socket():SendToSrv(pack)
	-- print(string.format("主角跑动: %d %d %d %d", cur_x/32, cur_y/32, target_x/32, target_y/32))
end

-- 主角结束跑动
function MoveCC:request_stop_move( final_x, final_y, final_dir )
	-- local pack = NetManager:get_socket():alloc(1, 2)
	-- pack:writeInt(final_x)
	-- pack:writeInt(final_y)
	-- pack:writeInt(final_dir)
	-- NetManager:get_socket():SendToSrv(pack)
	-- 由于历史原因，原来(1,2)协议已经弃用
	MoveCC:request_start_move(final_x, final_y, final_x, final_y)
	-- print("发送服务器，主角站定坐标", final_x, final_y)
end

-- 主角转向
function MoveCC:request_turn_around(  )
	-- 废除，不用
	return
	NetManager:get_socket():SendCmdToSrv(1, 3)
end

-- 主角宠物开始跑动
function MoveCC:request_player_pet_start_move( handler, cur_x, cur_y, target_x, target_y )
	local pack = NetManager:get_socket():alloc(1, 4)
	pack:writeInt64(handler)
	pack:writeInt(cur_x)
	pack:writeInt(cur_y)
	pack:writeInt(target_x)
	pack:writeInt(target_y)
	NetManager:get_socket():SendToSrv(pack)
end

