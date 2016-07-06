protocol_func_map_client[33] = {
    --获取使用的仙魂信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 1 ) 
        NetManager:send_packet( np )
    end,

    --获取玩家法宝信息
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 2 ) 
        NetManager:send_packet( np )
    end,

    --使用灵丹提升法宝星级
    --客户端发送
    [3] = function ( 
                param_1_unsigned_char,  -- 法宝id
                param_2_unsigned_char,  -- 灵丹类型，现固定传1--c本参数存在特殊说明，请查阅协议编辑器
                param_3_unsigned_char -- 是否勾选使用元宝--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 3 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --获取猎魂界面的仙魂信息
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 4 ) 
        NetManager:send_packet( np )
    end,

    --装备仙魂
    --客户端发送
    [5] = function ( 
                param_1_int -- 装备的仙魂的ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 5 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --卸下仙魂
    --客户端发送
    [6] = function ( 
                param_1_int -- 仙魂ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 6 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --炼魂
    --客户端发送
    [7] = function ( 
                param_1_int,  -- 猎魂师ID--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char -- 是否VIP元宝猎魂--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 7 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --一键炼魂
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 8 ) 
        NetManager:send_packet( np )
    end,

    --一键合成
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 9 ) 
        NetManager:send_packet( np )
    end,

    --开启仙魂槽
    --客户端发送
    [10] = function ( 
                param_1_int -- 开启槽位的个数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 10 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --吞噬仙魂
    --客户端发送
    [11] = function ( 
                param_1_unsigned_char,  -- 吞噬仙魂来源--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int,  -- 吞噬的仙魂ID
                param_3_unsigned_char,  -- 被吞噬仙魂来源--c本参数存在特殊说明，请查阅协议编辑器
                param_4_int -- 被吞噬的仙魂ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 11 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeByte( param_3_unsigned_char )
        np:writeInt( param_4_int )
        NetManager:send_packet( np )
    end,

    --查看其他玩家的法宝信息
    --客户端发送
    [12] = function ( 
                param_1_int,  -- 玩家id--c本参数存在特殊说明，请查阅协议编辑器
                param_2_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 12 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --获取今天VIP用户召唤第四个炼魂师的次数
    --客户端发送
    [13] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 13 ) 
        NetManager:send_packet( np )
    end,

    --分解某个仙魂
    --客户端发送
    [14] = function ( 
                param_1_unsigned_char,  -- 仙魂来源
                param_2_int -- 仙魂id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 14 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --升级某个仙魂
    --客户端发送
    [15] = function ( 
                param_1_unsigned_char,  -- 仙魂来源
                param_2_int -- 仙魂id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 15 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        NetManager:send_packet( np )
    end,

    --合成仙魂，生成前缀
    --客户端发送
    [16] = function ( 
                param_1_int,  -- 用来合成的仙魂列表个数
                param_2_array -- 仙魂列表--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 16 ) 
        np:writeInt( param_1_int )
        for i = 1, param_1_int do 
            -- protocol manual client 数组
            -- 仙魂列表--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_2_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --客户端请求魂值信息
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 17 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求开启某个法宝
    --客户端发送
    [18] = function ( 
                param_1_unsigned_char -- 法宝id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 18 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求进阶某个法宝
    --客户端发送
    [19] = function ( 
                param_1_unsigned_char -- 法宝id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 19 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求切换出战法宝
    --客户端发送
    [20] = function ( 
                param_1_unsigned_char -- 要出战的法宝id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 20 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求切换法宝外观
    --客户端发送
    [21] = function ( 
                param_1_unsigned_char -- 要使用外观的法宝id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 21 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求变换法宝技能位置
    --客户端发送
    [22] = function ( 
                param_1_unsigned_char,  -- 原位置
                param_2_unsigned_char -- 目标位置
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 22 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --仙魂的锁定操作
    --客户端发送
    [24] = function ( 
                param_1_unsigned_char,  -- 目的界面：0：法宝界面 1：猎魂界面
                param_2_int,  -- 仙魂id
                param_3_unsigned_char -- 操作类型，1：锁定，2：解锁
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 24 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeInt( param_2_int )
        np:writeByte( param_3_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求法宝战力比拼信息
    --客户端发送
    [26] = function ( 
                param_1_int,  -- 玩家id
                param_2_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 26 ) 
        np:writeInt( param_1_int )
        np:writeString( param_2_string )
        NetManager:send_packet( np )
    end,

    --穿上装备
    --客户端发送
    [27] = function ( 
                param_1_unsigned_int64 -- 装备guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 27 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --脱下装备
    --客户端发送
    [28] = function ( 
                param_1_unsigned_int64 -- 装备guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 28 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --查看自己的装备信息
    --客户端发送
    [29] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 33, 29 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[33] = {
    --开启仙魂槽位结果
    --接收服务器
    [5] = function ( np )
        local var_1_int = np:readInt( ) --错误代码--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --开启后总共开启了多少个槽位
        PacketDispatcher:dispather( 33, 5, var_1_int, var_2_int )--分发数据
    end,

    --添加仙魂
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --目的界面--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --仙魂ID
        local var_3_unsigned_char = np:readByte( ) --是否锁定，0不锁定，1锁定
        local var_4_unsigned_char = np:readByte( ) --前缀，0没有，1、2、3
        local var_5_unsigned_char = np:readByte( ) --仙魂种类
        local var_6_unsigned_char = np:readByte( ) --仙魂品质
        local var_7_unsigned_char = np:readByte( ) --仙魂等级
        local var_8_int = np:readInt( ) --仙魂灵力值
        PacketDispatcher:dispather( 33, 6, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_unsigned_char, var_8_int )--分发数据
    end,

    --更新仙魂信息
    --接收服务器
    [8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --目的界面--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --仙魂ID
        local var_3_unsigned_char = np:readByte( ) --是否锁定，0不锁定，1锁定
        local var_4_unsigned_char = np:readByte( ) --前缀，0没有，1、2、3
        local var_5_unsigned_char = np:readByte( ) --仙魂种类
        local var_6_unsigned_char = np:readByte( ) --仙魂品质
        local var_7_unsigned_char = np:readByte( ) --仙魂等级
        local var_8_int = np:readInt( ) --仙魂灵力值
        PacketDispatcher:dispather( 33, 8, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_unsigned_char, var_8_int )--分发数据
    end,

    --法宝评分改变
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --评分
        PacketDispatcher:dispather( 33, 9, var_1_int )--分发数据
    end,

    --一键合成结果
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --错误代码--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 33, 10, var_1_int )--分发数据
    end,

    --发送今天VIP用户召唤第四个炼魂师的次数
    --接收服务器
    [13] = function ( np )
        local var_1_int = np:readInt( ) --召唤次数
        PacketDispatcher:dispather( 33, 13, var_1_int )--分发数据
    end,

    --返回提升法宝出现暴击的类型
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --暴击类型--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 33, 14, var_1_int )--分发数据
    end,

    --返回提示
    --接收服务器
    [15] = function ( np )
        local var_1_int = np:readInt( ) --提示类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_string = np:readString( ) --提示文字
        PacketDispatcher:dispather( 33, 15, var_1_int, var_2_string )--分发数据
    end,

    --服务端下发魂值信息
    --接收服务器
    [17] = function ( np )
        local var_1_int64 = np:readInt64( ) --魂值
        PacketDispatcher:dispather( 33, 17, var_1_int64 )--分发数据
    end,

    --服务端下发合成仙魂结果
    --接收服务器
    [16] = function ( np )
        local var_1_int = np:readInt( ) --仙魂id
        local var_2_unsigned_char = np:readByte( ) --是否锁定
        local var_3_unsigned_char = np:readByte( ) --仙魂前缀
        local var_4_unsigned_char = np:readByte( ) --仙魂种类
        local var_5_unsigned_char = np:readByte( ) --仙魂品质
        local var_6_unsigned_char = np:readByte( ) --仙魂等级
        local var_7_int = np:readInt( ) --仙魂灵力值
        PacketDispatcher:dispather( 33, 16, var_1_int, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_unsigned_char, var_6_unsigned_char, var_7_int )--分发数据
    end,

    --服务端下发更新某个法宝信息
    --接收服务器
    [18] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --法宝id
        local var_2_unsigned_char = np:readByte( ) --法宝是否开启，0：未开启，1开启
        local var_3_unsigned_char = np:readByte( ) --法宝品质
        local var_4_unsigned_char = np:readByte( ) --法宝星级
        local var_5_int = np:readInt( ) --法宝经验
        local var_6_int = np:readInt( ) --法宝技能id
        local var_7_unsigned_char = np:readByte( ) --法宝技能等级
        local var_8_int = np:readInt( ) --被动技能id
        local var_9_unsigned_char = np:readByte( ) --被动技能等级
        local var_10_int = np:readInt( ) --法宝祝福值
        local var_11_unsigned_char = np:readByte( ) --法宝操作类型，0可升星，1可进阶
        local var_12_int = np:readInt( ) --法宝评分
        PacketDispatcher:dispather( 33, 18, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_unsigned_char, var_5_int, var_6_int, var_7_unsigned_char, var_8_int, var_9_unsigned_char, var_10_int, var_11_unsigned_char, var_12_int )--分发数据
    end,

    --服务端下发一些法宝的战斗信息
    --接收服务器
    [20] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --出战中的法宝id
        local var_2_int = np:readInt( ) --出战法宝技能id
        local var_3_unsigned_char = np:readByte( ) --出战法宝技能等级
        PacketDispatcher:dispather( 33, 20, var_1_unsigned_char, var_2_int, var_3_unsigned_char )--分发数据
    end,

    --服务端下发法宝外观信息
    --接收服务器
    [21] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --幻化中的法宝id
        PacketDispatcher:dispather( 33, 21, var_1_unsigned_char )--分发数据
    end,

    --服务端下发法宝战力比拼信息(同协议11)
    --接收服务器
    [26] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        PacketDispatcher:dispather( 33, 26, var_1_int )--分发数据
    end,

    --穿上装备
    --接收服务器
    [27] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备guid
        PacketDispatcher:dispather( 33, 27, var_1_unsigned_int64 )--分发数据
    end,

    --脱下装备
    --接收服务器
    [28] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备guid
        PacketDispatcher:dispather( 33, 28, var_1_unsigned_int64 )--分发数据
    end,


}
