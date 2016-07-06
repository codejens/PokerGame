protocol_func_map_client[19] = {
    --切换角色的上马、下马状态
    --客户端发送
    [1] = function ( 
                param_1_bool -- true表示上马，false表示下马
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_bool, lua_type = "boolean" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 1 ) 
        np:writeChar( param_1_bool )
        NetManager:send_packet( np )
    end,

    --（已经废弃）玩家进行坐骑进阶
    --客户端发送
    [4] = function ( 
                param_1_unsigned_char,  -- autoBuy, 0:道具不足不自动购买，1:道具不足自动购买
                param_2_unsigned_char -- autoJinjie, 0:不自动进阶，1:自动进阶
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 4 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --新坐骑-化形
    --客户端发送
    [9] = function ( 
                param_1_int -- 要化形的模型Id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 9 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --查看其他玩家的坐骑信息，结果用消息1下发
    --客户端发送
    [12] = function ( 
                param_1_int,  -- 角色id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 角色名称
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 12 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --穿上一个装备
    --客户端发送
    [10] = function ( 
                param_1_int64 -- guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 10 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --脱下装备
    --客户端发送
    [11] = function ( 
                param_1_int64 -- guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 11 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --（已经废弃）请求培养的相关数据
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 13 ) 
        NetManager:send_packet( np )
    end,

    --（已经废弃）坐骑培养操作
    --客户端发送
    [14] = function ( 
                param_1_int -- 培养类型--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 14 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --（已经废弃）客户端确认激活幻化道具，玩家点击确认激活
    --客户端发送
    [15] = function ( 
                param_1_int -- 幻化道具ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 15 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --（已经废弃）客户端请求激活道具，点击激活时发送
    --客户端发送
    [16] = function ( 
                param_1_unsigned_char,  -- 对应的幻化模型的ID,从51开始
                param_2_int -- 道具ID，与幻化模型ID对应
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 16 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --（已经废弃）使用坐骑代金卡时请求购买道具
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 17 ) 
        NetManager:send_packet( np )
    end,

    --新坐骑-客户端请求祝福值清空剩余时间
    --客户端发送
    [18] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 18 ) 
        NetManager:send_packet( np )
    end,

    --新坐骑-客户端进行坐骑进阶
    --客户端发送
    [19] = function ( 
                param_1_unsigned_char -- autoBuy, 0:道具不足不自动购买，1:道具不足自动购买
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 19 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --新坐骑-查询下阶坐骑增量评分
    --客户端发送
    [20] = function ( 
                param_1_int -- stage
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 20 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --新坐骑-学习技能
    --客户端发送
    [21] = function ( 
                param_1_int64 -- 技能书guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 21 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --初始化-客户端第一次打开界面
    --客户端发送
    [22] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 22 ) 
        NetManager:send_packet( np )
    end,

    --坐骑三阶大礼包使用
    --客户端发送
    [26] = function ( 
                param_1_int64 -- guid,礼包ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 19, 26 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[19] = {
    --（已经废弃）阶值改变
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --当前阶
        local var_2_int = np:readInt( ) --阶值（经验）
        local var_3_int = np:readInt( ) --今天仙币进阶剩余的次数
        PacketDispatcher:dispather( 19, 4, var_1_int, var_2_int, var_3_int )--分发数据
    end,

    --新坐骑-化形的结果
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --当前的外观，不是指外观id，是指哪个阶
        PacketDispatcher:dispather( 19, 9, var_1_int )--分发数据
    end,

    --脱下装备
    --接收服务器
    [11] = function ( np )
        local var_1_int64 = np:readInt64( ) --guid
        PacketDispatcher:dispather( 19, 11, var_1_int64 )--分发数据
    end,

    --装备一个装备
    --接收服务器
    [10] = function ( np )
        local var_1_int64 = np:readInt64( ) --guid
        PacketDispatcher:dispather( 19, 10, var_1_int64 )--分发数据
    end,

    --（已经废弃）服务端下发特殊幻化坐骑形象列表
    --接收服务器
    [15] = function ( np )
        local var_1_char = np:readChar( ) --幻化坐骑列表长度
        local var_2_char = np:readChar( ) --坐骑幻化形象ID
        local var_3_char = np:readChar( ) --是否激活，0表示未激活，1表示激活
        local var_4_unsigned_int = np:readUInt( ) --过期时间，客户端需要根据这个数转换成年月日时的格式
        PacketDispatcher:dispather( 19, 15, var_1_char, var_2_char, var_3_char, var_4_unsigned_int )--分发数据
    end,

    --（已经废弃）告诉客户端是否有对应的幻化道具
    --接收服务器
    [16] = function ( np )
        local var_1_int = np:readInt( ) --0：表示没有；其他表示道具id
        PacketDispatcher:dispather( 19, 16, var_1_int )--分发数据
    end,

    --新坐骑-服务端返回祝福值清空剩余时间
    --接收服务器
    [18] = function ( np )
        local var_1_int = np:readInt( ) --剩余时间(单位秒)--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 19, 18, var_1_int )--分发数据
    end,

    --新坐骑-服务端下发玩家祝福值
    --接收服务器
    [19] = function ( np )
        local var_1_int = np:readInt( ) --玩家当前祝福值
        local var_2_int = np:readInt( ) --addValue，普通增加的祝福值，0表示没有变化
        local var_3_int = np:readInt( ) --vipAddValue，vip增加的祝福值，0表示没有变化
        local var_4_int = np:readInt( ) --buffAddValue，buff增加的祝福值，0表示没有变化
        PacketDispatcher:dispather( 19, 19, var_1_int, var_2_int, var_3_int, var_4_int )--分发数据
    end,

    --新坐骑-服务端下发进阶成功后的结果
    --接收服务器
    [20] = function ( np )
        local var_1_int = np:readInt( ) --stage，进阶成功后的阶值
        PacketDispatcher:dispather( 19, 20, var_1_int )--分发数据
    end,

    --新坐骑-应答增量评分
    --接收服务器
    [21] = function ( np )
        local var_1_int = np:readInt( ) --score
        PacketDispatcher:dispather( 19, 21, var_1_int )--分发数据
    end,

    --新坐骑-应答客户端进行坐骑进阶（19,c）
    --接收服务器
    [23] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --服务端进阶结果--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 19, 23, var_1_unsigned_char )--分发数据
    end,

    --丹药-已使用的丹药数量
    --接收服务器
    [25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --type，药品类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --num，已使用的灵丹数量
        PacketDispatcher:dispather( 19, 25, var_1_unsigned_char, var_2_int )--分发数据
    end,

    --化形-一个特殊坐骑状态改变
    --接收服务器
    [26] = function ( np )
        local var_1_int = np:readInt( ) --modelId，改变模型Id
        local var_2_unsigned_char = np:readByte( ) --state，0:未激活，1:激活，2:已过期
        local var_3_int = np:readInt( ) --leftTime，剩余时间
        PacketDispatcher:dispather( 19, 26, var_1_int, var_2_unsigned_char, var_3_int )--分发数据
    end,

    --预体验-时间控制协议
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --isFirst，是否是第一次开启--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --type，体验类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --leftTime，剩余时间，单位秒--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 19, 27, var_1_unsigned_char, var_2_unsigned_char, var_3_int )--分发数据
    end,


}
