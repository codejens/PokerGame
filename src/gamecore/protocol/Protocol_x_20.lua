    if ( protocol_func_map_server[20] == nil ) then
        protocol_func_map_server[20] = {}
    end



    --下发今日进入各个模式的副本的剩余次数
    --接收服务器
    protocol_func_map_server[20][1] = function ( np )
        local var_1_int = np:readInt( ) --下发数据的数量（个数）
        -- 各个模式副本的剩余次数--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 20, 1, var_1_int, var_2_struct )--分发数据
    end

    --下发副本所有队伍列表
    --接收服务器
    protocol_func_map_server[20][2] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --副本的类型id
        local var_2_unsigned_short = np:readWord( ) --数量
        -- --s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 20, 2, var_1_unsigned_char, var_2_unsigned_short, var_3_struct )--分发数据
    end

    --下发某队伍的副本队伍情况
    --接收服务器
    protocol_func_map_server[20][6] = function ( np )
        local var_1_int = np:readInt( ) --副本id,即这个队伍打算进入的副本--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_short = np:readWord( ) --下发的数量（队员的个数）--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_short = np:readWord( ) --队伍的最大人数--s本参数存在特殊说明，请查阅协议编辑器
        -- 队员的数据--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_4_struct = nil
        --var_4_struct = struct( np )
        PacketDispatcher:dispather( 20, 6, var_1_int, var_2_unsigned_short, var_3_unsigned_short, var_4_struct )--分发数据
    end

