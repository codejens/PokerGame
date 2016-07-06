protocol_func_map_client[151] = {
    --获取送花奖励信息
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 151, 2 ) 
        NetManager:send_packet( np )
    end,

    --领取送花奖励（成功后会重新发送2）
    --客户端发送
    [3] = function ( 
                param_1_int -- 第几个--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 151, 3 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取魅力奖励信息
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 151, 4 ) 
        NetManager:send_packet( np )
    end,

    --领取魅力奖励（成功后会重新发4）
    --客户端发送
    [5] = function ( 
                param_1_int -- 第几个（从1开始）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 151, 5 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取美女活动信息
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 151, 6 ) 
        NetManager:send_packet( np )
    end,

    --获取情人节优惠活动信息
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 151, 7 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[151] = {
    --发送情人节活动图标状态
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --状态（0为隐藏，1为显示）
        PacketDispatcher:dispather( 151, 1, var_1_int )--分发数据
    end,

    --发送送花奖励信息
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（秒）
        local var_2_unsigned_char = np:readByte( ) --9朵玫瑰的领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --99朵玫瑰的领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_char = np:readByte( ) --999朵玫瑰的领取状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 151, 2, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --发送美女活动信息
    --接收服务器
    [6] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（秒）
        PacketDispatcher:dispather( 151, 6, var_1_int )--分发数据
    end,

    --发送情人节优惠活动信息
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（秒）
        PacketDispatcher:dispather( 151, 7, var_1_int )--分发数据
    end,


}
