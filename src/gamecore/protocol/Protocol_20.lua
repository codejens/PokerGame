protocol_func_map_client[20] = {
    --获取今日进入各个模式的副本的剩余次数
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 1 ) 
        NetManager:send_packet( np )
    end,

    --获取副本所有队伍列表
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char,  -- 副本类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 副本id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 2 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求创建副本队伍
    --客户端发送
    [3] = function ( 
                param_1_int -- 副本id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 3 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --客户端选择“准备好”按钮
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 5 ) 
        NetManager:send_packet( np )
    end,

    --查看某队伍的副本队伍情况
    --客户端发送
    [6] = function ( 
                param_1_unsigned_int -- 队伍id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 6 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --队长关闭(或开启）一个队员位置，即队伍的最大人数减1
    --客户端发送
    [7] = function ( 
                param_1_unsigned_char -- 增加或者减少队伍的最大人数--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 7 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --开始进入副本
    --客户端发送
    [8] = function ( 
                param_1_int -- 副本id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 8 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --加入副本队伍
    --客户端发送
    [9] = function ( 
                param_1_unsigned_int -- 要加入的队伍的id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 20, 9 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[20] = {
    --创建副本队伍的结果
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --创建副本队伍的结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --成功的话，会下发队伍的id--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 20, 3, var_1_unsigned_char, var_2_unsigned_int )--分发数据
    end,

    --服务器向队伍成员广播的消息（当队长创建一个副本队伍的时候）
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --副本id--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 20, 4, var_1_int )--分发数据
    end,

    --广播给其他队员“我”是否准备好
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --队员的角色id
        local var_2_unsigned_char = np:readByte( ) --是否准备好--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 20, 5, var_1_unsigned_int, var_2_unsigned_char )--分发数据
    end,

    --下发副本或者场景的剩余时间
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 20, 7, var_1_int )--分发数据
    end,


}
