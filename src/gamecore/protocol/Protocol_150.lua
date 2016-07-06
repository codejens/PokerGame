protocol_func_map_client[150] = {
    --获取新年活动连续登陆奖励
    --客户端发送
    [3] = function ( 
                param_1_int,  -- 状态--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 领取类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 150, 3 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --获取新年副本的次数
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 150, 4 ) 
        NetManager:send_packet( np )
    end,

    --领取新年消费礼包
    --客户端发送
    [5] = function ( 
                param_1_int -- 状态--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 150, 5 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --向财神索要礼包
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 150, 6 ) 
        NetManager:send_packet( np )
    end,

    --收集春联
    --客户端发送
    [7] = function ( 
                param_1_int -- 春联ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 150, 7 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取压岁钱
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 150, 8 ) 
        NetManager:send_packet( np )
    end,

    --获取新年活动回馈信息
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 150, 2 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[150] = {
    --下发新年活动回馈信息
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --活动期间累计消费金额
        local var_2_int = np:readInt( ) --下一级返回金额
        local var_3_int = np:readInt( ) --当前返回利率
        local var_4_int = np:readInt( ) --下一级返回利率
        PacketDispatcher:dispather( 150, 2, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --获取新年副本的次数
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        PacketDispatcher:dispather( 150, 4, var_1_int )--分发数据
    end,

    --领取新年消费礼包
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --领取礼包的状况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --当日已消费的元宝
        PacketDispatcher:dispather( 150, 5, var_1_int, var_2_int )--分发数据
    end,

    --向财神索要礼包
    --接收服务器
    [6] = function ( np )
        PacketDispatcher:dispather( 150, 6 )--分发数据
    end,

    --收集春联
    --接收服务器
    [7] = function ( np )
        PacketDispatcher:dispather( 150, 7 )--分发数据
    end,

    --领取压岁钱
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --是否显示--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 150, 8, var_1_int )--分发数据
    end,


}
