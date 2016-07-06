    if ( protocol_func_map_server[47] == nil ) then
        protocol_func_map_server[47] = {}
    end



    --获取仓库列表
    --接收服务器
    protocol_func_map_server[47][1] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品数量
        -- 物品信息,跟背包系统那些一样的
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 47, 1, var_1_unsigned_short, var_2_array )--分发数据
    end

    --仓库增加新物品
    --接收服务器
    protocol_func_map_server[47][3] = function ( np )
        -- 物品的结构
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 47, 3, var_1_array )--分发数据
    end

    --闯关信息
    --接收服务器
    protocol_func_map_server[47][5] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        local var_2_int = np:readInt( ) --已经购买次数
        local var_3_int = np:readInt( ) --已经通关到第几个副本--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --今日已经挑战的副本个数
        -- 今日已经挑战了的副本id--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 47, 5, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --通知闯关成功
    --接收服务器
    protocol_func_map_server[47][8] = function ( np )
        local var_1_int = np:readInt( ) --剩余次数
        local var_2_int = np:readInt( ) --当前已经通关的最大副本索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --本次通关的副本索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --扫荡奖励物品组数
        -- 奖励组--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 47, 8, var_1_int, var_2_int, var_3_int, var_4_int, var_5_array )--分发数据
    end

    --扫荡信息
    --接收服务器
    protocol_func_map_server[47][10] = function ( np )
        local var_1_int = np:readInt( ) --剩余扫荡次数
        local var_2_char = np:readChar( ) --是否扫荡中--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --当前扫荡的副本索引--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_int = np:readInt( ) --剩余时间
        local var_5_int = np:readInt( ) --总时间
        local var_6_int = np:readInt( ) --总个数
        -- 选择的第几个扫荡副本--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_array = {}
        for i = 1, var_6_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_7_array, structObj )
        end
        PacketDispatcher:dispather( 47, 10, var_1_int, var_2_char, var_3_int, var_4_int, var_5_int, var_6_int, var_7_array )--分发数据
    end

    --通知扫荡结束了
    --接收服务器
    protocol_func_map_server[47][13] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否主动停止--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --扫荡奖励条数
        -- 扫荡奖励组--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 47, 13, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

