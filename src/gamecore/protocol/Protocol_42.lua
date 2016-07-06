protocol_func_map_client[42] = {
    --获取仓库物品列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 42, 1 ) 
        NetManager:send_packet( np )
    end,

    --仓库物品移动到背包
    --客户端发送
    [2] = function ( 
                param_1_int64 -- 物品序列号--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 42, 2 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --获取委托副本信息
    --客户端发送
    [5] = function ( 
                param_1_int -- 副本ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 42, 5 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --委托
    --客户端发送
    [6] = function ( 
                param_1_int,  -- 副本ID
                param_2_unsigned_char,  -- 委托类型--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 次数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 42, 6 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --立即完成
    --客户端发送
    [7] = function ( 
                param_1_int -- 副本ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 42, 7 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取经验
    --客户端发送
    [8] = function ( 
                param_1_int -- 副本ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 42, 8 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[42] = {
    --移动结果
    --接收服务器
    [2] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号，如果是0，表示全部转移
        local var_2_unsigned_char = np:readByte( ) --0:不成功，1成功
        PacketDispatcher:dispather( 42, 2, var_1_int64, var_2_unsigned_char )--分发数据
    end,

    --仓库物品数量变化
    --接收服务器
    [4] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID
        local var_2_unsigned_short = np:readWord( ) --物品的新数量
        PacketDispatcher:dispather( 42, 4, var_1_int64, var_2_unsigned_short )--分发数据
    end,

    --发送委托副本信息
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --副本ID
        local var_2_int = np:readInt( ) --最后一次委托的层数
        local var_3_int = np:readInt( ) --委托次数
        local var_4_unsigned_char = np:readByte( ) --状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_char = np:readByte( ) --是否下线后再上线--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_unsigned_int = np:readUInt( ) --剩余时间
        local var_7_unsigned_char = np:readByte( ) --仙币委托还是元宝委托
        PacketDispatcher:dispather( 42, 5, var_1_int, var_2_int, var_3_int, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_int, var_7_unsigned_char )--分发数据
    end,

    --委托开始
    --接收服务器
    [6] = function ( np )
        local var_1_int = np:readInt( ) --副本ID
        local var_2_int = np:readInt( ) --第几次
        PacketDispatcher:dispather( 42, 6, var_1_int, var_2_int )--分发数据
    end,

    --委托结束
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --副本ID
        local var_2_unsigned_char = np:readByte( ) --仙币委托还是元宝委托--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 42, 7, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --获取经验结果
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --副本ID
        local var_2_int = np:readInt( ) --领取结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 42, 8, var_1_int, var_2_int )--分发数据
    end,

    --副本最大通关层数变化
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --副本ID
        local var_2_int = np:readInt( ) --最大通关层数
        PacketDispatcher:dispather( 42, 9, var_1_int, var_2_int )--分发数据
    end,


}
