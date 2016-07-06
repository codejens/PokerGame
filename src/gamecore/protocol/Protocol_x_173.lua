    if ( protocol_func_map_server[173] == nil ) then
        protocol_func_map_server[173] = {}
    end



    --下发海选赛胜负结果
    --接收服务器
    protocol_func_map_server[173][3] = function ( np )
        -- 两个玩家的数组--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 173, 3, var_1_array )--分发数据
    end

    --下发争霸赛准备场景统计面板
    --接收服务器
    protocol_func_map_server[173][4] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --16强人数
        -- 16强信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 173, 4, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发自由赛排行榜信息
    --接收服务器
    protocol_func_map_server[173][8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前第几页
        local var_2_unsigned_char = np:readByte( ) --总页数
        local var_3_unsigned_char = np:readByte( ) --当前页数数据量
        -- 排行玩家信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 173, 8, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_char, var_4_array )--分发数据
    end

    --下发上届16强信息
    --接收服务器
    protocol_func_map_server[173][9] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --16强个数
        -- 16强信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 173, 9, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发历届仙王信息
    --接收服务器
    protocol_func_map_server[173][10] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --仙王数量
        -- 仙王信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 173, 10, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发本届争霸赛信息
    --接收服务器
    protocol_func_map_server[173][11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --当前第几轮
        local var_2_unsigned_char = np:readByte( ) --当前轮次状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --当前轮次剩余时间
        local var_4_unsigned_char = np:readByte( ) --玩家数量
        -- 玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        local var_6_unsigned_char = np:readByte( ) --PK状态数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 每轮每组pk信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        PacketDispatcher:dispather( 173, 11, var_1_unsigned_char, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_array, var_6_unsigned_char, var_7_array )--分发数据
    end

    --下发玩家投注信息
    --接收服务器
    protocol_func_map_server[173][12] = function ( np )
        -- 每轮每组我的下注信息--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 173, 12, var_1_array )--分发数据
    end

