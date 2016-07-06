protocol_func_map_client[6] = {
    --请求任务列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 6, 1 ) 
        NetManager:send_packet( np )
    end,

    --放弃任务
    --客户端发送
    [4] = function ( 
                param_1_unsigned_short -- 任务id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 6, 4 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --快速完成任务
    --客户端发送
    [10] = function ( 
                param_1_unsigned_short -- 任务ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 6, 10 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --任务完成后，玩家点击【立即领取】按钮
    --客户端发送
    [12] = function ( 
                param_1_unsigned_short -- 任务ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 6, 12 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[6] = {
    --放弃任务的结果
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务id
        local var_2_char = np:readChar( ) --结果，0是成功
        PacketDispatcher:dispather( 6, 4, var_1_unsigned_short, var_2_char )--分发数据
    end,

    --新增一个任务
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务id
        local var_2_char = np:readChar( ) --结果，恒为0
        PacketDispatcher:dispather( 6, 2, var_1_unsigned_short, var_2_char )--分发数据
    end,

    --完成任务
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务id
        local var_2_char = np:readChar( ) --结果，恒为0
        PacketDispatcher:dispather( 6, 3, var_1_unsigned_short, var_2_char )--分发数据
    end,

    --设置任务进度值
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务id
        local var_2_unsigned_char = np:readByte( ) --索引值
        local var_3_int = np:readInt( ) --进度值
        PacketDispatcher:dispather( 6, 8, var_1_unsigned_short, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --快速完成结果返回
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务ID
        local var_2_char = np:readChar( ) --返回结果
        PacketDispatcher:dispather( 6, 10, var_1_unsigned_short, var_2_char )--分发数据
    end,

    --删除一个可接任务
    --接收服务器
    [11] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务ID
        PacketDispatcher:dispather( 6, 11, var_1_unsigned_short )--分发数据
    end,

    --立即领取按钮结果返回
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务ID
        local var_2_unsigned_char = np:readByte( ) --返回结果
        PacketDispatcher:dispather( 6, 12, var_1_unsigned_short, var_2_unsigned_char )--分发数据
    end,


}
