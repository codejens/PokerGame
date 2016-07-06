protocol_func_map_client[142] = {
    --刷新梦境物品,用户每次打开界面，都发送这个消息
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char,  -- 梦境类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 是否强制刷新,0:false,1:true--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 142, 1 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --盗梦，如果成功，会下发消息2
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char,  -- 梦境类型
                param_2_unsigned_char,  -- 盗梦类型--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- 0:元宝，1：盗梦符
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 142, 2 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取首页信息,服务器端会分别4条消息下发
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 142, 3 ) 
        NetManager:send_packet( np )
    end,

    --领取梦阶的奖励物品
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 142, 5 ) 
        NetManager:send_packet( np )
    end,

    --获取仓库列表
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 142, 4 ) 
        NetManager:send_packet( np )
    end,

    --仓库物品移到背包
    --客户端发送
    [9] = function ( 
                param_1_int64 -- 物品序列号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 142, 9 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[142] = {
    --下发梦阶值
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --梦阶的点数
        local var_2_unsigned_short = np:readWord( ) --可领取的物品id--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 142, 3, var_1_int, var_2_unsigned_short )--分发数据
    end,

    --盗梦结果
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_short = np:readWord( ) --仓库总数
        PacketDispatcher:dispather( 142, 2, var_1_unsigned_char, var_2_unsigned_short )--分发数据
    end,

    --领取是否成功
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --第几阶
        PacketDispatcher:dispather( 142, 5, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --到了刷新的时间。客户端收到本消息，如果界面正在打开中，则发送消息1
    --接收服务器
    [7] = function ( np )
        PacketDispatcher:dispather( 142, 7 )--分发数据
    end,

    --移动的结果
    --接收服务器
    [9] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号
        local var_2_unsigned_char = np:readByte( ) --0:不成功，1成功
        PacketDispatcher:dispather( 142, 9, var_1_int64, var_2_unsigned_char )--分发数据
    end,


}
