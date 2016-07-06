protocol_func_map_client[149] = {
    --合服争霸-请求boss争霸信息
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char -- 第几轮
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 2 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --合服争霸-请求boss争霸排行榜信息
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char -- 第几轮
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 3 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --合服争霸-请求领取boss争霸全民礼包
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char -- 第几轮
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 4 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --合服争霸-请求城主争霸信息
    --客户端发送
    [5] = function ( 
                param_1_unsigned_char -- 第几轮（固定传1）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 5 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --合服争霸-请求领取城主争霸全民礼包
    --客户端发送
    [6] = function ( 
                param_1_unsigned_char -- 第几轮（固定传1）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 6 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --合服活动.首充大团购-客户端请求奖励信息
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 10 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.首充大团购-客户端领取奖励
    --客户端发送
    [11] = function ( 
                param_1_unsigned_char -- index，奖励索引，从1开始，1表示最低的奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 11 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --合服活动.请求充值大比拼排行信息
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 12 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.领取充值大比拼排行全民奖励
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 13 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求充值大比拼排行榜
    --客户端发送
    [14] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 14 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求坐骑进阶信息
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 15 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求领取坐骑进阶礼包
    --客户端发送
    [16] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 16 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求宠物进阶信息
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 17 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求领取宠物进阶礼包
    --客户端发送
    [18] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 18 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求法阵进阶信息
    --客户端发送
    [19] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 19 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求领取法阵进阶礼包
    --客户端发送
    [20] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 20 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求翅膀进阶信息
    --客户端发送
    [21] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 21 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求领取翅膀进阶礼包
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 22 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求神兵进阶信息
    --客户端发送
    [23] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 23 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求领取神兵进阶礼包
    --客户端发送
    [24] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 24 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求坐骑排行信息
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 29 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.领取坐骑排行全民奖励
    --客户端发送
    [30] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 30 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求宠物排行信息
    --客户端发送
    [31] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 31 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.领取宠物排行全民奖励
    --客户端发送
    [32] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 32 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求法阵排行信息
    --客户端发送
    [33] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 33 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.领取法阵排行全民奖励
    --客户端发送
    [34] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 34 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求幻羽排行信息
    --客户端发送
    [35] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 35 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.领取幻羽排行全民奖励
    --客户端发送
    [36] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 36 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求神兵排行信息
    --客户端发送
    [37] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 37 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.领取神兵排行全民奖励
    --客户端发送
    [38] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 38 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.领取二次首充礼包
    --客户端发送
    [39] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 39 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求战灵进阶信息
    --客户端发送
    [40] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 40 ) 
        NetManager:send_packet( np )
    end,

    --合服活动.请求领取战灵进阶礼包
    --客户端发送
    [41] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 149, 41 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[149] = {
    --合服争霸-下发boss争霸信息
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几次
        local var_2_int = np:readInt( ) --第一帮派帮主id
        local var_3_string = np:readString( ) --第一帮派名
        local var_4_string = np:readString( ) --第一帮派帮主名
        local var_5_string = np:readString( ) --我的帮派名
        local var_6_int = np:readInt( ) --我的帮派排名
        local var_7_int = np:readInt( ) --我的帮派积分
        local var_8_int = np:readInt( ) --我参加的次数
        local var_9_unsigned_char = np:readByte( ) --0表示不可领取，1表示可领取，2表示已领取
        PacketDispatcher:dispather( 149, 2, var_1_unsigned_char, var_2_int, var_3_string, var_4_string, var_5_string, var_6_int, var_7_int, var_8_int, var_9_unsigned_char )--分发数据
    end,

    --合服争霸-下发城主争霸信息
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几次
        local var_2_int = np:readInt( ) --第一帮派帮主id
        local var_3_string = np:readString( ) --第一帮派名
        local var_4_string = np:readString( ) --第一帮派帮主名
        local var_5_string = np:readString( ) --我的帮派名
        local var_6_int = np:readInt( ) --我的帮派排名
        local var_7_int = np:readInt( ) --我的帮派积分
        local var_8_int = np:readInt( ) --我参加的次数
        local var_9_unsigned_char = np:readByte( ) --0表示不可领取，1表示可领取，2表示已领取
        PacketDispatcher:dispather( 149, 5, var_1_unsigned_char, var_2_int, var_3_string, var_4_string, var_5_string, var_6_int, var_7_int, var_8_int, var_9_unsigned_char )--分发数据
    end,

    --合服活动.下发充值大比拼排行信息
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的充值元宝数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 149, 12, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --合服活动.下发充值大比拼排行全民奖励状态
    --接收服务器
    [13] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 149, 13, var_1_unsigned_char )--分发数据
    end,

    --合服活动.下发单个活动可领取奖励数量
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动的索引
        local var_2_unsigned_char = np:readByte( ) --数量
        PacketDispatcher:dispather( 149, 27, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --合服活动.总的活动状态协议
    --接收服务器
    [28] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0活动结束
        local var_2_short = np:readShort( ) --合服第几天
        local var_3_short = np:readShort( ) --合服开始是开服第几天
        local var_4_unsigned_char = np:readByte( ) --第几次合服，1第一次，2第二次或以上
        PacketDispatcher:dispather( 149, 28, var_1_int, var_2_short, var_3_short, var_4_unsigned_char )--分发数据
    end,

    --合服活动.下发坐骑排行信息
    --接收服务器
    [29] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的坐骑战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 149, 29, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --合服活动.下发坐骑排行全民奖励状态
    --接收服务器
    [30] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 149, 30, var_1_unsigned_char )--分发数据
    end,

    --合服活动.下发宠物排行信息
    --接收服务器
    [31] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的宠物战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 149, 31, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --合服活动.下发宠物排行全民奖励状态
    --接收服务器
    [32] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 149, 32, var_1_unsigned_char )--分发数据
    end,

    --合服活动.下发法阵排行信息
    --接收服务器
    [33] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的法阵战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 149, 33, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --合服活动.下发法阵排行全民奖励状态
    --接收服务器
    [34] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 149, 34, var_1_unsigned_char )--分发数据
    end,

    --合服活动.下发幻羽排行信息
    --接收服务器
    [35] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的幻羽战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 149, 35, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --合服活动.下发幻羽排行全民奖励状态
    --接收服务器
    [36] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 149, 36, var_1_unsigned_char )--分发数据
    end,

    --合服活动.下发神兵排行信息
    --接收服务器
    [37] = function ( np )
        local var_1_int = np:readInt( ) --第一名玩家：ID
        local var_2_string = np:readString( ) --第一名玩家：名字
        local var_3_unsigned_char = np:readByte( ) --第一名玩家：性别
        local var_4_unsigned_char = np:readByte( ) --第一名玩家：职业
        local var_5_unsigned_int = np:readUInt( ) --我当前的神兵战力或阶数
        local var_6_unsigned_char = np:readByte( ) --我当前的名次，0表示未上榜
        PacketDispatcher:dispather( 149, 37, var_1_int, var_2_string, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_int, var_6_unsigned_char )--分发数据
    end,

    --合服活动.下发神兵排行全民奖励状态
    --接收服务器
    [38] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --全民奖励状态：0未达成 1可领取 2已领取
        PacketDispatcher:dispather( 149, 38, var_1_unsigned_char )--分发数据
    end,

    --合服活动.下发合服累充信息
    --接收服务器
    [39] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1显示 0不显示
        local var_2_unsigned_char = np:readByte( ) --今天是第几天
        local var_3_unsigned_int = np:readUInt( ) --今天的充值元宝数
        local var_4_unsigned_int = np:readUInt( ) --今天要充值多少元宝才能领取二次首充礼包
        local var_5_unsigned_char = np:readByte( ) --0不可领取 1可领取 2已领取
        local var_6_unsigned_char = np:readByte( ) --第几次合服，1代表第一次合服，2代表第二次合服
        PacketDispatcher:dispather( 149, 39, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_char, var_6_unsigned_char )--分发数据
    end,


}
