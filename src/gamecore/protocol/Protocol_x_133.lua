    if ( protocol_func_map_server[133] == nil ) then
        protocol_func_map_server[133] = {}
    end



    --客户端获得NPC交易物品数据
    --接收服务器
    protocol_func_map_server[133][3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --NPC交易品表长度
        -- NPC交易品数据项--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        local var_3_unsigned_char = np:readByte( ) --NPC出售的编号，0表示背包的商店
        PacketDispatcher:dispather( 133, 3, var_1_unsigned_char, var_2_struct, var_3_unsigned_char )--分发数据
    end

    --服务端下发限购相关数据
    --接收服务器
    protocol_func_map_server[133][13] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --组ID
        local var_2_unsigned_char = np:readByte( ) --已有购买的道具数量
        -- 已有购买的道具信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 133, 13, var_1_unsigned_char, var_2_unsigned_char, var_3_array )--分发数据
    end

    --服务端下发已兑换总数量
    --接收服务器
    protocol_func_map_server[133][16] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 133, 16, var_1_unsigned_char, var_2_array )--分发数据
    end

