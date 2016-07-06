protocol_func_map_client[146] = {
    --请求周环任务信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 146, 1 ) 
        NetManager:send_packet( np )
    end,

    --轻松跳环（解环）
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char -- 是否自动购买，1是0否
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 146, 3 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取周跑环阶段奖励
    --客户端发送
    [2] = function ( 
                param_1_int -- 要领取累计第几天的奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 146, 2 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --接任务
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 146, 5 ) 
        NetManager:send_packet( np )
    end,

    --领取特殊环附加经验奖励
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 146, 6 ) 
        NetManager:send_packet( np )
    end,

    --完成任务
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 146, 4 ) 
        NetManager:send_packet( np )
    end,

    --设置是否播放筛子动画(停用)
    --客户端发送
    [7] = function ( 
                param_1_unsigned_char -- 1是0否
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 146, 7 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[146] = {
    --丢骰子结果(停用)
    --接收服务器
    [4] = function ( np )
        local var_1_char = np:readChar( ) --丢骰子结果(经验倍数)
        local var_2_int = np:readInt( ) --已完成的环数
        PacketDispatcher:dispather( 146, 4, var_1_char, var_2_int )--分发数据
    end,

    --下发是否播放筛子动画(停用)
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1是0否
        PacketDispatcher:dispather( 146, 7, var_1_unsigned_char )--分发数据
    end,


}
