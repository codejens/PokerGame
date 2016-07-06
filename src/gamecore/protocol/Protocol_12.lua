protocol_func_map_client[12] = {
    --购买商城物品
    --客户端发送
    [1] = function ( 
                param_1_int,  -- 购买商城物品的标示，不是物品的ID
                param_2_int,  -- 购买数量
                param_3_int -- 使用数量，如果购买后不马上使用，则写0
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" }, { param_name = param_2_int, lua_type = "number" }, { param_name = param_3_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 1 ) 
        np:writeInt( param_1_int )
        np:writeInt( param_2_int )
        np:writeInt( param_3_int )
        NetManager:send_packet( np )
    end,

    --查询商城销量排行
    --客户端发送
    [2] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 2 ) 
        NetManager:send_packet( np )
    end,

    --查询可提取元宝数量
    --客户端发送
    [3] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 3 ) 
        NetManager:send_packet( np )
    end,

    --请求提取元宝
    --客户端发送
    [4] = function ( 
                param_1_unsigned_int -- 请求提取元宝数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_unsigned_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 4 ) 
        np:writeUInt( param_1_unsigned_int )
        NetManager:send_packet( np )
    end,

    --获取限制物品的剩余时间和剩余数量
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 7 ) 
        NetManager:send_packet( np )
    end,

    --改变商城购物是否广播标记
    --客户端发送
    [5] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 5 ) 
        NetManager:send_packet( np )
    end,

    --获取商城特价商品列表
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 7 ) 
        NetManager:send_packet( np )
    end,

    --请求VIP专区物品信息
    --客户端发送
    [8] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 8 ) 
        NetManager:send_packet( np )
    end,

    --请求YY月费紫钻物品信息
    --客户端发送
    [9] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 9 ) 
        NetManager:send_packet( np )
    end,

    --请求YY年费紫钻物品信息
    --客户端发送
    [10] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 12, 10 ) 
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[12] = {
    --购买商城物品返回
    --接收服务器
    [1] = function ( np )
        local var_1_bool = np:readChar( ) --是否购买成功
        PacketDispatcher:dispather( 12, 1, var_1_bool )--分发数据
    end,

    --玩家可提取元宝数量
    --接收服务器
    [3] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --玩家可提取元宝数量
        PacketDispatcher:dispather( 12, 3, var_1_unsigned_int )--分发数据
    end,

    --广播刷新分类，通知客户端可以获取
    --接收服务器
    [5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --分类的ID,1表示限时抢购，.
        PacketDispatcher:dispather( 12, 5, var_1_unsigned_char )--分发数据
    end,

    --限购商品的数目发生改变
    --接收服务器
    [6] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --商品的ID
        local var_2_int = np:readInt( ) --该商品剩余数目
        local var_3_unsigned_char = np:readByte( ) --分类的ID
        PacketDispatcher:dispather( 12, 6, var_1_unsigned_int, var_2_int, var_3_unsigned_char )--分发数据
    end,


}
