protocol_func_map_client[13] = {
    --发起交易
    --客户端发送
    [1] = function ( 
                param_1_int -- 交易对方ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 13, 1 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --回应交易请求
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 交易申请人角色ID
                param_2_bool -- 是否接受交易请求
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_bool, lua_type = "boolean" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 13, 2 ) 
        np:writeInt( param_1_int )
        np:writeChar( param_2_bool )
        NetManager:send_packet( np )
    end,

    --改变交易物品
    --客户端发送
    [3] = function ( 
                param_1_unsigned_int64,  -- 物品系列号
                param_2_int -- 0删除， 1增加
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 13, 3 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --改变交易金钱数量
    --客户端发送
    [4] = function ( 
                param_1_int,  -- 交易金钱数量--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 金钱类型，元宝或者银币
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 13, 4 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --锁定交易
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 13, 5 ) 
        NetManager:send_packet( np )
    end,

    --取消交易
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 13, 6 ) 
        NetManager:send_packet( np )
    end,

    --确认交易
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 13, 7 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[13] = {
    --发送交易请求
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --交易申请人ID
        local var_2_string = np:readString( ) --交易申请人名称
        PacketDispatcher:dispather( 13, 1, var_1_int, var_2_string )--分发数据
    end,

    --交易请求被拒绝（这条消息没用，取消）
    --接收服务器
    [2] = function ( np )
        local var_1_string = np:readString( ) --对方名称--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 13, 2, var_1_string )--分发数据
    end,

    --开始交易
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --交易对方ID
        local var_2_string = np:readString( ) --交易对方名称
        local var_3_unsigned_short = np:readWord( ) --交易对方等级
        PacketDispatcher:dispather( 13, 3, var_1_int, var_2_string, var_3_unsigned_short )--分发数据
    end,

    --返回添加交易物品结果
    --接收服务器
    [4] = function ( np )
        local var_1_bool = np:readChar( ) --添加成功否
        local var_2_int64 = np:readInt64( ) --物品id
        local var_3_int = np:readInt( ) --0删除，1添加
        PacketDispatcher:dispather( 13, 4, var_1_bool, var_2_int64, var_3_int )--分发数据
    end,

    --返回改变交易金钱数量结果
    --接收服务器
    [6] = function ( np )
        local var_1_bool = np:readChar( ) --改变成功否
        local var_2_int = np:readInt( ) --当前我交易的钱币的数量
        local var_3_int = np:readInt( ) --当前我交易的元宝的数量
        PacketDispatcher:dispather( 13, 6, var_1_bool, var_2_int, var_3_int )--分发数据
    end,

    --交易对方改变交易金钱数量
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --对方放入的金钱数量
        local var_2_int = np:readInt( ) --金钱类型，元宝或者钱币
        PacketDispatcher:dispather( 13, 7, var_1_int, var_2_int )--分发数据
    end,

    --交易锁定状态变更
    --接收服务器
    [8] = function ( np )
        local var_1_bool = np:readChar( ) --我是否已锁定
        local var_2_bool = np:readChar( ) --对方是否已锁定
        PacketDispatcher:dispather( 13, 8, var_1_bool, var_2_bool )--分发数据
    end,

    --交易已被取消
    --接收服务器
    [9] = function ( np )
        PacketDispatcher:dispather( 13, 9 )--分发数据
    end,

    --交易尚未锁定
    --接收服务器
    [10] = function ( np )
        PacketDispatcher:dispather( 13, 10 )--分发数据
    end,

    --交易完成
    --接收服务器
    [11] = function ( np )
        PacketDispatcher:dispather( 13, 11 )--分发数据
    end,


}
