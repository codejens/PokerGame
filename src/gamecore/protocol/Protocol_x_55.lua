    if ( protocol_func_map_server[55] == nil ) then
        protocol_func_map_server[55] = {}
    end



    --下发神护的基础数据
    --接收服务器
    protocol_func_map_server[55][3] = function ( np )
        local var_1_string = np:readString( ) --玩家名字
        local var_2_unsigned_char = np:readByte( ) --错误码--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_int = np:readInt( ) --玩家id
        local var_4_unsigned_char = np:readByte( ) --阶数
        local var_5_unsigned_char = np:readByte( ) --星级
        local var_6_int = np:readInt( ) --战力
        local var_7_int = np:readInt( ) --模型id
        local var_8_int = np:readInt( ) --当前祝福值
        local var_9_int = np:readInt( ) --祝福值清空倒计时，单位秒
        local var_10_int = np:readInt( ) --灵丹已使用个数
        local var_11_int = np:readInt( ) --仙丹已使用个数
        -- 8个属性值，是基础值加上进阶属性值--s本参数存在特殊说明，请查阅协议编辑器
        -- protocol manual server 结构体
         local var_12_struct = nil
        --var_12_struct = struct( np )
        PacketDispatcher:dispather( 55, 3, var_1_string, var_2_unsigned_char, var_3_int, var_4_unsigned_char, var_5_unsigned_char, var_6_int, var_7_int, var_8_int, var_9_int, var_10_int, var_11_int, var_12_struct )--分发数据
    end

    --下发神护装备信息
    --接收服务器
    protocol_func_map_server[55][4] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --装备数量
        -- 装备信息数组，类型为标准UserItem结构
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 55, 4, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --下发神护技能信息
    --接收服务器
    protocol_func_map_server[55][5] = function ( np )
        local var_1_int = np:readInt( ) --玩家id
        local var_2_unsigned_char = np:readByte( ) --技能数量
        -- 技能信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_3_array = {}
        for i = 1, var_2_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_3_array, structObj )
        end
        PacketDispatcher:dispather( 55, 5, var_1_int, var_2_unsigned_char, var_3_array )--分发数据
    end

    --学习技能返回
    --接收服务器
    protocol_func_map_server[55][13] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --技能数量
        -- 技能信息数组--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 55, 13, var_1_unsigned_char, var_2_array )--分发数据
    end

    --下发特殊神护信息
    --接收服务器
    protocol_func_map_server[55][17] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --count, 特殊翅膀的数量
        -- 特殊神护信息--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 55, 17, var_1_unsigned_char, var_2_array )--分发数据
    end

