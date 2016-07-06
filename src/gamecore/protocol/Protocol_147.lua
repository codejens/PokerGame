protocol_func_map_client[147] = {
    --获取我的自由赛信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 1 ) 
        NetManager:send_packet( np )
    end,

    --获取自由赛排行榜
    --客户端发送
    [2] = function ( 
                param_1_int -- 第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 2 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取争霸赛信息
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 3 ) 
        NetManager:send_packet( np )
    end,

    --获取上届16强排名
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 4 ) 
        NetManager:send_packet( np )
    end,

    --获取历届仙王
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 5 ) 
        NetManager:send_packet( np )
    end,

    --取消匹配
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 6 ) 
        NetManager:send_packet( np )
    end,

    --下注
    --客户端发送
    [9] = function ( 
                param_1_int,  -- 争霸赛第几轮比赛
                param_2_int,  -- 第几个玩家--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 下注金额
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 9 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --送鲜花或丢鸡蛋
    --客户端发送
    [11] = function ( 
                param_1_int,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 11 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --领取荣誉奖励
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 13 ) 
        NetManager:send_packet( np )
    end,

    --进入自由赛报名场景
    --客户端发送
    [14] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 14 ) 
        NetManager:send_packet( np )
    end,

    --进入争霸赛副本
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 15 ) 
        NetManager:send_packet( np )
    end,

    --退出自由赛报名场景
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 147, 17 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[147] = {
    --发送我的自由赛信息
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --名次
        local var_2_int = np:readInt( ) --积分
        local var_3_int = np:readInt( ) --累计次数
        local var_4_int = np:readInt( ) --累计胜利
        PacketDispatcher:dispather( 147, 1, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --匹配开始
    --接收服务器
    [6] = function ( np )
        PacketDispatcher:dispather( 147, 6 )--分发数据
    end,

    --PK开始
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 147, 7, var_1_unsigned_char )--分发数据
    end,

    --下注
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --争霸赛第几轮比赛
        local var_2_int = np:readInt( ) --第几个玩家--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --下注金额
        PacketDispatcher:dispather( 147, 9, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --擂台赛状态改变了
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --第几轮
        local var_2_unsigned_char = np:readByte( ) --状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_int = np:readUInt( ) --状态结束时间
        PacketDispatcher:dispather( 147, 10, var_1_int, var_2_unsigned_char, var_3_unsigned_int )--分发数据
    end,

    --送鲜花或丢鸡蛋
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int64 = np:readInt64( ) --玩家的handle
        PacketDispatcher:dispather( 147, 11, var_1_int, var_2_int, var_3_int64 )--分发数据
    end,

    --自由赛状态改变
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 147, 12, var_1_int )--分发数据
    end,

    --领取荣誉奖励
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --排名--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --是否领奖--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --金钱奖励
        local var_4_int = np:readInt( ) --荣誉值奖励
        PacketDispatcher:dispather( 147, 13, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --竞技场活动开启时间
    --接收服务器
    [18] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --竞技场活动开启时间
        PacketDispatcher:dispather( 147, 18, var_1_unsigned_int )--分发数据
    end,

    --仙道会数据刷新
    --接收服务器
    [19] = function ( np )
        PacketDispatcher:dispather( 147, 19 )--分发数据
    end,

    --通知客户端剩余鲜花或鸡蛋次数
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --鲜花剩余次数
        local var_2_int = np:readInt( ) --鸡蛋剩余次数
        PacketDispatcher:dispather( 147, 20, var_1_int, var_2_int )--分发数据
    end,

    --广播玩家的身价
    --接收服务器
    [21] = function ( np )
        local var_1_int = np:readInt( ) --第几个玩家--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --玩家身价
        PacketDispatcher:dispather( 147, 21, var_1_int, var_2_int )--分发数据
    end,

    --发送争霸赛PK结果
    --接收服务器
    [22] = function ( np )
        local var_1_int = np:readInt( ) --第几轮
        local var_2_int = np:readInt( ) --第几组
        local var_3_int = np:readInt( ) --哪个--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 147, 22, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --争霸赛场数变更
    --接收服务器
    [23] = function ( np )
        local var_1_int = np:readInt( ) --第几轮
        local var_2_int = np:readInt( ) --第几场
        PacketDispatcher:dispather( 147, 23, var_1_int, var_2_int )--分发数据
    end,


}
