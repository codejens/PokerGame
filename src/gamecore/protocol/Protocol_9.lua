protocol_func_map_client[9] = {
    --发送聊天信息
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char,  -- 频道ID
                param_2_unsigned_char,  -- 是否扣钱--c本参数存在特殊说明，请查阅协议编辑器
                param_3_string -- 聊天的内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 9, 1 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeString( param_3_string )
        NetManager:send_packet( np )
    end,

    --私聊_发送私聊消息
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 对方玩家id 
                param_2_int,  -- 是否扣钱--c本参数存在特殊说明，请查阅协议编辑器
                param_3_string,  -- 对方玩家的名字
                param_4_string -- 私聊
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_string, lua_type = "string" }, { param_name = param_4_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 9, 2 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeString( param_3_string )
        np:writeString( param_4_string )
        NetManager:send_packet( np )
    end,

    --发送GM公告
    --客户端发送
    [3] = function ( 
                param_1_string,  -- 公告的内容
                param_2_int -- 公告显示位置的掩码--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 9, 3 ) 
        np:writeString( param_1_string )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --上发vip的专用表情
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char -- 聊天表情的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 9, 4 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --上发灵泉仙浴表情和消息内容
    --客户端发送
    [5] = function ( 
                param_1_string -- 内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 9, 5 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --私聊_请求私聊
    --客户端发送
    [6] = function ( 
                param_1_int -- actorId，对方ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 9, 6 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[9] = {
    --向客户端发聊天消息
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --可以看到的玩家等级--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --玩家id 发送者
        local var_3_unsigned_char = np:readByte( ) --频道ID
        local var_4_unsigned_char = np:readByte( ) --性别--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_char = np:readByte( ) --标志位--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_unsigned_char = np:readByte( ) --阵营Id
        local var_7_unsigned_char = np:readByte( ) --职业
        local var_8_unsigned_char = np:readByte( ) --等级
        local var_9_unsigned_char = np:readByte( ) --头像id
        local var_10_int = np:readInt( ) --蓝黄钻信息
        local var_11_int = np:readInt( ) --发送者社会关系
        local var_12_string = np:readString( ) --玩家的名字
        local var_13_string = np:readString( ) --聊天内容
        PacketDispatcher:dispather( 9, 1, var_1_int, var_2_int, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_unsigned_char, var_8_unsigned_char, var_9_unsigned_char, var_10_int, var_11_int, var_12_string, var_13_string )--分发数据
    end,

    --系统提示
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家的等级，低于这个等级则不显示这个信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --显示的位置--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_string = np:readString( ) --系统提示信息
        PacketDispatcher:dispather( 9, 2, var_1_unsigned_char, var_2_unsigned_char, var_3_string )--分发数据
    end,

    --私聊_下发私聊消息
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --发送的玩家id
        local var_2_unsigned_char = np:readByte( ) --性别
        local var_3_unsigned_char = np:readByte( ) --职业
        local var_4_unsigned_char = np:readByte( ) --阵营id
        local var_5_unsigned_char = np:readByte( ) --等级
        local var_6_unsigned_char = np:readByte( ) --头像
        local var_7_int = np:readInt( ) --玩家VIP状态
        local var_8_int = np:readInt( ) --发送者社会关系
        local var_9_unsigned_int = np:readUInt( ) --队伍id，没组队就是0
        local var_10_string = np:readString( ) --玩家的名字
        local var_11_string = np:readString( ) --私聊的内容
        PacketDispatcher:dispather( 9, 3, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_int, var_8_int, var_9_unsigned_int, var_10_string, var_11_string )--分发数据
    end,

    --下发附近非玩家（怪物或者NPC）的聊天消息
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --实体handle--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_string = np:readString( ) --聊天消息内容
        PacketDispatcher:dispather( 9, 4, var_1_unsigned_int64, var_2_string )--分发数据
    end,

    --下发公告
    --接收服务器
    [5] = function ( np )
        local var_1_string = np:readString( ) --公告的内容
        local var_2_int = np:readInt( ) --公告的显示位置，按位掩码的
        PacketDispatcher:dispather( 9, 5, var_1_string, var_2_int )--分发数据
    end,

    --广播vip专属表情
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --发vip表情的玩家的句柄
        local var_2_unsigned_char = np:readByte( ) --表情的ID
        PacketDispatcher:dispather( 9, 6, var_1_unsigned_int64, var_2_unsigned_char )--分发数据
    end,

    --客户端弹出飞出的提示框 
    --接收服务器
    [7] = function ( np )
        local var_1_string = np:readString( ) --文字内容
        PacketDispatcher:dispather( 9, 7, var_1_string )--分发数据
    end,

    --场景内广播灵泉仙浴表情
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --广播者的handle
        local var_2_string = np:readString( ) --广播内容
        PacketDispatcher:dispather( 9, 8, var_1_unsigned_int64, var_2_string )--分发数据
    end,

    --播放最后一条聊天消息
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --玩家id 发送者
        local var_2_unsigned_char = np:readByte( ) --频道ID
        local var_3_unsigned_char = np:readByte( ) --性别--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_char = np:readByte( ) --标志位--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_char = np:readByte( ) --阵营Id
        local var_6_unsigned_char = np:readByte( ) --职业
        local var_7_unsigned_char = np:readByte( ) --等级
        local var_8_unsigned_char = np:readByte( ) --头像id
        local var_9_int = np:readInt( ) --蓝黄钻信息
        local var_10_int = np:readInt( ) --发送者社会关系
        local var_11_string = np:readString( ) --玩家的名字
        local var_12_string = np:readString( ) --聊天内容
        PacketDispatcher:dispather( 9, 9, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_unsigned_char, var_8_unsigned_char, var_9_int, var_10_int, var_11_string, var_12_string )--分发数据
    end,

    --清理某个玩家的已发千里传音内容（Lua）
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --玩家id 发送者
        PacketDispatcher:dispather( 9, 10, var_1_int )--分发数据
    end,

    --私聊_应答私聊请求
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --actorId，对方ID
        local var_2_unsigned_char = np:readByte( ) --askResult，请求结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_string = np:readString( ) --actorName，对方的名字
        local var_4_unsigned_char = np:readByte( ) --level，等级
        local var_5_unsigned_char = np:readByte( ) --sex，性别
        local var_6_unsigned_char = np:readByte( ) --job，职业
        local var_7_unsigned_char = np:readByte( ) --icon，头像
        PacketDispatcher:dispather( 9, 11, var_1_int, var_2_unsigned_char, var_3_string, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_unsigned_char )--分发数据
    end,

    --私聊_发送玩家GM等级
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --gmLevel，玩家自己的GM等级--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 9, 12, var_1_int )--分发数据
    end,


}
