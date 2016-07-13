protocol_func_map_client[1] = {
    [1] = function(
                param_1_int    --flag,1/快速场,2/自由场,3/竞技场
                )
        --@debug_begin
        protocol_func_map:check_param_type({
            { param_name = param_1_int, lua_type = "number" }, 
        })
        --@debug_end
        local np = NetManager:get_NetPacket(1,1) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )

        protocol_func_map_server[1][1]()
    end
    [2] = function(param_1_int)
        if param_1_int == 1 then
            protocol_func_map_server[1][2]()
        end
    end
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
    array.index = have_pos[num]
    return array        
end

protocol_func_map_server[1] = {
    [1] = function ( np )
        local val_1_init = 5
        local val_array = {}
        for num = 1 , val_1_init do
            local array = get_player_info(np,num)
            -- table.insert(val_array,array)
            val_array[array.index] = array
        end
        PacketDispatcher:dispather(1,1, val_array)--分发数据
    end,
    [2] = function(np)
        local array = get_player_info(np)
        PacketDispatcher:dispather(1,2, array)--分发数据
    end
    [3] = function(np)
        local index = 5
        PacketDispatcher:dispather(1,3,index)

    end
}
