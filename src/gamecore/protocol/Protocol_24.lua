protocol_func_map_client[24] = {
    --邀请切磋
    --客户端发送
    [1] = function ( 
                param_1_unsigned_int64,  -- 被邀请的玩家的handle
                param_2_string -- 被邀请人的名称--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 24, 1 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --玩家对邀请的回应
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char,  -- 0拒绝 1接受
                param_2_unsigned_int64 -- 邀请人的handle--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 24, 2 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeUint64( param_2_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --设置自由PK模式
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char -- PK模式的值--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 24, 3 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[24] = {
    --向玩家下发邀请切磋的消息
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --邀请人的handle
        local var_2_string = np:readString( ) --邀请人的名字
        PacketDispatcher:dispather( 24, 1, var_1_unsigned_int64, var_2_string )--分发数据
    end,

    --切磋开始的消息
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --对方的handle--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --切磋开始与否的标志--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --如果是开始切磋，则这个是切磋的总时间，算上倒计时的5秒
        PacketDispatcher:dispather( 24, 2, var_1_unsigned_int64, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --下发玩家的自由PK模式
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --模式编号--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 24, 3, var_1_unsigned_char )--分发数据
    end,

    --反击状态
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1进入反击，0退出反击
        local var_2_int64 = np:readInt64( ) --玩家handle，退出反击时为0
        PacketDispatcher:dispather( 24, 4, var_1_unsigned_char, var_2_int64 )--分发数据
    end,


}
