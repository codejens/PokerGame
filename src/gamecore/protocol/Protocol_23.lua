protocol_func_map_client[23] = {
    --获取仓库物品列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 1 ) 
        NetManager:send_packet( np )
    end,

    --背包拖一个物品到仓库
    --客户端发送
    [2] = function ( 
                param_1_int64,  -- 物品的guid
                param_2_int64 -- 目标位置物品的guid--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 2 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --仓库拖一个物品到背包
    --客户端发送
    [3] = function ( 
                param_1_int64,  -- 物品的guid
                param_2_int64 -- 目标位置物品的guid--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 3 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --丢弃仓库物品
    --客户端发送
    [4] = function ( 
                param_1_int64 -- 物品的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 4 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --扩展仓库格子数量
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 5 ) 
        NetManager:send_packet( np )
    end,

    --获取扩展仓库格子的费用列表
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 6 ) 
        NetManager:send_packet( np )
    end,

    --拆分仓库物品
    --客户端发送
    [7] = function ( 
                param_1_int64,  -- 拆分物品的GUID
                param_2_unsigned_short -- 拆分出来的物品数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 7 ) 
        np:writeInt64( param_1_int64 )
        np:writeWord( param_2_unsigned_short )
        NetManager:send_packet( np )
    end,

    --合并仓库物品
    --客户端发送
    [8] = function ( 
                param_1_int64,  -- 源物品的guid
                param_2_int64 -- 目标物品的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 8 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --整理仓库物品
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 9 ) 
        NetManager:send_packet( np )
    end,

    --通过在线时间累计打开仓库格子
    --客户端发送
    [11] = function ( 
                param_1_int,  -- 打开仓库的格子数量
                param_2_int -- 第几个仓库格子
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 11 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求通过元宝打开仓库格子的信息
    --客户端发送
    [12] = function ( 
                param_1_int,  -- 打开仓库格子的数量
                param_2_int -- 打开仓库格子中的第一个格子的位置--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 12 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --通过元宝打开仓库格子
    --客户端发送
    [13] = function ( 
                param_1_int,  -- 打开仓库格子的数量
                param_2_int -- 打开仓库格子中的第一个格子的位置--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 23, 13 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[23] = {
    --删除物品
    --接收服务器
    [3] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的guid
        PacketDispatcher:dispather( 23, 3, var_1_int64 )--分发数据
    end,

    --仓库的物品数量发生改变
    --接收服务器
    [4] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的guid
        local var_2_unsigned_char = np:readByte( ) --物品的新数量
        PacketDispatcher:dispather( 23, 4, var_1_int64, var_2_unsigned_char )--分发数据
    end,

    --发送仓库扩展需要的费用
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --需要的元宝数量
        local var_2_unsigned_char = np:readByte( ) --扩展的背包的格子数量
        PacketDispatcher:dispather( 23, 5, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发仓库自动开启
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --开启仓库格子需要的在线总时间
        local var_2_int = np:readInt( ) --开启仓库格子的剩余时间
        PacketDispatcher:dispather( 23, 10, var_1_int, var_2_int )--分发数据
    end,

    --下发通过元宝打开仓库格子的信息
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --依靠在线时间累计打开仓库格子的在线时间
        local var_2_int = np:readInt( ) --打开仓库格子消耗的元宝数量
        local var_3_int = np:readInt( ) --开启仓库格子数量
        local var_4_int = np:readInt( ) --获得的血量提升
        local var_5_int = np:readInt( ) --获得的法攻提升
        local var_6_int = np:readInt( ) --获得的物攻提升
        PacketDispatcher:dispather( 23, 12, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int )--分发数据
    end,

    --返回通过元宝打开仓库格子的结果
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --开启格子的数量
        local var_2_int = np:readInt( ) --开启格子的位置
        PacketDispatcher:dispather( 23, 13, var_1_int, var_2_int )--分发数据
    end,

    --下发通过在线时间累积打开仓库格子的结果
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --开启格子的位置
        local var_2_int = np:readInt( ) --开启格子的位置
        PacketDispatcher:dispather( 23, 11, var_1_int, var_2_int )--分发数据
    end,


}
