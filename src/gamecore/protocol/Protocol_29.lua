protocol_func_map_client[29] = {
    --发送灵根的信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 29, 1 ) 
        NetManager:send_packet( np )
    end,

    --灵根升级，成功的话会下发消息1
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 29, 2 ) 
        NetManager:send_packet( np )
    end,

    --查看其他玩家的灵根数据
    --客户端发送
    [3] = function ( 
                param_1_int,  -- 玩家id
                param_2_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 29, 3 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[29] = {
    --获取灵根信息
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --灵根信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --灵根战斗力
        PacketDispatcher:dispather( 29, 1, var_1_int, var_2_int )--分发数据
    end,

    --下发其他玩家的灵根数据
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --灵根信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --灵根战斗力
        PacketDispatcher:dispather( 29, 2, var_1_int, var_2_int )--分发数据
    end,


}
