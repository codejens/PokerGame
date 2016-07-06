protocol_func_map_client[140] = {
    --点击领奖
    --客户端发送
    [1] = function ( 
                param_1_unsigned_short -- 抽奖物品ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 140, 1 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --点击开始
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 140, 2 ) 
        NetManager:send_packet( np )
    end,

    --关闭抽奖界面
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 140, 3 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[140] = {
    --是否领取成功
    --接收服务器
    [2] = function ( np )
        local var_1_bool = np:readChar( ) --是否领取成功--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 140, 2, var_1_bool )--分发数据
    end,

    --返回能否开始
    --接收服务器
    [3] = function ( np )
        local var_1_bool = np:readChar( ) --能否开始--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 140, 3, var_1_bool )--分发数据
    end,


}
