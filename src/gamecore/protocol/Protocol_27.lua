protocol_func_map_client[27] = {
    --寄售物品-获取本人的物品列表
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 1 ) 
        NetManager:send_packet( np )
    end,

    --搜索寄卖物品
    --客户端发送
    [2] = function ( 
                param_1_int,  -- 每页的个数
                param_2_int,  -- 当前第几页--c本参数存在特殊说明，请查阅协议编辑器
                param_3_int,  -- 类型,-1是所有类型--c本参数存在特殊说明，请查阅协议编辑器
                param_4_int,  -- 最小价格--c本参数存在特殊说明，请查阅协议编辑器
                param_5_int,  -- 最大价格--c本参数存在特殊说明，请查阅协议编辑器
                param_6_int,  -- 品质值，-1是不限制
                param_7_int,  -- 最小等级，不限制则0
                param_8_int,  -- 最大等级，无限制则0--c本参数存在特殊说明，请查阅协议编辑器
                param_9_int,  -- 职业条件--c本参数存在特殊说明，请查阅协议编辑器
                param_10_int,  -- 模糊搜索出来的物品id的个数--c本参数存在特殊说明，请查阅协议编辑器
                param_11_int,  -- 物品id的列表--c本参数存在特殊说明，请查阅协议编辑器
                param_12_int -- 是否排序，0不排序，1从低到高，2从高到低
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" }, { param_name = param_4_int, lua_type = "number" }, { param_name = param_5_int, lua_type = "number" }, { param_name = param_6_int, lua_type = "number" }, { param_name = param_7_int, lua_type = "number" }, { param_name = param_8_int, lua_type = "number" }, { param_name = param_9_int, lua_type = "number" }, { param_name = param_10_int, lua_type = "number" }, { param_name = param_11_int, lua_type = "number" }, { param_name = param_12_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 2 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        np:writeInt( param_4_int )
        np:writeInt( param_5_int )
        np:writeInt( param_6_int )
        np:writeInt( param_7_int )
        np:writeInt( param_8_int )
        np:writeInt( param_9_int )
        np:writeInt( param_10_int )
        np:writeInt( param_11_int )
        np:writeInt( param_12_int )
        NetManager:send_packet( np )
    end,

    --寄卖物品
    --客户端发送
    [3] = function ( 
                param_1_int64,  -- 物品的序列号--c本参数存在特殊说明，请查阅协议编辑器
                param_2_int,  -- 寄卖金钱数量
                param_3_int,  -- 寄卖金钱类型
                param_4_unsigned_int,  -- 寄卖的时间--c本参数存在特殊说明，请查阅协议编辑器
                param_5_unsigned_int,  -- 寄卖的价格
                param_6_int,  -- 货币类型--c本参数存在特殊说明，请查阅协议编辑器
                param_7_unsigned_int -- 收取的寄卖费用--c本参数存在特殊说明，请查阅协议编辑器
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" }, { param_name = param_4_unsigned_int, lua_type = "number" }, { param_name = param_5_unsigned_int, lua_type = "number" }, { param_name = param_6_int, lua_type = "number" }, { param_name = param_7_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 3 ) 
        np:writeInt64( param_1_int64 )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        np:writeUInt( param_4_unsigned_int )
        np:writeUInt( param_5_unsigned_int )
        np:writeInt( param_6_int )
        np:writeUInt( param_7_unsigned_int )
        NetManager:send_packet( np )
    end,

    --寄售物品-取消寄卖
    --客户端发送
    [4] = function ( 
                param_1_int64,  -- 物品序列号--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_int -- 物品的handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 4 ) 
        np:writeInt64( param_1_int64 )
        np:writeUInt( param_2_unsigned_int )
        NetManager:send_packet( np )
    end,

    --购买物品
    --客户端发送
    [5] = function ( 
                param_1_int64,  -- 序列号--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_int -- 物品的handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 5 ) 
        np:writeInt64( param_1_int64 )
        np:writeUInt( param_2_unsigned_int )
        NetManager:send_packet( np )
    end,

    --计算寄卖费用的接口
    --客户端发送
    [7] = function ( 
                param_1_unsigned_int,  -- 寄卖时间--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_char,  -- 金钱类型
                param_3_unsigned_int -- 寄卖价钱
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" }, { param_name = param_2_unsigned_char, lua_type = "number" }, { param_name = param_3_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 7 ) 
        np:writeUInt( param_1_unsigned_int )
        np:writeByte( param_2_unsigned_char )
        np:writeUInt( param_3_unsigned_int )
        NetManager:send_packet( np )
    end,

    --寄售超时-获取本人超时寄售物品
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 8 ) 
        NetManager:send_packet( np )
    end,

    --寄售超时-取出一个超时物品
    --客户端发送
    [9] = function ( 
                param_1_int64,  -- 物品序列号--c本参数存在特殊说明，请查阅协议编辑器
                param_2_unsigned_int -- 物品的handle
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int64, lua_type = "number" }, { param_name = param_2_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 9 ) 
        np:writeInt64( param_1_int64 )
        np:writeUInt( param_2_unsigned_int )
        NetManager:send_packet( np )
    end,

    --寄售超时-一键取出超时物品
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 27, 10 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[27] = {
    --寄售物品-应答删除自己的寄卖物品
    --接收服务器
    [4] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --物品handle
        PacketDispatcher:dispather( 27, 4, var_1_unsigned_int )--分发数据
    end,

    --购买是否成功
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否成功--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 27, 5, var_1_unsigned_char )--分发数据
    end,

    --返回寄卖的费用
    --接收服务器
    [7] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --费用
        PacketDispatcher:dispather( 27, 7, var_1_unsigned_int )--分发数据
    end,

    --寄售超时-应答取出超时物品
    --接收服务器
    [9] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --物品的handle
        PacketDispatcher:dispather( 27, 9, var_1_unsigned_int )--分发数据
    end,

    --寄售超时-应答一键取出
    --接收服务器
    [10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --result--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 27, 10, var_1_unsigned_char )--分发数据
    end,


}
