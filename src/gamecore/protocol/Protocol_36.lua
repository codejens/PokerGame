protocol_func_map_client[36] = {
    --探宝，如果成功，会下发消息1
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char,  -- 梦境类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 盗梦类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 1 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取仓库列表
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 2 ) 
        NetManager:send_packet( np )
    end,

    --仓库物品移到背包
    --客户端发送
    [3] = function ( 
                param_1_int64 -- 物品序列号--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 3 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --获取全服日志
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 4 ) 
        NetManager:send_packet( np )
    end,

    --十一探宝（结构同1）
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char,  -- 梦境类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 盗梦类型
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 8 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取十一活动全服日志（结构同4）
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 9 ) 
        NetManager:send_packet( np )
    end,

    --兑换装备
    --客户端发送
    [13] = function ( 
                param_1_unsigned_char -- 兑换第几个装备，1-5
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 13 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --春节活动31-4日抽奖
    --客户端发送
    [20] = function ( 
                param_1_unsigned_char,  -- 秘境类型
                param_2_unsigned_char -- 抽奖次数，分别为1、2、3， 1表示1次， 2表示10次， 3表示50次
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 20 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --元宵节活动抽奖
    --客户端发送
    [21] = function ( 
                param_1_unsigned_char,  -- 秘境类型
                param_2_unsigned_char -- 抽奖次数，分别为1、2、3， 1表示1次， 2表示10次， 3表示50次
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 21 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --抽马上宝宝
    --客户端发送
    [24] = function ( 
                param_1_unsigned_char,  -- 梦境类型，传3
                param_2_unsigned_char -- 盗梦类型
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 24 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --有用：前端请求下发宝藏的兑换情况
    --客户端发送
    [25] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 36, 25 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[36] = {
    --移动的结果
    --接收服务器
    [3] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号,如果是0，表示全部转移
        local var_2_unsigned_char = np:readByte( ) --0:不成功，1成功
        PacketDispatcher:dispather( 36, 3, var_1_int64, var_2_unsigned_char )--分发数据
    end,

    --物品的数量发生改变
    --接收服务器
    [6] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID
        local var_2_unsigned_short = np:readWord( ) --物品的新数量
        PacketDispatcher:dispather( 36, 6, var_1_int64, var_2_unsigned_short )--分发数据
    end,

    --增加全服日志
    --接收服务器
    [7] = function ( np )
        PacketDispatcher:dispather( 36, 7 )--分发数据
    end,

    --十一探宝结果（结构同1）
    --接收服务器
    [8] = function ( np )
        PacketDispatcher:dispather( 36, 8 )--分发数据
    end,

    --发送十一活动全服日志（结构同4）
    --接收服务器
    [9] = function ( np )
        PacketDispatcher:dispather( 36, 9 )--分发数据
    end,

    --增加十一活动全服日志（结构同7）
    --接收服务器
    [10] = function ( np )
        PacketDispatcher:dispather( 36, 10 )--分发数据
    end,


}
