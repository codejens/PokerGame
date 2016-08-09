protocol_func_map_client[1] = {
    [1] = function(
                param_1_int    --flag,1/快速场,2/自由场,3/竞技场
                )
        protocol_func_map_server[1][1](param_1_int)
    end,
    [2] = function(param_1_int)
        --新进来一个玩家
        --@debug_begin
        protocol_func_map:check_param_type({
            { param_name = param_1_int, lua_type = "number" }, 
        })
        --@debug_end
        if is_no_server then
            protocol_func_map_server[1][2](nil,7)
        else
            local np = NetManager:get_NetPacket(1,2) 
            np:writeInt(param_1_int)
            NetManager:send_packet(np)
        end
    end,
    [3] = function(param_1_int)
        print("send player leave 1,3")
        protocol_func_map_server[1][3]()
    end,
    [4] = function(param_1_int)
        protocol_func_map_server[1][4]()
    end,
}

local function get_player_info(np,num)
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

protocol_func_map_server[1] = {
    [1] = function ( param_1_int )
        if param_1_int == 1 then --快速入场
            --进入房间收到该房间的玩家列表
            local val_1_init = math.random(1,5)
            local val_array = {}
            for num = 1 , val_1_init do
                local array = get_player_info(num)
                val_array[array.index] = array
            end
            PacketDispatcher:dispather(1,1, val_array)--分发数据
        elseif param_1_int == 2 then --自由场
            local val_1_init = 4 --4大类
            
        elseif param_1_int == 3 then --竞技场

        end
    end,
    [2] = function(np,num)
        --新进来一个玩家
        print("recv player_info 1,2")
        local array = get_player_info(np,num)
        PacketDispatcher:dispather(1,2, array)--分发数据
    end,
    [3] = function(np)
        --玩家离去
        print("recv player leave 1,3")
        local index = 5
        PacketDispatcher:dispather(1,3,index)
    end,
    [4] = function()
        --给玩家发牌
        local index = 5

    end
}
