protocol_func_map_client[172] = {
    --双阵型_请求进入场景
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 2 ) 
        NetManager:send_packet( np )
    end,

    --帮主发起召集令
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 7 ) 
        NetManager:send_packet( np )
    end,

    --进入帮派战副本
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 8 ) 
        NetManager:send_packet( np )
    end,

    --退出帮派战副本
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 9 ) 
        NetManager:send_packet( np )
    end,

    --请求铜钱副本排行榜信息
    --客户端发送
    [10] = function ( 
                param_1_unsigned_char -- 请求第几页的排行榜信息
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 10 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --五子棋-申请进入铜钱副本
    --客户端发送
    [11] = function ( 
                param_1_int -- 副本id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 11 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --宠物副本点击兑换宠物请求
    --客户端发送
    [16] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 16 ) 
        NetManager:send_packet( np )
    end,

    --宠物副本兑换宠物
    --客户端发送
    [17] = function ( 
                param_1_int -- 兑换的宠物id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 17 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --双阵型_追踪旗帜
    --客户端发送
    [24] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 24 ) 
        NetManager:send_packet( np )
    end,

    --幽冥魔域-客户端请求进入副本
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 1 ) 
        NetManager:send_packet( np )
    end,

    --幽灵魔域-客户端请求排行榜
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 3 ) 
        NetManager:send_packet( np )
    end,

    --进入诸天战神
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 29 ) 
        NetManager:send_packet( np )
    end,

    --请求上届诸天战神排行榜
    --客户端发送
    [30] = function ( 
                param_1_unsigned_char,  -- 阶段
                param_2_unsigned_char,  -- 排行榜类型，1总击杀榜，2连续击杀榜
                param_3_unsigned_char -- 第几页
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 30 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领取奖励
    --客户端发送
    [31] = function ( 
                param_1_unsigned_char,  -- 第几阶段,1,2,3
                param_2_unsigned_char -- 奖励类型，1总击杀，2连续击杀
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 31 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求第一名战神数据
    --客户端发送
    [32] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 32 ) 
        NetManager:send_packet( np )
    end,

    --获取今天重置封印守护副本的剩余次数以及可扫荡的关数
    --客户端发送
    [33] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 33 ) 
        NetManager:send_packet( np )
    end,

    --玩家请求进入封印守护副本
    --客户端发送
    [34] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 34 ) 
        NetManager:send_packet( np )
    end,

    --玩家请求退出封印守护副本
    --客户端发送
    [35] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 35 ) 
        NetManager:send_packet( np )
    end,

    --玩家请求重置封印守护副本关数
    --客户端发送
    [36] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 36 ) 
        NetManager:send_packet( np )
    end,

    --玩家请求自动扫荡封印守护已通关数
    --客户端发送
    [37] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 37 ) 
        NetManager:send_packet( np )
    end,

    --玩家请求领取宝箱
    --客户端发送
    [39] = function ( 
                param_1_unsigned_char -- 宝箱序号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 39 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领地占领情况（面板的）
    --客户端发送
    [41] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 41 ) 
        NetManager:send_packet( np )
    end,

    --领取奖励
    --客户端发送
    [42] = function ( 
                param_1_unsigned_char -- 领地下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 42 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --自动寻路到某个玩家
    --客户端发送
    [43] = function ( 
                param_1_int -- 玩家ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 43 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --玩家请求领取奖励
    --客户端发送
    [40] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 40 ) 
        NetManager:send_packet( np )
    end,

    --请求进入大闹天宫副本
    --客户端发送
    [46] = function ( 
                param_1_unsigned_char,  -- 第几个等级的副本，下标从1开始
                param_2_unsigned_char -- 难度，0普通，1英雄
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 46 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求大闹天宫副本情况
    --客户端发送
    [45] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 45 ) 
        NetManager:send_packet( np )
    end,

    --请求屠龙副本信息
    --客户端发送
    [47] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 47 ) 
        NetManager:send_packet( np )
    end,

    --进入屠龙副本
    --客户端发送
    [48] = function ( 
                param_1_unsigned_char -- 第几个副本
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 48 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --扫荡相关操作
    --客户端发送
    [49] = function ( 
                param_1_unsigned_char -- 操作类型，1开始扫荡，2请求奖励信息，3领取奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 49 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取通关奖励
    --客户端发送
    [50] = function ( 
                param_1_unsigned_char -- 第几个副本
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 50 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --进入真仙之路活动
    --客户端发送
    [53] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 53 ) 
        NetManager:send_packet( np )
    end,

    --复活
    --客户端发送
    [55] = function ( 
                param_1_unsigned_char -- 复活类型，1归元复活，2涅槃复活
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 55 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求仙路战报
    --客户端发送
    [56] = function ( 
                param_1_unsigned_char -- 请求第几页
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 56 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取仙路奖励
    --客户端发送
    [57] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 57 ) 
        NetManager:send_packet( np )
    end,

    --帮主发起召集令
    --客户端发送
    [59] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 59 ) 
        NetManager:send_packet( np )
    end,

    --进入帮派战副本
    --客户端发送
    [60] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 60 ) 
        NetManager:send_packet( np )
    end,

    --退出帮派战副本
    --客户端发送
    [61] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 61 ) 
        NetManager:send_packet( np )
    end,

    --请求进入夫妻副本
    --客户端发送
    [70] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 70 ) 
        NetManager:send_packet( np )
    end,

    --回应进入夫妻副本请求
    --客户端发送
    [71] = function ( 
                param_1_unsigned_char -- 是否同意，0：不同意，1：同意
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 71 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求夫妻副本界面信息
    --客户端发送
    [72] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 72 ) 
        NetManager:send_packet( np )
    end,

    --请求夫妻副本排行榜信息
    --客户端发送
    [73] = function ( 
                param_1_unsigned_char -- 第几页
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 73 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领取夫妻副本排行奖励
    --客户端发送
    [74] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 74 ) 
        NetManager:send_packet( np )
    end,

    --取消进入夫妻副本请求
    --客户端发送
    [69] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 69 ) 
        NetManager:send_packet( np )
    end,

    --请求进入精英副本
    --客户端发送
    [76] = function ( 
                param_1_int,  -- 副本id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 副本难度--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 76 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求精英副本界面信息
    --客户端发送
    [77] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 77 ) 
        NetManager:send_packet( np )
    end,

    --查询弑神值
    --客户端发送
    [78] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 78 ) 
        NetManager:send_packet( np )
    end,

    --领取精英副本通关奖励
    --客户端发送
    [79] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 172, 79 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[172] = {
    --双阵型_下发活动状态
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 172, 1, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --双阵型_下发进入场景结果和玩家基本信息
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --进入结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --排名
        local var_3_unsigned_char = np:readByte( ) --阵营
        local var_4_int = np:readInt( ) --积分
        local var_5_int = np:readInt( ) --击杀数
        PacketDispatcher:dispather( 172, 2, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_int, var_5_int )--分发数据
    end,

    --双阵型_刷新玩家积分信息
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --排名
        local var_2_int = np:readInt( ) --积分
        local var_3_int = np:readInt( ) --击杀数
        PacketDispatcher:dispather( 172, 3, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --双阵型_刷新双阵营信息
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --阵营1当前血量
        local var_2_int = np:readInt( ) --阵营2当前血量
        local var_3_unsigned_char = np:readByte( ) --执旗阵营
        local var_4_unsigned_short = np:readWord( ) --自动交旗剩余时间，秒
        local var_5_int64 = np:readInt64( ) --夺旗者的handle
        PacketDispatcher:dispather( 172, 5, var_1_int, var_2_int, var_3_unsigned_char, var_4_unsigned_short, var_5_int64 )--分发数据
    end,

    --帮派战活动弹窗
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否帮主邀请，1是0否
        local var_2_string = np:readString( ) --帮主名
        PacketDispatcher:dispather( 172, 7, var_1_unsigned_char, var_2_string )--分发数据
    end,

    --下发皇旗占有状态
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --占有皇旗的帮派ID，为0时表示没人占有
        local var_2_string = np:readString( ) --占有皇旗的帮派名字
        local var_3_string = np:readString( ) --占有皇旗的帮主名字
        local var_4_int = np:readInt( ) --已占有时间
        PacketDispatcher:dispather( 172, 8, var_1_int, var_2_string, var_3_string, var_4_int )--分发数据
    end,

    --下发将军旗占有状态
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --占有将军旗1的帮派ID，为0时表示没人占有
        local var_2_string = np:readString( ) --占有将军旗1的帮派名字
        local var_3_string = np:readString( ) --占有将军旗1的帮主名字
        local var_4_unsigned_char = np:readByte( ) --是否已抢夺成功，1是0否
        local var_5_int = np:readInt( ) --已占有时间
        local var_6_int = np:readInt( ) --占有将军旗2的帮派ID，为0时表示没人占有
        local var_7_string = np:readString( ) --占有将军旗2的帮派名字
        local var_8_string = np:readString( ) --占有将军旗2的帮主名字
        local var_9_unsigned_char = np:readByte( ) --是否已抢夺成功，1是0否
        local var_10_int = np:readInt( ) --已占有时间
        PacketDispatcher:dispather( 172, 9, var_1_int, var_2_string, var_3_string, var_4_unsigned_char, var_5_int, var_6_int, var_7_string, var_8_string, var_9_unsigned_char, var_10_int )--分发数据
    end,

    --下发自己的排名
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --自己的排名
        local var_2_int = np:readInt( ) --自己的击杀数
        PacketDispatcher:dispather( 172, 11, var_1_int, var_2_int )--分发数据
    end,

    --向客户端下发连斩效果播放请求
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --发送的数字代表几连斩
        local var_2_unsigned_char = np:readByte( ) --chuanNum，玩家本次同时消除了多少串
        PacketDispatcher:dispather( 172, 13, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --返回进入铜钱副本的状态
    --接收服务器
    [14] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0:进入副本失败  1：成功进入副本
        PacketDispatcher:dispather( 172, 14, var_1_unsigned_char )--分发数据
    end,

    --下发帮派战剩余游戏时间
    --接收服务器
    [15] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 172, 15, var_1_int )--分发数据
    end,

    --返回碎片信息
    --接收服务器
    [16] = function ( np )
        local var_1_int = np:readInt( ) --碎片数量
        PacketDispatcher:dispather( 172, 16, var_1_int )--分发数据
    end,

    --返回兑换宠物结果
    --接收服务器
    [17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1成功0失败
        local var_2_int = np:readInt( ) --玩家拥有的碎片数量
        PacketDispatcher:dispather( 172, 17, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --双阵型_下发旗帜当前位置
    --接收服务器
    [18] = function ( np )
        local var_1_int = np:readInt( ) --位置x
        local var_2_int = np:readInt( ) --位置y
        local var_3_unsigned_char = np:readByte( ) --旗帜状态：0初始状态，1被玩家拿，2死亡掉落，3阵营交旗区
        PacketDispatcher:dispather( 172, 18, var_1_int, var_2_int, var_3_unsigned_char )--分发数据
    end,

    --下发怪物开始限时掉落计时
    --接收服务器
    [19] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --怪物的ID
        local var_2_unsigned_short = np:readWord( ) --剩余时间，单位秒,0关闭界面
        PacketDispatcher:dispather( 172, 19, var_1_unsigned_int, var_2_unsigned_short )--分发数据
    end,

    --下发杀怪获得经验信息
    --接收服务器
    [20] = function ( np )
        local var_1_int64 = np:readInt64( ) --杀死怪物的handle
        local var_2_unsigned_int = np:readUInt( ) --杀死怪物获得的经验
        PacketDispatcher:dispather( 172, 20, var_1_int64, var_2_unsigned_int )--分发数据
    end,

    --宠物副本-下发杀怪信息
    --接收服务器
    [22] = function ( np )
        local var_1_int64 = np:readInt64( ) --杀死怪物的handle
        local var_2_int = np:readInt( ) --玩家拥有的碎片数量
        local var_3_int = np:readInt( ) --杀死怪物获得的碎片数量
        PacketDispatcher:dispather( 172, 22, var_1_int64, var_2_int, var_3_int )--分发数据
    end,

    --50级副本_下发条件奖励达成情况
    --接收服务器
    [23] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --条件的索引
        local var_2_unsigned_char = np:readByte( ) --是否达成 0初始值 1成功 2失败
        PacketDispatcher:dispather( 172, 23, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --五子棋副本-在特定怪物身上飘仙币
    --接收服务器
    [25] = function ( np )
        local var_1_int64 = np:readInt64( ) --清除的棋子怪物handle
        local var_2_unsigned_int64 = np:readUint64( ) --获得的仙币数量
        PacketDispatcher:dispather( 172, 25, var_1_int64, var_2_unsigned_int64 )--分发数据
    end,

    --下发每分钟经验统计
    --接收服务器
    [27] = function ( np )
        local var_1_int = np:readInt( ) --获得的经验
        PacketDispatcher:dispather( 172, 27, var_1_int )--分发数据
    end,

    --幽冥魔域-Boss释放技能
    --接收服务器
    [28] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index，boss索引从1开始
        PacketDispatcher:dispather( 172, 28, var_1_unsigned_char )--分发数据
    end,

    --下发我的诸天战神排行榜统计信息
    --接收服务器
    [30] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前第几阶段1,2,3,
        local var_2_unsigned_char = np:readByte( ) --击杀数排行，0为未上榜
        local var_3_int = np:readInt( ) --击杀数
        local var_4_unsigned_char = np:readByte( ) --连续击杀数排行，0为未上榜
        local var_5_int = np:readInt( ) --连续击杀数
        local var_6_int = np:readInt( ) --当前连续击杀数
        PacketDispatcher:dispather( 172, 30, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_int, var_6_int )--分发数据
    end,

    --下发第一名战神数据
    --接收服务器
    [32] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_string = np:readString( ) --玩家名
        local var_3_int = np:readInt( ) --击杀数
        local var_4_int = np:readInt( ) --连续击杀数
        local var_5_unsigned_int64 = np:readUint64( ) --输出伤害数
        local var_6_unsigned_int64 = np:readUint64( ) --承受伤害数
        local var_7_int = np:readInt( ) --人物模型ID
        local var_8_int = np:readInt( ) --人物武器ID
        local var_9_int = np:readInt( ) --人物翅膀ID
        local var_10_int = np:readInt( ) --人物龙魂ID
        PacketDispatcher:dispather( 172, 32, var_1_int, var_2_string, var_3_int, var_4_int, var_5_unsigned_int64, var_6_unsigned_int64, var_7_int, var_8_int, var_9_int, var_10_int )--分发数据
    end,

    --下发今天重置封印守护副本的剩余次数以及可扫荡的关数
    --接收服务器
    [33] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --可重置次数
        local var_2_unsigned_char = np:readByte( ) --可扫荡的关数
        PacketDispatcher:dispather( 172, 33, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --玩家请求进入封印守护副本结果返回
    --接收服务器
    [34] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0成功 1失败
        PacketDispatcher:dispather( 172, 34, var_1_unsigned_char )--分发数据
    end,

    --玩家请求退出封印守护副本结果返回
    --接收服务器
    [35] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0成功 1失败
        local var_2_unsigned_char = np:readByte( ) --0弹出通关窗口 1弹出扫荡窗口
        local var_3_unsigned_short = np:readWord( ) --在打副本或者扫荡的过程中通关到的关卡数
        local var_4_unsigned_int = np:readUInt( ) --在打副本或者扫荡的过程中通关得到的经验
        local var_5_unsigned_int = np:readUInt( ) --在打副本或者扫荡的过程中通关得到的绑定元宝
        PacketDispatcher:dispather( 172, 35, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_int, var_5_unsigned_int )--分发数据
    end,

    --玩家请求重置封印守护副本关数结果返回
    --接收服务器
    [36] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0成功 1失败
        PacketDispatcher:dispather( 172, 36, var_1_unsigned_char )--分发数据
    end,

    --玩家请求自动扫荡封印守护已通关数结果返回
    --接收服务器
    [37] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0成功 1失败
        PacketDispatcher:dispather( 172, 37, var_1_unsigned_char )--分发数据
    end,

    --玩家请求领取宝箱结果返回
    --接收服务器
    [39] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家欲领取的宝箱序号
        local var_2_unsigned_char = np:readByte( ) --0成功 1失败
        PacketDispatcher:dispather( 172, 39, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --下发活动统计信息
    --接收服务器
    [42] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_int = np:readInt( ) --持有人ID
        local var_3_string = np:readString( ) --持有人名字
        local var_4_string = np:readString( ) --持有人帮派名
        local var_5_int = np:readInt( ) --已持有时间
        local var_6_unsigned_char = np:readByte( ) --旗子x坐标，旗子不在发送0
        local var_7_unsigned_char = np:readByte( ) --旗子y坐标，旗子不在发送0
        PacketDispatcher:dispather( 172, 42, var_1_int, var_2_int, var_3_string, var_4_string, var_5_int, var_6_unsigned_char, var_7_unsigned_char )--分发数据
    end,

    --下发个人统计信息
    --接收服务器
    [43] = function ( np )
        local var_1_int = np:readInt( ) --击杀人数
        local var_2_int = np:readInt( ) --获得帮贡数
        local var_3_int = np:readInt( ) --获得经验数
        local var_4_int = np:readInt( ) --在此场景已停留时间
        PacketDispatcher:dispather( 172, 43, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --关闭统计面板
    --接收服务器
    [44] = function ( np )
        PacketDispatcher:dispather( 172, 44 )--分发数据
    end,

    --弹出结算界面
    --接收服务器
    [45] = function ( np )
        local var_1_string = np:readString( ) --场景名
        local var_2_int = np:readInt( ) --帮派ID
        local var_3_string = np:readString( ) --帮派名
        PacketDispatcher:dispather( 172, 45, var_1_string, var_2_int, var_3_string )--分发数据
    end,

    --玩家请求领取奖励结果返回
    --接收服务器
    [40] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0成功 1失败
        PacketDispatcher:dispather( 172, 40, var_1_unsigned_char )--分发数据
    end,

    --屠龙副本通关
    --接收服务器
    [48] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个副本
        local var_2_unsigned_char = np:readByte( ) --通关奖励类型，1首通，2日通，0无奖励
        PacketDispatcher:dispather( 172, 48, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --封印守护副本通知客户端弹出通关失败，没奖励可领取窗口
    --接收服务器
    [51] = function ( np )
        PacketDispatcher:dispather( 172, 51 )--分发数据
    end,

    --服务器下发悬赏令数量
    --接收服务器
    [52] = function ( np )
        local var_1_int = np:readInt( ) --悬赏令数量
        PacketDispatcher:dispather( 172, 52, var_1_int )--分发数据
    end,

    --下发真仙之路个人统计面板
    --接收服务器
    [53] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前层数
        local var_2_unsigned_char = np:readByte( ) --到过的最高层数
        local var_3_int = np:readInt( ) --当前积分
        local var_4_int = np:readInt( ) --累积击杀
        local var_5_unsigned_char = np:readByte( ) --本层目标击杀数
        local var_6_unsigned_char = np:readByte( ) --本层当前击杀数
        PacketDispatcher:dispather( 172, 53, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_int, var_5_unsigned_char, var_6_unsigned_char )--分发数据
    end,

    --弹出重生框
    --接收服务器
    [55] = function ( np )
        local var_1_string = np:readString( ) --击杀者名字
        local var_2_unsigned_char = np:readByte( ) --免费复活次数
        PacketDispatcher:dispather( 172, 55, var_1_string, var_2_unsigned_char )--分发数据
    end,

    --关闭领取界面
    --接收服务器
    [57] = function ( np )
        PacketDispatcher:dispather( 172, 57 )--分发数据
    end,

    --下发无双战神当前阶段剩余时间
    --接收服务器
    [58] = function ( np )
        local var_1_int = np:readInt( ) --当前阶段剩余时间
        PacketDispatcher:dispather( 172, 58, var_1_int )--分发数据
    end,

    --帮派战活动弹窗
    --接收服务器
    [59] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否帮主邀请，1是0否
        local var_2_string = np:readString( ) --帮主名
        PacketDispatcher:dispather( 172, 59, var_1_unsigned_char, var_2_string )--分发数据
    end,

    --下发皇旗占有状态
    --接收服务器
    [60] = function ( np )
        local var_1_int = np:readInt( ) --占有皇旗的帮派ID，为0时表示没人占有
        local var_2_string = np:readString( ) --占有皇旗的帮派名字
        local var_3_string = np:readString( ) --占有皇旗的帮主名字
        local var_4_int = np:readInt( ) --已占有时间
        PacketDispatcher:dispather( 172, 60, var_1_int, var_2_string, var_3_string, var_4_int )--分发数据
    end,

    --下发将军旗占有状态
    --接收服务器
    [61] = function ( np )
        local var_1_int = np:readInt( ) --占有将军旗1的帮派ID，为0时表示没人占有
        local var_2_string = np:readString( ) --占有将军旗1的帮派名字
        local var_3_string = np:readString( ) --占有将军旗1的帮主名字
        local var_4_unsigned_char = np:readByte( ) --是否已抢夺成功，1是0否
        local var_5_int = np:readInt( ) --已占有时间
        local var_6_int = np:readInt( ) --占有将军旗2的帮派ID，为0时表示没人占有
        local var_7_string = np:readString( ) --占有将军旗2的帮派名字
        local var_8_string = np:readString( ) --占有将军旗2的帮主名字
        local var_9_unsigned_char = np:readByte( ) --是否已抢夺成功，1是0否
        local var_10_int = np:readInt( ) --已占有时间
        PacketDispatcher:dispather( 172, 61, var_1_int, var_2_string, var_3_string, var_4_unsigned_char, var_5_int, var_6_int, var_7_string, var_8_string, var_9_unsigned_char, var_10_int )--分发数据
    end,

    --下发自己的排名
    --接收服务器
    [63] = function ( np )
        local var_1_int = np:readInt( ) --自己的排名
        local var_2_int = np:readInt( ) --自己的击杀数
        PacketDispatcher:dispather( 172, 63, var_1_int, var_2_int )--分发数据
    end,

    --下发帮派战剩余游戏时间
    --接收服务器
    [64] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 172, 64, var_1_int )--分发数据
    end,

    --发送进入夫妻副本请求
    --接收服务器
    [71] = function ( np )
        local var_1_int = np:readInt( ) --发起方的actorid
        PacketDispatcher:dispather( 172, 71, var_1_int )--分发数据
    end,

    --下发夫妻副本界面信息
    --接收服务器
    [72] = function ( np )
        local var_1_int = np:readInt( ) --当前排名
        local var_2_unsigned_char = np:readByte( ) --奖励状态：0：不可领取，1：可领，2：已领取
        local var_3_unsigned_char = np:readByte( ) --副本剩余次数
        PacketDispatcher:dispather( 172, 72, var_1_int, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --通知另一方取消夫妻副本请求
    --接收服务器
    [69] = function ( np )
        PacketDispatcher:dispather( 172, 69 )--分发数据
    end,

    --夫妻副本结算界面
    --接收服务器
    [75] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --通关层数
        local var_2_int = np:readInt( ) --通关时间
        PacketDispatcher:dispather( 172, 75, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --下发弑神值
    --接收服务器
    [78] = function ( np )
        local var_1_int = np:readInt( ) --弑神值
        PacketDispatcher:dispather( 172, 78, var_1_int )--分发数据
    end,

    --下发成功进入的精英副本结果
    --接收服务器
    [76] = function ( np )
        local var_1_int = np:readInt( ) --成功进入的副本id
        local var_2_unsigned_char = np:readByte( ) --副本难度
        PacketDispatcher:dispather( 172, 76, var_1_int, var_2_unsigned_char )--分发数据
    end,


}
