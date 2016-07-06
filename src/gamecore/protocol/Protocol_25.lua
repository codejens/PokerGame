protocol_func_map_client[25] = {
    --获取好友、仇人、隔离区列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 1 ) 
        NetManager:send_packet( np )
    end,

    --发送聊天信息
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 好友id或群id
                param_2_int,  -- 类型：1：好友，2：群
                param_3_string -- 信息内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 2 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeString( param_3_string )
        NetManager:send_packet( np )
    end,

    --添加仇人
    --客户端发送
    [3] = function ( 
                param_1_int,  -- 仇人id
                param_2_string -- 仇人名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 3 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --请求加好友
    --客户端发送
    [4] = function ( 
                param_1_int,  -- 对方角色id，如果为0，则根据角色名来加好友
                param_2_string -- 角色名
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 4 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --回应加好友
    --客户端发送
    [5] = function ( 
                param_1_int,  -- 请求人id
                param_2_unsigned_short,  -- 1：接受，0：拒绝
                param_3_unsigned_short -- 1：加好友，2：加群
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 5 ) 
        np:writeInt( param_1_int )
        np:writeWord( param_2_unsigned_short )
        np:writeWord( param_3_unsigned_short )
        NetManager:send_packet( np )
    end,

    --添加黑名单，成功返回消息7
    --客户端发送
    [6] = function ( 
                param_1_int,  -- 对方id，如果为0，就看名称
                param_2_string -- 角色名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 6 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --删除好友，仇人，黑名单
    --客户端发送
    [8] = function ( 
                param_1_int,  -- 对方id
                param_2_int -- 类型：1：好友，2仇人，3黑名单
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 8 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --好友升级祝贺
    --客户端发送
    [11] = function ( 
                param_1_int,  -- 好友id
                param_2_int -- 祝贺的等级
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 11 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --查找好友
    --客户端发送
    [12] = function ( 
                param_1_string -- 好友名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 12 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --用户一键征友
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 13 ) 
        NetManager:send_packet( np )
    end,

    --请求一键征友列表
    --客户端发送
    [14] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 25, 14 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[25] = {
    --发送聊天信息
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --发言者id
        local var_2_int = np:readInt( ) --发言者VIP状态
        local var_3_string = np:readString( ) --信息内容
        PacketDispatcher:dispather( 25, 2, var_1_int, var_2_int, var_3_string )--分发数据
    end,

    --某人关注（加好友）了你
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --邀请人的id
        local var_2_int = np:readInt( ) --邀请类型1：加好友，2：加群
        local var_3_int = np:readInt( ) --阵营id
        local var_4_int = np:readInt( ) --等级
        local var_5_unsigned_char = np:readByte( ) --玩家头像ID
        local var_6_string = np:readString( ) --邀请人的角色名
        PacketDispatcher:dispather( 25, 5, var_1_int, var_2_int, var_3_int, var_4_int, var_5_unsigned_char, var_6_string )--分发数据
    end,

    --删除好友（包括仇人，黑名单）
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --对方id
        local var_2_int = np:readInt( ) --类型：1：好友，2仇人，3黑名单
        PacketDispatcher:dispather( 25, 8, var_1_int, var_2_int )--分发数据
    end,

    --好友在线状态
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --好友id
        local var_2_int = np:readInt( ) --1：在线，0：不在线
        PacketDispatcher:dispather( 25, 9, var_1_int, var_2_int )--分发数据
    end,

    --好友信息变更
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --角色id
        local var_2_unsigned_char = np:readByte( ) --等级
        local var_3_unsigned_char = np:readByte( ) --头像
        local var_4_unsigned_char = np:readByte( ) --性别
        PacketDispatcher:dispather( 25, 10, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --更新友好度
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --角色id
        local var_2_int = np:readInt( ) --类型，0是好友的友好度，1是仇人的击杀次数
        local var_3_unsigned_int = np:readUInt( ) --友好度--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 25, 3, var_1_int, var_2_int, var_3_unsigned_int )--分发数据
    end,

    --好友升级祝贺提示
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --好友的id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --好友的等级
        local var_3_int = np:readInt( ) --本人今天发送祝贺的次数
        local var_4_int = np:readInt( ) --可以获取到的经验
        local var_5_string = np:readString( ) --好友名字
        PacketDispatcher:dispather( 25, 11, var_1_int, var_2_int, var_3_int, var_4_int, var_5_string )--分发数据
    end,

    --好友资料
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --角色id
        local var_2_int = np:readInt( ) --等级
        local var_3_int = np:readInt( ) --阵营
        local var_4_int = np:readInt( ) --职业
        local var_5_int = np:readInt( ) --性别
        local var_6_string = np:readString( ) --玩家名字
        local var_7_string = np:readString( ) --仙宗名字
        PacketDispatcher:dispather( 25, 12, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_string, var_7_string )--分发数据
    end,

    --下发当天一键征友的剩余次数，玩家登陆后服务器主动下发
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        PacketDispatcher:dispather( 25, 13, var_1_int )--分发数据
    end,


}
