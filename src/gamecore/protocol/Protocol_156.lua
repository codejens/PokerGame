protocol_func_map_client[156] = {
    --请求清明登陆子活动信息
    --客户端发送
    [2] = function ( 
                param_1_char -- 子活动类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 156, 2 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --领取清明登陆活动奖励
    --客户端发送
    [4] = function ( 
                param_1_int -- 领取奖励的选项--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 156, 4 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求领取每日消费活动奖励
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 156, 6 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[156] = {
    --下发放生祈福活动信息
    --接收服务器
    [2] = function ( np )
        local var_1_short = np:readShort( ) --任务数量--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 156, 2, var_1_short )--分发数据
    end,

    --下发清明每日消费活动信息
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --已消费元宝
        local var_2_int = np:readInt( ) --需要消费的元宝的量数
        local var_3_int = np:readInt( ) --领取状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 156, 5, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --下发老友回家活动信息
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --图标闪烁--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --活动时间
        PacketDispatcher:dispather( 156, 7, var_1_int, var_2_int )--分发数据
    end,

    --下发清明鬼府夜游，鬼府慑怨灵活动信息
    --接收服务器
    [8] = function ( np )
        local var_1_char = np:readChar( ) --剩余进入副本的次数
        PacketDispatcher:dispather( 156, 8, var_1_char )--分发数据
    end,


}
