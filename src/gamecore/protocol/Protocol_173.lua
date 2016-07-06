protocol_func_map_client[173] = {
    --进入海选场景
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 1 ) 
        NetManager:send_packet( np )
    end,

    --取消匹配
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 2 ) 
        NetManager:send_packet( np )
    end,

    --退出海选赛场景
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 3 ) 
        NetManager:send_packet( np )
    end,

    --进入争霸赛场景
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 4 ) 
        NetManager:send_packet( np )
    end,

    --鲜花or鸡蛋
    --客户端发送
    [5] = function ( 
                param_1_int,  -- 目标玩家ID
                param_2_unsigned_char -- 操作类型，1鲜花2鸡蛋
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 5 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取荣誉
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 6 ) 
        NetManager:send_packet( np )
    end,

    --请求本届自由赛我的信息
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 7 ) 
        NetManager:send_packet( np )
    end,

    --请求自由赛排行榜
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char -- 第几页
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 8 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求上届16强信息
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 9 ) 
        NetManager:send_packet( np )
    end,

    --请求历届仙王信息
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 10 ) 
        NetManager:send_packet( np )
    end,

    --请求本届争霸赛信息
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 11 ) 
        NetManager:send_packet( np )
    end,

    --下注
    --客户端发送
    [12] = function ( 
                param_1_unsigned_char,  -- 第几轮
                param_2_unsigned_char,  -- 第几场
                param_3_unsigned_char,  -- 投注编号
                param_4_int -- 投注仙币
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 173, 12 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        np:writeInt( param_4_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[173] = {
    --开始匹配
    --接收服务器
    [1] = function ( np )
        PacketDispatcher:dispather( 173, 1 )--分发数据
    end,

    --下发海选赛统计面板
    --接收服务器
    [2] = function ( np )
        PacketDispatcher:dispather( 173, 2 )--分发数据
    end,

    --下发本届自由赛我的信息
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --名次
        local var_2_int = np:readInt( ) --积分
        local var_3_int = np:readInt( ) --累计比赛次数
        local var_4_int = np:readInt( ) --累计胜利次数
        PacketDispatcher:dispather( 173, 7, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --下发领取荣誉奖励
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --领取状态，1可领取，0关闭领取图标
        PacketDispatcher:dispather( 173, 6, var_1_unsigned_char )--分发数据
    end,


}
