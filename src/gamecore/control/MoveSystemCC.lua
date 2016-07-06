--MoveSystemCC.lua
--create by tjh on 2015-05-05
--移动系统逻辑处理

MoveSystemCC = {}

function MoveSystemCC:init( ... )
	-- body
end

function MoveSystemCC:finish( ... )
	-- body
end

function MoveSystemCC:req_start_move(x,y,tx,ty )
	print(x,y,tx,ty)
	PacketDispatcher:send_protocol( PROTOCOL_ID_C_1_1, x, y, tx, ty)
end

function MoveSystemCC:req_stop_move( x,y,dir )
	PacketDispatcher:send_protocol( PROTOCOL_ID_C_1_2, x, y,dir)
end