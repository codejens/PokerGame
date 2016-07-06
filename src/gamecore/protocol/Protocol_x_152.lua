    if ( protocol_func_map_server[152] == nil ) then
        protocol_func_map_server[152] = {}
    end



    --下发玩家龙魂数据
    --接收服务器
    protocol_func_map_server[152][1] = function ( np )
        -- 九个龙魂等级，每个值为byte类型，0表示未激活
        -- 数组长度约定，要自己手动填
        local array_length_const = 10
        local var_1_array = {}
        for i = 1, array_length_const do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_1_array, structObj )
        end
        local var_2_unsigned_char = np:readByte( ) --当前幻化成第几个龙魂
        PacketDispatcher:dispather( 152, 1, var_1_array, var_2_unsigned_char )--分发数据
    end

    --下发他人龙魂信息
    --接收服务器
    protocol_func_map_server[152][3] = function ( np )
        local var_1_int = np:readInt( ) --玩家ID
        local var_2_int = np:readInt( ) --玩家模型ID
        local var_3_int = np:readInt( ) --玩家武器
        -- 九个龙魂等级，每个值为byte类型，0表示未激活
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        local var_5_unsigned_char = np:readByte( ) --玩家幻化龙魂ID
        PacketDispatcher:dispather( 152, 3, var_1_int, var_2_int, var_3_int, var_4_array, var_5_unsigned_char )--分发数据
    end

