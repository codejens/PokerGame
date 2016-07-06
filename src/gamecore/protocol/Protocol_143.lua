protocol_func_map_client[143] = {
    --请求获取消息列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 1 ) 
        NetManager:send_packet( np )
    end,

    --请求地主苦工系统数据
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 2 ) 
        NetManager:send_packet( np )
    end,

    --请求手下败将列表
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 3 ) 
        NetManager:send_packet( np )
    end,

    --请求夺仆之敌列表
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 4 ) 
        NetManager:send_packet( np )
    end,

    --请求苦工列表
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 5 ) 
        NetManager:send_packet( np )
    end,

    --请求求救信息列表
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 6 ) 
        NetManager:send_packet( np )
    end,

    --抓捕/掠夺
    --客户端发送
    [7] = function ( 
                param_1_int,  -- 要抓捕或掠夺的玩家ID
                param_2_int -- 是否强行掠夺--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 7 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --求救
    --客户端发送
    [8] = function ( 
                param_1_int -- 接受请求者
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 8 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --赎身
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 9 ) 
        NetManager:send_packet( np )
    end,

    --反抗
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 10 ) 
        NetManager:send_packet( np )
    end,

    --互动
    --客户端发送
    [11] = function ( 
                param_1_int,  -- 对方角色ID
                param_2_int -- 消息类型ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 11 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --提取经验
    --客户端发送
    [12] = function ( 
                param_1_int -- 苦工角色ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 12 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --压榨
    --客户端发送
    [13] = function ( 
                param_1_int -- 苦工角色ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 13 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --抽干
    --客户端发送
    [14] = function ( 
                param_1_int -- 苦工角色ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 14 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --解救苦工
    --客户端发送
    [15] = function ( 
                param_1_int -- 苦工角色ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 15 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --释放苦工
    --客户端发送
    [16] = function ( 
                param_1_int -- 苦工角色ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 143, 16 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[143] = {
    --发送地主苦工系统数据
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --系统开关状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --系统开启等级下限
        local var_3_int = np:readInt( ) --身份状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --今天已抓捕或掠夺次数
        local var_5_int = np:readInt( ) --抓捕/掠夺次数上限
        local var_6_int = np:readInt( ) --今日已互动次数
        local var_7_int = np:readInt( ) --互动次数上限
        local var_8_int = np:readInt( ) --今天已反抗/求救次数
        local var_9_int = np:readInt( ) --反抗/求救次数上限
        local var_10_int = np:readInt( ) --今日已获得经验
        local var_11_int = np:readInt( ) --今天已解救次数
        PacketDispatcher:dispather( 143, 2, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_int, var_11_int )--分发数据
    end,


}
