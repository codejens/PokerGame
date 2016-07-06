protocol_func_map_client[160] = {
    --查看6强争霸小组信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 1 ) 
        NetManager:send_packet( np )
    end,

    --查看6强争霸小组详情
    --客户端发送
    [2] = function ( 
                param_1_int -- 第几个小组--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 2 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --进入6强争霸赛
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 3 ) 
        NetManager:send_packet( np )
    end,

    --获取6强仙宗信息
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 6 ) 
        NetManager:send_packet( np )
    end,

    --参加城主争夺赛
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 7 ) 
        NetManager:send_packet( np )
    end,

    --获取无主城资格赛排行
    --客户端发送
    [9] = function ( 
                param_1_unsigned_char,  -- 资格赛id
                param_2_unsigned_short,  -- 起始条数位置--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_short -- 结束条数--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 9 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeWord( param_2_unsigned_short )
        np:writeWord( param_3_unsigned_short )
        NetManager:send_packet( np )
    end,

    --进入无主仙城资格赛副本
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 10 ) 
        NetManager:send_packet( np )
    end,

    --获取仙城相关信息
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 11 ) 
        NetManager:send_packet( np )
    end,

    --获取仙城记事记录
    --客户端发送
    [12] = function ( 
                param_1_int -- 第几个仙城（从1开始）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 12 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --进入攻坚赛
    --客户端发送
    [14] = function ( 
                param_1_unsigned_char -- 仙城id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 14 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取自己仙宗竞拍攻坚资格信息
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 15 ) 
        NetManager:send_packet( np )
    end,

    --获取竞拍攻坚资格信息
    --客户端发送
    [16] = function ( 
                param_1_char -- 灵脉ID--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 16 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --请求竞拍（成功后会返回15）
    --客户端发送
    [17] = function ( 
                param_1_char,  -- 灵脉ID--c本参数存在特殊说明，请查阅协议编辑器
                param_2_char,  -- 第几场--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 出价
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 17 ) 
        np:writeChar( param_1_char )
        np:writeChar( param_2_char )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --放弃竞拍资格（成功后会返回15）
    --客户端发送
    [18] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 18 ) 
        NetManager:send_packet( np )
    end,

    --请求本仙宗的成员出价排行信息
    --客户端发送
    [19] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 19 ) 
        NetManager:send_packet( np )
    end,

    --设置金仙之力出战人员
    --客户端发送
    [21] = function ( 
                param_1_int,  -- 出战次序--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 出战玩家ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 21 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --查询金仙之力出战人员
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 22 ) 
        NetManager:send_packet( np )
    end,

    --查看所有灵脉的竞拍得主信息
    --客户端发送
    [23] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 23 ) 
        NetManager:send_packet( np )
    end,

    --申请加入同盟
    --客户端发送
    [24] = function ( 
                param_1_char,  -- 申请类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_char,  -- 灵脉ID
                param_3_char,  -- 轮次ID--c本参数存在特殊说明，请查阅协议编辑器
                param_4_string -- 申请宣言
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" }, { param_name = param_3_char, lua_type = "number" }, { param_name = param_4_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 24 ) 
        np:writeChar( param_1_char )
        np:writeChar( param_2_char )
        np:writeChar( param_3_char )
        np:writeString( param_4_string )
        NetManager:send_packet( np )
    end,

    --同意申请者加入同盟
    --客户端发送
    [25] = function ( 
                param_1_short -- 索引--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 25 ) 
        np:writeShort( param_1_short )
        NetManager:send_packet( np )
    end,

    --拒绝申请者加入同盟
    --客户端发送
    [26] = function ( 
                param_1_short -- 索引--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 26 ) 
        np:writeShort( param_1_short )
        NetManager:send_packet( np )
    end,

    --圣皇仙城争夺_参加比赛
    --客户端发送
    [28] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 28 ) 
        NetManager:send_packet( np )
    end,

    --城主或挑战资格者取消与同盟的同盟关系
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 29 ) 
        NetManager:send_packet( np )
    end,

    --查看申请加入同盟的列表
    --客户端发送
    [30] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 30 ) 
        NetManager:send_packet( np )
    end,

    --退出副本，返回到普通服
    --客户端发送
    [31] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 31 ) 
        NetManager:send_packet( np )
    end,

    --进入仙城
    --客户端发送
    [32] = function ( 
                param_1_unsigned_char -- 仙城ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 32 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求赛程信息
    --客户端发送
    [27] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 27 ) 
        NetManager:send_packet( np )
    end,

    --获取同盟列表
    --客户端发送
    [33] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 33 ) 
        NetManager:send_packet( np )
    end,

    --查看指定灵脉的竞拍得主信息
    --客户端发送
    [34] = function ( 
                param_1_char -- 灵脉ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 34 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --查看指定灵脉的同盟信息
    --客户端发送
    [35] = function ( 
                param_1_char -- 灵脉ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 35 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --请求竞拍状态
    --客户端发送
    [36] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 36 ) 
        NetManager:send_packet( np )
    end,

    --请求同盟招募状态
    --客户端发送
    [37] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 37 ) 
        NetManager:send_packet( np )
    end,

    --请求攻坚赛金仙之力资格信息
    --客户端发送
    [38] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 38 ) 
        NetManager:send_packet( np )
    end,

    --请求本仙宗申请了的同盟
    --客户端发送
    [41] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 41 ) 
        NetManager:send_packet( np )
    end,

    --请求获取城主宣言或者修改城主宣言
    --客户端发送
    [42] = function ( 
                param_1_char,  -- 灵脉ID
                param_2_char,  -- 操作类型--c本参数存在特殊说明，请查阅协议编辑器
                param_3_string -- 宣言
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" }, { param_name = param_3_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 42 ) 
        np:writeChar( param_1_char )
        np:writeChar( param_2_char )
        np:writeString( param_3_string )
        NetManager:send_packet( np )
    end,

    --查看同盟申请仙宗的成员列表
    --客户端发送
    [44] = function ( 
                param_1_int -- 仙宗ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 44 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取士气排行榜
    --客户端发送
    [47] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 47 ) 
        NetManager:send_packet( np )
    end,

    --使用如意锦囊
    --客户端发送
    [48] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 160, 48 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[160] = {
    --跨服群战状态改变
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几周--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --阶段--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --该阶段的结束时间
        PacketDispatcher:dispather( 160, 8, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --下发攻坚赛结果
    --接收服务器
    [14] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --仙城id
        local var_2_unsigned_char = np:readByte( ) --获胜方--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 160, 14, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --下发自己仙宗的竞拍攻坚资格信息
    --接收服务器
    [15] = function ( np )
        local var_1_char = np:readChar( ) --已竞拍的灵脉ID--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --已竞拍的场次--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --仙宗出价
        local var_4_string = np:readString( ) --仙宗宣言
        PacketDispatcher:dispather( 160, 15, var_1_char, var_2_char, var_3_int, var_4_string )--分发数据
    end,

    --圣皇仙城争夺_下发比赛结果
    --接收服务器
    [28] = function ( np )
        PacketDispatcher:dispather( 160, 28 )--分发数据
    end,

    --下发竞拍状态
    --接收服务器
    [36] = function ( np )
        local var_1_char = np:readChar( ) --状态类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 160, 36, var_1_char )--分发数据
    end,

    --下发同盟招募状态
    --接收服务器
    [37] = function ( np )
        local var_1_char = np:readChar( ) --状态类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 160, 37, var_1_char )--分发数据
    end,

    --下发攻坚赛金仙之力资格信息
    --接收服务器
    [38] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --仙城id
        local var_2_unsigned_char = np:readByte( ) --资格信息--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 160, 38, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --显示跨服群战图标
    --接收服务器
    [40] = function ( np )
        PacketDispatcher:dispather( 160, 40 )--分发数据
    end,

    --下发城主宣主
    --接收服务器
    [42] = function ( np )
        local var_1_char = np:readChar( ) --灵脉ID
        local var_2_string = np:readString( ) --宣言
        PacketDispatcher:dispather( 160, 42, var_1_char, var_2_string )--分发数据
    end,

    --清理数据
    --接收服务器
    [43] = function ( np )
        local var_1_char = np:readChar( ) --类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 160, 43, var_1_char )--分发数据
    end,

    --同盟信息
    --接收服务器
    [45] = function ( np )
        local var_1_string = np:readString( ) --同盟仙宗名
        PacketDispatcher:dispather( 160, 45, var_1_string )--分发数据
    end,

    --同意申请者加入同盟结果
    --接收服务器
    [25] = function ( np )
        local var_1_char = np:readChar( ) --错误码--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --同意的同盟仙宗ID
        PacketDispatcher:dispather( 160, 25, var_1_char, var_2_int )--分发数据
    end,

    --发送攻守双方的士气值
    --接收服务器
    [46] = function ( np )
        local var_1_int = np:readInt( ) --攻城方士气值
        local var_2_int = np:readInt( ) --守城方士气值
        PacketDispatcher:dispather( 160, 46, var_1_int, var_2_int )--分发数据
    end,

    --发送如意锦囊状态
    --接收服务器
    [48] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --如意锦囊的状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --剩余CD时间
        local var_3_int = np:readInt( ) --下次使用需要的元宝数
        PacketDispatcher:dispather( 160, 48, var_1_unsigned_char, var_2_int, var_3_int )--分发数据
    end,


}
