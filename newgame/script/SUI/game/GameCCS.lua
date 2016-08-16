GameCCS = {}

function GameCCS:init()
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_1,bind(self.recv_enter_game_result,self))
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_2,bind(self.recv_add_player,self))
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_3,bind(self.delete_player,self))
end

function GameCCS:recv_enter_game_result()
	local num = math.random(1,4)
	local player_array = {}
	local function get_player_info(num)
	    local have_pos = {5,1,3,4,6,8,7,9}
	    local array = {}
	    array.id = 1000 + num
	    array.sex = math.random(0,1)
	    array.name = "赌圣_" .. num
	    array.yuanbao = math.random(0,10000)
	    array.money = math.random(1000,99999999)
	    array.cur_money = math.random(1,9999999)
	    array.head_type = math.random(1,10)
	    array.mantra = "我们来盲注"
	    array.index = GameConfig:get_have_pos(num)
	    return array        
	end
	for i = 1 , num do
		player_array[i] = get_player_info(num)
	end
	GameModel:set_cur_player_array(player_array)
end

function GameCCS:delete_player(index)
	GameModel:delete_player(index)
end

function GameCCS:recv_add_player(player_info)
	GameModel:add_player(player_info)
end

function GameCCS:add_player(player_info)
	GameModel:add_player(player_info)
end

GameCCS:init()