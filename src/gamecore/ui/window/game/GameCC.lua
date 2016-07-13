GameCC = {}

function GameCC:init()
	PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_1,bind(self.recv_enter_game_result,self))
	PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_2,bind(self.recv_enter_game_result,self))
	PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_3,bind(self.recv_enter_game_result,self))
end

function GameCC:req_enter_game(flag)
	PacketDispatcher:send_protocol(PROTOCOL_ID.C_1_1,flag)
end

function GameCC:recv_enter_game_result(player_array)
	GameModel:set_cur_player_array(player_array)
end

function GameCC:add_player(player_info)
	GameModel:add_player(player_info)
end

GameCC:init()