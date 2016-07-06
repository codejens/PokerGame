protocol_func_map_client[158] = {
    --领取VIP每日礼包
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 4 ) 
        NetManager:send_packet( np )
    end,

    --请求VIP副本信息
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 5 ) 
        NetManager:send_packet( np )
    end,

    --请求进入副本
    --客户端发送
    [6] = function ( 
                param_1_unsigned_char -- 第几个副本
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 6 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --进入VIP挂机副本
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 7 ) 
        NetManager:send_packet( np )
    end,

    --购买试炼药水
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char -- 第几个药水
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 8 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --YY专用-领取紫钻新手礼包
    --客户端发送
    [9] = function ( 
                param_1_unsigned_char -- 1表示领取月费紫钻奖励，2表示领取年费紫钻奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 9 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --YY专用-领取紫钻至尊坐骑
    --客户端发送
    [10] = function ( 
                param_1_unsigned_char -- 1表示领取月费紫钻奖励，2表示领取年费紫钻奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 10 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --YY专用-进入紫钻boss副本
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 11 ) 
        NetManager:send_packet( np )
    end,

    --领取体验VIP
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 158, 12 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[158] = {
    --下发VIP信息
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --VIP等级
        local var_2_int = np:readInt( ) --VIP剩余时间，0表示VIP到期
        local var_3_int = np:readInt( ) --VIP体验等级
        local var_4_int = np:readInt( ) --VIP体验剩余时间，0表示到期
        local var_5_int = np:readInt( ) --VIP经验值
        local var_6_int = np:readInt( ) --玩家开通VIP的类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_int = np:readInt( ) --当日VIP礼包领取情况，1已领取，0未领取
        PacketDispatcher:dispather( 158, 1, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int )--分发数据
    end,

    --首次VIP开通礼包提示
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --大于0表示发到背包里了，0表示发到邮箱里了
        local var_2_int = np:readInt( ) --礼包ID
        PacketDispatcher:dispather( 158, 2, var_1_int, var_2_int )--分发数据
    end,

    --VIP到期
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --1正常VIP，0体验VIP
        PacketDispatcher:dispather( 158, 3, var_1_int )--分发数据
    end,

    --YY专用-下发玩家紫钻信息
    --接收服务器
    [9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家紫钻类型，0无，1月费，2年费
        local var_2_unsigned_char = np:readByte( ) --是否领取新手礼包--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --是否领取贵族坐骑
        local var_4_unsigned_char = np:readByte( ) --副本可进入次数
        PacketDispatcher:dispather( 158, 9, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,


}
