protocol_func_map_client[138] = {
    --领取在线奖励
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 1 ) 
        NetManager:send_packet( np )
    end,

    --获取当前在线送元宝的数据
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 2 ) 
        NetManager:send_packet( np )
    end,

    --换取元宝
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 3 ) 
        NetManager:send_packet( np )
    end,

    --获取这周在线送元宝的数据
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 4 ) 
        NetManager:send_packet( np )
    end,

    --换取这周元宝
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 5 ) 
        NetManager:send_packet( np )
    end,

    --请求连续登陆领奖列表
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 6 ) 
        NetManager:send_packet( np )
    end,

    --(非vip)领连续登陆奖励
    --客户端发送
    [7] = function ( 
                param_1_int -- 领取第几个(从1开始)
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 7 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --(vip)领连续登陆奖励
    --客户端发送
    [8] = function ( 
                param_1_int -- 领取第几个(从1开始)
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 8 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --清楚连续登陆天数
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 9 ) 
        NetManager:send_packet( np )
    end,

    --查询有多少离线经验
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 10 ) 
        NetManager:send_packet( np )
    end,

    --获取离线经验
    --客户端发送
    [11] = function ( 
                param_1_int,  -- 获取的是0.5,1,1.5,2倍经验--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 需要换的小时数--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 11 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求连续登陆当前物品
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 12 ) 
        NetManager:send_packet( np )
    end,

    --领取VIP用户每天登录奖励
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 13 ) 
        NetManager:send_packet( np )
    end,

    --查询是否已经领取VIP登录奖励
    --客户端发送
    [14] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 14 ) 
        NetManager:send_packet( np )
    end,

    --领取封测礼包
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 15 ) 
        NetManager:send_packet( np )
    end,

    --领取充值礼包
    --客户端发送
    [16] = function ( 
                param_1_int -- 领取第几个礼包，从0开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 16 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取黄钻礼包
    --客户端发送
    [17] = function ( 
                param_1_int,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 等级礼包--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 17 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --获取排行榜活动的数据
    --客户端发送
    [19] = function ( 
                param_1_int -- 排行榜id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 19 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取排行榜活动的奖励
    --客户端发送
    [20] = function ( 
                param_1_int -- 排行榜id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 20 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取仙宗开服活动奖励信息
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 22 ) 
        NetManager:send_packet( np )
    end,

    --领取仙宗奖励
    --客户端发送
    [23] = function ( 
                param_1_int -- 1-4，分别代表4个奖励，--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 23 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求套装奖励信息
    --客户端发送
    [24] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 24 ) 
        NetManager:send_packet( np )
    end,

    --领取套装奖励
    --客户端发送
    [25] = function ( 
                param_1_int -- 领的是哪个奖励--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 25 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求渡劫奖励信息
    --客户端发送
    [26] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 26 ) 
        NetManager:send_packet( np )
    end,

    --领取渡劫奖励
    --客户端发送
    [27] = function ( 
                param_1_int -- 领的是哪个奖励--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 27 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --查询用户是否已领取9月活动的礼包
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 29 ) 
        NetManager:send_packet( np )
    end,

    --领取9月月礼包，如果成功的话，会下发协议29
    --客户端发送
    [30] = function ( 
                param_1_string -- cdkey
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 30 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --领取折扣券
    --客户端发送
    [31] = function ( 
                param_1_string -- cdKey
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 31 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --领取万圣节奖励（同领取在线奖励1）
    --客户端发送
    [34] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 34 ) 
        NetManager:send_packet( np )
    end,

    --领取黄钻每日资源位礼包
    --客户端发送
    [36] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 36 ) 
        NetManager:send_packet( np )
    end,

    --领取蓝钻礼包
    --客户端发送
    [37] = function ( 
                param_1_int,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 等级礼包--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 37 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --获取密友系统奖励列表
    --客户端发送
    [38] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 38 ) 
        NetManager:send_packet( np )
    end,

    --给密友赠送物品
    --客户端发送
    [39] = function ( 
                param_1_int,  -- 第几个奖励--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 赠送玩家名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 39 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --领取密友系统奖励
    --客户端发送
    [40] = function ( 
                param_1_int -- 领取第几个--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 40 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取第二轮充值礼包
    --客户端发送
    [41] = function ( 
                param_1_int -- 领取第几个礼包，从0开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 41 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取大厅礼包，如果领取成功，会发消息42，否则不会发
    --客户端发送
    [43] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 43 ) 
        NetManager:send_packet( np )
    end,

    --获取大厅连续登陆信息
    --客户端发送
    [44] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 44 ) 
        NetManager:send_packet( np )
    end,

    --领取大厅连续登陆奖励
    --客户端发送
    [45] = function ( 
                param_1_int -- 第几天的奖励（从1开始）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 45 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取活动礼包
    --客户端发送
    [46] = function ( 
                param_1_string -- cdkey
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 46 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --领取3366充值奖励宠物
    --客户端发送
    [47] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 47 ) 
        NetManager:send_packet( np )
    end,

    --获取邀请好友和分享信息
    --客户端发送
    [48] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 48 ) 
        NetManager:send_packet( np )
    end,

    --邀请好友
    --客户端发送
    [49] = function ( 
                param_1_string -- 被邀请玩家的openid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 49 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --分享
    --客户端发送
    [50] = function ( 
                param_1_int -- 分享了第几个，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 50 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --抽奖
    --客户端发送
    [51] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 51 ) 
        NetManager:send_packet( np )
    end,

    --领取邀请好友和分享奖励
    --客户端发送
    [52] = function ( 
                param_1_int,  -- 类型（0：邀请好友，1：分享）
                param_2_int -- 第几个（从1开始）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 52 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --获取圣诞活动奖励情况
    --客户端发送
    [54] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 54 ) 
        NetManager:send_packet( np )
    end,

    --领取圣诞活动奖励
    --客户端发送
    [55] = function ( 
                param_1_int -- 奖励ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 55 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取QQ会员礼包
    --客户端发送
    [56] = function ( 
                param_1_int,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 等级礼包--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 56 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --领取消费礼包
    --客户端发送
    [57] = function ( 
                param_1_int -- 领取第几个礼包，从0开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 57 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取QQ大厅新登陆礼包
    --客户端发送
    [58] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 58 ) 
        NetManager:send_packet( np )
    end,

    --领取大厅累积登录礼包
    --客户端发送
    [59] = function ( 
                param_1_char -- 领取第几天的奖励--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 59 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --领取QQ大厅新年福利礼包
    --客户端发送
    [60] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 60 ) 
        NetManager:send_packet( np )
    end,

    --领取3366累计登陆礼包
    --客户端发送
    [61] = function ( 
                param_1_char -- 领取第几天的奖励--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 61 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --宝盒抽奖
    --客户端发送
    [63] = function ( 
                param_1_int64,  -- 宝盒物品的GUID
                param_2_unsigned_char -- 是否去掉最后5个价值低的物品--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 63 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --结束宝盒抽奖
    --客户端发送
    [64] = function ( 
                param_1_int64 -- 宝盒物品的GUID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 64 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --获取3366连续登陆信息
    --客户端发送
    [65] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 65 ) 
        NetManager:send_packet( np )
    end,

    --领取3366连续登陆奖励
    --客户端发送
    [66] = function ( 
                param_1_int -- 第几天的奖励（从1开始）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 66 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取蓝钻大厅反馈活动奖励
    --客户端发送
    [68] = function ( 
                param_1_int -- 第几个奖励--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 68 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取金券商城的礼包
    --客户端发送
    [69] = function ( 
                param_1_string -- cdkey
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 69 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --领取大厅dau礼包（临时需求）
    --客户端发送
    [70] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 70 ) 
        NetManager:send_packet( np )
    end,

    --获取感恩节奖励情况
    --客户端发送
    [71] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 71 ) 
        NetManager:send_packet( np )
    end,

    --领取感恩活动奖励
    --客户端发送
    [72] = function ( 
                param_1_int -- 奖励ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 72 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --购买团购礼包
    --客户端发送
    [74] = function ( 
                param_1_int -- 购买类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 74 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --发送手机验证码
    --客户端发送
    [77] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 77 ) 
        NetManager:send_packet( np )
    end,

    --获取宠物成长奖励信息
    --客户端发送
    [78] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 78 ) 
        NetManager:send_packet( np )
    end,

    --领取宠物成长奖励
    --客户端发送
    [79] = function ( 
                param_1_int -- 数字0-4，分别代表5种奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 79 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取宠物悟性奖励信息
    --客户端发送
    [80] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 80 ) 
        NetManager:send_packet( np )
    end,

    --领取宠物悟性成长奖励
    --客户端发送
    [81] = function ( 
                param_1_int -- 数字0-4分别代表5种奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 81 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取装备强化奖励信息
    --客户端发送
    [82] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 82 ) 
        NetManager:send_packet( np )
    end,

    --领取装备强化奖励
    --客户端发送
    [83] = function ( 
                param_1_int -- 数字0-2分别代表3种奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 83 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取宝石等级镶嵌奖励信息
    --客户端发送
    [84] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 84 ) 
        NetManager:send_packet( np )
    end,

    --领取宝石镶嵌奖励
    --客户端发送
    [85] = function ( 
                param_1_int -- 数字0-5分别代表各个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 85 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取开服活动法宝奖励信息
    --客户端发送
    [86] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 86 ) 
        NetManager:send_packet( np )
    end,

    --领取开服活动法宝奖励
    --客户端发送
    [87] = function ( 
                param_1_int -- 数字0-3分别代表各个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 87 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取坐骑奖励信息
    --客户端发送
    [88] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 88 ) 
        NetManager:send_packet( np )
    end,

    --领取坐骑奖励
    --客户端发送
    [89] = function ( 
                param_1_int -- 从1开始，表示奖励编号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 89 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取微端礼包
    --客户端发送
    [90] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 90 ) 
        NetManager:send_packet( np )
    end,

    --玩家点击收藏
    --客户端发送
    [91] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 91 ) 
        NetManager:send_packet( np )
    end,

    --购买翅膀礼包
    --客户端发送
    [92] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 92 ) 
        NetManager:send_packet( np )
    end,

    --购买七日成王礼包
    --客户端发送
    [93] = function ( 
                param_1_unsigned_char,  -- 哪种礼包类型，1A，2B
                param_2_unsigned_char -- 第几天的礼包，1-7,8为免费礼包
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 93 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求领取七天连续登陆奖励
    --客户端发送
    [94] = function ( 
                param_1_int -- 奖励编号1-7，分表代表7个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 94 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取二轮消费礼包
    --客户端发送
    [96] = function ( 
                param_1_int -- 领取第几个消费礼包，从0开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 96 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取新充值活动礼包
    --客户端发送
    [97] = function ( 
                param_1_unsigned_char -- 第几个礼包
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 97 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --超级会员-客户端请求
    --客户端发送
    [98] = function ( 
                param_1_unsigned_char -- OperType，操作类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 98 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求某一好礼活动玩家奖励领取情况
    --客户端发送
    [100] = function ( 
                param_1_unsigned_char -- 1-6分别表示坐骑进阶，坐骑培养，法宝提升，法宝炼魂，宠物成长，宠物悟性
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 100 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取好礼奖励
    --客户端发送
    [101] = function ( 
                param_1_unsigned_char,  -- 好礼奖励类型，1-6
                param_2_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 101 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --充值兑换好礼-查询和领取
    --客户端发送
    [102] = function ( 
                param_1_unsigned_char -- OperType，操作类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 102 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取奖励
    --客户端发送
    [103] = function ( 
                param_1_unsigned_char,  -- 第几天的奖励
                param_2_unsigned_char -- 奖励下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 103 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取开服活动翅膀奖励信息
    --客户端发送
    [104] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 104 ) 
        NetManager:send_packet( np )
    end,

    --领取开服活动翅膀奖励
    --客户端发送
    [105] = function ( 
                param_1_int -- 数字0-2分别代表各个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 105 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --购买神兵利器礼包
    --客户端发送
    [106] = function ( 
                param_1_unsigned_char -- 1购买，2领取
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 106 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --道具兑换道具
    --客户端发送
    [107] = function ( 
                param_1_int,  -- useItemId--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- getItemId--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 107 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --累积登录：领取累积登录奖励
    --客户端发送
    [108] = function ( 
                param_1_unsigned_char -- 奖励的编号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 108 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --新年花恋：领取奖励
    --客户端发送
    [110] = function ( 
                param_1_unsigned_char -- 奖励编号,从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 110 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领取充值返利活动奖励
    --客户端发送
    [111] = function ( 
                param_1_unsigned_char,  -- 领取第几档奖励
                param_2_unsigned_char -- 领取第几个套餐
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 111 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --（废弃）请求领取合服活动提升好礼奖励领取情况
    --客户端发送
    [115] = function ( 
                param_1_unsigned_char -- 奖励类型，1 -7--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 115 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --（废弃）领取合服活动之提升好礼奖励
    --客户端发送
    [116] = function ( 
                param_1_unsigned_char,  -- 好礼奖励类型,1-7--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 奖励编号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 116 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取新年活动-2每天消费奖励
    --客户端发送
    [118] = function ( 
                param_1_unsigned_char -- 奖励的编号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 118 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取秘籍累积充值活动信息
    --客户端发送
    [147] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 147 ) 
        NetManager:send_packet( np )
    end,

    --领取秘籍累积充值活动奖励
    --客户端发送
    [148] = function ( 
                param_1_char -- 奖励项--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 148 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --秘籍累积充值活动请求活动结束
    --客户端发送
    [149] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 149 ) 
        NetManager:send_packet( np )
    end,

    --请求领取新充值活动重复礼包
    --客户端发送
    [150] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 150 ) 
        NetManager:send_packet( np )
    end,

    --请求煮元宵信息
    --客户端发送
    [151] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 151 ) 
        NetManager:send_packet( np )
    end,

    --请求煮元宵
    --客户端发送
    [152] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 152 ) 
        NetManager:send_packet( np )
    end,

    --请求吃元宵
    --客户端发送
    [153] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 153 ) 
        NetManager:send_packet( np )
    end,

    --请求领取元宵节活动每日消费奖励
    --客户端发送
    [155] = function ( 
                param_1_unsigned_char -- 奖励的编号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 155 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领取元宵节累积登录奖励
    --客户端发送
    [156] = function ( 
                param_1_unsigned_char -- 奖励的编号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 156 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求元宵节活动每周魅力排行榜
    --客户端发送
    [157] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 157 ) 
        NetManager:send_packet( np )
    end,

    --请求购买限时物品
    --客户端发送
    [158] = function ( 
                param_1_unsigned_char,  -- 物品的序号，每天购买时从1开始
                param_2_unsigned_char -- 物品个数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 158 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求开启礼包
    --客户端发送
    [160] = function ( 
                param_1_unsigned_int -- 礼包的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 160 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --龙破新版在线奖励-请求在线奖励信息
    --客户端发送
    [161] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 161 ) 
        NetManager:send_packet( np )
    end,

    --龙破新版在线奖励-请求领取在线奖励
    --客户端发送
    [162] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 162 ) 
        NetManager:send_packet( np )
    end,

    --合成升级材料
    --客户端发送
    [164] = function ( 
                param_1_int,  -- 合成的物品id
                param_2_int,  -- 合成的物品数量
                param_3_int,  -- 合成材料列表长度
                param_4_array -- 合成材料列表--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" }, { param_name = param_4_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 164 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        for i = 1, param_3_int do 
            -- protocol manual client 数组
            -- 合成材料列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_4_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --客户端请求冲级礼包信息
    --客户端发送
    [166] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 166 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求领取充值礼包
    --客户端发送
    [167] = function ( 
                param_1_unsigned_char -- 冲级礼包下标，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 167 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --玩家请求兑换礼包信息
    --客户端发送
    [169] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 169 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求领取兑换礼包
    --客户端发送
    [170] = function ( 
                param_1_unsigned_char -- 对应id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 170 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取两小时在线奖励
    --客户端发送
    [172] = function ( 
                param_1_unsigned_char -- 第几个
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 172 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求获取玩家积分
    --客户端发送
    [197] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 197 ) 
        NetManager:send_packet( np )
    end,

    --请求寻人任务信息
    --客户端发送
    [199] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 199 ) 
        NetManager:send_packet( np )
    end,

    --接收寻人任务
    --客户端发送
    [200] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 200 ) 
        NetManager:send_packet( np )
    end,

    --升级寻人任务
    --客户端发送
    [201] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 201 ) 
        NetManager:send_packet( np )
    end,

    --领取寻人任务奖励
    --客户端发送
    [202] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 202 ) 
        NetManager:send_packet( np )
    end,

    --领取3366日常奖励
    --客户端发送
    [120] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 120 ) 
        NetManager:send_packet( np )
    end,

    --请求领取黄钻特权活动称号
    --客户端发送
    [203] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 138, 203 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[138] = {
    --返回当前在线送元宝的数据
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --一天能换取元宝的总时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --单位时间能换取的元宝数--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_int = np:readUInt( ) --已换取元宝的时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_int = np:readUInt( ) --累计未换取元宝的时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_unsigned_int = np:readUInt( ) --每次领取元宝所需时间间隔数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 2, var_1_unsigned_int, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_int )--分发数据
    end,

    --返回换取元宝的结果
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --换取元宝的单位时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 3, var_1_unsigned_char )--分发数据
    end,

    --返回这周在线送元宝的数据
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --累计未换取元宝的时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --可以领取的金额
        PacketDispatcher:dispather( 138, 4, var_1_unsigned_int, var_2_unsigned_int )--分发数据
    end,

    --下发离线经验
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --离线小时数
        local var_2_unsigned_int = np:readUInt( ) --离线经验
        local var_3_unsigned_int = np:readUInt( ) --离线0.5倍经验
        local var_4_unsigned_int = np:readUInt( ) --离线1倍经验金钱单位
        local var_5_unsigned_int = np:readUInt( ) --离线1.5倍经验金钱单位
        local var_6_unsigned_int = np:readUInt( ) --离线2倍经验金钱单位
        PacketDispatcher:dispather( 138, 10, var_1_unsigned_int, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_int, var_6_unsigned_int )--分发数据
    end,

    --返回是否已经领取VIP用户登录奖励
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --返回结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 14, var_1_int )--分发数据
    end,

    --领取封测礼包，协议同在线奖励一样
    --接收服务器
    [15] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几次
        local var_2_int = np:readInt( ) --到下次的剩余时间
        local var_3_int = np:readInt( ) --剩余次数
        PacketDispatcher:dispather( 138, 15, var_1_unsigned_char, var_2_int, var_3_int )--分发数据
    end,

    --充值礼包的领取情况和剩余时间
    --接收服务器
    [16] = function ( np )
        local var_1_int = np:readInt( ) --最大可领取什么级别的礼包--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --领取礼包的情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --活动的剩余时间
        PacketDispatcher:dispather( 138, 16, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --下发黄钻礼包的领取情况，如果从没领取过或者不是黄钻，则不会下发
    --接收服务器
    [17] = function ( np )
        local var_1_int = np:readInt( ) --每一位代表一个礼包的领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --是否从本页面开通过黄钻宠物
        local var_3_int = np:readInt( ) --是否从本页面开通黄钻武器
        PacketDispatcher:dispather( 138, 17, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --排行榜活动的相关数据
    --接收服务器
    [18] = function ( np )
        local var_1_int = np:readInt( ) --距离开服7天22时剩余的时间，0表示已超过
        local var_2_int = np:readInt( ) --距离开服10日0时剩余时间，如果是0表示已超过
        local var_3_int = np:readInt( ) --是否有奖励可以领取，--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --一个int表示，共32位，0表示排行榜1（战力）的领取情况，1表示已领取，类推
        PacketDispatcher:dispather( 138, 18, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --领取排行榜活动的奖励的情况
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --一个int表示，共32位，0表示排行榜1（战力）的领取情况，1表示已领取，类推
        PacketDispatcher:dispather( 138, 20, var_1_int )--分发数据
    end,

    --仙宗开服活动奖励信息
    --接收服务器
    [22] = function ( np )
        local var_1_int = np:readInt( ) --仙宗是否有奖励--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 22, var_1_int )--分发数据
    end,

    --返回套装奖励信息
    --接收服务器
    [24] = function ( np )
        local var_1_int = np:readInt( ) --3个位分别标记3种奖励--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --3个位纪录哪个奖励是否领了--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 24, var_1_int, var_2_int )--分发数据
    end,

    --返回渡劫奖励信息
    --接收服务器
    [26] = function ( np )
        local var_1_int = np:readInt( ) --3个位分别标记3种奖励--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --3个位纪录哪个奖励是否领了--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 26, var_1_int, var_2_int )--分发数据
    end,

    --是否有开服奖励可领取（仙宗、套装、渡劫）
    --接收服务器
    [28] = function ( np )
        local var_1_int = np:readInt( ) --3个位表示是否可领取,没奖励不会发这条消息--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 28, var_1_int )--分发数据
    end,

    --是否已领取9月礼包
    --接收服务器
    [29] = function ( np )
        local var_1_int = np:readInt( ) --1:已领，0,：未领
        local var_2_int = np:readInt( ) --距离显示icon剩余时间，超过时间0，否则就是剩余时间
        local var_3_int = np:readInt( ) --距离不显示icon剩余时间，超过时间0，否则就是剩余时间
        local var_4_int = np:readInt( ) --距离可领取礼包的剩余时间，超过就是0
        PacketDispatcher:dispather( 138, 29, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --领取折扣券结果
    --接收服务器
    [31] = function ( np )
        local var_1_int = np:readInt( ) --返回结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 31, var_1_int )--分发数据
    end,

    --通知万圣节活动状态
    --接收服务器
    [32] = function ( np )
        local var_1_int = np:readInt( ) --活动状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 32, var_1_int )--分发数据
    end,

    --万圣节奖励信息（同在线奖励）
    --接收服务器
    [33] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --将领取第几次奖励
        local var_2_unsigned_int = np:readUInt( ) --到下次奖励的剩余时间
        local var_3_int = np:readInt( ) --剩余领奖次数
        PacketDispatcher:dispather( 138, 33, var_1_unsigned_char, var_2_unsigned_int, var_3_int )--分发数据
    end,

    --弹出黄钻每日资源位窗口
    --接收服务器
    [35] = function ( np )
        PacketDispatcher:dispather( 138, 35 )--分发数据
    end,

    --成功领取黄钻每日资源位礼包（成功领取才会收到这信息）
    --接收服务器
    [36] = function ( np )
        PacketDispatcher:dispather( 138, 36 )--分发数据
    end,

    --下发蓝钻礼包的领取情况，如果从没领取过或者不是蓝钻，则不会下发
    --接收服务器
    [37] = function ( np )
        local var_1_int = np:readInt( ) --每一位代表一个礼包的领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --是否从本页面开通过蓝钻宠物
        local var_3_int = np:readInt( ) --是否从本页面开通过蓝钻武器
        PacketDispatcher:dispather( 138, 37, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --给密友赠送物品结果
    --接收服务器
    [39] = function ( np )
        local var_1_int = np:readInt( ) --第几个奖励
        local var_2_int = np:readInt( ) --赠送结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 39, var_1_int, var_2_int )--分发数据
    end,

    --领取密友系统奖励结果
    --接收服务器
    [40] = function ( np )
        local var_1_int = np:readInt( ) --第几个奖励
        local var_2_int = np:readInt( ) --领取结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 40, var_1_int, var_2_int )--分发数据
    end,

    --第二轮充值礼包领取情况及剩余时间
    --接收服务器
    [41] = function ( np )
        local var_1_int = np:readInt( ) --最大可领取什么级别的礼包--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --领取礼包的情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --活动的剩余时间
        local var_4_int = np:readInt( ) --第二轮充值总充值元宝数
        PacketDispatcher:dispather( 138, 41, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --显示密友系统图标
    --接收服务器
    [42] = function ( np )
        local var_1_int = np:readInt( ) --开服第几天
        local var_2_int = np:readInt( ) --活动剩余时间（秒）
        local var_3_unsigned_char = np:readByte( ) --是否还有未领取或未赠送的奖励--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 42, var_1_int, var_2_int, var_3_unsigned_char )--分发数据
    end,

    --能否QQ领取大厅礼包
    --接收服务器
    [43] = function ( np )
        local var_1_int = np:readInt( ) --1能领，0不能领
        PacketDispatcher:dispather( 138, 43, var_1_int )--分发数据
    end,

    --返回领取大厅连续登陆奖励结果
    --接收服务器
    [45] = function ( np )
        local var_1_int = np:readInt( ) --第几天的奖励（从1开始）
        local var_2_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 45, var_1_int, var_2_int )--分发数据
    end,

    --领取活动礼包结果
    --接收服务器
    [46] = function ( np )
        local var_1_int = np:readInt( ) --返回结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 46, var_1_int )--分发数据
    end,

    --下发3366充值奖励宠物的状态
    --接收服务器
    [47] = function ( np )
        local var_1_char = np:readChar( ) --状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 47, var_1_char )--分发数据
    end,

    --抽奖结果
    --接收服务器
    [51] = function ( np )
        local var_1_int = np:readInt( ) --抽奖结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 51, var_1_int )--分发数据
    end,

    --领取奖励结果
    --接收服务器
    [52] = function ( np )
        local var_1_int = np:readInt( ) --类型，同领奖
        local var_2_int = np:readInt( ) --第几个
        local var_3_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --总抽奖次数
        PacketDispatcher:dispather( 138, 52, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --1个邀请好友任务完成
    --接收服务器
    [53] = function ( np )
        local var_1_int = np:readInt( ) --第几个任务（从1开始）
        PacketDispatcher:dispather( 138, 53, var_1_int )--分发数据
    end,

    --领取圣诞活动奖励
    --接收服务器
    [55] = function ( np )
        local var_1_int = np:readInt( ) --领取圣诞奖励的ID
        local var_2_int = np:readInt( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 55, var_1_int, var_2_int )--分发数据
    end,

    --下发QQ会员礼包领取情况
    --接收服务器
    [56] = function ( np )
        local var_1_int = np:readInt( ) --每一位代表每一种礼包的领取情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --是否在本页面领取过QQ会员宠物
        local var_3_int = np:readInt( ) --是否在本页面领取过QQ会员武器
        PacketDispatcher:dispather( 138, 56, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --消费礼包的领取情况和剩余时间
    --接收服务器
    [57] = function ( np )
        local var_1_int = np:readInt( ) --最大可领取什么级别的礼包--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --领取礼包的状况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --活动的剩余时间
        local var_4_int = np:readInt( ) --元宝的消费数
        PacketDispatcher:dispather( 138, 57, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --QQ大厅新登陆礼包信息
    --接收服务器
    [58] = function ( np )
        local var_1_char = np:readChar( ) --状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 58, var_1_char )--分发数据
    end,

    --下发大厅累积登陆礼包信息
    --接收服务器
    [59] = function ( np )
        local var_1_char = np:readChar( ) --标签页状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --当前已累积登录天数
        local var_3_int = np:readInt( ) --领取状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 59, var_1_char, var_2_char, var_3_int )--分发数据
    end,

    --下发QQ大厅新年福利礼包信息
    --接收服务器
    [60] = function ( np )
        local var_1_char = np:readChar( ) --图标状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --要过多少秒后可领取
        PacketDispatcher:dispather( 138, 60, var_1_char, var_2_int )--分发数据
    end,

    --下发大厅累积登陆礼包信息
    --接收服务器
    [61] = function ( np )
        local var_1_char = np:readChar( ) --标签页状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --当前已累积登录天数
        local var_3_int = np:readInt( ) --领取状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 61, var_1_char, var_2_char, var_3_int )--分发数据
    end,

    --宝盒抽奖结果
    --接收服务器
    [63] = function ( np )
        local var_1_int64 = np:readInt64( ) --宝盒物品的GUID
        local var_2_int = np:readInt( ) --抽奖的结果
        PacketDispatcher:dispather( 138, 63, var_1_int64, var_2_int )--分发数据
    end,

    --返回领取3366连续登陆奖励结果
    --接收服务器
    [66] = function ( np )
        local var_1_int = np:readInt( ) --第几天的奖励（从1开始）
        local var_2_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 66, var_1_int, var_2_int )--分发数据
    end,

    --发送蓝钻大厅反馈活动状态
    --接收服务器
    [67] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --普通用户奖励领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --蓝钻用户奖励领取状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 67, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --通知客户端图标（领取大厅dau礼包（临时需求））
    --接收服务器
    [70] = function ( np )
        local var_1_int = np:readInt( ) --图标是否显示--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 70, var_1_int )--分发数据
    end,

    --领取感恩活动奖励
    --接收服务器
    [72] = function ( np )
        local var_1_int = np:readInt( ) --领取圣诞奖励的ID
        local var_2_int = np:readInt( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 72, var_1_int, var_2_int )--分发数据
    end,

    --下发金卷商品购买状态
    --接收服务器
    [73] = function ( np )
        local var_1_int = np:readInt( ) --10金卷礼包领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --30金卷礼包购买状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --490金卷礼包购买状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --150RMB金卷礼包购买状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 73, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --QQ空间和QQ大厅团购礼包
    --接收服务器
    [74] = function ( np )
        local var_1_int = np:readInt( ) --当前团购人数
        local var_2_int = np:readInt( ) --当天购买第一个团购礼包次数
        local var_3_int = np:readInt( ) --当天购买第二个团购礼包次数
        local var_4_int = np:readInt( ) --玩家当前团购积分
        PacketDispatcher:dispather( 138, 74, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --团购礼包人数广播协议
    --接收服务器
    [75] = function ( np )
        local var_1_int = np:readInt( ) --团购人数
        PacketDispatcher:dispather( 138, 75, var_1_int )--分发数据
    end,

    --空间愚人节图标开关
    --接收服务器
    [76] = function ( np )
        local var_1_int = np:readInt( ) --0:关 1:开
        PacketDispatcher:dispather( 138, 76, var_1_int )--分发数据
    end,

    --手机验证图标显示控制
    --接收服务器
    [77] = function ( np )
        local var_1_int = np:readInt( ) --0关 1开
        local var_2_int = np:readInt( ) --礼包id--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 77, var_1_int, var_2_int )--分发数据
    end,

    --宠物成长奖励信息
    --接收服务器
    [78] = function ( np )
        local var_1_int = np:readInt( ) --0-4位分别代表获得奖励情况
        local var_2_int = np:readInt( ) --0-4位分别代表奖励领取情况
        PacketDispatcher:dispather( 138, 78, var_1_int, var_2_int )--分发数据
    end,

    --宠物悟性奖励信息
    --接收服务器
    [80] = function ( np )
        local var_1_int = np:readInt( ) --0-4位分别代表5种奖励
        local var_2_int = np:readInt( ) --0-4位分别代表每个奖励领取情况
        PacketDispatcher:dispather( 138, 80, var_1_int, var_2_int )--分发数据
    end,

    --发送装备强化奖励信息
    --接收服务器
    [82] = function ( np )
        local var_1_int = np:readInt( ) --0-2为分别代表已经取得的奖励情况
        local var_2_int = np:readInt( ) --0-2位分别代表奖励领取情况
        PacketDispatcher:dispather( 138, 82, var_1_int, var_2_int )--分发数据
    end,

    --下发宝石镶嵌奖励信息
    --接收服务器
    [84] = function ( np )
        local var_1_int = np:readInt( ) --0-5位分别代表奖励获得信息
        local var_2_int = np:readInt( ) --0-5位分别代表奖励的领取
        PacketDispatcher:dispather( 138, 84, var_1_int, var_2_int )--分发数据
    end,

    --下发法宝奖励信息
    --接收服务器
    [86] = function ( np )
        local var_1_int = np:readInt( ) --0-3位分别代表是否获取奖励
        local var_2_int = np:readInt( ) --0-3位分别代表是否领取奖励
        PacketDispatcher:dispather( 138, 86, var_1_int, var_2_int )--分发数据
    end,

    --下发坐骑奖励信息
    --接收服务器
    [88] = function ( np )
        local var_1_int = np:readInt( ) --第0-2位表示每个奖励达成情况，0：未达成奖励，1：达成了奖励
        local var_2_int = np:readInt( ) --第0-2位分别表示各个奖励的领取情况，0：未领取；1：已经领取
        local var_3_int = np:readInt( ) --当前已经进阶的次数
        PacketDispatcher:dispather( 138, 88, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --微端礼包领取结果
    --接收服务器
    [90] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1成功，0失败
        PacketDispatcher:dispather( 138, 90, var_1_unsigned_char )--分发数据
    end,

    --玩家收藏礼包领取状态
    --接收服务器
    [91] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0未收藏，1已领取
        PacketDispatcher:dispather( 138, 91, var_1_unsigned_char )--分发数据
    end,

    --翅膀礼包领取情况
    --接收服务器
    [92] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0表示未领取，1表示已领取，此协议没发的话客户端不显示图标，发1的话客户端关闭图标
        PacketDispatcher:dispather( 138, 92, var_1_unsigned_char )--分发数据
    end,

    --是否显示七天连续登陆图标
    --接收服务器
    [95] = function ( np )
        local var_1_int = np:readInt( ) --0:不显示， 1：显示
        PacketDispatcher:dispather( 138, 95, var_1_int )--分发数据
    end,

    --领取二轮消费礼包的情况和剩余时间
    --接收服务器
    [96] = function ( np )
        local var_1_int = np:readInt( ) --最大可领取什么类别的礼包--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --领取礼包的状况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --活动剩余时间
        local var_4_int = np:readInt( ) --消费元宝数
        PacketDispatcher:dispather( 138, 96, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --超级会员-服务端返回结果
    --接收服务器
    [98] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --OperType，操作类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --recharge--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_string = np:readString( ) --字符串数据--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 98, var_1_unsigned_char, var_2_int, var_3_string )--分发数据
    end,

    --下发提升好礼活动状态
    --接收服务器
    [99] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --坐骑好礼状态，1开启，0结束
        local var_2_int = np:readInt( ) --坐骑好礼开始时间
        local var_3_int = np:readInt( ) --坐骑好礼结束时间
        local var_4_int = np:readInt( ) --坐骑好礼剩余时间
        local var_5_unsigned_char = np:readByte( ) --法宝好礼状态，1开启，0结束
        local var_6_int = np:readInt( ) --法宝好礼开始时间
        local var_7_int = np:readInt( ) --法宝好礼结束时间
        local var_8_int = np:readInt( ) --法宝好礼剩余时间
        local var_9_unsigned_char = np:readByte( ) --宠物好礼状态，1开启，0结束
        local var_10_int = np:readInt( ) --宠物好礼开始时间
        local var_11_int = np:readInt( ) --宠物好礼结束时间
        local var_12_int = np:readInt( ) --宠物好礼剩余时间
        PacketDispatcher:dispather( 138, 99, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_unsigned_char, var_6_int, var_7_int, var_8_int, var_9_unsigned_char, var_10_int, var_11_int, var_12_int )--分发数据
    end,

    --充值兑换好礼-服务端返回结果
    --接收服务器
    [102] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --OperType，操作类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --EnergyData，能量值数据--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 102, var_1_unsigned_char, var_2_unsigned_int )--分发数据
    end,

    --下发开服活动翅膀奖励信息
    --接收服务器
    [104] = function ( np )
        local var_1_int = np:readInt( ) --是否达成了某个奖励，0-2位分别表示各个奖励，0：未达成，1：已达成
        local var_2_int = np:readInt( ) --是否领取了某个奖励，0-2位分别表示各个奖励，0：未获得，1：已经获得
        PacketDispatcher:dispather( 138, 104, var_1_int, var_2_int )--分发数据
    end,

    --下发神兵利器礼包购买情况
    --接收服务器
    [106] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否第一次显示，1是0否
        local var_2_unsigned_char = np:readByte( ) --0表示未领取，1表示已购买，2表示已领取，此协议没发的话客户端不显示图标，发2的话客户端关闭图标
        PacketDispatcher:dispather( 138, 106, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --新年活动：整点时间到达
    --接收服务器
    [109] = function ( np )
        PacketDispatcher:dispather( 138, 109 )--分发数据
    end,

    --下发腊八节活动状态
    --接收服务器
    [112] = function ( np )
        local var_1_int = np:readInt( ) --通知活动剩余时间 如果为0表示活动未开启
        PacketDispatcher:dispather( 138, 112, var_1_int )--分发数据
    end,

    --（废弃）请求领取合服首充奖励
    --接收服务器
    [113] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --奖励的编号，1-7表示领取七天的礼包，0表示领取充值后立即可以得到的礼包
        PacketDispatcher:dispather( 138, 113, var_1_unsigned_char )--分发数据
    end,

    --（废弃）下发合服活动之提升好礼活动状态
    --接收服务器
    [114] = function ( np )
        local var_1_int = np:readInt( ) --活动的剩余时间，如果为0表示活动没有开启
        local var_2_int = np:readInt( ) --活动开始时间
        local var_3_int = np:readInt( ) --活动结束时间
        PacketDispatcher:dispather( 138, 114, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --下发新年活动-2状态
    --接收服务器
    [117] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0表示未开启
        local var_2_unsigned_char = np:readByte( ) --1：表示采用老服配置，2：表示采用新服配置
        PacketDispatcher:dispather( 138, 117, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发新年活动-2每天消息奖励信息
    --接收服务器
    [118] = function ( np )
        local var_1_int = np:readInt( ) --玩家当天消费了多少元宝
        local var_2_char = np:readChar( ) --奖励的领取状态，每一位表示一个奖励，0表示未领取，1表示领取了
        PacketDispatcher:dispather( 138, 118, var_1_int, var_2_char )--分发数据
    end,

    --下发合服活动配置读取信息
    --接收服务器
    [119] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几次合服，从1开始
        local var_2_unsigned_char = np:readByte( ) --1：表示新服，2：表示老服， 这个字段备用
        PacketDispatcher:dispather( 138, 119, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --下发秘籍累积充值活动图标显示状态
    --接收服务器
    [146] = function ( np )
        local var_1_char = np:readChar( ) --图标显示状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 138, 146, var_1_char )--分发数据
    end,

    --下发新充值活动重复礼包奖励信息
    --接收服务器
    [150] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --已经领取了几个礼包
        local var_2_unsigned_char = np:readByte( ) --当前是否可以领取礼包， 0不能领取， 1可以领取
        PacketDispatcher:dispather( 138, 150, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --下发煮元宵信息
    --接收服务器
    [151] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前已经煮了的元宵个数
        local var_2_unsigned_char = np:readByte( ) --当天已经吃元宵的次数
        local var_3_unsigned_char = np:readByte( ) --是否播放煮元宵动画，1：表示煮元宵，0：表示非煮元宵
        local var_4_unsigned_char = np:readByte( ) --0：显示煮元宵，1：显示加火
        PacketDispatcher:dispather( 138, 151, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --下发情人节活动状态
    --接收服务器
    [154] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0表示未开启
        local var_2_unsigned_char = np:readByte( ) --1表示老服配置，2表示新服配置
        local var_3_unsigned_char = np:readByte( ) --活动的第几天，从1开始
        PacketDispatcher:dispather( 138, 154, var_1_int, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --下发元宵节活动每天消费奖励信息
    --接收服务器
    [155] = function ( np )
        local var_1_int = np:readInt( ) --玩家已经消费了多少元宝
        local var_2_unsigned_char = np:readByte( ) --奖励的状态，每一个分别表示奖励状态，0：表示没有领取，1表示已经领取
        PacketDispatcher:dispather( 138, 155, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --服务端下发玩家累计登陆天数（通用）
    --接收服务器
    [171] = function ( np )
        local var_1_int = np:readInt( ) --玩家累计登陆天数
        PacketDispatcher:dispather( 138, 171, var_1_int )--分发数据
    end,

    --两小时在线奖励领取情况
    --接收服务器
    [172] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否已领取翅膀奖励
        local var_2_unsigned_char = np:readByte( ) --是否已领取法宝奖励
        PacketDispatcher:dispather( 138, 172, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --下发消费积分活动的信息
    --接收服务器
    [198] = function ( np )
        local var_1_int = np:readInt( ) --活动的剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 138, 198, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --请求兑换物品
    --接收服务器
    [198] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --兑换第几档物品，编号从1开始
        PacketDispatcher:dispather( 138, 198, var_1_unsigned_char )--分发数据
    end,

    --下发玩家消费积分
    --接收服务器
    [197] = function ( np )
        local var_1_int = np:readInt( ) --玩家当前有多少积分
        PacketDispatcher:dispather( 138, 197, var_1_int )--分发数据
    end,

    --下发寻人任务信息
    --接收服务器
    [199] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当天已经做了多少次任务
        local var_2_unsigned_char = np:readByte( ) --当前任务的档次, 从1开始， 如果当前没有任务，则为0
        local var_3_unsigned_int = np:readUInt( ) --当前任务剩余的时间，单位秒，如果当前没有任务，则为0
        local var_4_unsigned_char = np:readByte( ) --当前任务是否完成，0表示没有完成， 1表示完成
        PacketDispatcher:dispather( 138, 199, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_int, var_4_unsigned_char )--分发数据
    end,

    --下发寻人任务活动状态
    --接收服务器
    [200] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --活动剩余时间，0表示活动已经结束
        local var_2_unsigned_char = np:readByte( ) --新老服配置， 1：表示老服， 2表示新服
        PacketDispatcher:dispather( 138, 200, var_1_unsigned_int, var_2_unsigned_char )--分发数据
    end,

    --下发玩家3366等级
    --接收服务器
    [120] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --等级
        local var_2_unsigned_char = np:readByte( ) --是否领取了奖励，1是0否
        PacketDispatcher:dispather( 138, 120, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --下发黄钻特权活动状态
    --接收服务器
    [203] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1表示开，0表示关（领取称号后下发0）
        PacketDispatcher:dispather( 138, 203, var_1_unsigned_char )--分发数据
    end,


}
