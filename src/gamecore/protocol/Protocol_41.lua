protocol_func_map_client[41] = {
    --获取玩家的邮件列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 41, 1 ) 
        NetManager:send_packet( np )
    end,

    --删除邮件
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- 要删除的个数--c本参数存在特殊说明，请查阅协议编辑器
                param_3_array -- 邮件的guid--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 41, 4 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        for i = 1, param_2_unsigned_char do 
            -- protocol manual client 数组
            -- 邮件的guid--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_3_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --发邮件
    --客户端发送
    [5] = function ( 
                param_1_string,  -- 收信人的名字
                param_2_string,  -- 内容
                param_3_unsigned_char,  -- 附件的个数
                param_4_array -- 附件--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_string, lua_type = "string" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 41, 5 ) 
        np:writeString( param_1_string )
        np:writeString( param_2_string )
        np:writeByte( param_3_unsigned_char )
        for i = 1, param_3_unsigned_char do 
            -- protocol manual client 数组
            -- 附件--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_4_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --提取附件
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int64 -- 邮件的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 41, 3 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --阅读邮件
    --客户端发送
    [6] = function ( 
                param_1_int,  -- 已阅读邮件的个数
                param_2_array -- 已阅读邮件的guid--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 41, 6 ) 
        np:writeInt( param_1_int )
        for i = 1, param_1_int do 
            -- protocol manual client 数组
            -- 已阅读邮件的guid--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_2_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[41] = {
    --服务端通知客户端有新邮件
    --接收服务器
    [2] = function ( np )
        PacketDispatcher:dispather( 41, 2 )--分发数据
    end,

    --通知客户端提取操作成功
    --接收服务器
    [3] = function ( np )
        PacketDispatcher:dispather( 41, 3 )--分发数据
    end,

    --通知客户端删除操作成功
    --接收服务器
    [4] = function ( np )
        PacketDispatcher:dispather( 41, 4 )--分发数据
    end,

    --通知发送操作成功
    --接收服务器
    [5] = function ( np )
        PacketDispatcher:dispather( 41, 5 )--分发数据
    end,

    --通知客户端预读操作成功
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --标识--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 41, 6, var_1_unsigned_char )--分发数据
    end,

    --通知客户端邮箱快满了
    --接收服务器
    [7] = function ( np )
        PacketDispatcher:dispather( 41, 7 )--分发数据
    end,

    --通知客户端还有附件没有领取
    --接收服务器
    [8] = function ( np )
        PacketDispatcher:dispather( 41, 8 )--分发数据
    end,


}
