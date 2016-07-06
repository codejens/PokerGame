protocol_func_map_client[16] = {
    --邀请加入队伍
    --客户端发送
    [1] = function ( 
                param_1_string -- 对方的名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 1 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --退出队伍
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 2 ) 
        NetManager:send_packet( np )
    end,

    --申请加入队伍
    --客户端发送
    [3] = function ( 
                param_1_string -- 对方的名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 3 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --设置为队长
    --客户端发送
    [4] = function ( 
                param_1_int -- 对方的actorID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 4 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --踢出一个队友
    --客户端发送
    [5] = function ( 
                param_1_int -- 队友的actorID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 5 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --解散队伍
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 9 ) 
        NetManager:send_packet( np )
    end,

    --队长回复申请入队
    --客户端发送
    [10] = function ( 
                param_1_int,  -- 申请玩家的actorID
                param_2_unsigned_char -- 处理结果--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 10 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --回复邀请加入队伍
    --客户端发送
    [11] = function ( 
                param_1_string,  -- 邀请者的名字
                param_2_unsigned_char,  -- 是否同意--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- 是否自动同意--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 11 ) 
        np:writeString( param_1_string )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取其它队伍成员信息
    --客户端发送
    [15] = function ( 
                param_1_int -- 队伍ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 15 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求队伍列表
    --客户端发送
    [16] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 16 ) 
        NetManager:send_packet( np )
    end,

    --请求无组队的玩家列表
    --客户端发送
    [17] = function ( 
                param_1_unsigned_char -- 1附近的人，2好友
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 17 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --更改队伍说明
    --客户端发送
    [18] = function ( 
                param_1_string -- 队伍说明
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 18 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --更改队伍自动收人选项
    --客户端发送
    [19] = function ( 
                param_1_bool -- true自动收人，false不自动收人
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_bool, lua_type = "boolean" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 16, 19 ) 
        np:writeChar( param_1_bool )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[16] = {
    --删除队伍成员
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --玩家的actorID
        PacketDispatcher:dispather( 16, 3, var_1_int )--分发数据
    end,

    --设置队长
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --玩家的actorID
        PacketDispatcher:dispather( 16, 4, var_1_int )--分发数据
    end,

    --队友退出游戏或者掉线
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --队友的actorId
        PacketDispatcher:dispather( 16, 7, var_1_int )--分发数据
    end,

    --玩家申请加入队伍
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --玩家的actorID
        local var_2_unsigned_char = np:readByte( ) --玩家的等级
        local var_3_unsigned_char = np:readByte( ) --玩家的职业
        local var_4_unsigned_char = np:readByte( ) --玩家的阵营
        local var_5_unsigned_short = np:readWord( ) --头像ID
        local var_6_unsigned_char = np:readByte( ) --性别
        local var_7_string = np:readString( ) --玩家的名字
        PacketDispatcher:dispather( 16, 9, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_short, var_6_unsigned_char, var_7_string )--分发数据
    end,

    --邀请加入队伍
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --玩家的actorID
        local var_2_unsigned_char = np:readByte( ) --玩家的等级
        local var_3_unsigned_char = np:readByte( ) --玩家的职业
        local var_4_unsigned_char = np:readByte( ) --玩家的阵营
        local var_5_int = np:readInt( ) --队伍副本id
        local var_6_string = np:readString( ) --玩家的名字
        PacketDispatcher:dispather( 16, 10, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_int, var_6_string )--分发数据
    end,

    --广播队员死亡或者复活
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --队员id
        local var_2_unsigned_char = np:readByte( ) --0:死亡，1：复活
        PacketDispatcher:dispather( 16, 11, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --广播自己的坐标或场景的变化
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --队员id
        local var_2_int = np:readInt( ) --所在的场景id
        local var_3_unsigned_short = np:readWord( ) --x坐标
        local var_4_unsigned_short = np:readWord( ) --y坐标
        local var_5_unsigned_char = np:readByte( ) --是否超出了经验共享范围--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 16, 12, var_1_int, var_2_int, var_3_unsigned_short, var_4_unsigned_short, var_5_unsigned_char )--分发数据
    end,

    --队友的准备状态发生改变
    --接收服务器
    [13] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体handle--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --玩家ID
        local var_3_unsigned_char = np:readByte( ) --准备状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 16, 13, var_1_int64, var_2_int, var_3_unsigned_char )--分发数据
    end,

    --更新队伍说明
    --接收服务器
    [18] = function ( np )
        local var_1_string = np:readString( ) --队伍说明，更新队伍说明只更新本人队伍的
        PacketDispatcher:dispather( 16, 18, var_1_string )--分发数据
    end,

    --更新队伍自动收人选项
    --接收服务器
    [19] = function ( np )
        local var_1_bool = np:readChar( ) --true自动收人，false不自动收人
        PacketDispatcher:dispather( 16, 19, var_1_bool )--分发数据
    end,


}
