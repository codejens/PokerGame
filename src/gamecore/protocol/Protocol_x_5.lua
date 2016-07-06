    if ( protocol_func_map_server[5] == nil ) then
        protocol_func_map_server[5] = {}
    end



    --初始化玩家技能
    --接收服务器
    protocol_func_map_server[5][1] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --技能的数量
        -- 技能的数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            local structObj = UserSkill( np )
            table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 5, 1, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发技能列表
    --接收服务器
    protocol_func_map_server[5][15] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --标志是否是全部--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_int = np:readInt( ) --秘籍战力
        local var_3_unsigned_char = np:readByte( ) --总技能数，目前最大为8
        -- 秘籍数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 5, 15, var_1_unsigned_char, var_2_int, var_3_unsigned_char, var_4_array )--分发数据
    end

    --下发玩家秘籍和技能信息
    --接收服务器
    protocol_func_map_server[5][20] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --是否开启秘籍系统--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_unsigned_char = np:readByte( ) --职业--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_unsigned_int = np:readUInt( ) --秘籍战力
        local var_4_unsigned_char = np:readByte( ) --技能个数
        -- 技能和秘籍数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_5_array = {}
        for i = 1, var_4_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_5_array, structObj )
        end
        PacketDispatcher:dispather( 5, 20, var_1_unsigned_char, var_2_unsigned_char, var_3_unsigned_int, var_4_unsigned_char, var_5_array )--分发数据
    end

    --下发技能增幅系统数据(暂时只下发永久的)
    --接收服务器
    protocol_func_map_server[5][22] = function ( np )
        local var_1_int = np:readInt( ) --列表长度
        -- 列表--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 5, 22, var_1_int, var_2_array )--分发数据
    end

    --战力比拼-下发玩家技能战斗力信息
    --接收服务器
    protocol_func_map_server[5][23] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_int = np:readInt( ) --技能总战力
        local var_3_int = np:readInt( ) --技能数量
        -- 技能数据--s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 5, 23, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

