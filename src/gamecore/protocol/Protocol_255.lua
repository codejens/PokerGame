protocol_func_map_client[255] = {
    --登录认证
    --客户端发送
    [1] = function ( 
                param_1_int,  -- 账户id
                param_2_string -- 在登录服务器获得的key字符串
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 1 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --创建角色
    --客户端发送
    [2] = function ( 
                param_1_string,  -- 角色名称
                param_2_char,  -- 性别
                param_3_char,  -- 职业
                param_4_char,  -- 头像
                param_5_char,  -- 阵营
                param_6_string -- 登陆平台（pf）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_char, lua_type = "number" }, { param_name = param_3_char, lua_type = "number" }, { param_name = param_4_char, lua_type = "number" }, { param_name = param_5_char, lua_type = "number" }, { param_name = param_6_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 2 ) 
        np:writeString( param_1_string )
        np:writeChar( param_2_char )
        np:writeChar( param_3_char )
        np:writeChar( param_4_char )
        np:writeChar( param_5_char )
        np:writeString( param_6_string )
        NetManager:send_packet( np )
    end,

    --删除角色
    --客户端发送
    [3] = function ( 
                param_1_int -- 角色id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 3 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求进入游戏
    --客户端发送
    [5] = function ( 
                param_1_int,  -- 角色id
                param_2_string -- 登陆平台（pf）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 5 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --查询最少的职业
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 7 ) 
        NetManager:send_packet( np )
    end,

    --查询最少人选的阵营id
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 8 ) 
        NetManager:send_packet( np )
    end,

    --查询角色列表
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 4 ) 
        NetManager:send_packet( np )
    end,

    --查询随机名字
    --客户端发送
    [6] = function ( 
                param_1_unsigned_char -- 性别
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 255, 6 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[255] = {
    --key认证结果
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0:成功--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 255, 1, var_1_unsigned_char )--分发数据
    end,

    --创建角色结果
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --创建的角色id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --错误码，0：成功--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 255, 2, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --删除角色结果
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --角色id
        local var_2_char = np:readChar( ) --结果，0：成功，错误码同上
        PacketDispatcher:dispather( 255, 3, var_1_int, var_2_char )--分发数据
    end,

    --进入游戏结果
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0:成功，其他错误码
        PacketDispatcher:dispather( 255, 5, var_1_unsigned_char )--分发数据
    end,

    --随机名字
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码，0的话才需要读后面的数据
        local var_2_unsigned_char = np:readByte( ) --性别
        local var_3_string = np:readString( ) --角色名称
        PacketDispatcher:dispather( 255, 6, var_1_unsigned_char, var_2_unsigned_char, var_3_string )--分发数据
    end,

    --查询最少人选的职业的id结果
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码，0才需要读后面的数据
        local var_2_unsigned_char = np:readByte( ) --职业id
        PacketDispatcher:dispather( 255, 7, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --查询最少人选的阵营id
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码，0才需要读后面的数据
        local var_2_unsigned_char = np:readByte( ) --阵营id
        PacketDispatcher:dispather( 255, 8, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,


}
