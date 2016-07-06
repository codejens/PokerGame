protocol_func_map_client[155] = {
    --领取礼包
    --客户端发送
    [2] = function ( 
                param_1_int -- 礼包类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 155, 2 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[155] = {

}
