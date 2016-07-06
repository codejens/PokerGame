protocol_func_map_client[56] = {
    --神魄精炼
    --客户端发送
    [1] = function ( 
                param_1_int,  -- 要精炼的神魄id(唯一id)
                param_2_char -- 是否自动购买--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 1 ) 
        np:writeInt( param_1_int )
        np:writeChar( param_2_char )
        NetManager:send_packet( np )
    end,

    --烙神进阶
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 选择的神魄id
                param_2_char -- 是否自动购买--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 2 ) 
        np:writeInt( param_1_int )
        np:writeChar( param_2_char )
        NetManager:send_packet( np )
    end,

    --封灵升级
    --客户端发送
    [3] = function ( 
                param_1_int,  -- 神魄的唯一id
                param_2_char -- 是否自动购买
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 3 ) 
        np:writeInt( param_1_int )
        np:writeChar( param_2_char )
        NetManager:send_packet( np )
    end,

    --请求玩家的神魄信息
    --客户端发送
    [4] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 4 ) 
        NetManager:send_packet( np )
    end,

    --玩家卸下一个神魄
    --客户端发送
    [5] = function ( 
                param_1_int,  -- 卸下的神魄id
                param_2_unsigned_char -- 神魄的方向
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 5 ) 
        np:writeInt( param_1_int )
        np:writeByte( param_2_unsigned_char )
        NetManager:send_packet( np )
    end,

    --查询魂魄能量
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 8 ) 
        NetManager:send_packet( np )
    end,

    --玩家装备或者移动一个神魄
    --客户端发送
    [6] = function ( 
                param_1_int,  -- 神魄id
                param_2_char,  -- 神魄的横坐标
                param_3_char,  -- 神魄的纵坐标
                param_4_unsigned_char -- 神魄的方向
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" }, { param_name = param_3_char, lua_type = "number" }, { param_name = param_4_unsigned_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 6 ) 
        np:writeInt( param_1_int )
        np:writeChar( param_2_char )
        np:writeChar( param_3_char )
        np:writeByte( param_4_unsigned_char )
        NetManager:send_packet( np )
    end,

    --兑换一个神魄或者材料
    --客户端发送
    [7] = function ( 
                param_1_unsigned_char,  -- 用来区分兑换的是神魄还是材料--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- 兑换的数量
                param_3_int,  -- 每个兑换的东西需要消耗的能量点数
                param_4_int -- 物品的id（如果是神魄则发神魄的类型id）
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_char, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" }, { param_name = param_4_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 7 ) 
        np:writeByte( param_1_unsigned_char )
        np:writeByte( param_2_unsigned_char )
        np:writeInt( param_3_int )
        np:writeInt( param_4_int )
        NetManager:send_packet( np )
    end,

    --请求洛神和封灵祝福值最快到期时间
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 56, 9 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[56] = {
    --下发玩家的魂魄能量
    --接收服务器
    [8] = function ( np )
        local var_1_int = np:readInt( ) --玩家的魂魄能量数值
        PacketDispatcher:dispather( 56, 8, var_1_int )--分发数据
    end,

    --下发最快祝福值到期时间
    --接收服务器
    [9] = function ( np )
        local var_1_int = np:readInt( ) --洛神祝福值最快到期时间（秒）
        local var_2_int = np:readInt( ) --封灵祝福值最快到期时间（秒）
        PacketDispatcher:dispather( 56, 9, var_1_int, var_2_int )--分发数据
    end,

    --下发清空祝福值和祝福值时间的神魄
    --接收服务器
    [10] = function ( np )
        local var_1_int = np:readInt( ) --神魄的唯一id
        local var_2_char = np:readChar( ) --是否已经装备--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_char = np:readChar( ) --标记清理的是封灵的还是洛神的祝福值--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 56, 10, var_1_int, var_2_char, var_3_char )--分发数据
    end,


}
