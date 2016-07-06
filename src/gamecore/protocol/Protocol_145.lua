protocol_func_map_client[145] = {
    --领取奖励
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 145, 2 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[145] = {

}
