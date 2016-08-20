-----------------------------------------------
-----------------------------------------------
---------HJH
---------2013-5-22
---------
BuniessCC = {}
-----------------------------------------------
 -- 13 ->1 client
function BuniessCC:send_begin_buniess(id)
	local pack = NetManager:get_socket():alloc(13, 1)
	pack:writeInt(id)
	NetManager:get_socket():SendToSrv(pack)
end
-----------------------------------------------
-- 13 ->2 client
function BuniessCC:send_answer_confirm_buniess(id, request)
	local pack = NetManager:get_socket():alloc(13, 2)
	pack:writeInt(id)
	pack:writeChar(request)
	NetManager:get_socket():SendToSrv(pack)
end
-----------------------------------------------
-- 13 ->3 client
function BuniessCC:send_change_item(id, state)
	print( string.format("run BuniessCC:send_change_item id=%d,state=%d",id, state) )
	local pack = NetManager:get_socket():alloc(13, 3)
	pack:writeUint64(id)
	pack:writeInt(state)
	NetManager:get_socket():SendToSrv(pack)
end
-----------------------------------------------
-- 13 ->4 client
function BuniessCC:send_change_money(num, style)
	local pack = NetManager:get_socket():alloc(13, 4)
	pack:writeInt(num)
	pack:writeInt(style)
	NetManager:get_socket():SendToSrv(pack)
end
-----------------------------------------------
-- 13 ->5 client
function BuniessCC:send_lock_buniess()
	local pack = NetManager:get_socket():alloc(13, 5)
	NetManager:get_socket():SendToSrv(pack)
end
-----------------------------------------------
-- 13 ->6 client
function BuniessCC:send_cancel_buniess()
	local pack = NetManager:get_socket():alloc(13, 6)
	NetManager:get_socket():SendToSrv(pack)
end
-----------------------------------------------
-- 13 ->7 client
function BuniessCC:send_confirm_buniess()
	local pack = NetManager:get_socket():alloc(13, 7)
	NetManager:get_socket():SendToSrv(pack)
end
-----------------------------------------------
-----------------------------------------------
-- 13 ->1 server
function BuniessCC:receive_buniess_request(pack)
	local role_id = pack:readInt()
	local role_name = pack:readString()
	print( string.format("BuniessCC:receive_buniess_request id=%d,name=%s",role_id, role_name) )
	BuniessModel:receive_buniess_request(role_id, role_name)
end
-----------------------------------------------
-- 13 ->2 server
function BuniessCC:receive_reject_buniess(pack)

end
-----------------------------------------------
-- 13 ->3 server
function BuniessCC:receive_begin_buniess(pack)
	local role_id = pack:readInt()
	local role_name = pack:readString()
	local role_level = pack:readShort()
	print( string.format("BuniessCC:receive_begin_buniess role_id=%d,role_name=%s,role_level=%d",role_id, role_name, role_level) )
	BuniessModel:open_buniess_win(role_id, role_name, role_level)
end
-----------------------------------------------
-- 13 ->4 server
function BuniessCC:receive_change_item(pack)
	local is_add = pack:readChar()
	local item_id = pack:readUint64()
	local item_state = pack:readInt()
	print( string.format("BuniessCC:receive_change_item is_add=%s,item_id=%d,item_state=%d",is_add, item_id, item_state) )
	BuniessModel:update_myself_item_info(is_add, item_id, item_state)
end
-----------------------------------------------
-- 13 ->5 server
function BuniessCC:receive_add_buniess_item(pack)
	local item_state = pack:readInt()
	local user_item = UserItem(pack)
	print( string.format("BuniessCC:receive_add_buniess_item item_state = %d", item_state) )
	BuniessModel:update_other_item_info(item_state, user_item)
end
-----------------------------------------------
-- 13 ->6 server 
function BuniessCC:receive_myself_money_change(pack)
	local state = pack:readChar()
	local yl = pack:readInt()
	local yb = pack:readInt()
	print( string.format("BuniessCC:receive_myself_money_change state=%s,yl=%d,yb=%d",state, yl, yb) )
	BuniessModel:change_my_money(yl,yb)
end
-----------------------------------------------
-- 13 ->7 server
function BuniessCC:receive_other_money_change(pack)
	local num = pack:readInt()
	local style = pack:readInt()
	print( string.format("BuniessCC:receive_other_money_change num=%d,style=%d",num,style) )
	BuniessModel:change_other_money(num, style)
end
-----------------------------------------------
-- 13 ->8 server
function BuniessCC:receive_lock_buniess(pack)
	local my_lock = pack:readChar()
	local other_lock = pack:readChar()
	print( string.format("BuniessCC:receive_lock_buniess my_lock=%s,other_lock=%s",my_lock, other_lock) )
	BuniessModel:lock_buniess(my_lock, other_lock)
end
-----------------------------------------------
-- 13 ->9 server
function BuniessCC:receive_cancel_buniess(pack)
	print("BuniessCC:receive_cancel_buniess")
	BuniessModel:finish_buniess()
end
-----------------------------------------------
-- 13 ->10 server
function BuniessCC:receive_buniess_unlock(pack)

end
-----------------------------------------------
-- 13 ->11 server
function BuniessCC:receive_finish_buniess(pack)
	print("BuniessCC:receive_finish_buniess")
	BuniessModel:finish_buniess()
end