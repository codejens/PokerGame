    if ( protocol_func_map_server[27] == nil ) then
        protocol_func_map_server[27] = {}
    end



    --寄售物品-下发本人的寄卖物品的列表
    --接收服务器
    protocol_func_map_server[27][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --物品的数量
        -- 物品的内容，类似背包的接口--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 27, 1, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发搜索结果
    --接收服务器
    protocol_func_map_server[27][2] = function ( np )
        local var_1_int = np:readInt( ) --本次下发的物品的数量
        local var_2_int = np:readInt( ) --当前第几页--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --一共多少页
        -- 物品的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 27, 2, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --应答寄卖物品
    --接收服务器
    protocol_func_map_server[27][3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否寄卖成功--s本参数存在特殊说明，请查阅协议编辑器
        -- 寄卖物品的信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 27, 3, var_1_unsigned_char, var_2_struct )--分发数据
    end

    --寄售超时-添加超时物品信息
    --接收服务器
    protocol_func_map_server[27][8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count，数量
        -- 物品信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 27, 8, var_1_unsigned_char, var_2_array )--分发数据
    end

