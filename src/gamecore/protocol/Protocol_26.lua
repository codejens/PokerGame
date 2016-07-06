protocol_func_map_client[26] = {
    --查看玩家的信息
    --客户端发送
    [1] = function ( 
                param_1_unsigned_int,  -- 玩家ID
                param_2_string -- 玩家的名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 1 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --客户端点击确定，退出游戏
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 2 ) 
        NetManager:send_packet( np )
    end,

    --玩家提交身份证号码（防沉迷）
    --客户端发送
    [20] = function ( 
                param_1_string,  -- 玩家真实姓名
                param_2_string -- 身份证号码
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 20 ) 
        np:writeString( param_1_string )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --请求排行榜数据
    --客户端发送
    [4] = function ( 
                param_1_string -- 排行榜的名称--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 4 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --获取服务器的时间
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 5 ) 
        NetManager:send_packet( np )
    end,

    --获取排行榜的信息（数据库）
    --客户端发送
    [21] = function ( 
                param_1_int,  -- 排行榜的id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int,  -- 当前第几页
                param_3_int -- 每页的数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 21 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --本人排行（数据库）
    --客户端发送
    [23] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 23 ) 
        NetManager:send_packet( np )
    end,

    --查看某个人的排行榜信息
    --客户端发送
    [22] = function ( 
                param_1_int,  -- 玩家id
                param_2_int,  -- 排行榜id
                param_3_int -- 宠物自增ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 22 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --开始（或中断）采集
    --客户端发送
    [24] = function ( 
                param_1_int64,  -- 采集怪的handle，如果是0，表示打断采集，后面的就不用发了
                param_2_int,  -- x坐标--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int,  -- y坐标
                param_4_int -- 朝向
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" }, { param_name = param_4_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 24 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        np:writeInt( param_4_int )
        NetManager:send_packet( np )
    end,

    --获取今天进入各个副本的次数
    --客户端发送
    [25] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 25 ) 
        NetManager:send_packet( np )
    end,

    --获取活跃奖励信息
    --客户端发送
    [26] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 26 ) 
        NetManager:send_packet( np )
    end,

    --领取活跃奖励
    --客户端发送
    [27] = function ( 
                param_1_int -- 获取第几个--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 27 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --播放了某个剧情
    --客户端发送
    [15] = function ( 
                param_1_int -- 剧情id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 15 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --世界BOSS-获取世界boss相关的数据 ,打开界面时获取一次
    --客户端发送
    [35] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 35 ) 
        NetManager:send_packet( np )
    end,

    --世界BOSS-获取单个boss的击杀者
    --客户端发送
    [37] = function ( 
                param_1_unsigned_char -- id，非怪物id，是WorldBoss配置表里面的id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 37 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --VIP用户用元宝增加进入副本的次数
    --客户端发送
    [38] = function ( 
                param_1_unsigned_short -- 副本id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 38 ) 
        np:writeWord( param_1_unsigned_short )
        NetManager:send_packet( np )
    end,

    --退出副本
    --客户端发送
    [33] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 33 ) 
        NetManager:send_packet( np )
    end,

    --改变称号显示状态
    --客户端发送
    [39] = function ( 
                param_1_int -- 显示标识--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 39 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --获取角色上坐骑后的速度
    --客户端发送
    [12] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 12 ) 
        NetManager:send_packet( np )
    end,

    --请求城主装备信息
    --客户端发送
    [40] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 40 ) 
        NetManager:send_packet( np )
    end,

    --提交黄钻的参数
    --客户端发送
    [43] = function ( 
                param_1_int,  -- 是否黄钻（0：不是； 1：是）。
                param_2_int,  -- 是否为年费黄钻用户（0：不是； 1：是）。
                param_3_int -- yellow_vip_level  黄钻等级，目前最高级别为黄钻8级
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 43 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --副本通关奖励-玩家进行抽奖
    --客户端发送
    [50] = function ( 
                param_1_unsigned_int,  -- fbId，此时是哪个副本通关后抽奖
                param_2_unsigned_char,  -- type，抽奖的类型--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- index，从0开始，表示第几张牌
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 50 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --副本通关奖励-客户端领取奖励
    --客户端发送
    [51] = function ( 
                param_1_unsigned_int -- fbId, 玩家刚通过的副本Id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 51 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --客户端请求第一排行榜面板信息
    --客户端发送
    [53] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 53 ) 
        NetManager:send_packet( np )
    end,

    --分线_进入
    --客户端发送
    [56] = function ( 
                param_1_unsigned_char -- 分线id，从1开始
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 56 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --副本通关奖励-再次进入副本
    --客户端发送
    [57] = function ( 
                param_1_int -- fbId
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 57 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-宠物比拼
    --客户端发送
    [58] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 58 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-坐骑比拼
    --客户端发送
    [59] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 59 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-装备比拼
    --客户端发送
    [62] = function ( 
                param_1_unsigned_int -- 对方玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 62 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-技能比拼
    --客户端发送
    [63] = function ( 
                param_1_unsigned_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 63 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-龙魂比拼
    --客户端发送
    [64] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 64 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --副本通关奖励-客户端请求首次通关标志
    --客户端发送
    [65] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 65 ) 
        NetManager:send_packet( np )
    end,

    --战力比拼-我要挑衅
    --客户端发送
    [66] = function ( 
                param_1_int,  -- 挑衅者的玩家id
                param_2_int,  -- 被挑衅的玩家id
                param_3_int -- 挑衅模块
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 66 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-神兵比拼
    --客户端发送
    [68] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 68 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-装备战力比拼
    --客户端发送
    [69] = function ( 
                param_1_int,  -- 玩家id
                param_2_int -- 系统id--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 69 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-法阵比拼
    --客户端发送
    [70] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 70 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-战灵比拼
    --客户端发送
    [71] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 71 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-仙遁比拼
    --客户端发送
    [72] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 72 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-影迹比拼
    --客户端发送
    [73] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 73 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --战力比拼-神护比拼
    --客户端发送
    [74] = function ( 
                param_1_int -- 玩家id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 26, 74 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[26] = {
    --开始填写防沉迷的资料
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0显示防沉迷图标，1弹出防沉迷填写
        PacketDispatcher:dispather( 26, 2, var_1_unsigned_char )--分发数据
    end,

    --弹出3小时的提示
    --接收服务器
    [3] = function ( np )
        PacketDispatcher:dispather( 26, 3 )--分发数据
    end,

    --弹出5小时的提示
    --接收服务器
    [4] = function ( np )
        PacketDispatcher:dispather( 26, 4 )--分发数据
    end,

    --排行榜数据改变，广播消息
    --接收服务器
    [5] = function ( np )
        PacketDispatcher:dispather( 26, 5 )--分发数据
    end,

    --下发服务器的时间
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --服务器的时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --服务器的开区时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_int = np:readUInt( ) --当前所在服开服天数
        local var_4_unsigned_int = np:readUInt( ) --连服时主服的开服天数
        local var_5_unsigned_int = np:readUInt( ) --原服所在服开服天数
        local var_6_int = np:readInt( ) --主服服务器ID,0代表未连服
        PacketDispatcher:dispather( 26, 8, var_1_unsigned_int, var_2_unsigned_int, var_3_unsigned_int, var_4_unsigned_int, var_5_unsigned_int, var_6_int )--分发数据
    end,

    --开始一个图文引导
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --图文引导的id
        PacketDispatcher:dispather( 26, 9, var_1_int )--分发数据
    end,

    --下发倒计时的时间
    --接收服务器
    [11] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --倒计时时间--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --byte，客户端已经写死，0:开始，1:结束
        local var_3_unsigned_char = np:readByte( ) --显示效果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 26, 11, var_1_unsigned_int, var_2_unsigned_char, var_3_unsigned_char )--分发数据
    end,

    --返回角色上坐骑后的速度
    --接收服务器
    [12] = function ( np )
        local var_1_int = np:readInt( ) --速度值
        PacketDispatcher:dispather( 26, 12, var_1_int )--分发数据
    end,

    --删除计分器
    --接收服务器
    [14] = function ( np )
        local var_1_int64 = np:readInt64( ) --计分器ID
        PacketDispatcher:dispather( 26, 14, var_1_int64 )--分发数据
    end,

    --玩家添加下属
    --接收服务器
    [16] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --下属句柄
        local var_2_char = np:readChar( ) --标记下属是否有目标点信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --目标场景Id
        local var_4_string = np:readString( ) --目标NPC名称
        PacketDispatcher:dispather( 26, 16, var_1_unsigned_int64, var_2_char, var_3_int, var_4_string )--分发数据
    end,

    --删除下属
    --接收服务器
    [17] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --下属句柄
        PacketDispatcher:dispather( 26, 17, var_1_unsigned_int64 )--分发数据
    end,

    --播放全屏特效
    --接收服务器
    [18] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --特效id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --特效持续时间，单位：秒
        PacketDispatcher:dispather( 26, 18, var_1_unsigned_short, var_2_int )--分发数据
    end,

    --播放全屏特效，与消息18的区别是，这个是代码实现的特效
    --接收服务器
    [19] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --特效id
        local var_2_int = np:readInt( ) --持续时间
        PacketDispatcher:dispather( 26, 19, var_1_unsigned_short, var_2_int )--分发数据
    end,

    --身份证的验证结果
    --接收服务器
    [20] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --错误码--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 26, 20, var_1_unsigned_char )--分发数据
    end,

    --采集状态变更
    --接收服务器
    [24] = function ( np )
        local var_1_int = np:readInt( ) --采集状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --采集的时间
        PacketDispatcher:dispather( 26, 24, var_1_int, var_2_int )--分发数据
    end,

    --下发今天已经拜神的次数
    --接收服务器
    [32] = function ( np )
        local var_1_int = np:readInt( ) --今天已经拜神的次数
        PacketDispatcher:dispather( 26, 32, var_1_int )--分发数据
    end,

    --通知客户端新的一天到来
    --接收服务器
    [27] = function ( np )
        PacketDispatcher:dispather( 26, 27 )--分发数据
    end,

    --触发一个活跃目标事件
    --接收服务器
    [30] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --活跃目标ID
        local var_2_unsigned_short = np:readWord( ) --总次数
        local var_3_int = np:readInt( ) --今天总的活跃度
        PacketDispatcher:dispather( 26, 30, var_1_unsigned_short, var_2_unsigned_short, var_3_int )--分发数据
    end,

    --领取活跃奖励结果
    --接收服务器
    [31] = function ( np )
        local var_1_int = np:readInt( ) --领取第几个奖励
        local var_2_int = np:readInt( ) --错误代码--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 26, 31, var_1_int, var_2_int )--分发数据
    end,

    --下发关闭统计窗口
    --接收服务器
    [34] = function ( np )
        PacketDispatcher:dispather( 26, 34 )--分发数据
    end,

    --发送今日进入某个副本次数信息
    --接收服务器
    [38] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --副本ID
        local var_2_unsigned_short = np:readWord( ) --今天进入次数
        local var_3_unsigned_short = np:readWord( ) --VIP用户今天用元宝增加的次数
        PacketDispatcher:dispather( 26, 38, var_1_unsigned_short, var_2_unsigned_short, var_3_unsigned_short )--分发数据
    end,

    --中断玩家挂机状态
    --接收服务器
    [39] = function ( np )
        PacketDispatcher:dispather( 26, 39 )--分发数据
    end,

    --通知其他玩家已经离线
    --接收服务器
    [41] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --玩家ID
        local var_2_string = np:readString( ) --玩家名字
        PacketDispatcher:dispather( 26, 41, var_1_unsigned_int, var_2_string )--分发数据
    end,

    --通知客户端排行榜已经刷新
    --接收服务器
    [42] = function ( np )
        PacketDispatcher:dispather( 26, 42 )--分发数据
    end,

    --通知客户端活动开始
    --接收服务器
    [43] = function ( np )
        local var_1_int = np:readInt( ) --活动ID
        PacketDispatcher:dispather( 26, 43, var_1_int )--分发数据
    end,

    --播放屏幕中央的特效
    --接收服务器
    [44] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --特效ID
        local var_2_int = np:readInt( ) --持续时间（秒）
        PacketDispatcher:dispather( 26, 44, var_1_unsigned_short, var_2_int )--分发数据
    end,

    --通知玩家副本结束(2014年5月30日已废弃)
    --接收服务器
    [32] = function ( np )
        local var_1_int = np:readInt( ) --副本ID
        local var_2_int = np:readInt( ) --副本剩余次数，-1表示不限制
        local var_3_bool = np:readChar( ) --是否通关
        local var_4_bool = np:readChar( ) --是否可花费元宝增加一次
        PacketDispatcher:dispather( 26, 32, var_1_int, var_2_int, var_3_bool, var_4_bool )--分发数据
    end,

    --世界boss被击杀
    --接收服务器
    [45] = function ( np )
        local var_1_string = np:readString( ) --弹开窗口后在窗口显示的文字
        PacketDispatcher:dispather( 26, 45, var_1_string )--分发数据
    end,

    --野外BOSS-野外BOSS倒计时2分钟提示
    --接收服务器
    [46] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --command, --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int = np:readUInt( ) --LeftTime--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 26, 46, var_1_unsigned_char, var_2_unsigned_int )--分发数据
    end,

    --野外BOSS-野外BOSS已经出现
    --接收服务器
    [47] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --command--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --monId--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 26, 47, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --是否跨服战的服务器
    --接收服务器
    [48] = function ( np )
        local var_1_int = np:readInt( ) --是否跨服战的服务器，0：否，1是
        PacketDispatcher:dispather( 26, 48, var_1_int )--分发数据
    end,

    --通知客户端锁屏
    --接收服务器
    [54] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --锁多久，秒为单位
        PacketDispatcher:dispather( 26, 54, var_1_unsigned_char )--分发数据
    end,

    --分线_分线信息
    --接收服务器
    [55] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --自己所在分线，从1开始
        local var_2_unsigned_char = np:readByte( ) --分线总数
        PacketDispatcher:dispather( 26, 55, var_1_unsigned_char, var_2_unsigned_char )--分发数据
    end,

    --分线_进入
    --接收服务器
    [56] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --cd时间
        PacketDispatcher:dispather( 26, 56, var_1_unsigned_int )--分发数据
    end,

    --战力比拼-宠物比拼
    --接收服务器
    [58] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --宠物进阶的战力
        local var_3_int = np:readInt( ) --宠物仙丹的战力
        local var_4_int = np:readInt( ) --宠物灵丹的战力
        local var_5_int = np:readInt( ) --宠物技能的战力
        PacketDispatcher:dispather( 26, 58, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --战力比拼-坐骑比拼
    --接收服务器
    [59] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --坐骑进阶的战力
        local var_3_int = np:readInt( ) --坐骑仙丹的战力
        local var_4_int = np:readInt( ) --坐骑灵丹的战力
        local var_5_int = np:readInt( ) --坐骑技能的战力
        PacketDispatcher:dispather( 26, 59, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int )--分发数据
    end,

    --战力比拼-装备比拼
    --接收服务器
    [62] = function ( np )
        local var_1_int = np:readInt( ) --对方装备战力总和（不统计强化、宝石、洗练）
        local var_2_int = np:readInt( ) --自己装备战力总和（不统计强化、宝石、洗练）
        local var_3_int = np:readInt( ) --对方装备强化后的战力总和-装备本身战力总和（不统计宝石、洗练）
        local var_4_int = np:readInt( ) --自己装备强化后的战力总和-装备本身战力总和（不统计宝石、洗练）
        local var_5_int = np:readInt( ) --对方所有装备镶嵌的宝石增加的战力总和
        local var_6_int = np:readInt( ) --自己所有装备镶嵌的宝石增加的战力总和
        local var_7_int = np:readInt( ) --对方装备洗练增加的战力总和
        local var_8_int = np:readInt( ) --自己装备洗练增加的战力总和
        PacketDispatcher:dispather( 26, 62, var_1_int, var_2_int, var_3_int, var_4_int, var_5_int, var_6_int, var_7_int, var_8_int )--分发数据
    end,

    --战力比拼-下发挑衅
    --接收服务器
    [66] = function ( np )
        local var_1_int = np:readInt( ) --发起挑衅的玩家id
        local var_2_string = np:readString( ) --挑衅者玩家名字
        local var_3_int = np:readInt( ) --挑衅的模块
        PacketDispatcher:dispather( 26, 66, var_1_int, var_2_string, var_3_int )--分发数据
    end,

    --战力比拼-下发玩家是否在线
    --接收服务器
    [67] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --被挑衅的玩家是否在线--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 26, 67, var_1_unsigned_char )--分发数据
    end,


}
