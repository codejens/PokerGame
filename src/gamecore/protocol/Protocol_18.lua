protocol_func_map_client[18] = {
    --开始挂机
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 18, 5 ) 
        NetManager:send_packet( np )
    end,

    --结束挂机
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 18, 6 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[18] = {
    --已开始（或已停止）挂机
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --挂机状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 18, 4, var_1_unsigned_char )--分发数据
    end,


}
