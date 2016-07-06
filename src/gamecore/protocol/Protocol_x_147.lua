    if ( protocol_func_map_server[147] == nil ) then
        protocol_func_map_server[147] = {}
    end



    --发送自由赛排行榜
    --接收服务器
    protocol_func_map_server[147][2] = function ( np )
        local var_1_int = np:readInt( ) --总页数
        local var_2_int = np:readInt( ) --第几页
        local var_3_int = np:readInt( ) --该页有多少项
        -- 每一项的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 147, 2, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --发送争霸赛信息
    --接收服务器
    protocol_func_map_server[147][3] = function ( np )
        local var_1_int = np:readInt( ) --第几轮
        local var_2_unsigned_char = np:readByte( ) --擂台赛状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_int = np:readUInt( ) --状态结束时间
        local var_4_int = np:readInt( ) --玩家数量
        -- 每个玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        local var_6_int = np:readInt( ) --PK状态数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 每轮每组PK状态--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        PacketDispatcher:dispather( 147, 3, var_1_int, var_2_unsigned_char, var_3_unsigned_int, var_4_int, var_5_array, var_6_int, var_7_array )--分发数据
    end

    --发送上届16强排名
    --接收服务器
    protocol_func_map_server[147][4] = function ( np )
        local var_1_int = np:readInt( ) --信息个数
        -- 排行的每个玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 147, 4, var_1_int, var_2_array )--分发数据
    end

    --发送历届仙王
    --接收服务器
    protocol_func_map_server[147][5] = function ( np )
        local var_1_int = np:readInt( ) --仙王信息个数
        -- 各个仙王信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 147, 5, var_1_int, var_2_array )--分发数据
    end

    --PK结束
    --接收服务器
    protocol_func_map_server[147][8] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --当前玩家胜负--s本参数存在特殊说明，请查阅协议编辑器
        -- 当前玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        -- 对手玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_4_struct = nil
        --var_4_struct = struct( np )
        PacketDispatcher:dispather( 147, 8, var_1_unsigned_char, var_2_unsigned_char, var_3_struct, var_4_struct )--分发数据
    end

    --下发身价排行榜
    --接收服务器
    protocol_func_map_server[147][16] = function ( np )
        local var_1_int = np:readInt( ) --个数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 147, 16, var_1_int, var_2_array )--分发数据
    end

