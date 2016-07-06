protocol_func_map_client[31] = {
    --充值
    --客户端发送
    [1] = function ( 
                param_1_int,  -- 套餐id
                param_2_unsigned_char -- 充值类型，0普通充值，1每日进阶大礼充值--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 31, 1 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --开通黄钻，获取token
    --客户端发送
    [3] = function ( 
                param_1_int -- 1:黄钻宠物，2:蓝钻武器，3:黄钻武器，4:蓝钻宠物，6:圣诞节开通黄钻
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 31, 3 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --关闭充值窗口
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 31, 2 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[31] = {
    --返回充值的参数，客户端要这些参数调用tx的接口
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_string = np:readString( ) --token
        local var_3_string = np:readString( ) --url_params
        PacketDispatcher:dispather( 31, 1, var_1_int, var_2_string, var_3_string )--分发数据
    end,

    --充值的结果
    --接收服务器
    [2] = function ( np )
        PacketDispatcher:dispather( 31, 2 )--分发数据
    end,

    --返回黄钻的token，成功开通后客户端调用开通换钻成功的消息通知服务端
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --错误码，0是成功
        local var_2_string = np:readString( ) --token
        PacketDispatcher:dispather( 31, 3, var_1_int, var_2_string )--分发数据
    end,


}
