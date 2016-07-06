protocol_func_map_client[28] = {
    --获取成就的列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 28, 1 ) 
        NetManager:send_packet( np )
    end,

    --申请领取成就的奖励
    --客户端发送
    [2] = function ( 
                param_1_unsigned_short -- 成就的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 28, 2 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --获取称号的列表信息
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 28, 3 ) 
        NetManager:send_packet( np )
    end,

    --设置当前的称号
    --客户端发送
    [4] = function ( 
                param_1_unsigned_short -- 称号的id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 28, 4 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --领取成就奖励
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 28, 5 ) 
        NetManager:send_packet( np )
    end,

    --上传称号显示配置
    --客户端发送
    [8] = function ( 
                param_1_unsigned_char,  -- 称号个数
                param_2_array -- 称号id列表--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 28, 8 ) 
        np:writeByte( param_1_unsigned_char )
        for i = 1, param_1_unsigned_char do 
            -- protocol manual client 数组
            -- 称号id列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_2_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[28] = {
    --完成一个成就
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --成就的ID
        PacketDispatcher:dispather( 28, 2, var_1_unsigned_short )--分发数据
    end,

    --成就的一个事件触发了
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --成就的ID
        local var_2_unsigned_short = np:readWord( ) --事件的ID
        local var_3_int = np:readInt( ) --进度值,比如送花9朵
        PacketDispatcher:dispather( 28, 3, var_1_unsigned_short, var_2_unsigned_short, var_3_int )--分发数据
    end,

    --成就的奖励领取结果
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --成就ID
        local var_2_unsigned_char = np:readByte( ) --成就领取的结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 28, 4, var_1_unsigned_short, var_2_unsigned_char )--分发数据
    end,

    --获得一个称号
    --接收服务器
    [6] = function ( np )
        local var_1_int64 = np:readInt64( ) --玩家句柄
        local var_2_unsigned_short = np:readWord( ) --称号的ID
        local var_3_unsigned_char = np:readByte( ) --isDisplay, 是否显示--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 28, 6, var_1_int64, var_2_unsigned_short, var_3_unsigned_char )--分发数据
    end,

    --失去一个称号
    --接收服务器
    [7] = function ( np )
        local var_1_int64 = np:readInt64( ) --玩家句柄
        local var_2_unsigned_short = np:readWord( ) --称号的ID
        PacketDispatcher:dispather( 28, 7, var_1_int64, var_2_unsigned_short )--分发数据
    end,


}
