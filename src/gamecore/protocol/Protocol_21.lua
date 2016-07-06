protocol_func_map_client[21] = {
    --提交客服邮件
    --客户端发送
    [1] = function ( 
                param_1_char,  -- 类型，1：bug，2：投诉，3：建议，4：其他
                param_2_string,  -- 标题
                param_3_string -- 内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" }, { param_name = param_3_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 21, 1 ) 
        np:writeChar( param_1_char )
        np:writeString( param_2_string )
        np:writeString( param_3_string )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[21] = {

}
