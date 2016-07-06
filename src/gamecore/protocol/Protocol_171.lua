protocol_func_map_client[171] = {
    --请求百服翻牌活动初始数据
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 1 ) 
        NetManager:send_packet( np )
    end,

    --客户端发送点击开始请求
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 3 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求翻牌
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char -- 牌的下标，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 4 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --百服转盘活动获取玩家活动数据
    --客户端发送
    [6] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 6 ) 
        NetManager:send_packet( np )
    end,

    --玩家点击开始抽奖
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 7 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求返利信息
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 8 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求百服超值返还信息
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 10 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求领取百服超值返还礼包
    --客户端发送
    [11] = function ( 
                param_1_unsigned_char -- index--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 11 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求领取全服或个人消费礼包
    --客户端发送
    [14] = function ( 
                param_1_unsigned_char,  -- 操作，1：领取全服消费礼包，2：领取个人消费礼包
                param_2_unsigned_char -- 领取礼包的index
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 14 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求神秘商店信息
    --客户端发送
    [16] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 16 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求购买或者兑换物品
    --客户端发送
    [17] = function ( 
                param_1_unsigned_char,  -- 操作类型，1购买，2兑换
                param_2_unsigned_char -- index--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 17 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求刷新物品
    --客户端发送
    [18] = function ( 
                param_1_unsigned_char -- 刷新次数，1：一次，12：12次
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 18 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求领取全服或者个人充值礼包
    --客户端发送
    [21] = function ( 
                param_1_unsigned_char,  -- 操作，1：领取全服消费礼包，2：领取个人消费礼包
                param_2_unsigned_char -- 领取礼包的index
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 21 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求玩家年货购买情况
    --客户端发送
    [27] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 27 ) 
        NetManager:send_packet( np )
    end,

    --请求购买年货
    --客户端发送
    [28] = function ( 
                param_1_int,  -- 道具ID
                param_2_unsigned_char -- 购买数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 28 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求在线抽奖活动数据
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 29 ) 
        NetManager:send_packet( np )
    end,

    --玩家抽奖
    --客户端发送
    [30] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 30 ) 
        NetManager:send_packet( np )
    end,

    --请求捕鱼活动数据
    --客户端发送
    [31] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 31 ) 
        NetManager:send_packet( np )
    end,

    --玩家点击捕鱼
    --客户端发送
    [32] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 32 ) 
        NetManager:send_packet( np )
    end,

    --吉祥如意.连续登录-领取礼包
    --客户端发送
    [33] = function ( 
                param_1_unsigned_char -- index--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 33 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --吉祥如意.每日优惠-玩家购买物品
    --客户端发送
    [34] = function ( 
                param_1_unsigned_char,  -- type, 购买类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int,  -- itemId, 购买物品的Id--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- count, 购买物品的数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 34 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --吉祥如意.消费送豪礼-客户端
    --客户端发送
    [35] = function ( 
                param_1_unsigned_char -- index, 礼包索引，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 35 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --吉祥如意.欢乐大转盘-玩家开始抽奖
    --客户端发送
    [36] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 36 ) 
        NetManager:send_packet( np )
    end,

    --吉祥如意.限量抢购-客户端购买礼包
    --客户端发送
    [37] = function ( 
                param_1_unsigned_char -- index, 购买的礼包索引,从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 37 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --神马都有.客户端请求领取每日消费礼包
    --客户端发送
    [41] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 41 ) 
        NetManager:send_packet( np )
    end,

    --神马都有.客户端请求领取充值礼包
    --客户端发送
    [43] = function ( 
                param_1_unsigned_char,  -- 档次
                param_2_unsigned_char -- 第几个套餐
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 43 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --神马都有.客户端请求领取马上有钱礼包
    --客户端发送
    [45] = function ( 
                param_1_unsigned_char -- 第几个礼包
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 45 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --神马都有.客户端操作
    --客户端发送
    [47] = function ( 
                param_1_unsigned_char,  -- 1表示领养，2表示浇灌，3表示收获
                param_2_unsigned_char -- 领养时用到，传宝宝下标，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 47 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --神马都有.客户端请求马上有钱礼包信息
    --客户端发送
    [46] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 46 ) 
        NetManager:send_packet( np )
    end,

    --新年BOSS--进入场景协议
    --客户端发送
    [48] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 48 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求回归特礼信息
    --客户端发送
    [53] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 53 ) 
        NetManager:send_packet( np )
    end,

    --玩家请求领取回归特礼礼包
    --客户端发送
    [54] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 54 ) 
        NetManager:send_packet( np )
    end,

    --极限名人堂-查看击杀BOSS和帮派战排行信息
    --客户端发送
    [56] = function ( 
                param_1_unsigned_char,  -- id, 第几天的名人堂事件
                param_2_unsigned_char -- job, 职业--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 56 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --成长礼包-领取奖励
    --客户端发送
    [57] = function ( 
                param_1_int64,  -- itemGuid, 物品的GUID
                param_2_unsigned_char -- count, 物品数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 57 ) 
        np:writeInt64( param_1_int64 )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --活动大厅-请求帮派战信息
    --客户端发送
    [58] = function ( 
                param_1_unsigned_char -- operType，0:请求界面信息，1:进入帮派战
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 58 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --趣味答题_客户端提交答案（废弃）
    --客户端发送
    [62] = function ( 
                param_1_unsigned_char,  -- 第几个题目
                param_2_unsigned_char -- 玩家选择的答案下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 62 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --趣味答题_客户端使用互动技能
    --客户端发送
    [64] = function ( 
                param_1_unsigned_int,  -- 目标的角色ID
                param_2_unsigned_char -- 技能的序号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 64 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --趣味答题_进入答题副本
    --客户端发送
    [67] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 67 ) 
        NetManager:send_packet( np )
    end,

    --渡劫_领取破章第一人奖励
    --客户端发送
    [68] = function ( 
                param_1_unsigned_int -- 第几章，编号从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 68 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --渡劫_副本申请加血
    --客户端发送
    [69] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 69 ) 
        NetManager:send_packet( np )
    end,

    --渡劫_一键通关
    --客户端发送
    [70] = function ( 
                param_1_int -- 玩家点击扫荡按钮时所在页面的章节数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 70 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --渡劫_领取一键通关奖励
    --客户端发送
    [71] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 71 ) 
        NetManager:send_packet( np )
    end,

    --全民富翁-客户端打开界面请求数据
    --客户端发送
    [73] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 73 ) 
        NetManager:send_packet( np )
    end,

    --全民富翁-客户端摇骰子
    --客户端发送
    [74] = function ( 
                param_1_unsigned_char,  -- numRound，第几波
                param_2_unsigned_char -- numTurn，第几轮
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 74 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --购买全套紫装礼包
    --客户端发送
    [84] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 84 ) 
        NetManager:send_packet( np )
    end,

    --请求世界boss伤害奖励信息
    --客户端发送
    [87] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 87 ) 
        NetManager:send_packet( np )
    end,

    --领取世界boss伤害奖励
    --客户端发送
    [88] = function ( 
                param_1_unsigned_char -- 第几个奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 88 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --微信礼包-客户端请求领取微信礼包
    --客户端发送
    [91] = function ( 
                param_1_string -- 微信验证码
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 91 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --客户端请求预充值返利信息
    --客户端发送
    [93] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 93 ) 
        NetManager:send_packet( np )
    end,

    --每日首冲_领取
    --客户端发送
    [94] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 94 ) 
        NetManager:send_packet( np )
    end,

    --请求神兵限时优惠活动数据
    --客户端发送
    [119] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 119 ) 
        NetManager:send_packet( np )
    end,

    --领取奖励
    --客户端发送
    [120] = function ( 
                param_1_unsigned_char -- 第几个奖励，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 120 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求神兵累积充值活动数据
    --客户端发送
    [130] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 130 ) 
        NetManager:send_packet( np )
    end,

    --领取神兵累积充值奖励
    --客户端发送
    [131] = function ( 
                param_1_unsigned_char -- 第几个奖励，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 131 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --资源找回-客户端找回某个奖励信息
    --客户端发送
    [132] = function ( 
                param_1_unsigned_char,  -- resIndex，资源类型
                param_2_int,  -- id，
                param_3_unsigned_char -- type，0:免费找回，1:元宝找回
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 132 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --资源找回-一键找回
    --客户端发送
    [133] = function ( 
                param_1_unsigned_char -- type，0:一键找回，1:至尊找回
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 133 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --膜拜城主-打开活动界面
    --客户端发送
    [134] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 134 ) 
        NetManager:send_packet( np )
    end,

    --膜拜城主-膜拜或者鄙视城主
    --客户端发送
    [135] = function ( 
                param_1_unsigned_char,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 星级
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 135 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --膜拜城主-领取膜拜城主奖励
    --客户端发送
    [137] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 137 ) 
        NetManager:send_packet( np )
    end,

    --膜拜城主-刷新经验倍数
    --客户端发送
    [138] = function ( 
                param_1_int -- 刷新品质--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 138 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求全服抽奖活动信息（打开界面时申请）
    --客户端发送
    [139] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 139 ) 
        NetManager:send_packet( np )
    end,

    --申请抽奖
    --客户端发送
    [140] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 140 ) 
        NetManager:send_packet( np )
    end,

    --装备淬炼-玩家进行淬炼
    --客户端发送
    [141] = function ( 
                param_1_unsigned_char,  -- type，类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int64,  -- 道具guid，标识当前使用的道具
                param_3_int64 -- 装备guid，标识要操作的装备
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int64, lua_type = "number" }, { param_name = param_3_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 141 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt64( param_2_int64 )
        np:writeInt64( param_3_int64 )
        NetManager:send_packet( np )
    end,

    --幻境修炼-进入挂机场景
    --客户端发送
    [142] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 142 ) 
        NetManager:send_packet( np )
    end,

    --幻境修炼-退出挂机场景
    --客户端发送
    [143] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 143 ) 
        NetManager:send_packet( np )
    end,

    --预体验-开启预体验
    --客户端发送
    [144] = function ( 
                param_1_unsigned_char -- yutiyanType--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 144 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求当前可打的副本是否有剩余次数或重置次数
    --客户端发送
    [147] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 147 ) 
        NetManager:send_packet( np )
    end,

    --请求封印守护、屠龙圣殿的可领奖次数
    --客户端发送
    [148] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 148 ) 
        NetManager:send_packet( np )
    end,

    --请求彩蛋信息
    --客户端发送
    [149] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 149 ) 
        NetManager:send_packet( np )
    end,

    --刷新彩蛋
    --客户端发送
    [150] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 150 ) 
        NetManager:send_packet( np )
    end,

    --砸蛋
    --客户端发送
    [151] = function ( 
                param_1_unsigned_char -- 第几个蛋 0 全部砸开
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 151 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取限时活动信息
    --客户端发送
    [152] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 152 ) 
        NetManager:send_packet( np )
    end,

    --刷新道具
    --客户端发送
    [153] = function ( 
                param_1_unsigned_char -- 是否自动刷新--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 153 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --购买物品
    --客户端发送
    [154] = function ( 
                param_1_int,  -- id
                param_2_int -- 数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 154 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --每日登录领取奖励
    --客户端发送
    [155] = function ( 
                param_1_unsigned_char -- index下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 155 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --捕鱼达人请求数据 倒计时为 0时也要请求
    --客户端发送
    [159] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 159 ) 
        NetManager:send_packet( np )
    end,

    --捕鱼
    --客户端发送
    [160] = function ( 
                param_1_unsigned_char -- 下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 160 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --捕鱼刷新，要元宝
    --客户端发送
    [161] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 161 ) 
        NetManager:send_packet( np )
    end,

    --领取360加速球礼包
    --客户端发送
    [162] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 162 ) 
        NetManager:send_packet( np )
    end,

    --游戏大厅领取奖励
    --客户端发送
    [163] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 163 ) 
        NetManager:send_packet( np )
    end,

    --DIY称号活动领取奖励
    --客户端发送
    [174] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 174 ) 
        NetManager:send_packet( np )
    end,

    --安全卫士活动领奖
    --客户端发送
    [175] = function ( 
                param_1_unsigned_char -- index下标从一开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 175 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取全服抽奖活动信息
    --客户端发送
    [176] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 176 ) 
        NetManager:send_packet( np )
    end,

    --全服抽奖参加抽奖
    --客户端发送
    [177] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 177 ) 
        NetManager:send_packet( np )
    end,

    --请求翻牌
    --客户端发送
    [179] = function ( 
                param_1_unsigned_char -- 翻牌，用0表示一键翻牌，1-9表示牌的index
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 179 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求洗牌
    --客户端发送
    [178] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 178 ) 
        NetManager:send_packet( np )
    end,

    --限时抢购，参与抢购
    --客户端发送
    [180] = function ( 
                param_1_unsigned_char -- 开的下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 180 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --限时抢购查看上一轮
    --客户端发送
    [181] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 181 ) 
        NetManager:send_packet( np )
    end,

    --领取挂机有礼活动礼包
    --客户端发送
    [184] = function ( 
                param_1_unsigned_char -- 礼包index，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 184 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取挑战副本活动礼包
    --客户端发送
    [185] = function ( 
                param_1_unsigned_char -- 礼包index，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 185 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --投资计划领奖
    --客户端发送
    [188] = function ( 
                param_1_unsigned_char,  -- 第几个投资
                param_2_unsigned_char -- 第几天
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 188 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --投资计划投资
    --客户端发送
    [186] = function ( 
                param_1_unsigned_char -- 投资id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 186 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求下发幸运翻牌数据
    --客户端发送
    [187] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 187 ) 
        NetManager:send_packet( np )
    end,

    --请求下发挂机有礼活动数据
    --客户端发送
    [183] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 183 ) 
        NetManager:send_packet( np )
    end,

    --客户端领奖
    --客户端发送
    [182] = function ( 
                param_1_unsigned_char -- 领取下标 1 2 3
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 182 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端下发改名请求
    --客户端发送
    [190] = function ( 
                param_1_string,  -- 玩家更改的新的名字
                param_2_unsigned_char -- 是否播报的标识--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 190 ) 
        np:writeString( param_1_string )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --每日消费活动礼包信息查询
    --客户端发送
    [191] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 191 ) 
        NetManager:send_packet( np )
    end,

    --请求领取每日消费礼包
    --客户端发送
    [192] = function ( 
                param_1_unsigned_char -- 领取第几天的礼包， 从1开始编号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 192 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求补领每日消费礼包
    --客户端发送
    [193] = function ( 
                param_1_unsigned_char -- 请求补领第几天的礼包， 从1开始编号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 193 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端下发360等级
    --客户端发送
    [194] = function ( 
                param_1_int -- 360等级
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 194 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求抢购全民乐购礼包
    --客户端发送
    [195] = function ( 
                param_1_unsigned_char -- 第几个礼包， 从1开始编号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 195 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求全民乐购活动信息
    --客户端发送
    [196] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 196 ) 
        NetManager:send_packet( np )
    end,

    --请求九字真言活动信息，打开界面时发送
    --客户端发送
    [197] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 197 ) 
        NetManager:send_packet( np )
    end,

    --九字真言翻开格子
    --客户端发送
    [198] = function ( 
                param_1_unsigned_char,  -- 是否一键翻开，1是0否
                param_2_unsigned_char,  -- 第几行
                param_3_unsigned_char -- 第几个
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 198 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --九字真言领取奖励
    --客户端发送
    [199] = function ( 
                param_1_unsigned_char -- 0领取奖励  1自动刷新 2手动刷新
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 199 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求星语心愿活动数据
    --客户端发送
    [202] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 202 ) 
        NetManager:send_packet( np )
    end,

    --星语心愿许愿
    --客户端发送
    [203] = function ( 
                param_1_unsigned_char -- 许愿方式 1表示元宝，2表示仙币，3表示道具
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 203 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --星语心愿领奖
    --客户端发送
    [204] = function ( 
                param_1_unsigned_char -- 礼包的index，1-n
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 204 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求全民采购玩家购买信息
    --客户端发送
    [205] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 205 ) 
        NetManager:send_packet( np )
    end,

    --请求该买全民采购礼包
    --客户端发送
    [206] = function ( 
                param_1_unsigned_char -- 第几个礼包
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 206 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求幸运转盘活动数据
    --客户端发送
    [207] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 207 ) 
        NetManager:send_packet( np )
    end,

    --玩家请求抽奖
    --客户端发送
    [208] = function ( 
                param_1_unsigned_char -- 抽奖次数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 208 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求刷新
    --客户端发送
    [209] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 209 ) 
        NetManager:send_packet( np )
    end,

    --请求存钱或者取钱
    --客户端发送
    [211] = function ( 
                param_1_unsigned_char,  -- 0：表示存钱， 1：表示取钱
                param_2_unsigned_char -- 存第几档
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 211 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求玩家的存钱信息
    --客户端发送
    [212] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 212 ) 
        NetManager:send_packet( np )
    end,

    --神马都有.客户端操作
    --客户端发送
    [213] = function ( 
                param_1_unsigned_char,  -- 1表示领养，2表示浇灌，3表示收获
                param_2_unsigned_char -- 领养时用到，传宝宝下标，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 213 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --活动大厅-请求连服城主战信息
    --客户端发送
    [215] = function ( 
                param_1_unsigned_char -- operType，0:请求界面信息，1:进入帮派战
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 215 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求至尊特惠活动数据
    --客户端发送
    [216] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 216 ) 
        NetManager:send_packet( np )
    end,

    --领取至尊特惠活动礼包
    --客户端发送
    [217] = function ( 
                param_1_unsigned_char -- 礼包的下标1-4，4表示至尊
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 217 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求领取返利或礼包
    --客户端发送
    [218] = function ( 
                param_1_unsigned_char,  -- 操作类型：1领取返利，2领取礼包 
                param_2_unsigned_char -- 若操作类型为2，填礼包idnex，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 218 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求玩家数据
    --客户端发送
    [219] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 219 ) 
        NetManager:send_packet( np )
    end,

    --领取每日返利奖品
    --客户端发送
    [220] = function ( 
                param_1_unsigned_char -- 奖励所在档次的下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 220 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求玩家鉴宝活动数据
    --客户端发送
    [222] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 222 ) 
        NetManager:send_packet( np )
    end,

    --玩家点击了鉴宝
    --客户端发送
    [223] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 223 ) 
        NetManager:send_packet( np )
    end,

    --玩家点击鉴宝活动更换奖品按钮
    --客户端发送
    [224] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 224 ) 
        NetManager:send_packet( np )
    end,

    --玩家点击鉴宝活动的领取奖品按钮
    --客户端发送
    [225] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 225 ) 
        NetManager:send_packet( np )
    end,

    --新版全服消费请求
    --客户端发送
    [226] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 226 ) 
        NetManager:send_packet( np )
    end,

    --领奖
    --客户端发送
    [227] = function ( 
                param_1_unsigned_char,  -- 档次
                param_2_unsigned_char -- 下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 227 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求活动在线奖励
    --客户端发送
    [228] = function ( 
                param_1_unsigned_char -- 礼包下标，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 228 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求连服充值排行活动数据
    --客户端发送
    [231] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 231 ) 
        NetManager:send_packet( np )
    end,

    --领取连服充值排行全民奖励
    --客户端发送
    [232] = function ( 
                param_1_unsigned_char -- 序号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 232 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求众志成城活动数据
    --客户端发送
    [233] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 233 ) 
        NetManager:send_packet( np )
    end,

    --众志成城请求修城
    --客户端发送
    [234] = function ( 
                param_1_unsigned_char -- 1～3，1为劳力
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 234 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --众志成城请求刷新
    --客户端发送
    [235] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 235 ) 
        NetManager:send_packet( np )
    end,

    --请求消掉冷却时间
    --客户端发送
    [236] = function ( 
                param_1_unsigned_char -- 消掉冷却时间（1-3）,修复类型的index
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 236 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --限时抢购2,请求购买限时物品
    --客户端发送
    [238] = function ( 
                param_1_unsigned_char,  -- 物品的序号，每天购买时从1开始
                param_2_unsigned_char -- 物品个数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 238 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求单笔充值奖励信息
    --客户端发送
    [239] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 239 ) 
        NetManager:send_packet( np )
    end,

    --请求领取单笔充值奖励
    --客户端发送
    [240] = function ( 
                param_1_unsigned_char -- 奖励的编号，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 240 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取恭贺新年礼包奖励
    --客户端发送
    [243] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 243 ) 
        NetManager:send_packet( np )
    end,

    --请求周年鲜花榜
    --客户端发送
    [244] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 244 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求领取消费回馈礼包
    --客户端发送
    [245] = function ( 
                param_1_unsigned_char -- 第几个礼包
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 245 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求鉴宝或领奖
    --客户端发送
    [95] = function ( 
                param_1_unsigned_char -- 1：鉴宝，2领取奖励奖
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 95 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求换牌
    --客户端发送
    [96] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 96 ) 
        NetManager:send_packet( np )
    end,

    --请求领取消费礼包（22号活动）
    --客户端发送
    [247] = function ( 
                param_1_unsigned_char,  -- 档次
                param_2_unsigned_char -- 第几个套餐
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 171, 247 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[171] = {
    --下发百服翻牌活动状态
    --接收服务器
    [1] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        PacketDispatcher:dispather( 171, 1, var_1_int )--分发数据
    end,

    --百服活动下发活动图标状态
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --配置类型，0：老服， 1：新服， 2：其他服
        local var_2_int = np:readInt( ) --控制客户端百服活动图标开关--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 5, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --发送玩家可以抽奖次数
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --玩家可以抽奖次数
        PacketDispatcher:dispather( 171, 6, var_1_unsigned_int )--分发数据
    end,

    --下发返利信息
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --todayRecharge--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --fanli--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 8, var_1_int, var_2_int )--分发数据
    end,

    --下发抽中物品的下标
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --抽中物品的下标  范围 1-12
        PacketDispatcher:dispather( 171, 7, var_1_unsigned_char )--分发数据
    end,

    --下发全服消费返利活动状态
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 11, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发全服消费返利全服消费信息
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --全服当日消费总元宝
        local var_2_int = np:readInt( ) --全服当日消费可领取的最大礼包--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 13, var_1_int, var_2_int )--分发数据
    end,

    --下发神秘商店活动状态
    --接收服务器
    [18] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 18, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发新增幸运玩家信息
    --接收服务器
    [19] = function ( np )
        local var_1_string = np:readString( ) --幸运玩家名字
        local var_2_unsigned_char = np:readByte( ) --显示类型，1表示购买了，2表示兑换了
        local var_3_int = np:readInt( ) --物品id
        PacketDispatcher:dispather( 171, 19, var_1_string, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --下发全服充值返利活动状态
    --接收服务器
    [21] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 21, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发全服充值返利全服充值信息
    --接收服务器
    [23] = function ( np )
        local var_1_int = np:readInt( ) --全服当日充值总元宝
        local var_2_int = np:readInt( ) --全服当日充值可领取的最大礼包
        PacketDispatcher:dispather( 171, 23, var_1_int, var_2_int )--分发数据
    end,

    --下发年货活动状态
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0未开始，1开始，2结束（状态0不会下发）
        PacketDispatcher:dispather( 171, 27, var_1_unsigned_char )--分发数据
    end,

    --下发24-26号活动状态
    --接收服务器
    [29] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --活动开始日期--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --活动结束日期--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_char = np:readChar( ) --新老服配置标识--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_char = np:readChar( ) --用来区分第几次开活动--s本参数存在特殊说明，请查阅协议编辑器
        local var_6_char = np:readChar( ) --在线时长抽奖活动状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_char = np:readChar( ) --捕鱼活动状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 29, var_1_int, var_2_int, var_3_int, var_4_char, var_5_char, var_6_char, var_7_char )--分发数据
    end,

    --下发在线抽奖活动数据
    --接收服务器
    [30] = function ( np )
        local var_1_int = np:readInt( ) --玩家当天累计在线时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --距离下次抽奖剩余的秒数
        local var_3_char = np:readChar( ) --当天剩余抽奖次数
        PacketDispatcher:dispather( 171, 30, var_1_int, var_2_int, var_3_char )--分发数据
    end,

    --下发抽中的奖品序号
    --接收服务器
    [31] = function ( np )
        local var_1_char = np:readChar( ) --抽中的物品的下标--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 31, var_1_char )--分发数据
    end,

    --吉祥如意.连续登录-下发礼包信息
    --接收服务器
    [33] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --byte1, --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --byte2--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --byte3--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 33, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --吉祥如意.每日优惠-下发物品信息
    --接收服务器
    [34] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --type，购买类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --index, 物品索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --count, 该物品对与该玩家的限购数量
        PacketDispatcher:dispather( 171, 34, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --吉祥如意.消费送豪礼-服务端
    --接收服务器
    [35] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --ybCount, 玩家累计消费的元宝数
        local var_2_unsigned_char = np:readByte( ) --byte1, 0:不可领取，1:可领取，2:已领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --byte2, 0:不可领取，1:可领取，2:已领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_char = np:readByte( ) --byte3, 0:不可领取，1:可领取，2:已领取--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 35, var_1_unsigned_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --吉祥如意.欢乐大转盘-抽中的物品下标
    --接收服务器
    [36] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index, 物品下标
        PacketDispatcher:dispather( 171, 36, var_1_unsigned_char )--分发数据
    end,

    --吉祥如意.活动状态
    --接收服务器
    [38] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --leftTime, 活动剩余时间
        local var_2_unsigned_char = np:readByte( ) --type, 服务器类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 38, var_1_unsigned_int, var_2_unsigned_char )--分发数据
    end,

    --吉祥如意.欢乐大转盘-下发玩家抽奖次数
    --接收服务器
    [37] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --count, 玩家抽奖次数
        PacketDispatcher:dispather( 171, 37, var_1_unsigned_int )--分发数据
    end,

    --神马都有.下发每日消费活动状态
    --接收服务器
    [41] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 41, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --神马都有.下发每日消费信息
    --接收服务器
    [42] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0表示不可领取，1表示可领取，2表示已领取
        PacketDispatcher:dispather( 171, 42, var_1_unsigned_char )--分发数据
    end,

    --神马都有.下发充值送礼活动状态
    --接收服务器
    [43] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 43, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --神马都有.下发马上有钱活动状态
    --接收服务器
    [45] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 45, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --神马都有.下发马上宝宝活动状态
    --接收服务器
    [47] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 47, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --神马都有.下发马上宝宝信息
    --接收服务器
    [48] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否显示图标， 0不显示， 1显示
        local var_2_int = np:readInt( ) --领取的宝宝，未领则为0
        local var_3_int = np:readInt( ) --成长度，整数，客户端要除以100
        local var_4_unsigned_char = np:readByte( ) --是否可浇灌，0可以，1不可以
        PacketDispatcher:dispather( 171, 48, var_1_unsigned_char, var_2_int, var_3_int, var_4_unsigned_char )--分发数据
    end,

    --下发新年BOSS活动状态
    --接收服务器
    [49] = function ( np )
        local var_1_char = np:readChar( ) --活动状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --新老配置标识--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --剩余的秒数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 49, var_1_char, var_2_char, var_3_int )--分发数据
    end,

    --吉祥如意.限量抢购-下发各礼包状态
    --接收服务器
    [39] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --byte1, 礼包1可购买数量
        local var_2_unsigned_char = np:readByte( ) --byte2, 礼包2可购买数量
        local var_3_unsigned_char = np:readByte( ) --byte3, 礼包3可购买数量
        local var_4_unsigned_char = np:readByte( ) --byte1, 配置中礼包1的限购数量
        local var_5_unsigned_char = np:readByte( ) --byte2, 配置中礼包2的限购数量
        local var_6_unsigned_char = np:readByte( ) --byte3, 配置中礼包3的限购数量
        PacketDispatcher:dispather( 171, 39, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char )--分发数据
    end,

    --服务端下发抽马上宝宝活动
    --接收服务器
    [51] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 51, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发回归特礼活动
    --接收服务器
    [53] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 53, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发玩家回归特礼信息
    --接收服务器
    [54] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --档次
        local var_2_unsigned_char = np:readByte( ) --领取次数
        local var_3_unsigned_char = np:readByte( ) --是否满足领取条件，0不满足，1满足
        local var_4_unsigned_char = np:readByte( ) --礼包领取状态，0未领，1已领取
        PacketDispatcher:dispather( 171, 54, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --任务追踪面板优化-下发今日的已经做的斩妖除魔任务数量
    --接收服务器
    [57] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count, 玩家今日已经做的斩妖除魔任务数量
        PacketDispatcher:dispather( 171, 57, var_1_unsigned_char )--分发数据
    end,

    --趣味答题_下发活动状态
    --接收服务器
    [59] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1开启，0结束，2倒计时
        local var_2_unsigned_int = np:readUInt( ) --剩余时间（秒）
        PacketDispatcher:dispather( 171, 59, var_1_unsigned_char, var_2_unsigned_int )--分发数据
    end,

    --趣味答题_下发开始作答
    --接收服务器
    [61] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个题目
        local var_2_unsigned_int = np:readUInt( ) --剩余答题时间（秒）
        PacketDispatcher:dispather( 171, 61, var_1_unsigned_char, var_2_unsigned_int )--分发数据
    end,

    --趣味答题_下发玩家当前选择区域
    --接收服务器
    [62] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前区域，0未选择，1区域一，2区域二
        PacketDispatcher:dispather( 171, 62, var_1_unsigned_char )--分发数据
    end,

    --趣味答题_下发正确答案
    --接收服务器
    [63] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个题目
        local var_2_unsigned_char = np:readByte( ) --正确答案下标
        local var_3_unsigned_char = np:readByte( ) --玩家的选择
        local var_4_unsigned_int = np:readUInt( ) --剩余查看答案时间（秒）
        PacketDispatcher:dispather( 171, 63, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_int )--分发数据
    end,

    --趣味答题_客户端使用互动技能结果
    --接收服务器
    [64] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --技能序号
        local var_2_unsigned_char = np:readByte( ) --0成功 1失败
        PacketDispatcher:dispather( 171, 64, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --趣味答题_下发玩家答题情况
    --接收服务器
    [65] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家答对题数
        local var_2_unsigned_char = np:readByte( ) --剩余答题数
        PacketDispatcher:dispather( 171, 65, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --趣味答题_下发答题结果
    --接收服务器
    [66] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家答对题数
        local var_2_unsigned_int = np:readUInt( ) --玩家获得经验
        PacketDispatcher:dispather( 171, 66, var_1_unsigned_char, var_2_unsigned_int )--分发数据
    end,

    --趣味答题_下发进入答题副本结果
    --接收服务器
    [67] = function ( np )
        PacketDispatcher:dispather( 171, 67 )--分发数据
    end,

    --渡劫_下发副本可以加血的次数
    --接收服务器
    [69] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --还剩多少次加血机会
        PacketDispatcher:dispather( 171, 69, var_1_unsigned_int )--分发数据
    end,

    --渡劫_下发副本下发剩余通层次数
    --接收服务器
    [70] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --还剩余多少次
        PacketDispatcher:dispather( 171, 70, var_1_unsigned_int )--分发数据
    end,

    --全民富翁-下发时间信息
    --接收服务器
    [74] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --numRound，第几波
        local var_2_unsigned_int = np:readUInt( ) --leftRound，该波剩余时间
        local var_3_unsigned_char = np:readByte( ) --numTurn，第几轮
        local var_4_unsigned_int = np:readUInt( ) --leftTurn，该轮剩余时间
        local var_5_unsigned_char = np:readByte( ) --haveDo，1:已经摇骰子，0:还未摇骰子
        PacketDispatcher:dispather( 171, 74, var_1_unsigned_char, var_2_unsigned_int, var_3_unsigned_char, var_4_unsigned_int, var_5_unsigned_char )--分发数据
    end,

    --全民富翁-下发幸运奖和一到五等奖数量更改信息
    --接收服务器
    [75] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --awardType，0:奖品类型，1-5:一到五等奖
        local var_2_unsigned_char = np:readByte( ) --count，该奖品剩余数量
        PacketDispatcher:dispather( 171, 75, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --全民富翁-下发自己所得奖励信息
    --接收服务器
    [77] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --礼包数量
        local var_2_int = np:readInt( ) --礼包Id
        PacketDispatcher:dispather( 171, 77, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --全民富翁-广播字符串消息
    --接收服务器
    [78] = function ( np )
        local var_1_string = np:readString( ) --字符串消息
        PacketDispatcher:dispather( 171, 78, var_1_string )--分发数据
    end,

    --渡劫_下发全服通关状态
    --接收服务器
    [79] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --全服的玩家最高已经通过了第几章
        PacketDispatcher:dispather( 171, 79, var_1_unsigned_int )--分发数据
    end,

    --全民富翁-广播活动已经结束
    --接收服务器
    [81] = function ( np )
        PacketDispatcher:dispather( 171, 81 )--分发数据
    end,

    --服务端下发翅膀系统累积消费
    --接收服务器
    [83] = function ( np )
        local var_1_int = np:readInt( ) --累积消费（从登陆的第二天开始累积）
        PacketDispatcher:dispather( 171, 83, var_1_int )--分发数据
    end,

    --下发全套紫装礼包剩余购买时间
    --接收服务器
    [84] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间，为0则关闭图标
        PacketDispatcher:dispather( 171, 84, var_1_int )--分发数据
    end,

    --首冲_给礼包
    --接收服务器
    [85] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1发送到背包，2发送到邮箱
        PacketDispatcher:dispather( 171, 85, var_1_unsigned_char )--分发数据
    end,

    --首冲_礼包状态
    --接收服务器
    [86] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0未使用，1已使用
        local var_2_unsigned_char = np:readByte( ) --0需要去充值，1可以使用礼包
        PacketDispatcher:dispather( 171, 86, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --领奖结果
    --接收服务器
    [88] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个奖励
        PacketDispatcher:dispather( 171, 88, var_1_unsigned_char )--分发数据
    end,

    --四灵幻阵-下发宝箱刷新倒计时时间
    --接收服务器
    [89] = function ( np )
        local var_1_int = np:readInt( ) --宝箱刷新倒计时时间
        PacketDispatcher:dispather( 171, 89, var_1_int )--分发数据
    end,

    --微信礼包-服务端下发微信礼包领取状态
    --接收服务器
    [90] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0:未领取,1:已领取
        PacketDispatcher:dispather( 171, 90, var_1_unsigned_char )--分发数据
    end,

    --微信礼包-服务端下发微信礼包领取情况
    --接收服务器
    [91] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0:领取失败,1:领取成功
        PacketDispatcher:dispather( 171, 91, var_1_unsigned_char )--分发数据
    end,

    --服务端返回预充值返利信息
    --接收服务器
    [93] = function ( np )
        local var_1_int = np:readInt( ) --玩家已充值元宝
        PacketDispatcher:dispather( 171, 93, var_1_int )--分发数据
    end,

    --每日首冲_状态
    --接收服务器
    [94] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几天，1开始
        local var_2_unsigned_char = np:readByte( ) --0不能领取，1可以领取，2已领取
        local var_3_unsigned_char = np:readByte( ) --0每日充值活动，1合服充值活动
        local var_4_unsigned_char = np:readByte( ) --是第几大套配置
        local var_5_unsigned_char = np:readByte( ) --（新版本有）第几小套配置
        local var_6_unsigned_char = np:readByte( ) --（合服首充有）第几次合服，1代表第一次合服，2代表第二次合服
        PacketDispatcher:dispather( 171, 94, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char )--分发数据
    end,

    --下发神兵限时优惠活动状态
    --接收服务器
    [119] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间，0为结束
        PacketDispatcher:dispather( 171, 119, var_1_int )--分发数据
    end,

    --下发神兵累积充值活动状态
    --接收服务器
    [130] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间，0为结束
        PacketDispatcher:dispather( 171, 130, var_1_int )--分发数据
    end,

    --膜拜城主-应答膜拜或者鄙视城主
    --接收服务器
    [135] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否成功膜拜或者鄙视--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --当日剩余膜拜次数
        local var_3_int = np:readInt( ) --城主被膜拜次数
        local var_4_int = np:readInt( ) --城主被鄙视次数
        local var_5_int = np:readInt( ) --当前刷新品质
        PacketDispatcher:dispather( 171, 135, var_1_unsigned_char, var_2_int, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --膜拜城主-广播城主被膜拜或者鄙视的次数
    --接收服务器
    [136] = function ( np )
        local var_1_int = np:readInt( ) --城主被膜拜的次数
        local var_2_int = np:readInt( ) --城主被鄙视的次数
        PacketDispatcher:dispather( 171, 136, var_1_int, var_2_int )--分发数据
    end,

    --膜拜城主-应答领取膜拜城主奖励
    --接收服务器
    [137] = function ( np )
        PacketDispatcher:dispather( 171, 137 )--分发数据
    end,

    --膜拜城主-应答刷新经验倍数
    --接收服务器
    [138] = function ( np )
        local var_1_int = np:readInt( ) --刷新品质
        local var_2_int = np:readInt( ) --剩余刷新次数
        PacketDispatcher:dispather( 171, 138, var_1_int, var_2_int )--分发数据
    end,

    --下发全服抽奖活动状态
    --接收服务器
    [139] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间，0表示结束
        PacketDispatcher:dispather( 171, 139, var_1_int )--分发数据
    end,

    --下发全服抽奖活动个人信息
    --接收服务器
    [140] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --玩家今天剩余抽奖次数
        local var_2_unsigned_char = np:readByte( ) --当前抽中奖励下标，0是初始下标，什么也每种
        PacketDispatcher:dispather( 171, 140, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --装备淬炼-图标控制协议
    --接收服务器
    [142] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，活动剩余时间
        PacketDispatcher:dispather( 171, 142, var_1_int )--分发数据
    end,

    --幻境修炼-下发今日挂机剩余时间
    --接收服务器
    [144] = function ( np )
        local var_1_int = np:readInt( ) --leftTime，剩余时间
        PacketDispatcher:dispather( 171, 144, var_1_int )--分发数据
    end,

    --静态场景副本统计-退出场景，见函数MiscFunc.SendCaleExitScene
    --接收服务器
    [145] = function ( np )
        PacketDispatcher:dispather( 171, 145 )--分发数据
    end,

    --预体验-通知客户端弹窗
    --接收服务器
    [146] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --yutiyanType--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 146, var_1_unsigned_char )--分发数据
    end,

    --应答当前可打的副本是否有剩余次数或重置次数
    --接收服务器
    [147] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1有次数 0没次数
        PacketDispatcher:dispather( 171, 147, var_1_unsigned_char )--分发数据
    end,

    --应答封印守护、屠龙圣殿的可领奖次数
    --接收服务器
    [148] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --封印守护的可领奖次数
        local var_2_unsigned_char = np:readByte( ) --屠龙圣殿的可领奖次数
        PacketDispatcher:dispather( 171, 148, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --世界Boss-下发各人统计
    --接收服务器
    [150] = function ( np )
        local var_1_int = np:readInt( ) --排名--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --IDType
        local var_3_int = np:readInt( ) --ID
        local var_4_string = np:readString( ) --name
        local var_5_int = np:readInt( ) --score
        PacketDispatcher:dispather( 171, 150, var_1_int, var_2_unsigned_char, var_3_int, var_4_string, var_5_int )--分发数据
    end,

    --下发玩家今天通过膜拜城主获得的总经验值
    --接收服务器
    [151] = function ( np )
        local var_1_int64 = np:readInt64( ) --
        PacketDispatcher:dispather( 171, 151, var_1_int64 )--分发数据
    end,

    --砸蛋下发活动状态
    --接收服务器
    [152] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型 1 2
        PacketDispatcher:dispather( 171, 152, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --神秘商店图标
    --接收服务器
    [155] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0为隐藏 1为显示
        local var_2_unsigned_char = np:readByte( ) --配置类型 1 2
        local var_3_unsigned_char = np:readByte( ) --1:表示开启老版神秘商店；2表示开启黑市商人
        PacketDispatcher:dispather( 171, 155, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --更新限时神秘商店的刷新剩余时间
    --接收服务器
    [156] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间（秒
        PacketDispatcher:dispather( 171, 156, var_1_int )--分发数据
    end,

    --每日登录活动状态
    --接收服务器
    [158] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 158, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --活跃好礼活动状态
    --接收服务器
    [160] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 160, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --活跃好礼领奖
    --接收服务器
    [156] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index下标
        PacketDispatcher:dispather( 171, 156, var_1_unsigned_char )--分发数据
    end,

    --每日消费活动状态
    --接收服务器
    [162] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 162, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --每日消费玩家数据
    --接收服务器
    [163] = function ( np )
        local var_1_int = np:readInt( ) --消费元宝
        local var_2_unsigned_char = np:readByte( ) --长度
        local var_3_int = np:readInt( ) --state每一位表示状态 0 未领 1已领
        PacketDispatcher:dispather( 171, 163, var_1_int, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --每日消费领取奖励
    --接收服务器
    [157] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --index下标
        PacketDispatcher:dispather( 171, 157, var_1_unsigned_char )--分发数据
    end,

    --限购活动状态
    --接收服务器
    [164] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 164, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --限购购买
    --接收服务器
    [158] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --下标
        local var_2_unsigned_char = np:readByte( ) --个数
        PacketDispatcher:dispather( 171, 158, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --捕鱼达人活动状态
    --接收服务器
    [166] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 166, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --捕鱼结果
    --接收服务器
    [167] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码 0成功 1钱数量不够 2活动已过期
        local var_2_unsigned_char = np:readByte( ) --鱼的下标 0表示全部
        PacketDispatcher:dispather( 171, 167, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --360加速球图标状态
    --接收服务器
    [169] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0消失，1出现
        PacketDispatcher:dispather( 171, 169, var_1_unsigned_char )--分发数据
    end,

    --360游戏大厅图标状态
    --接收服务器
    [170] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0消失 1出现
        PacketDispatcher:dispather( 171, 170, var_1_unsigned_char )--分发数据
    end,

    --DIY称号活动状态
    --接收服务器
    [174] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --礼包领取状态，用0-2表示--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --美女客服按钮状态，0表示灰色，1表示激活
        local var_3_int = np:readInt( ) --充值数量
        PacketDispatcher:dispather( 171, 174, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --DIY称号活动图标状态
    --接收服务器
    [175] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0表示消失，1表示开启
        local var_2_unsigned_char = np:readByte( ) --第几套配置
        local var_3_int = np:readInt( ) --活动剩余时间
        PacketDispatcher:dispather( 171, 175, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --全服抽奖活动状态
    --接收服务器
    [189] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 189, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --全服抽奖个人信息
    --接收服务器
    [177] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --剩余次数
        local var_2_unsigned_char = np:readByte( ) --上次下标
        PacketDispatcher:dispather( 171, 177, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --幸运翻牌活动状态
    --接收服务器
    [178] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_unsigned_char = np:readByte( ) --第几套配置，用1-n表示，1表示老服
        PacketDispatcher:dispather( 171, 178, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --限时抢购活动信息
    --接收服务器
    [181] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        local var_3_unsigned_char = np:readByte( ) --state 0和3表示不在抢购时间段 1准备阶段 2抢购时间段
        local var_4_int = np:readInt( ) --距下一轮开始的时间（秒）
        local var_5_int = np:readInt( ) --本轮还剩多久
        PacketDispatcher:dispather( 171, 181, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_int, var_5_int )--分发数据
    end,

    --限时抢购上轮信息
    --接收服务器
    [182] = function ( np )
        local var_1_int = np:readInt( ) --actorid
        local var_2_string = np:readString( ) --actorname
        local var_3_int = np:readInt( ) --道具id
        local var_4_int = np:readInt( ) --数量
        PacketDispatcher:dispather( 171, 182, var_1_int, var_2_string, var_3_int, var_4_int )--分发数据
    end,

    --限时抢购参与信息
    --接收服务器
    [183] = function ( np )
        local var_1_int = np:readInt( ) --极品id
        local var_2_int = np:readInt( ) --极品数量
        local var_3_unsigned_char = np:readByte( ) --宝箱下标
        local var_4_int = np:readInt( ) --开出物品id
        local var_5_int = np:readInt( ) --开出物品数量
        local var_6_unsigned_char = np:readByte( ) --是否可参与 0 不可 1 可
        local var_7_unsigned_char = np:readByte( ) --是否可领极品 0 不可 1 可 2 已领
        local var_8_unsigned_char = np:readByte( ) --是否可领抢购奖 0 不可 1 可 2 已领
        local var_9_unsigned_char = np:readByte( ) --是否可领参与奖 0 不可 1 可 2 已领
        local var_10_int = np:readInt( ) --round轮数
        local var_11_unsigned_char = np:readByte( ) --0 不是极品 1 是极品
        PacketDispatcher:dispather( 171, 183, var_1_int, var_2_int, var_3_unsigned_char, var_4_int, var_5_int, var_6_unsigned_char, var_7_unsigned_char, var_8_unsigned_char, var_9_unsigned_char, var_10_int, var_11_unsigned_char )--分发数据
    end,

    --投资计划活动状态
    --接收服务器
    [201] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 201, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发改名结果
    --接收服务器
    [190] = function ( np )
        local var_1_char = np:readChar( ) --下发改名的结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 190, var_1_char )--分发数据
    end,

    --每日消费活动开启信息
    --接收服务器
    [191] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几套配置， 从1开始编号
        local var_2_unsigned_char = np:readByte( ) --活动第几天， 0表示未开启， 其他表示活动的第几天
        PacketDispatcher:dispather( 171, 191, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --360安全卫士领奖结果
    --接收服务器
    [194] = function ( np )
        local var_1_int = np:readInt( ) --领奖状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 194, var_1_int )--分发数据
    end,

    --360安全卫士特权图标状态
    --接收服务器
    [200] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0：消失 1：出现
        PacketDispatcher:dispather( 171, 200, var_1_unsigned_char )--分发数据
    end,

    --下发全民乐购礼包购买信息
    --接收服务器
    [195] = function ( np )
        local var_1_int = np:readInt( ) --礼包1购买次数
        local var_2_int = np:readInt( ) --礼包2购买次数
        local var_3_int = np:readInt( ) --礼包3购买次数
        local var_4_int = np:readInt( ) --剩余积分
        local var_5_int = np:readInt( ) --参与购买礼包的用户数
        PacketDispatcher:dispather( 171, 195, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --下发全民乐购活动状态
    --接收服务器
    [196] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动是否开启， 0表示没有开， 1表示开启
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 196, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --下发九字真言活动情况
    --接收服务器
    [197] = function ( np )
        local var_1_int = np:readInt( ) --剩余活动时间，0为关闭活动
        local var_2_unsigned_char = np:readByte( ) --配置类型，1新0老
        PacketDispatcher:dispather( 171, 197, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发九字真言幸运儿信息
    --接收服务器
    [199] = function ( np )
        local var_1_string = np:readString( ) --人品奖获得者名称
        local var_2_int = np:readInt( ) --人品奖获得者ID
        local var_3_int = np:readInt( ) --花费元宝数
        PacketDispatcher:dispather( 171, 199, var_1_string, var_2_int, var_3_int )--分发数据
    end,

    --下发星语心愿活动状态
    --接收服务器
    [202] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0表示结束
        local var_2_unsigned_char = np:readByte( ) --使用第几套配置1-3
        PacketDispatcher:dispather( 171, 202, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --星语心愿广播星星总数
    --接收服务器
    [204] = function ( np )
        local var_1_int = np:readInt( ) --星星总数
        PacketDispatcher:dispather( 171, 204, var_1_int )--分发数据
    end,

    --下发全民采购活动状态
    --接收服务器
    [205] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --第几套配置
        PacketDispatcher:dispather( 171, 205, var_1_unsigned_int, var_2_unsigned_char )--分发数据
    end,

    --下发幸运转盘活动状态
    --接收服务器
    [207] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型 1-n
        PacketDispatcher:dispather( 171, 207, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发抽奖结果
    --接收服务器
    [209] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --抽到的格子的下标1-n
        PacketDispatcher:dispather( 171, 209, var_1_unsigned_char )--分发数据
    end,

    --下发天阙降幅活动开启状态
    --接收服务器
    [210] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 210, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发玩家的存钱信息
    --接收服务器
    [212] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --玩家存储的是第几档
        local var_2_unsigned_int = np:readUInt( ) --当前玩家已经充值了多少元宝
        local var_3_unsigned_int = np:readUInt( ) --存了钱后的第几天，从1开始编号， 0表示没存
        local var_4_unsigned_int = np:readUInt( ) --玩家的利息
        local var_5_unsigned_int = np:readUInt( ) --是否已经取钱了， 0表示没有取， 1表示取了
        PacketDispatcher:dispather( 171, 212, var_1_unsigned_int, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_int )--分发数据
    end,

    --神马都有.下发马上宝宝活动状态
    --接收服务器
    [213] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 213, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --神马都有.下发马上宝宝信息
    --接收服务器
    [214] = function ( np )
        local var_1_int = np:readInt( ) --领取的宝宝，未领则为0
        local var_2_int = np:readInt( ) --成长度，整数，客户端要除以100
        local var_3_unsigned_char = np:readByte( ) --是否可浇灌，0可以，1不可以
        local var_4_unsigned_char = np:readByte( ) --是否显示图标， 0不显示， 1显示
        PacketDispatcher:dispather( 171, 214, var_1_int, var_2_int, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --下发至尊特惠活动状态
    --接收服务器
    [216] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间,0表示结束
        local var_2_unsigned_char = np:readByte( ) --使用第几套配置1-n
        PacketDispatcher:dispather( 171, 216, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发至尊返利活动状态
    --接收服务器
    [218] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，2表示新服，1表示老服
        PacketDispatcher:dispather( 171, 218, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发每日返利活动状态
    --接收服务器
    [220] = function ( np )
        local var_1_int = np:readInt( ) --剩余活动时间
        local var_2_unsigned_char = np:readByte( ) --配置类型
        local var_3_unsigned_char = np:readByte( ) --活动进行到哪天
        PacketDispatcher:dispather( 171, 220, var_1_int, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --下发鉴宝活动的活动状态
    --接收服务器
    [222] = function ( np )
        local var_1_int = np:readInt( ) --活动状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --新老服配置--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 222, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发鉴宝活动玩家活动数据
    --接收服务器
    [223] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前玩家所处的层级
        local var_2_int = np:readInt( ) --玩家所在那层的当前经验值
        local var_3_unsigned_char = np:readByte( ) --玩家随机获得当前层的物品所在的下标
        PacketDispatcher:dispather( 171, 223, var_1_unsigned_char, var_2_int, var_3_unsigned_char )--分发数据
    end,

    --下发连服充值排行活动开启状态
    --接收服务器
    [230] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动状态 0未开启 1进行中 2已结束 3真正结束
        local var_2_int = np:readInt( ) --活动剩余时间
        local var_3_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 171, 230, var_1_unsigned_char, var_2_int, var_3_unsigned_char )--分发数据
    end,

    --下发众志成城活动状态
    --接收服务器
    [233] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，0表示结束
        local var_2_unsigned_char = np:readByte( ) --使用第几套配置1-3
        PacketDispatcher:dispather( 171, 233, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发众志成城修复值
    --接收服务器
    [235] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --城墙修复比例
        local var_2_int = np:readInt( ) --城墙修复值
        PacketDispatcher:dispather( 171, 235, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --请求众志成城奖励
    --接收服务器
    [237] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --礼包的index （1～n）
        PacketDispatcher:dispather( 171, 237, var_1_unsigned_char )--分发数据
    end,

    --下发恭贺新年活动状态
    --接收服务器
    [243] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动图标状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 171, 243, var_1_unsigned_char )--分发数据
    end,

    --下发周年鲜花榜活动状态
    --接收服务器
    [244] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --配置类型1,2
        local var_2_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 171, 244, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --下发神仙鉴宝活动状态
    --接收服务器
    [95] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        local var_2_unsigned_char = np:readByte( ) --配置
        PacketDispatcher:dispather( 171, 95, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发消费礼包活动状态（22号活动）
    --接收服务器
    [247] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间（单位秒），0表示活动结束 
        local var_2_unsigned_char = np:readByte( ) --是否使用新服配置，1表示新服，0表示老服
        PacketDispatcher:dispather( 171, 247, var_1_int, var_2_unsigned_char )--分发数据
    end,


}
