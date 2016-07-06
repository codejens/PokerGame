    if ( protocol_func_map_server[4] == nil ) then
        protocol_func_map_server[4] = {}
    end



    --初始化数据
    --接收服务器
    protocol_func_map_server[4][4] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --数量
        -- 数据
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 4, 4, var_1_unsigned_char, var_2_array )--分发数据
    end

