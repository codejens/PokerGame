protocol_func_map_client[162] = {
    --请求河图洛书卡牌信息
    --客户端发送
    [1] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 162, 1 ) 
        NetManager:send_packet( np )
    end,

    --请求操作河图洛书指定卡牌
    --客户端发送
    [3] = function ( 
                param_1_char,  -- 操作类型 0=激活，1=升星
                param_2_short,  -- 卡片id
                param_3_int64 -- guid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_short, lua_type = "number" }, { param_name = param_3_int64, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 162, 3 ) 
        np:writeChar( param_1_char )
        np:writeShort( param_2_short )
        np:writeInt64( param_3_int64 )
        NetManager:send_packet( np )
    end,

    --请求分解卡牌
    --客户端发送
    [4] = function ( 
                param_1_short,  -- 要分解卡牌类型的数量
                param_2_short,  -- -要分解的卡牌的ID
                param_3_short,  -- 要分解的卡牌的数量
                param_4_short,  -- 要分解的道具guid数量--c本参数存在特殊说明，请查阅协议编辑器
                param_5_array -- guid数组
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_short, lua_type = "number" }, { param_name = param_2_short, lua_type = "number" }, { param_name = param_3_short, lua_type = "number" }, { param_name = param_4_short, lua_type = "number" }, { param_name = param_5_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 162, 4 ) 
        np:writeShort( param_1_short )
        np:writeShort( param_2_short )
        np:writeShort( param_3_short )
        np:writeShort( param_4_short )
        for i = 1, param_4_short do 
            -- protocol manual client 数组
            -- guid数组
            local structObj = param_5_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,

    --请求拍买券兑换成卡牌
    --客户端发送
    [5] = function ( 
                param_1_short,  -- 兑换的下标
                param_2_char -- 兑换的数量
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_short, lua_type = "number" }, { param_name = param_2_char, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 162, 5 ) 
        np:writeShort( param_1_short )
        np:writeChar( param_2_char )
        NetManager:send_packet( np )
    end,

    --兑换次数
    --客户端发送
    [7] = function ( 
                )
        --@debug_begin
        protocol_func_map:check_param_type({  })
        --@debug_end
        local np = NetManager:get_NetPacket( 162, 7 ) 
        NetManager:send_packet( np )
    end,

    --请求别人的河图洛书卡牌信息
    --客户端发送
    [8] = function ( 
                param_1_int -- actorid
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_int, lua_type = "number" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 162, 8 ) 
        np:writeInt( param_1_int )
        NetManager:send_packet( np )
    end,

    --请求材料兑换成卡牌
    --客户端发送
    [9] = function ( 
                param_1_char,  -- 数量
                param_2_short,  -- 下标
                param_3_char,  -- guid个数
                param_4_array -- guid列表
                )
        --@debug_begin
        protocol_func_map:check_param_type({ { param_name = param_1_char, lua_type = "number" }, { param_name = param_2_short, lua_type = "number" }, { param_name = param_3_char, lua_type = "number" }, { param_name = param_4_array, lua_type = "table" },  })
        --@debug_end
        local np = NetManager:get_NetPacket( 162, 9 ) 
        np:writeChar( param_1_char )
        np:writeShort( param_2_short )
        np:writeChar( param_3_char )
        for i = 1, param_3_char do 
            -- protocol manual client 数组
            -- guid列表
            local structObj = param_4_array[i]
            structObj:write_pack( np )
        end
        NetManager:send_packet( np )
    end,


}



protocol_func_map_server[162] = {
    --返回剩余购买次数
    --接收服务器
    [7] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        PacketDispatcher:dispather( 162, 7, var_1_int )--分发数据
    end,

    --卡牌id和星级
    --接收服务器
    [2] = function ( np )
        local var_1_short = np:readShort( ) --id
        local var_2_char = np:readChar( ) --星级star
        PacketDispatcher:dispather( 162, 2, var_1_short, var_2_char )--分发数据
    end,

    --下发残卷值
    --接收服务器
    [6] = function ( np )
        local var_1_int = np:readInt( ) --残卷值
        PacketDispatcher:dispather( 162, 6, var_1_int )--分发数据
    end,


}
