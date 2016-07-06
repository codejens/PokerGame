    if ( protocol_func_map_server[12] == nil ) then
        protocol_func_map_server[12] = {}
    end



    --返回商城销量排行
    --接收服务器
    protocol_func_map_server[12][2] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --销量记录数量
        -- 商品销量数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 12, 2, var_1_unsigned_short, var_2_array )--分发数据
    end

    --下发商城特价商品列表
    --接收服务器
    protocol_func_map_server[12][7] = function ( np )
        local var_1_int = np:readInt( ) --商品的剩余时间
        local var_2_int = np:readInt( ) --物品数量
        -- 商品的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 12, 7, var_1_int, var_2_int, var_3_array )--分发数据
    end

    --下发VIP专区物品信息
    --接收服务器
    protocol_func_map_server[12][8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --道具个数
        -- 道具数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 12, 8, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发YY月费紫钻物品信息
    --接收服务器
    protocol_func_map_server[12][9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --道具个数
        -- 道具数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 12, 9, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发YY年费紫钻物品信息
    --接收服务器
    protocol_func_map_server[12][10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --道具个数
        -- 道具数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 12, 10, var_1_unsigned_char, var_2_array )--分发数据
    end

