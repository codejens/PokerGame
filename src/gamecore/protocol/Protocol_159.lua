protocol_func_map_client[159] = {
    --请求玩家登陆奖励领取情况
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 2 ) 
        NetManager:send_packet( np )
    end,

    --领取登陆奖励
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 3 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求等级排行信息
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 4 ) 
        NetManager:send_packet( np )
    end,

    --请求战力排行信息
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 5 ) 
        NetManager:send_packet( np )
    end,

    --请求龙破霸主活动奖励领取情况
    --客户端发送
    [6] = function ( 
                param_1_unsigned_char -- 第几个活动--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 6 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取龙破霸主活动奖励
    --客户端发送
    [7] = function ( 
                param_1_unsigned_char,  -- 第几个活动
                param_2_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 7 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --查看龙破霸主活动排行榜
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char -- 第几个排行榜--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 8 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求套装奖励领取情况
    --客户端发送
    [9] = function ( 
                param_1_unsigned_char -- 奖励类型，1紫装，2橙装
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 9 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取套装奖励
    --客户端发送
    [10] = function ( 
                param_1_unsigned_char,  -- 奖励类型，1紫装，2橙装
                param_2_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 10 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求成就达人奖励领取情况
    --客户端发送
    [11] = function ( 
                param_1_unsigned_char -- 第几个活动--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 11 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取成就达人奖励
    --客户端发送
    [12] = function ( 
                param_1_unsigned_char,  -- 第几个活动
                param_2_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 12 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求玩家帮派奖励领取情况
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 13 ) 
        NetManager:send_packet( np )
    end,

    --领取帮派奖励
    --客户端发送
    [14] = function ( 
                param_1_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 14 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --封测大礼_欢乐转盘抽奖
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 15 ) 
        NetManager:send_packet( np )
    end,

    --封测大礼_领取登陆好礼活动信息
    --客户端发送
    [16] = function ( 
                param_1_unsigned_char -- 奖励的序号，1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 16 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --封测大礼_请求全民冲级活动信息
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 17 ) 
        NetManager:send_packet( np )
    end,

    --封测大礼_领取全民冲级奖励
    --客户端发送
    [18] = function ( 
                param_1_unsigned_char -- 奖励下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 18 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --封测大礼_请求活跃好礼活动信息
    --客户端发送
    [24] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 24 ) 
        NetManager:send_packet( np )
    end,

    --封测大礼_领取活跃好礼奖励
    --客户端发送
    [25] = function ( 
                param_1_unsigned_char -- 奖励下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 159, 25 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[159] = {
    --下发封测活动状态
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0为结束
        PacketDispatcher:dispather( 159, 1, var_1_int )--分发数据
    end,

    --封测大礼_下发欢乐转盘活动信息
    --接收服务器
    [15] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家可抽奖次数
        local var_2_unsigned_char = np:readByte( ) --当前抽中下标，登陆时下发的是0
        PacketDispatcher:dispather( 159, 15, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --封测大礼_下发欢乐转盘获奖者名单
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_string = np:readString( ) --玩家名字
        local var_3_unsigned_char = np:readByte( ) --奖励类型，0元宝，1道具
        local var_4_int = np:readInt( ) --玩家获得元宝数（道具ID）
        PacketDispatcher:dispather( 159, 20, var_1_int, var_2_string, var_3_unsigned_char, var_4_int )--分发数据
    end,

    --封测大礼_新增全民冲级获得者
    --接收服务器
    [22] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_string = np:readString( ) --玩家名
        local var_3_unsigned_char = np:readByte( ) --玩家获得几级奖励
        PacketDispatcher:dispather( 159, 22, var_1_int, var_2_string, var_3_unsigned_char )--分发数据
    end,

    --封测大礼_下发活动状态
    --接收服务器
    [23] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0为结束
        PacketDispatcher:dispather( 159, 23, var_1_int )--分发数据
    end,

    --封测大礼_新增活跃好礼获得者
    --接收服务器
    [27] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_string = np:readString( ) --玩家名
        local var_3_unsigned_char = np:readByte( ) --玩家获得什么奖励
        PacketDispatcher:dispather( 159, 27, var_1_int, var_2_string, var_3_unsigned_char )--分发数据
    end,


}
