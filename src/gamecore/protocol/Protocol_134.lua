protocol_func_map_client[134] = {
    --设置一个快捷键
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char,  -- 快捷键编号
                param_2_unsigned_char,  -- 快捷键内容类型--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_short -- 快捷键内容--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 134, 1 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeWord( param_3_unsigned_short )
        NetManager:send_packet( np )
    end,

    --客户端请求快捷键设置
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 134, 2 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[134] = {
    --返回设置快捷键结果
    --接收服务器
    [1] = function ( np )
        local var_1_bool = np:readChar( ) --是否成功设置
        PacketDispatcher:dispather( 134, 1, var_1_bool )--分发数据
    end,


}
