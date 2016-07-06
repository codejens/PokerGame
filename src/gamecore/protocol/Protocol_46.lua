protocol_func_map_client[46] = {
    --获取我的战队信息
    --客户端发送
    [1] = function ( 
                param_1_unsigned_char,  -- 0花1鸡蛋
                param_2_int -- 目标handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 1 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --创建战队
    --客户端发送
    [2] = function ( 
                param_1_string -- 战队名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 2 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --获取可邀请加入战队的玩家列表
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 3 ) 
        NetManager:send_packet( np )
    end,

    --邀请玩家加入战队
    --客户端发送
    [4] = function ( 
                param_1_int,  -- 玩家id
                param_2_string -- 玩家名
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 4 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --邀请加入战队回复
    --客户端发送
    [5] = function ( 
                param_1_int,  -- 战队id
                param_2_unsigned_char,  -- 0表示拒绝，1表示同意
                param_3_int -- 邀请人的玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 5 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --获取可加入的战队列表
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 6 ) 
        NetManager:send_packet( np )
    end,

    --申请加入战队
    --客户端发送
    [7] = function ( 
                param_1_int -- 战队id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 7 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --回复玩家申请加入战队
    --客户端发送
    [8] = function ( 
                param_1_int,  -- 玩家id
                param_2_unsigned_char -- 结果--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 8 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --退出战队
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 9 ) 
        NetManager:send_packet( np )
    end,

    --踢出战队
    --客户端发送
    [10] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 10 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --海选赛报名
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 13 ) 
        NetManager:send_packet( np )
    end,

    --取消匹配
    --客户端发送
    [14] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 14 ) 
        NetManager:send_packet( np )
    end,

    --获取战队排行
    --客户端发送
    [17] = function ( 
                param_1_unsigned_char,  -- 是否本服战队--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 17 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --获取MVP排行榜
    --客户端发送
    [18] = function ( 
                param_1_unsigned_char,  -- 是否本服排行榜--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 18 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --小组赛_参加小组赛
    --客户端发送
    [21] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 21 ) 
        NetManager:send_packet( np )
    end,

    --小组赛_获取战队分组
    --客户端发送
    [24] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 24 ) 
        NetManager:send_packet( np )
    end,

    --小组赛_获取小组排行榜
    --客户端发送
    [25] = function ( 
                param_1_unsigned_char -- 第几组
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 25 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --争霸赛_获取自己战队是否参赛
    --客户端发送
    [27] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 27 ) 
        NetManager:send_packet( np )
    end,

    --争霸赛_参赛
    --客户端发送
    [28] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 28 ) 
        NetManager:send_packet( np )
    end,

    --争霸赛_参观
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 29 ) 
        NetManager:send_packet( np )
    end,

    --争霸赛_获取对战信息
    --客户端发送
    [32] = function ( 
                param_1_unsigned_char -- 1地榜，2天榜
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 32 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --争霸赛_获取我的下注信息
    --客户端发送
    [33] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 33 ) 
        NetManager:send_packet( np )
    end,

    --委任队长
    --客户端发送
    [11] = function ( 
                param_1_int -- 委任为队长的玩家ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 11 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --进入海选赛报名场景
    --客户端发送
    [30] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 30 ) 
        NetManager:send_packet( np )
    end,

    --争霸赛_下注
    --客户端发送
    [34] = function ( 
                param_1_unsigned_char,  -- 位置
                param_2_int -- 猜测赢的战队id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 34 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --争霸赛_送花丢鸡蛋
    --客户端发送
    [35] = function ( 
                param_1_unsigned_char,  -- 0送花1丢鸡蛋
                param_2_int64 -- 目标handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 35 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt64( param_2_int64 )
        NetManager:send_packet( np )
    end,

    --领取海选赛战队排名奖励
    --客户端发送
    [39] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 39 ) 
        NetManager:send_packet( np )
    end,

    --争霸赛_剩余参观票数
    --客户端发送
    [40] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 40 ) 
        NetManager:send_packet( np )
    end,

    --退出海选赛报名场景
    --客户端发送
    [41] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 41 ) 
        NetManager:send_packet( np )
    end,

    --小组赛_退出休息室
    --客户端发送
    [42] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 42 ) 
        NetManager:send_packet( np )
    end,

    --退出海选赛PK场景
    --客户端发送
    [43] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 43 ) 
        NetManager:send_packet( np )
    end,

    --查看本服所有战队
    --客户端发送
    [48] = function ( 
                param_1_int -- 第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 48 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --查看战队信息
    --客户端发送
    [49] = function ( 
                param_1_string,  -- 来自服务器
                param_2_string -- 战队名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 49 ) 
        np:writeString( param_1_string )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --小组赛_退出战斗场景
    --客户端发送
    [50] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 50 ) 
        NetManager:send_packet( np )
    end,

    --获取天榜前四名战队信息
    --客户端发送
    [53] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 53 ) 
        NetManager:send_packet( np )
    end,

    --获取历届天榜金仙
    --客户端发送
    [54] = function ( 
                param_1_int -- 第几届--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 46, 54 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[46] = {
    --创建战队结果
    --接收服务器
    [2] = function ( np )
        local var_1_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 46, 2, var_1_int )--分发数据
    end,

    --有玩家邀请加入战队
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --战队id
        local var_2_int = np:readInt( ) --邀请人的玩家id--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --战队人数
        local var_4_string = np:readString( ) --战队名称
        local var_5_string = np:readString( ) --邀请玩家名称
        local var_6_int = np:readInt( ) --队长等级
        local var_7_int = np:readInt( ) --队长职业
        local var_8_int = np:readInt( ) --队长战斗力
        PacketDispatcher:dispather( 46, 4, var_1_int, var_2_int, var_3_int, var_4_string, var_5_string, var_6_int, var_7_int, var_8_int )--分发数据
    end,

    --有玩家申请加入战队
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --战队战斗力
        local var_3_string = np:readString( ) --玩家名
        local var_4_string = np:readString( ) --战队名称
        PacketDispatcher:dispather( 46, 7, var_1_int, var_2_int, var_3_string, var_4_string )--分发数据
    end,

    --一个玩家加入战队
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --actorid
        local var_2_string = np:readString( ) --玩家名
        local var_3_int = np:readInt( ) --战斗力
        local var_4_int = np:readInt( ) --等级
        local var_5_int = np:readInt( ) --职业
        PacketDispatcher:dispather( 46, 5, var_1_int, var_2_string, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --一个玩家退出战队
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        PacketDispatcher:dispather( 46, 9, var_1_int )--分发数据
    end,

    --设置队长
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --队长id
        PacketDispatcher:dispather( 46, 11, var_1_int )--分发数据
    end,

    --跨服战状态改变
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --阶段--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --该轮结束时间点
        PacketDispatcher:dispather( 46, 12, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --开始匹配
    --接收服务器
    [13] = function ( np )
        PacketDispatcher:dispather( 46, 13 )--分发数据
    end,

    --匹配成功
    --接收服务器
    [14] = function ( np )
        PacketDispatcher:dispather( 46, 14 )--分发数据
    end,

    --PK开始
    --接收服务器
    [15] = function ( np )
        local var_1_int = np:readInt( ) --pk类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 46, 15, var_1_int )--分发数据
    end,

    --对手血量变化
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --最大血量
        local var_3_int = np:readInt( ) --血量--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_char = np:readByte( ) --是否宠物血量--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 46, 20, var_1_int, var_2_int, var_3_int, var_4_unsigned_char )--分发数据
    end,

    --小组赛_对战信息更新
    --接收服务器
    [23] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --场次
        local var_2_unsigned_char = np:readByte( ) --结果0输1赢
        PacketDispatcher:dispather( 46, 23, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --对手玩家上下线
    --接收服务器
    [26] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_unsigned_char = np:readByte( ) --上下线--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 46, 26, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --争霸赛_返回自己战队是否参赛
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0不是，1是
        PacketDispatcher:dispather( 46, 27, var_1_unsigned_char )--分发数据
    end,

    --发送玩家跨服荣誉值
    --接收服务器
    [31] = function ( np )
        local var_1_int = np:readInt( ) --跨服荣誉值
        PacketDispatcher:dispather( 46, 31, var_1_int )--分发数据
    end,

    --争霸赛_下注返回
    --接收服务器
    [34] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1地榜，2天榜
        local var_2_unsigned_char = np:readByte( ) --0失败1成功
        local var_3_unsigned_char = np:readByte( ) --位置
        local var_4_int = np:readInt( ) --猜测赢的战队id
        PacketDispatcher:dispather( 46, 34, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_int )--分发数据
    end,

    --争霸赛_更新送花丢鸡蛋剩余次数
    --接收服务器
    [36] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --送花剩余次数
        local var_2_unsigned_char = np:readByte( ) --丢鸡蛋剩余次数
        PacketDispatcher:dispather( 46, 36, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --争霸赛_送花丢鸡蛋返回
    --接收服务器
    [35] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0花1鸡蛋
        local var_2_int64 = np:readInt64( ) --目标handle
        PacketDispatcher:dispather( 46, 35, var_1_unsigned_char, var_2_int64 )--分发数据
    end,

    --争霸赛_下注状态改变通知
    --接收服务器
    [37] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1地榜2天榜
        local var_2_unsigned_char = np:readByte( ) --1可以下注，0停止下注
        local var_3_unsigned_char = np:readByte( ) --第几轮下注--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 46, 37, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --发送海选赛跨服荣誉奖励（显示图标）
    --接收服务器
    [39] = function ( np )
        local var_1_int = np:readInt( ) --战队排名
        PacketDispatcher:dispather( 46, 39, var_1_int )--分发数据
    end,

    --争霸赛_返回剩余参观票数
    --接收服务器
    [40] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --剩余票数
        PacketDispatcher:dispather( 46, 40, var_1_unsigned_short )--分发数据
    end,

    --争霸赛_当轮比赛全部结束
    --接收服务器
    [44] = function ( np )
        PacketDispatcher:dispather( 46, 44 )--分发数据
    end,

    --取消匹配
    --接收服务器
    [45] = function ( np )
        PacketDispatcher:dispather( 46, 45 )--分发数据
    end,

    --争霸赛_比赛对战结果
    --接收服务器
    [46] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1地榜2天榜
        local var_2_unsigned_char = np:readByte( ) --位置(1 - 31)
        local var_3_int = np:readInt( ) --胜者战队id
        PacketDispatcher:dispather( 46, 46, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --通知被踢出了战队
    --接收服务器
    [51] = function ( np )
        local var_1_string = np:readString( ) --战队名称
        PacketDispatcher:dispather( 46, 51, var_1_string )--分发数据
    end,

    --显示跨服战图标
    --接收服务器
    [52] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --图标类型，1表示显示正式图标，0表示显示预告图标
        local var_2_string = np:readString( ) --预告时间
        PacketDispatcher:dispather( 46, 52, var_1_unsigned_char, var_2_string )--分发数据
    end,


}
