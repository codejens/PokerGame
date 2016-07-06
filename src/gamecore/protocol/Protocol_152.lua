protocol_func_map_client[152] = {
    --激活或升级某个龙魂
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char -- 第几个龙魂
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 152, 1 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --龙魂幻化
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char -- 幻化第几个龙魂
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 152, 2 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --查看他人龙魂信息
    --客户端发送
    [3] = function ( 
                param_1_int -- 玩家ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 152, 3 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[152] = {
    --下发龙魂可升级信息
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --几个龙魂可激活或升级
        local var_2_unsigned_char = np:readByte( ) --龙魂下标数组，每个为byte类型
        PacketDispatcher:dispather( 152, 2, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,


}
