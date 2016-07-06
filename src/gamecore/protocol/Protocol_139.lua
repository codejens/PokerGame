protocol_func_map_client[139] = {
    --客户端点击拾取单个奖励
    --客户端发送
    [2] = function ( 
                param_1_unsigned_char -- 奖励的索引值
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 2 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端点击全部拾取奖励
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 3 ) 
        NetManager:send_packet( np )
    end,

    --客户端点击放弃奖励
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 4 ) 
        NetManager:send_packet( np )
    end,

    --进入擂台场景
    --客户端发送
    [6] = function ( 
                param_1_unsigned_char -- 进入擂台场景的类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 6 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --玩家点击速传按钮
    --客户端发送
    [7] = function ( 
                param_1_unsigned_short,  -- 场景的ID
                param_2_string,  -- 场景的名字
                param_3_unsigned_short,  -- 场景的坐标 X
                param_4_unsigned_short -- 场景的坐标 Y
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" }, { param_name = param_3_unsigned_short, lua_type = "number" }, { param_name = param_4_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 7 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeString( param_2_string )
        np:writeWord( param_3_unsigned_short )
        np:writeWord( param_4_unsigned_short )
        NetManager:send_packet( np )
    end,

    --读取进度条失败，
    --客户端发送
    [8] = function ( 
                param_1_unsigned_int -- 此次消息的唯一标识
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 8 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --玩家领取离线经验
    --客户端发送
    [9] = function ( 
                param_1_unsigned_char -- 领取离线经验的类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 9 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --保存系统设置的数据
    --客户端发送
    [10] = function ( 
                param_1_unsigned_int,  -- 系统设置的数据--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_int,  -- 系统设置数据2
                param_3_unsigned_int,  -- 音量
                param_4_unsigned_int -- 音效
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" }, { param_name = param_3_unsigned_int, lua_type = "number" }, { param_name = param_4_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 10 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeUInt( param_2_unsigned_int )
        np:writeUInt( param_3_unsigned_int )
        np:writeUInt( param_4_unsigned_int )
        NetManager:send_packet( np )
    end,

    --客户端点驿站传送功能的传送
    --客户端发送
    [11] = function ( 
                param_1_int,  -- 玩家所在场景的ID
                param_2_int,  -- 目标场景的ID
                param_3_int,  -- 目标场景的坐标X
                param_4_int -- 目标场景的坐标Y
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" }, { param_name = param_4_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 11 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        np:writeInt( param_4_int )
        NetManager:send_packet( np )
    end,

    --客户端点击BOSS按钮
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 12 ) 
        NetManager:send_packet( np )
    end,

    --用户领取副本奖励（开箱）
    --客户端发送
    [13] = function ( 
                param_1_unsigned_char,  -- 箱子的索引 0-4 ，如果是单人的奖励，这个写0
                param_2_unsigned_char -- 是否金箱，0：银箱，1：金箱
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 13 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端点击领取系统预告奖励
    --客户端发送
    [14] = function ( 
                param_1_unsigned_char -- 领取的组号ID--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 14 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求获得领取系统预告信息
    --客户端发送
    [15] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 15 ) 
        NetManager:send_packet( np )
    end,

    --赠送鲜花或谢谢对方
    --客户端发送
    [21] = function ( 
                param_1_unsigned_short,  -- 朵数--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- 匿名：0：匿名，1:签名
                param_3_string -- 对方名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 21 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeByte( param_2_unsigned_char )
        np:writeString( param_3_string )
        NetManager:send_packet( np )
    end,

    --客户端返回输入的字符串内容
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 22 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求阵营活动列表信息
    --客户端发送
    [23] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 23 ) 
        NetManager:send_packet( np )
    end,

    --客户端点击发布阵营活动
    --客户端发送
    [24] = function ( 
                param_1_unsigned_char -- 阵营活动ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 24 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端点击领取老虎机领奖按钮
    --客户端发送
    [25] = function ( 
                param_1_unsigned_char -- 窗口ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 25 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --玩家点击江湖地位变更传送到阵营领袖NPC按钮
    --客户端发送
    [26] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 26 ) 
        NetManager:send_packet( np )
    end,

    --更换头像
    --客户端发送
    [27] = function ( 
                param_1_unsigned_short -- 头像id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 27 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --弹劾盟主
    --客户端发送
    [28] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 28 ) 
        NetManager:send_packet( np )
    end,

    --查询阵营盟主弹劾信息
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 29 ) 
        NetManager:send_packet( np )
    end,

    --盟主弹劾投票
    --客户端发送
    [30] = function ( 
                param_1_char -- 1表示支持弹劾 0 表示反对弹劾
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 30 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --拜神
    --客户端发送
    [31] = function ( 
                param_1_unsigned_char,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 奖励类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 31 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --赏金游戏结束
    --客户端发送
    [34] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 34 ) 
        NetManager:send_packet( np )
    end,

    --请求天元之战排行榜
    --客户端发送
    [35] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 35 ) 
        NetManager:send_packet( np )
    end,

    --请求本帮派天元之战统计数据
    --客户端发送
    [36] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 36 ) 
        NetManager:send_packet( np )
    end,

    --接受刷星任务
    --客户端发送
    [37] = function ( 
                param_1_int -- 刷星任务ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 37 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --任务刷星
    --客户端发送
    [38] = function ( 
                param_1_int,  -- 任务ID
                param_2_unsigned_char -- 是否刷到满级--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 38 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --完成刷星任务
    --客户端发送
    [39] = function ( 
                param_1_int,  -- 刷星任务ID
                param_2_unsigned_char -- 完成类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 39 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --复活对话框使用什么复活
    --客户端发送
    [40] = function ( 
                param_1_int -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 40 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --渡劫_请求某一章的渡劫副本信息
    --客户端发送
    [41] = function ( 
                param_1_unsigned_int -- 第几章， 编号从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 41 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --渡劫_进入渡劫系统
    --客户端发送
    [42] = function ( 
                param_1_int,  -- 请求进入第几章渡劫副本，编号从1开始
                param_2_int -- 请求进入第几层渡劫副本，编号从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 42 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --渡劫_退出渡劫
    --客户端发送
    [43] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 43 ) 
        NetManager:send_packet( np )
    end,

    --渡劫_再次渡劫(废弃)
    --客户端发送
    [44] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 44 ) 
        NetManager:send_packet( np )
    end,

    --消费元宝增加采集蟠桃次数
    --客户端发送
    [32] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 32 ) 
        NetManager:send_packet( np )
    end,

    --赏金游戏开始
    --客户端发送
    [46] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 46 ) 
        NetManager:send_packet( np )
    end,

    --必杀技副本拾取宝箱
    --客户端发送
    [47] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 47 ) 
        NetManager:send_packet( np )
    end,

    --获取阵营战战场信息
    --客户端发送
    [50] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 50 ) 
        NetManager:send_packet( np )
    end,

    --进入战场
    --客户端发送
    [51] = function ( 
                param_1_int -- 第几个战场--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 51 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取阵营战排行榜信息
    --客户端发送
    [52] = function ( 
                param_1_int -- 第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 52 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取阵营战奖励
    --客户端发送
    [53] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 53 ) 
        NetManager:send_packet( np )
    end,

    --获取阵营战战场个数
    --客户端发送
    [55] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 55 ) 
        NetManager:send_packet( np )
    end,

    --获取阵营战结束后排行榜信息
    --客户端发送
    [56] = function ( 
                param_1_int -- 第几页--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 56 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --进入仙浴场景
    --客户端发送
    [58] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 58 ) 
        NetManager:send_packet( np )
    end,

    --仙浴活动（打泡泡和戏水）
    --客户端发送
    [59] = function ( 
                param_1_int,  -- 类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 目标玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 59 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --神秘商店购买物品
    --客户端发送
    [61] = function ( 
                param_1_int,  -- 商店ID--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int,  -- 物品ID
                param_3_int -- 物品数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 61 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --玩家选择消耗某个物品，并获取到其中的一个物品
    --客户端发送
    [63] = function ( 
                param_1_int64,  -- 物品序列号
                param_2_int -- 顺序号--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 63 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --传递客户端的参数给服务器
    --客户端发送
    [64] = function ( 
                param_1_int,  -- 数量
                param_2_array -- 数据是key-value形式，都是字符串--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 64 ) 
        np:writeInt( param_1_int )
        for i = 1, param_1_int do 
            -- protocol manual client 数组
            -- 数据是key-value形式，都是字符串--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_2_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --一键找回
    --客户端发送
    [71] = function ( 
                param_1_unsigned_char -- 找回类型，0全部，1经验，2元气，3银两，4仙币
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 71 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取经验找回系统奖励
    --客户端发送
    [70] = function ( 
                param_1_unsigned_char,  -- 类型
                param_2_int,  -- ID
                param_3_unsigned_char,  -- 找回的数据类型，1经验，2元气，3银两，4仙币
                param_4_unsigned_char -- 是否100%找回，1是，0否
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 70 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        NetManager:send_packet( np )
    end,

    --进入八卦地宫
    --客户端发送
    [74] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 74 ) 
        NetManager:send_packet( np )
    end,

    --退出八卦地宫
    --客户端发送
    [75] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 75 ) 
        NetManager:send_packet( np )
    end,

    --领取八卦地宫目标的奖励
    --客户端发送
    [76] = function ( 
                param_1_int -- 目标的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 76 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取连续登陆奖励
    --客户端发送
    [80] = function ( 
                param_1_int -- 领取类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 80 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求双旦副本剩余次数
    --客户端发送
    [81] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 81 ) 
        NetManager:send_packet( np )
    end,

    --提交身份证验证
    --客户端发送
    [83] = function ( 
                param_1_string,  -- 名字
                param_2_string -- 身份证
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 83 ) 
        np:writeString( param_1_string )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --获取限时商店活动信息
    --客户端发送
    [85] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 85 ) 
        NetManager:send_packet( np )
    end,

    --刷新道具
    --客户端发送
    [86] = function ( 
                param_1_unsigned_char -- 是否自动刷新--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 86 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --购买道具
    --客户端发送
    [87] = function ( 
                param_1_int,  -- 购买物品的ID
                param_2_int -- 购买数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 87 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --收藏快捷键到桌面成功
    --客户端发送
    [90] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 90 ) 
        NetManager:send_packet( np )
    end,

    --金券商城获取token和url
    --客户端发送
    [91] = function ( 
                param_1_int -- 套餐id，取值4-7--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 91 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --玩家转职
    --客户端发送
    [91] = function ( 
                param_1_int -- 职业编号，1-4
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 91 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求最少人数的职业
    --客户端发送
    [95] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 95 ) 
        NetManager:send_packet( np )
    end,

    --请求签到
    --客户端发送
    [97] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 97 ) 
        NetManager:send_packet( np )
    end,

    --请求补签
    --客户端发送
    [98] = function ( 
                param_1_char -- 补签的日期
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 98 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --请求领取签到送宠物奖励
    --客户端发送
    [99] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 99 ) 
        NetManager:send_packet( np )
    end,

    --请求领取每天签到奖励
    --客户端发送
    [100] = function ( 
                param_1_char -- 奖励选项ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 100 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --请求投资基金系统信息（已购买后才有效果）
    --客户端发送
    [112] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 112 ) 
        NetManager:send_packet( np )
    end,

    --请求购买投资基金
    --客户端发送
    [113] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 113 ) 
        NetManager:send_packet( np )
    end,

    --请求领取奖励
    --客户端发送
    [114] = function ( 
                param_1_char -- 奖励项的索引--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 114 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --衣柜_获取幻化信息
    --客户端发送
    [118] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 118 ) 
        NetManager:send_packet( np )
    end,

    --衣柜_获取战甲信息
    --客户端发送
    [119] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 119 ) 
        NetManager:send_packet( np )
    end,

    --衣柜_幻化
    --客户端发送
    [120] = function ( 
                param_1_unsigned_char,  -- 幻化的的类型，如16表示时装，17表示武器等
                param_2_int -- 幻化时装id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 120 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --衣柜_战甲放入
    --客户端发送
    [121] = function ( 
                param_1_unsigned_char,  -- 哪圈（由里向外1、2、3）
                param_2_unsigned_char,  -- 哪个槽（1开始）
                param_3_int64 -- 物品序列号
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 121 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeInt64( param_3_int64 )
        NetManager:send_packet( np )
    end,

    --衣柜_战甲卸下
    --客户端发送
    [122] = function ( 
                param_1_unsigned_char,  -- 哪圈
                param_2_unsigned_char -- 哪槽
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 122 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --（废弃）鱼乐无穷_进入鱼乐无穷
    --客户端发送
    [124] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 124 ) 
        NetManager:send_packet( np )
    end,

    --（废弃）鱼乐无穷_捕鱼
    --客户端发送
    [125] = function ( 
                param_1_unsigned_char -- 鱼的id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 125 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --（废弃）鱼乐无穷_换鱼请求
    --客户端发送
    [126] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 126 ) 
        NetManager:send_packet( np )
    end,

    --（废弃）选择答案
    --客户端发送
    [181] = function ( 
                param_1_unsigned_char,  -- 第几题
                param_2_unsigned_char -- 玩家的选择
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 181 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --（废弃）请求道具剩余次数
    --客户端发送
    [183] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 183 ) 
        NetManager:send_packet( np )
    end,

    --（废弃）使用答题道具
    --客户端发送
    [184] = function ( 
                param_1_unsigned_char -- 1：双倍文采，2：答案排错，3：一击命中
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 184 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求领取信息(临时)
    --客户端发送
    [189] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 189 ) 
        NetManager:send_packet( np )
    end,

    --请求领取帮派战奖励(临时)
    --客户端发送
    [192] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 192 ) 
        NetManager:send_packet( np )
    end,

    --帮派战传送(临时)
    --客户端发送
    [193] = function ( 
                param_1_char -- 传送类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 193 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --请求跳过或进入赏金小游戏
    --客户端发送
    [194] = function ( 
                param_1_char -- --c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 194 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --请求进入欢乐挂机战场
    --客户端发送
    [172] = function ( 
                param_1_unsigned_int -- 战场副本handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 172 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --购买并使用药水
    --客户端发送
    [173] = function ( 
                param_1_int -- 第几个药水
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 173 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --玩家申请使用某个称号
    --客户端发送
    [197] = function ( 
                param_1_int -- 称号ID--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 197 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --玩家取消名人堂称号
    --客户端发送
    [198] = function ( 
                param_1_int -- 名人堂称号ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 198 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --客户端招募队友
    --客户端发送
    [200] = function ( 
                param_1_int -- 副本ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 200 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --客户端通过招募链接加入队伍
    --客户端发送
    [201] = function ( 
                param_1_int,  -- 队长ID
                param_2_int -- 副本ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 201 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --请求第二周活动数据
    --客户端发送
    [203] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 203 ) 
        NetManager:send_packet( np )
    end,

    --领取奖励
    --客户端发送
    [204] = function ( 
                param_1_unsigned_char,  -- 奖励类型，1登陆送礼，2充值送礼，3日常送礼
                param_2_unsigned_char -- 领取的奖励下标
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 204 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取极限名人堂奖励
    --客户端发送
    [206] = function ( 
                param_1_int,  -- 称号ID
                param_2_unsigned_char -- 奖励类型，1极限奖励，2平民奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 206 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求进入圣诞副本
    --客户端发送
    [207] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 207 ) 
        NetManager:send_packet( np )
    end,

    --领取中秋活动奖励
    --客户端发送
    [208] = function ( 
                param_1_int,  -- 1：表示累积充值奖励；2：表示当日充值奖励；3：表示登陆奖励
                param_2_int -- 表示奖励序号，从0开始，
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 208 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --玩家申请中秋抽奖次数
    --客户端发送
    [209] = function ( 
                param_1_unsigned_char -- 申请抽奖次数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 209 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --申请元宝和月饼数目
    --客户端发送
    [210] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 210 ) 
        NetManager:send_packet( np )
    end,

    --申请珍品抽取记录列表
    --客户端发送
    [211] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 211 ) 
        NetManager:send_packet( np )
    end,

    --领取新极限名人堂奖励
    --客户端发送
    [214] = function ( 
                param_1_unsigned_char,  -- 目标ID
                param_2_unsigned_char -- 奖励类型，1极限，2平民
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 214 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取极限名人堂额外奖励
    --客户端发送
    [213] = function ( 
                param_1_unsigned_char -- 第几个额外奖励
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 213 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --领取礼包
    --客户端发送
    [217] = function ( 
                param_1_unsigned_char,  -- 礼包类型 1表示登陆礼包，2表示元宝消费礼包
                param_2_unsigned_char -- 礼包的级别，因为登陆礼包分了4个级别，元宝消费礼包只有1个级别
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 217 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --热血押镖-请求继续护镖
    --客户端发送
    [218] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 218 ) 
        NetManager:send_packet( np )
    end,

    --临时请求玩家杀戮值
    --客户端发送
    [221] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 221 ) 
        NetManager:send_packet( np )
    end,

    --（万圣节）客户端请求领取充值奖励
    --客户端发送
    [222] = function ( 
                param_1_unsigned_char -- 奖励的序号，从0开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 222 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求开启某个时装放置位置
    --客户端发送
    [223] = function ( 
                param_1_unsigned_char,  -- 第几页（层），从0开始
                param_2_unsigned_char -- 这一页（层）中的第几个位置，从0开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 223 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --热血护镖-客户端请求排行榜信息
    --客户端发送
    [225] = function ( 
                param_1_int,  -- 排行榜类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 请求第几页的数据
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 225 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --客户端请求所有星辰变属性
    --客户端发送
    [226] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 226 ) 
        NetManager:send_packet( np )
    end,

    --请求光棍节每日登陆奖励
    --客户端发送
    [227] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 227 ) 
        NetManager:send_packet( np )
    end,

    --超值优惠系统-玩家购买物品
    --客户端发送
    [229] = function ( 
                param_1_unsigned_char,  -- type, 购买类型--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int,  -- itemId, 购买物品的Id--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- count, 购买物品的数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 229 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求彩蛋信息
    --客户端发送
    [233] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 233 ) 
        NetManager:send_packet( np )
    end,

    --刷新彩蛋
    --客户端发送
    [234] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 234 ) 
        NetManager:send_packet( np )
    end,

    --砸蛋
    --客户端发送
    [235] = function ( 
                param_1_unsigned_char -- 第几个蛋，0表示全部砸开
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 235 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --限时消费-请求领取礼包
    --客户端发送
    [238] = function ( 
                param_1_int -- 用来说明玩家领取的是第几个礼包
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 238 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --玩家打开界面，请求服务端发送数据
    --客户端发送
    [240] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 240 ) 
        NetManager:send_packet( np )
    end,

    --客户端发送翻牌请求
    --客户端发送
    [242] = function ( 
                param_1_int -- 客户端发送玩家翻了哪张牌--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 242 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --客户端发送领取礼包的请求-领取所有的礼包
    --客户端发送
    [243] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 243 ) 
        NetManager:send_packet( np )
    end,

    --客户端下发玩家点击开始或者刷新按钮事件
    --客户端发送
    [241] = function ( 
                param_1_unsigned_char,  -- 1表示玩家点击了刷新，0表示玩家点击了开始按钮
                param_2_int,  -- fbid,副本id
                param_3_int -- fbid, 副本id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 241 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --客户端请求打开神秘商店窗口，当使用副本委托时
    --客户端发送
    [244] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 244 ) 
        NetManager:send_packet( np )
    end,

    --剧情模拟_客户端播放完某个剧情
    --客户端发送
    [245] = function ( 
                param_1_int,  -- fbid, 副本id
                param_2_unsigned_char -- index,剧情索引
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 245 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --道具强化功能-客户端使用强化石
    --客户端发送
    [246] = function ( 
                param_1_int,  -- itemId, 物品id
                param_2_unsigned_char,  -- count, 使用物品的数量
                param_3_int64 -- guid, 要强化的准备的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 246 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        np:writeInt64( param_3_int64 )
        NetManager:send_packet( np )
    end,

    --副本额外奖励-客户端领取奖励
    --客户端发送
    [247] = function ( 
                param_1_unsigned_char -- count, 玩家在此副本中未领取的奖品数--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 247 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --一键合成物品
    --客户端发送
    [248] = function ( 
                param_1_unsigned_char,  -- level, 合成的级别--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- type, 宝石类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 248 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求增加采集圣诞雪堆的次数
    --客户端发送
    [249] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 249 ) 
        NetManager:send_packet( np )
    end,

    --圣诞节活动许愿
    --客户端发送
    [250] = function ( 
                param_1_unsigned_int -- 许愿物品id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 250 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --新美女理财-请求投资基金系统信息（已购买后才有效果）
    --客户端发送
    [251] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 251 ) 
        NetManager:send_packet( np )
    end,

    --新美女理财-请求购买投资基金
    --客户端发送
    [252] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 252 ) 
        NetManager:send_packet( np )
    end,

    --新美女理财-请求领取奖励
    --客户端发送
    [253] = function ( 
                param_1_char -- 奖励项的索引--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 253 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --宠物装备-一键合成物品
    --客户端发送
    [254] = function ( 
                param_1_unsigned_char,  -- level, 合成的级别--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- type, 宝石类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 254 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求打开斩妖除魔榜界面
    --客户端发送
    [127] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 127 ) 
        NetManager:send_packet( np )
    end,

    --请求帮派任务界面
    --客户端发送
    [128] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 128 ) 
        NetManager:send_packet( np )
    end,

    --渡劫_首次通关一层拾取宝箱
    --客户端发送
    [129] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 129 ) 
        NetManager:send_packet( np )
    end,

    --渡劫_倒计时10秒结束强制进入传送门场景
    --客户端发送
    [130] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 130 ) 
        NetManager:send_packet( np )
    end,

    --轮盘副本_请求抽奖
    --客户端发送
    [134] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 134 ) 
        NetManager:send_packet( np )
    end,

    --轮盘副本_请求抽奖动画播放完成
    --客户端发送
    [135] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 135 ) 
        NetManager:send_packet( np )
    end,

    --更新护镖自动追随状态
    --客户端发送
    [219] = function ( 
                param_1_unsigned_char -- 1开启0关闭
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 139, 219 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[139] = {
    --是否成功领取单个奖励
    --接收服务器
    [2] = function ( np )
        local var_1_bool = np:readChar( ) --是否成功领取--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 2, var_1_bool )--分发数据
    end,

    --是否成功领取全部奖励
    --接收服务器
    [3] = function ( np )
        local var_1_bool = np:readChar( ) --是否成功全部领取--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 3, var_1_bool )--分发数据
    end,

    --发送读进度条的信息给客户端
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --此次消息的唯一标识，用于读取失败后返回给服务器
        local var_2_unsigned_int = np:readUInt( ) --读取进度条的时间
        local var_3_bool = np:readChar( ) --模态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_bool = np:readChar( ) --可否取消--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 4, var_1_unsigned_int, var_2_unsigned_int, var_3_bool, var_4_bool )--分发数据
    end,

    --打开领取离线经验面板
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --1倍离线经验
        local var_2_unsigned_int64 = np:readUint64( ) --1.5倍离线经验
        local var_3_unsigned_int64 = np:readUint64( ) --2倍离线经验
        PacketDispatcher:dispather( 139, 5, var_1_unsigned_int64, var_2_unsigned_int64, var_3_unsigned_int64 )--分发数据
    end,

    --领取离线经验是否成功
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否成功领取--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 6, var_1_unsigned_char )--分发数据
    end,

    --返回系统设置的数据给客户端（已废弃）
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --系统设置的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --系统设置的数据2
        local var_3_unsigned_int = np:readUInt( ) --音量
        local var_4_unsigned_int = np:readUInt( ) --音效
        PacketDispatcher:dispather( 139, 7, var_1_unsigned_int, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int )--分发数据
    end,

    --请求弹出驿站传送功能的列表
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --玩家所在位置的场景ID--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 8, var_1_int )--分发数据
    end,

    --请求打开队伍副本的列表
    --接收服务器
    [9] = function ( np )
        PacketDispatcher:dispather( 139, 9 )--分发数据
    end,

    --玩家添加下属
    --接收服务器
    [12] = function ( np )
        local var_1_int64 = np:readInt64( ) --下属句柄
        local var_2_char = np:readChar( ) --消息中是否有目标点信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --目标点场景ID
        local var_4_string = np:readString( ) --目标NPC名称
        PacketDispatcher:dispather( 139, 12, var_1_int64, var_2_char, var_3_int, var_4_string )--分发数据
    end,

    --移除下属
    --接收服务器
    [13] = function ( np )
        local var_1_int64 = np:readInt64( ) --handle--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 13, var_1_int64 )--分发数据
    end,

    --护镖活动剩余时间和奖励银两
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --活动时间（秒为单位）
        local var_2_int = np:readInt( ) --护镖奖励银两
        PacketDispatcher:dispather( 139, 14, var_1_int, var_2_int )--分发数据
    end,

    --登录护镖提示信息
    --接收服务器
    [15] = function ( np )
        local var_1_string = np:readString( ) --登录护镖提示信息
        PacketDispatcher:dispather( 139, 15, var_1_string )--分发数据
    end,

    --是否成功领取系统预告奖励
    --接收服务器
    [18] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否成功领取奖励--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 18, var_1_unsigned_char )--分发数据
    end,

    --服务端返回领取系统预告信息
    --接收服务器
    [19] = function ( np )
        local var_1_int = np:readInt( ) --领取奖励的32位整数
        PacketDispatcher:dispather( 139, 19, var_1_int )--分发数据
    end,

    --赠花提示
    --接收服务器
    [22] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --朵数--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_string = np:readString( ) --送花人的名称
        local var_3_int = np:readInt( ) --送花id
        local var_4_int = np:readInt( ) --阵营id
        local var_5_int = np:readInt( ) --job
        local var_6_int = np:readInt( ) --等级
        local var_7_int = np:readInt( ) --sex
        local var_8_int = np:readInt( ) --icon
        PacketDispatcher:dispather( 139, 22, var_1_unsigned_short, var_2_string, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int )--分发数据
    end,

    --请求客户端打开输入框界面
    --接收服务器
    [23] = function ( np )
        local var_1_string = np:readString( ) --输入框标题
        local var_2_unsigned_int = np:readUInt( ) --输入框允许输入字数限制
        local var_3_string = np:readString( ) --输入框按钮标题
        PacketDispatcher:dispather( 139, 23, var_1_string, var_2_unsigned_int, var_3_string )--分发数据
    end,

    --服务端返回发布阵营活动状态
    --接收服务器
    [25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --阵营活动ID
        local var_2_unsigned_char = np:readByte( ) --是否发布成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --已发布次数
        PacketDispatcher:dispather( 139, 25, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --更换头像是否成功
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0:成功，1：失败
        PacketDispatcher:dispather( 139, 27, var_1_unsigned_char )--分发数据
    end,

    --开始播放动画，自身资源服务器上装载
    --接收服务器
    [28] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --动画的ID
        PacketDispatcher:dispather( 139, 28, var_1_unsigned_char )--分发数据
    end,

    --开始播放动画(从外部网址上)
    --接收服务器
    [29] = function ( np )
        local var_1_string = np:readString( ) --网页地址
        PacketDispatcher:dispather( 139, 29, var_1_string )--分发数据
    end,

    --开始盟主弹劾
    --接收服务器
    [30] = function ( np )
        local var_1_string = np:readString( ) --弹劾玩家名称
        PacketDispatcher:dispather( 139, 30, var_1_string )--分发数据
    end,

    --服务器发送本阵营盟主弹劾信息
    --接收服务器
    [31] = function ( np )
        local var_1_bool = np:readChar( ) --是否处于盟主弹劾状态
        local var_2_string = np:readString( ) --弹劾玩家名称
        local var_3_int = np:readInt( ) --支持弹劾投票数目
        local var_4_int = np:readInt( ) --反对弹劾投票数目
        local var_5_bool = np:readChar( ) --玩家是否已经进行了弹劾投票
        PacketDispatcher:dispather( 139, 31, var_1_bool, var_2_string, var_3_int, var_4_int, var_5_bool )--分发数据
    end,

    --拜神结果
    --接收服务器
    [32] = function ( np )
        local var_1_char = np:readChar( ) --错误码--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --拜神类型，后面的次数根据这个类型判断是哪种类型的次数减少了--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --奖励类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_char = np:readByte( ) --已经拜神的次数
        PacketDispatcher:dispather( 139, 32, var_1_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --下发赏金游戏时间
    --接收服务器
    [34] = function ( np )
        local var_1_int = np:readInt( ) --游戏时间
        PacketDispatcher:dispather( 139, 34, var_1_int )--分发数据
    end,

    --任务刷星结果
    --接收服务器
    [37] = function ( np )
        local var_1_int = np:readInt( ) --刷星任务ID
        local var_2_int = np:readInt( ) --等级段
        local var_3_int = np:readInt( ) --星级
        local var_4_int = np:readInt( ) --任务ID
        local var_5_int = np:readInt( ) --剩余免费刷星次数
        local var_6_int = np:readInt( ) --剩余任务次数
        PacketDispatcher:dispather( 139, 37, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int )--分发数据
    end,

    --发送复活对话框（不能原地复活的）
    --接收服务器
    [39] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --复活点复活等待时间
        local var_2_string = np:readString( ) --击杀者名字
        PacketDispatcher:dispather( 139, 39, var_1_unsigned_char, var_2_string )--分发数据
    end,

    --发送复活对话框
    --接收服务器
    [40] = function ( np )
        local var_1_int = np:readInt( ) --复活时间
        local var_2_int = np:readInt( ) --阵营id
        local var_3_int = np:readInt( ) --杀人者id
        local var_4_int = np:readInt( ) --宠物id--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_int = np:readInt( ) --杀人者等级
        local var_6_int = np:readInt( ) --杀人者性别
        local var_7_int = np:readInt( ) --杀人者职业
        local var_8_string = np:readString( ) --杀人者名字
        local var_9_string = np:readString( ) --主人的名字
        local var_10_int = np:readInt( ) --原地复活等待时间
        PacketDispatcher:dispather( 139, 40, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_string, var_9_string, var_10_int )--分发数据
    end,

    --渡劫_下发渡劫结果
    --接收服务器
    [42] = function ( np )
        local var_1_int = np:readInt( ) --第几章
        local var_2_unsigned_int = np:readUInt( ) --第几层
        local var_3_int = np:readInt( ) --副本剩余时间
        local var_4_unsigned_int = np:readUInt( ) --剩余怪物数
        PacketDispatcher:dispather( 139, 42, var_1_int, var_2_unsigned_int, var_3_int, var_4_unsigned_int )--分发数据
    end,

    --渡劫失败
    --接收服务器
    [43] = function ( np )
        PacketDispatcher:dispather( 139, 43 )--分发数据
    end,

    --接受刷星任务结果
    --接收服务器
    [45] = function ( np )
        local var_1_int = np:readInt( ) --刷星任务类型id
        local var_2_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 45, var_1_int, var_2_int )--分发数据
    end,

    --下发赏金怪物得到的金钱
    --接收服务器
    [46] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --怪物handle
        local var_2_int = np:readInt( ) --怪物基础金钱
        local var_3_int = np:readInt( ) --所得的全部金钱
        PacketDispatcher:dispather( 139, 46, var_1_unsigned_int64, var_2_int, var_3_int )--分发数据
    end,

    --通知天元城之权的仙宗成员去领取奖励
    --接收服务器
    [48] = function ( np )
        PacketDispatcher:dispather( 139, 48 )--分发数据
    end,

    --今天剩余免费速传次数
    --接收服务器
    [49] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 49, var_1_int )--分发数据
    end,

    --进入战场结果
    --接收服务器
    [51] = function ( np )
        local var_1_int = np:readInt( ) --战场id
        local var_2_int = np:readInt( ) --结果代码--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_string = np:readString( ) --错误信息
        PacketDispatcher:dispather( 139, 51, var_1_int, var_2_int, var_3_string )--分发数据
    end,

    --领取阵营战奖励结果
    --接收服务器
    [53] = function ( np )
        local var_1_int = np:readInt( ) --第几战场
        local var_2_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_string = np:readString( ) --结果提示，错误时返回的错误提示
        PacketDispatcher:dispather( 139, 53, var_1_int, var_2_int, var_3_string )--分发数据
    end,

    --发送阵营战战场个数
    --接收服务器
    [55] = function ( np )
        local var_1_int = np:readInt( ) --个数
        PacketDispatcher:dispather( 139, 55, var_1_int )--分发数据
    end,

    --阵营战结束后发送排行信息（结构和52一样）
    --接收服务器
    [56] = function ( np )
        PacketDispatcher:dispather( 139, 56 )--分发数据
    end,

    --结盟阵营信息
    --接收服务器
    [57] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --阵营1--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --阵营2--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --阵营3--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 57, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --返回戏水和泡泡次数
    --接收服务器
    [60] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --剩余打泡泡次数
        local var_2_unsigned_int = np:readUInt( ) --剩余戏水次数
        PacketDispatcher:dispather( 139, 60, var_1_unsigned_int, var_2_unsigned_int )--分发数据
    end,

    --仙浴活动
    --接收服务器
    [59] = function ( np )
        local var_1_int = np:readInt( ) --类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int64 = np:readInt64( ) --目标玩家的handle--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 59, var_1_int, var_2_int, var_3_int64 )--分发数据
    end,

    --发送增加蟠桃采集次数需要的元宝
    --接收服务器
    [62] = function ( np )
        local var_1_int = np:readInt( ) --已经使用的次数
        local var_2_int = np:readInt( ) --下次需要的元宝数
        PacketDispatcher:dispather( 139, 62, var_1_int, var_2_int )--分发数据
    end,

    --剩余VIP体验时间
    --接收服务器
    [65] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 139, 65, var_1_int )--分发数据
    end,

    --通知领取天元之战奖励
    --接收服务器
    [66] = function ( np )
        PacketDispatcher:dispather( 139, 66 )--分发数据
    end,

    --播放获取经验特效
    --接收服务器
    [68] = function ( np )
        local var_1_int = np:readInt( ) --获取经验数
        PacketDispatcher:dispather( 139, 68, var_1_int )--分发数据
    end,

    --发送当前世界等级
    --接收服务器
    [69] = function ( np )
        local var_1_int = np:readInt( ) --世界等级--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 69, var_1_int )--分发数据
    end,

    --八卦地宫刷新BOSS的时间
    --接收服务器
    [73] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 139, 73, var_1_int )--分发数据
    end,

    --进入八卦地宫
    --接收服务器
    [74] = function ( np )
        PacketDispatcher:dispather( 139, 74 )--分发数据
    end,

    --退出八卦地宫
    --接收服务器
    [75] = function ( np )
        PacketDispatcher:dispather( 139, 75 )--分发数据
    end,

    --经验找回领取需要消耗元宝数
    --接收服务器
    [77] = function ( np )
        local var_1_int = np:readInt( ) --元宝数
        PacketDispatcher:dispather( 139, 77, var_1_int )--分发数据
    end,

    --下发双旦充值回馈信息
    --接收服务器
    [79] = function ( np )
        local var_1_int = np:readInt( ) --活动期间累计充值
        local var_2_int = np:readInt( ) --下一级奖励金额
        local var_3_int = np:readInt( ) --当前返利率
        local var_4_int = np:readInt( ) --下一级返利率
        PacketDispatcher:dispather( 139, 79, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --下发双旦副本剩余次数
    --接收服务器
    [81] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        PacketDispatcher:dispather( 139, 81, var_1_int )--分发数据
    end,

    --通知客户端弹出版本更新
    --接收服务器
    [82] = function ( np )
        PacketDispatcher:dispather( 139, 82 )--分发数据
    end,

    --身份证验证结果
    --接收服务器
    [83] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 83, var_1_unsigned_char )--分发数据
    end,

    --强制弹出填写身份证界面
    --接收服务器
    [84] = function ( np )
        PacketDispatcher:dispather( 139, 84 )--分发数据
    end,

    --显示或隐藏限时商店图标
    --接收服务器
    [88] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --显示或隐藏--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 88, var_1_unsigned_char )--分发数据
    end,

    --更新限时神秘商店的刷新剩余时间
    --接收服务器
    [89] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间（秒）
        PacketDispatcher:dispather( 139, 89, var_1_int )--分发数据
    end,

    --下发充值的token和url
    --接收服务器
    [91] = function ( np )
        local var_1_int = np:readInt( ) --结果，0：成功， 其他为错误码
        local var_2_string = np:readString( ) --token
        local var_3_string = np:readString( ) --url，参考协议31,1
        PacketDispatcher:dispather( 139, 91, var_1_int, var_2_string, var_3_string )--分发数据
    end,

    --返回最少人数的职业
    --接收服务器
    [95] = function ( np )
        local var_1_int = np:readInt( ) --职业ID，1-4
        PacketDispatcher:dispather( 139, 95, var_1_int )--分发数据
    end,

    --下发投资基金系统图标状态
    --接收服务器
    [111] = function ( np )
        local var_1_char = np:readChar( ) --图标显示状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --是否已购买投资基金--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --活动开启时间
        PacketDispatcher:dispather( 139, 111, var_1_char, var_2_char, var_3_int )--分发数据
    end,

    --衣柜_幻化结果
    --接收服务器
    [120] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0失败，1成功
        local var_2_int = np:readInt( ) --当前幻化时装id
        PacketDispatcher:dispather( 139, 120, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --（废弃）鱼乐无穷_图标显示
    --接收服务器
    [123] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --display_type显示类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 123, var_1_unsigned_char )--分发数据
    end,

    --（废弃）鱼乐无穷_捕鱼结果
    --接收服务器
    [125] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --鱼的id
        PacketDispatcher:dispather( 139, 125, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --（废弃）下发开心答题活动状态
    --接收服务器
    [178] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1开启，0结束，2倒计时
        local var_2_int = np:readInt( ) --剩余时间
        PacketDispatcher:dispather( 139, 178, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --（废弃）通知可以选择答案
    --接收服务器
    [180] = function ( np )
        local var_1_char = np:readChar( ) --第几个题目
        local var_2_int = np:readInt( ) --剩余答题时间
        PacketDispatcher:dispather( 139, 180, var_1_char, var_2_int )--分发数据
    end,

    --（废弃）玩家选择答案结果
    --接收服务器
    [181] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几题
        local var_2_unsigned_char = np:readByte( ) --玩家选择的答案下标
        local var_3_unsigned_char = np:readByte( ) --正确答案的答案下标
        local var_4_unsigned_char = np:readByte( ) --是否是一击必中
        PacketDispatcher:dispather( 139, 181, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char )--分发数据
    end,

    --（废弃）下发正确答案
    --接收服务器
    [182] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个题目
        local var_2_unsigned_char = np:readByte( ) --正确答案下标
        local var_3_int = np:readInt( ) --剩余查看答案时间
        PacketDispatcher:dispather( 139, 182, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --（废弃）去掉两个错误答案
    --接收服务器
    [184] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --第几个题目
        local var_2_unsigned_char = np:readByte( ) --错误答案1
        local var_3_unsigned_char = np:readByte( ) --错误答案2
        PacketDispatcher:dispather( 139, 184, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --（废弃）通知客户端全部题目答题结束
    --接收服务器
    [187] = function ( np )
        PacketDispatcher:dispather( 139, 187 )--分发数据
    end,

    --（废弃）下发玩家答题情况
    --接收服务器
    [188] = function ( np )
        local var_1_int = np:readInt( ) --玩家目前文采
        local var_2_unsigned_char = np:readByte( ) --玩家答对题数
        local var_3_unsigned_char = np:readByte( ) --剩余答题数
        PacketDispatcher:dispather( 139, 188, var_1_int, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --天元之战奖励下发(临时)
    --接收服务器
    [189] = function ( np )
        local var_1_char = np:readChar( ) --奖励是否可以领取--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --帮派成员类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_char = np:readChar( ) --天元之战的奖励领取状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --积分
        local var_5_int = np:readInt( ) --个人排名
        local var_6_int = np:readInt( ) --帮派排名
        local var_7_int = np:readInt( ) --帮派里的个人排名
        local var_8_int = np:readInt( ) --经验
        local var_9_int = np:readInt( ) --仙宗贡献
        local var_10_int = np:readInt( ) --声望
        local var_11_char = np:readChar( ) --奖励物品数目--s本参数存在特殊说明，请查阅协议编辑器
        local var_12_int = np:readInt( ) --物品id
        PacketDispatcher:dispather( 139, 189, var_1_char, var_2_char, var_3_char, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int, var_9_int, var_10_int, var_11_char, var_12_int )--分发数据
    end,

    --帮派战奖励领取状态(临时)
    --接收服务器
    [192] = function ( np )
        local var_1_char = np:readChar( ) --领取状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 192, var_1_char )--分发数据
    end,

    --天元之战结果
    --接收服务器
    [190] = function ( np )
        local var_1_int = np:readInt( ) --帮派是否胜利--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 190, var_1_int )--分发数据
    end,

    --请求打开老虎机界面
    --接收服务器
    [195] = function ( np )
        PacketDispatcher:dispather( 139, 195 )--分发数据
    end,

    --下发欢乐挂机副本状态
    --接收服务器
    [171] = function ( np )
        local var_1_int = np:readInt( ) --状态，0准备，1开始，2结束
        local var_2_int = np:readInt( ) --倒计时时间
        PacketDispatcher:dispather( 139, 171, var_1_int, var_2_int )--分发数据
    end,

    --提示有阵营战奖励未领取
    --接收服务器
    [174] = function ( np )
        PacketDispatcher:dispather( 139, 174 )--分发数据
    end,

    --赏金游戏一键拾取成功
    --接收服务器
    [194] = function ( np )
        PacketDispatcher:dispather( 139, 194 )--分发数据
    end,

    --关闭帮派战领取奖励按钮
    --接收服务器
    [169] = function ( np )
        PacketDispatcher:dispather( 139, 169 )--分发数据
    end,

    --关闭阵营战领取奖励按钮
    --接收服务器
    [170] = function ( np )
        PacketDispatcher:dispather( 139, 170 )--分发数据
    end,

    --秘境夺宝BOSS是否存在
    --接收服务器
    [200] = function ( np )
        local var_1_int = np:readInt( ) --0：表示BOSS不存在，1：表示BOSS存在
        PacketDispatcher:dispather( 139, 200, var_1_int )--分发数据
    end,

    --通知第二周运营活动状态
    --接收服务器
    [202] = function ( np )
        local var_1_int = np:readInt( ) --活动剩余时间，如果是0则活动没开启
        PacketDispatcher:dispather( 139, 202, var_1_int )--分发数据
    end,

    --服务端下发圣诞副本活动状态
    --接收服务器
    [207] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --活动剩余时间，如果不在副本活动剩余时间内，则为0
        PacketDispatcher:dispather( 139, 207, var_1_unsigned_int )--分发数据
    end,

    --服务端下发中秋活动状态
    --接收服务器
    [208] = function ( np )
        local var_1_int = np:readInt( ) --0表示活动结束，非0表示活动开启
        PacketDispatcher:dispather( 139, 208, var_1_int )--分发数据
    end,

    --服务端下发玩家的月饼和元宝数目
    --接收服务器
    [209] = function ( np )
        local var_1_int = np:readInt( ) --元宝数目
        local var_2_int = np:readInt( ) --月饼数目
        PacketDispatcher:dispather( 139, 209, var_1_int, var_2_int )--分发数据
    end,

    --服务端下发玩家抽取珍品的信息
    --接收服务器
    [210] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --记录条数，最多6条
        local var_2_string = np:readString( ) --玩家名字
        local var_3_string = np:readString( ) --物品名字
        PacketDispatcher:dispather( 139, 210, var_1_unsigned_char, var_2_string, var_3_string )--分发数据
    end,

    --服务端下发最新的一条珍品记录
    --接收服务器
    [211] = function ( np )
        local var_1_string = np:readString( ) --玩家名字
        local var_2_string = np:readString( ) --物品名字
        PacketDispatcher:dispather( 139, 211, var_1_string, var_2_string )--分发数据
    end,

    --下发中秋抽奖抽取的物品索引
    --接收服务器
    [212] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1-12，1表示配置必表里的第一个物品，以此类推
        local var_2_unsigned_char = np:readByte( ) --抽取次数
        PacketDispatcher:dispather( 139, 212, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --通知国庆活动状态
    --接收服务器
    [215] = function ( np )
        local var_1_int = np:readInt( ) --通知活动剩余时间 如果为0表示活动未开启
        local var_2_char = np:readChar( ) --用来标记是否采用新配置--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 215, var_1_int, var_2_char )--分发数据
    end,

    --发送护镖失败的相关信息
    --接收服务器
    [217] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --被劫镖车星级
        local var_2_int = np:readInt( ) --劫镖人ID
        local var_3_string = np:readString( ) --劫镖人名字
        PacketDispatcher:dispather( 139, 217, var_1_unsigned_char, var_2_int, var_3_string )--分发数据
    end,

    --热血押镖-控制继续护镖的协议
    --接收服务器
    [218] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --open，开/关，0表示关，1表示打开--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --used_times，已经接受过的此任务的次数
        local var_3_unsigned_char = np:readByte( ) --all_times，此任务允许一天内接受的总次数
        local var_4_unsigned_char = np:readByte( ) --id，刷星的任务编号，从1开始
        local var_5_unsigned_char = np:readByte( ) --grade，根据用户的级别进行的分类，从1开始
        local var_6_unsigned_char = np:readByte( ) --star，用户接受的任务星级，从1开始
        local var_7_int = np:readInt( ) --总时间
        local var_8_int = np:readInt( ) --剩余时间
        local var_9_unsigned_int64 = np:readUint64( ) --镖车handle
        local var_10_unsigned_char = np:readByte( ) --镖车状态，0是行动中，1是停止
        PacketDispatcher:dispather( 139, 218, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_int, var_8_int, var_9_unsigned_int64, var_10_unsigned_char )--分发数据
    end,

    --热血护镖-护镖者已达镖车
    --接收服务器
    [219] = function ( np )
        PacketDispatcher:dispather( 139, 219 )--分发数据
    end,

    --下发投资理财活动期间总的元宝数
    --接收服务器
    [220] = function ( np )
        local var_1_int = np:readInt( ) --活动期间充值元宝数目
        PacketDispatcher:dispather( 139, 220, var_1_int )--分发数据
    end,

    --下发圣诞节抽取到的许愿奖励档次
    --接收服务器
    [221] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --奖励档次，从1开始
        PacketDispatcher:dispather( 139, 221, var_1_unsigned_char )--分发数据
    end,

    --（万圣节）下发玩家充值奖励信息
    --接收服务器
    [222] = function ( np )
        local var_1_int = np:readInt( ) --玩家已经充值元宝数目
        local var_2_unsigned_char = np:readByte( ) --玩家的奖励领取状态，每一位表示每个奖励的领取状态。0：表示未领取，1：表示已经领取
        PacketDispatcher:dispather( 139, 222, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --热血护镖-劫镖成功后下发奖励提示
    --接收服务器
    [224] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，玩家今日的劫镖次数
        local var_2_unsigned_int = np:readUInt( ) --银两数量
        local var_3_unsigned_int = np:readUInt( ) --帮贡数量
        PacketDispatcher:dispather( 139, 224, var_1_unsigned_char, var_2_unsigned_int, var_3_unsigned_int )--分发数据
    end,

    --下发光棍节奖励信息
    --接收服务器
    [227] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0：表示没有领取，1：表示已经领取
        PacketDispatcher:dispather( 139, 227, var_1_unsigned_char )--分发数据
    end,

    --下发幸运轮盘活动状态
    --接收服务器
    [228] = function ( np )
        local var_1_int = np:readInt( ) --下发活动剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --配置类型
        PacketDispatcher:dispather( 139, 228, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --超值优惠系统-下发物品信息
    --接收服务器
    [229] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --type，购买类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --index, 物品索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_char = np:readByte( ) --count, 该物品对与该玩家的限购数量
        PacketDispatcher:dispather( 139, 229, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --超值优惠系统-控制活动开关
    --接收服务器
    [230] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --command, 命令--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --StartTime, 开始时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_int = np:readUInt( ) --EndTime, 结束时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_unsigned_int = np:readUInt( ) --LeftTime, 剩余时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 230, var_1_unsigned_char, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int )--分发数据
    end,

    --世界BOSS法海已经刷出
    --接收服务器
    [231] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0：表示法海不在，1：表示法海在
        PacketDispatcher:dispather( 139, 231, var_1_unsigned_char )--分发数据
    end,

    --下发彩蛋活动状态
    --接收服务器
    [232] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间，0为结束
        local var_2_unsigned_char = np:readByte( ) --是否新服配置，1是0否
        PacketDispatcher:dispather( 139, 232, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --下发限时消费活动状态
    --接收服务器
    [236] = function ( np )
        local var_1_int = np:readInt( ) --下发活动状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 236, var_1_int )--分发数据
    end,

    --下发活动数据
    --接收服务器
    [237] = function ( np )
        local var_1_int = np:readInt( ) --消费元宝数
        local var_2_int = np:readInt( ) --可以领取的礼包个数
        PacketDispatcher:dispather( 139, 237, var_1_int, var_2_int )--分发数据
    end,

    --下发翻牌的活动状态
    --接收服务器
    [239] = function ( np )
        local var_1_int = np:readInt( ) --发送剩余活动时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 139, 239, var_1_int )--分发数据
    end,

    --下发爱心数量和可以领取的礼包数量
    --接收服务器
    [240] = function ( np )
        local var_1_int = np:readInt( ) --爱心个数
        local var_2_int = np:readInt( ) --可以领取的礼包个数
        PacketDispatcher:dispather( 139, 240, var_1_int, var_2_int )--分发数据
    end,

    --剧情模拟_通知客户端播放剧情
    --接收服务器
    [242] = function ( np )
        local var_1_int = np:readInt( ) --fbid,副本id
        local var_2_unsigned_char = np:readByte( ) --index,剧情索引
        PacketDispatcher:dispather( 139, 242, var_1_int, var_2_unsigned_char )--分发数据
    end,

    --通知客户端刷新神秘商人界面
    --接收服务器
    [244] = function ( np )
        local var_1_char = np:readChar( ) --商店的ID
        PacketDispatcher:dispather( 139, 244, var_1_char )--分发数据
    end,

    --圣诞活动BOSS杀死后通知客户端弹出“奖”
    --接收服务器
    [249] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --BOSS等级， 从1开始
        PacketDispatcher:dispather( 139, 249, var_1_unsigned_char )--分发数据
    end,

    --新美女理财-下发投资基金系统图标状态
    --接收服务器
    [252] = function ( np )
        local var_1_char = np:readChar( ) --图标显示状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --是否已购买投资基金--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --活动开启时间
        PacketDispatcher:dispather( 139, 252, var_1_char, var_2_char, var_3_int )--分发数据
    end,

    --新美女理财-下发投资理财活动期间总的元宝数
    --接收服务器
    [254] = function ( np )
        local var_1_int = np:readInt( ) --活动期间充值元宝数目
        PacketDispatcher:dispather( 139, 254, var_1_int )--分发数据
    end,

    --圣诞节许愿结果
    --接收服务器
    [250] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --许愿物品ID，如果没有许愿则为0
        local var_2_unsigned_int = np:readUInt( ) --活动剩余时间(秒),活动结束则为0
        PacketDispatcher:dispather( 139, 250, var_1_unsigned_int, var_2_unsigned_int )--分发数据
    end,

    --提示玩家获得临时体验神级技能
    --接收服务器
    [255] = function ( np )
        PacketDispatcher:dispather( 139, 255 )--分发数据
    end,

    --渡劫_下发非首次通关一层协议
    --接收服务器
    [132] = function ( np )
        PacketDispatcher:dispather( 139, 132 )--分发数据
    end,

    --轮盘副本_广播轮盘抽奖开始
    --接收服务器
    [133] = function ( np )
        local var_1_int = np:readInt( ) --当前回合可操作的玩家的ID
        local var_2_string = np:readString( ) --当前回合可操作玩家名称
        PacketDispatcher:dispather( 139, 133, var_1_int, var_2_string )--分发数据
    end,

    --轮盘副本_广播抽奖结果
    --接收服务器
    [134] = function ( np )
        local var_1_char = np:readChar( ) --内圈随机结果
        local var_2_char = np:readChar( ) --外圈随机结果
        PacketDispatcher:dispather( 139, 134, var_1_char, var_2_char )--分发数据
    end,

    --服务端下发刷新任务信息（诛天令，帮派）
    --接收服务器
    [38] = function ( np )
        local var_1_int = np:readInt( ) --刷星任务ID
        local var_2_int = np:readInt( ) --等级段
        local var_3_int = np:readInt( ) --星级
        local var_4_int = np:readInt( ) --任务ID
        local var_5_int = np:readInt( ) --任务状态
        local var_6_int = np:readInt( ) --剩余任务次数
        PacketDispatcher:dispather( 139, 38, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int )--分发数据
    end,

    --新版播放物品资源特效（同67）
    --接收服务器
    [71] = function ( np )
        PacketDispatcher:dispather( 139, 71 )--分发数据
    end,


}
