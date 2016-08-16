GameCC = {}

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

   	if RoleModel:is_self(array.id) then
   		array.state = math.random(0,2) --2站起
    else
    	array.state = math.random(0,2) --弃牌,等下一局
    end
    array.mantra = "我们来盲注"
    array.index = GameConfig:get_have_pos(num)
    return array        
end

function GameCC:init()
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_1,bind(self.recv_enter_game_result,self))
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_2,bind(self.recv_add_player,self))
	-- PacketDispatcher:register_protocol_callback(PROTOCOL_ID.S_1_3,bind(self.delete_player,self))
end

function GameCC:req_enter_game(flag)
	-- PacketDispatcher:send_protocol(PROTOCOL_ID.C_1_1,flag)
	local array = {}
	local num = 3
	array.room_id = 10001
	array.big_room_type = 1
	array.small_room_type = 1
	array.player_array = {}

	for i = 1 , num do
		array.player_array[i] = get_player_info(i)
	end
	self:recv_enter_game_result(array)

	local function call_1()
		self:recv_add_player(get_player_info(4))
	end
	local call1 = callback:new()
	call1:start(2,call_1)

	local function call_2()
		self:delete_player(2)
	end
	local call2 = callback:new()
	call2:start(3,call_2)
end

function GameCC:recv_enter_game_result(array)
	GameModel:set_cur_room_data(array)
	-- GameModel:set_cur_player_array(array.player_array)
end

function GameCC:delete_player(index)
	GameModel:delete_player(index)
end

function GameCC:recv_add_player(player_info)
	GameModel:add_player(player_info)
end

GameCC:init()