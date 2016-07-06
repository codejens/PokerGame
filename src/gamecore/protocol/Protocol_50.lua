protocol_func_map_client[50] = {
    --升阶
    --客户端发送
    [2] = function ( 
                param_1_char,  -- 是否自动购买材料--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- guid个数
                param_3_array -- guid数据--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 2 ) 
        np:writeChar( param_1_char )
        np:writeByte( param_2_unsigned_char )
        for i = 1, param_2_unsigned_char do 
            -- protocol manual client 数组
            -- guid数据--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_3_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --服用灵丹
    --客户端发送
    [3] = function ( 
                param_1_unsigned_short,  -- 总的物品数
                param_2_unsigned_short,  -- 消耗的物品数
                param_3_array -- 物品guid--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 3 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        for i = 1, param_2_unsigned_short do 
            -- protocol manual client 数组
            -- 物品guid--c本参数存在特殊说明，请查阅协议编辑器
            local structObj = param_3_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --服用仙丹
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 4 ) 
        NetManager:send_packet( np )
    end,

    --学习技能，一次只能学习一个技能
    --客户端发送
    [5] = function ( 
                param_1_int64 -- 技能书id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 5 ) 
        np:writeInt64( param_1_int64 )
        NetManager:send_packet( np )
    end,

    --化形
    --客户端发送
    [6] = function ( 
                param_1_char -- 化形的阶数
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 6 ) 
        np:writeChar( param_1_char )
        NetManager:send_packet( np )
    end,

    --激活神兵系统
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 9 ) 
        NetManager:send_packet( np )
    end,

    --查看玩家神兵
    --客户端发送
    [10] = function ( 
                param_1_string -- 玩家名字
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_string, lua_type = "string" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 10 ) 
        np:writeString( param_1_string )
        NetManager:send_packet( np )
    end,

    --穿上装备
    --客户端发送
    [12] = function ( 
                param_1_unsigned_int64 -- 装备guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 12 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --脱下装备
    --客户端发送
    [13] = function ( 
                param_1_unsigned_int64 -- 装备guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 50, 13 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[50] = {
    --升阶应答
    --接收服务器
    [2] = function ( np )
        local var_1_char = np:readChar( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --高16位是总增加值，8位是Vip加成祝福值，8位是暴击卡祝福值
        local var_3_int = np:readInt( ) --祝福值时间--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 50, 2, var_1_char, var_2_int, var_3_int )--分发数据
    end,

    --服用灵丹返回
    --接收服务器
    [3] = function ( np )
        local var_1_int = np:readInt( ) --已服用灵丹数
        PacketDispatcher:dispather( 50, 3, var_1_int )--分发数据
    end,

    --服用仙丹返回
    --接收服务器
    [4] = function ( np )
        local var_1_int = np:readInt( ) --已服用仙丹数
        PacketDispatcher:dispather( 50, 4, var_1_int )--分发数据
    end,

    --化形返回
    --接收服务器
    [6] = function ( np )
        local var_1_int = np:readInt( ) --modid
        PacketDispatcher:dispather( 50, 6, var_1_int )--分发数据
    end,

    --释放神兵技能信息
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --技能id--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --技能等级
        local var_3_unsigned_short = np:readWord( ) --需要的总的蓄斩数
        local var_4_unsigned_short = np:readWord( ) --已经有的蓄斩数
        PacketDispatcher:dispather( 50, 7, var_1_unsigned_short, var_2_unsigned_char, var_3_unsigned_short, var_4_unsigned_short )--分发数据
    end,

    --清除祝福值
    --接收服务器
    [8] = function ( np )
        PacketDispatcher:dispather( 50, 8 )--分发数据
    end,

    --提示神兵体验时间已到
    --接收服务器
    [11] = function ( np )
        PacketDispatcher:dispather( 50, 11 )--分发数据
    end,

    --穿上装备
    --接收服务器
    [12] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备guid
        PacketDispatcher:dispather( 50, 12, var_1_unsigned_int64 )--分发数据
    end,

    --脱下装备
    --接收服务器
    [13] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --装备guid
        PacketDispatcher:dispather( 50, 13, var_1_unsigned_int64 )--分发数据
    end,


}
