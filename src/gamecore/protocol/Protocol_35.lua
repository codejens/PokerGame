protocol_func_map_client[35] = {
    --客户端到达目的点
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 35, 1 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[35] = {
    --上交通工具
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --目标点X
        local var_2_int = np:readInt( ) --目标点Y
        PacketDispatcher:dispather( 35, 1, var_1_int, var_2_int )--分发数据
    end,

    --下交通工具
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --点坐标X
        local var_2_int = np:readInt( ) --点坐标Y
        PacketDispatcher:dispather( 35, 2, var_1_int, var_2_int )--分发数据
    end,

    --移动到下一个点
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --下一个点坐标X
        local var_2_int = np:readInt( ) --下一个点坐标Y
        local var_3_int = np:readInt( ) --步长
        PacketDispatcher:dispather( 35, 3, var_1_int, var_2_int, var_3_int )--分发数据
    end,


}
