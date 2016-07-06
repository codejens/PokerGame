protocol_func_map_client[47] = {
    --获取仓库列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 1 ) 
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
        local np = NetManager:get_NetPacket( 47, 2 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --获取闯关信息
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 5 ) 
        NetManager:send_packet( np )
    end,

    --购买闯关次数
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 6 ) 
        NetManager:send_packet( np )
    end,

    --开始闯关,返回14协议
    --客户端发送
    [7] = function ( 
                param_1_int,  -- 闯关第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 出战宠物id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 7 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --开始扫荡
    --客户端发送
    [10] = function ( 
                param_1_int,  -- 扫荡副本的个数
                param_2_array -- 扫荡第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 10 ) 
        np:writeInt( param_1_int )
        for i = 1, param_1_int do 
            -- protocol manual client 数组
            -- 扫荡第几个副本--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_2_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --获取扫荡信息，返回10号消息
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 11 ) 
        NetManager:send_packet( np )
    end,

    --立即完成扫荡,会返回n条12和1条13
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 12 ) 
        NetManager:send_packet( np )
    end,

    --停止扫荡
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 13 ) 
        NetManager:send_packet( np )
    end,

    --珍宝囊整理，如果成功则返回珍宝囊列表
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 47, 15 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[47] = {
    --仓库物品移动到背包
    --接收服务器
    [2] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --0:不成功，1成功
        local var_3_unsigned_char = np:readByte( ) --物品类型，0表示全部--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 47, 2, var_1_int64, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --仓库物品数量变化
    --接收服务器
    [4] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID
        local var_2_unsigned_short = np:readWord( ) --物品的新数量
        PacketDispatcher:dispather( 47, 4, var_1_int64, var_2_unsigned_short )--分发数据
    end,

    --购买闯关次数返回
    --接收服务器
    [6] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        local var_2_int = np:readInt( ) --已经购买次数
        PacketDispatcher:dispather( 47, 6, var_1_int, var_2_int )--分发数据
    end,

    --通知闯关失败
    --接收服务器
    [7] = function ( np )
        PacketDispatcher:dispather( 47, 7 )--分发数据
    end,

    --通知一次扫荡完成
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        local var_2_int = np:readInt( ) --完成扫荡的副本索引--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 47, 12, var_1_int, var_2_int )--分发数据
    end,

    --开始闯关返回,再次登录后还在闯关副本中也会发送
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --闯关的副本索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --刷第几组怪--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --出战宠物id
        PacketDispatcher:dispather( 47, 9, var_1_int, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --通知刷出新的一组怪
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --副本所在索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --第几组怪--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 47, 14, var_1_int, var_2_int )--分发数据
    end,


}
