protocol_func_map_client[39] = {
    --获取竞技场信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 1 ) 
        NetManager:send_packet( np )
    end,

    --开始PK
    --客户端发送
    [2] = function ( 
                param_1_int -- 挑战的玩家ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 2 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --消除CD时间
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 3 ) 
        NetManager:send_packet( np )
    end,

    --增加挑战次数
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 4 ) 
        NetManager:send_packet( np )
    end,

    --查看排行榜
    --客户端发送
    [5] = function ( 
                param_1_int -- 第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 5 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --查看玩家战绩记录
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 6 ) 
        NetManager:send_packet( np )
    end,

    --领取排行奖励
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 7 ) 
        NetManager:send_packet( np )
    end,

    --选择出战宠物
    --客户端发送
    [12] = function ( 
                param_1_int -- 宠物ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 12 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --快速完成
    --客户端发送
    [14] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 14 ) 
        NetManager:send_packet( np )
    end,

    --退出
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 15 ) 
        NetManager:send_packet( np )
    end,

    --购买鼓舞
    --客户端发送
    [16] = function ( 
                param_1_unsigned_char -- 鼓舞类型
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 16 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求竞技兑换信息
    --客户端发送
    [18] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 18 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求领取竞技兑换奖励
    --客户端发送
    [19] = function ( 
                param_1_unsigned_char -- 下标，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 19 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求竞技积分
    --客户端发送
    [20] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 39, 20 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[39] = {
    --倒计时结束，PK开始
    --接收服务器
    [2] = function ( np )
        PacketDispatcher:dispather( 39, 2 )--分发数据
    end,

    --更新CD时间
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --CD时间(秒)
        PacketDispatcher:dispather( 39, 3, var_1_int )--分发数据
    end,

    --更新挑战次数信息
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --剩余挑战的次数
        local var_2_int = np:readInt( ) --下次购买需要的元宝数--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --元宝购买剩余次数
        PacketDispatcher:dispather( 39, 4, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --发送排名奖励领取状态
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --排名
        local var_2_unsigned_char = np:readByte( ) --是否领取奖励--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --领奖时间
        local var_4_int = np:readInt( ) --上次结算排名
        PacketDispatcher:dispather( 39, 7, var_1_int, var_2_unsigned_char, var_3_int, var_4_int )--分发数据
    end,

    --添加战绩记录（同发送玩家战绩记录的战绩记录的一项结果相同）
    --接收服务器
    [9] = function ( np )
        PacketDispatcher:dispather( 39, 9 )--分发数据
    end,

    --挑战结果
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --获得的仙币
        local var_3_int = np:readInt( ) --获得的声望
        local var_4_int = np:readInt( ) --获得的经验
        PacketDispatcher:dispather( 39, 10, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --捉捕结果
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 39, 11, var_1_int )--分发数据
    end,

    --更新出战宠物
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --宠物ID
        PacketDispatcher:dispather( 39, 12, var_1_int )--分发数据
    end,

    --快速完成
    --接收服务器
    [14] = function ( np )
        PacketDispatcher:dispather( 39, 14 )--分发数据
    end,

    --玩家鼓舞状态
    --接收服务器
    [16] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --鼓舞类型
        PacketDispatcher:dispather( 39, 16, var_1_unsigned_char )--分发数据
    end,

    --（已废弃）任务追踪面板.我要变强-下发封神台挑战倒计时
    --接收服务器
    [17] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --倒计时，单位秒
        PacketDispatcher:dispather( 39, 17, var_1_unsigned_int )--分发数据
    end,

    --服务端下发竞技积分
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --竞技积分
        PacketDispatcher:dispather( 39, 20, var_1_int )--分发数据
    end,


}
