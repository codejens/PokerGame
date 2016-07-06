    if ( protocol_func_map_server[174] == nil ) then
        protocol_func_map_server[174] = {}
    end



    --下发恭喜发财玩家数据
    --接收服务器
    protocol_func_map_server[174][3] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --活动天数
        -- 每天的返利数目--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 174, 3, var_1_unsigned_char, var_2_array )--分发数据
    end

    --获取粉钻活动奖励情况
    --接收服务器
    protocol_func_map_server[174][150] = function ( np )
        local var_1_int = np:readInt( ) --当前剩余次数
        local var_2_int = np:readInt( ) --总的开通次数
        local var_3_int = np:readInt( ) --奖励个数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 174, 150, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

    --获取黄钻活动奖励情况
    --接收服务器
    protocol_func_map_server[174][154] = function ( np )
        local var_1_int = np:readInt( ) --当前剩余次数
        local var_2_int = np:readInt( ) --总的开通次数
        local var_3_int = np:readInt( ) --奖励个数
        -- --s本参数存在特殊说明，请查阅协议编辑器
        local var_4_array = {}
        for i = 1, var_3_int do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_4_array, structObj )
        end
        PacketDispatcher:dispather( 174, 154, var_1_int, var_2_int, var_3_int, var_4_array )--分发数据
    end

