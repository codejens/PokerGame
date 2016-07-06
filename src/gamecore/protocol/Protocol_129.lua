protocol_func_map_client[129] = {
    --读取自动战斗的保存的数据内容
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 129, 1 ) 
        NetManager:send_packet( np )
    end,

    --保存自动战斗的配置信息
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 配置信息的数量（个数）
                param_2_struct -- 具体的数据类型,至于key代表什么内容数据，由客户端自己定义--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_struct, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 129, 2 ) 
        np:writeInt( param_1_int )
        -- protocol manual client 结构体
        -- 具体的数据类型,至于key代表什么内容数据，由客户端自己定义--c本参数存在特殊说明，请查阅协议编辑器
        if param_2_struct.write_pack then
            param_2_struct:write_pack( np )
        end
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[129] = {

}
