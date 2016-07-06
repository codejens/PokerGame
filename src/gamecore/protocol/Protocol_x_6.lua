    if ( protocol_func_map_server[6] == nil ) then
        protocol_func_map_server[6] = {}
    end



    --下发可接任务列表
    --接收服务器
    protocol_func_map_server[6][5] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --任务数量
        -- 任务列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 6, 5, var_1_unsigned_short, var_2_array )--分发数据
    end

    --新增可接任务
    --接收服务器
    protocol_func_map_server[6][9] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --新的可接任务的数量
        -- 任务列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 6, 9, var_1_unsigned_short, var_2_array )--分发数据
    end

    --下发任务列表
    --接收服务器
    protocol_func_map_server[6][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --0表示返回客户端请求的结果，1表示玩家进入游戏第一次下发列表
        local var_2_unsigned_short = np:readWord( ) --任务的数量
        -- 任务数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 6, 1, var_1_unsigned_char, var_2_unsigned_short, var_3_array )--分发数据
    end

    --超时任务
    --接收服务器
    protocol_func_map_server[6][7] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数量
        -- 任务id列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 6, 7, var_1_unsigned_char, var_2_array )--分发数据
    end

