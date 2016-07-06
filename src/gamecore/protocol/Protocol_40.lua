protocol_func_map_client[40] = {
    --查看自己或其他人的翅膀信息
    --客户端发送
    [1] = function ( 
                param_1_int,  -- 玩家ID--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 1 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --（已废弃）升级翅膀
    --客户端发送
    [2] = function ( 
                param_1_int -- 是否自动购买材料，1是0否
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 2 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --提升阶值
    --客户端发送
    [3] = function ( 
                param_1_unsigned_int64,  -- 翅膀的guid
                param_2_unsigned_char -- autoBuy，0:不自动购买，1:自动购买
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 3 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --化形
    --客户端发送
    [4] = function ( 
                param_1_int -- 选择的哪个阶的外观
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 4 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --领取翅膀
    --客户端发送
    [5] = function ( 
                param_1_char -- 领取类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 5 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --（已废弃）升级翅膀技能
    --客户端发送
    [6] = function ( 
                param_1_int,  -- 升的是哪个技能--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int -- 是否自动购买材料，1是0否
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 6 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --翅膀转换进阶丹
    --客户端发送
    [7] = function ( 
                param_1_unsigned_int64 -- 背包里翅膀的guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 7 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --翅膀技能-学习技能
    --客户端发送
    [8] = function ( 
                param_1_int64 -- 技能书guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 8 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --客户端请求翅膀战力比拼信息
    --客户端发送
    [17] = function ( 
                param_1_int,  -- 玩家id
                param_2_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 17 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --穿上装备
    --客户端发送
    [18] = function ( 
                param_1_unsigned_int64 -- 装备guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 18 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --脱下装备
    --客户端发送
    [19] = function ( 
                param_1_unsigned_int64 -- 装备guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 19 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --初始化-客户端第一次打开界面
    --客户端发送
    [25] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 40, 25 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[40] = {
    --（已废弃）升级翅膀结果
    --接收服务器
    [2] = function ( np )
        local var_1_char = np:readChar( ) --升级结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --等级
        local var_3_int = np:readInt( ) --祝福值
        PacketDispatcher:dispather( 40, 2, var_1_char, var_2_int, var_3_int )--分发数据
    end,

    --提升阶值
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --进阶结果--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_char = np:readChar( ) --stage，进阶后的阶值
        local var_3_int = np:readInt( ) --blessValue，祝福值
        local var_4_int = np:readInt( ) --clearTime，祝福值清空倒计时，单位秒
        local var_5_int = np:readInt( ) --addValue，普通增加的祝福值
        local var_6_int = np:readInt( ) --vipAddValue，VIP额外增加的祝福值
        PacketDispatcher:dispather( 40, 3, var_1_unsigned_char, var_2_char, var_3_int, var_4_int, var_5_int, var_6_int )--分发数据
    end,

    --评分
    --接收服务器
    [6] = function ( np )
        local var_1_int = np:readInt( ) --评分
        PacketDispatcher:dispather( 40, 6, var_1_int )--分发数据
    end,

    --化形结果
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --翅膀模型id--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 40, 4, var_1_int )--分发数据
    end,

    --技能熟练度改变
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --5个熟练度--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 40, 8, var_1_int )--分发数据
    end,

    --（已废弃）升级翅膀技能结果
    --接收服务器
    [9] = function ( np )
        local var_1_char = np:readChar( ) --是否暴击--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --增加经验值
        PacketDispatcher:dispather( 40, 9, var_1_char, var_2_int )--分发数据
    end,

    --是否已经领过普通翅膀
    --接收服务器
    [10] = function ( np )
        local var_1_char = np:readChar( ) --是否已经领过普通翅膀--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 40, 10, var_1_char )--分发数据
    end,

    --倒计时清空-祝福值发生了变化
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --blessValue，祝福值
        local var_2_int = np:readInt( ) --clearTime，祝福值清空倒计时
        PacketDispatcher:dispather( 40, 11, var_1_int, var_2_int )--分发数据
    end,

    --翅膀技能-学习技能返回
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --技能类型，1：固定，2：非固定
        local var_2_unsigned_char = np:readByte( ) --index，技能所在的格子从1开始
        local var_3_unsigned_short = np:readWord( ) --skillId
        local var_4_unsigned_short = np:readWord( ) --skillLevel
        local var_5_unsigned_char = np:readByte( ) --haveNum，学习技能之后拥有的技能数量
        PacketDispatcher:dispather( 40, 12, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_short, var_5_unsigned_char )--分发数据
    end,

    --通知客户端第一次领取翅膀成功
    --接收服务器
    [13] = function ( np )
        PacketDispatcher:dispather( 40, 13 )--分发数据
    end,

    --是否已经领取过元宝翅膀
    --接收服务器
    [14] = function ( np )
        local var_1_char = np:readChar( ) --是否已经领取过元宝翅膀--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 40, 14, var_1_char )--分发数据
    end,

    --下发幻羽灵丹信息
    --接收服务器
    [15] = function ( np )
        local var_1_int = np:readInt( ) --幻羽仙丹剩余使用次数
        local var_2_int = np:readInt( ) --仙丹增幅（万分，1000表示10%）
        local var_3_int = np:readInt( ) --灵丹可使用的总次数
        local var_4_int = np:readInt( ) --灵丹已使用的次数
        PacketDispatcher:dispather( 40, 15, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --是否完成图标显示任务
    --接收服务器
    [16] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0:未完成，1:已完成
        PacketDispatcher:dispather( 40, 16, var_1_unsigned_char )--分发数据
    end,

    --穿上装备
    --接收服务器
    [18] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备guid
        PacketDispatcher:dispather( 40, 18, var_1_unsigned_int64 )--分发数据
    end,

    --脱下装备
    --接收服务器
    [19] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备guid
        PacketDispatcher:dispather( 40, 19, var_1_unsigned_int64 )--分发数据
    end,

    --下发翅膀体验信息
    --接收服务器
    [21] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --预体验index
        local var_2_int = np:readInt( ) --剩余时间
        local var_3_int = np:readInt( ) --阶段
        PacketDispatcher:dispather( 40, 21, var_1_unsigned_char, var_2_int, var_3_int )--分发数据
    end,

    --化形-一个特殊翅膀状态改变
    --接收服务器
    [24] = function ( np )
        local var_1_int = np:readInt( ) --modelId，改变模型Id
        local var_2_unsigned_char = np:readByte( ) --state，0:未激活，1:激活，2:已过期
        local var_3_int = np:readInt( ) --leftTime，剩余时间
        PacketDispatcher:dispather( 40, 24, var_1_int, var_2_unsigned_char, var_3_int )--分发数据
    end,


}
