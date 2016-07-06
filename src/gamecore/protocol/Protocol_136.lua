protocol_func_map_client[136] = {
    --修理事情请求
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char,  -- 请求类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_int64,  -- 修理物品的GUID--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- 物品所在位置--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_int64, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 136, 1 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeUint64( param_2_unsigned_int64 )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --修理事情处理
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char,  -- 修理类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_int64,  -- 修理物品的GUID--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- 物品位置--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_int64, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 136, 2 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeUint64( param_2_unsigned_int64 )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --使用磨刀石维修装备
    --客户端发送
    [3] = function ( 
                param_1_char,  -- 维修的装备是身上的还是背包里的--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int64 -- 装备的GUID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 136, 3 ) 
        np:writeChar( param_1_char )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[136] = {
    --返回客户端修理结果
    --接收服务器
    [2] = function ( np )
        local var_1_bool = np:readChar( ) --修理是否成功
        PacketDispatcher:dispather( 136, 2, var_1_bool )--分发数据
    end,

    --返回客户端修理的消耗
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --修理类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --修理需要的钱
        local var_3_unsigned_int = np:readUInt( ) --物品ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_int64 = np:readUint64( ) --修理物品的GUID--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_char = np:readByte( ) --物品位置--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 136, 1, var_1_unsigned_char, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int64, var_5_unsigned_char )--分发数据
    end,

    --使用磨刀石维修装备
    --接收服务器
    [3] = function ( np )
        PacketDispatcher:dispather( 136, 3 )--分发数据
    end,


}
