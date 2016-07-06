    if ( protocol_func_map_server[16] == nil ) then
        protocol_func_map_server[16] = {}
    end



    --初始化队伍信息
    --接收服务器
    protocol_func_map_server[16][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --队伍的拾取方式
        local var_2_unsigned_char = np:readByte( ) --在线队伍成员的数量
        -- 在线队伍成员的信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        local var_4_int = np:readInt( ) --队长的actorID
        local var_5_unsigned_char = np:readByte( ) --Roll物品的最低物品品质
        local var_6_int = np:readInt( ) --队伍id--s本参数存在特殊说明，请查阅协议编辑器
        local var_7_unsigned_int = np:readUInt( ) --副本id--s本参数存在特殊说明，请查阅协议编辑器
        local var_8_unsigned_char = np:readByte( ) --队伍的副本状态--s本参数存在特殊说明，请查阅协议编辑器
        PacketDispatcher:dispather( 16, 1, var_1_unsigned_char, var_2_unsigned_char, var_3_array, var_4_int, var_5_unsigned_char, var_6_int, var_7_unsigned_int, var_8_unsigned_char )--分发数据
    end

    --添加队伍成员(或队友重新上线)
    --接收服务器
    protocol_func_map_server[16][2] = function ( np )
        -- 队伍成员的数据--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_1_struct = nil
        --var_1_struct = struct( np )
        PacketDispatcher:dispather( 16, 2, var_1_struct )--分发数据
    end

    --队友的属性发生改变
    --接收服务器
    protocol_func_map_server[16][8] = function ( np )
        local var_1_int64 = np:readInt64( ) --实体的handle--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --角色id
        local var_3_unsigned_char = np:readByte( ) --属性改变的数量--s本参数存在特殊说明，请查阅协议编辑器
        -- 属性改变的内容--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 16, 8, var_1_int64, var_2_int, var_3_unsigned_char, var_4_array )--分发数据
    end

    --发送组队副本代币数量
    --接收服务器
    protocol_func_map_server[16][14] = function ( np )
        local var_1_int = np:readInt( ) --代币数量
        -- 每种代币的数量--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 16, 14, var_1_int, var_2_array )--分发数据
    end

    --发送队伍成员信息
    --接收服务器
    protocol_func_map_server[16][15] = function ( np )
        local var_1_unsigned_int = np:readUInt( ) --队伍ID
        local var_2_unsigned_char = np:readByte( ) --队伍成员数量
        -- 队伍成员信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 16, 15, var_1_unsigned_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发队伍列表
    --接收服务器
    protocol_func_map_server[16][16] = function ( np )
        local var_1_int = np:readInt( ) --队伍数
        -- 队伍信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 16, 16, var_1_int, var_2_array )--分发数据
    end

    --玩家列表
    --接收服务器
    protocol_func_map_server[16][17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --类型，目前有1附近玩家，2好友
        local var_2_int = np:readInt( ) --列表总数
        -- 玩家信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 16, 17, var_1_unsigned_char, var_2_int, var_3_array )--分发数据
    end

