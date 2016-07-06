protocol_func_map_client[133] = {
    --从NPC商店或者背包商店买东西
    --客户端发送
    [1] = function ( 
                param_1_unsigned_short,  -- 涉及的物品ID--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_short,  -- 涉及的物品数量
                param_3_unsigned_short -- NPC的编号--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 1 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeWord( param_3_unsigned_short )
        NetManager:send_packet( np )
    end,

    --兑换：宠物道具（圣灵碎片）
    --客户端发送
    [2] = function ( 
                param_1_unsigned_short,  -- 物品的ID
                param_2_unsigned_short,  -- 购买的数量
                param_3_unsigned_char,  -- 物品品质等级
                param_4_unsigned_char,  -- 物品强化等级
                param_5_unsigned_char -- 组号ID--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 2 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --请求背包购买的物品的列表
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 3 ) 
        NetManager:send_packet( np )
    end,

    --出售物品给商店
    --客户端发送
    [4] = function ( 
                param_1_unsigned_int64 -- 物品的GUID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 4 ) 
        np:writeUint64( param_1_unsigned_int64 )
        NetManager:send_packet( np )
    end,

    --从商店回购物品
    --客户端发送
    [5] = function ( 
                param_1_unsigned_int64,  -- 物品的GUID
                param_2_unsigned_short -- NPC的ID，随时商店是0
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int64, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 5 ) 
        np:writeUint64( param_1_unsigned_int64 )
        np:writeWord( param_2_unsigned_short )
        NetManager:send_packet( np )
    end,

    --购买荣誉值商店的物品
    --客户端发送
    [6] = function ( 
                param_1_unsigned_short,  -- 物品的ID
                param_2_unsigned_short,  -- 购买的数量
                param_3_unsigned_char,  -- 物品品质等级
                param_4_unsigned_char,  -- 物品强化等级
                param_5_unsigned_char -- 组号ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 6 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --兑换：购买组队副本商店的物品（玄黄令）
    --客户端发送
    [7] = function ( 
                param_1_unsigned_short,  -- 物品的ID
                param_2_unsigned_short,  -- 购买的数量
                param_3_unsigned_char,  -- 物品品质等级
                param_4_unsigned_char,  -- 物品强化等级
                param_5_unsigned_char -- 组号ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 7 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --威望兑换物品
    --客户端发送
    [8] = function ( 
                param_1_unsigned_short,  -- 物品id
                param_2_unsigned_short,  -- 兑换的物品数量
                param_3_unsigned_char,  -- 物品品质等级
                param_4_unsigned_char,  -- 物品强化等级
                param_5_unsigned_char -- 物品组号id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 8 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --跨服荣誉兑换物品
    --客户端发送
    [9] = function ( 
                param_1_unsigned_short,  -- 物品id
                param_2_unsigned_short,  -- 兑换的物品数量
                param_3_unsigned_char,  -- 物品品质等级
                param_4_unsigned_char,  -- 物品强化等级
                param_5_unsigned_char -- 物品组号id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 9 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求黄令数量
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 10 ) 
        NetManager:send_packet( np )
    end,

    --客户端请求玄令数量
    --客户端发送
    [11] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 11 ) 
        NetManager:send_packet( np )
    end,

    --兑换：熔炼兑换（熔炼值）
    --客户端发送
    [12] = function ( 
                param_1_unsigned_short,  -- 物品id
                param_2_unsigned_short,  -- 兑换的物品数量
                param_3_unsigned_char,  -- 物品品质等级
                param_4_unsigned_char,  -- 物品强化等级
                param_5_unsigned_char -- 物品组号id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 12 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求限购相关数据
    --客户端发送
    [13] = function ( 
                param_1_unsigned_char -- 组ID
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 13 ) 
        np:writeByte( param_1_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求悬赏令数量
    --客户端发送
    [14] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 14 ) 
        NetManager:send_packet( np )
    end,

    --兑换：无双战神（悬赏令）
    --客户端发送
    [15] = function ( 
                param_1_unsigned_short,  -- 物品id
                param_2_unsigned_short,  -- 兑换的物品数量
                param_3_unsigned_char,  -- 物品品质等级
                param_4_unsigned_char,  -- 物品强化等级
                param_5_unsigned_char -- 物品组号id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 15 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,

    --客户端请求天令
    --客户端发送
    [17] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 17 ) 
        NetManager:send_packet( np )
    end,

    --弑神值兑换物品
    --客户端发送
    [18] = function ( 
                param_1_unsigned_short,  -- 物品id
                param_2_unsigned_short,  -- 兑换的物品数量
                param_3_unsigned_char,  -- 物品的品质等级
                param_4_unsigned_char,  -- 物品的强化等级
                param_5_unsigned_char -- 物品组号id
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_short, lua_type = "number" }, { param_name = param_2_unsigned_short, lua_type = "number" }, { param_name = param_3_unsigned_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" }, { param_name = param_5_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 133, 18 ) 
        np:writeWord( param_1_unsigned_short )
        np:writeWord( param_2_unsigned_short )
        np:writeByte( param_3_unsigned_char )
        np:writeByte( param_4_unsigned_char )
        np:writeByte( param_5_unsigned_char )
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[133] = {
    --NPC交易结果
    --接收服务器
    [2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --交易类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_int64 = np:readUint64( ) --交易涉及的物品GUID
        local var_3_unsigned_char = np:readByte( ) --涉及的物品的数量
        PacketDispatcher:dispather( 133, 2, var_1_unsigned_char, var_2_unsigned_int64, var_3_unsigned_char )--分发数据
    end,

    --从商店购买了一件物品
    --接收服务器
    [1] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --物品的guid
        local var_2_unsigned_short = np:readWord( ) --物品的数量
        PacketDispatcher:dispather( 133, 1, var_1_unsigned_int64, var_2_unsigned_short )--分发数据
    end,

    --成功出售一件物品给商店
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --物品的GUID
        PacketDispatcher:dispather( 133, 4, var_1_unsigned_int64 )--分发数据
    end,

    --成功回购一件物品
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_int64 = np:readUint64( ) --物品的GUID
        PacketDispatcher:dispather( 133, 5, var_1_unsigned_int64 )--分发数据
    end,

    --服务端下发黄令数量
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --黄令数量
        PacketDispatcher:dispather( 133, 10, var_1_int )--分发数据
    end,

    --服务端返回玄令数量
    --接收服务器
    [11] = function ( np )
        local var_1_int = np:readInt( ) --服务端返回玄令数量
        PacketDispatcher:dispather( 133, 11, var_1_int )--分发数据
    end,

    --服务端下发悬赏令数量
    --接收服务器
    [14] = function ( np )
        local var_1_int = np:readInt( ) --悬赏令数量
        PacketDispatcher:dispather( 133, 14, var_1_int )--分发数据
    end,

    --下发天令数量
    --接收服务器
    [17] = function ( np )
        local var_1_int = np:readInt( ) --天令数
        PacketDispatcher:dispather( 133, 17, var_1_int )--分发数据
    end,

    --下发弑神值兑换结果
    --接收服务器
    [18] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --1成功，0失败
        local var_2_int = np:readInt( ) --弑神值
        PacketDispatcher:dispather( 133, 18, var_1_unsigned_char, var_2_int )--分发数据
    end,


}
