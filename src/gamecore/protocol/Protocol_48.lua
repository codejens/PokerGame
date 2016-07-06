protocol_func_map_client[48] = {
    --获取通天塔仓库数据
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 1 ) 
        NetManager:send_packet( np )
    end,

    --取出仓库物品
    --客户端发送
    [2] = function ( 
                param_1_int64,  -- 物品序列号--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 取出类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 2 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求玩家通关信息
    --客户端发送
    [5] = function ( 
                param_1_unsigned_char -- 类型，0普通镇妖塔，1英雄镇妖塔
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 5 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --进入副本
    --客户端发送
    [6] = function ( 
                param_1_unsigned_char,  -- 类型，0普通镇妖塔，1英雄镇妖塔
                param_2_int -- 玩家选择的层数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 6 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --进入下一关
    --客户端发送
    [7] = function ( 
                param_1_unsigned_char -- 类型，0:普通镇妖塔，1:英雄镇妖塔
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 7 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --重新挑战
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char -- 类型，0:普通镇妖塔，1:英雄镇妖塔
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 8 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --查看所有层主信息
    --客户端发送
    [12] = function ( 
                param_1_unsigned_char -- 类型，0普通镇妖塔，1英雄镇妖塔
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 12 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求面板信息
    --客户端发送
    [14] = function ( 
                param_1_unsigned_char -- 类型，0:普通镇妖塔，1:英雄镇妖塔
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 48, 14 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[48] = {
    --取出仓库物品结果
    --接收服务器
    [2] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品序列号--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --取出类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 48, 2, var_1_int64, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --仓库物品数量更新
    --接收服务器
    [4] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的GUID
        local var_2_unsigned_short = np:readWord( ) --物品的数量
        PacketDispatcher:dispather( 48, 4, var_1_int64, var_2_unsigned_short )--分发数据
    end,

    --挑战失败
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型，0:普通镇妖塔，1:英雄镇妖塔
        PacketDispatcher:dispather( 48, 10, var_1_unsigned_char )--分发数据
    end,

    --层主被替代
    --接收服务器
    [11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型，0普通镇妖塔，1英雄镇妖塔
        local var_2_int = np:readInt( ) --层数
        local var_3_string = np:readString( ) --新的层主
        PacketDispatcher:dispather( 48, 11, var_1_unsigned_char, var_2_int, var_3_string )--分发数据
    end,

    --飘通天塔图标
    --接收服务器
    [13] = function ( np )
        PacketDispatcher:dispather( 48, 13 )--分发数据
    end,


}
