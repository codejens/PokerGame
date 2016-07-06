protocol_func_map_client[174] = {
    --获取恭喜发财玩家数据
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 1 ) 
        NetManager:send_packet( np )
    end,

    --获取玩家珍宝云梯的活动数据
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 2 ) 
        NetManager:send_packet( np )
    end,

    --玩家掷筛子
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char -- 确认玩家是用元宝还是仙币--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 3 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --玩家兑换物品
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char,  -- 玩家是用玉石还是积分兑换--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 兑换物品所在的下标--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 4 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求神树活动数据
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 7 ) 
        NetManager:send_packet( np )
    end,

    --请求神树活动数据
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 8 ) 
        NetManager:send_packet( np )
    end,

    --浇水一次
    --客户端发送
    [9] = function ( 
                param_1_unsigned_char -- 浇水次数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 9 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领取微端礼包
    --客户端发送
    [11] = function ( 
                param_1_unsigned_char -- 礼包编号， 1表示微端下周礼包，2-4表示微端每日礼包
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 11 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领取联盟服会员开通、续费大礼
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 13 ) 
        NetManager:send_packet( np )
    end,

    --获取粉钻活动奖励情况
    --客户端发送
    [150] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 150 ) 
        NetManager:send_packet( np )
    end,

    --领取粉钻活动奖励
    --客户端发送
    [151] = function ( 
                param_1_int,  -- 奖励ID
                param_2_string -- 许愿语句内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 151 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --请求领取每日进阶礼包
    --客户端发送
    [152] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 152 ) 
        NetManager:send_packet( np )
    end,

    --获取黄钻活动奖励情况
    --客户端发送
    [154] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 154 ) 
        NetManager:send_packet( np )
    end,

    --领取黄钻活动奖励
    --客户端发送
    [155] = function ( 
                param_1_int,  -- 奖励ID
                param_2_string -- 许愿语句内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 174, 155 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[174] = {
    --团圆盛宴下发活动状态，该协议是在activitycommon.lua执行
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --剩余活动时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 174, 1, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --恭喜发财活动状态下发，activitycommon.lua下发
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 174, 2, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发珍宝云梯活动状态，activitycommon.lua下发协议
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --剩余活动时间
        local var_2_unsigned_char = np:readByte( ) --活动配置
        PacketDispatcher:dispather( 174, 4, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发珍宝云梯玩家活动数据
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --玩家累积的积分
        local var_2_int = np:readInt( ) --玩家拥有的玉石数量
        local var_3_unsigned_char = np:readByte( ) --玩家当前所处的层数
        local var_4_unsigned_char = np:readByte( ) --玩家所处层数的具体位置
        local var_5_unsigned_char = np:readByte( ) --玩家点亮的钻石数量
        local var_6_unsigned_char = np:readByte( ) --使用仙币的剩余次数
        PacketDispatcher:dispather( 174, 5, var_1_int, var_2_int, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char )--分发数据
    end,

    --掷筛子产生的点数
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --具体的点数
        PacketDispatcher:dispather( 174, 6, var_1_unsigned_char )--分发数据
    end,

    --神树活动状态
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置
        PacketDispatcher:dispather( 174, 7, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --神树活动数据，如成熟度等，是否当天第一浇水
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0：第一次浇水，1：非第一次浇水
        local var_2_int = np:readInt( ) --神树成熟度
        local var_3_int = np:readInt( ) --神树等级
        local var_4_int = np:readInt( ) --剩余时间
        local var_5_int = np:readInt( ) --配置类型1，2
        PacketDispatcher:dispather( 174, 8, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --下发活动状态蓝钻续费活动状态
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --领取次数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 174, 10, var_1_unsigned_char )--分发数据
    end,

    --下发微端礼包状态
    --接收服务器
    [11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --微端下载礼包状态， 0表示没有领取， 1表示领取
        local var_2_unsigned_char = np:readByte( ) --微端每日礼包1状态
        local var_3_unsigned_char = np:readByte( ) --微端每日礼包2状态
        local var_4_unsigned_char = np:readByte( ) --微端每日礼包3状态
        PacketDispatcher:dispather( 174, 11, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --下发联盟服会员开通、续费大礼奖励状态
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否有领取过奖励， 0表示没有领取， 1表示领取了
        PacketDispatcher:dispather( 174, 12, var_1_unsigned_char )--分发数据
    end,

    --领取粉钻活动奖励
    --接收服务器
    [151] = function ( np )
        local var_1_int = np:readInt( ) --奖励ID
        local var_2_int = np:readInt( ) --0：领取失败；1：领取成功
        PacketDispatcher:dispather( 174, 151, var_1_int, var_2_int )--分发数据
    end,

    --下发粉钻活动状态
    --接收服务器
    [149] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        PacketDispatcher:dispather( 174, 149, var_1_int )--分发数据
    end,

    --下发每日进阶礼包活动状态
    --接收服务器
    [152] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动第几天 1~n
        local var_2_unsigned_char = np:readByte( ) --右侧界面是否显示，1表示显示0表示消失
        local var_3_unsigned_char = np:readByte( ) --奖励领取状态，0表示未充值，1表示可领取,2表示已领取
        local var_4_unsigned_char = np:readByte( ) --连续充值多少天
        PacketDispatcher:dispather( 174, 152, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --下发黄钻活动状态
    --接收服务器
    [153] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        PacketDispatcher:dispather( 174, 153, var_1_int )--分发数据
    end,

    --领取黄钻活动奖励
    --接收服务器
    [155] = function ( np )
        local var_1_int = np:readInt( ) --奖励ID
        local var_2_int = np:readInt( ) --0：领取失败；1：领取成功
        PacketDispatcher:dispather( 174, 155, var_1_int, var_2_int )--分发数据
    end,

    --下发蓝钻开通活动状态
    --接收服务器
    [156] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_unsigned_char = np:readByte( ) --第几套配置,1-n
        PacketDispatcher:dispather( 174, 156, var_1_int, var_2_unsigned_char )--分发数据
    end,


}
