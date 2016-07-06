protocol_func_map_client[44] = {
    --请求神器信息
    --客户端发送
    [1] = function ( 
                param_1_int -- 玩家ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 1 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --修炼神器
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char,  -- 第几个神器
                param_2_unsigned_char -- 是否自动购买，1是0否
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 2 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --神器转生
    --客户端发送
    [3] = function ( 
                param_1_char -- 第几个神器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 3 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --请求觅灵信息
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 4 ) 
        NetManager:send_packet( np )
    end,

    --引灵
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 5 ) 
        NetManager:send_packet( np )
    end,

    --领取灵符
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 6 ) 
        NetManager:send_packet( np )
    end,

    --请求技能回忆数据
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 7 ) 
        NetManager:send_packet( np )
    end,

    --请求回忆
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char,  -- 回忆类型，1普通，2完美
                param_2_unsigned_char -- 是否自动选择--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 8 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --玩家选择回忆
    --客户端发送
    [9] = function ( 
                param_1_unsigned_char -- 回忆下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 9 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --觅灵
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 44, 10 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[44] = {
    --返回当前回忆数据
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否存在完美回忆，1是0否
        PacketDispatcher:dispather( 44, 7, var_1_unsigned_char )--分发数据
    end,


}
