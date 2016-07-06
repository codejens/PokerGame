protocol_func_map_client[137] = {
    --领取奖励
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 137, 1 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求技压群雄技能点亮情况
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char -- 技能类型，1宠物，2坐骑，3翅膀
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 137, 2 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --点亮技能图标
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char,  -- 技能类型，1宠物，2坐骑，3翅膀
                param_2_unsigned_char,  -- 第几页
                param_3_unsigned_char,  -- 第几个图标
                param_4_unsigned_char -- 使用第几种消耗方式
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 137, 3 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取点亮全页奖励
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char,  -- 技能类型，1宠物，2坐骑，3翅膀
                param_2_unsigned_char,  -- 第几页
                param_3_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 137, 4 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[137] = {

}
