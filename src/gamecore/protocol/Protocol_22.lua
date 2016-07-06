protocol_func_map_client[22] = {
    --玩家处理了一条信息
    --客户端发送
    [1] = function ( 
                param_1_int64 -- 消息号--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 22, 1 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[22] = {
    --删除一条用户信息
    --接收服务器
    [2] = function ( np )
        local var_1_int64 = np:readInt64( ) --消息号--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 22, 2, var_1_int64 )--分发数据
    end,


}
