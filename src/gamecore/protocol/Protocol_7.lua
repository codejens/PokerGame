protocol_func_map_client[7] = {
    --穿上装备
    --客户端发送
    [1] = function ( 
                param_1_unsigned_int64 -- 装备的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 7, 1 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --脱下装备
    --客户端发送
    [2] = function ( 
                param_1_unsigned_int64 -- 装备的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 7, 2 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --脱下指定位置的装备
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char -- 装备位置
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 7, 3 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取玩家身上的装备
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 7, 4 ) 
        NetManager:send_packet( np )
    end,

    --查看其他玩家的装备
    --客户端发送
    [5] = function ( 
                param_1_string -- 玩家的名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 7, 5 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --显示或隐藏时装
    --客户端发送
    [6] = function ( 
                param_1_int -- 显示或隐藏标志位--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 7, 6 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[7] = {
    --通知客户端装备一件物品
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备的guid
        PacketDispatcher:dispather( 7, 1, var_1_unsigned_int64 )--分发数据
    end,

    --脱下装备
    --接收服务器
    [2] = function ( np )
        local var_1_int64 = np:readInt64( ) --装备的guid
        PacketDispatcher:dispather( 7, 2, var_1_int64 )--分发数据
    end,

    --装备的耐久发生变化
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备的guid
        local var_2_unsigned_int = np:readUInt( ) --装备的耐久的数值
        PacketDispatcher:dispather( 7, 4, var_1_unsigned_int64, var_2_unsigned_int )--分发数据
    end,

    --删除装备
    --接收服务器
    [6] = function ( np )
        local var_1_int64 = np:readInt64( ) --装备的guid
        PacketDispatcher:dispather( 7, 6, var_1_int64 )--分发数据
    end,


}
