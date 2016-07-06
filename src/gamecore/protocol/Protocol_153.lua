protocol_func_map_client[153] = {
    --获取累计登陆奖励
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 状态--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 领取类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 153, 2 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[153] = {

}
