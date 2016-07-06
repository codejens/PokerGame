protocol_func_map_client[10] = {
    --获取本人的帮派信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 1 ) 
        NetManager:send_packet( np )
    end,

    --获取帮派成员列表
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 2 ) 
        NetManager:send_packet( np )
    end,

    --获取帮派的信息内容
    --客户端发送
    [3] = function ( 
                param_1_unsigned_short,  -- 当前第几页
                param_2_unsigned_short -- 每页的数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 3 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        NetManager:send_packet( np )
    end,

    --创建帮派
    --客户端发送
    [4] = function ( 
                param_1_unsigned_short,  -- 帮派图标索引值
                param_2_unsigned_char,  -- 1为一级帮派，2为二级帮派，3为三级帮派
                param_3_unsigned_char,  -- buyType，购买类型，仅在创建二三级帮派时有效--c本参数存在特殊说明，请查阅协议编辑器
                param_4_string -- 帮派名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 4 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        np:writeString( param_4_string )
        NetManager:send_packet( np )
    end,

    --解散帮派
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 5 ) 
        NetManager:send_packet( np )
    end,

    --脱离帮派
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 6 ) 
        NetManager:send_packet( np )
    end,

    --邀请玩家加入帮派
    --客户端发送
    [7] = function ( 
                param_1_int,  -- 玩家的id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 玩家的名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 7 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --是否接受邀请加入帮派
    --客户端发送
    [8] = function ( 
                param_1_int,  -- 接受邀请还是拒绝--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 帮派的id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 8 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --用户提交加入帮派的申请
    --客户端发送
    [9] = function ( 
                param_1_int -- 帮派id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 9 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --申请加入的审核结果
    --客户端发送
    [10] = function ( 
                param_1_int,  -- 审核结果，0是拒绝，1是接受
                param_2_int -- 申请加入人的角色id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 10 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --显示申请加入帮派的消息的列表
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 11 ) 
        NetManager:send_packet( np )
    end,

    --升降级
    --客户端发送
    [12] = function ( 
                param_1_int,  -- 操作的角色id
                param_2_int -- 调整到什么职位--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 12 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --开除成员
    --客户端发送
    [13] = function ( 
                param_1_int -- 被开除的角色id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 13 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --更新公告或群聊
    --客户端发送
    [14] = function ( 
                param_1_int,  -- 0：公告，1：群聊，2语音
                param_2_string -- 公告内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 14 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --领取每日福利
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 15 ) 
        NetManager:send_packet( np )
    end,

    --升级帮派
    --客户端发送
    [16] = function ( 
                param_1_int -- 升级哪个建筑，0-3 代表4个建筑
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 16 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --捐献
    --客户端发送
    [17] = function ( 
                param_1_char,  -- 捐献的物品类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 捐献的元宝数量或者灵石数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 17 ) 
        np:writeChar( param_1_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --在商店离购买物品
    --客户端发送
    [18] = function ( 
                param_1_int,  -- 物品id
                param_2_int -- 数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 18 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求仙宗等级信息 返回协议16
    --客户端发送
    [19] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 19 ) 
        NetManager:send_packet( np )
    end,

    --帮派聊天
    --客户端发送
    [22] = function ( 
                param_1_unsigned_char,  -- 字体颜色
                param_2_string -- 聊天内容
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 22 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --勾选不再显示聊天框
    --客户端发送
    [23] = function ( 
                param_1_unsigned_char -- 设置是否显示聊天框--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 23 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取是否显示聊天框
    --客户端发送
    [24] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 24 ) 
        NetManager:send_packet( np )
    end,

    --获取帮派公告
    --客户端发送
    [26] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 26 ) 
        NetManager:send_packet( np )
    end,

    --获取仙宗仓库物品列表
    --客户端发送
    [27] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 27 ) 
        NetManager:send_packet( np )
    end,

    --背包拖一个物品到仙宗仓库
    --客户端发送
    [28] = function ( 
                param_1_int64,  -- 物品的guid
                param_2_int64 -- 目标位置物品的guid--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 28 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --仙宗仓库拖一个物品到背包
    --客户端发送
    [29] = function ( 
                param_1_int64,  -- 物品的guid
                param_2_int64,  -- 目标位置物品的guid--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int -- 物品数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 29 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt64( param_2_int64 )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --整理仙宗仓库
    --客户端发送
    [30] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 30 ) 
        NetManager:send_packet( np )
    end,

    --获取帮派神兽祭坛信息
    --客户端发送
    [31] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 31 ) 
        NetManager:send_packet( np )
    end,

    --抚摸
    --客户端发送
    [32] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 32 ) 
        NetManager:send_packet( np )
    end,

    --献果
    --客户端发送
    [33] = function ( 
                param_1_int -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 33 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --找回献果次数
    --客户端发送
    [34] = function ( 
                param_1_int -- 找回多少次
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 34 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取献果，抚摸日志
    --客户端发送
    [35] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 35 ) 
        NetManager:send_packet( np )
    end,

    --福地之战_获取开启配置
    --客户端发送
    [37] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 37 ) 
        NetManager:send_packet( np )
    end,

    --福地之战_开启副本
    --客户端发送
    [38] = function ( 
                param_1_unsigned_char -- 难度1/2/3/4
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 38 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取仙宗事件记录
    --客户端发送
    [41] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 41 ) 
        NetManager:send_packet( np )
    end,

    --查看弹劾动态
    --客户端发送
    [45] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 45 ) 
        NetManager:send_packet( np )
    end,

    --弹劾
    --客户端发送
    [46] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 46 ) 
        NetManager:send_packet( np )
    end,

    --宗主取消弹劾
    --客户端发送
    [47] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 47 ) 
        NetManager:send_packet( np )
    end,

    --请求帮派技能数据
    --客户端发送
    [48] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 48 ) 
        NetManager:send_packet( np )
    end,

    --升级技能
    --客户端发送
    [49] = function ( 
                param_1_unsigned_char -- 技能ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 49 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --升级厢房
    --客户端发送
    [50] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 50 ) 
        NetManager:send_packet( np )
    end,

    --申请帮派仓库物品
    --客户端发送
    [51] = function ( 
                param_1_int64,  -- 申请的物品guid
                param_2_int -- 申请的物品数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 51 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求申请帮派仓库物品的消息列表
    --客户端发送
    [52] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 52 ) 
        NetManager:send_packet( np )
    end,

    --帮主审核申请仓库物品结果
    --客户端发送
    [53] = function ( 
                param_1_int,  -- 玩家id(申请人id)
                param_2_int64,  -- 申请的物品guid
                param_3_int,  -- 申请的数量
                param_4_int -- 审核类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" }, { param_name = param_4_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 53 ) 
        np:writeInt( param_1_int )
        np:writeInt64( param_2_int64 )
        np:writeInt( param_3_int )
        np:writeInt( param_4_int )
        NetManager:send_packet( np )
    end,

    --请求仓库物品状态
    --客户端发送
    [54] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 54 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --夺宝_获取宝箱信息
    --客户端发送
    [55] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 55 ) 
        NetManager:send_packet( np )
    end,

    --夺宝_开启宝箱
    --客户端发送
    [56] = function ( 
                param_1_unsigned_char -- 宝箱类型，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 56 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --夺宝_领取宝箱
    --客户端发送
    [57] = function ( 
                param_1_unsigned_int -- 宝箱id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 57 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --夺宝_夺取宝箱
    --客户端发送
    [58] = function ( 
                param_1_unsigned_int -- 宝箱id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 10, 58 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[10] = {
    --帮派的详细信息
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0正确，1本人没加入帮派
        local var_2_int = np:readInt( ) --帮派排名
        local var_3_int = np:readInt( ) --帮派等级--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --帮派贡献值
        local var_5_int = np:readInt( ) --累计贡献值
        local var_6_unsigned_char = np:readByte( ) --帮派地位
        local var_7_int = np:readInt( ) --帮主的id
        local var_8_unsigned_short = np:readWord( ) --帮派的图标
        local var_9_int = np:readInt( ) --灵石数量
        local var_10_int = np:readInt( ) --成员数量
        local var_11_int = np:readInt( ) --在线成员数量
        local var_12_int = np:readInt( ) --能否领取福利，0不可以，1可以
        local var_13_int = np:readInt( ) --弹劾状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_14_string = np:readString( ) --帮主名称
        local var_15_string = np:readString( ) --帮派名称
        local var_16_string = np:readString( ) --公告
        local var_17_string = np:readString( ) --yy语音
        local var_18_string = np:readString( ) --群聊
        PacketDispatcher:dispather( 10, 1, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_int, var_6_unsigned_char, var_7_int, var_8_unsigned_short, var_9_int, var_10_int, var_11_int, var_12_int, var_13_int, var_14_string, var_15_string, var_16_string, var_17_string, var_18_string )--分发数据
    end,

    --创建帮派结果
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --创建的帮派id
        PacketDispatcher:dispather( 10, 4, var_1_int )--分发数据
    end,

    --通知玩家邀请信息，客户端必须要玩家选择接受还是拒绝
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --帮派id
        local var_2_string = np:readString( ) --帮派的名称
        local var_3_string = np:readString( ) --邀请人的名称
        PacketDispatcher:dispather( 10, 7, var_1_int, var_2_string, var_3_string )--分发数据
    end,

    --更新帮派的信息,客户端收到这个消息后，重新申请帮派的数据
    --接收服务器
    [17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --变化的内容，对于没打开仙宗的窗口的用户，这条消息可以直接忽略--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 10, 17, var_1_unsigned_char )--分发数据
    end,

    --升级的结果
    --接收服务器
    [16] = function ( np )
        local var_1_int64 = np:readInt64( ) --当前等级--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 10, 16, var_1_int64 )--分发数据
    end,

    --申请加入的审核结果
    --接收服务器
    [10] = function ( np )
        local var_1_string = np:readString( ) --帮派名称--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 10, 10, var_1_string )--分发数据
    end,

    --灵石数量改变
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --当前数量
        PacketDispatcher:dispather( 10, 20, var_1_int )--分发数据
    end,

    --申请加入帮派的结果
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --帮派id
        local var_2_int = np:readInt( ) --结果，0成功，1失败
        PacketDispatcher:dispather( 10, 9, var_1_int, var_2_int )--分发数据
    end,

    --领取帮派福利结果
    --接收服务器
    [15] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0：成功，1失败
        local var_2_string = np:readString( ) --提示语
        PacketDispatcher:dispather( 10, 15, var_1_unsigned_char, var_2_string )--分发数据
    end,

    --总的帮派贡献改变
    --接收服务器
    [21] = function ( np )
        local var_1_int = np:readInt( ) --当前值
        PacketDispatcher:dispather( 10, 21, var_1_int )--分发数据
    end,

    --帮派聊天
    --接收服务器
    [22] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --字体颜色
        local var_2_unsigned_char = np:readByte( ) --帮派职位
        local var_3_int = np:readInt( ) --玩家VIP状态
        local var_4_string = np:readString( ) --玩家姓名
        local var_5_string = np:readString( ) --聊天内容
        PacketDispatcher:dispather( 10, 22, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_string, var_5_string )--分发数据
    end,

    --勾选不再显示聊天框
    --接收服务器
    [23] = function ( np )
        PacketDispatcher:dispather( 10, 23 )--分发数据
    end,

    --获取是否显示聊天框
    --接收服务器
    [24] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --获取是否显示聊天框--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 10, 24, var_1_unsigned_char )--分发数据
    end,

    --通知帮派成员是否上线
    --接收服务器
    [25] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_unsigned_char = np:readByte( ) --玩家是否在线--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 10, 25, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --获取帮派公告
    --接收服务器
    [26] = function ( np )
        local var_1_string = np:readString( ) --帮派公告
        PacketDispatcher:dispather( 10, 26, var_1_string )--分发数据
    end,

    --仙宗仓库删除一个物品
    --接收服务器
    [29] = function ( np )
        local var_1_int64 = np:readInt64( ) --物品的guid
        PacketDispatcher:dispather( 10, 29, var_1_int64 )--分发数据
    end,

    --发送帮派神兽祭坛信息
    --接收服务器
    [31] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --点亮第几个颗灵珠
        local var_2_int = np:readInt( ) --灵珠经验
        local var_3_unsigned_char = np:readByte( ) --神兽等级
        local var_4_int = np:readInt( ) --神兽经验
        local var_5_int = np:readInt( ) --今天抚摸神兽的剩余次数
        local var_6_int = np:readInt( ) --今天献果的剩余次数
        PacketDispatcher:dispather( 10, 31, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_int, var_5_int, var_6_int )--分发数据
    end,

    --发送玩家神兽祭坛信息
    --接收服务器
    [32] = function ( np )
        local var_1_int = np:readInt( ) --今天剩余献果次数
        local var_2_int = np:readInt( ) --可以找回的献果次数
        local var_3_int = np:readInt( ) --今天抚摸次数
        PacketDispatcher:dispather( 10, 32, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --增加一条献果，抚摸事件日志（跟35协议的一条记录结构一样）
    --接收服务器
    [36] = function ( np )
        PacketDispatcher:dispather( 10, 36 )--分发数据
    end,

    --福地之战_返回开启配置
    --接收服务器
    [37] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --本周帮派剩余次数
        local var_2_unsigned_char = np:readByte( ) --本周个人进入剩余次数
        PacketDispatcher:dispather( 10, 37, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --福地之战_通知开启
    --接收服务器
    [39] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --副本难度
        PacketDispatcher:dispather( 10, 39, var_1_unsigned_char )--分发数据
    end,

    --福地之战_通知结果
    --接收服务器
    [43] = function ( np )
        local var_1_int = np:readInt( ) --结果，1成功0失败
        PacketDispatcher:dispather( 10, 43, var_1_int )--分发数据
    end,

    --增加一条仙宗事件记录（跟41协议的一条记录一样）
    --接收服务器
    [42] = function ( np )
        PacketDispatcher:dispather( 10, 42 )--分发数据
    end,

    --发送弹劾动态
    --接收服务器
    [45] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --弹劾期剩余时间
        local var_2_string = np:readString( ) --候选人名称
        PacketDispatcher:dispather( 10, 45, var_1_unsigned_int, var_2_string )--分发数据
    end,

    --下发厢房等级
    --接收服务器
    [50] = function ( np )
        local var_1_int = np:readInt( ) --厢房等级
        PacketDispatcher:dispather( 10, 50, var_1_int )--分发数据
    end,

    --申请帮派仓库物品结果
    --接收服务器
    [51] = function ( np )
        local var_1_int = np:readInt( ) --申请结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 10, 51, var_1_int )--分发数据
    end,

    --下发帮主审核申请仓库物品结果
    --接收服务器
    [53] = function ( np )
        PacketDispatcher:dispather( 10, 53 )--分发数据
    end,


}
