protocol_func_map_client[144] = {
    --请求获取消息列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 1 ) 
        NetManager:send_packet( np )
    end,

    --请求地主苦工系统数据
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 2 ) 
        NetManager:send_packet( np )
    end,

    --请求手下败将列表
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 3 ) 
        NetManager:send_packet( np )
    end,

    --请求夺仆之敌列表
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 4 ) 
        NetManager:send_packet( np )
    end,

    --请求苦工列表
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 5 ) 
        NetManager:send_packet( np )
    end,

    --请求我可解救的苦工列表
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 6 ) 
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
        local np = NetManager:get_NetPacket( 144, 7 ) 
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
        local np = NetManager:get_NetPacket( 144, 8 ) 
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
        local np = NetManager:get_NetPacket( 144, 9 ) 
        NetManager:send_packet( np )
    end,

    --反抗
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 10 ) 
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
        local np = NetManager:get_NetPacket( 144, 11 ) 
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
        local np = NetManager:get_NetPacket( 144, 12 ) 
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
        local np = NetManager:get_NetPacket( 144, 13 ) 
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
        local np = NetManager:get_NetPacket( 144, 14 ) 
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
        local np = NetManager:get_NetPacket( 144, 15 ) 
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
        local np = NetManager:get_NetPacket( 144, 16 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取可解救我的同帮派玩家列表
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 17 ) 
        NetManager:send_packet( np )
    end,

    --增加抓捕次数
    --客户端发送
    [18] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 144, 18 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[144] = {
    --新信息通知
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --消息ID
        PacketDispatcher:dispather( 144, 20, var_1_int )--分发数据
    end,


}
