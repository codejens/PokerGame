protocol_func_map_client[32] = {
    --请求阵营初始化数据
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 1 ) 
        NetManager:send_packet( np )
    end,

    --请求阵营职位信息
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 2 ) 
        NetManager:send_packet( np )
    end,

    --邀请某个玩家担任某个职位
    --客户端发送
    [3] = function ( 
                param_1_int,  -- 职位Id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 被邀请玩家名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 3 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --被邀请者处理邀请的结果
    --客户端发送
    [4] = function ( 
                param_1_unsigned_int64,  -- 邀请者实体句柄
                param_2_int,  -- 阵营职位Id--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 被玩家玩家对于邀请的处理结果--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 4 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --任免职位
    --客户端发送
    [5] = function ( 
                param_1_int -- 职位Id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 5 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --修改阵营公告
    --客户端发送
    [6] = function ( 
                param_1_string,  -- 公告内容
                param_2_int -- 阵营id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 6 ) 
        np:writeString( param_1_string )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --申请结盟
    --客户端发送
    [7] = function ( 
                param_1_int -- 结盟阵营Id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 7 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --申请结盟处理结果
    --客户端发送
    [8] = function ( 
                param_1_bool,  -- 处理结果。1是同意 0 为拒绝结盟
                param_2_string -- 申请结盟的盟主名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_bool, lua_type = "boolean" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 8 ) 
        np:writeChar( param_1_bool )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --请求阵营buff
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 9 ) 
        NetManager:send_packet( np )
    end,

    --请求阵营实力数据
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 10 ) 
        NetManager:send_packet( np )
    end,

    --请求提升江湖地位
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 11 ) 
        NetManager:send_packet( np )
    end,

    --解散阵营联盟
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 32, 12 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[32] = {
    --下发阵营公告
    --接收服务器
    [2] = function ( np )
        local var_1_string = np:readString( ) --阵营公告
        PacketDispatcher:dispather( 32, 2, var_1_string )--分发数据
    end,

    --江湖地位更新
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --阵营Id
        local var_2_int = np:readInt( ) --老的江湖地位
        local var_3_int = np:readInt( ) --新的江湖地位
        PacketDispatcher:dispather( 32, 4, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --邀请任命
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --任职发起者实体句柄
        local var_2_int = np:readInt( ) --职位Id
        local var_3_string = np:readString( ) --任职发起者名称
        PacketDispatcher:dispather( 32, 6, var_1_unsigned_int64, var_2_int, var_3_string )--分发数据
    end,

    --职位变更
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --变化前的职位Id
        local var_2_int = np:readInt( ) --变化后的职位Id
        local var_3_string = np:readString( ) --被任命者名称
        local var_4_string = np:readString( ) --任职者玩家名称
        PacketDispatcher:dispather( 32, 7, var_1_int, var_2_int, var_3_string, var_4_string )--分发数据
    end,

    --添加阵营Buff
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --buff类型
        local var_2_unsigned_char = np:readByte( ) --buff组
        local var_3_int = np:readInt( ) --剩余时间
        local var_4_string = np:readString( ) --buff名称
        local var_5_unsigned_char = np:readByte( ) --属性数据类型
        local var_6_int = np:readInt( ) --属性值--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_unsigned_short = np:readWord( ) --间隔时间
        local var_8_unsigned_int = np:readUInt( ) --Buff创建时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 32, 10, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_string, var_5_unsigned_char, var_6_int, var_7_unsigned_short, var_8_unsigned_int )--分发数据
    end,

    --删除阵营Buff
    --接收服务器
    [11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --buff类型
        local var_2_unsigned_char = np:readByte( ) --buff组
        PacketDispatcher:dispather( 32, 11, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --删除阵营类型Buff
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --buff类型
        PacketDispatcher:dispather( 32, 12, var_1_unsigned_char )--分发数据
    end,

    --结盟关系变化
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --老的盟友阵营id
        local var_2_int = np:readInt( ) --新的盟友阵营id
        PacketDispatcher:dispather( 32, 14, var_1_int, var_2_int )--分发数据
    end,

    --申请结盟（给目标阵营盟主）
    --接收服务器
    [15] = function ( np )
        local var_1_int = np:readInt( ) --阵营id
        local var_2_unsigned_int64 = np:readUint64( ) --申请结盟的盟主句柄
        local var_3_string = np:readString( ) --发起结盟申请的玩家名称
        PacketDispatcher:dispather( 32, 15, var_1_int, var_2_unsigned_int64, var_3_string )--分发数据
    end,

    --提醒玩家提升江湖地位
    --接收服务器
    [17] = function ( np )
        PacketDispatcher:dispather( 32, 17 )--分发数据
    end,


}
