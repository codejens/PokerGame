protocol_func_map_client[131] = {
    --拜师
    --客户端发送
    [1] = function ( 
                param_1_unsigned_int64,  -- 对方的handle
                param_2_unsigned_char -- 拜师还是收徒--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 131, 1 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端上传用户选择了哪些人结拜
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char,  -- 选择的数量
                param_2_unsigned_int64 -- 角色的handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 131, 2 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeUint64( param_2_unsigned_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[131] = {

}
