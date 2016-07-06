protocol_func_map_client[17] = {
    --开始、停止打坐，注意：只有普通打坐调用这个接口，开始双修什么的用其他接口
    --客户端发送
    [1] = function ( 
                param_1_bool,  -- 是否开始操练
                param_2_unsigned_char -- 打坐的外观
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_bool, lua_type = "boolean" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 17, 1 ) 
        np:writeChar( param_1_bool )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --邀请双修
    --客户端发送
    [2] = function ( 
                param_1_string,  -- 角色名称
                param_2_unsigned_char -- 打坐的外观
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 17, 2 ) 
        np:writeString( param_1_string )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --邀请回复
    --客户端发送
    [3] = function ( 
                param_1_string,  -- 邀请人的名称
                param_2_unsigned_char -- 0:拒绝，1：接受
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 17, 3 ) 
        np:writeString( param_1_string )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求可以邀请双修的玩家列表
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 17, 4 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[17] = {
    --打坐状态变更
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --打坐状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --操练剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 17, 1, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --通知客户端修行的奖励数据
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型
        local var_2_int = np:readInt( ) --经验
        local var_3_int = np:readInt( ) --灵气
        PacketDispatcher:dispather( 17, 5, var_1_unsigned_char, var_2_int, var_3_int )--分发数据
    end,


}
