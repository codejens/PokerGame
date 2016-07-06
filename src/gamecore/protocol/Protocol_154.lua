protocol_func_map_client[154] = {
    --获取副本招募信息
    --客户端发送
    [1] = function ( 
                param_1_int,  -- 第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 第几页
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 1 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --申请入队回应
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 玩家ID
                param_2_unsigned_char -- 结果--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 2 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --发布招募
    --客户端发送
    [3] = function ( 
                param_1_int -- 第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 3 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --取消招募
    --客户端发送
    [4] = function ( 
                param_1_int -- 第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 4 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --申请入队
    --客户端发送
    [5] = function ( 
                param_1_unsigned_int -- 队伍ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 5 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --进入副本
    --客户端发送
    [6] = function ( 
                param_1_int -- 第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 6 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --创建队伍
    --客户端发送
    [7] = function ( 
                param_1_int -- 第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 7 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --增加组队副本次数
    --客户端发送
    [8] = function ( 
                param_1_int -- 第几个副本--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 8 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --玩家点击已准备按钮
    --客户端发送
    [9] = function ( 
                param_1_int -- 玩家id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 9 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --玩家设置自动准备
    --客户端发送
    [11] = function ( 
                param_1_unsigned_char -- 勾选发1，取消勾选发0--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 11 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求成员副本次数信息
    --客户端发送
    [10] = function ( 
                param_1_unsigned_int -- 队伍id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 10 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --队长切换副本
    --客户端发送
    [12] = function ( 
                param_1_unsigned_int,  -- 组id
                param_2_char -- 副本下标--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 12 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeChar( param_2_char )
        NetManager:send_packet( np )
    end,

    --邀请加入队伍
    --客户端发送
    [13] = function ( 
                param_1_unsigned_int -- 被邀请者的id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 13 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --新组队-玩家点击.创建.按钮，创建副本
    --客户端发送
    [15] = function ( 
                param_1_unsigned_int,  -- fbId，副本Id
                param_2_unsigned_int,  -- fightValue，最低战力
                param_3_unsigned_char -- autoStart，是否满员且所有玩家都准备时自动开始--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 15 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeUInt( param_2_unsigned_int )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --新组队-玩家加入队伍
    --客户端发送
    [16] = function ( 
                param_1_int,  -- fbId
                param_2_unsigned_int -- teamHdl，队伍句柄
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 16 ) 
        np:writeInt( param_1_int )
        np:writeUInt( param_2_unsigned_int )
        NetManager:send_packet( np )
    end,

    --新组队-客户端请求队伍信息
    --客户端发送
    [20] = function ( 
                param_1_unsigned_int -- fbId，副本Id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 20 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --新组队-队伍内成员（或队长）离开队伍
    --客户端发送
    [18] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 18 ) 
        NetManager:send_packet( np )
    end,

    --新组队-队长T出队伍成员
    --客户端发送
    [21] = function ( 
                param_1_int -- 被T的玩家actorId
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 21 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --新组队-队伍内玩家准备（或取消准备）
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 17 ) 
        NetManager:send_packet( np )
    end,

    --新组队-队长开始游戏
    --客户端发送
    [19] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 19 ) 
        NetManager:send_packet( np )
    end,

    --新组队-队长设置队伍是否满员后自动开启
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 22 ) 
        NetManager:send_packet( np )
    end,

    --新组队#全服广播#-队长发送队伍邀请
    --客户端发送
    [23] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 154, 23 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[154] = {
    --发送申请入队回应
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 154, 2, var_1_unsigned_char )--分发数据
    end,

    --通知有人申请入队
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_string = np:readString( ) --玩家名
        local var_3_unsigned_char = np:readByte( ) --职业
        local var_4_int = np:readInt( ) --等级
        local var_5_int = np:readInt( ) --战斗力
        PacketDispatcher:dispather( 154, 5, var_1_int, var_2_string, var_3_unsigned_char, var_4_int, var_5_int )--分发数据
    end,

    --取消发布招募结果
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --第几个副本
        local var_2_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 154, 3, var_1_int, var_2_int )--分发数据
    end,

    --新组队#队内广播#-服务端返回玩家加入队伍结果
    --接收服务器
    [16] = function ( np )
        local var_1_int = np:readInt( ) --fbId，副本Id
        local var_2_unsigned_int = np:readUInt( ) --teamHdl，队伍句柄
        local var_3_unsigned_int = np:readUInt( ) --serverId，玩家所属的服务器Id
        local var_4_int = np:readInt( ) --actorId，玩家Id
        local var_5_string = np:readString( ) --name，玩家名称
        local var_6_unsigned_char = np:readByte( ) --teamStatus，0:队员，1:队长
        local var_7_unsigned_int = np:readUInt( ) --level，玩家等级
        local var_8_int = np:readInt( ) --fightValue，玩家战力
        local var_9_unsigned_char = np:readByte( ) --sec，玩家性别
        local var_10_unsigned_int = np:readUInt( ) --icon，玩家头像
        local var_11_unsigned_char = np:readByte( ) --byte: 0:未准备，1:准备
        PacketDispatcher:dispather( 154, 16, var_1_int, var_2_unsigned_int, var_3_unsigned_int, var_4_int, var_5_string, var_6_unsigned_char, var_7_unsigned_int, var_8_int, var_9_unsigned_char, var_10_unsigned_int, var_11_unsigned_char )--分发数据
    end,

    --新组队#队内广播#-成员离开队伍结果（被T或主动离开）
    --接收服务器
    [18] = function ( np )
        local var_1_int = np:readInt( ) --fbId，副本Id
        local var_2_unsigned_int = np:readUInt( ) --teamHdl，队伍句柄
        local var_3_int = np:readInt( ) --actorId，离开队伍（或被T出）的玩家Id
        PacketDispatcher:dispather( 154, 18, var_1_int, var_2_unsigned_int, var_3_int )--分发数据
    end,

    --新组队#队内广播#-服务端广播成员准备状态
    --接收服务器
    [19] = function ( np )
        local var_1_int = np:readInt( ) --fbId
        local var_2_unsigned_int = np:readUInt( ) --teamHdl，队伍句柄
        local var_3_int = np:readInt( ) --actorId，玩家Id
        local var_4_unsigned_char = np:readByte( ) --type，0:取消准备，1:准备
        PacketDispatcher:dispather( 154, 19, var_1_int, var_2_unsigned_int, var_3_int, var_4_unsigned_char )--分发数据
    end,

    --新组队#全服广播#-队伍被解散
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --fbId
        local var_2_unsigned_int = np:readUInt( ) --teamHdl，被解散的队伍句柄
        PacketDispatcher:dispather( 154, 20, var_1_int, var_2_unsigned_int )--分发数据
    end,

    --（废弃）新组队-队伍进入游戏倒计时（用来禁止玩家操作）
    --接收服务器
    [21] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --countDown，倒计时，单位是秒
        PacketDispatcher:dispather( 154, 21, var_1_unsigned_char )--分发数据
    end,

    --新组队#全服广播#-队伍的在线人数改变
    --接收服务器
    [22] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --teamHdl，队伍句柄
        local var_2_unsigned_int = np:readUInt( ) --count，当前队伍内的人数
        PacketDispatcher:dispather( 154, 22, var_1_unsigned_int, var_2_unsigned_int )--分发数据
    end,

    --新组队#全服广播#-新队伍被创建
    --接收服务器
    [23] = function ( np )
        local var_1_int = np:readInt( ) --fbId，副本Id
        local var_2_unsigned_int = np:readUInt( ) --teamHdl，队伍句柄
        local var_3_unsigned_int = np:readUInt( ) --serverId，队长来自多少服
        local var_4_string = np:readString( ) --captainName，队长名称
        local var_5_int = np:readInt( ) --minFightValue，最低战力要求
        local var_6_unsigned_char = np:readByte( ) --是否满员后自动开始，0:不自动开始，1:自动开始
        local var_7_unsigned_int = np:readUInt( ) --队伍成员人数
        PacketDispatcher:dispather( 154, 23, var_1_int, var_2_unsigned_int, var_3_unsigned_int, var_4_string, var_5_int, var_6_unsigned_char, var_7_unsigned_int )--分发数据
    end,

    --新组队#队内广播#-发送队伍是否自动开启
    --接收服务器
    [24] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --teamHdl
        local var_2_unsigned_char = np:readByte( ) --autoStart，0:不自动开启，1:自动开启
        PacketDispatcher:dispather( 154, 24, var_1_unsigned_int, var_2_unsigned_char )--分发数据
    end,


}
