    if ( protocol_func_map_server[158] == nil ) then
        protocol_func_map_server[158] = {}
    end



    --下发VIP副本信息
    --接收服务器
    protocol_func_map_server[158][5] = function ( np )
        local var_1_unsigned_char = np:readByte( ) --副本个数
        -- 副本次数情况--s本参数存在特殊说明，请查阅协议编辑器
        local var_2_array = {}
        for i = 1, var_1_unsigned_char do 
            -- protocol manual server 数组
            -- local structObj = struct( np )
            -- table.insert( var_2_array, structObj )
        end
        PacketDispatcher:dispather( 158, 5, var_1_unsigned_char, var_2_array )--分发数据
    end

