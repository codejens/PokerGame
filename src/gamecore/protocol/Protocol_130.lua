protocol_func_map_client[130] = {
    --请求学会的物品
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 130, 1 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[130] = {
    --学会制作一个物品
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能的ID(比如锻造)
        local var_2_unsigned_short = np:readWord( ) --物品的ID
        PacketDispatcher:dispather( 130, 2, var_1_unsigned_short, var_2_unsigned_short )--分发数据
    end,


}
