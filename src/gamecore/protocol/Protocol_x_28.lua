    if ( protocol_func_map_server[28] == nil ) then
        protocol_func_map_server[28] = {}
    end



    --下发成就的列表
    --接收服务器
    protocol_func_map_server[28][1] = function ( np )
        -- 玩家的成就是否完成的标记--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_int = np:readInt( ) --成就的每个事件的完成情况的数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 成就的每个事件的完成情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 28, 1, var_1_array, var_2_int, var_3_array )--分发数据
    end

    --下发称号的数据
    --接收服务器
    protocol_func_map_server[28][5] = function ( np )
        -- 称号的数据--s本参数存在特殊说明，请查阅协议编辑器
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        -- 称号显示--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, #var_1_array do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 28, 5, var_1_array, var_2_array )--分发数据
    end

    --称号显示广播
    --接收服务器
    protocol_func_map_server[28][8] = function ( np )
        local var_1_int64 = np:readInt64( ) --玩家句柄
        -- 称号显示列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int64 do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 28, 8, var_1_int64, var_2_array )--分发数据
    end

    --下发成就的进度信息
    --接收服务器
    protocol_func_map_server[28][9] = function ( np )
        local var_1_int = np:readInt( ) --groupId，组号
        local var_2_unsigned_char = np:readByte( ) --count，数组参数数量
        -- 进度值信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_unsigned_char = np:readByte( ) --count，目标值参数数量
        -- 目标值信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 28, 9, var_1_int, var_2_unsigned_char, var_3_array, var_4_unsigned_char, var_5_array )--分发数据
    end

