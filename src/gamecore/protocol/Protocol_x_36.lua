    if ( protocol_func_map_server[36] == nil ) then
        protocol_func_map_server[36] = {}
    end



    --探宝结果
    --接收服务器
    protocol_func_map_server[36][1] = function ( np )
        local var_1_int = np:readInt( ) --物品id
        local var_2_int = np:readInt( ) --数量
        -- 日志的内容--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_3_struct = nil
        --var_3_struct = struct( np )
        PacketDispatcher:dispather( 36, 1, var_1_int, var_2_int, var_3_struct )--分发数据
    end

    --获取仓库列表
    --接收服务器
    protocol_func_map_server[36][2] = function ( np )
        local var_1_unsigned_short = np:readWord( ) --物品数量
        -- 物品信息,跟背包系统那些一样的--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_short do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 36, 2, var_1_unsigned_short, var_2_array )--分发数据
    end

    --下发全服日志
    --接收服务器
    protocol_func_map_server[36][4] = function ( np )
        local var_1_int = np:readInt( ) --日志的数量,最多16个
        -- 玩家详细数据--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_2_struct = nil
        --var_2_struct = struct( np )
        PacketDispatcher:dispather( 36, 4, var_1_int, var_2_struct )--分发数据
    end

    --添加物品
    --接收服务器
    protocol_func_map_server[36][5] = function ( np )
        -- 物品的结构
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        PacketDispatcher:dispather( 36, 5, var_1_array )--分发数据
    end

    --本次抽奖后活动的物品的id列表，（id可能会有重复的，客户端统计）
    --接收服务器
    protocol_func_map_server[36][11] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --本次抽奖获取的物品的数量
        -- 物品id的列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 36, 11, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

    --下发探宝结果集
    --接收服务器
    protocol_func_map_server[36][12] = function ( np )
        local var_1_int = np:readInt( ) --数量
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 36, 12, var_1_int, var_2_array )--分发数据
    end

    --有用：后端下发宝藏的兑换情况
    --接收服务器
    protocol_func_map_server[36][25] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数组长度（已兑换的数量）
        -- 数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 36, 25, var_1_unsigned_char, var_2_array )--分发数据
    end

