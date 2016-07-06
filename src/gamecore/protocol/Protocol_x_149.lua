    if ( protocol_func_map_server[149] == nil ) then
        protocol_func_map_server[149] = {}
    end



    --合服争霸-主活动控制协议
    --接收服务器
    protocol_func_map_server[149][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动时间列表长度
        -- 活动时间列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --第几次合服，1代表第一次合服，2代表二次合服
        PacketDispatcher:dispather( 149, 1, var_1_unsigned_char, var_2_array, var_3_unsigned_char )--分发数据
    end

    --合服争霸-下发boss争霸排行信息
    --接收服务器
    protocol_func_map_server[149][3] = function ( np )
        local var_1_int = np:readInt( ) --排行榜列表长度
        -- 排行榜列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 3, var_1_int, var_2_array )--分发数据
    end

    --合服活动.首充大团购-应答客户端请求
    --接收服务器
    protocol_func_map_server[149][10] = function ( np )
        local var_1_int = np:readInt( ) --num，首冲的玩家数量
        local var_2_unsigned_char = np:readByte( ) --count，数组成员个数
        -- 领奖状态，奖励顺序由低到高--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 149, 10, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --合服活动.下发充值大比拼排行榜
    --接收服务器
    protocol_func_map_server[149][14] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --排行榜的长度
        -- 排行榜--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 14, var_1_unsigned_char, var_2_array )--分发数据
    end

    --合服活动.下发坐骑进阶信息
    --接收服务器
    protocol_func_map_server[149][15] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 15, var_1_unsigned_char, var_2_array )--分发数据
    end

    --合服活动.下发宠物进阶信息
    --接收服务器
    protocol_func_map_server[149][17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 17, var_1_unsigned_char, var_2_array )--分发数据
    end

    --合服活动.下发法阵进阶信息
    --接收服务器
    protocol_func_map_server[149][19] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 19, var_1_unsigned_char, var_2_array )--分发数据
    end

    --合服活动.下发翅膀进阶信息
    --接收服务器
    protocol_func_map_server[149][21] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 21, var_1_unsigned_char, var_2_array )--分发数据
    end

    --合服活动.下发神兵进阶信息
    --接收服务器
    protocol_func_map_server[149][23] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 23, var_1_unsigned_char, var_2_array )--分发数据
    end

    --合服活动.下发神秘大奖信息
    --接收服务器
    protocol_func_map_server[149][25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组数量。
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 25, var_1_unsigned_char, var_2_array )--分发数据
    end

    --合服活动.下发可领取奖励数量
    --接收服务器
    protocol_func_map_server[149][26] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度
        -- 数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        local var_3_unsigned_char = np:readByte( ) --总的数量
        PacketDispatcher:dispather( 149, 26, var_1_unsigned_char, var_2_array, var_3_unsigned_char )--分发数据
    end

    --合服活动.下发战灵进阶信息
    --接收服务器
    protocol_func_map_server[149][40] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --列表长度
        -- 礼包列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 149, 40, var_1_unsigned_char, var_2_array )--分发数据
    end

